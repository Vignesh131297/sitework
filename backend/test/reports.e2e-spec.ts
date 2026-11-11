import { randomUUID } from 'node:crypto';
import { toDbDate } from '../src/common/time/business-time.js';
import { createSite, createUser, resetDatabase } from './support/fixtures.js';
import { createTestApp, signInAs, type TestApp } from './support/test-app.js';

const ist = (date: string, time: string) =>
  new Date(`${date}T${time}:00+05:30`);

describe('Reports (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.close();
  });

  let adminAuth: string;
  let arunAuth: string;
  let site: { id: string };
  let other: { id: string };
  let ravi: { id: string; phone: string };

  beforeEach(async () => {
    await resetDatabase(t.prisma);
    t.clock.set(ist('2026-10-10', '12:00'));
    const admin = await createUser(t.prisma, { role: 'ADMIN' });
    const arun = await createUser(t.prisma, { role: 'ENGINEER', name: 'Arun' });
    const prakash = await createUser(t.prisma, {
      role: 'ENGINEER',
      name: 'Prakash',
    });
    ravi = await createUser(t.prisma, { name: 'Ravi' });
    const kumar = await createUser(t.prisma, { name: 'Kumar' });
    site = await createSite(t.prisma, {
      name: 'ABC',
      createdById: admin.id,
      engineerIds: [arun.id],
      staffIds: [ravi.id],
    });
    other = await createSite(t.prisma, {
      name: 'Villa',
      createdById: admin.id,
      engineerIds: [prakash.id],
      staffIds: [kumar.id],
    });
    adminAuth = await signInAs(t, admin.phone);
    arunAuth = await signInAs(t, arun.phone);

    // Ravi on Mon 5 Oct: present, Morning sent (reviewed 30 min later, sent offline), Afternoon missed.
    const workDate = toDbDate('2026-10-05');
    await t.prisma.attendance.create({
      data: {
        staffId: ravi.id,
        siteId: site.id,
        workDate,
        status: 'PRESENT',
        checkInAt: ist('2026-10-05', '09:00'),
      },
    });
    await t.prisma.attendance.create({
      data: {
        staffId: ravi.id,
        siteId: site.id,
        workDate: toDbDate('2026-10-06'),
        status: 'ABSENT',
      },
    });
    await t.prisma.staffUpdate.create({
      data: {
        clientSubmissionId: randomUUID(),
        staffId: ravi.id,
        siteId: site.id,
        engineerId: arun.id,
        workDate,
        slot: 'MORNING',
        description: 'Brickwork',
        locationFlag: 'OUTSIDE_SITE',
        photoSource: 'CAMERA',
        capturedAt: ist('2026-10-05', '10:30'),
        submittedAt: ist('2026-10-05', '10:30'),
        submittedOffline: true,
        imageKey: 'staff/2026-10-05/photo.jpg',
        imageBytes: 1000,
        imageMime: 'image/jpeg',
        imageExpiresAt: ist('2026-10-06', '10:30'),
        engineerViewedAt: ist('2026-10-05', '11:00'),
      },
    });
    await t.prisma.missedUpdate.create({
      data: {
        staffId: ravi.id,
        siteId: site.id,
        engineerId: arun.id,
        workDate,
        slot: 'AFTERNOON',
      },
    });
    await t.prisma.engineerUpdate.create({
      data: {
        engineerId: arun.id,
        siteId: site.id,
        type: 'REMARK',
        description: 'Note',
        createdAt: ist('2026-10-05', '17:00'),
      },
    });
    await t.prisma.issue.create({
      data: {
        siteId: site.id,
        reportedById: arun.id,
        title: 'Crack',
        description: 'Wall',
        createdAt: ist('2026-10-07', '10:00'),
      },
    });
    await t.prisma.payment.create({
      data: {
        siteId: site.id,
        amount: 100000,
        paidOn: toDbDate('2026-10-08'),
        method: 'CASH',
        recordedById: admin.id,
      },
    });
    await t.prisma.payment.create({
      data: {
        siteId: other.id,
        amount: 50000,
        paidOn: toDbDate('2026-09-01'),
        method: 'UPI',
        recordedById: admin.id,
      },
    });
  });

  const get = (auth: string, url: string) =>
    t.http().get(`/api/v1${url}`).set('authorization', auth);
  const WEEK = 'from=2026-10-05&to=2026-10-11';

  it('summarizes each site over the range; engineers see only theirs, without money', async () => {
    const rows = (await get(adminAuth, `/reports/sites?${WEEK}`).expect(200))
      .body.data;
    const abc = rows.find(
      (r: { site: { name: string } }) => r.site.name === 'ABC',
    );
    expect(abc).toMatchObject({
      updates: {
        submitted: 1,
        missed: 1,
        offline: 1,
        locationFlagged: 1,
        compliancePercent: 50,
      },
      attendance: { present: 1, late: 0, halfDay: 0, absent: 1, onLeave: 0 },
      engineerUpdates: 1,
      issues: { opened: 1, resolved: 0, openNow: 1 },
      received: '100000.00',
    });
    expect(
      rows.find((r: { site: { name: string } }) => r.site.name === 'Villa')
        .received,
    ).toBe('0.00');

    const mine = (await get(arunAuth, `/reports/sites?${WEEK}`).expect(200))
      .body.data;
    expect(mine.map((r: { site: { name: string } }) => r.site.name)).toEqual([
      'ABC',
    ]);
    expect(mine[0].received).toBeNull();
  });

  it('summarizes each staff member, scoped for engineers', async () => {
    const rows = (await get(adminAuth, `/reports/staff?${WEEK}`).expect(200))
      .body.data;
    expect(rows.map((r: { staff: { name: string } }) => r.staff.name)).toEqual([
      'Kumar',
      'Ravi',
    ]);
    expect(rows[1]).toMatchObject({
      site: { id: site.id },
      attendance: { present: 1, absent: 1 },
      updates: { submitted: 1, missed: 1, compliancePercent: 50 },
    });
    expect(rows[0].updates.compliancePercent).toBeNull();
    const mine = (await get(arunAuth, `/reports/staff?${WEEK}`).expect(200))
      .body.data;
    expect(mine.map((r: { staff: { name: string } }) => r.staff.name)).toEqual([
      'Ravi',
    ]);
  });

  it('reports engineers and payments to admins only', async () => {
    const engineers = (
      await get(adminAuth, `/reports/engineers?${WEEK}`).expect(200)
    ).body.data;
    expect(
      engineers.find(
        (e: { engineer: { name: string } }) => e.engineer.name === 'Arun',
      ),
    ).toMatchObject({
      sites: 1,
      engineerUpdates: 1,
      issues: { reported: 1, resolved: 0 },
      reviews: {
        photos: 1,
        reviewed: 1,
        reviewRatePercent: 100,
        averageMinutes: 30,
      },
    });

    const payments = (
      await get(adminAuth, `/reports/payments?${WEEK}`).expect(200)
    ).body.data;
    expect(payments.totals).toEqual({
      received: '100000.00',
      count: 1,
      byMethod: { CASH: '100000.00' },
    });
    expect(
      payments.sites.find(
        (s: { site: { name: string } }) => s.site.name === 'Villa',
      ),
    ).toMatchObject({
      receivedInRange: '0.00',
      receivedToDate: '50000.00',
    });

    await get(arunAuth, `/reports/engineers?${WEEK}`).expect(403);
    await get(arunAuth, `/reports/payments?${WEEK}`).expect(403);
    await get(await signInAs(t, ravi.phone), `/reports/sites?${WEEK}`).expect(
      403,
    );
  });

  it('exports CSV and checks the range', async () => {
    const csv = await get(
      adminAuth,
      `/reports/staff?${WEEK}&format=csv`,
    ).expect(200);
    expect(csv.headers['content-type']).toBe('text/csv; charset=utf-8');
    expect(csv.headers['content-disposition']).toBe(
      'attachment; filename="staff-2026-10-05-to-2026-10-11.csv"',
    );
    expect(csv.text.charCodeAt(0)).toBe(0xfeff);
    const lines = csv.text.slice(1).trim().split('\r\n');
    expect(lines[0]).toMatch(/^Employee ID,Name,Designation,/);
    expect(lines).toHaveLength(3);

    expect(
      (
        await get(
          adminAuth,
          '/reports/sites?from=2026-10-11&to=2026-10-05',
        ).expect(400)
      ).body.details[0].field,
    ).toBe('from');
    expect(
      (
        await get(
          adminAuth,
          '/reports/sites?from=2025-01-01&to=2026-10-05',
        ).expect(400)
      ).body.details[0].field,
    ).toBe('to');
    await get(adminAuth, '/reports/sites?from=2026-10-05').expect(400);
  });
});
