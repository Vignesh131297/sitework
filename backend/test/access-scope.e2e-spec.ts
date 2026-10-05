import { randomUUID } from 'node:crypto';
import { toDbDate } from '../src/common/time/business-time.js';
import { createSite, createUser, resetDatabase } from './support/fixtures.js';
import { createTestApp, signInAs, type TestApp } from './support/test-app.js';

const ist = (date: string, time: string) =>
  new Date(`${date}T${time}:00+05:30`);

/**
 * Two teams: Arun runs ABC with Ravi; Prakash runs Villa with Kumar. Nobody
 * reaches the other team's records by id, and lists never include them. Each
 * check has a control call from the right person, so a 404 means "not yours",
 * not "wrong id".
 */
describe('Access across teams (e2e)', () => {
  let t: TestApp;
  const auth = {} as Record<'arun' | 'prakash' | 'ravi' | 'kumar', string>;
  const ids = {} as Record<
    | 'abc'
    | 'villa'
    | 'ravi'
    | 'kumar'
    | 'raviUpdate'
    | 'kumarUpdate'
    | 'arunUpdate'
    | 'abcIssue',
    string
  >;

  beforeAll(async () => {
    t = await createTestApp();
    await resetDatabase(t.prisma);
    t.clock.set(ist('2026-10-05', '12:00'));
    const admin = await createUser(t.prisma, { role: 'ADMIN' });
    const arun = await createUser(t.prisma, { role: 'ENGINEER' });
    const prakash = await createUser(t.prisma, { role: 'ENGINEER' });
    const ravi = await createUser(t.prisma, { name: 'Ravi' });
    const kumar = await createUser(t.prisma, { name: 'Kumar' });
    const abc = await createSite(t.prisma, {
      createdById: admin.id,
      engineerIds: [arun.id],
      staffIds: [ravi.id],
    });
    const villa = await createSite(t.prisma, {
      createdById: admin.id,
      engineerIds: [prakash.id],
      staffIds: [kumar.id],
    });
    Object.assign(ids, {
      abc: abc.id,
      villa: villa.id,
      ravi: ravi.id,
      kumar: kumar.id,
    });
    for (const [name, user] of Object.entries({ arun, prakash, ravi, kumar }))
      auth[name as keyof typeof auth] = await signInAs(t, user.phone);

    const workDate = toDbDate('2026-10-05');
    const update = (staffId: string, siteId: string, engineerId: string) =>
      t.prisma.staffUpdate.create({
        data: {
          clientSubmissionId: randomUUID(),
          staffId,
          siteId,
          engineerId,
          workDate,
          slot: 'MORNING',
          description: 'Work',
          locationFlag: 'OK',
          photoSource: 'CAMERA',
          capturedAt: ist('2026-10-05', '10:30'),
          imageKey: `staff/2026-10-05/${randomUUID()}.jpg`,
          imageBytes: 1000,
          imageMime: 'image/jpeg',
          imageExpiresAt: ist('2026-10-06', '10:30'),
        },
      });
    for (const [staffId, siteId] of [
      [ravi.id, abc.id],
      [kumar.id, villa.id],
    ])
      await t.prisma.attendance.create({
        data: {
          staffId,
          siteId,
          workDate,
          status: 'PRESENT',
          checkInAt: ist('2026-10-05', '09:00'),
        },
      });
    ids.raviUpdate = (await update(ravi.id, abc.id, arun.id)).id;
    ids.kumarUpdate = (await update(kumar.id, villa.id, prakash.id)).id;
    ids.arunUpdate = (
      await t.prisma.engineerUpdate.create({
        data: {
          engineerId: arun.id,
          siteId: abc.id,
          type: 'REMARK',
          description: 'Note',
        },
      })
    ).id;
    ids.abcIssue = (
      await t.prisma.issue.create({
        data: {
          siteId: abc.id,
          reportedById: arun.id,
          title: 'Crack',
          description: 'Wall',
        },
      })
    ).id;
  });

  afterAll(async () => {
    await t.close();
  });

  const get = (who: keyof typeof auth, url: string) =>
    t.http().get(`/api/v1${url}`).set('authorization', auth[who]);
  const send = (
    who: keyof typeof auth,
    method: 'post' | 'patch',
    url: string,
    fields: Record<string, string>,
  ) => {
    // Multipart, as the app sends these forms (with optional photos).
    const request = t
      .http()
      [method](`/api/v1${url}`)
      .set('authorization', auth[who]);
    for (const [name, value] of Object.entries(fields))
      request.field(name, value);
    return request;
  };
  const listIds = async (who: keyof typeof auth, url: string) =>
    ((await get(who, url).expect(200)).body.data as { id: string }[]).map(
      (row) => row.id,
    );

  it("keeps an engineer out of another team's site, staff and records", async () => {
    const theirs = [
      `/sites/${ids.abc}`,
      `/sites/${ids.abc}/day`,
      `/staff/${ids.ravi}`,
      `/staff-updates/${ids.raviUpdate}`,
      `/staff-updates/${ids.raviUpdate}/image`,
      `/engineer-updates/${ids.arunUpdate}`,
      `/issues/${ids.abcIssue}`,
    ];
    for (const url of theirs) {
      await get('arun', url).expect(200);
      expect((await get('prakash', url)).status, url).toBe(404);
    }
    await t
      .http()
      .post(`/api/v1/staff-updates/${ids.raviUpdate}/views`)
      .set('authorization', auth.prakash)
      .expect(404);
    await t
      .http()
      .patch(`/api/v1/issues/${ids.abcIssue}`)
      .set('authorization', auth.prakash)
      .send({ status: 'RESOLVED', resolutionNote: 'Not mine' })
      .expect(404);
    expect(
      (await t.prisma.issue.findUniqueOrThrow({ where: { id: ids.abcIssue } }))
        .status,
    ).toBe('OPEN');
  });

  it("won't let an engineer file reports or issues on another team's site", async () => {
    const issue = {
      siteId: ids.abc,
      title: 'Leak',
      description: 'Pipe',
      priority: 'HIGH',
    };
    await send('prakash', 'post', '/issues', issue).expect(404);
    await send('prakash', 'post', '/engineer-updates', {
      siteId: ids.abc,
      type: 'REMARK',
      description: 'Not my site',
    }).expect(404);
    expect(await t.prisma.issue.count({ where: { siteId: ids.abc } })).toBe(1);
    expect(
      await t.prisma.engineerUpdate.count({ where: { siteId: ids.abc } }),
    ).toBe(1);
  });

  it("filters an engineer's lists to their sites, whatever the filter says", async () => {
    for (const url of [
      `/staff-updates?siteId=${ids.abc}`,
      `/staff-updates?staffId=${ids.ravi}`,
      `/attendance?siteId=${ids.abc}`,
      `/engineer-updates?siteId=${ids.abc}`,
      `/issues?siteId=${ids.abc}`,
      `/staff?siteId=${ids.abc}`,
    ]) {
      expect(await listIds('prakash', url), url).toEqual([]);
    }
    expect(await listIds('prakash', '/sites')).toEqual([ids.villa]);
    expect(await listIds('prakash', '/staff')).toEqual([ids.kumar]);
    expect(await listIds('prakash', '/staff-updates')).toEqual([
      ids.kumarUpdate,
    ]);
  });

  it('keeps staff to their own photos, days and site', async () => {
    for (const url of [
      `/staff-updates/${ids.raviUpdate}`,
      `/staff-updates/${ids.raviUpdate}/image`,
    ]) {
      await get('ravi', url).expect(200);
      expect((await get('kumar', url)).status, url).toBe(404);
    }
    await get('kumar', `/sites/${ids.abc}`).expect(404);
    await get('kumar', `/sites/${ids.villa}`).expect(200);

    expect(
      await listIds('kumar', `/staff-updates?staffId=${ids.ravi}`),
    ).toEqual([]);
    expect(await listIds('kumar', '/staff-updates')).toEqual([ids.kumarUpdate]);
    const days = (
      await get('kumar', `/attendance?siteId=${ids.abc}`).expect(200)
    ).body.data;
    expect(days).toEqual([]);
    const own = (await get('kumar', '/attendance').expect(200)).body.data;
    expect(own.map((d: { staff: { id: string } }) => d.staff.id)).toEqual([
      ids.kumar,
    ]);
  });

  it('takes the site from the assignment, never from the app', async () => {
    const response = await send('kumar', 'post', '/staff-updates', {
      clientSubmissionId: randomUUID(),
      siteId: ids.abc,
      slot: 'MORNING',
      description: 'Trying another site',
      capturedAt: new Date().toISOString(),
    }).expect(400);
    expect(response.body.details).toContainEqual(
      expect.objectContaining({ field: 'siteId' }),
    );
  });
});
