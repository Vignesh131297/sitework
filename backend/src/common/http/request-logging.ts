import type { IncomingMessage, ServerResponse } from 'node:http';
import type { AuthUser } from '../../auth/auth-user.js';

/**
 * One short line per request: id, method, path, status, user and timing. No
 * headers (tokens, device details), and no query string on signed file links,
 * whose signature works as a password until it expires.
 */
export const requestLogSerializers = {
  req: (req: { id: string; method: string; url: string }) => ({
    id: req.id,
    method: req.method,
    url: loggableUrl(req.url),
  }),
  res: (res: { statusCode: number }) => ({ statusCode: res.statusCode }),
};

export function loggableUrl(url: string): string {
  return /^\/api\/v\d+\/files\//.test(url) ? url.split('?')[0] : url;
}

/** Who made the request, once the auth guard has run. */
export function requestLogProps(req: IncomingMessage, _res: ServerResponse) {
  const user = (req as IncomingMessage & { user?: AuthUser }).user;
  return user ? { userId: user.id } : {};
}

/** Load-balancer and uptime checks would drown out everything else. */
export function skipRequestLog(req: IncomingMessage): boolean {
  return req.url === '/api/v1/health';
}
