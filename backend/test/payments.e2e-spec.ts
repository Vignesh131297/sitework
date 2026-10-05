import { PaymentsService } from '../src/payments/payments.service.js';
import { createSite, createUser, resetDatabase } from './support/fixtures.js';
import { createTestApp, signInAs, type TestApp } from './support/test-app.js';

// The test site's contract is ₹10,00,000.
describe('Payments (e2e)', () => {
  let t: TestApp;
  let admin: { id: string; phone: string };
  let adminAuth: string;
  let site: { id: string; clientId: string };

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.close();
  });

  beforeEach(async () => {
    await resetDatabase(t.prisma);
    t.clock.set(new Date('2026-10-05T11:00:00+05:30'));
    admin = await createUser(t.prisma, { role: 'ADMIN' });
    adminAuth = await signInAs(t, admin.phone);
    site = await createSite(t.prisma, { name: 'ABC', createdById: admin.id });
  });

  const as = (auth: string) => ({
    get: (url: string) =>
      t.http().get(`/api/v1${url}`).set('authorization', auth),
    post: (url: string, body?: object) =>
      t.http().post(`/api/v1${url}`).set('authorization', auth).send(body),
    patch: (url: string, body?: object) =>
      t.http().patch(`/api/v1${url}`).set('authorization', auth).send(body),
    delete: (url: string) =>
      t.http().delete(`/api/v1${url}`).set('authorization', auth),
  });

  const milestone = (title: string, amount: string, dueDate: string) =>
    as(adminAuth).post(`/sites/${site.id}/milestones`, {
      title,
      amount,
      dueDate,
    });
  const pay = (amount: string, paidOn = '2026-10-01', method = 'UPI') =>
    as(adminAuth).post(`/sites/${site.id}/payments`, {
      amount,
      paidOn,
      method,
      reference: 'UTR123',
    });

  it('schedules milestones within the contract and applies payments oldest first', async () => {
    await milestone('Advance', '200000', '2026-09-01').expect(201);
    await milestone('Foundation', '300000', '2026-09-30').expect(201);
    const over = await milestone('Roof', '600000', '2026-12-01').expect(400);
    expect(over.body.code).toBe('SCHEDULE_EXCEEDS_CONTRACT');

    await pay('250000').expect(201);
    const money = (
      await as(adminAuth).get(`/sites/${site.id}/money`).expect(200)
    ).body.data;
    expect(money.financials).toMatchObject({
      contract: '1000000.00',
      received: '250000.00',
      pending: '750000.00',
      overdue: '250000.00',
      overdueCount: 1,
    });
    expect(
      money.financials.milestones.map(
        (m: { title: string; status: string; paid: string }) => [
          m.title,
          m.status,
          m.paid,
        ],
      ),
    ).toEqual([
      ['Advance', 'PAID', '200000.00'],
      ['Foundation', 'OVERDUE', '50000.00'],
    ]);

    // Editing a milestone keeps to the contract too.
    const foundation = money.financials.milestones[1].id as string;
    const tooBig = await as(adminAuth)
      .patch(`/milestones/${foundation}`, { amount: '900000' })
      .expect(400);
    expect(tooBig.body.code).toBe('SCHEDULE_EXCEEDS_CONTRACT');
    const moved = await as(adminAuth)
      .patch(`/milestones/${foundation}`, { dueDate: '2026-10-31' })
      .expect(200);
    expect(moved.body.data.financials.overdueCount).toBe(0);
    await as(adminAuth).delete(`/milestones/${foundation}`).expect(200);
    expect(
      await t.prisma.auditLog.count({
        where: { action: { startsWith: 'milestone.' } },
      }),
    ).toBe(4);
  });

  it('refuses payments above the contract or in the future; voids instead of deleting', async () => {
    const first = await pay('900000').expect(201);
    expect(first.body.data).toMatchObject({
      amount: '900000.00',
      method: 'UPI',
      site: { name: 'ABC' },
      voidedAt: null,
    });
    const tooMuch = await pay('100000.01').expect(400);
    expect(tooMuch.body).toMatchObject({
      code: 'PAYMENT_EXCEEDS_CONTRACT',
      message: 'This is more than the ₹1,00,000 left on the contract.',
    });
    const future = await pay('1000', '2026-10-06').expect(400);
    expect(future.body.details[0].field).toBe('paidOn');
    expect((await pay('0').expect(400)).body.details[0].field).toBe('amount');

    const id = first.body.data.id as string;
    await as(adminAuth).post(`/payments/${id}/void`, {}).expect(400);
    const voided = await as(adminAuth)
      .post(`/payments/${id}/void`, { reason: 'Entered twice' })
      .expect(200);
    expect(voided.body.data).toMatchObject({
      voidReason: 'Entered twice',
      voidedBy: { id: admin.id },
    });
    expect(
      (
        await as(adminAuth)
          .post(`/payments/${id}/void`, { reason: 'Again' })
          .expect(409)
      ).body.code,
    ).toBe('PAYMENT_ALREADY_VOIDED');

    // A voided payment no longer counts.
    await pay('1000000').expect(201);
    expect(
      (await as(adminAuth).get('/payments').expect(200)).body.meta.total,
    ).toBe(1);
    expect(
      (await as(adminAuth).get('/payments?includeVoided=true').expect(200)).body
        .meta.total,
    ).toBe(2);
  });

  it('summarizes every site, filters payments, and keeps money admin-only', async () => {
    const other = await createSite(t.prisma, {
      name: 'Villa',
      createdById: admin.id,
    });
    await milestone('Advance', '200000', '2026-09-01').expect(201);
    await pay('100000', '2026-09-15', 'CASH').expect(201);
    await as(adminAuth)
      .post(`/sites/${other.id}/payments`, {
        amount: '50000',
        paidOn: '2026-10-02',
        method: 'CHEQUE',
      })
      .expect(201);

    const summary = (await as(adminAuth).get('/payments/summary').expect(200))
      .body.data;
    expect(summary.totals).toMatchObject({
      contract: '2000000.00',
      received: '150000.00',
      overdue: '100000.00',
    });
    expect(
      summary.sites.map((s: { site: { name: string } }) => s.site.name),
    ).toEqual(['ABC', 'Villa']);
    expect(summary.sites[0].nextDue).toMatchObject({
      title: 'Advance',
      outstanding: '100000.00',
    });

    expect(
      (
        await as(adminAuth)
          .get(`/payments?clientId=${site.clientId}`)
          .expect(200)
      ).body.meta.total,
    ).toBe(1);
    expect(
      (await as(adminAuth).get('/payments?method=CHEQUE').expect(200)).body
        .data[0].site.name,
    ).toBe('Villa');
    expect(
      (
        await as(adminAuth)
          .get('/payments?from=2026-10-01&to=2026-10-31')
          .expect(200)
      ).body.meta.total,
    ).toBe(1);

    const engineer = await createUser(t.prisma, { role: 'ENGINEER' });
    const engineerAuth = await signInAs(t, engineer.phone);
    await as(engineerAuth).get('/payments/summary').expect(403);
    await as(engineerAuth).get(`/sites/${site.id}/money`).expect(403);
    await as(engineerAuth)
      .post(`/sites/${site.id}/payments`, {
        amount: '1',
        paidOn: '2026-10-01',
        method: 'CASH',
      })
      .expect(403);
  });

  it('announces each overdue milestone to admins once', async () => {
    await milestone('Advance', '200000', '2026-09-01').expect(201);
    await milestone('Later', '200000', '2026-12-01').expect(201);
    const service = t.app.get(PaymentsService);
    expect(await service.notifyOverdue()).toBe(1);
    expect(await service.notifyOverdue()).toBe(0);
    const alert = await t.prisma.notification.findFirstOrThrow({
      where: { type: 'PAYMENT' },
    });
    expect(alert).toMatchObject({
      recipientId: admin.id,
      title: 'Payment overdue: Advance',
      referenceType: 'PAYMENT_MILESTONE',
    });
  });
});
