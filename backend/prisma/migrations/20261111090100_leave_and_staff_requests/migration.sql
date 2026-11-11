-- CreateEnum
CREATE TYPE "LeaveType" AS ENUM ('SICK', 'CASUAL', 'OTHER');

-- CreateEnum
CREATE TYPE "ApprovalStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "StaffRequestKind" AS ENUM ('MONEY', 'FOOD');

-- CreateEnum
CREATE TYPE "Meal" AS ENUM ('BREAKFAST', 'LUNCH', 'DINNER');

-- CreateTable
CREATE TABLE "leave_requests" (
    "id" UUID NOT NULL,
    "number" SERIAL NOT NULL,
    "request_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "site_id" UUID,
    "type" "LeaveType" NOT NULL,
    "from_date" DATE NOT NULL,
    "to_date" DATE NOT NULL,
    "reason" TEXT NOT NULL,
    "status" "ApprovalStatus" NOT NULL DEFAULT 'PENDING',
    "reviewed_by" UUID,
    "reviewed_at" TIMESTAMPTZ(3),
    "review_note" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "leave_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "staff_requests" (
    "id" UUID NOT NULL,
    "number" SERIAL NOT NULL,
    "request_id" UUID NOT NULL,
    "kind" "StaffRequestKind" NOT NULL,
    "staff_id" UUID NOT NULL,
    "site_id" UUID NOT NULL,
    "amount" DECIMAL(14,2),
    "for_date" DATE,
    "meal" "Meal",
    "note" TEXT,
    "status" "ApprovalStatus" NOT NULL DEFAULT 'PENDING',
    "reviewed_by" UUID,
    "reviewed_at" TIMESTAMPTZ(3),
    "review_note" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "staff_requests_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "leave_requests_number_key" ON "leave_requests"("number");

-- CreateIndex
CREATE UNIQUE INDEX "leave_requests_request_id_key" ON "leave_requests"("request_id");

-- CreateIndex
CREATE INDEX "leave_requests_user_id_from_date_idx" ON "leave_requests"("user_id", "from_date");

-- CreateIndex
CREATE INDEX "leave_requests_status_created_at_idx" ON "leave_requests"("status", "created_at");

-- CreateIndex
CREATE INDEX "leave_requests_site_id_status_idx" ON "leave_requests"("site_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "staff_requests_number_key" ON "staff_requests"("number");

-- CreateIndex
CREATE UNIQUE INDEX "staff_requests_request_id_key" ON "staff_requests"("request_id");

-- CreateIndex
CREATE INDEX "staff_requests_staff_id_created_at_idx" ON "staff_requests"("staff_id", "created_at");

-- CreateIndex
CREATE INDEX "staff_requests_status_created_at_idx" ON "staff_requests"("status", "created_at");

-- CreateIndex
CREATE INDEX "staff_requests_site_id_status_idx" ON "staff_requests"("site_id", "status");

-- AddForeignKey
ALTER TABLE "leave_requests" ADD CONSTRAINT "leave_requests_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leave_requests" ADD CONSTRAINT "leave_requests_site_id_fkey" FOREIGN KEY ("site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leave_requests" ADD CONSTRAINT "leave_requests_reviewed_by_fkey" FOREIGN KEY ("reviewed_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_requests" ADD CONSTRAINT "staff_requests_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_requests" ADD CONSTRAINT "staff_requests_site_id_fkey" FOREIGN KEY ("site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_requests" ADD CONSTRAINT "staff_requests_reviewed_by_fkey" FOREIGN KEY ("reviewed_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- ───────────── Integrity rules Prisma cannot express (added by hand) ─────────────

-- Approved leave (no check-in) counts like an absent day for this rule.
ALTER TABLE "attendance" DROP CONSTRAINT "attendance_check_in_required";
ALTER TABLE "attendance" ADD CONSTRAINT "attendance_check_in_required"
  CHECK ("status" IN ('ABSENT', 'ON_LEAVE') OR "check_in_at" IS NOT NULL);

ALTER TABLE "leave_requests" ADD CONSTRAINT "leave_requests_dates_in_order"
  CHECK ("to_date" >= "from_date");

-- A money request has an amount and nothing else; a food request a day and a meal.
ALTER TABLE "staff_requests" ADD CONSTRAINT "staff_requests_kind_fields"
  CHECK (
    ("kind" = 'MONEY' AND "amount" > 0 AND "for_date" IS NULL AND "meal" IS NULL)
    OR ("kind" = 'FOOD' AND "amount" IS NULL AND "for_date" IS NOT NULL AND "meal" IS NOT NULL)
  );

-- Decided requests name who decided and when; a rejection says why.
ALTER TABLE "leave_requests" ADD CONSTRAINT "leave_requests_decided_has_reviewer"
  CHECK ("status" NOT IN ('APPROVED', 'REJECTED') OR "reviewed_at" IS NOT NULL);
ALTER TABLE "leave_requests" ADD CONSTRAINT "leave_requests_rejected_has_reason"
  CHECK ("status" <> 'REJECTED' OR "review_note" IS NOT NULL);
ALTER TABLE "staff_requests" ADD CONSTRAINT "staff_requests_decided_has_reviewer"
  CHECK ("status" NOT IN ('APPROVED', 'REJECTED') OR "reviewed_at" IS NOT NULL);
ALTER TABLE "staff_requests" ADD CONSTRAINT "staff_requests_rejected_has_reason"
  CHECK ("status" <> 'REJECTED' OR "review_note" IS NOT NULL);
