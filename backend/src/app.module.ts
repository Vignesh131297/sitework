import { randomUUID } from 'node:crypto';
import { Module, ValidationPipe } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR, APP_PIPE } from '@nestjs/core';
import { LoggerModule } from 'nestjs-pino';
import { AttachmentsModule } from './attachments/attachments.service.js';
import { AttendanceModule } from './attendance/attendance.module.js';
import { AuthModule } from './auth/auth.module.js';
import { ClientsModule } from './clients/clients.module.js';
import { AuditModule } from './common/audit/audit.service.js';
import { AllExceptionsFilter } from './common/filters/all-exceptions.filter.js';
import type { RequestWithId } from './common/http/request-id.middleware.js';
import {
  requestLogProps,
  requestLogSerializers,
  skipRequestLog,
} from './common/http/request-logging.js';
import { ResponseEnvelopeInterceptor } from './common/interceptors/response-envelope.interceptor.js';
import { ClockModule } from './common/time/clock.js';
import { validationExceptionFactory } from './common/validation/validation-exception.factory.js';
import { validateEnv, type Env } from './config/env.js';
import { DashboardModule } from './dashboard/dashboard.module.js';
import { EngineerUpdatesModule } from './engineer-updates/engineer-updates.module.js';
import { HealthModule } from './health/health.module.js';
import { IssuesModule } from './issues/issues.module.js';
import { JobsModule } from './jobs/jobs.module.js';
import { MailModule } from './mail/mail.module.js';
import { NotificationsModule } from './notifications/notifications.module.js';
import { PaymentsModule } from './payments/payments.module.js';
import { PeopleModule } from './people/people.module.js';
import { PrismaModule } from './prisma/prisma.module.js';
import { PushModule } from './push/push.module.js';
import { ReportsModule } from './reports/reports.module.js';
import { RequestsModule } from './requests/requests.module.js';
import { SettingsModule } from './settings/settings.module.js';
import { SitesModule } from './sites/sites.module.js';
import { StaffUpdatesModule } from './staff-updates/staff-updates.module.js';
import { StockModule } from './stock/stock.module.js';
import { StorageModule } from './storage/storage.module.js';
import { UsersModule } from './users/users.module.js';
import { VehiclesModule } from './vehicles/vehicles.module.js';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      cache: true,
      validate: validateEnv,
    }),
    LoggerModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService<Env, true>) => ({
        pinoHttp: {
          level: config.get('LOG_LEVEL', { infer: true }),
          transport:
            config.get('NODE_ENV', { infer: true }) === 'development'
              ? { target: 'pino-pretty', options: { singleLine: true } }
              : undefined,
          serializers: requestLogSerializers,
          customProps: requestLogProps,
          autoLogging: { ignore: skipRequestLog },
          // Belt and braces: the serializers already leave headers out.
          redact: ['req.headers.authorization', 'req.headers.cookie'],
          // The id is assigned earlier by requestIdMiddleware (see app.setup.ts).
          genReqId: (req) => (req as RequestWithId).id ?? randomUUID(),
          customLogLevel: (_req, res, error) =>
            error || res.statusCode >= 500
              ? 'error'
              : res.statusCode >= 400
                ? 'warn'
                : 'info',
        },
      }),
    }),
    ClockModule,
    PrismaModule,
    SettingsModule,
    AuditModule,
    MailModule,
    AuthModule,
    UsersModule,
    ClientsModule,
    SitesModule,
    PeopleModule,
    StorageModule,
    NotificationsModule,
    PushModule,
    AttendanceModule,
    StaffUpdatesModule,
    AttachmentsModule,
    EngineerUpdatesModule,
    IssuesModule,
    PaymentsModule,
    StockModule,
    RequestsModule,
    VehiclesModule,
    ReportsModule,
    JobsModule,
    DashboardModule,
    HealthModule,
  ],
  providers: [
    {
      provide: APP_PIPE,
      useFactory: () =>
        new ValidationPipe({
          whitelist: true,
          forbidNonWhitelisted: true,
          transform: true,
          exceptionFactory: validationExceptionFactory,
        }),
    },
    { provide: APP_FILTER, useClass: AllExceptionsFilter },
    { provide: APP_INTERCEPTOR, useClass: ResponseEnvelopeInterceptor },
  ],
})
export class AppModule {}
