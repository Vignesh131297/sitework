-- AlterEnum
ALTER TYPE "NotificationType" ADD VALUE 'VEHICLE';

-- AlterEnum
ALTER TYPE "ReferenceType" ADD VALUE 'VEHICLE';
ALTER TYPE "ReferenceType" ADD VALUE 'VEHICLE_REPAIR_REQUEST';

-- New enum values can't be used in the transaction that adds them, so the vehicle
-- tables come in the next migration.
