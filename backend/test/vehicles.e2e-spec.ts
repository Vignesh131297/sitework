import { randomUUID } from 'node:crypto';
import { createSite, createUser, resetDatabase } from './support/fixtures.js';
import { createTestApp, signInAs, type TestApp } from './support/test-app.js';

// Monday 5 Oct 2026, India Standard Time.
const DAY = '2026-10-05';
const ist = (time: string, date = DAY) => new Date(`${date}T${time}:00+05:30`);

type Who = 'admin' | 'boss' | 'arun' | 'ravi' | 'selvam' | 'store';

/**
 * Admin and Boss are admins. Arun is an engineer; Ravi and Selvam are staff on
 * his site; Store runs a godown. Admins give company vehicles to staff and
 * engineers; whoever holds one asks for repair money, and only an admin decides.
 */
describe('Vehicles (e2e)', () => {
  let t: TestApp;
  const auth = {} as Record<Who, string>;
  const ids = {} as Record<Who, string>;

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
      boss: await createUser(t.prisma, { role: 'ADMIN', name: 'Boss' }),
      arun: await createUser(t.prisma, { role: 'ENGINEER', name: 'Arun' }),
      ravi: await createUser(t.prisma, { name: 'Ravi' }),
      selvam: await createUser(t.prisma, { name: 'Selvam' }),
      store: await createUser(t.prisma, {
        role: 'GODOWN_MANAGER',
        name: 'Store',
      }),
    };
    for (const [who, user] of Object.entries(people)) {
      auth[who as Who] = await signInAs(t, user.phone);
      ids[who as Who] = user.id;
    }
    await createSite(t.prisma, {
      name: 'ABC',
      createdById: ids.admin,
      engineerIds: [ids.arun],
      staffIds: [ids.ravi, ids.selvam],
    });
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
  });

  const addVehicle = async (body: object = {}): Promise<{ id: string }> =>
    (
      await as('admin')
        .post('/vehicles', {
          type: 'BIKE',
          registrationNo: 'TN 09 BK 4821',
          makeModel: 'Hero Splendor Plus',
          ...body,
        })
        .expect(201)
    ).body.data;

  const give = (vehicleId: string, who: Who, body: object = {}) =>
    as('admin').post(`/vehicles/${vehicleId}/assign`, {
      userId: ids[who],
      givenOn: DAY,
      ...body,
    });

  const askRepair = (who: Who, body: object = {}) =>
    as(who).post('/vehicle-repair-requests', {
      requestId: randomUUID(),
      amount: '850',
      note: 'Rear tyre puncture',
      ...body,
    });

  const notified = (referenceId: string) =>
    t.prisma.notification.findMany({
      where: { type: 'VEHICLE', referenceId },
      orderBy: { createdAt: 'asc' },
    });

  describe('the list', () => {
    it('is kept by admins, with one entry per registration number', async () => {
      const created = (
        await as('admin')
          .post('/vehicles', {
            type: 'BIKE',
            registrationNo: 'tn 09 bk-4821',
            makeModel: ' Hero Splendor Plus ',
            note: 'With helmet',
          })
          .expect(201)
      ).body.data;
      expect(created).toMatchObject({
        code: expect.stringMatching(/^VH-\d{4}$/),
        type: 'BIKE',
        registrationNo: 'TN09BK4821',
        makeModel: 'Hero Splendor Plus',
        note: 'With helmet',
        isActive: true,
        holder: null,
        history: [],
      });

      // The same plate written another way is the same vehicle.
      const again = await as('admin')
        .post('/vehicles', {
          type: 'SCOOTER',
          registrationNo: 'TN09BK4821',
          makeModel: 'Honda Activa',
        })
        .expect(409);
      expect(again.body.code).toBe('VEHICLE_REGISTRATION_IN_USE');
      await as('admin')
        .post('/vehicles', {
          type: 'BIKE',
          registrationNo: '--',
          makeModel: 'TVS',
        })
        .expect(400);

      const scooter = await addVehicle({
        type: 'SCOOTER',
        registrationNo: 'TN09AZ1164',
        makeModel: 'Honda Activa 6G',
      });
      const edited = (
        await as('admin')
          .patch(`/vehicles/${scooter.id}`, {
            makeModel: 'Honda Activa 125',
            note: '',
          })
          .expect(200)
      ).body.data;
      expect(edited).toMatchObject({
        makeModel: 'Honda Activa 125',
        note: null,
      });
      const clash = await as('admin')
        .patch(`/vehicles/${scooter.id}`, { registrationNo: 'TN09BK4821' })
        .expect(409);
      expect(clash.body.code).toBe('VEHICLE_REGISTRATION_IN_USE');

      const list = (await as('admin').get('/vehicles').expect(200)).body;
      expect(list.meta.total).toBe(2);
      expect(
        (await as('admin').get('/vehicles?q=activa').expect(200)).body.data.map(
          (v: { id: string }) => v.id,
        ),
      ).toEqual([scooter.id]);
      expect(
        (await as('admin').get('/vehicles?q=bk 48').expect(200)).body.data.map(
          (v: { id: string }) => v.id,
        ),
      ).toEqual([created.id]);

      // Only admins see the list or a vehicle.
      for (const who of ['arun', 'ravi', 'store'] as const) {
        await as(who).get('/vehicles').expect(403);
        await as(who).get(`/vehicles/${created.id}`).expect(403);
        await as(who)
          .post('/vehicles', {
            type: 'BIKE',
            registrationNo: 'TN01A1',
            makeModel: 'Any',
          })
          .expect(403);
      }
      await as('admin').get(`/vehicles/${randomUUID()}`).expect(404);
    });
  });

  describe('giving and taking back', () => {
    it('gives a vehicle to one person at a time and keeps the history', async () => {
      const bike = await addVehicle();
      const scooter = await addVehicle({
        type: 'SCOOTER',
        registrationNo: 'TN09AZ1164',
        makeModel: 'Honda Activa 6G',
      });
      expect(
        (await as('ravi').get('/vehicles/mine').expect(200)).body.data,
      ).toEqual({ vehicle: null });

      const given = (
        await give(bike.id, 'ravi', {
          givenOn: '2026-10-01',
          note: 'With helmet',
        }).expect(200)
      ).body.data;
      expect(given.holder).toEqual({
        user: {
          id: ids.ravi,
          name: 'Ravi',
          role: 'STAFF',
          employeeCode: expect.any(String),
        },
        givenOn: '2026-10-01',
        note: 'With helmet',
      });
      expect(given.history).toHaveLength(1);
      expect(given.history[0]).toMatchObject({
        user: { id: ids.ravi },
        givenOn: '2026-10-01',
        returnedOn: null,
        givenBy: { id: ids.admin, name: 'Admin' },
        returnedBy: null,
      });
      const alerts = await notified(bike.id);
      expect(alerts.map((n) => n.recipientId)).toEqual([ids.ravi]);
      expect(alerts[0]).toMatchObject({
        title: 'Hero Splendor Plus · TN09BK4821 was given to you',
        referenceType: 'VEHICLE',
      });
      expect(alerts[0].message).toMatch(/^VH-\d{4} · by Admin$/);

      // Ravi sees his vehicle; the admin sees it on his page.
      expect(
        (await as('ravi').get('/vehicles/mine').expect(200)).body.data.vehicle,
      ).toMatchObject({ id: bike.id, registrationNo: 'TN09BK4821' });
      expect(
        (await as('admin').get(`/staff/${ids.ravi}`).expect(200)).body.data
          .vehicle,
      ).toEqual({
        id: bike.id,
        code: given.code,
        type: 'BIKE',
        registrationNo: 'TN09BK4821',
        makeModel: 'Hero Splendor Plus',
        givenOn: '2026-10-01',
      });
      expect(
        (await as('admin').get(`/staff/${ids.selvam}`).expect(200)).body.data
          .vehicle,
      ).toBeNull();

      // One holder per vehicle, one vehicle per person.
      const taken = await give(bike.id, 'selvam').expect(409);
      expect(taken.body.code).toBe('VEHICLE_ALREADY_GIVEN');
      expect(taken.body.message).toContain('Ravi');
      const second = await give(scooter.id, 'ravi').expect(409);
      expect(second.body.code).toBe('PERSON_HAS_VEHICLE');
      // Not while someone has it.
      const inUse = await as('admin')
        .patch(`/vehicles/${bike.id}`, { isActive: false })
        .expect(409);
      expect(inUse.body.code).toBe('VEHICLE_ALREADY_GIVEN');

      // Only staff and engineers; not in the future; only by an admin.
      await give(scooter.id, 'store').expect(400);
      await give(scooter.id, 'boss').expect(400);
      await give(scooter.id, 'selvam', { givenOn: '2026-10-06' }).expect(400);
      await as('arun')
        .post(`/vehicles/${scooter.id}/assign`, {
          userId: ids.selvam,
          givenOn: DAY,
        })
        .expect(403);
      await give(scooter.id, 'arun').expect(200);

      const filter = async (status: string) =>
        (
          await as('admin').get(`/vehicles?status=${status}`).expect(200)
        ).body.data.map((v: { id: string }) => v.id);
      expect(await filter('GIVEN')).toEqual([bike.id, scooter.id]);
      expect(await filter('FREE')).toEqual([]);
      expect(
        (await as('admin').get('/vehicles?q=ravi').expect(200)).body.data.map(
          (v: { id: string }) => v.id,
        ),
      ).toEqual([bike.id]);

      // Taking it back: not before it was given, not in the future.
      await as('admin')
        .post(`/vehicles/${bike.id}/return`, { returnedOn: '2026-09-30' })
        .expect(400);
      await as('admin')
        .post(`/vehicles/${bike.id}/return`, { returnedOn: '2026-10-06' })
        .expect(400);
      await as('ravi')
        .post(`/vehicles/${bike.id}/return`, { returnedOn: DAY })
        .expect(403);
      const back = (
        await as('boss')
          .post(`/vehicles/${bike.id}/return`, {
            returnedOn: '2026-10-04',
            note: 'Moved to another site',
          })
          .expect(200)
      ).body.data;
      expect(back.holder).toBeNull();
      expect(back.history[0]).toMatchObject({
        returnedOn: '2026-10-04',
        returnNote: 'Moved to another site',
        returnedBy: { id: ids.boss, name: 'Boss' },
      });
      expect((await notified(bike.id)).at(-1)).toMatchObject({
        recipientId: ids.ravi,
        title: 'Hero Splendor Plus · TN09BK4821 was taken back',
      });
      expect(
        (await as('ravi').get('/vehicles/mine').expect(200)).body.data,
      ).toEqual({ vehicle: null });
      const twice = await as('admin')
        .post(`/vehicles/${bike.id}/return`, { returnedOn: DAY })
        .expect(409);
      expect(twice.body.code).toBe('VEHICLE_NOT_GIVEN');
      expect(await filter('FREE')).toEqual([bike.id]);

      // The next holder can't start before it came back.
      await give(bike.id, 'selvam', { givenOn: '2026-10-03' }).expect(400);
      const next = (
        await give(bike.id, 'selvam', { givenOn: '2026-10-04' }).expect(200)
      ).body.data;
      expect(
        next.history.map((h: { user: { name: string } }) => h.user.name),
      ).toEqual(['Selvam', 'Ravi']);

      // Out of use: it can't be given until it is brought back.
      await as('admin')
        .post(`/vehicles/${bike.id}/return`, { returnedOn: DAY })
        .expect(200);
      await as('admin')
        .patch(`/vehicles/${bike.id}`, { isActive: false })
        .expect(200);
      expect(await filter('INACTIVE')).toEqual([bike.id]);
      expect(await filter('FREE')).toEqual([]);
      const off = await give(bike.id, 'ravi').expect(409);
      expect(off.body.code).toBe('VEHICLE_INACTIVE');
    });

    it('lets only one of two admins give the same vehicle', async () => {
      const bike = await addVehicle();
      const results = await Promise.all([
        give(bike.id, 'ravi'),
        as('boss').post(`/vehicles/${bike.id}/assign`, {
          userId: ids.selvam,
          givenOn: DAY,
        }),
      ]);
      expect(results.map((r) => r.status).sort()).toEqual([200, 409]);
      expect(
        await t.prisma.vehicleAssignment.count({
          where: { vehicleId: bike.id, returnedOn: null },
        }),
      ).toBe(1);
    });

    it('frees the vehicle when its holder is deactivated', async () => {
      const bike = await addVehicle();
      await give(bike.id, 'ravi', { givenOn: '2026-10-01' }).expect(200);
      await as('admin')
        .patch(`/staff/${ids.ravi}/status`, { isActive: false })
        .expect(200);
      const after = (await as('admin').get(`/vehicles/${bike.id}`).expect(200))
        .body.data;
      expect(after.holder).toBeNull();
      expect(after.history[0]).toMatchObject({
        returnedOn: DAY,
        returnNote: 'Account deactivated',
        returnedBy: { id: ids.admin },
      });
      // Nor can it go to someone who has left.
      const gone = await give(bike.id, 'ravi').expect(400);
      expect(gone.body.code).toBe('USER_INACTIVE');
    });
  });

  describe('repair money', () => {
    it('is asked for by the holder and decided by an admin only', async () => {
      const bike = await addVehicle();
      const none = await askRepair('ravi').expect(400);
      expect(none.body.code).toBe('NO_VEHICLE');
      await give(bike.id, 'ravi').expect(200);

      await askRepair('ravi', { amount: '0' }).expect(400);
      await askRepair('ravi', { amount: '50000.01' }).expect(400);
      await askRepair('ravi', { note: 'x' }).expect(400);
      // Admins and godown managers don't ask.
      await askRepair('admin').expect(403);
      await askRepair('store').expect(403);

      const requestId = randomUUID();
      const created = (await askRepair('ravi', { requestId }).expect(201)).body
        .data;
      expect(created).toMatchObject({
        code: expect.stringMatching(/^VR-\d{4}$/),
        vehicle: {
          id: bike.id,
          type: 'BIKE',
          registrationNo: 'TN09BK4821',
          makeModel: 'Hero Splendor Plus',
        },
        user: { id: ids.ravi, name: 'Ravi', role: 'STAFF' },
        amount: '850.00',
        note: 'Rear tyre puncture',
        status: 'PENDING',
        reviewedBy: null,
        canApprove: false,
        canCancel: true,
      });
      // A retry of the same form is the same request; someone else's is refused.
      const retry = (await askRepair('ravi', { requestId }).expect(201)).body
        .data;
      expect(retry.id).toBe(created.id);
      expect(await t.prisma.vehicleRepairRequest.count()).toBe(1);

      // Every admin is told; nobody else.
      const alerts = await notified(created.id);
      expect(alerts.map((n) => n.recipientId).sort()).toEqual(
        [ids.admin, ids.boss].sort(),
      );
      expect(alerts[0]).toMatchObject({
        title: 'Ravi asked for ₹850 for a repair',
        referenceType: 'VEHICLE_REPAIR_REQUEST',
      });
      expect(alerts[0].message).toMatch(
        /^VR-\d{4} · Hero Splendor Plus · TN09BK4821$/,
      );

      // The engineer on his site neither sees nor decides it.
      await as('arun')
        .get(`/vehicle-repair-requests/${created.id}`)
        .expect(404);
      await as('arun')
        .post(`/vehicle-repair-requests/${created.id}/approve`, {})
        .expect(403);
      await as('selvam')
        .get(`/vehicle-repair-requests/${created.id}`)
        .expect(404);
      expect(
        (await as('arun').get('/vehicle-repair-requests').expect(200)).body
          .data,
      ).toEqual([]);
      await as('ravi')
        .post(`/vehicle-repair-requests/${created.id}/approve`, {})
        .expect(403);

      const queue = (
        await as('boss')
          .get('/vehicle-repair-requests?toReview=true')
          .expect(200)
      ).body;
      expect(queue.meta.total).toBe(1);
      expect(queue.data[0]).toMatchObject({
        id: created.id,
        canApprove: true,
        canCancel: false,
      });
      expect(
        (
          await as('ravi')
            .get('/vehicle-repair-requests?toReview=true')
            .expect(200)
        ).body.data,
      ).toEqual([]);

      t.clock.set(ist('11:00'));
      const approved = (
        await as('boss')
          .post(`/vehicle-repair-requests/${created.id}/approve`, {
            note: 'Keep the bill',
          })
          .expect(200)
      ).body.data;
      expect(approved).toMatchObject({
        status: 'APPROVED',
        reviewedBy: { id: ids.boss, name: 'Boss' },
        reviewedAt: ist('11:00').toISOString(),
        reviewNote: 'Keep the bill',
        canApprove: false,
      });
      const decided = (await notified(created.id)).find(
        (n) => n.recipientId === ids.ravi,
      );
      expect(decided).toMatchObject({
        title: '₹850 repair money approved',
        message: `${created.code} · by Boss · Keep the bill`,
      });

      // Decided once: the other admin and the asker are told so.
      const late = await as('admin')
        .post(`/vehicle-repair-requests/${created.id}/reject`, {
          reason: 'Too much',
        })
        .expect(409);
      expect(late.body.code).toBe('REQUEST_ALREADY_DECIDED');
      await as('ravi')
        .post(`/vehicle-repair-requests/${created.id}/cancel`)
        .expect(409);

      // It stays on the vehicle after the vehicle is taken back.
      await as('admin')
        .post(`/vehicles/${bike.id}/return`, { returnedOn: DAY })
        .expect(200);
      const onVehicle = (
        await as('admin')
          .get(`/vehicle-repair-requests?vehicleId=${bike.id}`)
          .expect(200)
      ).body.data;
      expect(onVehicle.map((r: { id: string }) => r.id)).toEqual([created.id]);
      expect(
        (
          await as('ravi').get('/vehicle-repair-requests?mine=true').expect(200)
        ).body.data.map((r: { id: string }) => r.id),
      ).toEqual([created.id]);
    });

    it('can be rejected with a reason, or withdrawn while it waits', async () => {
      const bike = await addVehicle();
      await give(bike.id, 'arun').expect(200);

      const first = (await askRepair('arun', { amount: '2400.50' }).expect(201))
        .body.data;
      expect(first).toMatchObject({
        user: { id: ids.arun, role: 'ENGINEER' },
        amount: '2400.50',
      });
      // A reason is needed.
      await as('admin')
        .post(`/vehicle-repair-requests/${first.id}/reject`, {})
        .expect(400);
      const rejected = (
        await as('admin')
          .post(`/vehicle-repair-requests/${first.id}/reject`, {
            reason: 'Get a second quote',
          })
          .expect(200)
      ).body.data;
      expect(rejected).toMatchObject({
        status: 'REJECTED',
        reviewNote: 'Get a second quote',
        canCancel: false,
      });
      expect(
        (await notified(first.id)).find((n) => n.recipientId === ids.arun)
          ?.title,
      ).toBe('₹2,400.50 repair money rejected');

      const second = (await askRepair('arun').expect(201)).body.data;
      // Only the person who asked withdraws it.
      await as('ravi')
        .post(`/vehicle-repair-requests/${second.id}/cancel`)
        .expect(404);
      await as('admin')
        .post(`/vehicle-repair-requests/${second.id}/cancel`)
        .expect(403);
      const withdrawn = (
        await as('arun')
          .post(`/vehicle-repair-requests/${second.id}/cancel`)
          .expect(200)
      ).body.data;
      expect(withdrawn).toMatchObject({
        status: 'CANCELLED',
        canApprove: false,
        canCancel: false,
      });
      // Withdrawing again changes nothing; an admin can no longer decide it.
      await as('arun')
        .post(`/vehicle-repair-requests/${second.id}/cancel`)
        .expect(200);
      const gone = await as('admin')
        .post(`/vehicle-repair-requests/${second.id}/approve`, {})
        .expect(409);
      expect(gone.body.code).toBe('REQUEST_ALREADY_DECIDED');

      const waiting = (
        await as('admin')
          .get('/vehicle-repair-requests?status=PENDING')
          .expect(200)
      ).body.data;
      expect(waiting).toEqual([]);
    });
  });
});
