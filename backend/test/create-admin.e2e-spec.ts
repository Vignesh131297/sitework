import { createAdmin } from '../src/people/create-admin.js';
import { resetDatabase } from './support/fixtures.js';
import { createTestApp, type TestApp } from './support/test-app.js';

// What `node dist/cli/create-admin.js` does on a new installation.
describe('Creating an admin from the command line (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.close();
  });

  beforeEach(async () => {
    await resetDatabase(t.prisma);
  });

  it('creates the first admin, who must replace the temporary password', async () => {
    const admin = await createAdmin(t.prisma, {
      name: '  Site Owner  ',
      phone: '98765 43210',
      email: 'Owner@Example.com',
    });
    expect(admin).toMatchObject({
      name: 'Site Owner',
      phone: '+919876543210',
      employeeCode: 'ADM-001',
    });

    const login = await t
      .http()
      .post('/api/v1/auth/login')
      .send({
        identifier: 'owner@example.com',
        password: admin.temporaryPassword,
      })
      .expect(200);
    expect(login.body.data.user).toMatchObject({
      role: 'ADMIN',
      mustChangePassword: true,
    });
    expect(
      await t.prisma.auditLog.count({
        where: { entityId: admin.id, action: 'user.created' },
      }),
    ).toBe(1);

    const second = await createAdmin(t.prisma, {
      name: 'Partner',
      phone: '+919876500000',
    });
    expect(second.employeeCode).toBe('ADM-002');
  });

  it('refuses bad or taken details', async () => {
    await createAdmin(t.prisma, { name: 'Owner', phone: '+919876543210' });
    await expect(
      createAdmin(t.prisma, { name: 'Again', phone: '9876543210' }),
    ).rejects.toThrow('already belongs to Owner');
    await expect(
      createAdmin(t.prisma, { name: 'X', phone: '12345' }),
    ).rejects.toThrow('mobile number');
    await expect(
      createAdmin(t.prisma, { name: ' ', phone: '+919876500001' }),
    ).rejects.toThrow('name');
    await expect(
      createAdmin(t.prisma, {
        name: 'Y',
        phone: '+919876500002',
        email: 'not-an-email',
      }),
    ).rejects.toThrow('e-mail');
    expect(await t.prisma.user.count()).toBe(1);
  });
});
