import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { Logger } from 'nestjs-pino';
import { AppModule } from './app.module.js';
import { API_PREFIX, configureApp } from './app.setup.js';
import { APP_VERSION } from './common/app-info.js';
import type { Env } from './config/env.js';

const app = await NestFactory.create(AppModule, { bufferLogs: true });
const logger = app.get(Logger);
app.useLogger(logger);
configureApp(app);

const config = app.get<ConfigService<Env, true>>(ConfigService);
if (config.get('NODE_ENV', { infer: true }) !== 'production') {
  const document = SwaggerModule.createDocument(
    app,
    new DocumentBuilder()
      .setTitle('SiteWork API')
      .setVersion(APP_VERSION)
      .addBearerAuth()
      .build(),
  );
  SwaggerModule.setup('docs', app, document);
}

const host = config.get('HOST', { infer: true });
const port = config.get('PORT', { infer: true });
await app.listen(port, host);
logger.log(
  `SiteWork API listening on http://${host}:${port}/${API_PREFIX} (docs at /docs)`,
);
