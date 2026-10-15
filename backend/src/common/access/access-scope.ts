import type { AuthUser } from '../../auth/auth-user.js';
import type { Prisma } from '../../generated/prisma/client.js';

type Caller = Pick<AuthUser, 'id' | 'role'>;

/** Matches no site. */
const NOTHING: Prisma.SiteWhereInput = { id: { in: [] } };

/**
 * Row-level access rules as Prisma filters. Every query for sites, staff or
 * site-owned records combines its own filter with one of these, so a caller
 * can never see records outside their scope (out-of-scope ids look missing):
 *   Admin    everything (Rule 4)
 *   Engineer the sites they are assigned to, and the staff on those sites (Rule 3)
 *   Staff    their own site and their own records (Rules 1-2)
 *   Godown manager  no sites or staff (their godowns: see godownScope)
 */
export function siteScope(user: Caller): Prisma.SiteWhereInput {
  switch (user.role) {
    case 'ADMIN':
      return {};
    case 'ENGINEER':
      return { engineerAssignments: { some: { engineerId: user.id } } };
    case 'STAFF':
      return { staffAssignments: { some: { staffId: user.id } } };
    case 'GODOWN_MANAGER':
      return NOTHING;
  }
}

/** Which staff members (users with role STAFF) the caller may see. */
export function staffScope(user: Caller): Prisma.UserWhereInput {
  switch (user.role) {
    case 'ADMIN':
      return { role: 'STAFF' };
    case 'ENGINEER':
      return {
        role: 'STAFF',
        staffAssignment: {
          site: { engineerAssignments: { some: { engineerId: user.id } } },
        },
      };
    case 'STAFF':
      return { role: 'STAFF', id: user.id };
    case 'GODOWN_MANAGER':
      return { role: 'STAFF', id: { in: [] } };
  }
}

/** For tables with a site and a staff member (attendance, staff updates, missed updates). */
export function staffRecordScope(user: Caller): {
  site?: Prisma.SiteWhereInput;
  staffId?: string;
} {
  switch (user.role) {
    case 'ADMIN':
      return {};
    case 'ENGINEER':
      return { site: siteScope(user) };
    case 'STAFF':
      return { staffId: user.id };
    case 'GODOWN_MANAGER':
      return { site: NOTHING };
  }
}

/** For records that belong to a site (engineer updates, issues, payments). */
export function siteRecordScope(user: Caller): {
  site?: Prisma.SiteWhereInput;
} {
  return user.role === 'ADMIN' ? {} : { site: siteScope(user) };
}

/**
 * Godowns the caller runs: admins all of them, godown managers those they are
 * assigned to. (Engineers may look at godown stock but run none.)
 */
export function godownScope(user: Caller): Prisma.GodownWhereInput {
  return user.role === 'ADMIN'
    ? {}
    : { managers: { some: { userId: user.id } } };
}
