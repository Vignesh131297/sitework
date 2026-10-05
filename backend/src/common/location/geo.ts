import { ErrorCode } from '../errors/error-codes.js';
import { badRequest } from '../errors/http-errors.js';
import type { LocationFlag } from '../../generated/prisma/enums.js';
import type { Settings } from '../../settings/settings.schema.js';

export interface GeoPoint {
  latitude: number;
  longitude: number;
}

/** Great-circle distance in metres (haversine). */
export function distanceMeters(a: GeoPoint, b: GeoPoint): number {
  const R = 6_371_000;
  const rad = (degrees: number) => (degrees * Math.PI) / 180;
  const dLat = rad(b.latitude - a.latitude);
  const dLon = rad(b.longitude - a.longitude);
  const h =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(rad(a.latitude)) *
      Math.cos(rad(b.latitude)) *
      Math.sin(dLon / 2) ** 2;
  return 2 * R * Math.asin(Math.sqrt(h));
}

/** Where the phone was, as reported by the app. It never invents coordinates. */
export interface ReportedLocation {
  latitude?: number;
  longitude?: number;
  accuracyM?: number;
  /** Android said the position came from a mock-location app. */
  isMocked?: boolean;
  /** Why there are no coordinates. */
  locationProblem?: 'PERMISSION_DENIED' | 'UNAVAILABLE';
}

export interface SiteGeofence {
  latitude: number | null;
  longitude: number | null;
  geofenceRadiusM: number | null;
}

export interface LocationCheck {
  flag: LocationFlag;
  distanceM: number | null;
  latitude: number | null;
  longitude: number | null;
  accuracyM: number | null;
}

/** GPS error larger than this is not given the benefit of the doubt. */
const MAX_ACCURACY_ALLOWANCE_M = 100;

/**
 * Judges a reported position against the site (decision 13): no fix is allowed
 * but flagged; mock locations and positions outside the site radius are
 * flagged, or refused when the rules say BLOCK.
 */
export function checkLocation(
  reported: ReportedLocation,
  site: SiteGeofence,
  rules: Settings['location'],
  { enforce = true }: { enforce?: boolean } = {},
): LocationCheck {
  const hasFix =
    reported.latitude !== undefined && reported.longitude !== undefined;
  if (!hasFix) {
    if (rules.required && !reported.locationProblem) {
      throw badRequest(
        ErrorCode.LOCATION_REQUIRED,
        'Your location is needed. Turn on location and try again.',
      );
    }
    return {
      flag:
        reported.locationProblem === 'PERMISSION_DENIED'
          ? 'PERMISSION_DENIED'
          : 'UNAVAILABLE',
      distanceM: null,
      latitude: null,
      longitude: null,
      accuracyM: null,
    };
  }

  const position = {
    latitude: reported.latitude!,
    longitude: reported.longitude!,
  };
  const base = {
    latitude: position.latitude,
    longitude: position.longitude,
    accuracyM: reported.accuracyM ?? null,
  };
  const distanceM =
    site.latitude !== null && site.longitude !== null
      ? Math.round(
          distanceMeters(position, {
            latitude: site.latitude,
            longitude: site.longitude,
          }),
        )
      : null;

  if (reported.isMocked) {
    if (enforce && rules.mockLocationAction === 'BLOCK') {
      throw badRequest(
        ErrorCode.MOCK_LOCATION,
        'Turn off mock location apps and try again.',
      );
    }
    return { ...base, flag: 'MOCKED', distanceM };
  }

  if (distanceM !== null) {
    const radius = site.geofenceRadiusM ?? rules.defaultGeofenceRadiusM;
    const allowance = Math.min(
      reported.accuracyM ?? 0,
      MAX_ACCURACY_ALLOWANCE_M,
    );
    if (distanceM - allowance > radius) {
      if (enforce && rules.outsideSiteAction === 'BLOCK') {
        throw badRequest(
          ErrorCode.OUTSIDE_SITE,
          `You seem to be ${distanceM} m from the site. Move to the site and try again.`,
        );
      }
      return { ...base, flag: 'OUTSIDE_SITE', distanceM };
    }
  }
  return { ...base, flag: 'OK', distanceM };
}
