import { toDbDate } from '../src/common/time/business-time.js';
import {
  DayActivityService,
  dayTotals,
} from '../src/staff-updates/day-activity.service.js';
import { createSite, createUser, resetDatabase } from './support/fixtures.js';
import { createTestApp, signInAs, type TestApp } from './support/test-app.js';

describe('Admin core (e2e)', () => {
  let t: TestApp;
  let admin: { id: string; phone: string };
  let adminAuth: string;

  beforeAll(async () => {
    t = await createTestApp();
  });

  beforeEach(async () => {
    await resetDatabase(t.prisma);
    admin = await createUser(t.prisma, { role: 'ADMIN' });
    adminAuth = await signInAs(t, admin.phone);
  });

  afterAll(async () => {
    await t.close();
  });

  const as = (auth: string) => ({
    get: (url: string) =>
      t.http().get(`/api/v1${url}`).set('authorization', auth),
    post: (url: string, body?: object) =>
      t.http().post(`/api/v1${url}`).set('authorization', auth).send(body),
    patch: (url: string, body?: object) =>
      t.http().patch(`/api/v1${url}`).set('authorization', auth).send(body),
    put: (url: string, body?: object) =>
      t.http().put(`/api/v1${url}`).set('authorization', auth).send(body),
    delete: (url: string) =>
      t.http().delete(`/api/v1${url}`).set('authorization', auth),
  });

  describe('clients', () => {
    it('creates, searches, reads and updates clients; normalizes the phone', async () => {
      const created = await as(adminAuth)
        .post('/clients', {
          name: 'ABC Constructions',
          phone: '98400 11223',
          email: 'Accounts@ABC.test',
        })
        .expect(201);
      expect(created.body.data).toMatchObject({
        phone: '+919840011223',
        email: 'accounts@abc.test',
        siteCount: 0,
        sites: [],
      });

      await as(adminAuth)
        .post('/clients', { name: 'Green Valley', phone: '9840099999' })
        .expect(201);
      const search = await as(adminAuth).get('/clients?q=abc').expect(200);
      expect(search.body.data.map((c: { name: string }) => c.name)).toEqual([
        'ABC Constructions',
      ]);
      expect(search.body.meta).toMatchObject({ page: 1, total: 1 });

      const updated = await as(adminAuth)
        .patch(`/clients/${created.body.data.id}`, {
          notes: 'Pays by NEFT',
          email: null,
        })
        .expect(200);
      expect(updated.body.data).toMatchObject({
        notes: 'Pays by NEFT',
        email: null,
      });

      const tooShort = await as(adminAuth)
        .post('/clients', { name: 'Bad', phone: '12345' })
        .expect(400);
      expect(tooShort.body.code).toBe('VALIDATION_FAILED');
      const notMobile = await as(adminAuth)
        .post('/clients', { name: 'Bad', phone: '123456789' })
        .expect(400);
      expect(notMobile.body).toMatchObject({
        code: 'INVALID_PHONE',
        details: [{ field: 'phone' }],
      });
    });
  });

  describe('sites', () => {
    it('creates sites with automatic codes and validates money and dates', async () => {
      const engineer = await createUser(t.prisma, {
        role: 'ENGINEER',
        name: 'Arun Kumar',
      });
      const client = await t.prisma.client.create({
        data: { name: 'ABC', phone: '+919840011223' },
      });
      const body = {
        name: 'ABC Apartment Project',
        clientId: client.id,
        address: 'Anna Nagar, Chennai',
        startDate: '2026-03-02',
        contractAmount: '1500000',
        engineerIds: [engineer.id],
      };

      const first = await as(adminAuth).post('/sites', body).expect(201);
      expect(first.body.data).toMatchObject({
        code: 'SITE-001',
        status: 'NOT_STARTED',
        contractAmount: '1500000.00',
        geofenceRadiusM: 300,
        engineers: [{ id: engineer.id, name: 'Arun Kumar' }],
        financials: {
          contract: '1500000.00',
          received: '0.00',
          pending: '1500000.00',
          milestones: [],
        },
      });
      expect(
        (await as(adminAuth).post('/sites', body).expect(201)).body.data.code,
      ).toBe('SITE-002');
      expect(
        (
          await as(adminAuth)
            .post('/sites', { ...body, code: 'site-001' })
            .expect(409)
        ).body.code,
      ).toBe('SITE_CODE_IN_USE');
      expect(
        (
          await as(adminAuth)
            .post('/sites', { ...body, expectedCompletionDate: '2026-01-01' })
            .expect(400)
        ).body.details[0].field,
      ).toBe('expectedCompletionDate');

      // The contract can't drop below what has already been received.
      await t.prisma.payment.create({
        data: {
          siteId: first.body.data.id,
          amount: 500000,
          paidOn: toDbDate('2026-04-01'),
          method: 'UPI',
          recordedById: admin.id,
        },
      });
      const below = await as(adminAuth)
        .patch(`/sites/${first.body.data.id}`, { contractAmount: '400000' })
        .expect(400);
      expect(below.body.code).toBe('CONTRACT_BELOW_RECEIVED');
      const raised = await as(adminAuth)
        .patch(`/sites/${first.body.data.id}`, {
          contractAmount: '1600000',
          status: 'IN_PROGRESS',
        })
        .expect(200);
      expect(raised.body.data.financials).toMatchObject({
        received: '500000.00',
        pending: '1100000.00',
      });
      const audit = await t.prisma.auditLog.findFirst({
        where: { action: 'site.updated' },
      });
      expect(audit?.changes).toMatchObject({
        contractAmount: '1600000',
        previousContractAmount: '1500000.00',
      });
    });

    it('keeps an engineer on a site while staff still report to them there', async () => {
      const arun = await createUser(t.prisma, {
        role: 'ENGINEER',
        name: 'Arun',
      });
      const prakash = await createUser(t.prisma, {
        role: 'ENGINEER',
        name: 'Prakash',
      });
      const ravi = await createUser(t.prisma, { name: 'Ravi' });
      const site = await createSite(t.prisma, {
        createdById: admin.id,
        engineerIds: [arun.id, prakash.id],
        staffIds: [ravi.id],
      });

      const blocked = await as(adminAuth)
        .put(`/sites/${site.id}/engineers`, { engineerIds: [prakash.id] })
        .expect(409);
      expect(blocked.body).toMatchObject({ code: 'ENGINEER_HAS_STAFF' });
      expect(blocked.body.message).toContain('Ravi (Arun)');

      const changed = await as(adminAuth)
        .put(`/sites/${site.id}/engineers`, { engineerIds: [arun.id] })
        .expect(200);
      expect(changed.body.data.engineers).toEqual([
        { id: arun.id, name: 'Arun' },
      ]);
      const history = await t.prisma.assignmentHistory.findMany({
        where: { siteId: site.id },
      });
      expect(history).toMatchObject([{ kind: 'ENGINEER', userId: prakash.id }]);
    });

    it('scopes site access by role', async () => {
      const arun = await createUser(t.prisma, { role: 'ENGINEER' });
      const suresh = await createUser(t.prisma, { role: 'ENGINEER' });
      const ravi = await createUser(t.prisma);
      const mine = await createSite(t.prisma, {
        name: 'Mine',
        createdById: admin.id,
        engineerIds: [arun.id],
        staffIds: [ravi.id],
      });
      const other = await createSite(t.prisma, {
        name: 'Other',
        createdById: admin.id,
        engineerIds: [suresh.id],
      });
      await t.prisma.paymentMilestone.create({
        data: {
          siteId: mine.id,
          title: 'Advance',
          amount: 100000,
          dueDate: toDbDate('2026-01-01'),
          createdById: admin.id,
        },
      });

      const engineer = as(await signInAs(t, arun.phone));
      const engineerSites = await engineer.get('/sites').expect(200);
      expect(
        engineerSites.body.data.map((s: { name: string }) => s.name),
      ).toEqual(['Mine']);
      await engineer.get(`/sites/${other.id}`).expect(404);
      const engineerView = await engineer.get(`/sites/${mine.id}`).expect(200);
      expect(engineerView.body.data.financials).toMatchObject({
        contract: '1000000.00',
      });
      expect(engineerView.body.data.financials).not.toHaveProperty(
        'milestones',
      );
      await engineer.post('/sites', {}).expect(403);

      const staff = as(await signInAs(t, ravi.phone));
      const staffView = await staff.get(`/sites/${mine.id}`).expect(200);
      // Staff never see money or the client's contact details.
      expect(staffView.body.data).toMatchObject({
        financials: null,
        staff: [],
        contractAmount: null,
        client: { phone: null, email: null },
      });
      const staffList = await staff.get('/sites').expect(200);
      expect(
        staffList.body.data.map(
          (s: { contractAmount: unknown }) => s.contractAmount,
        ),
      ).toEqual([null]);
      await staff.get(`/sites/${other.id}`).expect(404);
      await staff.get('/staff').expect(403);
      await staff.get('/clients').expect(403);
    });
  });

  describe('people', () => {
    it('creates an engineer with a temporary password that must be changed', async () => {
      const created = await as(adminAuth)
        .post('/engineers', {
          name: 'Arun Kumar',
          phone: '9000000011',
          email: 'arun@sitework.test',
        })
        .expect(201);
      expect(created.body.data.person).toMatchObject({
        employeeCode: 'ENG-001',
        mustChangePassword: true,
        isActive: true,
      });
      const temporaryPassword = created.body.data.temporaryPassword as string;

      const login = await t
        .http()
        .post('/api/v1/auth/login')
        .send({ identifier: '9000000011', password: temporaryPassword })
        .expect(200);
      expect(login.body.data.user.mustChangePassword).toBe(true);

      const duplicate = await as(adminAuth)
        .post('/engineers', { name: 'Someone', phone: '+91 90000 00011' })
        .expect(409);
      expect(duplicate.body).toMatchObject({
        code: 'PHONE_IN_USE',
        message: 'This mobile number is already used by Arun Kumar.',
      });
    });

    it('assigns staff, moves them between sites with history, and filters lists', async () => {
      const arun = await createUser(t.prisma, { role: 'ENGINEER' });
      const prakash = await createUser(t.prisma, { role: 'ENGINEER' });
      const siteA = await createSite(t.prisma, {
        name: 'A',
        createdById: admin.id,
        engineerIds: [arun.id],
      });
      const siteB = await createSite(t.prisma, {
        name: 'B',
        createdById: admin.id,
        engineerIds: [prakash.id],
      });

      const created = await as(adminAuth)
        .post('/staff', {
          name: 'Ravi',
          phone: '9000000101',
          designation: 'MASON',
          siteId: siteA.id,
          engineerId: arun.id,
        })
        .expect(201);
      const ravi = created.body.data.person;
      expect(ravi).toMatchObject({
        employeeCode: 'STF-001',
        assignment: { site: { id: siteA.id }, engineer: { id: arun.id } },
      });

      const wrongEngineer = await as(adminAuth)
        .put(`/staff/${ravi.id}/assignment`, {
          siteId: siteB.id,
          engineerId: arun.id,
        })
        .expect(400);
      expect(wrongEngineer.body.code).toBe('ENGINEER_NOT_ON_SITE');

      await as(adminAuth)
        .put(`/staff/${ravi.id}/assignment`, {
          siteId: siteB.id,
          engineerId: prakash.id,
        })
        .expect(200);
      expect(
        await t.prisma.assignmentHistory.findMany({
          where: { userId: ravi.id },
        }),
      ).toMatchObject([
        { kind: 'STAFF', siteId: siteA.id, engineerId: arun.id },
      ]);

      await as(adminAuth)
        .post('/staff', {
          name: 'Kumar',
          phone: '9000000102',
          designation: 'HELPER',
        })
        .expect(201);
      const unassigned = await as(adminAuth)
        .get('/staff?unassigned=true')
        .expect(200);
      expect(unassigned.body.data.map((p: { name: string }) => p.name)).toEqual(
        ['Kumar'],
      );
      const onSiteB = await as(adminAuth)
        .get(`/staff?siteId=${siteB.id}`)
        .expect(200);
      expect(onSiteB.body.data.map((p: { name: string }) => p.name)).toEqual([
        'Ravi',
      ]);

      // Engineers see only staff on their own sites.
      const prakashView = await as(await signInAs(t, prakash.phone))
        .get('/staff')
        .expect(200);
      expect(
        prakashView.body.data.map((p: { name: string }) => p.name),
      ).toEqual(['Ravi']);
      const arunView = await as(await signInAs(t, arun.phone))
        .get('/staff')
        .expect(200);
      expect(arunView.body.data).toEqual([]);
    });

    it('deactivation ends sessions and assignments, and protects supervised staff', async () => {
      const arun = await createUser(t.prisma, { role: 'ENGINEER' });
      const ravi = await createUser(t.prisma);
      await createSite(t.prisma, {
        createdById: admin.id,
        engineerIds: [arun.id],
        staffIds: [ravi.id],
      });
      const raviAuth = await signInAs(t, ravi.phone);

      const blocked = await as(adminAuth)
        .patch(`/engineers/${arun.id}/status`, { isActive: false })
        .expect(409);
      expect(blocked.body.code).toBe('ENGINEER_HAS_STAFF');

      const deactivated = await as(adminAuth)
        .patch(`/staff/${ravi.id}/status`, { isActive: false })
        .expect(200);
      expect(deactivated.body.data).toMatchObject({
        isActive: false,
        assignment: null,
      });
      await as(raviAuth).get('/me').expect(401);

      const engineerOff = await as(adminAuth)
        .patch(`/engineers/${arun.id}/status`, { isActive: false })
        .expect(200);
      expect(engineerOff.body.data).toMatchObject({
        isActive: false,
        sites: [],
      });

      const reassign = await as(adminAuth)
        .put(`/staff/${ravi.id}/assignment`, {
          siteId: '00000000-0000-0000-0000-000000000000',
          engineerId: arun.id,
        })
        .expect(400);
      expect(reassign.body.code).toBe('USER_INACTIVE');
    });
  });

  describe('settings and holidays', () => {
    it('lets everyone read rules, only admins change them, with validation', async () => {
      const staff = await createUser(t.prisma);
      const staffAuth = await signInAs(t, staff.phone);
      const read = await as(staffAuth).get('/settings').expect(200);
      expect(read.body.data.business.timeZone).toBe('Asia/Kolkata');
      await as(staffAuth)
        .patch('/settings/images', { ttlHours: 48 })
        .expect(403);

      const invalid = await as(adminAuth)
        .patch('/settings/images', { ttlHours: 0 })
        .expect(400);
      expect(invalid.body).toMatchObject({
        code: 'VALIDATION_FAILED',
        details: [{ field: 'ttlHours' }],
      });
      await as(adminAuth).patch('/settings/unknown', {}).expect(404);

      const saved = await as(adminAuth)
        .patch('/settings/images', { ttlHours: 48 })
        .expect(200);
      expect(saved.body.data).toMatchObject({
        ttlHours: 48,
        expiryAction: 'DELETE',
      });
      expect(
        (await as(staffAuth).get('/settings').expect(200)).body.data.images
          .ttlHours,
      ).toBe(48);
    });

    it('manages holidays', async () => {
      const created = await as(adminAuth)
        .post('/holidays', { date: '2026-11-08', name: 'Diwali' })
        .expect(201);
      await as(adminAuth)
        .post('/holidays', { date: '2026-11-08', name: 'Again' })
        .expect(409);
      expect(
        (await as(adminAuth).get('/holidays?year=2026').expect(200)).body.data,
      ).toEqual([
        { id: created.body.data.id, date: '2026-11-08', name: 'Diwali' },
      ]);
      await as(adminAuth)
        .delete(`/holidays/${created.body.data.id}`)
        .expect(200);
    });
  });

  describe('day activity and dashboard', () => {
    // Monday 5 Oct 2026, India Standard Time.
    const ist = (time: string) => new Date(`2026-10-05T${time}:00+05:30`);

    it('judges each slot by the server clock, checked-in or not', async () => {
      const arun = await createUser(t.prisma, { role: 'ENGINEER' });
      const ravi = await createUser(t.prisma, { name: 'Ravi' });
      const kumar = await createUser(t.prisma, { name: 'Kumar' });
      const site = await createSite(t.prisma, {
        createdById: admin.id,
        engineerIds: [arun.id],
        staffIds: [ravi.id, kumar.id],
      });
      const workDate = toDbDate('2026-10-05');
      await t.prisma.attendance.create({
        data: {
          staffId: ravi.id,
          siteId: site.id,
          workDate,
          status: 'PRESENT',
          checkInAt: ist('09:00'),
        },
      });
      await t.prisma.staffUpdate.create({
        data: {
          clientSubmissionId: crypto.randomUUID(),
          staffId: ravi.id,
          siteId: site.id,
          engineerId: arun.id,
          workDate,
          slot: 'MORNING',
          description: 'Brickwork',
          locationFlag: 'OK',
          photoSource: 'CAMERA',
          capturedAt: ist('10:30'),
          submittedAt: ist('10:31'),
          imageKey: 'test/key.jpg',
          imageBytes: 1000,
          imageMime: 'image/jpeg',
          imageExpiresAt: ist('23:00'),
        },
      });
      const activity = t.app.get(DayActivityService);
      const states = async (time: string) => {
        const day = await activity.forDate('2026-10-05', {}, ist(time));
        return Object.fromEntries(
          day.staff.map((s) => [
            s.staff.name,
            s.slots.map((slot) => slot.state),
          ]),
        );
      };

      expect(await states('13:30')).toEqual({
        Kumar: ['NOT_EXPECTED', 'PENDING', 'UPCOMING'], // never checked in: absent, not "missing"
        Ravi: ['SUBMITTED', 'PENDING', 'UPCOMING'],
      });
      const evening = await activity.forDate('2026-10-05', {}, ist('20:00'));
      expect(
        evening.staff
          .find((s) => s.staff.name === 'Ravi')!
          .slots.map((s) => s.state),
      ).toEqual(['SUBMITTED', 'MISSING', 'MISSING']);
      expect(dayTotals(evening.staff)).toMatchObject({
        expected: 3,
        submitted: 1,
        missing: 2,
        notCheckedIn: 1,
      });

      // Arriving after the Morning window closed: Morning was never owed.
      await t.prisma.attendance.create({
        data: {
          staffId: kumar.id,
          siteId: site.id,
          workDate,
          status: 'LATE',
          checkInAt: ist('13:20'),
        },
      });
      expect((await states('13:30')).Kumar).toEqual([
        'NOT_EXPECTED',
        'PENDING',
        'UPCOMING',
      ]);
      expect((await states('20:00')).Kumar).toEqual([
        'NOT_EXPECTED',
        'MISSING',
        'MISSING',
      ]);

      await t.prisma.holiday.create({
        data: { date: workDate, name: 'Test holiday' },
      });
      t.app
        .get(
          (await import('../src/settings/calendar.service.js')).CalendarService,
        )
        .invalidate();
      const holiday = await activity.forDate('2026-10-05', {}, ist('13:30'));
      expect(holiday).toMatchObject({
        isWorkingDay: false,
        holiday: 'Test holiday',
      });
      expect(
        holiday.staff
          .find((s) => s.staff.name === 'Kumar')!
          .slots.every((s) => s.state === 'NOT_EXPECTED'),
      ).toBe(true);
    });

    it('summarizes counts, money, issues and attention items for the admin', async () => {
      const arun = await createUser(t.prisma, { role: 'ENGINEER' });
      await createUser(t.prisma, { role: 'ENGINEER', isActive: false });
      const ravi = await createUser(t.prisma);
      const site = await createSite(t.prisma, {
        name: 'ABC',
        createdById: admin.id,
        engineerIds: [arun.id],
        staffIds: [ravi.id],
      });
      await t.prisma.paymentMilestone.create({
        data: {
          siteId: site.id,
          title: 'Slab 1',
          amount: 300000,
          dueDate: toDbDate('2026-01-15'),
          createdById: admin.id,
        },
      });
      await t.prisma.payment.create({
        data: {
          siteId: site.id,
          amount: 200000,
          paidOn: toDbDate('2026-01-20'),
          method: 'UPI',
          recordedById: admin.id,
        },
      });
      await t.prisma.issue.create({
        data: {
          siteId: site.id,
          reportedById: arun.id,
          title: 'Parapet crack',
          description: 'x',
          priority: 'CRITICAL',
        },
      });

      const engineerAuth = await signInAs(t, arun.phone);
      await as(engineerAuth).get('/dashboard/admin').expect(403);

      const response = await as(adminAuth).get('/dashboard/admin').expect(200);
      const dashboard = response.body.data;
      expect(dashboard.counts).toEqual({
        activeSites: 1,
        clients: 1,
        engineers: 1,
        staff: 1,
      });
      expect(dashboard.payments).toMatchObject({
        contract: '1000000.00',
        received: '200000.00',
        pending: '800000.00',
        overdue: '100000.00',
        overdueCount: 1,
      });
      expect(dashboard.issues).toEqual({ open: 1, critical: 1 });
      expect(dashboard.attention).toEqual(
        expect.arrayContaining([
          expect.objectContaining({
            type: 'OVERDUE_PAYMENT',
            milestone: expect.objectContaining({ title: 'Slab 1' }),
            outstanding: '100000.00',
          }),
          expect.objectContaining({
            type: 'CRITICAL_ISSUE',
            issue: expect.objectContaining({ title: 'Parapet crack' }),
          }),
        ]),
      );
      expect(dashboard.sites).toMatchObject([
        { site: { name: 'ABC' }, staffCount: 1 },
      ]);
    });
  });
});
