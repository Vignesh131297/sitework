import sharp from 'sharp';
import { processPhoto } from './image-processor.js';

describe('processPhoto', () => {
  it('re-encodes as a smaller JPEG without metadata, applying rotation', async () => {
    const input = await sharp({
      create: { width: 3000, height: 2000, channels: 3, background: '#335577' },
    })
      .withExif({ IFD0: { Make: 'PhoneCo' } })
      .withMetadata({ orientation: 6 }) // stored sideways, as many phones do
      .jpeg()
      .toBuffer();
    const output = await processPhoto(input);
    const metadata = await sharp(output.buffer).metadata();
    expect(output.mime).toBe('image/jpeg');
    expect(metadata.format).toBe('jpeg');
    expect({ width: metadata.width, height: metadata.height }).toEqual({
      width: 1067,
      height: 1600,
    });
    expect(metadata.exif).toBeUndefined();
    expect(metadata.orientation).toBeUndefined();
  });

  it('keeps small photos at their size', async () => {
    const input = await sharp({
      create: { width: 800, height: 600, channels: 3, background: '#fff' },
    })
      .jpeg()
      .toBuffer();
    expect(await processPhoto(input)).toMatchObject({
      width: 800,
      height: 600,
    });
  });

  it('rejects anything that is not a photo', async () => {
    await expect(
      processPhoto(Buffer.from('<svg></svg>')),
    ).rejects.toMatchObject({
      code: 'INVALID_IMAGE',
    });
    await expect(processPhoto(Buffer.alloc(0))).rejects.toMatchObject({
      code: 'INVALID_IMAGE',
    });
  });
});
