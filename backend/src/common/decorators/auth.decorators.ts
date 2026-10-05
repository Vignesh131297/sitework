import {
  createParamDecorator,
  SetMetadata,
  type ExecutionContext,
} from '@nestjs/common';
import type { AuthenticatedRequest, AuthUser } from '../../auth/auth-user.js';
import type { Role } from '../../generated/prisma/enums.js';

export const IS_PUBLIC_KEY = 'auth:public';
export const ROLES_KEY = 'auth:roles';
export const ALLOW_PENDING_PASSWORD_KEY = 'auth:allowPendingPasswordChange';

/** Route needs no sign-in (every other route does). */
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);

/** Route is limited to these roles. */
export const Roles = (...roles: Role[]) => SetMetadata(ROLES_KEY, roles);

/** Route stays usable while the user must still replace a temporary password. */
export const AllowPendingPasswordChange = () =>
  SetMetadata(ALLOW_PENDING_PASSWORD_KEY, true);

export const CurrentUser = createParamDecorator(
  (_data: unknown, context: ExecutionContext): AuthUser =>
    context.switchToHttp().getRequest<AuthenticatedRequest>().user,
);
