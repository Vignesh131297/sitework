export interface StoredObject {
  key: string;
  createdAt: Date;
}

/**
 * Private object storage for photos. Objects are never public: they are read
 * through short-lived signed URLs, and only the server writes or deletes them.
 * Keys look like `staff/2026-10-04/<uuid>.jpg` (folder per kind and date).
 */
export abstract class StorageProvider {
  abstract put(key: string, body: Buffer, contentType: string): Promise<void>;

  /** Deletes the objects; keys that no longer exist are ignored. */
  abstract delete(keys: readonly string[]): Promise<void>;

  /**
   * A URL that reads one object until it expires. Absolute for external storage;
   * for local storage it is a path under the API (e.g. `/files/…`) for the app to
   * resolve against its API base URL.
   */
  abstract signedUrl(key: string, ttlSeconds: number): Promise<string>;

  /** Objects directly inside a folder (e.g. `staff/2026-10-04`), for orphan sweeps. */
  abstract list(folder: string): Promise<StoredObject[]>;
}

/** Folder of a business date's staff photos; the photo key is `${folder}/<uuid>.jpg`. */
export const staffPhotoFolder = (workDate: string) => `staff/${workDate}`;

/** Folder of kept attachments (engineer updates, issues), by month. */
export const attachmentFolder = (month: string) => `attachments/${month}`;
