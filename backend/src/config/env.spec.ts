import { validateEnv } from './env.js';

const base = {
  DATABASE_URL: 'postgresql://user:pass@localhost:5432/sitework',
  JWT_SECRET: 'a'.repeat(32),
  JWT_REFRESH_SECRET: 'b'.repeat(32),
};

describe('validateEnv', () => {
  it('applies defaults', () => {
    expect(validateEnv(base)).toMatchObject({
      NODE_ENV: 'development',
      HOST: '0.0.0.0',
      PORT: 3000,
      STORAGE_DRIVER: 'local',
      PUSH_DRIVER: 'log',
      REFRESH_TOKEN_TTL_DAYS: 30,
    });
  });

  it('reads TRUST_PROXY as off, on, a hop count or addresses', () => {
    const trust = (TRUST_PROXY?: string) =>
      validateEnv({ ...base, TRUST_PROXY }).TRUST_PROXY;
    expect(trust()).toBe(false);
    expect(trust('true')).toBe(true);
    expect(trust('1')).toBe(1);
    expect(trust('loopback, 10.0.0.0/8')).toBe('loopback, 10.0.0.0/8');
  });

  it('coerces numbers from strings', () => {
    expect(validateEnv({ ...base, PORT: '8080' }).PORT).toBe(8080);
  });

  it('reports every problem at once', () => {
    expect(() => validateEnv({ JWT_SECRET: 'too-short' })).toThrow(
      /DATABASE_URL[\s\S]*JWT_SECRET[\s\S]*JWT_REFRESH_SECRET/,
    );
  });

  it('rejects non-PostgreSQL database URLs', () => {
    expect(() => validateEnv({ ...base, DATABASE_URL: 'mysql://x' })).toThrow(
      /DATABASE_URL/,
    );
  });

  it('requires Supabase credentials for the supabase storage driver', () => {
    expect(() => validateEnv({ ...base, STORAGE_DRIVER: 'supabase' })).toThrow(
      /SUPABASE_URL[\s\S]*SUPABASE_SERVICE_KEY/,
    );
  });

  it('requires Firebase credentials for the fcm push driver', () => {
    expect(() => validateEnv({ ...base, PUSH_DRIVER: 'fcm' })).toThrow(
      /FIREBASE_PROJECT_ID/,
    );
  });

  it('refuses development-only drivers in production', () => {
    expect(() => validateEnv({ ...base, NODE_ENV: 'production' })).toThrow(
      /STORAGE_DRIVER[\s\S]*PUSH_DRIVER/,
    );
  });
});
