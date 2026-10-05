import { randomUUID } from 'node:crypto';
import { rm } from 'node:fs/promises';
import { resolve } from 'node:path';
import sharp from 'sharp';
import { toDbDate } from '../src/common/time/business-time.js';
import { createSite, createUser, resetDatabase } from './support/fixtures.js';
import { createTestApp, signInAs, type TestApp } from './support/test-app.js';

// Monday 5 Oct 2026, India Standard Time.
const DAY = '2026-10-05';
const ist = (time: string) => new Date(`${DAY}T${time}:00+05:30`);

describe('Engineer work: dashboard, staff board, updates, issues (e2e)', () => {
  let t: TestApp;
  let photo: Buffer;

  beforeAll(async () => {
    t = await createTestApp();
    photo = await sharp({
      create: { width: 1200, height: 900, channels: 3, background: '#468' },
    })
      .jpeg()
      .toBuffer();
  });

  afterAll(async () => {
    await t.close();
  });

  let admin: { id: string; phone: string };
  let arun: { id: string; phone: string; name: string };
  let prakash: { id: string; phone: string };
  let ravi: { id: string; phone: string };
  let site: { id: string };
  let otherSite: { id: string };

  beforeEach(async () => {
    await resetDatabase(t.prisma);
    await rm(resolve('.test-storage'), { recursive: true, force: true });
    t.clock.set(ist('11:00'));
    admin = await createUser(t.prisma, { role: 'ADMIN', name: 'Admin' });
    arun = await createUser(t.prisma, { role: 'ENGINEER', name: 'Arun' });
    prakash = await createUser(t.prisma, { role: 'ENGINEER', name: 'Prakash' });
    ravi = await createUser(t.prisma, { name: 'Ravi' });
    const kumar = await createUser(t.prisma, { name: 'Kumar' });
    site = await createSite(t.prisma, {
      name: 'ABC',
      createdById: admin.id,
      engineerIds: [arun.id],
      staffIds: [ravi.id, kumar.id],
    });
    otherSite = await createSite(t.prisma, {
      name: 'Elsewhere',
      createdById: admin.id,
      engineerIds: [prakash.id],
    });
  });

  const as = (auth: string) => ({
    get: (url: string) =>
      t.http().get(`/api/v1${url}`).set('authorization', auth),
    post: (url: string, body?: object) =>
      t.http().post(`/api/v1${url}`).set('authorization', auth).send(body),
    patch: (url: string, body?: object) =>
      t.http().patch(`/api/v1${url}`).set('authorization', auth).send(body),
  });

  function multipart(
    auth: string,
    url: string,
    fields: Record<string, string | number>,
    photos = 0,
  ) {
    const request = t.http().post(`/api/v1${url}`).set('authorization', auth);
    for (const [name, value] of Object.entries(fields))
      request.field(name, String(value));
    for (let i = 0; i < photos; i += 1) {
      request.attach('photos', photo, {
        filename: `p${i}.jpg`,
        contentType: 'image/jpeg',
      });
    }
    return request;
  }

  /** Ravi checked in and sent the Morning update with a photo. */
  async function raviSentMorning(): Promise<string> {
    const workDate = toDbDate(DAY);
    await t.prisma.attendance.create({
      data: {
        staffId: ravi.id,
        siteId: site.id,
        workDate,
        status: 'PRESENT',
        checkInAt: ist('09:00'),
      },
    });
    const update = await t.prisma.staffUpdate.create({
      data: {
        clientSubmissionId: randomUUID(),
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
        imageKey: 'staff/2026-10-05/x.jpg',
        imageBytes: 1000,
        imageMime: 'image/jpeg',
        imageExpiresAt: ist('23:00'),
      },
    });
    return update.id;
  }

  describe('engineer dashboard and staff board', () => {
    it('shows only their sites, what to review, and who needs attention', async () => {
      await raviSentMorning();
      t.clock.set(ist('12:30'));
      const arunAuth = await signInAs(t, arun.phone);

      const dashboard = (
        await as(arunAuth).get('/dashboard/engineer').expect(200)
      ).body.data;
      expect(
        dashboard.sites.map((s: { site: { name: string } }) => s.site.name),
      ).toEqual(['ABC']);
      expect(dashboard).toMatchObject({
        date: DAY,
        toReview: 1,
        updates: { submitted: 1, notCheckedIn: 1 },
        issues: { open: 0, critical: 0 },
      });
      expect(dashboard.attention).toEqual([
        {
          type: 'NOT_CHECKED_IN',
          site: { id: site.id, name: 'ABC' },
          count: 1,
          staffNames: ['Kumar'],
        },
      ]);
      expect(dashboard).not.toHaveProperty('payments');
      await as(arunAuth).get('/dashboard/admin').expect(403);
    });

    it('lists the site’s staff with their slots, review state and attendance', async () => {
      const updateId = await raviSentMorning();
      const arunAuth = await signInAs(t, arun.phone);

      const board = (
        await as(arunAuth).get(`/sites/${site.id}/day`).expect(200)
      ).body.data;
      expect(board.date).toBe(DAY);
      const raviDay = board.staff.find(
        (s: { staff: { name: string } }) => s.staff.name === 'Ravi',
      );
      expect(raviDay.attendance).toMatchObject({ status: 'PRESENT' });
      expect(raviDay.slots[0]).toMatchObject({
        slot: 'MORNING',
        state: 'SUBMITTED',
        update: {
          id: updateId,
          imageStatus: 'AVAILABLE',
          engineerViewedAt: null,
          adminViewedAt: null,
        },
      });

      const earlier = (
        await as(arunAuth)
          .get(`/sites/${site.id}/day?date=2026-10-03`)
          .expect(200)
      ).body.data;
      expect(earlier.date).toBe('2026-10-03');
      await as(arunAuth).get(`/sites/${otherSite.id}/day`).expect(404);
      await as(await signInAs(t, ravi.phone))
        .get(`/sites/${site.id}/day`)
        .expect(403);
      await as(arunAuth)
        .get(`/sites/${site.id}/day?date=yesterday`)
        .expect(400);
    });
  });

  describe('photo review queue', () => {
    it('lists photos each reviewer still has to see, until they see them', async () => {
      const updateId = await raviSentMorning();
      const arunAuth = await signInAs(t, arun.phone);
      const adminAuth = await signInAs(t, admin.phone);
      const pending = async (auth: string) =>
        (await as(auth).get('/staff-updates?pendingReview=true').expect(200))
          .body.meta.total as number;

      expect(await pending(arunAuth)).toBe(1);
      expect(await pending(adminAuth)).toBe(1);
      expect(await pending(await signInAs(t, prakash.phone))).toBe(0);
      expect(
        (await as(adminAuth).get('/dashboard/admin').expect(200)).body.data
          .toReview,
      ).toBe(1);

      await as(arunAuth).post(`/staff-updates/${updateId}/views`).expect(200);
      expect(await pending(arunAuth)).toBe(0);
      expect(await pending(adminAuth)).toBe(1);
    });
  });

  describe('engineer updates', () => {
    it('reports to admins with photos; a progress report moves the site’s progress', async () => {
      const arunAuth = await signInAs(t, arun.phone);
      const created = await multipart(
        arunAuth,
        '/engineer-updates',
        {
          siteId: site.id,
          type: 'PROGRESS',
          description: 'Slab concreting done',
          progressPercent: 55,
        },
        2,
      ).expect(201);
      expect(created.body.data).toMatchObject({
        type: 'PROGRESS',
        priority: 'MEDIUM',
        progressPercent: 55,
        attachmentCount: 2,
        site: { id: site.id },
        engineer: { id: arun.id },
      });
      expect(created.body.data.attachments).toHaveLength(2);
      const image = await t
        .http()
        .get(`/api/v1${created.body.data.attachments[0].url as string}`)
        .expect(200);
      expect(image.headers['content-type']).toBe('image/jpeg');
      expect(
        (await t.prisma.site.findUniqueOrThrow({ where: { id: site.id } }))
          .progressPercent,
      ).toBe(55);

      const notice = await t.prisma.notification.findFirstOrThrow({
        where: { type: 'ENGINEER_UPDATE' },
      });
      expect(notice).toMatchObject({
        recipientId: admin.id,
        title: 'Engineer Arun submitted a site progress update',
      });

      const adminAuth = await signInAs(t, admin.phone);
      const seen = await as(adminAuth)
        .post(`/engineer-updates/${created.body.data.id as string}/views`)
        .expect(200);
      expect(seen.body.data.adminViewedAt).toBe(ist('11:00').toISOString());
      expect(
        (
          await as(adminAuth)
            .get(`/engineer-updates?siteId=${site.id}`)
            .expect(200)
        ).body.meta.total,
      ).toBe(1);
    });

    it('keeps engineers to their own sites and checks the fields', async () => {
      const arunAuth = await signInAs(t, arun.phone);
      await multipart(arunAuth, '/engineer-updates', {
        siteId: otherSite.id,
        type: 'REMARK',
        description: 'Not mine',
      }).expect(404);
      const misplaced = await multipart(arunAuth, '/engineer-updates', {
        siteId: site.id,
        type: 'REMARK',
        description: 'A remark',
        progressPercent: 10,
      }).expect(400);
      expect(misplaced.body.details[0].field).toBe('progressPercent');
      await multipart(
        arunAuth,
        '/engineer-updates',
        { siteId: site.id, type: 'REMARK', description: 'Six' },
        6,
      ).expect(400);
      await multipart(await signInAs(t, admin.phone), '/engineer-updates', {
        siteId: site.id,
        type: 'REMARK',
        description: 'Admins read these',
      }).expect(403);

      await multipart(arunAuth, '/engineer-updates', {
        siteId: site.id,
        type: 'MATERIALS_REQUIRED',
        description: 'Need 40 bags of cement',
      }).expect(201);
      expect(
        (
          await as(await signInAs(t, prakash.phone))
            .get('/engineer-updates')
            .expect(200)
        ).body.data,
      ).toEqual([]);
      const mine = await as(arunAuth)
        .get('/engineer-updates?type=MATERIALS_REQUIRED&q=cement')
        .expect(200);
      expect(mine.body.meta.total).toBe(1);
      expect(mine.body.data[0]).not.toHaveProperty('attachments');
    });
  });

  describe('issues', () => {
    it('are reported with photos, worked on, and resolved with a note', async () => {
      const arunAuth = await signInAs(t, arun.phone);
      const created = await multipart(
        arunAuth,
        '/issues',
        {
          siteId: site.id,
          title: 'Seepage in basement',
          description: 'North wall after rain',
          priority: 'CRITICAL',
        },
        1,
      ).expect(201);
      const id = created.body.data.id as string;
      expect(created.body.data).toMatchObject({
        status: 'OPEN',
        priority: 'CRITICAL',
        reportedBy: { id: arun.id, role: 'ENGINEER' },
        attachmentCount: 1,
      });
      const reported = await t.prisma.notification.findMany({
        where: { type: 'ISSUE' },
      });
      expect(reported.map((n) => n.recipientId)).toEqual([admin.id]);
      expect(reported[0].title).toBe('New critical issue: Seepage in basement');

      const adminAuth = await signInAs(t, admin.phone);
      const dashboard = (
        await as(adminAuth).get('/dashboard/admin').expect(200)
      ).body.data;
      expect(dashboard.attention).toContainEqual({
        type: 'CRITICAL_ISSUE',
        site: { id: site.id, name: 'ABC' },
        issue: { id, title: 'Seepage in basement' },
      });

      await as(arunAuth)
        .patch(`/issues/${id}`, { status: 'IN_PROGRESS' })
        .expect(200);
      const noNote = await as(arunAuth)
        .patch(`/issues/${id}`, { status: 'RESOLVED' })
        .expect(400);
      expect(noNote.body.details[0].field).toBe('resolutionNote');
      t.clock.set(ist('16:00'));
      const resolved = await as(arunAuth)
        .patch(`/issues/${id}`, {
          status: 'RESOLVED',
          resolutionNote: 'Waterproofing applied',
        })
        .expect(200);
      expect(resolved.body.data).toMatchObject({
        status: 'RESOLVED',
        resolvedAt: ist('16:00').toISOString(),
        resolvedBy: { id: arun.id },
        resolutionNote: 'Waterproofing applied',
      });
      const resolvedNotice = await t.prisma.notification.findFirstOrThrow({
        where: { title: { startsWith: 'Issue resolved' } },
      });
      expect(resolvedNotice.recipientId).toBe(admin.id);

      // Only an admin can reopen.
      await as(arunAuth).patch(`/issues/${id}`, { status: 'OPEN' }).expect(403);
      const reopened = await as(adminAuth)
        .patch(`/issues/${id}`, { status: 'OPEN' })
        .expect(200);
      expect(reopened.body.data).toMatchObject({
        status: 'OPEN',
        resolvedAt: null,
        resolutionNote: null,
      });
      expect(
        await t.prisma.auditLog.count({ where: { action: 'issue.updated' } }),
      ).toBe(3);
    });

    it('lists by scope and urgency; admin-reported issues reach the site’s engineers', async () => {
      const adminAuth = await signInAs(t, admin.phone);
      await multipart(adminAuth, '/issues', {
        siteId: site.id,
        title: 'Low one',
        description: 'Minor crack',
        priority: 'LOW',
      }).expect(201);
      await multipart(adminAuth, '/issues', {
        siteId: site.id,
        title: 'Urgent one',
        description: 'Scaffolding loose',
        priority: 'HIGH',
      }).expect(201);
      await multipart(adminAuth, '/issues', {
        siteId: otherSite.id,
        title: 'Elsewhere',
        description: 'Other site',
      }).expect(201);
      expect(
        (
          await t.prisma.notification.findMany({
            where: { recipientId: arun.id, type: 'ISSUE' },
          })
        ).length,
      ).toBe(2);

      const arunAuth = await signInAs(t, arun.phone);
      const list = await as(arunAuth)
        .get('/issues?unresolved=true')
        .expect(200);
      expect(list.body.data.map((i: { title: string }) => i.title)).toEqual([
        'Urgent one',
        'Low one',
      ]);
      const elsewhere = (
        await as(adminAuth).get(`/issues?siteId=${otherSite.id}`).expect(200)
      ).body.data[0].id as string;
      await as(arunAuth).get(`/issues/${elsewhere}`).expect(404);
      await as(arunAuth)
        .patch(`/issues/${elsewhere}`, { status: 'IN_PROGRESS' })
        .expect(404);
      await as(await signInAs(t, ravi.phone))
        .get('/issues')
        .expect(403);
    });
  });
});
