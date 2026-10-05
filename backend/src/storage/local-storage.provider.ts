import { createHmac, timingSafeEqual } from 'node:crypto';
import { createReadStream, type ReadStream } from 'node:fs';
import {
  mkdir,
  readdir,
  rename,
  stat,
  unlink,
  writeFile,
} from 'node:fs/promises';
import { dirname, join, resolve, sep } from 'node:path';
import { StorageProvider, type StoredObject } from './storage.provider.js';

/**
 * Development storage: files on the API's disk, read through `/files/<token>`
 * URLs signed with an HMAC, so they work for the app without a login header
 * yet expire like Supabase signed URLs.
 */
export class LocalStorageProvider extends StorageProvider {
  private readonly root: string;

  constructor(
    directory: string,
    private readonly signingSecret: string,
  ) {
    super();
    this.root = resolve(directory);
  }

  async put(key: string, body: Buffer): Promise<void> {
    const path = this.pathOf(key);
    await mkdir(dirname(path), { recursive: true });
    // Write then rename, so a reader never sees half a file.
    const temporary = `${path}.${process.pid}.tmp`;
    await writeFile(temporary, body);
    await rename(temporary, path);
  }

  async delete(keys: readonly string[]): Promise<void> {
    for (const key of keys) {
      try {
        await unlink(this.pathOf(key));
      } catch (error) {
        if ((error as NodeJS.ErrnoException).code !== 'ENOENT') throw error;
      }
    }
  }

  signedUrl(key: string, ttlSeconds: number): Promise<string> {
    const expires = Math.floor(Date.now() / 1000) + ttlSeconds;
    const token = Buffer.from(key).toString('base64url');
    return Promise.resolve(
      `/files/${token}?expires=${expires}&signature=${this.sign(key, expires)}`,
    );
  }

  async list(folder: string): Promise<StoredObject[]> {
    let names: string[];
    try {
      names = await readdir(this.pathOf(folder));
    } catch (error) {
      if ((error as NodeJS.ErrnoException).code === 'ENOENT') return [];
      throw error;
    }
    const objects: StoredObject[] = [];
    for (const name of names) {
      if (name.endsWith('.tmp')) continue;
      const info = await stat(join(this.pathOf(folder), name));
      if (info.isFile())
        objects.push({ key: `${folder}/${name}`, createdAt: info.mtime });
    }
    return objects;
  }

  /** The object a signed `/files` URL points to, or null if the link is invalid or expired. */
  verify(
    token: string,
    expires: string,
    signature: string,
    now = new Date(),
  ): string | null {
    const expiresAt = Number(expires);
    if (!Number.isInteger(expiresAt) || expiresAt * 1000 < now.getTime())
      return null;
    let key: string;
    try {
      key = Buffer.from(token, 'base64url').toString('utf8');
      this.pathOf(key);
    } catch {
      return null;
    }
    const expected = Buffer.from(this.sign(key, expiresAt));
    const given = Buffer.from(signature);
    return expected.length === given.length && timingSafeEqual(expected, given)
      ? key
      : null;
  }

  /** A stream of the file, or null when it no longer exists (e.g. already deleted). */
  async open(key: string): Promise<ReadStream | null> {
    const path = this.pathOf(key);
    try {
      if (!(await stat(path)).isFile()) return null;
    } catch {
      return null;
    }
    return createReadStream(path);
  }

  private sign(key: string, expires: number): string {
    return createHmac('sha256', this.signingSecret)
      .update(`file:${key}:${expires}`)
      .digest('base64url');
  }

  /** Absolute path for a key, refusing anything that would escape the root. */
  private pathOf(key: string): string {
    if (!/^[A-Za-z0-9][A-Za-z0-9._/-]*$/.test(key) || key.includes('..')) {
      throw new Error(`Invalid storage key: ${key}`);
    }
    const path = resolve(this.root, key);
    if (path !== this.root && !path.startsWith(this.root + sep))
      throw new Error(`Invalid storage key: ${key}`);
    return path;
  }
}
