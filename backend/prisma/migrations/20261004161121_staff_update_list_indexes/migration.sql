-- CreateIndex
CREATE INDEX "staff_updates_submitted_at_idx" ON "staff_updates"("submitted_at");

-- CreateIndex
CREATE INDEX "staff_updates_staff_id_submitted_at_idx" ON "staff_updates"("staff_id", "submitted_at");
