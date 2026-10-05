import { Global, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Env } from '../config/env.js';
import { DevicesController } from './devices.controller.js';
import { PushDispatcher } from './push-dispatcher.service.js';
import {
  FcmPushProvider,
  LogPushProvider,
  PushProvider,
} from './push.provider.js';

@Global()
@Module({
  controllers: [DevicesController],
  providers: [
    {
      provide: PushProvider,
      inject: [ConfigService],
      useFactory: (config: ConfigService<Env, true>): PushProvider =>
        config.get('PUSH_DRIVER', { infer: true }) === 'fcm'
          ? new FcmPushProvider(
              config.get('FIREBASE_PROJECT_ID', { infer: true }) ?? '',
              config.get('FIREBASE_CLIENT_EMAIL', { infer: true }) ?? '',
              config.get('FIREBASE_PRIVATE_KEY', { infer: true }) ?? '',
            )
          : new LogPushProvider(),
    },
    PushDispatcher,
  ],
  exports: [PushProvider, PushDispatcher],
})
export class PushModule {}
