import { randomUUID } from 'node:crypto';
import { AttendanceService } from '../src/attendance/attendance.service.js';
import { toDbDate } from '../src/common/time/business-time.js';
import { MissedUpdatesService } from '../src/staff-updates/missed-updates.service.js';
import { createSite, createUser, resetDatabase } from './support/fixtures.js';
import { createTestApp, signInAs, type TestApp } from './support/test-app.js';

// Monday 5 Oct 2026, India Standard Time. Working days are Monday to Saturday.
const DAY = '2026-10-05';
const ist = (time: string, date = DAY) => new Date(`${date}T${time}:00+05:30`);
const ON_SITE = { latitude: 13.0879, longitude: 80.2009, accuracyM: 12 };

type Who = 'admin' | 'arun' | 'prakash' | 'ravi' | 'selvam';

/**
 * Arun is the engineer at ABC, where Ravi works. Prakash is the engineer at
 * Villa, where Selvam works. Staff ask for leave, money and food; the engineer
 * on their site or an admin decides. Engineers' leave is for admins only.
 */
describe('Leave and labour requests (e2e)', () => {
  let t: TestApp;
  const auth = {} as Record<Who, string>;
  const ids = {} as Record<Who | 'abc' | 'villa', string>;

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.close();
  });

  beforeEach(async () => {
    await resetDatabase(t.prisma);
    t.clock.set(ist('09:30'));
    const people = {
      admin: await createUser(t.prisma, { role: 'ADMIN', name: 'Admin' }),
      arun: await createUser(t.prisma, { role: 'ENGINEER', name: 'Arun' }),
      prakash: await createUser(t.prisma, {
        role: 'ENGINEER',
        name: 'Prakash',
      }),
      ravi: await createUser(t.prisma, { name: 'Ravi' }),
      selvam: await createUser(t.prisma, { name: 'Selvam' }),
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
        staffIds: [ids.ravi],
      })
    ).id;
    ids.villa = (
      await createSite(t.prisma, {
        name: 'Villa',
        createdById: ids.admin,
        engineerIds: [ids.prakash],
        staffIds: [ids.selvam],
      })
    ).id;
  });

  const as = (who: Who) => ({
    get: (url: string) =>
      t.http().get(`/api/v1${url}`).set('authorization', auth[who]),
    post: (url: string, body?: object) =>
      t.http().post(`/api/v1${url}`).set('authorization', auth[who]).send(body),
  });

  const askLeave = (who: Who, body: object) =>
    as(who).post('/leave-requests', {
      requestId: randomUUID(),
      type: 'SICK',
      reason: 'Fever',
      ...body,
    });

  const ask = (body: object) =>
    as('ravi').post('/staff-requests', { requestId: randomUUID(), ...body });

  const notified = (type: 'LEAVE' | 'STAFF_REQUEST', referenceId: string) =>
    t.prisma.notification.findMany({
      where: { type, referenceId },
      orderBy: { createdAt: 'asc' },
    });

  const attendanceOn = (date: string) =>
    t.prisma.attendance.findUnique({
      where: {
        staffId_workDate: { staffId: ids.ravi, workDate: toDbDate(date) },
      },
    });

  describe('staff leave', () => {
    it('is decided by an engineer on the site and shows as leave in attendance', async () => {
      // Saturday: Ravi didn't come and was marked absent that evening.
      const attendance = t.app.get(AttendanceService);
      expect(await attendance.markAbsentees('2026-10-03')).toBe(2);

      const created = (
        await askLeave('ravi', {
          fromDate: '2026-10-03',
          toDate: '2026-10-06',
          reason: 'Fever since Saturday',
        }).expect(201)
      ).body.data;
      expect(created).toMatchObject({
        code: expect.stringMatching(/^LV-\d{4}$/),
        user: { id: ids.ravi, role: 'STAFF' },
        site: { id: ids.abc, name: 'ABC' },
        type: 'SICK',
        fromDate: '2026-10-03',
        toDate: '2026-10-06',
        days: 4,
        status: 'PENDING',
        canApprove: false,
        canCancel: true,
      });
      const alerts = await notified('LEAVE', created.id);
      expect(alerts.map((n) => n.recipientId).sort()).toEqual(
        [ids.admin, ids.arun].sort(),
      );
      expect(alerts[0].title).toBe('Ravi asked for sick leave');

      // Another site's engineer can't see it; staff can't decide.
      await as('prakash').get(`/leave-requests/${created.id}`).expect(404);
      await as('prakash')
        .post(`/leave-requests/${created.id}/approve`, {})
        .expect(404);
      await as('ravi')
        .post(`/leave-requests/${created.id}/approve`, {})
        .expect(403);

      const queue = (
        await as('arun').get('/leave-requests?toReview=true').expect(200)
      ).body;
      expect(queue.data.map((r: { id: string }) => r.id)).toEqual([created.id]);
      expect(queue.data[0].canApprove).toBe(true);
      expect(
        (await as('prakash').get('/leave-requests?toReview=true').expect(200))
          .body.data,
      ).toEqual([]);

      const approved = (
        await as('arun')
          .post(`/leave-requests/${created.id}/approve`, {
            note: 'Get well soon',
          })
          .expect(200)
      ).body.data;
      expect(approved).toMatchObject({
        status: 'APPROVED',
        reviewedBy: { id: ids.arun, name: 'Arun' },
        reviewNote: 'Get well soon',
        canApprove: false,
        // It has started, so it can no longer be withdrawn.
        canCancel: false,
      });
      const decided = (await notified('LEAVE', created.id)).find(
        (n) => n.recipientId === ids.ravi,
      );
      expect(decided?.title).toBe(
        'Your leave Sat 3 Oct – Tue 6 Oct was approved',
      );

      // Saturday turns from absent to leave; Sunday is not a working day; today
      // is marked now; tomorrow by the end-of-day job.
      expect((await attendanceOn('2026-10-03'))?.status).toBe('ON_LEAVE');
      expect(await attendanceOn('2026-10-04')).toBeNull();
      expect((await attendanceOn(DAY))?.status).toBe('ON_LEAVE');
      expect(await attendanceOn('2026-10-06')).toBeNull();
      expect(await attendance.markAbsentees('2026-10-06')).toBe(2);
      expect((await attendanceOn('2026-10-06'))?.status).toBe('ON_LEAVE');
      const selvam = await t.prisma.attendance.findFirstOrThrow({
        where: { staffId: ids.selvam, workDate: toDbDate('2026-10-06') },
      });
      expect(selvam.status).toBe('ABSENT');

      // No reminders or "not checked in" for someone on leave.
      t.clock.set(ist('10:30'));
      const day = (await as('arun').get(`/sites/${ids.abc}/day`).expect(200))
        .body.data;
      const raviToday = day.staff.find(
        (s: { staff: { id: string } }) => s.staff.id === ids.ravi,
      );
      expect(raviToday).toMatchObject({ onLeave: true, notCheckedIn: false });
      expect(
        raviToday.slots.every(
          (s: { state: string }) => s.state === 'NOT_EXPECTED',
        ),
      ).toBe(true);
      const missed = t.app.get(MissedUpdatesService);
      // Only Selvam (at Villa) still owes the Morning update.
      await missed.remind(ist('11:35'));
      const reminders = await t.prisma.notification.findMany({
        where: { dedupeKey: { startsWith: 'reminder:' } },
      });
      expect(reminders.map((r) => r.recipientId)).toEqual([ids.selvam]);

      // Attendance lists show it, and reports count it.
      const days = (
        await as('ravi').get('/attendance?from=2026-10-01').expect(200)
      ).body.data;
      expect(days.map((d: { status: string }) => d.status)).toEqual([
        'ON_LEAVE',
        'ON_LEAVE',
        'ON_LEAVE',
      ]);
      const report = (
        await as('admin')
          .get('/reports/staff?from=2026-10-01&to=2026-10-07')
          .expect(200)
      ).body.data;
      expect(
        report.find((r: { staff: { id: string } }) => r.staff.id === ids.ravi)
          .attendance,
      ).toMatchObject({ absent: 0, onLeave: 3 });

      // Turning up anyway makes it a normal day.
      t.clock.set(ist('10:45'));
      const checkIn = (
        await as('ravi').post('/attendance/check-in', ON_SITE).expect(200)
      ).body.data;
      expect(checkIn.status).toBe('LATE');
      const later = (
        await as('arun').get(`/sites/${ids.abc}/day`).expect(200)
      ).body.data.staff.find(
        (s: { staff: { id: string } }) => s.staff.id === ids.ravi,
      );
      expect(later.onLeave).toBe(false);

      // Overlapping leave is refused; started leave can't be withdrawn.
      const overlap = await askLeave('ravi', {
        fromDate: '2026-10-06',
        toDate: '2026-10-07',
      }).expect(409);
      expect(overlap.body.code).toBe('LEAVE_OVERLAPS');
      const cancel = await as('ravi')
        .post(`/leave-requests/${created.id}/cancel`)
        .expect(409);
      expect(cancel.body.code).toBe('REQUEST_ALREADY_DECIDED');
      await as('arun')
        .post(`/leave-requests/${created.id}/approve`, {})
        .expect(409);
    });

    it('is rejected with a reason, and future leave can be withdrawn', async () => {
      const first = (
        await askLeave('ravi', {
          type: 'CASUAL',
          fromDate: '2026-10-08',
          toDate: '2026-10-08',
          reason: 'Family function',
        }).expect(201)
      ).body.data;
      await as('admin')
        .post(`/leave-requests/${first.id}/reject`, {})
        .expect(400);
      const rejected = (
        await as('admin')
          .post(`/leave-requests/${first.id}/reject`, {
            reason: 'Concrete pour that day',
          })
          .expect(200)
      ).body.data;
      expect(rejected).toMatchObject({
        status: 'REJECTED',
        reviewNote: 'Concrete pour that day',
        canCancel: false,
      });
      const decided = (await notified('LEAVE', first.id)).find(
        (n) => n.recipientId === ids.ravi,
      );
      expect(decided).toMatchObject({
        title: 'Your leave Thu 8 Oct was rejected',
        message: `${first.code} · by Admin · Concrete pour that day`,
      });

      // A rejected request doesn't block asking again.
      const second = (
        await askLeave('ravi', {
          type: 'CASUAL',
          fromDate: '2026-10-08',
          toDate: '2026-10-09',
        }).expect(201)
      ).body.data;
      await as('arun')
        .post(`/leave-requests/${second.id}/approve`, {})
        .expect(200);
      const withdrawn = (
        await as('ravi').post(`/leave-requests/${second.id}/cancel`).expect(200)
      ).body.data;
      expect(withdrawn).toMatchObject({
        status: 'CANCELLED',
        canCancel: false,
      });
      await as('arun').post(`/leave-requests/${second.id}/cancel`).expect(403);
      expect(await t.prisma.attendance.count()).toBe(0);
    });

    it('checks the dates and repeats safely', async () => {
      const bad = async (body: object, field: string) => {
        const response = await askLeave('ravi', body).expect(400);
        expect(response.body.details[0].field).toBe(field);
      };
      await bad({ fromDate: '2026-10-09', toDate: '2026-10-08' }, 'toDate');
      await bad({ fromDate: '2026-08-01', toDate: '2026-08-02' }, 'fromDate');
      await bad({ fromDate: '2026-10-06', toDate: '2026-12-31' }, 'toDate');

      const requestId = randomUUID();
      const body = {
        requestId,
        type: 'OTHER',
        fromDate: '2026-10-07',
        toDate: '2026-10-07',
        reason: 'Bank work',
      };
      const once = (await as('ravi').post('/leave-requests', body).expect(201))
        .body.data;
      const twice = (await as('ravi').post('/leave-requests', body).expect(201))
        .body.data;
      expect(twice.id).toBe(once.id);
      await as('selvam').post('/leave-requests', body).expect(409);
      expect(await t.prisma.leaveRequest.count()).toBe(1);
    });
  });

  describe('engineer leave', () => {
    it('goes to admins, who alone decide it', async () => {
      const created = (
        await askLeave('arun', {
          type: 'CASUAL',
          fromDate: '2026-10-12',
          toDate: '2026-10-13',
          reason: 'Wedding',
        }).expect(201)
      ).body.data;
      expect(created).toMatchObject({
        user: { id: ids.arun, role: 'ENGINEER' },
        site: null,
        days: 2,
      });
      const alerts = await notified('LEAVE', created.id);
      expect(alerts.map((n) => n.recipientId)).toEqual([ids.admin]);

      const own = await as('arun')
        .post(`/leave-requests/${created.id}/approve`, {})
        .expect(403);
      expect(own.body.message).toBe("You can't decide your own leave.");
      await as('prakash').get(`/leave-requests/${created.id}`).expect(404);
      await as('ravi').get(`/leave-requests/${created.id}`).expect(404);
      expect(
        (await as('arun').get('/leave-requests?toReview=true').expect(200)).body
          .data,
      ).toEqual([]);

      await as('admin')
        .post(`/leave-requests/${created.id}/approve`, {})
        .expect(200);
      // Engineers have no attendance records.
      expect(await t.prisma.attendance.count()).toBe(0);
      // Admins can't ask for leave here.
      await askLeave('admin', {
        fromDate: '2026-10-12',
        toDate: '2026-10-12',
      }).expect(403);

      // Engineers see their own leave and their staff's.
      await askLeave('ravi', {
        fromDate: '2026-10-07',
        toDate: '2026-10-07',
      }).expect(201);
      const mine = (await as('arun').get('/leave-requests').expect(200)).body;
      expect(mine.meta.total).toBe(2);
      const onlyMine = (
        await as('arun').get('/leave-requests?mine=true').expect(200)
      ).body.data;
      expect(onlyMine.map((r: { id: string }) => r.id)).toEqual([created.id]);
    });
  });

  describe('money and food', () => {
    it('lets staff ask for an advance, decided by their engineer', async () => {
      const created = (
        await ask({ kind: 'MONEY', amount: '1500', note: 'House rent' }).expect(
          201,
        )
      ).body.data;
      expect(created).toMatchObject({
        code: expect.stringMatching(/^RQ-\d{4}$/),
        kind: 'MONEY',
        staff: { id: ids.ravi, name: 'Ravi' },
        site: { id: ids.abc },
        amount: '1500.00',
        forDate: null,
        meal: null,
        note: 'House rent',
        status: 'PENDING',
        canCancel: true,
        canApprove: false,
      });
      const alerts = await notified('STAFF_REQUEST', created.id);
      expect(alerts.map((n) => n.recipientId).sort()).toEqual(
        [ids.admin, ids.arun].sort(),
      );
      expect(alerts[0]).toMatchObject({
        title: 'Ravi asked for ₹1,500 advance',
        message: `${created.code} · ABC`,
      });

      await as('prakash').get(`/staff-requests/${created.id}`).expect(404);
      await as('prakash')
        .post(`/staff-requests/${created.id}/approve`, {})
        .expect(404);
      await as('arun').post(`/staff-requests/${created.id}/reject`).expect(400);
      const rejected = (
        await as('arun')
          .post(`/staff-requests/${created.id}/reject`, {
            reason: 'Advance already given this month',
          })
          .expect(200)
      ).body.data;
      expect(rejected).toMatchObject({
        status: 'REJECTED',
        reviewedBy: { id: ids.arun },
        canApprove: false,
        canCancel: false,
      });
      const decided = (await notified('STAFF_REQUEST', created.id)).find(
        (n) => n.recipientId === ids.ravi,
      );
      expect(decided?.title).toBe('₹1,500 advance rejected');
      await as('admin')
        .post(`/staff-requests/${created.id}/approve`, {})
        .expect(409);

      // Checks.
      expect(
        (await ask({ kind: 'MONEY' }).expect(400)).body.details[0].field,
      ).toBe('amount');
      await ask({ kind: 'MONEY', amount: '0' }).expect(400);
      await ask({ kind: 'MONEY', amount: '150000' }).expect(400);
      await as('arun')
        .post('/staff-requests', {
          requestId: randomUUID(),
          kind: 'MONEY',
          amount: '100',
        })
        .expect(403);
    });

    it('lets staff ask for a meal for themselves', async () => {
      const lunch = (
        await ask({ kind: 'FOOD', forDate: DAY, meal: 'LUNCH' }).expect(201)
      ).body.data;
      expect(lunch).toMatchObject({
        kind: 'FOOD',
        amount: null,
        forDate: DAY,
        meal: 'LUNCH',
      });
      expect((await notified('STAFF_REQUEST', lunch.id))[0].title).toBe(
        'Ravi asked for lunch on Mon 5 Oct',
      );
      await ask({ kind: 'FOOD', forDate: DAY, meal: 'LUNCH' }).expect(409);
      await ask({ kind: 'FOOD', forDate: '2026-10-02', meal: 'LUNCH' }).expect(
        400,
      );
      await ask({ kind: 'FOOD', forDate: DAY }).expect(400);

      const approved = (
        await as('admin')
          .post(`/staff-requests/${lunch.id}/approve`, { note: 'Canteen' })
          .expect(200)
      ).body.data;
      expect(approved).toMatchObject({
        status: 'APPROVED',
        reviewNote: 'Canteen',
      });
      expect(
        (await notified('STAFF_REQUEST', lunch.id)).find(
          (n) => n.recipientId === ids.ravi,
        )?.title,
      ).toBe('Lunch on Mon 5 Oct approved');

      const dinner = (
        await ask({ kind: 'FOOD', forDate: DAY, meal: 'DINNER' }).expect(201)
      ).body.data;
      await as('arun').post(`/staff-requests/${dinner.id}/cancel`).expect(403);
      await as('ravi').post(`/staff-requests/${dinner.id}/cancel`).expect(200);
      const again = (
        await as('ravi').post(`/staff-requests/${dinner.id}/cancel`).expect(200)
      ).body.data;
      expect(again.status).toBe('CANCELLED');
      await as('arun')
        .post(`/staff-requests/${dinner.id}/approve`, {})
        .expect(409);

      // Lists are scoped: staff see theirs, engineers their sites'.
      const mine = (await as('ravi').get('/staff-requests').expect(200)).body;
      expect(mine.meta.total).toBe(2);
      expect(
        (await as('selvam').get('/staff-requests').expect(200)).body.meta.total,
      ).toBe(0);
      expect(
        (await as('prakash').get('/staff-requests').expect(200)).body.meta
          .total,
      ).toBe(0);
      expect(
        (
          await as('arun')
            .get('/staff-requests?kind=FOOD&status=APPROVED')
            .expect(200)
        ).body.data.map((r: { id: string }) => r.id),
      ).toEqual([lunch.id]);
      expect(
        (await as('arun').get('/staff-requests?toReview=true').expect(200)).body
          .meta.total,
      ).toBe(0);
    });
  });

  describe('material', () => {
    it('lets staff ask for material for their site and follow their own requests', async () => {
      const cement = (
        await as('admin')
          .post('/materials', { name: 'Cement OPC 53', unit: 'bag' })
          .expect(201)
      ).body.data.material.id;
      const materials = (await as('ravi').get('/materials').expect(200)).body
        .data;
      expect(materials).toEqual([
        expect.objectContaining({ id: cement, name: 'Cement OPC 53' }),
      ]);

      const request = (
        await as('ravi')
          .post('/material-requests', {
            requestId: randomUUID(),
            siteId: ids.abc,
            lines: [{ materialId: cement, quantity: '10' }],
            note: 'For the first floor slab',
          })
          .expect(201)
      ).body.data;
      expect(request).toMatchObject({
        status: 'PENDING',
        requestedBy: { id: ids.ravi },
        canCancel: true,
        canApprove: false,
      });
      const alerts = await t.prisma.notification.findMany({
        where: { referenceId: request.id },
      });
      expect(alerts.map((n) => n.recipientId).sort()).toEqual(
        [ids.admin, ids.arun].sort(),
      );

      // Only their own site, and only their own requests.
      await as('ravi')
        .post('/material-requests', {
          requestId: randomUUID(),
          siteId: ids.villa,
          lines: [{ materialId: cement, quantity: '1' }],
        })
        .expect(404);
      await as('arun')
        .post('/material-requests', {
          requestId: randomUUID(),
          siteId: ids.abc,
          lines: [{ materialId: cement, quantity: '5' }],
        })
        .expect(201);
      expect(
        (await as('ravi').get('/material-requests').expect(200)).body.data.map(
          (r: { id: string }) => r.id,
        ),
      ).toEqual([request.id]);
      expect(
        (await as('arun').get('/material-requests').expect(200)).body.meta
          .total,
      ).toBe(2);

      await as('ravi')
        .post(`/material-requests/${request.id}/approve`, {})
        .expect(403);
      const cancelled = (
        await as('ravi')
          .post(`/material-requests/${request.id}/cancel`)
          .expect(200)
      ).body.data;
      expect(cancelled.status).toBe('CANCELLED');
    });
  });
});
