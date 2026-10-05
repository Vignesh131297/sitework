import { PushDispatcher } from '../src/push/push-dispatcher.service.js';
import { createUser, resetDatabase } from './support/fixtures.js';
import { createTestApp, signInAs, type TestApp } from './support/test-app.js';

const NOW = new Date('2026-10-05T10:00:00+05:30');
const TOKEN_A = 'fcm-token-aaaaaaaaaaaaaaaaaaaaaaaa';
const TOKEN_B = 'fcm-token-bbbbbbbbbbbbbbbbbbbbbbbb';

describe('Push notifications (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.close();
  });

  beforeEach(async () => {
    await resetDatabase(t.prisma);
    t.clock.set(NOW);
    t.push.sent.length = 0;
    t.push.dead.clear();
    t.push.failing = false;
  });

  const as = (auth: string) => ({
    post: (url: string, body?: object) =>
      t.http().post(`/api/v1${url}`).set('authorization', auth).send(body),
    delete: (url: string, body?: object) =>
      t.http().delete(`/api/v1${url}`).set('authorization', auth).send(body),
  });

  async function notify(
    recipientId: string,
    minutesAgo = 0,
    title = 'Ravi submitted Morning Update',
  ) {
    return t.prisma.notification.create({
      data: {
        recipientId,
        type: 'STAFF_UPDATE',
        title,
        message: 'ABC · 10:42 AM',
        referenceType: 'STAFF_UPDATE',
        referenceId: '01a10632-754c-74d9-8f84-69dba09405b2',
        data: { siteId: 'site-1' },
        createdAt: new Date(NOW.getTime() - minutesAgo * 60_000),
      },
    });
  }

  const dispatch = () => t.app.get(PushDispatcher).dispatch(NOW);

  it('registers devices, pushes to all of them, and removes a device on sign-out', async () => {
    const arun = await createUser(t.prisma, { role: 'ENGINEER' });
    const auth = await signInAs(t, arun.phone);
    await as(auth)
      .post('/me/devices', { fcmToken: TOKEN_A, appVersion: '0.1.0' })
      .expect(200);
    await as(auth).post('/me/devices', { fcmToken: TOKEN_B }).expect(200);
    await as(auth).post('/me/devices', { fcmToken: TOKEN_A }).expect(200); // again: no duplicate
    expect(await t.prisma.deviceToken.count()).toBe(2);

    const n = await notify(arun.id);
    expect(await dispatch()).toEqual({ sent: 1, failed: 0, noDevice: 0 });
    expect(t.push.sent.map((m) => m.token).sort()).toEqual([TOKEN_A, TOKEN_B]);
    expect(t.push.sent[0]).toMatchObject({
      title: 'Ravi submitted Morning Update',
      body: 'ABC · 10:42 AM',
      data: {
        notificationId: n.id,
        type: 'STAFF_UPDATE',
        referenceType: 'STAFF_UPDATE',
        siteId: 'site-1',
      },
    });
    const sent = await t.prisma.notification.findUniqueOrThrow({
      where: { id: n.id },
    });
    expect(sent).toMatchObject({ pushStatus: 'SENT', pushSentAt: NOW });

    // Nothing new: nothing is pushed twice.
    expect(await dispatch()).toEqual({ sent: 0, failed: 0, noDevice: 0 });

    expect(
      (await as(auth).delete('/me/devices', { fcmToken: TOKEN_B }).expect(200))
        .body.data,
    ).toEqual({ removed: 1 });
    await as(auth).post('/me/devices', { fcmToken: 'short' }).expect(400);
  });

  it('moves a token to whoever signs in on that phone', async () => {
    const first = await createUser(t.prisma, { role: 'STAFF' });
    const second = await createUser(t.prisma, { role: 'STAFF' });
    await as(await signInAs(t, first.phone))
      .post('/me/devices', { fcmToken: TOKEN_A })
      .expect(200);
    await as(await signInAs(t, second.phone))
      .post('/me/devices', { fcmToken: TOKEN_A })
      .expect(200);
    const device = await t.prisma.deviceToken.findUniqueOrThrow({
      where: { fcmToken: TOKEN_A },
    });
    expect(device.userId).toBe(second.id);
    // The first user can't remove the second user's device.
    await as(await signInAs(t, first.phone))
      .delete('/me/devices', { fcmToken: TOKEN_A })
      .expect(200);
    expect(await t.prisma.deviceToken.count()).toBe(1);
  });

  it('marks rows without a device, forgets dead tokens, retries failures, and skips stale rows', async () => {
    const admin = await createUser(t.prisma, { role: 'ADMIN' });
    const noPhone = await createUser(t.prisma, { role: 'ADMIN' });
    const inactive = await createUser(t.prisma, {
      role: 'ENGINEER',
      isActive: false,
    });
    await t.prisma.deviceToken.createMany({
      data: [
        { userId: admin.id, fcmToken: TOKEN_A },
        { userId: inactive.id, fcmToken: TOKEN_B },
      ],
    });
    const forNoPhone = await notify(noPhone.id);
    const forInactive = await notify(inactive.id);
    const stale = await notify(admin.id, 90, 'Old news');

    // FCM is down: the row stays pending and is retried.
    t.push.failing = true;
    const forAdmin = await notify(admin.id);
    expect(await dispatch()).toMatchObject({ sent: 0, noDevice: 2 });
    expect(
      await t.prisma.notification.findUniqueOrThrow({
        where: { id: forAdmin.id },
      }),
    ).toMatchObject({
      pushStatus: 'PENDING',
      pushAttempts: 1,
      pushError: 'FCM unavailable',
    });
    for (const id of [forNoPhone.id, forInactive.id]) {
      expect(
        (await t.prisma.notification.findUniqueOrThrow({ where: { id } }))
          .pushStatus,
      ).toBe('NO_DEVICE');
    }
    expect(
      await t.prisma.notification.findUniqueOrThrow({
        where: { id: stale.id },
      }),
    ).toMatchObject({
      pushStatus: 'FAILED',
      pushError: 'Too old to push',
    });

    // Back up, but the app was uninstalled: the token is deleted.
    t.push.failing = false;
    t.push.dead.add(TOKEN_A);
    await dispatch();
    expect(
      await t.prisma.deviceToken.findUnique({ where: { fcmToken: TOKEN_A } }),
    ).toBeNull();
    await dispatch(); // no device left for the third try
    expect(
      (
        await t.prisma.notification.findUniqueOrThrow({
          where: { id: forAdmin.id },
        })
      ).pushStatus,
    ).toBe('NO_DEVICE');
    expect(t.push.sent.map((m) => m.title)).not.toContain('Old news');
  });
});
