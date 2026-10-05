import {
  Injectable,
  type CanActivate,
  type ExecutionContext,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from '../../common/decorators/auth.decorators.js';
import type { Role } from '../../generated/prisma/enums.js';
import { forbidden } from '../auth.errors.js';
import type { AuthenticatedRequest } from '../auth-user.js';

/** Global guard: enforces @Roles(...). Runs after JwtAuthGuard has loaded the user. */
@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const roles = this.reflector.getAllAndOverride<Role[] | undefined>(
      ROLES_KEY,
      [context.getHandler(), context.getClass()],
    );
    if (!roles?.length) return true;
    const { user } = context.switchToHttp().getRequest<AuthenticatedRequest>();
    if (!user || !roles.includes(user.role)) throw forbidden();
    return true;
  }
}
