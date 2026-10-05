import sharp from 'sharp';
import { ErrorCode } from '../common/errors/error-codes.js';
import { badRequest } from '../common/errors/http-errors.js';

export interface ProcessedImage {
  buffer: Buffer;
  mime: 'image/jpeg';
  width: number;
  height: number;
}

const ACCEPTED_FORMATS = new Set(['jpeg', 'png', 'webp', 'heif', 'avif']);

/**
 * Decodes an uploaded photo and re-encodes it as a JPEG: proves the bytes are a
 * real image, applies the camera's rotation, shrinks it for the phone screens it
 * is viewed on, and drops all metadata (EXIF, including any GPS tags).
 */
export async function processPhoto(
  input: Buffer,
  {
    maxDimension = 1600,
    quality = 80,
  }: { maxDimension?: number; quality?: number } = {},
): Promise<ProcessedImage> {
  try {
    // limitInputPixels guards against decompression bombs (about 50 MP).
    const image = sharp(input, {
      failOn: 'error',
      limitInputPixels: 50_000_000,
    });
    const metadata = await image.metadata();
    if (!metadata.format || !ACCEPTED_FORMATS.has(metadata.format))
      throw new Error('unsupported format');
    const { data, info } = await image
      .rotate()
      .resize({
        width: maxDimension,
        height: maxDimension,
        fit: 'inside',
        withoutEnlargement: true,
      })
      .jpeg({ quality, mozjpeg: true })
      .toBuffer({ resolveWithObject: true });
    return {
      buffer: data,
      mime: 'image/jpeg',
      width: info.width,
      height: info.height,
    };
  } catch {
    throw badRequest(
      ErrorCode.INVALID_IMAGE,
      'The photo could not be read. Please take it again.',
      'photo',
    );
  }
}
