import { z } from 'zod';
import { normalizePhone } from '../common/identity/phone.js';

/**
 * Express "trust proxy": false when clients connect directly; behind a load
 * balancer, the number of proxies in front (usually 1) or their addresses.
 * Rate limits key on the client address, so this must match the deployment.
 */
export function parseTrustProxy(value: string): boolean | number | string {
  const text = value.trim().toLowerCase();
  if (text === '' || text === 'false') return false;
  if (text === 'true') return true;
  if (/^[0-9]+$/.test(text)) return Number(text);
  return value.trim();
}

const postgresUrl = z
  .string()
  .regex(/^postgres(ql)?:\/\//, 'must be a postgresql:// connection string');

export const envSchema = z
  .object({
    NODE_ENV: z
      .enum(['development', 'test', 'staging', 'production'])
      .default('development'),
    /** 0.0.0.0 for containers; 127.0.0.1 locally (the Android emulator reaches it via 10.0.2.2). */
    HOST: z.string().default('0.0.0.0'),
    PORT: z.coerce.number().int().positive().default(3000),
    LOG_LEVEL: z
      .enum(['fatal', 'error', 'warn', 'info', 'debug', 'trace', 'silent'])
      .default('info'),
    TRUST_PROXY: z.string().default('false').transform(parseTrustProxy),

    DATABASE_URL: postgresUrl,

    JWT_SECRET: z.string().min(32, 'must be at least 32 characters'),
    /** Pepper for hashing refresh tokens and password-reset codes. */
    JWT_REFRESH_SECRET: z.string().min(32, 'must be at least 32 characters'),
    JWT_ACCESS_TTL_MINUTES: z.coerce.number().int().min(1).max(60).default(15),
    REFRESH_TOKEN_TTL_DAYS: z.coerce.number().int().positive().default(30),

    STORAGE_DRIVER: z.enum(['local', 'supabase']).default('local'),
    LOCAL_STORAGE_DIR: z.string().default('./storage'),
    SUPABASE_URL: z.string().optional(),
    SUPABASE_SERVICE_KEY: z.string().optional(),
    /** A private bucket: photos are only ever read through short-lived signed URLs. */
    SUPABASE_BUCKET: z.string().default('sitework-private'),

    PUSH_DRIVER: z.enum(['log', 'fcm']).default('log'),
    FIREBASE_PROJECT_ID: z.string().optional(),
    FIREBASE_CLIENT_EMAIL: z.string().optional(),
    FIREBASE_PRIVATE_KEY: z.string().optional(),

    /**
     * Mobile numbers (comma-separated) whose password can't be changed or reset
     * in any way, e.g. a shared admin while the app is being tried out.
     */
    PASSWORD_LOCKED_PHONES: z
      .string()
      .default('')
      .transform((value, ctx) => {
        const phones: string[] = [];
        for (const entry of value.split(',')) {
          if (!entry.trim()) continue;
          const phone = normalizePhone(entry);
          if (phone) phones.push(phone);
          else
            ctx.addIssue({
              code: 'custom',
              message: `"${entry.trim()}" is not a mobile number`,
            });
        }
        return phones;
      }),

    /** Requests per minute per signed-in user (sign-in and resets have their own, stricter limits). */
    RATE_LIMIT_PER_MINUTE: z.coerce.number().int().min(30).default(300),

    /** Scheduled jobs (missed updates, photo cleanup, auto-absent). Off in tests. */
    JOBS_ENABLED: z.stringbool().default(true),

    /** disabled: e-mail password reset is off (admins reset passwords). log: development only. */
    MAIL_DRIVER: z.enum(['disabled', 'log', 'smtp']).default('disabled'),
    MAIL_FROM: z.string().default('SiteWork <no-reply@sitework.example>'),
    /** e.g. smtps://user:password@smtp.example.com:465 */
    SMTP_URL: z.string().optional(),
  })
  .superRefine((env, ctx) => {
    const requireKeys = (keys: (keyof typeof env)[], reason: string) => {
      for (const key of keys) {
        if (!env[key]) {
          ctx.addIssue({
            code: 'custom',
            path: [key],
            message: `required when ${reason}`,
          });
        }
      }
    };
    if (env.STORAGE_DRIVER === 'supabase') {
      requireKeys(
        ['SUPABASE_URL', 'SUPABASE_SERVICE_KEY'],
        'STORAGE_DRIVER=supabase',
      );
    }
    if (env.PUSH_DRIVER === 'fcm') {
      requireKeys(
        [
          'FIREBASE_PROJECT_ID',
          'FIREBASE_CLIENT_EMAIL',
          'FIREBASE_PRIVATE_KEY',
        ],
        'PUSH_DRIVER=fcm',
      );
    }
    if (env.MAIL_DRIVER === 'smtp') {
      requireKeys(['SMTP_URL'], 'MAIL_DRIVER=smtp');
    }
    if (env.NODE_ENV === 'production') {
      const devOnly: [keyof typeof env, string][] = [
        ['STORAGE_DRIVER', 'local'],
        ['PUSH_DRIVER', 'log'],
        ['MAIL_DRIVER', 'log'],
      ];
      for (const [key, value] of devOnly) {
        if (env[key] === value) {
          ctx.addIssue({
            code: 'custom',
            path: [key],
            message: `${value} is for development only`,
          });
        }
      }
    }
  });

export type Env = z.infer<typeof envSchema>;

/** Used by ConfigModule: fails fast at boot with every problem listed. */
export function validateEnv(config: Record<string, unknown>): Env {
  const result = envSchema.safeParse(config);
  if (!result.success) {
    const problems = result.error.issues
      .map(
        (issue) => `  - ${issue.path.join('.') || '(root)'}: ${issue.message}`,
      )
      .join('\n');
    throw new Error(`Invalid environment configuration:\n${problems}`);
  }
  return result.data;
}
