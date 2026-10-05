import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import type { App } from 'supertest/types.js';
import { AppModule } from '../src/app.module.js';
import { configureApp } from '../src/app.setup.js';

describe('API foundation (e2e)', () => {
  let app: INestApplication<App>;

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();
    app = moduleRef.createNestApplication();
    configureApp(app);
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it('GET /api/v1/health reports the server clock and business date', async () => {
    const response = await request(app.getHttpServer())
      .get('/api/v1/health')
      .expect(200);

    expect(response.body).toMatchObject({
      success: true,
      data: {
        status: 'ok',
        database: 'up',
        environment: 'test',
        timeZone: 'Asia/Kolkata',
      },
    });
    expect(Number.isNaN(Date.parse(response.body.data.serverTime))).toBe(false);
    expect(response.body.data.businessDate).toMatch(/^\d{4}-\d{2}-\d{2}$/);
    expect(response.headers['x-request-id']).toBeTruthy();
    expect(response.headers['x-content-type-options']).toBe('nosniff'); // helmet
  });

  it('returns the standard error envelope for unknown routes', async () => {
    const response = await request(app.getHttpServer())
      .get('/api/v1/does-not-exist')
      .expect(404);

    expect(response.body).toMatchObject({ success: false, code: 'NOT_FOUND' });
    expect(response.body.requestId).toBe(response.headers['x-request-id']);
  });

  it('answers malformed JSON with a traceable BAD_REQUEST', async () => {
    const response = await request(app.getHttpServer())
      .post('/api/v1/health')
      .set('content-type', 'application/json')
      .send('{"broken":')
      .expect(400);

    expect(response.body).toMatchObject({
      success: false,
      code: 'BAD_REQUEST',
    });
    expect(response.body.requestId).toBe(response.headers['x-request-id']);
  });

  it('honours a sane caller-supplied request id and replaces anything else', async () => {
    const traced = await request(app.getHttpServer())
      .get('/api/v1/health')
      .set('x-request-id', 'trace-123')
      .expect(200);
    expect(traced.headers['x-request-id']).toBe('trace-123');

    const injected = await request(app.getHttpServer())
      .get('/api/v1/health')
      .set('x-request-id', 'bad id\twith spaces')
      .expect(200);
    expect(injected.headers['x-request-id']).toMatch(/^[0-9a-f-]{36}$/);
  });
});
