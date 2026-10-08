import { SupabaseStorageProvider } from './supabase-storage.provider.js';

describe('SupabaseStorageProvider', () => {
  const sent: { url: string; headers: Record<string, string> }[] = [];

  beforeEach(() => {
    sent.length = 0;
    vi.stubGlobal('fetch', (url: string, init: RequestInit) => {
      sent.push({ url, headers: init.headers as Record<string, string> });
      return Promise.resolve(new Response('{}', { status: 200 }));
    });
  });

  afterEach(() => {
    vi.unstubAllGlobals();
  });

  it('sends a new secret key only as apikey', async () => {
    const storage = new SupabaseStorageProvider(
      'https://ref.supabase.co/',
      'sb_secret_abc123',
      'bucket',
    );
    await storage.put('staff/a.jpg', Buffer.from('a'), 'image/jpeg');
    expect(sent[0].url).toBe(
      'https://ref.supabase.co/storage/v1/object/bucket/staff/a.jpg',
    );
    expect(sent[0].headers.apikey).toBe('sb_secret_abc123');
    expect(sent[0].headers).not.toHaveProperty('authorization');
  });

  it('also sends a legacy service_role key as a bearer token', async () => {
    const storage = new SupabaseStorageProvider(
      'https://ref.supabase.co',
      'eyJhbGciOiJIUzI1NiJ9.legacy',
      'bucket',
    );
    await storage.delete(['staff/a.jpg']);
    expect(sent[0].headers).toMatchObject({
      apikey: 'eyJhbGciOiJIUzI1NiJ9.legacy',
      authorization: 'Bearer eyJhbGciOiJIUzI1NiJ9.legacy',
    });
  });
});
