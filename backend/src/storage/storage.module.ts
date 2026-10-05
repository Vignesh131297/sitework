import {
  Controller,
  Get,
  Global,
  Module,
  Param,
  Query,
  Res,
  StreamableFile,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ApiExcludeController } from '@nestjs/swagger';
import type { Response } from 'express';
import { Public } from '../common/decorators/auth.decorators.js';
import { notFound } from '../common/errors/http-errors.js';
import type { Env } from '../config/env.js';
import { LocalStorageProvider } from './local-storage.provider.js';
import { StorageProvider } from './storage.provider.js';
import { SupabaseStorageProvider } from './supabase-storage.provider.js';

/** Serves local-storage files behind signed, expiring links (development only). */
@ApiExcludeController()
@Controller('files')
export class LocalFilesController {
  constructor(private readonly storage: StorageProvider) {}

  @Public()
  @Get(':token')
  async read(
    @Param('token') token: string,
    @Query('expires') expires: string | undefined,
    @Query('signature') signature: string | undefined,
    @Res({ passthrough: true }) res: Response,
  ): Promise<StreamableFile> {
    const local =
      this.storage instanceof LocalStorageProvider ? this.storage : null;
    const key = local?.verify(token, expires ?? '', signature ?? '');
    const stream = key ? await local!.open(key) : null;
    if (!stream) throw notFound('file');
    res.setHeader('Cache-Control', 'private, no-store');
    return new StreamableFile(stream, { type: 'image/jpeg' });
  }
}

@Global()
@Module({
  controllers: [LocalFilesController],
  providers: [
    {
      provide: StorageProvider,
      inject: [ConfigService],
      useFactory: (config: ConfigService<Env, true>): StorageProvider =>
        config.get('STORAGE_DRIVER', { infer: true }) === 'supabase'
          ? new SupabaseStorageProvider(
              config.get('SUPABASE_URL', { infer: true }) ?? '',
              config.get('SUPABASE_SERVICE_KEY', { infer: true }) ?? '',
              config.get('SUPABASE_BUCKET', { infer: true }),
            )
          : new LocalStorageProvider(
              config.get('LOCAL_STORAGE_DIR', { infer: true }),
              // Domain-separated inside the provider ("file:" prefix).
              config.get('JWT_SECRET', { infer: true }),
            ),
    },
  ],
  exports: [StorageProvider],
})
export class StorageModule {}
