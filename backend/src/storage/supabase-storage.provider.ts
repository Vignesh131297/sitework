import { StorageProvider, type StoredObject } from './storage.provider.js';

/**
 * Supabase Storage over its REST API, with the service key (server only).
 * The bucket must be private; the app only ever gets signed URLs.
 */
export class SupabaseStorageProvider extends StorageProvider {
  private readonly base: string;

  constructor(
    url: string,
    private readonly serviceKey: string,
    private readonly bucket: string,
  ) {
    super();
    this.base = `${url.replace(/\/+$/, '')}/storage/v1`;
  }

  async put(key: string, body: Buffer, contentType: string): Promise<void> {
    await this.request(`/object/${this.bucket}/${key}`, {
      method: 'POST',
      // Upsert makes a retried upload of the same key harmless.
      headers: {
        'content-type': contentType,
        'x-upsert': 'true',
        'cache-control': 'no-store',
      },
      body: new Uint8Array(body),
    });
  }

  async delete(keys: readonly string[]): Promise<void> {
    if (keys.length === 0) return;
    await this.request(`/object/${this.bucket}`, {
      method: 'DELETE',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ prefixes: keys }),
    });
  }

  async signedUrl(key: string, ttlSeconds: number): Promise<string> {
    const response = await this.request(`/object/sign/${this.bucket}/${key}`, {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ expiresIn: ttlSeconds }),
    });
    const { signedURL } = (await response.json()) as { signedURL: string };
    return `${this.base}${signedURL}`;
  }

  async list(folder: string): Promise<StoredObject[]> {
    const objects: StoredObject[] = [];
    const limit = 1000;
    for (let offset = 0; ; offset += limit) {
      const response = await this.request(`/object/list/${this.bucket}`, {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({
          prefix: folder,
          limit,
          offset,
          sortBy: { column: 'name', order: 'asc' },
        }),
      });
      const rows = (await response.json()) as {
        id: string | null;
        name: string;
        created_at: string | null;
      }[];
      for (const row of rows) {
        // Rows without an id are sub-folders.
        if (row.id && row.created_at)
          objects.push({
            key: `${folder}/${row.name}`,
            createdAt: new Date(row.created_at),
          });
      }
      if (rows.length < limit) return objects;
    }
  }

  private async request(path: string, init: RequestInit): Promise<Response> {
    const response = await fetch(`${this.base}${path}`, {
      ...init,
      headers: {
        ...init.headers,
        // New secret keys (sb_secret_...) are not JWTs and go only in `apikey`;
        // legacy service_role keys are JWTs and are also sent as a bearer token.
        ...(this.serviceKey.startsWith('sb_')
          ? {}
          : { authorization: `Bearer ${this.serviceKey}` }),
        apikey: this.serviceKey,
      },
      signal: AbortSignal.timeout(30_000),
    });
    if (!response.ok) {
      // The body may echo the request; keep only the status in the error.
      throw new Error(
        `Supabase Storage ${init.method} ${path.split('/').slice(0, 3).join('/')} failed: ${response.status}`,
      );
    }
    return response;
  }
}
