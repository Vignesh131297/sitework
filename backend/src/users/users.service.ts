import { HttpStatus, Injectable } from '@nestjs/common';
import { AppException } from '../common/errors/app.exception.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import { fromDbDate } from '../common/time/business-time.js';
import type { Designation, Role } from '../generated/prisma/enums.js';
import { UsersRepository } from './users.repository.js';

export interface MeProfile {
  id: string;
  name: string;
  role: Role;
  phone: string;
  email: string | null;
  employeeCode: string;
  designation: Designation | null;
  joiningDate: string | null;
  mustChangePassword: boolean;
  /** Staff: their site and responsible engineer. */
  assignment: {
    site: { id: string; code: string; name: string; address: string };
    engineer: { id: string; name: string; phone: string };
  } | null;
  /** Engineers: the sites they are assigned to. */
  sites: { id: string; code: string; name: string }[];
}

@Injectable()
export class UsersService {
  constructor(private readonly users: UsersRepository) {}

  async getProfile(userId: string): Promise<MeProfile> {
    const user = await this.users.findProfile(userId);
    if (!user) {
      throw new AppException(
        ErrorCode.NOT_FOUND,
        'Your account was not found.',
        HttpStatus.NOT_FOUND,
      );
    }
    return {
      id: user.id,
      name: user.name,
      role: user.role,
      phone: user.phone,
      email: user.email,
      employeeCode: user.employeeCode,
      designation: user.designation,
      joiningDate: user.joiningDate ? fromDbDate(user.joiningDate) : null,
      mustChangePassword: user.mustChangePassword,
      assignment: user.staffAssignment
        ? {
            site: user.staffAssignment.site,
            engineer: user.staffAssignment.engineer,
          }
        : null,
      sites: user.engineerAssignments.map((assignment) => assignment.site),
    };
  }
}
