import { randomUUID } from 'node:crypto';
import sharp from 'sharp';
import { createSite, createUser, resetDatabase } from './support/fixtures.js';
import { createTestApp, signInAs, type TestApp } from './support/test-app.js';

const ist = (date: string, time: string) =>
  new Date(`${date}T${time}:00+05:30`);

interface RequestLine {
  material: { id: string; name: string };
  quantity: string;
  approvedQuantity: string | null;
  sent: string;
  received: string;
  onTheWay: string;
  leftToSend: string | null;
}

interface MaterialRequest {
  id: string;
  code: string;
  status: string;
  outcome: string | null;
  godown: { id: string; name: string } | null;
  lines: RequestLine[];
  sentInFull: boolean;
  entries?: { id: string; kind: string; status: string }[];
  canApprove: boolean;
  canCancel: boolean;
  canSend: boolean;
  canClose: boolean;
}

type Who = 'admin' | 'arun' | 'prakash' | 'mani' | 'selvi';

/**
 * Arun runs ABC and Prakash runs Villa. Mani manages the Main godown and Selvi
 * the North one. Arun asks for material, the admin approves it from Main, Mani
 * sends it, Arun confirms, uses it and closes the request, returning what is
 * left to Main.
 */
describe('Material requests and godown managers (e2e)', () => {
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
      create: { width: 800, height: 600, channels: 3, background: '#468' },
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
    const people = {
      admin: await createUser(t.prisma, { role: 'ADMIN', name: 'Admin' }),
      arun: await createUser(t.prisma, { role: 'ENGINEER', name: 'Arun' }),
      prakash: await createUser(t.prisma, {
        role: 'ENGINEER',
        name: 'Prakash',
      }),
      mani: await createUser(t.prisma, {
        role: 'GODOWN_MANAGER',
        name: 'Mani',
      }),
      selvi: await createUser(t.prisma, {
        role: 'GODOWN_MANAGER',
        name: 'Selvi',
      }),
    };
    for (const [who, user] of Object.entries(people)) {
      auth[who as Who] = await signInAs(t, user.phone);
      ids[who as Who] = user.id;
    }
    ids.abc = (
      await createSite(t.prisma, {
        name: 'ABC',
        createdById: ids.admin,
        engineerIds: [ids.arun],
      })
    ).id;
    ids.villa = (
      await createSite(t.prisma, {
        name: 'Villa',
        createdById: ids.admin,
        engineerIds: [ids.prakash],
      })
    ).id;
    ids.main = (
      await as('admin').post('/godowns', { name: 'Main' }).expect(201)
    ).body.data.id;
    ids.north = (
      await as('admin').post('/godowns', { name: 'North' }).expect(201)
    ).body.data.id;
    await t.prisma.godownAssignment.createMany({
      data: [
        { godownId: ids.main, userId: ids.mani, assignedById: ids.admin },
        { godownId: ids.north, userId: ids.selvi, assignedById: ids.admin },
      ],
    });
    ids.cement = (
      await as('admin')
        .post('/materials', { name: 'Cement OPC 53', unit: 'bag' })
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
    who: Who,
    quantity: string,
    { materialId = ids.cement, godownId = ids.main, rate = '380' } = {},
  ) =>
    as(who).post(
      '/stock/purchases',
      base({ godownId, lines: [{ materialId, quantity, rate }] }),
    );
  const ask = (who: Who, siteId: string, lines: object[], extra = {}) =>
    as(who).post('/material-requests', {
      requestId: randomUUID(),
      siteId,
      lines,
      ...extra,
    });
  const approve = (
    id: string,
    approved: Record<string, string>,
    godownId = ids.main,
  ) =>
    as('admin').post(`/material-requests/${id}/approve`, {
      godownId,
      lines: Object.entries(approved).map(([materialId, approvedQuantity]) => ({
        materialId,
        approvedQuantity,
      })),
    });
  const sendFor = (
    who: Who,
    requestId: string,
    quantity: string,
    { from = ids.main, to = ids.abc, materialId = ids.cement } = {},
  ) =>
    as(who).form(
      '/stock/transfers',
      base({
        fromGodownId: from,
        toSiteId: to,
        materialRequestId: requestId,
        dcNumber: 'DC-7',
        lines: [line(materialId, quantity)],
      }),
    );
  const receive = (who: Who, entryId: string, quantity: string) =>
    as(who).form(`/stock/entries/${entryId}/receive`, {
      lines: [{ materialId: ids.cement, receivedQuantity: quantity }],
    });
  const view = async (who: Who, id: string): Promise<MaterialRequest> =>
    (await as(who).get(`/material-requests/${id}`).expect(200)).body.data;
  const titles = async (who: Who) =>
    (
      await t.prisma.notification.findMany({
        where: { recipientId: ids[who] },
        orderBy: { createdAt: 'asc' },
      })
    ).map((n) => n.title);
  const atGodown = async (godownId: string): Promise<string> =>
    (
      (await as('admin').get(`/stock/godowns/${godownId}`).expect(200)).body
        .data.items as { material: { id: string }; onHand: string }[]
    ).find((i) => i.material.id === ids.cement)?.onHand ?? '0';

  it('runs a request from asking to closing: approve, send in parts, confirm, return the leftover', async () => {
    await buy('mani', '120').expect(201);

    const asked = (
      await ask(
        'arun',
        ids.abc,
        [line(ids.cement, '100'), line(ids.sand, '50')],
        { neededBy: '2026-10-07', note: 'Second floor slab' },
      ).expect(201)
    ).body.data as MaterialRequest;
    expect(asked).toMatchObject({
      status: 'PENDING',
      godown: null,
      canApprove: false,
      canCancel: true,
      canSend: false,
      canClose: false,
    });
    expect(asked.code).toMatch(/^MR-\d{4}$/);
    expect(await titles('admin')).toEqual([
      `${asked.code}: material request from ABC`,
    ]);
    // Other sites and the godowns don't see it until it is approved.
    await as('prakash').get(`/material-requests/${asked.id}`).expect(404);
    await as('mani').get(`/material-requests/${asked.id}`).expect(404);
    expect(
      (await as('admin').get('/dashboard/admin').expect(200)).body.data.stock
        .requestsToApprove,
    ).toBe(1);
    expect(
      (await as('arun').get('/dashboard/engineer').expect(200)).body.data.stock,
    ).toEqual({ toReceive: 0, openRequests: 1 });

    // Approved from Main: 80 bags of cement, no sand.
    const approved = (
      await approve(asked.id, { [ids.cement]: '80', [ids.sand]: '0' }).expect(
        200,
      )
    ).body.data as MaterialRequest;
    expect(approved).toMatchObject({
      status: 'APPROVED',
      godown: { name: 'Main' },
      canApprove: false,
      canSend: true,
    });
    expect(
      approved.lines.map((l) => [l.material.name, l.approvedQuantity]),
    ).toEqual([
      ['Cement OPC 53', '80'],
      ['M-Sand', '0'],
    ]);
    expect(await titles('arun')).toEqual([`${asked.code} approved`]);
    expect(await titles('mani')).toEqual([`Send ${asked.code} to ABC`]);
    const again = await approve(asked.id, { [ids.cement]: '1' }).expect(409);
    expect(again.body.code).toBe('REQUEST_NOT_OPEN');
    expect((await view('mani', asked.id)).canSend).toBe(true);
    await as('selvi').get(`/material-requests/${asked.id}`).expect(404);
    expect(
      (await as('mani').get('/dashboard/godown').expect(200)).body.data,
    ).toMatchObject({ toSend: 1, toReceive: 0 });

    // Only Main's manager sends it, from Main, to ABC, within what's approved.
    await sendFor('selvi', asked.id, '10').expect(403);
    const wrongSite = await sendFor('mani', asked.id, '10', {
      to: ids.villa,
    }).expect(400);
    expect(wrongSite.body.details[0].field).toBe('materialRequestId');
    const noSand = await sendFor('mani', asked.id, '1', {
      materialId: ids.sand,
    }).expect(400);
    expect(noSand.body.code).toBe('REQUEST_EXCEEDED');
    const first = (await sendFor('mani', asked.id, '50').expect(201)).body.data;
    expect(first).toMatchObject({
      status: 'IN_TRANSIT',
      request: { id: asked.id, code: asked.code },
    });
    const tooMuch = await sendFor('mani', asked.id, '31').expect(400);
    expect(tooMuch.body).toMatchObject({
      code: 'REQUEST_EXCEEDED',
      message: `Only 30 bag of Cement OPC 53 is left to send on ${asked.code}.`,
      details: [{ field: 'lines.0.quantity' }],
    });
    let progress = await view('arun', asked.id);
    expect(progress.lines[0]).toMatchObject({
      sent: '50',
      onTheWay: '50',
      received: '0',
      leftToSend: '30',
    });
    // Nothing closes while a delivery is on its way.
    expect(progress.canClose).toBe(false);
    const early = await as('arun')
      .post(`/material-requests/${asked.id}/close`, { outcome: 'ALL_USED' })
      .expect(409);
    expect(early.body.code).toBe('REQUEST_NOT_OPEN');

    await receive('arun', first.id, '50').expect(200);
    const rest = (await sendFor('mani', asked.id, '30').expect(201)).body.data;
    await receive('arun', rest.id, '30').expect(200);
    progress = await view('arun', asked.id);
    expect(progress).toMatchObject({ sentInFull: true, canClose: true });
    expect((await view('mani', asked.id)).canSend).toBe(false);
    expect(
      (await as('mani').get('/dashboard/godown').expect(200)).body.data.toSend,
    ).toBe(0);
    expect(await atGodown(ids.main)).toBe('40');

    // 70 used; the 10 left go back to Main with the close.
    await as('arun')
      .post(
        '/stock/usage',
        base({ siteId: ids.abc, lines: [line(ids.cement, '70')] }),
      )
      .expect(201);
    const close = {
      outcome: 'LEFTOVER_RETURNED',
      note: 'Slab done',
      returnRequestId: randomUUID(),
      lines: [line(ids.cement, '10')],
    };
    const tooBig = await as('arun')
      .post(`/material-requests/${asked.id}/close`, {
        ...close,
        returnRequestId: randomUUID(),
        lines: [line(ids.cement, '11')],
      })
      .expect(400);
    expect(tooBig.body.code).toBe('STOCK_NOT_ENOUGH');
    expect((await view('arun', asked.id)).status).toBe('APPROVED');
    const closed = (
      await as('arun')
        .post(`/material-requests/${asked.id}/close`, close)
        .expect(200)
    ).body.data as MaterialRequest;
    expect(closed).toMatchObject({
      status: 'CLOSED',
      outcome: 'LEFTOVER_RETURNED',
      canClose: false,
    });
    expect(closed.entries!.map((e) => [e.kind, e.status])).toEqual([
      ['TRANSFER', 'DONE'],
      ['TRANSFER', 'DONE'],
      ['TRANSFER', 'IN_TRANSIT'],
    ]);
    // A retry gets the same answer; nothing is returned twice.
    await as('arun')
      .post(`/material-requests/${asked.id}/close`, close)
      .expect(200);
    expect(
      await t.prisma.stockEntry.count({
        where: { materialRequestId: asked.id },
      }),
    ).toBe(3);
    expect(await titles('admin')).toContain(`${asked.code} closed at ABC`);
    expect(await titles('mani')).toContain(`${asked.code} closed at ABC`);
    expect(await titles('mani')).toContain('Stock on the way to Main');
    const twice = await as('admin')
      .post(`/material-requests/${asked.id}/close`, { outcome: 'ALL_USED' })
      .expect(409);
    expect(twice.body.code).toBe('REQUEST_NOT_OPEN');

    // Main's manager confirms the return.
    expect(
      (await as('mani').get('/dashboard/godown').expect(200)).body.data
        .toReceive,
    ).toBe(1);
    const back = closed.entries![2];
    await receive('selvi', back.id, '10').expect(404);
    await receive('mani', back.id, '10').expect(200);
    expect(await atGodown(ids.main)).toBe('50');
    expect(
      (await as('arun').get('/dashboard/engineer').expect(200)).body.data.stock,
    ).toEqual({ toReceive: 0, openRequests: 0 });
  });

  it('keeps godown managers to their own godowns, with prices only on their own purchases', async () => {
    const own = (await buy('mani', '20').expect(201)).body.data;
    expect(own.lines[0]).toMatchObject({ rate: '380.00', amount: '7600.00' });
    const elsewhere = await buy('mani', '5', { godownId: ids.north }).expect(
      403,
    );
    expect(elsewhere.body.code).toBe('FORBIDDEN');
    const admins = (await buy('admin', '10', { rate: '400' }).expect(201)).body
      .data;
    await buy('selvi', '7', { godownId: ids.north }).expect(201);

    const seen = (
      await as('mani').get(`/stock/entries/${admins.id}`).expect(200)
    ).body.data;
    expect(seen.lines[0]).toMatchObject({ rate: null, amount: null });
    expect(seen.totalAmount).toBeNull();
    const list = (await as('mani').get('/stock/entries').expect(200)).body
      .data as { id: string }[];
    expect(list.map((e) => e.id).sort()).toEqual([own.id, admins.id].sort());

    const overview = (await as('mani').get('/stock/overview').expect(200)).body
      .data;
    expect(
      overview.godowns.map((g: { godown: { name: string } }) => g.godown.name),
    ).toEqual(['Main']);
    expect(overview.sites).toEqual([]);
    await as('mani').get(`/stock/godowns/${ids.north}`).expect(404);
    const main = (
      await as('mani').get(`/stock/godowns/${ids.main}`).expect(200)
    ).body.data;
    expect(main.managers.map((m: { name: string }) => m.name)).toEqual([
      'Mani',
    ]);

    // New materials any time; counts and write-offs at their godown only.
    await as('mani')
      .post('/materials', { name: 'Binding wire', unit: 'kg' })
      .expect(201);
    await as('mani')
      .post(
        '/stock/counts',
        base({
          godownId: ids.main,
          note: 'Weekly count',
          lines: [{ materialId: ids.cement, countedQuantity: '29' }],
        }),
      )
      .expect(201);
    await as('mani')
      .post(
        '/stock/counts',
        base({
          godownId: ids.north,
          note: 'Weekly count',
          lines: [{ materialId: ids.cement, countedQuantity: '7' }],
        }),
      )
      .expect(403);
    await as('mani')
      .post(
        '/stock/write-offs',
        base({
          godownId: ids.main,
          note: 'Bags got wet',
          lines: [line(ids.cement, '2')],
        }),
      )
      .expect(201);
    expect(await titles('admin')).toContain('Stock written off at Main');
    expect(await atGodown(ids.main)).toBe('27');

    // Godowns move stock between themselves; the other manager confirms.
    const moved = (
      await as('mani')
        .form(
          '/stock/transfers',
          base({
            fromGodownId: ids.main,
            toGodownId: ids.north,
            dcNumber: 'DC-9',
            lines: [line(ids.cement, '5')],
          }),
        )
        .expect(201)
    ).body.data;
    expect(await titles('selvi')).toEqual(['Stock on the way to North']);
    expect(moved.canReceive).toBe(false);
    await receive('mani', moved.id, '5').expect(403);
    await receive('selvi', moved.id, '5').expect(200);
    expect(await atGodown(ids.north)).toBe('12');

    // Sites aren't theirs: no requests to make or approve, no site stock.
    await ask('mani', ids.abc, [line(ids.cement, '1')]).expect(403);
    await as('mani').get(`/sites/${ids.abc}/stock`).expect(403);
    const forSite = await as('mani')
      .form(
        '/stock/transfers',
        base({
          fromGodownId: ids.main,
          toSiteId: ids.abc,
          lines: [line(ids.cement, '1')],
        }),
      )
      .expect(400);
    expect(forSite.body.details[0].field).toBe('materialRequestId');
  });

  it('lets admins reject requests and the site withdraw them', async () => {
    const first = (
      await ask('arun', ids.abc, [line(ids.cement, '10')]).expect(201)
    ).body.data as MaterialRequest;
    await as('arun')
      .post(`/material-requests/${first.id}/approve`, {
        godownId: ids.main,
        lines: [{ materialId: ids.cement, approvedQuantity: '10' }],
      })
      .expect(403);
    const short = await as('admin')
      .post(`/material-requests/${first.id}/reject`, { reason: 'No' })
      .expect(400);
    expect(short.body.details[0].field).toBe('reason');
    const rejected = (
      await as('admin')
        .post(`/material-requests/${first.id}/reject`, {
          reason: 'Use the stock already at the site',
        })
        .expect(200)
    ).body.data as MaterialRequest;
    expect(rejected).toMatchObject({ status: 'REJECTED', canCancel: false });
    const notice = await t.prisma.notification.findFirst({
      where: { recipientId: ids.arun },
    });
    expect(notice).toMatchObject({
      title: `${first.code} rejected`,
      message: 'Use the stock already at the site',
    });
    await approve(first.id, { [ids.cement]: '10' }).expect(409);
    await as('arun').post(`/material-requests/${first.id}/cancel`).expect(409);

    // Approving needs every line, and at least something to send.
    const second = (
      await ask('arun', ids.abc, [
        line(ids.cement, '10'),
        line(ids.sand, '5'),
      ]).expect(201)
    ).body.data as MaterialRequest;
    const missing = await approve(second.id, { [ids.cement]: '10' }).expect(
      400,
    );
    expect(missing.body.details[0].field).toBe('lines');
    const nothing = await approve(second.id, {
      [ids.cement]: '0',
      [ids.sand]: '0',
    }).expect(400);
    expect(nothing.body.message).toBe(
      'Approve at least one material, or reject the request.',
    );
    await as('prakash')
      .post(`/material-requests/${second.id}/cancel`)
      .expect(404);
    const cancelled = (
      await as('arun')
        .post(`/material-requests/${second.id}/cancel`)
        .expect(200)
    ).body.data as MaterialRequest;
    expect(cancelled.status).toBe('CANCELLED');

    // Engineers ask only for their own sites; a retry makes no second request.
    await ask('arun', ids.villa, [line(ids.cement, '1')]).expect(404);
    const sites = (await as('arun').get('/stock/overview').expect(200)).body
      .data.sites as { name: string }[];
    expect(sites.map((s) => s.name)).toEqual(['ABC']);
    const body = {
      requestId: randomUUID(),
      siteId: ids.abc,
      lines: [line(ids.cement, '3')],
    };
    const once = await as('arun').post('/material-requests', body).expect(201);
    const retry = await as('arun').post('/material-requests', body).expect(201);
    expect(retry.body.data.id).toBe(once.body.data.id);
    const open = (
      await as('arun').get('/material-requests?open=true').expect(200)
    ).body.data as MaterialRequest[];
    expect(open.map((r) => r.id)).toEqual([once.body.data.id]);
    const past = await ask('arun', ids.abc, [line(ids.cement, '1')], {
      neededBy: '2026-10-04',
    }).expect(400);
    expect(past.body.details[0].field).toBe('neededBy');
  });

  it('lets admins add godown managers and other admins', async () => {
    const created = (
      await as('admin')
        .post('/godown-managers', {
          name: 'Kannan',
          phone: '9876500011',
          godownIds: [ids.main],
        })
        .expect(201)
    ).body.data;
    expect(created.temporaryPassword).toEqual(expect.any(String));
    expect(created.person).toMatchObject({
      name: 'Kannan',
      godowns: [{ name: 'Main' }],
    });
    expect(created.person.employeeCode).toMatch(/^GDM-/);
    await as('arun')
      .post('/godown-managers', { name: 'Raja', phone: '9876500012' })
      .expect(403);

    const moved = (
      await as('admin')
        .patch(`/godown-managers/${created.person.id}`, {
          godownIds: [ids.north],
        })
        .expect(200)
    ).body.data;
    expect(moved.godowns).toEqual([{ id: ids.north, name: 'North' }]);
    const off = (
      await as('admin')
        .patch(`/godown-managers/${created.person.id}/status`, {
          isActive: false,
        })
        .expect(200)
    ).body.data;
    expect(off.godowns).toEqual([]);

    const admin = (
      await as('admin')
        .post('/admins', { name: 'Second Admin', phone: '9876500013' })
        .expect(201)
    ).body.data;
    expect(admin.person.employeeCode).toMatch(/^ADM-/);
    const self = await as('admin')
      .patch(`/admins/${ids.admin}/status`, { isActive: false })
      .expect(400);
    expect(self.body.message).toBe("You can't deactivate your own account.");
    await as('admin')
      .patch(`/admins/${admin.person.id}/status`, { isActive: false })
      .expect(200);
    const list = (await as('admin').get('/admins').expect(200)).body.data as {
      name: string;
    }[];
    expect(list.map((a) => a.name).sort()).toEqual(['Admin', 'Second Admin']);
  });

  it('lets only the first admin sign up', async () => {
    await resetDatabase(t.prisma);
    const signup = () => t.http().get('/api/v1/auth/signup').expect(200);
    expect((await signup()).body.data).toEqual({ open: true });

    const account = {
      name: 'Owner',
      phone: '9876500099',
      password: 'Owner@2026',
    };
    const weak = await t
      .http()
      .post('/api/v1/auth/signup')
      .send({ ...account, password: 'short' })
      .expect(400);
    expect(weak.body.code).toBe('WEAK_PASSWORD');
    const session = (
      await t.http().post('/api/v1/auth/signup').send(account).expect(201)
    ).body.data;
    const me = (
      await t
        .http()
        .get('/api/v1/me')
        .set('authorization', `Bearer ${session.accessToken}`)
        .expect(200)
    ).body.data;
    expect(me).toMatchObject({ name: 'Owner', role: 'ADMIN' });

    expect((await signup()).body.data).toEqual({ open: false });
    const closed = await t
      .http()
      .post('/api/v1/auth/signup')
      .send({ ...account, phone: '9876500098' })
      .expect(403);
    expect(closed.body.code).toBe('SIGNUP_CLOSED');
  });
});
