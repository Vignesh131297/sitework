-- CreateEnum
CREATE TYPE "MaterialRequestStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED', 'CLOSED');

-- CreateEnum
CREATE TYPE "MaterialRequestOutcome" AS ENUM ('ALL_USED', 'LEFTOVER_RETURNED');

-- AlterEnum
ALTER TYPE "ReferenceType" ADD VALUE 'MATERIAL_REQUEST';

-- AlterEnum
ALTER TYPE "Role" ADD VALUE 'GODOWN_MANAGER';

-- AlterTable
ALTER TABLE "stock_entries" ADD COLUMN     "material_request_id" UUID;

-- CreateTable
CREATE TABLE "godown_assignments" (
    "id" UUID NOT NULL,
    "godown_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "assigned_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "assigned_by" UUID,

    CONSTRAINT "godown_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "material_requests" (
    "id" UUID NOT NULL,
    "number" SERIAL NOT NULL,
    "request_id" UUID NOT NULL,
    "site_id" UUID NOT NULL,
    "requested_by" UUID NOT NULL,
    "needed_by" DATE,
    "note" TEXT,
    "status" "MaterialRequestStatus" NOT NULL DEFAULT 'PENDING',
    "godown_id" UUID,
    "reviewed_by" UUID,
    "reviewed_at" TIMESTAMPTZ(3),
    "review_note" TEXT,
    "outcome" "MaterialRequestOutcome",
    "closed_by" UUID,
    "closed_at" TIMESTAMPTZ(3),
    "close_note" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "material_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "material_request_lines" (
    "id" UUID NOT NULL,
    "material_request_id" UUID NOT NULL,
    "material_id" UUID NOT NULL,
    "quantity" DECIMAL(12,3) NOT NULL,
    "approved_quantity" DECIMAL(12,3),

    CONSTRAINT "material_request_lines_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "godown_assignments_user_id_idx" ON "godown_assignments"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "godown_assignments_godown_id_user_id_key" ON "godown_assignments"("godown_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "material_requests_number_key" ON "material_requests"("number");

-- CreateIndex
CREATE UNIQUE INDEX "material_requests_request_id_key" ON "material_requests"("request_id");

-- CreateIndex
CREATE INDEX "material_requests_status_created_at_idx" ON "material_requests"("status", "created_at");

-- CreateIndex
CREATE INDEX "material_requests_site_id_created_at_idx" ON "material_requests"("site_id", "created_at");

-- CreateIndex
CREATE INDEX "material_requests_godown_id_status_idx" ON "material_requests"("godown_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "material_request_lines_material_request_id_material_id_key" ON "material_request_lines"("material_request_id", "material_id");

-- CreateIndex
CREATE INDEX "stock_entries_material_request_id_idx" ON "stock_entries"("material_request_id");

-- AddForeignKey
ALTER TABLE "godown_assignments" ADD CONSTRAINT "godown_assignments_godown_id_fkey" FOREIGN KEY ("godown_id") REFERENCES "godowns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "godown_assignments" ADD CONSTRAINT "godown_assignments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "godown_assignments" ADD CONSTRAINT "godown_assignments_assigned_by_fkey" FOREIGN KEY ("assigned_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_entries" ADD CONSTRAINT "stock_entries_material_request_id_fkey" FOREIGN KEY ("material_request_id") REFERENCES "material_requests"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "material_requests" ADD CONSTRAINT "material_requests_site_id_fkey" FOREIGN KEY ("site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "material_requests" ADD CONSTRAINT "material_requests_requested_by_fkey" FOREIGN KEY ("requested_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "material_requests" ADD CONSTRAINT "material_requests_godown_id_fkey" FOREIGN KEY ("godown_id") REFERENCES "godowns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "material_requests" ADD CONSTRAINT "material_requests_reviewed_by_fkey" FOREIGN KEY ("reviewed_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "material_requests" ADD CONSTRAINT "material_requests_closed_by_fkey" FOREIGN KEY ("closed_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "material_request_lines" ADD CONSTRAINT "material_request_lines_material_request_id_fkey" FOREIGN KEY ("material_request_id") REFERENCES "material_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "material_request_lines" ADD CONSTRAINT "material_request_lines_material_id_fkey" FOREIGN KEY ("material_id") REFERENCES "materials"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ───────────── Integrity rules Prisma cannot express (added by hand) ─────────────

ALTER TABLE "material_request_lines" ADD CONSTRAINT "material_request_lines_quantity_positive"
  CHECK ("quantity" > 0);
ALTER TABLE "material_request_lines" ADD CONSTRAINT "material_request_lines_approved_non_negative"
  CHECK ("approved_quantity" IS NULL OR "approved_quantity" >= 0);

-- Approved (and later closed) requests name their godown and reviewer; a rejection
-- says why; only a closed request has an outcome.
ALTER TABLE "material_requests" ADD CONSTRAINT "material_requests_approved_has_godown"
  CHECK ("status" NOT IN ('APPROVED', 'CLOSED') OR ("godown_id" IS NOT NULL AND "reviewed_at" IS NOT NULL));
ALTER TABLE "material_requests" ADD CONSTRAINT "material_requests_rejected_has_reason"
  CHECK ("status" <> 'REJECTED' OR ("review_note" IS NOT NULL AND "reviewed_at" IS NOT NULL));
ALTER TABLE "material_requests" ADD CONSTRAINT "material_requests_closed_has_outcome"
  CHECK (("status" = 'CLOSED') = ("outcome" IS NOT NULL AND "closed_at" IS NOT NULL));
