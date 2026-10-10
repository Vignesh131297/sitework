import { randomUUID } from 'node:crypto';
import sharp from 'sharp';
import { StockService } from '../src/stock/stock.service.js';
import { createSite, createUser, resetDatabase } from './support/fixtures.js';
import { createTestApp, signInAs, type TestApp } from './support/test-app.js';

const ist = (date: string, time: string) =>
  new Date(`${date}T${time}:00+05:30`);

interface Line {
  material: { id: string; name: string };
  quantity: string;
  receivedQuantity: string | null;
  shortQuantity: string | null;
  rate: string | null;
  amount: string | null;
}

interface Entry {
  id: string;
  kind: string;
  status: string;
  lines: Line[];
  totalAmount: string | null;
  photoCount: number;
  canReceive: boolean;
  canVoid: boolean;
}

type Who = 'admin' | 'arun' | 'prakash' | 'ravi';

/**
 * Two godowns (Main, North) and two teams: Arun runs ABC with Ravi on site;
 * Prakash runs Villa. The admin buys into godowns and sends stock out;
 * engineers confirm, use and move it on; Ravi records ABC's daily usage.
 */
describe('Stock (e2e)', () => {
  let t: TestApp;
  let photo: Buffer;
  const auth = {} as Record<Who, string>;
  const ids = {} as Record<
    Who | 'abc' | 'villa' | 'main' | 'north' | 'cement' | 'sand',
    string
  >;

  beforeAll(async () => {
    t = await createTestApp();
    photo = await sharp({
      create: { width: 800, height: 600, channels: 3, background: '#864' },
    })
      .jpeg()
      .toBuffer();
  });

  afterAll(async () => {
    await t.close();
  });

  beforeEach(async () => {
    await resetDatabase(t.prisma);
    t.clock.set(ist('2026-10-05', '11:00'));
    const admin = await createUser(t.prisma, {
      role: 'ADMIN',
      name: 'Admin',
    });
    const arun = await createUser(t.prisma, {
      role: 'ENGINEER',
      name: 'Arun',
    });
    const prakash = await createUser(t.prisma, {
      role: 'ENGINEER',
      name: 'Prakash',
    });
    const ravi = await createUser(t.prisma, { name: 'Ravi' });
    const abc = await createSite(t.prisma, {
      name: 'ABC',
      createdById: admin.id,
      engineerIds: [arun.id],
      staffIds: [ravi.id],
    });
    const villa = await createSite(t.prisma, {
      name: 'Villa',
      createdById: admin.id,
      engineerIds: [prakash.id],
    });
    for (const [who, user] of Object.entries({ admin, arun, prakash, ravi })) {
      auth[who as Who] = await signInAs(t, user.phone);
      ids[who as Who] = user.id;
    }
    Object.assign(ids, { abc: abc.id, villa: villa.id });
    ids.main = (
      await as('admin').post('/godowns', { name: 'Main' }).expect(201)
    ).body.data.id;
    ids.north = (
      await as('admin').post('/godowns', { name: 'North' }).expect(201)
    ).body.data.id;
    ids.cement = (
      await as('admin')
        .post('/materials', {
          name: 'Cement OPC 53',
          unit: 'bag',
          minStock: '50',
        })
        .expect(201)
    ).body.data.material.id;
    ids.sand = (
      await as('admin')
        .post('/materials', { name: 'M-Sand', unit: 'cft' })
        .expect(201)
    ).body.data.material.id;
  });

  const as = (who: Who) => ({
    get: (url: string) =>
      t.http().get(`/api/v1${url}`).set('authorization', auth[who]),
    post: (url: string, body?: object) =>
      t.http().post(`/api/v1${url}`).set('authorization', auth[who]).send(body),
    patch: (url: string, body?: object) =>
      t
        .http()
        .patch(`/api/v1${url}`)
        .set('authorization', auth[who])
        .send(body),
    /** A multipart form: lines as a JSON field, plus [photos] photos. */
    form: (url: string, fields: Record<string, unknown>, photos = 1) => {
      const request = t
        .http()
        .post(`/api/v1${url}`)
        .set('authorization', auth[who]);
      for (const [name, value] of Object.entries(fields))
        if (value !== undefined)
          request.field(
            name,
            typeof value === 'string' ? value : JSON.stringify(value),
          );
      for (let i = 0; i < photos; i += 1)
        request.attach('photos', photo, {
          filename: `p${i}.jpg`,
          contentType: 'image/jpeg',
        });
      return request;
    },
  });

  const line = (materialId: string, quantity: string) => ({
    materialId,
    quantity,
  });
  const base = (extra: object = {}) => ({
    requestId: randomUUID(),
    movedOn: '2026-10-05',
    ...extra,
  });
  const buy = (
    quantity: string,
    { materialId = ids.cement, godownId = ids.main, rate = '380' } = {},
  ) =>
    as('admin').post(
      '/stock/purchases',
      base({ godownId, lines: [{ materialId, quantity, rate }] }),
    );
  /** A request for the site, approved from [godownId]; returns its id. */
  const approvedRequest = async (
    siteId: string,
    materialId: string,
    quantity: string,
    godownId: string,
  ): Promise<string> => {
    const request = (
      await as('admin')
        .post('/material-requests', {
          requestId: randomUUID(),
          siteId,
          lines: [line(materialId, quantity)],
        })
        .expect(201)
    ).body.data;
    await as('admin')
      .post(`/material-requests/${request.id}/approve`, {
        godownId,
        lines: [{ materialId, approvedQuantity: quantity }],
      })
      .expect(200);
    return request.id as string;
  };
  /**
   * From a godown, with the DC photo. To a site it goes against a request,
   * made and approved first for exactly this much.
   */
  const send = (
    to: { toSiteId?: string; toGodownId?: string },
    quantity: string,
    { from = ids.main, materialId = ids.cement, photos = 1 } = {},
  ) => ({
    expect: async (status: number) => {
      const materialRequestId = to.toSiteId
        ? await approvedRequest(to.toSiteId, materialId, quantity, from)
        : undefined;
      const response = await as('admin').form(
        '/stock/transfers',
        base({
          fromGodownId: from,
          ...to,
          materialRequestId,
          dcNumber: 'DC-1',
          lines: [line(materialId, quantity)],
        }),
        photos,
      );
      if (response.status !== status)
        throw new Error(
          `expected ${status}, got ${response.status}: ${JSON.stringify(response.body)}`,
        );
      return response;
    },
  });
  const receive = (
    who: Who,
    entryId: string,
    received: Record<string, string>,
    { note, photos = 1 }: { note?: string; photos?: number } = {},
  ) =>
    as(who).form(
      `/stock/entries/${entryId}/receive`,
      {
        lines: Object.entries(received).map(
          ([materialId, receivedQuantity]) => ({
            materialId,
            receivedQuantity,
          }),
        ),
        note,
      },
      photos,
    );
  const use = (who: Who, siteId: string, quantity: string, extra = {}) =>
    as(who).post(
      '/stock/usage',
      base({ siteId, lines: [line(ids.cement, quantity)], ...extra }),
    );
  const held = async (path: string, materialId = ids.cement): Promise<string> =>
    (
      (await as('admin').get(path).expect(200)).body.data.items as {
        material: { id: string };
        onHand: string;
      }[]
    ).find((i) => i.material.id === materialId)?.onHand ?? '0';
  const atSite = (siteId: string, materialId?: string) =>
    held(`/sites/${siteId}/stock`, materialId);
  const atGodown = (godownId: string, materialId?: string) =>
    held(`/stock/godowns/${godownId}`, materialId);
  const titles = async (who: Who) =>
    (
      await t.prisma.notification.findMany({
        where: { recipientId: ids[who] },
        orderBy: { createdAt: 'asc' },
      })
    ).map((n) => n.title);

  it('runs the whole flow: buy, send with a DC, confirm short with a photo, use, return', async () => {
    const bought = (await buy('100').expect(201)).body.data as Entry;
    expect(bought).toMatchObject({
      kind: 'PURCHASE',
      status: 'DONE',
      totalAmount: '38000.00',
      lines: [{ quantity: '100', rate: '380.00', amount: '38000.00' }],
    });

    // Sent: the godown drops at once; the site gets it only once confirmed.
    const sent = (await send({ toSiteId: ids.abc }, '60').expect(201)).body
      .data as Entry;
    expect(sent).toMatchObject({
      kind: 'TRANSFER',
      status: 'IN_TRANSIT',
      photoCount: 1,
    });
    expect(await atGodown(ids.main)).toBe('40');
    expect(await atSite(ids.abc)).toBe('0');
    const abc = (await as('arun').get(`/sites/${ids.abc}/stock`).expect(200))
      .body.data;
    expect(abc.arriving).toHaveLength(1);
    expect(abc.arriving[0].canReceive).toBe(true);
    expect(await titles('arun')).toContain('Stock on the way to ABC');

    // Confirming needs a photo, and a note when something is missing.
    const noPhoto = await receive(
      'arun',
      sent.id,
      { [ids.cement]: '60' },
      { photos: 0 },
    ).expect(400);
    expect(noPhoto.body.details[0].field).toBe('photos');
    const noNote = await receive('arun', sent.id, {
      [ids.cement]: '58',
    }).expect(400);
    expect(noNote.body.details[0].field).toBe('note');
    await receive('arun', sent.id, { [ids.cement]: '61' }).expect(400);
    const received = (
      await receive(
        'arun',
        sent.id,
        { [ids.cement]: '58' },
        { note: 'Two bags torn' },
      ).expect(200)
    ).body.data as Entry;
    expect(received).toMatchObject({
      status: 'DONE',
      photoCount: 2,
      lines: [{ receivedQuantity: '58', shortQuantity: '2', rate: null }],
    });
    const again = await receive('arun', sent.id, {
      [ids.cement]: '58',
    }).expect(409);
    expect(again.body.code).toBe('STOCK_ALREADY_RECEIVED');
    expect(await titles('admin')).toContain('Short delivery at ABC');
    const detail = (
      await as('admin').get(`/stock/entries/${sent.id}`).expect(200)
    ).body.data;
    expect(detail.photos.map((p: { stage: string }) => p.stage)).toEqual([
      'SENT',
      'RECEIVED',
    ]);

    // Ravi (site staff) records the day's usage; Arun returns the rest.
    await use('ravi', ids.abc, '40', { note: 'Ground floor slab' }).expect(201);
    const back = (
      await as('arun')
        .post(
          '/stock/transfers',
          base({
            fromSiteId: ids.abc,
            toGodownId: ids.north,
            lines: [line(ids.cement, '18')],
          }),
        )
        .expect(201)
    ).body.data as Entry;
    expect(await atSite(ids.abc)).toBe('0');
    expect(await titles('admin')).toContain('Stock on the way to North');
    const overview = (await as('admin').get('/stock/overview').expect(200)).body
      .data;
    expect(overview.toReceive).toBe(1);
    await receive('admin', back.id, { [ids.cement]: '18' }).expect(200);
    expect(await atGodown(ids.north)).toBe('18');

    // Money is for admins: the site's usage valued at the average price.
    const forAdmin = (
      await as('admin').get(`/sites/${ids.abc}/stock`).expect(200)
    ).body.data;
    expect(forAdmin.value).toEqual({ used: '15200.00', onHand: '0.00' });
    expect(forAdmin.items[0]).toMatchObject({
      received: '58',
      used: '40',
      sentOut: '18',
      onHand: '0',
      usedValue: '15200.00',
    });
    const forEngineer = (
      await as('arun').get(`/sites/${ids.abc}/stock`).expect(200)
    ).body.data;
    expect(forEngineer.value).toBeNull();
    expect(forEngineer.items[0].usedValue).toBeNull();
    const history = (
      await as('arun').get(`/stock/entries?siteId=${ids.abc}`).expect(200)
    ).body.data as Entry[];
    expect(history.map((e) => e.kind)).toEqual([
      'TRANSFER',
      'USAGE',
      'TRANSFER',
    ]);
    expect(history.flatMap((e) => e.lines.map((l) => l.rate))).toEqual([
      null,
      null,
      null,
    ]);
  });

  it('lets engineers return stock to a godown, never straight to another site', async () => {
    await buy('50').expect(201);
    const sent = (await send({ toSiteId: ids.abc }, '30').expect(201)).body
      .data as Entry;
    await receive('arun', sent.id, { [ids.cement]: '30' }).expect(200);

    const toSite = await as('arun')
      .form(
        '/stock/transfers',
        base({
          fromSiteId: ids.abc,
          toSiteId: ids.villa,
          lines: [line(ids.cement, '10')],
        }),
        0,
      )
      .expect(400);
    expect(toSite.body.details[0].field).toBe('toSiteId');

    const back = (
      await as('arun')
        .form(
          '/stock/transfers',
          base({
            fromSiteId: ids.abc,
            toGodownId: ids.north,
            lines: [line(ids.cement, '10')],
          }),
          0,
        )
        .expect(201)
    ).body.data as Entry;
    // North has no manager yet, so the admins hear about it.
    const toAdmin = await t.prisma.notification.findFirst({
      where: { recipientId: ids.admin, title: 'Stock on the way to North' },
    });
    expect(toAdmin?.message).toBe('Cement OPC 53: 10 bag · from ABC by Arun');
    expect(back.canReceive).toBe(false);
    expect(back.canVoid).toBe(true);

    // A site gets stock only against a request; godowns are for admins and
    // their managers to send from, with a DC photo.
    const noRequest = await as('admin')
      .form(
        '/stock/transfers',
        base({
          fromGodownId: ids.main,
          toSiteId: ids.abc,
          lines: [line(ids.cement, '1')],
        }),
      )
      .expect(400);
    expect(noRequest.body.details[0].field).toBe('materialRequestId');
    const fromGodown = await as('arun')
      .form(
        '/stock/transfers',
        base({
          fromGodownId: ids.main,
          toGodownId: ids.north,
          lines: [line(ids.cement, '1')],
        }),
      )
      .expect(403);
    expect(fromGodown.body.code).toBe('FORBIDDEN');
    const noDc = await send({ toSiteId: ids.abc }, '1', { photos: 0 }).expect(
      400,
    );
    expect(noDc.body.details[0].field).toBe('photos');

    // Write-offs by engineers reach admins.
    await as('arun')
      .post(
        '/stock/write-offs',
        base({
          siteId: ids.abc,
          note: 'Set hard in the rain',
          lines: [line(ids.cement, '2')],
        }),
      )
      .expect(201);
    expect(await titles('admin')).toContain('Stock written off at ABC');
  });

  it('keeps staff to recording their own site’s usage', async () => {
    await buy('20').expect(201);
    const sent = (await send({ toSiteId: ids.abc }, '20').expect(201)).body
      .data as Entry;
    await receive('arun', sent.id, { [ids.cement]: '20' }).expect(200);

    const stock = (await as('ravi').get(`/sites/${ids.abc}/stock`).expect(200))
      .body.data;
    expect(stock.usedToday).toBe(false);
    expect(stock.arriving).toEqual([]);
    const used = (await use('ravi', ids.abc, '5').expect(201)).body
      .data as Entry;
    expect(used.canVoid).toBe(true);
    expect(
      (await as('ravi').get(`/sites/${ids.abc}/stock`).expect(200)).body.data
        .usedToday,
    ).toBe(true);

    await as('ravi').get(`/sites/${ids.villa}/stock`).expect(404);
    await use('ravi', ids.villa, '1').expect(404);
    await as('ravi').get('/stock/overview').expect(403);
    await as('ravi')
      .post(
        '/stock/write-offs',
        base({ siteId: ids.abc, note: 'Lost', lines: [line(ids.cement, '1')] }),
      )
      .expect(403);

    // Their own usage, the same day only.
    await as('ravi')
      .post(`/stock/entries/${used.id}/void`, { reason: 'Typed 5, not 3' })
      .expect(200);
    const later = (await use('ravi', ids.abc, '3').expect(201)).body
      .data as Entry;
    t.clock.set(ist('2026-10-06', '09:00'));
    await as('ravi')
      .post(`/stock/entries/${later.id}/void`, { reason: 'Mistake' })
      .expect(403);
    expect(await atSite(ids.abc)).toBe('17');
  });

  it('never lets a place give more than it has', async () => {
    await buy('10').expect(201);
    const tooMuch = await send({ toSiteId: ids.abc }, '10.5').expect(400);
    expect(tooMuch.body).toMatchObject({
      code: 'STOCK_NOT_ENOUGH',
      message: 'Only 10 bag of Cement OPC 53 is at Main.',
      details: [{ field: 'lines.0.quantity' }],
    });
    const none = await use('arun', ids.abc, '1').expect(400);
    expect(none.body.message).toBe('There is no Cement OPC 53 at ABC.');
    const nowhere = await send({ toGodownId: ids.main }, '1').expect(400);
    expect(nowhere.body.details[0].field).toBe('toGodownId');

    const twice = await as('admin')
      .post(
        '/stock/purchases',
        base({
          godownId: ids.main,
          lines: [
            { materialId: ids.cement, quantity: '1', rate: '1' },
            { materialId: ids.cement, quantity: '2', rate: '1' },
          ],
        }),
      )
      .expect(400);
    expect(twice.body.details[0].field).toBe('lines.1.materialId');
    const noRate = await as('admin')
      .post(
        '/stock/purchases',
        base({ godownId: ids.main, lines: [line(ids.cement, '1')] }),
      )
      .expect(400);
    expect(noRate.body.details[0].field).toBe('lines.0.rate');
    const future = await as('admin')
      .post(
        '/stock/purchases',
        base({
          godownId: ids.main,
          movedOn: '2026-10-06',
          lines: [{ materialId: ids.cement, quantity: '1', rate: '1' }],
        }),
      )
      .expect(400);
    expect(future.body.details[0].field).toBe('movedOn');
  });

  it('lets only one of two simultaneous uses take the last stock', async () => {
    await buy('40').expect(201);
    const sent = (await send({ toSiteId: ids.abc }, '40').expect(201)).body
      .data as Entry;
    await receive('arun', sent.id, { [ids.cement]: '40' }).expect(200);
    const results = await Promise.all([
      use('arun', ids.abc, '30'),
      use('ravi', ids.abc, '30'),
      use('arun', ids.abc, '30'),
    ]);
    expect(results.map((r) => r.status).sort()).toEqual([201, 400, 400]);
    expect(await atSite(ids.abc)).toBe('10');
  });

  it('records a form once, however often the phone retries it', async () => {
    const purchase = base({
      godownId: ids.main,
      lines: [
        { materialId: ids.cement, quantity: '25', rate: '380' },
        { materialId: ids.sand, quantity: '100', rate: '52.50' },
      ],
    });
    const first = await as('admin').post('/stock/purchases', purchase);
    const retry = await as('admin').post('/stock/purchases', purchase);
    expect(first.status).toBe(201);
    expect(retry.status).toBe(201);
    expect(retry.body.data.id).toBe(first.body.data.id);
    expect(first.body.data.totalAmount).toBe('14750.00');
    expect(await atGodown(ids.main)).toBe('25');
    expect(await t.prisma.stockEntry.count()).toBe(1);

    // Someone else reusing the id is a mistake, not a retry.
    const taken = await as('arun')
      .post('/stock/usage', {
        requestId: purchase.requestId,
        movedOn: purchase.movedOn,
        siteId: ids.abc,
        lines: [line(ids.cement, '1')],
      })
      .expect(409);
    expect(taken.body.code).toBe('CONFLICT');
  });

  it('cancels entries without ever leaving a place below zero', async () => {
    await buy('100').expect(201);
    const sent = (await send({ toSiteId: ids.abc }, '30').expect(201)).body
      .data as Entry;
    const cancelled = await as('admin')
      .post(`/stock/entries/${sent.id}/void`, { reason: 'Wrong site' })
      .expect(200);
    expect(cancelled.body.data).toMatchObject({
      status: 'VOIDED',
      canVoid: false,
    });
    expect(await atGodown(ids.main)).toBe('100');
    const twice = await as('admin')
      .post(`/stock/entries/${sent.id}/void`, { reason: 'Again' })
      .expect(409);
    expect(twice.body.code).toBe('STOCK_ALREADY_VOIDED');

    const second = (await send({ toSiteId: ids.abc }, '30').expect(201)).body
      .data as Entry;
    await receive('arun', second.id, { [ids.cement]: '30' }).expect(200);
    await use('arun', ids.abc, '10').expect(201);
    const refused = await as('admin')
      .post(`/stock/entries/${second.id}/void`, { reason: 'Mistake' })
      .expect(409);
    expect(refused.body).toMatchObject({
      code: 'STOCK_NOT_ENOUGH',
      message:
        "This can't be cancelled: only 20 bag of Cement OPC 53 is left at ABC.",
    });
    await as('arun')
      .post(`/stock/entries/${second.id}/void`, { reason: 'Not mine' })
      .expect(403);
  });

  it('records the difference a physical count finds', async () => {
    await buy('100').expect(201);
    await buy('20', { materialId: ids.sand, rate: '52' }).expect(201);
    const counted = (
      await as('admin')
        .post(
          '/stock/counts',
          base({
            godownId: ids.main,
            note: 'Monthly count',
            lines: [
              { materialId: ids.cement, countedQuantity: '97' },
              { materialId: ids.sand, countedQuantity: '20' },
            ],
          }),
        )
        .expect(201)
    ).body.data as Entry;
    expect(counted).toMatchObject({
      kind: 'ADJUSTMENT',
      lines: [{ material: { name: 'Cement OPC 53' }, quantity: '3' }],
    });
    expect(await atGodown(ids.main)).toBe('97');

    // A count that matches is kept, with nothing to correct.
    const matching = (
      await as('admin')
        .post(
          '/stock/counts',
          base({
            godownId: ids.main,
            note: 'Spot check',
            lines: [{ materialId: ids.sand, countedQuantity: '20' }],
          }),
        )
        .expect(201)
    ).body.data as Entry;
    expect(matching.lines).toEqual([]);
  });

  it('alerts admins once when all godowns together drop below a minimum', async () => {
    const low = () =>
      t.prisma.notification.findMany({
        where: { recipientId: ids.admin, title: 'Low stock: Cement OPC 53' },
      });
    await buy('60').expect(201);
    await buy('30', { godownId: ids.north }).expect(201); // 90 in godowns
    await send({ toSiteId: ids.abc }, '30').expect(201); // 60
    // Moving stock between godowns is no drop: 20 on its way still counts.
    await send({ toGodownId: ids.main }, '20', { from: ids.north }).expect(201);
    await send({ toSiteId: ids.abc }, '5').expect(201); // 55
    expect(await low()).toHaveLength(0);
    await as('admin')
      .post(
        '/stock/write-offs',
        base({
          godownId: ids.north,
          note: 'Damaged',
          lines: [line(ids.cement, '10')],
        }),
      )
      .expect(201); // 45: below 50
    expect(await low()).toHaveLength(1);
    expect((await low())[0].message).toBe(
      '45 bag left in the godowns (minimum 50 bag)',
    );
    await send({ toSiteId: ids.villa }, '5').expect(201); // 40: still below
    expect(await low()).toHaveLength(1);
    expect(
      (await as('admin').get('/dashboard/admin').expect(200)).body.data.stock,
    ).toEqual({ lowStock: 1, toReceive: 1, requestsToApprove: 0 });
  });

  it('manages materials and godowns: unique names, fixed units, closing only when empty', async () => {
    const same = await as('admin')
      .post('/materials', { name: 'cement opc 53', unit: 'bag' })
      .expect(409);
    expect(same.body.code).toBe('MATERIAL_NAME_IN_USE');
    const godown = await as('admin')
      .post('/godowns', { name: 'main' })
      .expect(409);
    expect(godown.body.code).toBe('GODOWN_NAME_IN_USE');

    await as('admin')
      .patch(`/materials/${ids.sand}`, { unit: 'ton' })
      .expect(200);
    await buy('10', { materialId: ids.sand, rate: '1200' }).expect(201);
    const unit = await as('admin')
      .patch(`/materials/${ids.sand}`, { unit: 'cft' })
      .expect(400);
    expect(unit.body.details[0].field).toBe('unit');
    await as('admin')
      .patch(`/materials/${ids.sand}`, { isActive: false })
      .expect(200);
    const inactive = await buy('1', { materialId: ids.sand }).expect(400);
    expect(inactive.body.code).toBe('MATERIAL_INACTIVE');
    expect(
      (await as('admin').get(`/materials/${ids.sand}`).expect(200)).body.data,
    ).toMatchObject({
      averageRate: '1200.00',
      inGodowns: '10',
      godowns: [{ godown: { name: 'Main' }, onHand: '10' }],
    });

    const full = await as('admin')
      .patch(`/godowns/${ids.main}`, { isActive: false })
      .expect(400);
    expect(full.body.details[0].field).toBe('isActive');
    await as('admin')
      .patch(`/godowns/${ids.north}`, { isActive: false })
      .expect(200);
    const closed = await buy('1', { godownId: ids.north }).expect(400);
    expect(closed.body.code).toBe('GODOWN_INACTIVE');
    const forArun = (await as('arun').get('/stock/overview').expect(200)).body
      .data;
    expect(
      forArun.godowns.map((g: { godown: { name: string } }) => g.godown.name),
    ).toEqual(['Main']);
  });

  it('refuses requests and deliveries for a completed site', async () => {
    await buy('10').expect(201);
    const materialRequestId = await approvedRequest(
      ids.villa,
      ids.cement,
      '1',
      ids.main,
    );
    await t.prisma.site.update({
      where: { id: ids.villa },
      data: { status: 'COMPLETED' },
    });
    const closed = await as('admin')
      .form(
        '/stock/transfers',
        base({
          fromGodownId: ids.main,
          toSiteId: ids.villa,
          materialRequestId,
          lines: [line(ids.cement, '1')],
        }),
      )
      .expect(400);
    expect(closed.body.code).toBe('SITE_CLOSED');
    const request = await as('admin')
      .post('/material-requests', {
        requestId: randomUUID(),
        siteId: ids.villa,
        lines: [line(ids.cement, '1')],
      })
      .expect(400);
    expect(request.body.code).toBe('SITE_CLOSED');
  });

  it('reminds engineers in the evening when a site with stock recorded no usage', async () => {
    await buy('10').expect(201);
    const sent = (await send({ toSiteId: ids.abc }, '10').expect(201)).body
      .data as Entry;
    await receive('arun', sent.id, { [ids.cement]: '10' }).expect(200);
    const stock = t.app.get(StockService);

    expect(await stock.remindUsage(ist('2026-10-05', '18:00'))).toBe(0);
    expect(await stock.remindUsage(ist('2026-10-05', '18:30'))).toBe(1);
    expect(await stock.remindUsage(ist('2026-10-05', '19:00'))).toBe(0);
    expect(await titles('arun')).toContain(
      "Record today's material use at ABC",
    );
    // Recorded the next day: no reminder. Sunday is not a working day.
    t.clock.set(ist('2026-10-06', '12:00'));
    await use('ravi', ids.abc, '1', { movedOn: '2026-10-06' }).expect(201);
    expect(await stock.remindUsage(ist('2026-10-06', '18:45'))).toBe(0);
    expect(await stock.remindUsage(ist('2026-10-11', '18:45'))).toBe(0);
  });

  it('reports each place from opening to closing, valued for admins, as a spreadsheet too', async () => {
    t.clock.set(ist('2026-09-30', '10:00'));
    await as('admin')
      .post(
        '/stock/purchases',
        base({
          godownId: ids.main,
          movedOn: '2026-09-30',
          lines: [{ materialId: ids.cement, quantity: '100', rate: '400' }],
        }),
      )
      .expect(201);
    const materialRequestId = await approvedRequest(
      ids.abc,
      ids.cement,
      '50',
      ids.main,
    );
    const sent = (
      await as('admin')
        .form(
          '/stock/transfers',
          base({
            fromGodownId: ids.main,
            toSiteId: ids.abc,
            movedOn: '2026-09-30',
            materialRequestId,
            lines: [line(ids.cement, '50')],
          }),
        )
        .expect(201)
    ).body.data as Entry;
    // Confirmed the next month: it counts at the site from that day.
    t.clock.set(ist('2026-10-02', '10:00'));
    await receive('arun', sent.id, { [ids.cement]: '50' }).expect(200);
    await use('arun', ids.abc, '12.5', { movedOn: '2026-10-02' }).expect(201);

    const range = 'from=2026-10-01&to=2026-10-31';
    const engineer = (
      await as('arun').get(`/reports/stock?${range}`).expect(200)
    ).body.data;
    expect(engineer).toEqual([
      {
        place: 'SITE',
        site: expect.objectContaining({ name: 'ABC' }),
        godown: null,
        material: expect.objectContaining({ name: 'Cement OPC 53' }),
        opening: '0',
        received: '50',
        used: '12.5',
        sentOut: '0',
        wasted: '0',
        adjusted: '0',
        closing: '37.5',
        usedValue: null,
      },
    ]);
    const admin = (await as('admin').get(`/reports/stock?${range}`).expect(200))
      .body.data;
    expect(admin.map((r: { place: string }) => r.place)).toEqual([
      'GODOWN',
      'SITE',
    ]);
    expect(admin[0]).toMatchObject({ opening: '50', closing: '50' });
    expect(admin[1].usedValue).toBe('5000.00');

    const file = await as('admin')
      .get(`/reports/stock?${range}&format=csv`)
      .expect(200);
    expect(file.headers['content-type']).toContain('text/csv');
    expect(file.text).toContain(
      'Place,Type,Material,Unit,Opening,Received,Used,Sent out,Wasted,Count corrections,Closing,Used value',
    );
    expect(file.text).toContain(
      'ABC,Site,Cement OPC 53,bag,0,50,12.5,0,0,0,37.5,5000.00',
    );
  });
});
