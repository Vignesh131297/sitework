import type { Request } from 'express';
import type { Role } from '../generated/prisma/enums.js';

/** The signed-in caller, attached to the request by JwtAuthGuard (loaded from the database). */
export interface AuthUser {
  id: string;
  role: Role;
  name: string;
  sessionId: string;
  mustChangePassword: boolean;
}

export type AuthenticatedRequest = Request & { user: AuthUser; id?: string };
