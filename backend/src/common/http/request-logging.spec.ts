import { loggableUrl, requestLogSerializers } from './request-logging.js';

describe('request logging', () => {
  it('drops the signature from signed file links only', () => {
    expect(
      loggableUrl('/api/v1/files/abc.def?expires=1790000000&signature=s3cr3t'),
    ).toBe('/api/v1/files/abc.def');
    expect(loggableUrl('/api/v1/reports/sites?from=2026-10-01')).toBe(
      '/api/v1/reports/sites?from=2026-10-01',
    );
  });

  it('keeps id, method and url, and nothing from the headers', () => {
    const logged = requestLogSerializers.req({
      id: 'r1',
      method: 'GET',
      url: '/api/v1/me',
      headers: { authorization: 'Bearer x', 'user-agent': 'Dart' },
    } as never);
    expect(logged).toEqual({ id: 'r1', method: 'GET', url: '/api/v1/me' });
  });
});
