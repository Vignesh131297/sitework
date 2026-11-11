import { randomUUID } from 'node:crypto';
import { RequestMethod } from '@nestjs/common';
import { METHOD_METADATA, PATH_METADATA } from '@nestjs/common/constants';
import { ModulesContainer } from '@nestjs/core';
import { API_PREFIX } from '../src/app.setup.js';
import {
  IS_PUBLIC_KEY,
  ROLES_KEY,
} from '../src/common/decorators/auth.decorators.js';
import type { Role } from '../src/generated/prisma/enums.js';
import { createUser, resetDatabase } from './support/fixtures.js';
import { createTestApp, signInAs, type TestApp } from './support/test-app.js';

interface Route {
  method: string;
  path: string;
  isPublic: boolean;
  roles: Role[] | undefined;
}

const ROLES: Role[] = ['ADMIN', 'ENGINEER', 'STAFF', 'GODOWN_MANAGER'];

/**
 * Routes any signed-in user may call. Each one scopes its data to the caller
 * (or is the caller's own account), which the feature suites test. A new route
 * without @Roles fails this suite until it is reviewed and added here.
 */
const ANY_SIGNED_IN = [
  'DELETE /api/v1/me/devices',
  'GET /api/v1/attendance',
  'GET /api/v1/holidays',
  'GET /api/v1/me',
  'GET /api/v1/notifications',
  'GET /api/v1/notifications/unread-count',
  'GET /api/v1/settings',
  'GET /api/v1/sites',
  'GET /api/v1/sites/:id',
  'GET /api/v1/staff-updates',
  'GET /api/v1/staff-updates/:id',
  'GET /api/v1/staff-updates/:id/image',
  'PATCH /api/v1/auth/password',
  'POST /api/v1/auth/logout',
  'POST /api/v1/me/devices',
  'POST /api/v1/notifications/:id/read',
  'POST /api/v1/notifications/read-all',
];

/** Every route the app serves, read from the controllers' decorators. */
function discoverRoutes(t: TestApp): Route[] {
  const routes: Route[] = [];
  const meta = <T>(key: string, target: object): T | undefined =>
    Reflect.getMetadata(key, target) as T | undefined;
  for (const module of t.app.get(ModulesContainer).values()) {
    for (const wrapper of module.controllers.values()) {
      const controller = wrapper.metatype as (new () => object) | null;
      if (!controller) continue;
      const base = meta<string | string[]>(PATH_METADATA, controller) ?? '';
      const proto = controller.prototype as Record<string, unknown>;
      for (const name of Object.getOwnPropertyNames(proto)) {
        const handler = proto[name];
        if (name === 'constructor' || typeof handler !== 'function') continue;
        const path = meta<string | string[]>(PATH_METADATA, handler);
        if (path === undefined) continue;
        const method =
          RequestMethod[meta<RequestMethod>(METHOD_METADATA, handler)!];
        const join = (...parts: string[]) =>
          `/${parts
            .flatMap((p) => p.split('/'))
            .filter(Boolean)
            .join('/')}`;
        for (const b of [base].flat())
          for (const p of [path].flat())
            routes.push({
              method,
              path: join(API_PREFIX, b, p),
              isPublic:
                meta<boolean>(IS_PUBLIC_KEY, handler) ??
                meta<boolean>(IS_PUBLIC_KEY, controller) ??
                false,
              roles:
                meta<Role[]>(ROLES_KEY, handler) ??
                meta<Role[]>(ROLES_KEY, controller),
            });
      }
    }
  }
  return routes;
}

const key = (r: Route) => `${r.method} ${r.path}`;

describe('Permission matrix (e2e)', () => {
  let t: TestApp;
  let routes: Route[];
  const auth = {} as Record<Role, string>;

  beforeAll(async () => {
    t = await createTestApp();
    await resetDatabase(t.prisma);
    for (const role of ROLES) {
      const user = await createUser(t.prisma, { role });
      auth[role] = await signInAs(t, user.phone);
    }
    routes = discoverRoutes(t);
  });

  afterAll(async () => {
    await t.close();
  });

  const call = (route: Route, authorization?: string) => {
    // Any id will do: the guards answer before the route looks anything up.
    const url = route.path.replace(/:\w+/g, randomUUID());
    const method = route.method.toLowerCase() as
      'get' | 'post' | 'patch' | 'put' | 'delete';
    const req = t.http()[method](url);
    return authorization ? req.set('authorization', authorization) : req;
  };

  it('finds the routes', () => {
    expect(routes.length).toBeGreaterThan(60);
    expect(new Set(routes.map(key)).size).toBe(routes.length);
  });

  it('turns away anonymous callers everywhere except the public routes', async () => {
    const open = routes
      .filter((r) => r.isPublic)
      .map(key)
      .sort();
    expect(open).toEqual([
      'GET /api/v1/auth/signup',
      'GET /api/v1/files/:token',
      'GET /api/v1/health',
      'POST /api/v1/auth/forgot-password',
      'POST /api/v1/auth/login',
      'POST /api/v1/auth/refresh',
      'POST /api/v1/auth/reset-password',
      // Only while no admin exists: the first admin signs up.
      'POST /api/v1/auth/signup',
    ]);
    const leaks: string[] = [];
    for (const route of routes.filter((r) => !r.isPublic)) {
      const response = await call(route);
      if (response.status !== 401 || response.body.code !== 'UNAUTHORIZED')
        leaks.push(`${key(route)} → ${response.status}`);
    }
    expect(leaks).toEqual([]);
  });

  it('turns away roles a route is not for', async () => {
    const leaks: string[] = [];
    for (const route of routes.filter((r) => r.roles)) {
      for (const role of ROLES.filter((r) => !route.roles!.includes(r))) {
        const response = await call(route, auth[role]);
        if (response.status !== 403 || response.body.code !== 'FORBIDDEN')
          leaks.push(`${role} ${key(route)} → ${response.status}`);
      }
    }
    expect(leaks).toEqual([]);
  });

  it('lists every route open to all roles on purpose', () => {
    const unrestricted = routes
      .filter((r) => !r.isPublic && !r.roles)
      .map(key)
      .sort();
    expect(unrestricted).toEqual(ANY_SIGNED_IN);
  });

  it('gives staff only their own day, site usage and their own requests', () => {
    const forStaff = routes
      .filter((r) => r.roles?.includes('STAFF'))
      .map(key)
      .sort();
    expect(forStaff).toEqual([
      // Their own leave, money and food requests (scoped to the caller).
      'GET /api/v1/leave-requests',
      'GET /api/v1/leave-requests/:id',
      // The materials in use, to ask for some (names and units only).
      'GET /api/v1/material-requests',
      'GET /api/v1/material-requests/:id',
      'GET /api/v1/materials',
      'GET /api/v1/me/today',
      // Their own site's stock, to record (and correct) its daily usage.
      'GET /api/v1/sites/:id/stock',
      'GET /api/v1/staff-requests',
      'GET /api/v1/staff-requests/:id',
      'POST /api/v1/attendance/check-in',
      'POST /api/v1/attendance/check-out',
      'POST /api/v1/leave-requests',
      'POST /api/v1/leave-requests/:id/cancel',
      'POST /api/v1/material-requests',
      'POST /api/v1/material-requests/:id/cancel',
      'POST /api/v1/staff-requests',
      'POST /api/v1/staff-requests/:id/cancel',
      'POST /api/v1/staff-updates',
      'POST /api/v1/stock/entries/:id/void',
      'POST /api/v1/stock/usage',
    ]);
  });

  it('gives godown managers their godowns: stock in, sending, returns, counts', () => {
    const forManagers = routes
      .filter((r) => r.roles?.includes('GODOWN_MANAGER'))
      .map(key)
      .sort();
    expect(forManagers).toEqual([
      'GET /api/v1/dashboard/godown',
      'GET /api/v1/material-requests',
      'GET /api/v1/material-requests/:id',
      'GET /api/v1/materials',
      'GET /api/v1/stock/entries',
      'GET /api/v1/stock/entries/:id',
      'GET /api/v1/stock/godowns/:id',
      'GET /api/v1/stock/overview',
      'POST /api/v1/materials',
      'POST /api/v1/stock/counts',
      'POST /api/v1/stock/entries/:id/receive',
      'POST /api/v1/stock/entries/:id/void',
      'POST /api/v1/stock/purchases',
      'POST /api/v1/stock/transfers',
      'POST /api/v1/stock/write-offs',
    ]);
  });
});
