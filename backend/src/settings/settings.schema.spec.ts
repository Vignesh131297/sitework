import {
  DEFAULT_SETTINGS,
  resolveSettings,
  SETTINGS_KEYS,
  settingsSchemas,
} from './settings.schema.js';

describe('resolveSettings', () => {
  it('uses the defaults when nothing is stored', () => {
    expect(resolveSettings([])).toEqual({
      settings: DEFAULT_SETTINGS,
      invalidKeys: [],
    });
  });

  it('merges stored fields over the defaults within a group', () => {
    const { settings } = resolveSettings([
      { key: 'images', value: { ttlHours: 48 } },
    ]);
    expect(settings.images).toEqual({
      ...DEFAULT_SETTINGS.images,
      ttlHours: 48,
    });
    expect(settings.business).toEqual(DEFAULT_SETTINGS.business);
  });

  it('falls back to the defaults for an invalid group and reports it', () => {
    const { settings, invalidKeys } = resolveSettings([
      { key: 'business', value: { timeZone: 'Not/AZone' } },
    ]);
    expect(settings.business).toEqual(DEFAULT_SETTINGS.business);
    expect(invalidKeys).toEqual(['business']);
  });

  it('rejects overlapping slot windows', () => {
    const slots = [
      { slot: 'MORNING', start: '10:00', end: '13:30' },
      { slot: 'AFTERNOON', start: '13:00', end: '15:00' },
      { slot: 'EVENING', start: '16:00', end: '19:00' },
    ];
    expect(
      resolveSettings([{ key: 'updates', value: { slots } }]).invalidKeys,
    ).toEqual(['updates']);
  });

  it('ignores unknown keys', () => {
    expect(resolveSettings([{ key: 'legacy', value: 1 }]).invalidKeys).toEqual(
      [],
    );
  });

  it('ships defaults that satisfy their own schemas', () => {
    for (const key of SETTINGS_KEYS) {
      expect(
        settingsSchemas[key].safeParse(DEFAULT_SETTINGS[key]).success,
      ).toBe(true);
    }
  });
});
