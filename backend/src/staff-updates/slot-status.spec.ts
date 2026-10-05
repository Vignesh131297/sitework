import { DEFAULT_SETTINGS } from '../settings/settings.schema.js';
import { slotState, slotWindows } from './slot-status.js';

const ist = (time: string) => new Date(`2026-10-05T${time}:00+05:30`);

describe('slotWindows', () => {
  it('builds the configured windows in the business time zone, with grace', () => {
    const [morning, afternoon, evening] = slotWindows(
      '2026-10-05',
      DEFAULT_SETTINGS,
    );
    expect(morning.slot).toBe('MORNING');
    expect(morning.start).toEqual(ist('10:00'));
    expect(morning.end).toEqual(ist('12:00'));
    expect(morning.closesAt).toEqual(ist('12:15'));
    expect(afternoon.start).toEqual(ist('13:00'));
    expect(evening.end).toEqual(ist('19:00'));
  });
});

describe('slotState', () => {
  const [morning] = slotWindows('2026-10-05', DEFAULT_SETTINGS);
  const at = (time: string, submitted = false, expected = true) =>
    slotState({ window: morning, submitted, expected, now: ist(time) });

  it('follows the server clock through the day', () => {
    expect(at('09:59')).toBe('UPCOMING');
    expect(at('10:00')).toBe('PENDING');
    expect(at('12:10')).toBe('PENDING'); // grace period
    expect(at('12:16')).toBe('MISSING');
  });

  it('is SUBMITTED whenever an update exists, and NOT_EXPECTED when nothing is due', () => {
    expect(at('12:30', true)).toBe('SUBMITTED');
    expect(at('11:00', false, false)).toBe('NOT_EXPECTED');
    expect(at('11:00', true, false)).toBe('SUBMITTED');
  });
});
