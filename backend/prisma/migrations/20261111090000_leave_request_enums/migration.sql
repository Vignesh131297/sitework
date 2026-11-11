-- AlterEnum
ALTER TYPE "AttendanceStatus" ADD VALUE 'ON_LEAVE';

-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "NotificationType" ADD VALUE 'LEAVE';
ALTER TYPE "NotificationType" ADD VALUE 'STAFF_REQUEST';

-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "ReferenceType" ADD VALUE 'LEAVE_REQUEST';
ALTER TYPE "ReferenceType" ADD VALUE 'STAFF_REQUEST';

-- New enum values can't be used in the transaction that adds them, so the tables
-- and constraints that use ON_LEAVE come in the next migration.
