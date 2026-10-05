import { Controller, Get } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import {
  AllowPendingPasswordChange,
  CurrentUser,
} from '../common/decorators/auth.decorators.js';
import { UsersService, type MeProfile } from './users.service.js';

@Controller('me')
export class MeController {
  constructor(private readonly users: UsersService) {}

  @Get()
  @AllowPendingPasswordChange()
  me(@CurrentUser() user: AuthUser): Promise<MeProfile> {
    return this.users.getProfile(user.id);
  }
}
