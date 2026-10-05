import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { LocalStorageProvider } from './local-storage.provider.js';

describe('LocalStorageProvider', () => {
  let dir: string;
  let storage: LocalStorageProvider;

  beforeEach(async () => {
    dir = await mkdtemp(join(tmpdir(), 'sitework-storage-'));
    storage = new LocalStorageProvider(dir, 'x'.repeat(40));
  });

  afterEach(async () => {
    await rm(dir, { recursive: true, force: true });
  });

  const parse = (url: string) => {
    const parsed = new URL(url, 'http://api.test');
    return {
      token: parsed.pathname.replace('/files/', ''),
      expires: parsed.searchParams.get('expires')!,
      signature: parsed.searchParams.get('signature')!,
    };
  };

  it('stores, lists and deletes files by folder', async () => {
    await storage.put('staff/2026-10-05/a.jpg', Buffer.from('a'));
    await storage.put('staff/2026-10-05/b.jpg', Buffer.from('b'));
    expect(
      (await storage.list('staff/2026-10-05')).map((o) => o.key).sort(),
    ).toEqual(['staff/2026-10-05/a.jpg', 'staff/2026-10-05/b.jpg']);
    await storage.delete([
      'staff/2026-10-05/a.jpg',
      'staff/2026-10-05/missing.jpg',
    ]);
    expect((await storage.list('staff/2026-10-05')).map((o) => o.key)).toEqual([
      'staff/2026-10-05/b.jpg',
    ]);
    expect(await storage.list('staff/2026-01-01')).toEqual([]);
  });

  it('signs links that expire and cannot be altered', async () => {
    await storage.put('staff/2026-10-05/a.jpg', Buffer.from('a'));
    const link = parse(await storage.signedUrl('staff/2026-10-05/a.jpg', 60));
    expect(storage.verify(link.token, link.expires, link.signature)).toBe(
      'staff/2026-10-05/a.jpg',
    );
    expect(
      storage.verify(link.token, link.expires, `${link.signature}x`),
    ).toBeNull();
    expect(
      storage.verify(
        link.token,
        String(Number(link.expires) + 1),
        link.signature,
      ),
    ).toBeNull();
    const other = Buffer.from('staff/2026-10-05/b.jpg').toString('base64url');
    expect(storage.verify(other, link.expires, link.signature)).toBeNull();
    const later = new Date(Date.now() + 120_000);
    expect(
      storage.verify(link.token, link.expires, link.signature, later),
    ).toBeNull();
  });

  it('refuses keys that would leave the storage folder', async () => {
    await expect(
      storage.put('../outside.jpg', Buffer.from('x')),
    ).rejects.toThrow('Invalid storage key');
    await expect(storage.put('/etc/passwd', Buffer.from('x'))).rejects.toThrow(
      'Invalid storage key',
    );
    const sneaky = Buffer.from('staff/../../secret').toString('base64url');
    const link = parse(await storage.signedUrl('staff/2026-10-05/a.jpg', 60));
    expect(storage.verify(sneaky, link.expires, link.signature)).toBeNull();
  });
});
