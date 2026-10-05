import { Controller, Get } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { CurrentUser, Roles } from '../common/decorators/auth.decorators.js';
import {
  DashboardService,
  type AdminDashboard,
  type EngineerDashboard,
} from './dashboard.service.js';

@Controller('dashboard')
export class DashboardController {
  constructor(private readonly dashboard: DashboardService) {}

  @Roles('ADMIN')
  @Get('admin')
  admin(): Promise<AdminDashboard> {
    return this.dashboard.admin();
  }

  @Roles('ENGINEER')
  @Get('engineer')
  engineer(@CurrentUser() user: AuthUser): Promise<EngineerDashboard> {
    return this.dashboard.engineer(user);
  }
}
