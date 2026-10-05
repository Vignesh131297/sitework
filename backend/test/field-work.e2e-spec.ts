import { randomUUID } from 'node:crypto';
import { existsSync } from 'node:fs';
import { rm } from 'node:fs/promises';
import { resolve } from 'node:path';
import sharp from 'sharp';
import { AttendanceService } from '../src/attendance/attendance.service.js';
import { ImageCleanupService } from '../src/staff-updates/image-cleanup.service.js';
import { MissedUpdatesService } from '../src/staff-updates/missed-updates.service.js';
import { createSite, createUser, resetDatabase } from './support/fixtures.js';
import { createTestApp, signInAs, type TestApp } from './support/test-app.js';

// Monday 5 Oct 2026, India Standard Time. Windows: 10-12, 13-15, 16-19 (+15 min grace).
const DAY = '2026-10-05';
const ist = (time: string, date = DAY) => new Date(`${date}T${time}:00+05:30`);
const ON_SITE = { latitude: 13.0879, longitude: 80.2009, accuracyM: 12 };
const FAR_AWAY = { latitude: 13.1, longitude: 80.3, accuracyM: 10 };

describe('Field work: attendance, staff updates, photos (e2e)', () => {
  let t: TestApp;
  let photo: Buffer;

  beforeAll(async () => {
    t = await createTestApp();
    // A large photo with EXIF, like a phone camera's.
    photo = await sharp({
      create: { width: 2400, height: 1800, channels: 3, background: '#8a6' },
    })
      .withExif({ IFD0: { Copyright: 'camera', Make: 'PhoneCo' } })
      .jpeg()
      .toBuffer();
  });

  afterAll(async () => {
    await t.close();
  });

  let admin: { id: string; phone: string };
  let arun: { id: string; phone: string };
  let ravi: { id: string; phone: string };
  let site: { id: string };

  beforeEach(async () => {
    await resetDatabase(t.prisma);
    await rm(resolve('.test-storage'), { recursive: true, force: true });
    t.clock.reset();
    admin = await createUser(t.prisma, { role: 'ADMIN', name: 'Admin' });
    arun = await createUser(t.prisma, { role: 'ENGINEER', name: 'Arun' });
    ravi = await createUser(t.prisma, { name: 'Ravi' });
    site = await createSite(t.prisma, {
      name: 'ABC',
      createdById: admin.id,
      engineerIds: [arun.id],
      staffIds: [ravi.id],
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

  const at = (time: string, date = DAY) => t.clock.set(ist(time, date));

  /** Multipart update as the app sends it. */
  function sendUpdate(
    auth: string,
    fields: Record<string, string | number | boolean | undefined> = {},
    file: Buffer | null = photo,
  ) {
    const request = t
      .http()
      .post('/api/v1/staff-updates')
      .set('authorization', auth);
    const values = {
      slot: 'MORNING',
      description: 'Plastering the first floor',
      clientSubmissionId: randomUUID(),
      ...ON_SITE,
      ...fields,
    };
    for (const [name, value] of Object.entries(values)) {
      if (value !== undefined) request.field(name, String(value));
    }
    if (file)
      request.attach('photo', file, {
        filename: 'photo.jpg',
        contentType: 'image/jpeg',
      });
    return request;
  }

  async function checkIn(auth: string, time = '09:05') {
    at(time);
    return as(auth).post('/attendance/check-in', ON_SITE).expect(200);
  }

  describe('attendance', () => {
    it('checks in on time or late, flags location, and refuses a second check-in', async () => {
      const raviAuth = await signInAs(t, ravi.phone);
      const onTime = await checkIn(raviAuth, '09:10');
      expect(onTime.body.data).toMatchObject({
        status: 'PRESENT',
        checkInLocationFlag: 'OK',
        workDate: DAY,
      });
      const again = await as(raviAuth)
        .post('/attendance/check-in', ON_SITE)
        .expect(409);
      expect(again.body.code).toBe('ALREADY_CHECKED_IN');

      const kumar = await createUser(t.prisma, { name: 'Kumar' });
      await t.prisma.staffAssignment.create({
        data: { staffId: kumar.id, siteId: site.id, engineerId: arun.id },
      });
      const kumarAuth = await signInAs(t, kumar.phone);
      at('09:40');
      const late = await as(kumarAuth)
        .post('/attendance/check-in', FAR_AWAY)
        .expect(200);
      expect(late.body.data).toMatchObject({
        status: 'LATE',
        checkInLocationFlag: 'OUTSIDE_SITE',
      });
    });

    it('needs a location or a reason, and flags mock locations', async () => {
      const raviAuth = await signInAs(t, ravi.phone);
      at('09:00');
      const missing = await as(raviAuth)
        .post('/attendance/check-in', {})
        .expect(400);
      expect(missing.body.code).toBe('LOCATION_REQUIRED');
      const mocked = await as(raviAuth)
        .post('/attendance/check-in', { ...ON_SITE, isMocked: true })
        .expect(200);
      expect(mocked.body.data.checkInLocationFlag).toBe('MOCKED');

      const kumar = await createUser(t.prisma);
      await t.prisma.staffAssignment.create({
        data: { staffId: kumar.id, siteId: site.id, engineerId: arun.id },
      });
      const denied = await as(await signInAs(t, kumar.phone))
        .post('/attendance/check-in', { locationProblem: 'PERMISSION_DENIED' })
        .expect(200);
      expect(denied.body.data.checkInLocationFlag).toBe('PERMISSION_DENIED');
    });

    it('refuses days off and unassigned staff; a short day is a half day', async () => {
      const raviAuth = await signInAs(t, ravi.phone);
      at('09:00', '2026-10-04'); // Sunday
      expect(
        (await as(raviAuth).post('/attendance/check-in', ON_SITE).expect(400))
          .body.code,
      ).toBe('NOT_A_WORKING_DAY');

      const loner = await createUser(t.prisma);
      at('09:00');
      expect(
        (
          await as(await signInAs(t, loner.phone))
            .post('/attendance/check-in', ON_SITE)
            .expect(400)
        ).body.code,
      ).toBe('NOT_ASSIGNED_TO_SITE');

      expect(
        (await as(raviAuth).post('/attendance/check-out', ON_SITE).expect(400))
          .body.code,
      ).toBe('NOT_CHECKED_IN');
      await checkIn(raviAuth, '09:00');
      at('12:00');
      const out = await as(raviAuth)
        .post('/attendance/check-out', FAR_AWAY)
        .expect(200);
      expect(out.body.data).toMatchObject({
        status: 'HALF_DAY',
        workedMinutes: 180,
        checkOutLocationFlag: 'OUTSIDE_SITE',
      });
      expect(
        (await as(raviAuth).post('/attendance/check-out', ON_SITE).expect(409))
          .body.code,
      ).toBe('ALREADY_CHECKED_OUT');
    });

    it('lets admins mark and correct days, with scoped lists and auto-absent', async () => {
      const adminAuth = await signInAs(t, admin.phone);
      const kumar = await createUser(t.prisma, { name: 'Kumar' });
      await t.prisma.staffAssignment.create({
        data: { staffId: kumar.id, siteId: site.id, engineerId: arun.id },
      });
      await checkIn(await signInAs(t, ravi.phone), '09:00');

      const marked = await as(adminAuth)
        .post('/attendance', {
          staffId: kumar.id,
          date: DAY,
          status: 'PRESENT',
          checkInAt: ist('09:00').toISOString(),
          note: 'Phone lost',
        })
        .expect(201);
      const corrected = await as(adminAuth)
        .patch(`/attendance/${marked.body.data.id}`, {
          status: 'HALF_DAY',
          note: 'Left at noon',
        })
        .expect(200);
      expect(corrected.body.data).toMatchObject({
        status: 'HALF_DAY',
        correctionNote: 'Left at noon',
      });
      expect(
        await t.prisma.auditLog.count({
          where: { action: { startsWith: 'attendance.' } },
        }),
      ).toBe(2);

      const other = await createUser(t.prisma, { role: 'ENGINEER' });
      const outsider = await createUser(t.prisma, { name: 'Elsewhere' });
      await createSite(t.prisma, {
        createdById: admin.id,
        engineerIds: [other.id],
        staffIds: [outsider.id],
      });
      const arunView = await as(await signInAs(t, arun.phone))
        .get(`/attendance?date=${DAY}`)
        .expect(200);
      expect(
        arunView.body.data
          .map((r: { staff: { name: string } }) => r.staff.name)
          .sort(),
      ).toEqual(['Kumar', 'Ravi']);
      await as(await signInAs(t, arun.phone))
        .post('/attendance', {})
        .expect(403);

      const absentees = t.app.get(AttendanceService);
      expect(await absentees.markAbsentees(DAY)).toBe(1); // Elsewhere never came
      expect(await absentees.markAbsentees(DAY)).toBe(0);
      expect(await absentees.markAbsentees('2026-10-04')).toBe(0); // Sunday
    });
  });

  describe('staff updates', () => {
    it('accepts one photo update per slot, judged by the server clock', async () => {
      const raviAuth = await signInAs(t, ravi.phone);
      at('09:30');
      expect((await sendUpdate(raviAuth).expect(400)).body.code).toBe(
        'SLOT_NOT_OPEN',
      );
      at('10:30');
      expect((await sendUpdate(raviAuth).expect(400)).body.code).toBe(
        'NOT_CHECKED_IN',
      );

      await checkIn(raviAuth, '09:05');
      at('10:30');
      const id = randomUUID();
      const created = await sendUpdate(raviAuth, {
        clientSubmissionId: id,
      }).expect(201);
      expect(created.body.data).toMatchObject({
        slot: 'MORNING',
        workDate: DAY,
        submittedOffline: false,
        location: { flag: 'OK' },
        photoSource: 'CAMERA',
        image: {
          status: 'AVAILABLE',
          expiresAt: ist('10:30', '2026-10-06').toISOString(),
        },
        engineer: { id: arun.id },
      });

      // The stored photo is smaller and carries no metadata.
      const row = await t.prisma.staffUpdate.findUniqueOrThrow({
        where: { id: created.body.data.id },
      });
      const stored = await sharp(
        resolve('.test-storage', row.imageKey!),
      ).metadata();
      expect(Math.max(stored.width!, stored.height!)).toBe(1600);
      expect(stored.exif).toBeUndefined();

      // A retry of the same submission returns it; a second one for the slot is refused.
      const retry = await sendUpdate(raviAuth, {
        clientSubmissionId: id,
      }).expect(200);
      expect(retry.body.data.id).toBe(created.body.data.id);
      expect((await sendUpdate(raviAuth).expect(409)).body.code).toBe(
        'UPDATE_ALREADY_SUBMITTED',
      );

      // The engineer and the admin are told.
      const notified = await t.prisma.notification.findMany({
        where: { type: 'STAFF_UPDATE' },
      });
      expect(notified.map((n) => n.recipientId).sort()).toEqual(
        [admin.id, arun.id].sort(),
      );
      expect(notified[0].title).toBe('Ravi submitted Morning Update');
    });

    it('checks the photo and the fields', async () => {
      const raviAuth = await signInAs(t, ravi.phone);
      await checkIn(raviAuth);
      at('10:30');
      expect(
        (
          await sendUpdate(raviAuth, {}, Buffer.from('not an image')).expect(
            400,
          )
        ).body.code,
      ).toBe('INVALID_IMAGE');
      const noPhoto = await sendUpdate(raviAuth, {}, null).expect(400);
      expect(noPhoto.body).toMatchObject({
        code: 'VALIDATION_FAILED',
        details: [{ field: 'photo' }],
      });
      expect(
        (await sendUpdate(raviAuth, { description: ' ' }).expect(400)).body
          .code,
      ).toBe('VALIDATION_FAILED');
      expect(
        (await sendUpdate(raviAuth, { slot: 'NIGHT' }).expect(400)).body.code,
      ).toBe('VALIDATION_FAILED');
      const future = await sendUpdate(raviAuth, {
        capturedAt: ist('10:40').toISOString(),
      }).expect(400);
      expect(future.body.details[0].field).toBe('capturedAt');
      const gallery = await sendUpdate(raviAuth, {
        photoSource: 'GALLERY',
      }).expect(201);
      expect(gallery.body.data.photoSource).toBe('GALLERY');
      expect(await t.prisma.staffUpdate.count()).toBe(1);
    });

    it('accepts offline captures taken inside the window for a while after it', async () => {
      const raviAuth = await signInAs(t, ravi.phone);
      await checkIn(raviAuth);
      at('14:00');
      const late = await sendUpdate(raviAuth, {
        capturedAt: ist('11:50').toISOString(),
      }).expect(201);
      expect(late.body.data).toMatchObject({
        slot: 'MORNING',
        submittedOffline: true,
        capturedAt: ist('11:50').toISOString(),
      });

      at('15:30'); // Afternoon closed at 15:15 and was captured too late to count.
      const outside = await sendUpdate(raviAuth, {
        slot: 'AFTERNOON',
        capturedAt: ist('15:20').toISOString(),
      }).expect(400);
      expect(outside.body.code).toBe('SLOT_CLOSED');
      at('18:20'); // 15:15 + 180 minutes has passed.
      const tooLate = await sendUpdate(raviAuth, {
        slot: 'AFTERNOON',
        capturedAt: ist('14:50').toISOString(),
      }).expect(400);
      expect(tooLate.body.code).toBe('SLOT_CLOSED');
    });

    it('lists updates by role and returns the staff home screen', async () => {
      const raviAuth = await signInAs(t, ravi.phone);
      await checkIn(raviAuth);
      at('10:45');
      await sendUpdate(raviAuth).expect(201);
      at('13:10');
      const today = await as(raviAuth).get('/me/today').expect(200);
      expect(today.body.data).toMatchObject({
        date: DAY,
        isWorkingDay: true,
        assignment: {
          site: { id: site.id, name: 'ABC' },
          engineer: { id: arun.id },
        },
        attendance: { status: 'PRESENT' },
        rules: { requireCheckIn: true, allowGallery: true },
      });
      expect(
        today.body.data.slots.map((s: { state: string }) => s.state),
      ).toEqual(['SUBMITTED', 'PENDING', 'UPCOMING']);

      const other = await createUser(t.prisma, { role: 'ENGINEER' });
      expect(
        (
          await as(await signInAs(t, other.phone))
            .get('/staff-updates')
            .expect(200)
        ).body.data,
      ).toEqual([]);
      expect(
        (
          await as(await signInAs(t, arun.phone))
            .get(`/staff-updates?date=${DAY}`)
            .expect(200)
        ).body.meta.total,
      ).toBe(1);
      expect(
        (await as(raviAuth).get('/staff-updates').expect(200)).body.meta.total,
      ).toBe(1);
      await as(await signInAs(t, admin.phone))
        .get('/me/today')
        .expect(403);
    });
  });

  describe('photo review and deletion', () => {
    async function submitted(): Promise<string> {
      const raviAuth = await signInAs(t, ravi.phone);
      await checkIn(raviAuth);
      at('10:30');
      return (await sendUpdate(raviAuth).expect(201)).body.data.id as string;
    }

    it('deletes the photo once the engineer and an admin have seen it, keeping the record', async () => {
      const id = await submitted();
      const arunAuth = await signInAs(t, arun.phone);
      const adminAuth = await signInAs(t, admin.phone);

      const link = await as(arunAuth)
        .get(`/staff-updates/${id}/image`)
        .expect(200);
      const image = await t
        .http()
        .get(`/api/v1${link.body.data.url as string}`)
        .expect(200);
      expect(image.headers['content-type']).toBe('image/jpeg');
      expect(image.headers['cache-control']).toBe('private, no-store');
      await t
        .http()
        .get(`/api/v1${link.body.data.url as string}x`)
        .expect(404); // tampered signature

      // Another engineer on the site can look, but only the responsible engineer counts.
      const prakash = await createUser(t.prisma, { role: 'ENGINEER' });
      await t.prisma.engineerAssignment.create({
        data: { siteId: site.id, engineerId: prakash.id },
      });
      at('11:00');
      await as(await signInAs(t, prakash.phone))
        .post(`/staff-updates/${id}/views`)
        .expect(200);
      await as(adminAuth).post(`/staff-updates/${id}/views`).expect(200);
      expect(
        (await as(adminAuth).get(`/staff-updates/${id}`).expect(200)).body.data
          .image.status,
      ).toBe('AVAILABLE');

      at('11:05');
      const viewed = await as(arunAuth)
        .post(`/staff-updates/${id}/views`)
        .expect(200);
      expect(viewed.body.data).toMatchObject({
        engineerViewedAt: ist('11:05').toISOString(),
        adminViewedAt: ist('11:00').toISOString(),
        image: {
          status: 'READY_FOR_DELETION',
          expiresAt: ist('11:35').toISOString(),
        },
      });
      await as(await signInAs(t, ravi.phone))
        .post(`/staff-updates/${id}/views`)
        .expect(403);

      const cleanup = t.app.get(ImageCleanupService);
      expect(await cleanup.deleteDue(ist('11:30'))).toBe(0); // still in the grace period
      const key = (
        await t.prisma.staffUpdate.findUniqueOrThrow({ where: { id } })
      ).imageKey!;
      expect(await cleanup.deleteDue(ist('11:36'))).toBe(1);
      expect(existsSync(resolve('.test-storage', key))).toBe(false);

      const gone = await as(adminAuth).get(`/staff-updates/${id}`).expect(200);
      expect(gone.body.data.image).toMatchObject({
        status: 'DELETED',
        deleteReason: 'ALL_VIEWED',
      });
      expect(gone.body.data.description).toBe('Plastering the first floor');
      expect(
        (await as(adminAuth).get(`/staff-updates/${id}/image`).expect(410)).body
          .code,
      ).toBe('IMAGE_DELETED');
    });

    it('deletes unreviewed photos when they expire, and sweeps orphaned files', async () => {
      const id = await submitted();
      const cleanup = t.app.get(ImageCleanupService);
      expect(await cleanup.deleteDue(ist('10:29', '2026-10-06'))).toBe(0);
      expect(await cleanup.deleteDue(ist('10:31', '2026-10-06'))).toBe(1);
      const row = await t.prisma.staffUpdate.findUniqueOrThrow({
        where: { id },
      });
      expect(row).toMatchObject({
        imageStatus: 'DELETED',
        imageDeleteReason: 'EXPIRED',
        imageKey: null,
      });

      const storage = t.app.get(
        (await import('../src/storage/storage.provider.js')).StorageProvider,
      );
      await storage.put(`staff/${DAY}/orphan.jpg`, photo, 'image/jpeg');
      // Looks back from the given day; the file is old enough not to be a live upload.
      expect(await cleanup.sweepOrphans(ist('12:00', '2026-10-06'))).toBe(1);
      expect(await cleanup.sweepOrphans(ist('12:00', '2026-10-06'))).toBe(0);
    });
  });

  describe('missed updates and reminders', () => {
    it('records each miss once, alerts the engineer and admins once, and clears on a late arrival', async () => {
      const kumar = await createUser(t.prisma, { name: 'Kumar' });
      const absent = await createUser(t.prisma, { name: 'Absent' });
      for (const person of [kumar, absent]) {
        await t.prisma.staffAssignment.create({
          data: { staffId: person.id, siteId: site.id, engineerId: arun.id },
        });
      }
      const raviAuth = await signInAs(t, ravi.phone);
      const kumarAuth = await signInAs(t, kumar.phone);
      await checkIn(raviAuth);
      await checkIn(kumarAuth);
      at('10:30');
      await sendUpdate(raviAuth).expect(201);

      const missed = t.app.get(MissedUpdatesService);
      expect(await missed.remind(ist('11:35'))).toBe(2); // Kumar and Absent still owe the Morning update
      expect(await missed.remind(ist('11:45'))).toBe(0);
      expect(await missed.detect(ist('12:10'))).toBe(0); // grace period
      expect(await missed.detect(ist('12:16'))).toBe(1); // Kumar; Absent never checked in
      expect(await missed.detect(ist('12:30'))).toBe(0);

      const alerts = await t.prisma.notification.findMany({
        where: { type: 'MISSING_UPDATE', dedupeKey: { startsWith: 'missed:' } },
      });
      expect(alerts.map((a) => a.recipientId).sort()).toEqual(
        [admin.id, arun.id].sort(),
      );
      expect(alerts[0].title).toBe(
        'Kumar has not submitted the Morning Update',
      );

      // Kumar's phone was offline; the update arrives within the acceptance period.
      at('13:00');
      await sendUpdate(kumarAuth, {
        capturedAt: ist('11:55').toISOString(),
      }).expect(201);
      const record = await t.prisma.missedUpdate.findFirstOrThrow({
        where: { staffId: kumar.id },
      });
      expect(record.resolvedAt).toEqual(ist('13:00'));
    });
  });

  describe('notifications', () => {
    it('lists, counts and marks only the caller’s own notifications', async () => {
      const raviAuth = await signInAs(t, ravi.phone);
      await checkIn(raviAuth);
      at('10:30');
      await sendUpdate(raviAuth).expect(201);
      const arunAuth = await signInAs(t, arun.phone);

      expect(
        (await as(arunAuth).get('/notifications/unread-count').expect(200)).body
          .data,
      ).toEqual({ count: 1 });
      const list = await as(arunAuth).get('/notifications').expect(200);
      expect(list.body.data[0]).toMatchObject({
        type: 'STAFF_UPDATE',
        isRead: false,
        referenceType: 'STAFF_UPDATE',
      });
      const id = list.body.data[0].id as string;

      await as(raviAuth).post(`/notifications/${id}/read`).expect(404);
      await as(arunAuth).post(`/notifications/${id}/read`).expect(200);
      expect(
        (await as(arunAuth).get('/notifications?unreadOnly=true').expect(200))
          .body.data,
      ).toEqual([]);

      const adminAuth = await signInAs(t, admin.phone);
      expect(
        (await as(adminAuth).post('/notifications/read-all').expect(200)).body
          .data,
      ).toEqual({ updated: 1 });
      expect(
        (await as(adminAuth).get('/notifications/unread-count').expect(200))
          .body.data,
      ).toEqual({ count: 0 });
    });
  });
});
