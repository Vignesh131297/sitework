import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_GUARD } from '@nestjs/core';
import { JwtModule } from '@nestjs/jwt';
import { ThrottlerModule } from '@nestjs/throttler';
import { AppThrottlerGuard } from '../common/throttling/app-throttler.guard.js';
import type { Env } from '../config/env.js';
import { UsersModule } from '../users/users.module.js';
import {
  AuthController,
  UserCredentialsController,
} from './auth.controller.js';
import { AuthService } from './auth.service.js';
import { JwtAuthGuard } from './guards/jwt-auth.guard.js';
import { RolesGuard } from './guards/roles.guard.js';
import { SessionsRepository } from './sessions.repository.js';
import { TokenService } from './token.service.js';

@Module({
  imports: [
    UsersModule,
    JwtModule.registerAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService<Env, true>) => ({
        secret: config.get('JWT_SECRET', { infer: true }),
      }),
    }),
    // Default limit for everything; sign-in and reset routes set stricter ones.
    ThrottlerModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService<Env, true>) => [
        {
          name: 'default',
          ttl: 60_000,
          limit: config.get('RATE_LIMIT_PER_MINUTE', { infer: true }),
        },
      ],
    }),
  ],
  controllers: [AuthController, UserCredentialsController],
  providers: [
    AuthService,
    TokenService,
    SessionsRepository,
    // Global guards, in this order: who you are → what you may do → how often.
    { provide: APP_GUARD, useClass: JwtAuthGuard },
    { provide: APP_GUARD, useClass: RolesGuard },
    { provide: APP_GUARD, useClass: AppThrottlerGuard },
  ],
  exports: [AuthService],
})
export class AuthModule {}
