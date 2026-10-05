import { readFileSync } from 'node:fs';

// Resolves to backend/package.json from both src/ (tests) and dist/ (runtime).
const pkg = JSON.parse(
  readFileSync(new URL('../../package.json', import.meta.url), 'utf8'),
) as { version: string };

export const APP_VERSION = pkg.version;
