-- CreateEnum
CREATE TYPE "VehicleType" AS ENUM ('BIKE', 'SCOOTER', 'CAR', 'VAN', 'OTHER');

-- CreateTable
CREATE TABLE "vehicles" (
    "id" UUID NOT NULL,
    "number" SERIAL NOT NULL,
    "type" "VehicleType" NOT NULL,
    "registration_no" TEXT NOT NULL,
    "make_model" TEXT NOT NULL,
    "note" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_by" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "vehicles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vehicle_assignments" (
    "id" UUID NOT NULL,
    "vehicle_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "given_on" DATE NOT NULL,
    "returned_on" DATE,
    "note" TEXT,
    "return_note" TEXT,
    "given_by" UUID NOT NULL,
    "returned_by" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "vehicle_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vehicle_repair_requests" (
    "id" UUID NOT NULL,
    "number" SERIAL NOT NULL,
    "request_id" UUID NOT NULL,
    "vehicle_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "amount" DECIMAL(14,2) NOT NULL,
    "note" TEXT NOT NULL,
    "status" "ApprovalStatus" NOT NULL DEFAULT 'PENDING',
    "reviewed_by" UUID,
    "reviewed_at" TIMESTAMPTZ(3),
    "review_note" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "vehicle_repair_requests_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "vehicles_number_key" ON "vehicles"("number");

-- CreateIndex
CREATE UNIQUE INDEX "vehicles_registration_no_key" ON "vehicles"("registration_no");

-- CreateIndex
CREATE INDEX "vehicles_is_active_idx" ON "vehicles"("is_active");

-- CreateIndex
CREATE INDEX "vehicle_assignments_vehicle_id_given_on_idx" ON "vehicle_assignments"("vehicle_id", "given_on");

-- CreateIndex
CREATE INDEX "vehicle_assignments_user_id_given_on_idx" ON "vehicle_assignments"("user_id", "given_on");

-- CreateIndex
CREATE UNIQUE INDEX "vehicle_repair_requests_number_key" ON "vehicle_repair_requests"("number");

-- CreateIndex
CREATE UNIQUE INDEX "vehicle_repair_requests_request_id_key" ON "vehicle_repair_requests"("request_id");

-- CreateIndex
CREATE INDEX "vehicle_repair_requests_user_id_created_at_idx" ON "vehicle_repair_requests"("user_id", "created_at");

-- CreateIndex
CREATE INDEX "vehicle_repair_requests_status_created_at_idx" ON "vehicle_repair_requests"("status", "created_at");

-- CreateIndex
CREATE INDEX "vehicle_repair_requests_vehicle_id_created_at_idx" ON "vehicle_repair_requests"("vehicle_id", "created_at");

-- AddForeignKey
ALTER TABLE "vehicles" ADD CONSTRAINT "vehicles_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vehicle_assignments" ADD CONSTRAINT "vehicle_assignments_vehicle_id_fkey" FOREIGN KEY ("vehicle_id") REFERENCES "vehicles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vehicle_assignments" ADD CONSTRAINT "vehicle_assignments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vehicle_assignments" ADD CONSTRAINT "vehicle_assignments_given_by_fkey" FOREIGN KEY ("given_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vehicle_assignments" ADD CONSTRAINT "vehicle_assignments_returned_by_fkey" FOREIGN KEY ("returned_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vehicle_repair_requests" ADD CONSTRAINT "vehicle_repair_requests_vehicle_id_fkey" FOREIGN KEY ("vehicle_id") REFERENCES "vehicles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vehicle_repair_requests" ADD CONSTRAINT "vehicle_repair_requests_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vehicle_repair_requests" ADD CONSTRAINT "vehicle_repair_requests_reviewed_by_fkey" FOREIGN KEY ("reviewed_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- ───────────── Integrity rules Prisma cannot express (added by hand) ─────────────

-- A vehicle has one holder at a time, and a person holds one vehicle at a time.
-- The open row (not yet returned) is the current holder.
CREATE UNIQUE INDEX "vehicle_assignments_one_holder_per_vehicle"
  ON "vehicle_assignments"("vehicle_id") WHERE "returned_on" IS NULL;
CREATE UNIQUE INDEX "vehicle_assignments_one_vehicle_per_user"
  ON "vehicle_assignments"("user_id") WHERE "returned_on" IS NULL;

ALTER TABLE "vehicle_assignments" ADD CONSTRAINT "vehicle_assignments_dates_in_order"
  CHECK ("returned_on" IS NULL OR "returned_on" >= "given_on");

ALTER TABLE "vehicle_repair_requests" ADD CONSTRAINT "vehicle_repair_requests_amount_positive"
  CHECK ("amount" > 0);

-- Decided requests name who decided and when; a rejection says why.
ALTER TABLE "vehicle_repair_requests" ADD CONSTRAINT "vehicle_repair_requests_decided_has_reviewer"
  CHECK ("status" NOT IN ('APPROVED', 'REJECTED') OR "reviewed_at" IS NOT NULL);
ALTER TABLE "vehicle_repair_requests" ADD CONSTRAINT "vehicle_repair_requests_rejected_has_reason"
  CHECK ("status" <> 'REJECTED' OR "review_note" IS NOT NULL);
