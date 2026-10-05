import {
  addDays,
  businessDate,
  formatShortDate,
  formatTime,
  fromDbDate,
  isValidTimeZone,
  isWorkingDay,
  toDbDate,
  zonedInstant,
} from './business-time.js';

const IST = 'Asia/Kolkata';

describe('business time', () => {
  it('takes the calendar date in the business time zone, not UTC', () => {
    // 20:00 UTC is 01:30 the next morning in India.
    expect(businessDate(new Date('2026-10-03T20:00:00Z'), IST)).toBe(
      '2026-10-04',
    );
    expect(businessDate(new Date('2026-10-03T18:00:00Z'), IST)).toBe(
      '2026-10-03',
    );
  });

  it('turns a wall-clock time on a business date into an instant', () => {
    expect(zonedInstant('2026-10-05', '10:00', IST).toISOString()).toBe(
      '2026-10-05T04:30:00.000Z',
    );
  });

  it('round-trips DATE column values', () => {
    const value = toDbDate('2026-10-05');
    expect(value.toISOString()).toBe('2026-10-05T00:00:00.000Z');
    expect(fromDbDate(value)).toBe('2026-10-05');
  });

  it('adds days across month boundaries', () => {
    expect(addDays('2026-09-30', 1)).toBe('2026-10-01');
    expect(addDays('2026-10-01', -1)).toBe('2026-09-30');
  });

  it('excludes non-working weekdays and holidays', () => {
    const mondayToSaturday = [1, 2, 3, 4, 5, 6];
    const holidays = new Set(['2026-10-02']);
    expect(isWorkingDay('2026-10-03', mondayToSaturday, holidays)).toBe(true); // Saturday
    expect(isWorkingDay('2026-10-04', mondayToSaturday, holidays)).toBe(false); // Sunday
    expect(isWorkingDay('2026-10-02', mondayToSaturday, holidays)).toBe(false); // holiday
  });

  it('validates IANA time zone names', () => {
    expect(isValidTimeZone(IST)).toBe(true);
    expect(isValidTimeZone('Mars/Olympus_Mons')).toBe(false);
  });

  it('formats times and dates for messages', () => {
    expect(formatTime(new Date('2026-10-03T05:12:00Z'), IST)).toBe('10:42 AM');
    expect(formatShortDate('2026-10-03')).toBe('Sat 3 Oct');
  });

  it('rejects impossible dates', () => {
    expect(() => toDbDate('2026-02-30')).toThrow(/Invalid date/);
  });
});
