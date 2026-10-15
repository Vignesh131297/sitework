import type { ConfigService } from '@nestjs/config';
import type { Env } from '../config/env.js';

/**
 * The owner's switch (PASSWORD_LOCKED_PHONES): these accounts keep their
 * password. It can't be changed, reset by an admin or reset by e-mail code, and
 * the mobile number it is tied to can't be changed either.
 */
export const isPasswordLocked = (
  config: ConfigService<Env, true>,
  user: { phone: string },
): boolean =>
  config.get('PASSWORD_LOCKED_PHONES', { infer: true }).includes(user.phone);
