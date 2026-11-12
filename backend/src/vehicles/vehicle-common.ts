import { ErrorCode } from '../common/errors/error-codes.js';
import { conflict } from '../common/errors/http-errors.js';
import type { Role, VehicleType } from '../generated/prisma/enums.js';

/** "VH-0003" (a vehicle) or "VR-0012" (money asked for a repair). */
export function vehicleCode(number: number): string {
  return `VH-${String(number).padStart(4, '0')}`;
}

export function repairCode(number: number): string {
  return `VR-${String(number).padStart(4, '0')}`;
}

/** As stored and compared: upper-case letters and digits only ("TN09AB1234"). */
export function normalizeRegistration(value: string): string {
  return value.toUpperCase().replace(/[^A-Z0-9]/g, '');
}

/** "Hero Splendor Plus · TN09AB1234", as people name a vehicle. */
export function vehicleLabel(vehicle: {
  makeModel: string;
  registrationNo: string;
}): string {
  return `${vehicle.makeModel} · ${vehicle.registrationNo}`;
}

/** The person holding or asking, as the views show them. */
export interface VehiclePerson {
  id: string;
  name: string;
  role: Role;
  employeeCode: string;
}

export const PERSON_SELECT = {
  id: true,
  name: true,
  role: true,
  employeeCode: true,
} as const;

/** The vehicle as other records refer to it. */
export interface VehicleRef {
  id: string;
  /** "VH-0003" */
  code: string;
  type: VehicleType;
  registrationNo: string;
  makeModel: string;
}

export const personHasVehicle = (name: string, label: string) =>
  conflict(
    ErrorCode.PERSON_HAS_VEHICLE,
    `${name} already has ${label}. Take it back first.`,
  );

export const vehicleAlreadyGiven = (label: string, name: string) =>
  conflict(
    ErrorCode.VEHICLE_ALREADY_GIVEN,
    `${label} is with ${name}. Take it back first.`,
  );
