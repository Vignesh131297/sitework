import {
  anythingOnTheWay,
  requestProgress,
  sentInFull,
  type DeliveredLine,
} from './request-progress.js';

const delivery = (
  materialId: string,
  quantity: bigint,
  status: DeliveredLine['status'],
  receivedQuantity: bigint | null = null,
): DeliveredLine => ({
  materialId,
  fromPlace: 'GODOWN',
  toPlace: 'SITE',
  status,
  quantity,
  receivedQuantity,
});

describe('material request progress', () => {
  it('adds up what was sent, received and is still on the way', () => {
    const progress = requestProgress(
      [
        { materialId: 'cement', approved: 100_000n },
        { materialId: 'sand', approved: 50_000n },
      ],
      [
        delivery('cement', 60_000n, 'DONE', 58_000n),
        delivery('cement', 30_000n, 'IN_TRANSIT'),
        delivery('cement', 10_000n, 'VOIDED'),
        delivery('sand', 50_000n, 'DONE', 50_000n),
        // A return from the site doesn't count as sent.
        {
          materialId: 'cement',
          fromPlace: 'SITE',
          toPlace: 'GODOWN',
          status: 'DONE',
          quantity: 5_000n,
          receivedQuantity: 5_000n,
        },
      ],
    );
    expect(progress.get('cement')).toEqual({
      sent: 90_000n,
      received: 58_000n,
      onTheWay: 30_000n,
      leftToSend: 10_000n,
    });
    expect(progress.get('sand')).toEqual({
      sent: 50_000n,
      received: 50_000n,
      onTheWay: 0n,
      leftToSend: 0n,
    });
    expect(sentInFull(progress)).toBe(false);
    expect(anythingOnTheWay(progress)).toBe(true);
  });

  it('is sent in full once nothing approved is left to send', () => {
    const progress = requestProgress(
      [
        { materialId: 'cement', approved: 20_000n },
        { materialId: 'sand', approved: 0n },
      ],
      [delivery('cement', 20_000n, 'DONE', 20_000n)],
    );
    expect(sentInFull(progress)).toBe(true);
    expect(anythingOnTheWay(progress)).toBe(false);
  });

  it('has nothing to send before approval', () => {
    const progress = requestProgress(
      [{ materialId: 'cement', approved: null }],
      [],
    );
    expect(progress.get('cement')?.leftToSend).toBeNull();
    expect(sentInFull(progress)).toBe(false);
  });
});
