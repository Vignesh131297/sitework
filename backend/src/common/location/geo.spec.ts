import { DEFAULT_SETTINGS } from '../../settings/settings.schema.js';
import { checkLocation, distanceMeters } from './geo.js';

const rules = DEFAULT_SETTINGS.location;
const site = { latitude: 13.0878, longitude: 80.2008, geofenceRadiusM: 300 };

describe('distanceMeters', () => {
  it('measures short distances on the ground', () => {
    // 0.001 degrees of latitude is about 111 m.
    expect(
      distanceMeters(
        { latitude: 13, longitude: 80 },
        { latitude: 13.001, longitude: 80 },
      ),
    ).toBeCloseTo(111.2, 0);
  });
});

describe('checkLocation', () => {
  it('is OK inside the site radius, with the distance', () => {
    expect(
      checkLocation(
        { latitude: 13.0879, longitude: 80.2009, accuracyM: 10 },
        site,
        rules,
      ),
    ).toMatchObject({ flag: 'OK', distanceM: 16 }); // 11 m north, 11 m east
  });

  it('gives GPS error the benefit of the doubt, up to 100 m', () => {
    // About 350 m away: inside if the fix is off by 80 m, outside at 20 m.
    const near = { latitude: 13.0878 + 350 / 111_200, longitude: 80.2008 };
    expect(checkLocation({ ...near, accuracyM: 80 }, site, rules).flag).toBe(
      'OK',
    );
    expect(checkLocation({ ...near, accuracyM: 20 }, site, rules).flag).toBe(
      'OUTSIDE_SITE',
    );
  });

  it('uses the default radius when the site has none', () => {
    const away = { latitude: 13.0878 + 200 / 111_200, longitude: 80.2008 };
    const check = checkLocation(
      away,
      { ...site, geofenceRadiusM: null },
      { ...rules, defaultGeofenceRadiusM: 100 },
    );
    expect(check.flag).toBe('OUTSIDE_SITE');
  });

  it('cannot judge a site without coordinates', () => {
    const noCoordinates = {
      latitude: null,
      longitude: null,
      geofenceRadiusM: null,
    };
    expect(
      checkLocation({ latitude: 1, longitude: 1 }, noCoordinates, rules),
    ).toMatchObject({
      flag: 'OK',
      distanceM: null,
    });
  });

  it('flags mock locations, or refuses them when the rules say so', () => {
    const mocked = { latitude: 13.0879, longitude: 80.2009, isMocked: true };
    const blocking = { ...rules, mockLocationAction: 'BLOCK' as const };
    expect(checkLocation(mocked, site, rules).flag).toBe('MOCKED');
    expect(() => checkLocation(mocked, site, blocking)).toThrow(
      expect.objectContaining({ code: 'MOCK_LOCATION' }),
    );
    expect(checkLocation(mocked, site, blocking, { enforce: false }).flag).toBe(
      'MOCKED',
    );
  });

  it('refuses outside the site only when the rules say BLOCK', () => {
    const far = { latitude: 13.2, longitude: 80.2 };
    expect(() =>
      checkLocation(far, site, { ...rules, outsideSiteAction: 'BLOCK' }),
    ).toThrow(expect.objectContaining({ code: 'OUTSIDE_SITE' }));
  });

  it('accepts no fix with a reason, flagged; without a reason it asks for location', () => {
    expect(
      checkLocation({ locationProblem: 'PERMISSION_DENIED' }, site, rules),
    ).toMatchObject({
      flag: 'PERMISSION_DENIED',
      latitude: null,
    });
    expect(
      checkLocation({ locationProblem: 'UNAVAILABLE' }, site, rules).flag,
    ).toBe('UNAVAILABLE');
    expect(() => checkLocation({}, site, rules)).toThrow(
      expect.objectContaining({ code: 'LOCATION_REQUIRED' }),
    );
    expect(checkLocation({}, site, { ...rules, required: false }).flag).toBe(
      'UNAVAILABLE',
    );
  });
});
