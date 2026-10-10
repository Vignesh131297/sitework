-- CreateEnum
CREATE TYPE "StockPlace" AS ENUM ('SUPPLIER', 'GODOWN', 'SITE', 'USED', 'WASTE', 'ADJUSTMENT');

-- CreateEnum
CREATE TYPE "StockMovementStatus" AS ENUM ('IN_TRANSIT', 'DONE', 'VOIDED');

-- CreateEnum
CREATE TYPE "StockPhotoStage" AS ENUM ('SENT', 'RECEIVED');

-- AlterEnum
ALTER TYPE "NotificationType" ADD VALUE 'STOCK';

-- AlterEnum
ALTER TYPE "ReferenceType" ADD VALUE 'STOCK_ENTRY';

-- AlterTable
ALTER TABLE "attachments" ADD COLUMN     "stock_entry_id" UUID,
ADD COLUMN     "stock_stage" "StockPhotoStage";

-- CreateTable
CREATE TABLE "godowns" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "godowns_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "materials" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "unit" TEXT NOT NULL,
    "category" TEXT,
    "min_stock" DECIMAL(12,3),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "materials_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stock_entries" (
    "id" UUID NOT NULL,
    "request_id" UUID NOT NULL,
    "from_place" "StockPlace" NOT NULL,
    "from_godown_id" UUID,
    "from_site_id" UUID,
    "to_place" "StockPlace" NOT NULL,
    "to_godown_id" UUID,
    "to_site_id" UUID,
    "status" "StockMovementStatus" NOT NULL,
    "moved_on" DATE NOT NULL,
    "dc_number" TEXT,
    "supplier" TEXT,
    "bill_no" TEXT,
    "note" TEXT,
    "created_by" UUID NOT NULL,
    "received_on" DATE,
    "received_at" TIMESTAMPTZ(3),
    "received_by" UUID,
    "receive_note" TEXT,
    "voided_at" TIMESTAMPTZ(3),
    "voided_by" UUID,
    "void_reason" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "stock_entries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stock_movements" (
    "id" UUID NOT NULL,
    "entry_id" UUID NOT NULL,
    "material_id" UUID NOT NULL,
    "quantity" DECIMAL(12,3) NOT NULL,
    "received_quantity" DECIMAL(12,3),
    "rate" DECIMAL(14,2),
    "from_place" "StockPlace" NOT NULL,
    "from_godown_id" UUID,
    "from_site_id" UUID,
    "to_place" "StockPlace" NOT NULL,
    "to_godown_id" UUID,
    "to_site_id" UUID,
    "status" "StockMovementStatus" NOT NULL,
    "moved_on" DATE NOT NULL,
    "received_on" DATE,

    CONSTRAINT "stock_movements_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "godowns_name_key" ON "godowns"("name");

-- CreateIndex
CREATE UNIQUE INDEX "materials_name_key" ON "materials"("name");

-- CreateIndex
CREATE UNIQUE INDEX "stock_entries_request_id_key" ON "stock_entries"("request_id");

-- CreateIndex
CREATE INDEX "stock_entries_status_to_place_idx" ON "stock_entries"("status", "to_place");

-- CreateIndex
CREATE INDEX "stock_entries_from_site_id_moved_on_idx" ON "stock_entries"("from_site_id", "moved_on");

-- CreateIndex
CREATE INDEX "stock_entries_to_site_id_moved_on_idx" ON "stock_entries"("to_site_id", "moved_on");

-- CreateIndex
CREATE INDEX "stock_entries_from_godown_id_moved_on_idx" ON "stock_entries"("from_godown_id", "moved_on");

-- CreateIndex
CREATE INDEX "stock_entries_to_godown_id_moved_on_idx" ON "stock_entries"("to_godown_id", "moved_on");

-- CreateIndex
CREATE INDEX "stock_entries_created_at_idx" ON "stock_entries"("created_at");

-- CreateIndex
CREATE INDEX "stock_movements_material_id_status_idx" ON "stock_movements"("material_id", "status");

-- CreateIndex
CREATE INDEX "stock_movements_from_site_id_moved_on_idx" ON "stock_movements"("from_site_id", "moved_on");

-- CreateIndex
CREATE INDEX "stock_movements_to_site_id_received_on_idx" ON "stock_movements"("to_site_id", "received_on");

-- CreateIndex
CREATE INDEX "stock_movements_from_godown_id_moved_on_idx" ON "stock_movements"("from_godown_id", "moved_on");

-- CreateIndex
CREATE INDEX "stock_movements_to_godown_id_received_on_idx" ON "stock_movements"("to_godown_id", "received_on");

-- CreateIndex
CREATE UNIQUE INDEX "stock_movements_entry_id_material_id_key" ON "stock_movements"("entry_id", "material_id");

-- CreateIndex
CREATE INDEX "attachments_stock_entry_id_idx" ON "attachments"("stock_entry_id");

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_stock_entry_id_fkey" FOREIGN KEY ("stock_entry_id") REFERENCES "stock_entries"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_entries" ADD CONSTRAINT "stock_entries_from_godown_id_fkey" FOREIGN KEY ("from_godown_id") REFERENCES "godowns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_entries" ADD CONSTRAINT "stock_entries_to_godown_id_fkey" FOREIGN KEY ("to_godown_id") REFERENCES "godowns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_entries" ADD CONSTRAINT "stock_entries_from_site_id_fkey" FOREIGN KEY ("from_site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_entries" ADD CONSTRAINT "stock_entries_to_site_id_fkey" FOREIGN KEY ("to_site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_entries" ADD CONSTRAINT "stock_entries_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_entries" ADD CONSTRAINT "stock_entries_received_by_fkey" FOREIGN KEY ("received_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_entries" ADD CONSTRAINT "stock_entries_voided_by_fkey" FOREIGN KEY ("voided_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_entry_id_fkey" FOREIGN KEY ("entry_id") REFERENCES "stock_entries"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_material_id_fkey" FOREIGN KEY ("material_id") REFERENCES "materials"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_from_godown_id_fkey" FOREIGN KEY ("from_godown_id") REFERENCES "godowns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_to_godown_id_fkey" FOREIGN KEY ("to_godown_id") REFERENCES "godowns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_from_site_id_fkey" FOREIGN KEY ("from_site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_to_site_id_fkey" FOREIGN KEY ("to_site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ───────────── Integrity rules Prisma cannot express (added by hand) ─────────────

-- An attachment belongs to exactly one engineer update, issue or stock entry, and
-- only stock photos say who took them (sender or receiver).
ALTER TABLE "attachments" DROP CONSTRAINT "attachments_single_owner";
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_single_owner"
  CHECK (num_nonnulls("engineer_update_id", "issue_id", "stock_entry_id") = 1);
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_stock_stage_matches_owner"
  CHECK (("stock_entry_id" IS NULL) = ("stock_stage" IS NULL));

ALTER TABLE "materials" ADD CONSTRAINT "materials_min_stock_non_negative"
  CHECK ("min_stock" IS NULL OR "min_stock" >= 0);

-- Entries and their lines follow the same rules for places and status.
-- A godown or site id is given exactly when the place is one; stock always goes
-- somewhere else; only moves between godowns and sites wait for the receiver; a
-- received entry says when; a voided one says so.
ALTER TABLE "stock_entries" ADD CONSTRAINT "stock_entries_from_matches_place"
  CHECK (("from_place" = 'GODOWN') = ("from_godown_id" IS NOT NULL)
    AND ("from_place" = 'SITE') = ("from_site_id" IS NOT NULL));
ALTER TABLE "stock_entries" ADD CONSTRAINT "stock_entries_to_matches_place"
  CHECK (("to_place" = 'GODOWN') = ("to_godown_id" IS NOT NULL)
    AND ("to_place" = 'SITE') = ("to_site_id" IS NOT NULL));
ALTER TABLE "stock_entries" ADD CONSTRAINT "stock_entries_moves_somewhere"
  CHECK ("from_place" <> "to_place"
    OR "from_godown_id" IS DISTINCT FROM "to_godown_id"
    OR "from_site_id" IS DISTINCT FROM "to_site_id");
ALTER TABLE "stock_entries" ADD CONSTRAINT "stock_entries_transit_between_holders"
  CHECK ("status" <> 'IN_TRANSIT'
    OR ("from_place" IN ('GODOWN', 'SITE') AND "to_place" IN ('GODOWN', 'SITE')));
ALTER TABLE "stock_entries" ADD CONSTRAINT "stock_entries_received_when_done"
  CHECK (("status" = 'DONE') <= ("received_on" IS NOT NULL)
    AND ("status" = 'IN_TRANSIT') <= ("received_on" IS NULL));
ALTER TABLE "stock_entries" ADD CONSTRAINT "stock_entries_voided_matches_status"
  CHECK (("status" = 'VOIDED') = ("voided_at" IS NOT NULL));

ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_quantity_positive"
  CHECK ("quantity" > 0);
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_from_matches_place"
  CHECK (("from_place" = 'GODOWN') = ("from_godown_id" IS NOT NULL)
    AND ("from_place" = 'SITE') = ("from_site_id" IS NOT NULL));
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_to_matches_place"
  CHECK (("to_place" = 'GODOWN') = ("to_godown_id" IS NOT NULL)
    AND ("to_place" = 'SITE') = ("to_site_id" IS NOT NULL));
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_moves_somewhere"
  CHECK ("from_place" <> "to_place"
    OR "from_godown_id" IS DISTINCT FROM "to_godown_id"
    OR "from_site_id" IS DISTINCT FROM "to_site_id");
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_transit_between_holders"
  CHECK ("status" <> 'IN_TRANSIT'
    OR ("from_place" IN ('GODOWN', 'SITE') AND "to_place" IN ('GODOWN', 'SITE')));

-- A finished line says what arrived (never more than was sent) and when.
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_received_when_done"
  CHECK ("status" <> 'DONE' OR ("received_quantity" IS NOT NULL AND "received_on" IS NOT NULL));
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_not_received_in_transit"
  CHECK ("status" <> 'IN_TRANSIT' OR ("received_quantity" IS NULL AND "received_on" IS NULL));
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_received_quantity_range"
  CHECK ("received_quantity" IS NULL OR "received_quantity" BETWEEN 0 AND "quantity");

-- Only purchases carry a price.
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_rate_on_purchases"
  CHECK ("rate" IS NULL OR ("rate" >= 0 AND "from_place" = 'SUPPLIER'));
