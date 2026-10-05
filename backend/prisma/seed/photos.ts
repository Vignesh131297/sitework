import { rm } from 'node:fs/promises';
import { resolve } from 'node:path';
import sharp from 'sharp';
import type { PrismaClient } from '../../src/generated/prisma/client.js';
import type { TimeSlot } from '../../src/generated/prisma/enums.js';
import { SLOT_LABEL } from '../../src/notifications/notification-messages.js';
import { LocalStorageProvider } from '../../src/storage/local-storage.provider.js';

const SLOT_COLOR: Record<TimeSlot, string> = {
  MORNING: '#b8860b',
  AFTERNOON: '#3f6e9e',
  EVENING: '#6b4a8f',
};

const escapeXml = (text: string) =>
  text.replace(/[<>&"']/g, (c) => `&#${c.charCodeAt(0)};`);

/**
 * Writes a labelled placeholder photo for every seeded update that still has
 * one, so the photo viewer works in development (local storage only).
 */
export async function writeSeedPhotos(
  prisma: PrismaClient,
  directory: string,
): Promise<number> {
  const storage = new LocalStorageProvider(directory, 'seed-only');
  await rm(resolve(directory, 'staff'), { recursive: true, force: true });
  const updates = await prisma.staffUpdate.findMany({
    where: { imageKey: { not: null } },
    select: {
      imageKey: true,
      slot: true,
      description: true,
      staff: { select: { name: true } },
      site: { select: { name: true } },
    },
  });
  for (const update of updates) {
    const svg = `<svg width="1200" height="900" xmlns="http://www.w3.org/2000/svg">
      <rect width="100%" height="100%" fill="${SLOT_COLOR[update.slot]}"/>
      <g font-family="sans-serif" fill="#fff">
        <text x="60" y="150" font-size="64" font-weight="bold">${escapeXml(update.site.name)}</text>
        <text x="60" y="250" font-size="48">${escapeXml(update.staff.name)} · ${SLOT_LABEL[update.slot]} update</text>
        <text x="60" y="340" font-size="34">${escapeXml(update.description)}</text>
        <text x="60" y="840" font-size="28" opacity="0.8">Sample photo (development data)</text>
      </g>
    </svg>`;
    const jpeg = await sharp(Buffer.from(svg)).jpeg({ quality: 70 }).toBuffer();
    await storage.put(update.imageKey!, jpeg);
  }
  return updates.length;
}
