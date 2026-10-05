import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Express } from 'express';
import compression from 'compression';
import helmet from 'helmet';
import { requestIdMiddleware } from './common/http/request-id.middleware.js';
import type { Env } from './config/env.js';

export const API_PREFIX = 'api/v1';

/**
 * HTTP-level setup shared by main.ts and the e2e tests; call it before app.init().
 * Global pipes, filters and interceptors are registered as providers in AppModule
 * instead, so tests get them too.
 */
export function configureApp(app: INestApplication): void {
  app.setGlobalPrefix(API_PREFIX);
  // The real client address behind a load balancer (sign-in limits use it).
  const config = app.get<ConfigService<Env, true>>(ConfigService);
  const express = app.getHttpAdapter().getInstance() as Express;
  express.set('trust proxy', config.get('TRUST_PROXY', { infer: true }));
  // Middleware added here runs before Nest's body parsers, which are registered on init.
  app.use(requestIdMiddleware);
  app.use(helmet());
  // Field phones are often on weak mobile data; JSON lists shrink about 5x.
  app.use(compression({ threshold: 1024 }));
  app.enableShutdownHooks();
}
