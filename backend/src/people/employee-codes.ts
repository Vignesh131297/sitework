import type { PrismaClient } from '../generated/prisma/client.js';
import type { Role } from '../generated/prisma/enums.js';

const CODE_PREFIX: Record<Role, string> = {
  ADMIN: 'ADM',
  ENGINEER: 'ENG',
  STAFF: 'STF',
  GODOWN_MANAGER: 'GDM',
};

/** The next code for [role], e.g. "ENG-004", after the highest one in use. */
export async function nextEmployeeCode(
  db: Pick<PrismaClient, 'user'>,
  role: Role,
): Promise<string> {
  const prefix = `${CODE_PREFIX[role]}-`;
  const codes = await db.user.findMany({
    where: { employeeCode: { startsWith: prefix } },
    select: { employeeCode: true },
  });
  const highest = codes.reduce((max, { employeeCode }) => {
    const n = Number(employeeCode.slice(prefix.length));
    return Number.isInteger(n) && n > max ? n : max;
  }, 0);
  return `${prefix}${String(highest + 1).padStart(3, '0')}`;
}
