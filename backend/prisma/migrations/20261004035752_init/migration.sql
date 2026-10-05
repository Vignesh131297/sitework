-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'ENGINEER', 'STAFF');

-- CreateEnum
CREATE TYPE "Designation" AS ENUM ('MASON', 'HELPER', 'ELECTRICIAN', 'CARPENTER', 'PLUMBER', 'SUPERVISOR', 'PAINTER', 'GENERAL_WORKER');

-- CreateEnum
CREATE TYPE "SiteStatus" AS ENUM ('NOT_STARTED', 'IN_PROGRESS', 'ON_HOLD', 'COMPLETED');

-- CreateEnum
CREATE TYPE "AssignmentKind" AS ENUM ('ENGINEER', 'STAFF');

-- CreateEnum
CREATE TYPE "TimeSlot" AS ENUM ('MORNING', 'AFTERNOON', 'EVENING');

-- CreateEnum
CREATE TYPE "ImageStatus" AS ENUM ('AVAILABLE', 'READY_FOR_DELETION', 'DELETED');

-- CreateEnum
CREATE TYPE "ImageDeleteReason" AS ENUM ('ALL_VIEWED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "PhotoSource" AS ENUM ('CAMERA', 'GALLERY');

-- CreateEnum
CREATE TYPE "LocationFlag" AS ENUM ('OK', 'PERMISSION_DENIED', 'UNAVAILABLE', 'MOCKED', 'OUTSIDE_SITE');

-- CreateEnum
CREATE TYPE "AttendanceStatus" AS ENUM ('PRESENT', 'LATE', 'HALF_DAY', 'ABSENT');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('CASH', 'UPI', 'BANK_TRANSFER', 'CHEQUE', 'OTHER');

-- CreateEnum
CREATE TYPE "EngineerUpdateType" AS ENUM ('PROGRESS', 'COMPLETED_WORK', 'MATERIALS_REQUIRED', 'SAFETY_CONCERN', 'CLIENT_REQUIREMENT', 'REMARK', 'DAILY_REPORT');

-- CreateEnum
CREATE TYPE "Priority" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL');

-- CreateEnum
CREATE TYPE "IssueStatus" AS ENUM ('OPEN', 'IN_PROGRESS', 'RESOLVED');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('STAFF_UPDATE', 'ENGINEER_UPDATE', 'MISSING_UPDATE', 'PAYMENT', 'ISSUE', 'ATTENDANCE', 'SYSTEM');

-- CreateEnum
CREATE TYPE "ReferenceType" AS ENUM ('STAFF_UPDATE', 'MISSED_UPDATE', 'ENGINEER_UPDATE', 'ISSUE', 'SITE', 'PAYMENT_MILESTONE', 'PAYMENT', 'ATTENDANCE');

-- CreateEnum
CREATE TYPE "PushStatus" AS ENUM ('PENDING', 'SENT', 'FAILED', 'NO_DEVICE');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "role" "Role" NOT NULL,
    "name" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "email" TEXT,
    "password_hash" TEXT NOT NULL,
    "employee_code" TEXT NOT NULL,
    "designation" "Designation",
    "joining_date" DATE,
    "photo_key" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "must_change_password" BOOLEAN NOT NULL DEFAULT false,
    "failed_login_count" INTEGER NOT NULL DEFAULT 0,
    "locked_until" TIMESTAMPTZ(3),
    "last_login_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "auth_sessions" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "refresh_token_hash" TEXT NOT NULL,
    "device_name" TEXT,
    "ip_address" TEXT,
    "expires_at" TIMESTAMPTZ(3) NOT NULL,
    "revoked_at" TIMESTAMPTZ(3),
    "last_used_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "auth_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "device_tokens" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "fcm_token" TEXT NOT NULL,
    "platform" TEXT NOT NULL DEFAULT 'android',
    "app_version" TEXT,
    "last_seen_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "device_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "password_reset_codes" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "code_hash" TEXT NOT NULL,
    "expires_at" TIMESTAMPTZ(3) NOT NULL,
    "used_at" TIMESTAMPTZ(3),
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "password_reset_codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "clients" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "company" TEXT,
    "phone" TEXT NOT NULL,
    "email" TEXT,
    "address" TEXT,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "clients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sites" (
    "id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "client_id" UUID NOT NULL,
    "contact_name" TEXT,
    "contact_phone" TEXT,
    "address" TEXT NOT NULL,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "geofence_radius_m" INTEGER,
    "start_date" DATE NOT NULL,
    "expected_completion_date" DATE,
    "contract_amount" DECIMAL(14,2) NOT NULL,
    "status" "SiteStatus" NOT NULL DEFAULT 'NOT_STARTED',
    "progress_percent" SMALLINT NOT NULL DEFAULT 0,
    "created_by" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "sites_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "engineer_assignments" (
    "id" UUID NOT NULL,
    "site_id" UUID NOT NULL,
    "engineer_id" UUID NOT NULL,
    "assigned_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "assigned_by" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "engineer_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "staff_assignments" (
    "id" UUID NOT NULL,
    "staff_id" UUID NOT NULL,
    "site_id" UUID NOT NULL,
    "engineer_id" UUID NOT NULL,
    "assigned_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "assigned_by" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "staff_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assignment_history" (
    "id" UUID NOT NULL,
    "kind" "AssignmentKind" NOT NULL,
    "user_id" UUID NOT NULL,
    "site_id" UUID NOT NULL,
    "engineer_id" UUID,
    "assigned_at" TIMESTAMPTZ(3) NOT NULL,
    "unassigned_at" TIMESTAMPTZ(3) NOT NULL,
    "ended_by" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "assignment_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attendance" (
    "id" UUID NOT NULL,
    "staff_id" UUID NOT NULL,
    "site_id" UUID NOT NULL,
    "work_date" DATE NOT NULL,
    "status" "AttendanceStatus" NOT NULL,
    "check_in_at" TIMESTAMPTZ(3),
    "check_in_latitude" DOUBLE PRECISION,
    "check_in_longitude" DOUBLE PRECISION,
    "check_in_accuracy_m" DOUBLE PRECISION,
    "check_in_location_flag" "LocationFlag",
    "check_out_at" TIMESTAMPTZ(3),
    "check_out_latitude" DOUBLE PRECISION,
    "check_out_longitude" DOUBLE PRECISION,
    "check_out_accuracy_m" DOUBLE PRECISION,
    "check_out_location_flag" "LocationFlag",
    "corrected_by" UUID,
    "correction_note" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "attendance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "staff_updates" (
    "id" UUID NOT NULL,
    "client_submission_id" UUID NOT NULL,
    "staff_id" UUID NOT NULL,
    "site_id" UUID NOT NULL,
    "engineer_id" UUID NOT NULL,
    "work_date" DATE NOT NULL,
    "slot" "TimeSlot" NOT NULL,
    "description" TEXT NOT NULL,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "accuracy_m" DOUBLE PRECISION,
    "location_flag" "LocationFlag" NOT NULL,
    "distance_from_site_m" INTEGER,
    "photo_source" "PhotoSource" NOT NULL,
    "captured_at" TIMESTAMPTZ(3) NOT NULL,
    "submitted_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "submitted_offline" BOOLEAN NOT NULL DEFAULT false,
    "image_key" TEXT,
    "image_bytes" INTEGER NOT NULL,
    "image_mime" TEXT NOT NULL,
    "image_status" "ImageStatus" NOT NULL DEFAULT 'AVAILABLE',
    "image_expires_at" TIMESTAMPTZ(3) NOT NULL,
    "image_ready_at" TIMESTAMPTZ(3),
    "image_deleted_at" TIMESTAMPTZ(3),
    "image_delete_reason" "ImageDeleteReason",
    "image_delete_attempts" INTEGER NOT NULL DEFAULT 0,
    "engineer_viewed_at" TIMESTAMPTZ(3),
    "admin_viewed_at" TIMESTAMPTZ(3),
    "admin_viewed_by" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "staff_updates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "missed_updates" (
    "id" UUID NOT NULL,
    "staff_id" UUID NOT NULL,
    "site_id" UUID NOT NULL,
    "engineer_id" UUID NOT NULL,
    "work_date" DATE NOT NULL,
    "slot" "TimeSlot" NOT NULL,
    "detected_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resolved_at" TIMESTAMPTZ(3),
    "resolved_by_update_id" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "missed_updates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "engineer_updates" (
    "id" UUID NOT NULL,
    "engineer_id" UUID NOT NULL,
    "site_id" UUID NOT NULL,
    "type" "EngineerUpdateType" NOT NULL,
    "priority" "Priority" NOT NULL DEFAULT 'MEDIUM',
    "title" TEXT,
    "description" TEXT NOT NULL,
    "progress_percent" SMALLINT,
    "admin_viewed_at" TIMESTAMPTZ(3),
    "admin_viewed_by" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "engineer_updates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "issues" (
    "id" UUID NOT NULL,
    "site_id" UUID NOT NULL,
    "reported_by" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "priority" "Priority" NOT NULL DEFAULT 'MEDIUM',
    "status" "IssueStatus" NOT NULL DEFAULT 'OPEN',
    "resolved_at" TIMESTAMPTZ(3),
    "resolved_by" UUID,
    "resolution_note" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "issues_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attachments" (
    "id" UUID NOT NULL,
    "engineer_update_id" UUID,
    "issue_id" UUID,
    "object_key" TEXT NOT NULL,
    "mime" TEXT NOT NULL,
    "bytes" INTEGER NOT NULL,
    "uploaded_by" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "attachments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_milestones" (
    "id" UUID NOT NULL,
    "site_id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "amount" DECIMAL(14,2) NOT NULL,
    "due_date" DATE NOT NULL,
    "notes" TEXT,
    "created_by" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "payment_milestones_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payments" (
    "id" UUID NOT NULL,
    "site_id" UUID NOT NULL,
    "amount" DECIMAL(14,2) NOT NULL,
    "paid_on" DATE NOT NULL,
    "method" "PaymentMethod" NOT NULL,
    "reference" TEXT,
    "remarks" TEXT,
    "recorded_by" UUID NOT NULL,
    "voided_at" TIMESTAMPTZ(3),
    "voided_by" UUID,
    "void_reason" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" UUID NOT NULL,
    "recipient_id" UUID NOT NULL,
    "type" "NotificationType" NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "reference_type" "ReferenceType",
    "reference_id" UUID,
    "data" JSONB,
    "dedupe_key" TEXT,
    "is_read" BOOLEAN NOT NULL DEFAULT false,
    "read_at" TIMESTAMPTZ(3),
    "push_status" "PushStatus" NOT NULL DEFAULT 'PENDING',
    "push_attempts" INTEGER NOT NULL DEFAULT 0,
    "push_sent_at" TIMESTAMPTZ(3),
    "push_error" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "app_settings" (
    "key" TEXT NOT NULL,
    "value" JSONB NOT NULL,
    "updated_by" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "app_settings_pkey" PRIMARY KEY ("key")
);

-- CreateTable
CREATE TABLE "holidays" (
    "id" UUID NOT NULL,
    "date" DATE NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "holidays_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" UUID NOT NULL,
    "actor_id" UUID,
    "action" TEXT NOT NULL,
    "entity_type" TEXT NOT NULL,
    "entity_id" TEXT NOT NULL,
    "changes" JSONB,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_key" ON "users"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_employee_code_key" ON "users"("employee_code");

-- CreateIndex
CREATE INDEX "users_role_is_active_idx" ON "users"("role", "is_active");

-- CreateIndex
CREATE INDEX "auth_sessions_user_id_idx" ON "auth_sessions"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "device_tokens_fcm_token_key" ON "device_tokens"("fcm_token");

-- CreateIndex
CREATE INDEX "device_tokens_user_id_idx" ON "device_tokens"("user_id");

-- CreateIndex
CREATE INDEX "password_reset_codes_user_id_created_at_idx" ON "password_reset_codes"("user_id", "created_at");

-- CreateIndex
CREATE INDEX "clients_name_idx" ON "clients"("name");

-- CreateIndex
CREATE UNIQUE INDEX "sites_code_key" ON "sites"("code");

-- CreateIndex
CREATE INDEX "sites_client_id_idx" ON "sites"("client_id");

-- CreateIndex
CREATE INDEX "sites_status_idx" ON "sites"("status");

-- CreateIndex
CREATE INDEX "engineer_assignments_engineer_id_idx" ON "engineer_assignments"("engineer_id");

-- CreateIndex
CREATE UNIQUE INDEX "engineer_assignments_site_id_engineer_id_key" ON "engineer_assignments"("site_id", "engineer_id");

-- CreateIndex
CREATE UNIQUE INDEX "staff_assignments_staff_id_key" ON "staff_assignments"("staff_id");

-- CreateIndex
CREATE INDEX "staff_assignments_site_id_engineer_id_idx" ON "staff_assignments"("site_id", "engineer_id");

-- CreateIndex
CREATE INDEX "staff_assignments_engineer_id_idx" ON "staff_assignments"("engineer_id");

-- CreateIndex
CREATE INDEX "assignment_history_user_id_assigned_at_idx" ON "assignment_history"("user_id", "assigned_at");

-- CreateIndex
CREATE INDEX "assignment_history_site_id_assigned_at_idx" ON "assignment_history"("site_id", "assigned_at");

-- CreateIndex
CREATE INDEX "attendance_site_id_work_date_idx" ON "attendance"("site_id", "work_date");

-- CreateIndex
CREATE INDEX "attendance_work_date_idx" ON "attendance"("work_date");

-- CreateIndex
CREATE UNIQUE INDEX "attendance_staff_id_work_date_key" ON "attendance"("staff_id", "work_date");

-- CreateIndex
CREATE UNIQUE INDEX "staff_updates_client_submission_id_key" ON "staff_updates"("client_submission_id");

-- CreateIndex
CREATE INDEX "staff_updates_site_id_work_date_idx" ON "staff_updates"("site_id", "work_date");

-- CreateIndex
CREATE INDEX "staff_updates_engineer_id_work_date_idx" ON "staff_updates"("engineer_id", "work_date");

-- CreateIndex
CREATE INDEX "staff_updates_work_date_slot_idx" ON "staff_updates"("work_date", "slot");

-- CreateIndex
CREATE INDEX "staff_updates_image_status_image_expires_at_idx" ON "staff_updates"("image_status", "image_expires_at");

-- CreateIndex
CREATE UNIQUE INDEX "staff_updates_staff_id_site_id_work_date_slot_key" ON "staff_updates"("staff_id", "site_id", "work_date", "slot");

-- CreateIndex
CREATE UNIQUE INDEX "missed_updates_resolved_by_update_id_key" ON "missed_updates"("resolved_by_update_id");

-- CreateIndex
CREATE INDEX "missed_updates_site_id_work_date_idx" ON "missed_updates"("site_id", "work_date");

-- CreateIndex
CREATE INDEX "missed_updates_engineer_id_work_date_idx" ON "missed_updates"("engineer_id", "work_date");

-- CreateIndex
CREATE INDEX "missed_updates_work_date_slot_idx" ON "missed_updates"("work_date", "slot");

-- CreateIndex
CREATE UNIQUE INDEX "missed_updates_staff_id_work_date_slot_key" ON "missed_updates"("staff_id", "work_date", "slot");

-- CreateIndex
CREATE INDEX "engineer_updates_site_id_created_at_idx" ON "engineer_updates"("site_id", "created_at");

-- CreateIndex
CREATE INDEX "engineer_updates_engineer_id_created_at_idx" ON "engineer_updates"("engineer_id", "created_at");

-- CreateIndex
CREATE INDEX "engineer_updates_created_at_idx" ON "engineer_updates"("created_at");

-- CreateIndex
CREATE INDEX "issues_site_id_status_idx" ON "issues"("site_id", "status");

-- CreateIndex
CREATE INDEX "issues_status_priority_idx" ON "issues"("status", "priority");

-- CreateIndex
CREATE INDEX "issues_created_at_idx" ON "issues"("created_at");

-- CreateIndex
CREATE UNIQUE INDEX "attachments_object_key_key" ON "attachments"("object_key");

-- CreateIndex
CREATE INDEX "attachments_engineer_update_id_idx" ON "attachments"("engineer_update_id");

-- CreateIndex
CREATE INDEX "attachments_issue_id_idx" ON "attachments"("issue_id");

-- CreateIndex
CREATE INDEX "payment_milestones_site_id_due_date_idx" ON "payment_milestones"("site_id", "due_date");

-- CreateIndex
CREATE INDEX "payment_milestones_due_date_idx" ON "payment_milestones"("due_date");

-- CreateIndex
CREATE INDEX "payments_site_id_paid_on_idx" ON "payments"("site_id", "paid_on");

-- CreateIndex
CREATE INDEX "payments_paid_on_idx" ON "payments"("paid_on");

-- CreateIndex
CREATE INDEX "notifications_recipient_id_is_read_created_at_idx" ON "notifications"("recipient_id", "is_read", "created_at" DESC);

-- CreateIndex
CREATE INDEX "notifications_push_status_created_at_idx" ON "notifications"("push_status", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "notifications_recipient_id_dedupe_key_key" ON "notifications"("recipient_id", "dedupe_key");

-- CreateIndex
CREATE UNIQUE INDEX "holidays_date_key" ON "holidays"("date");

-- CreateIndex
CREATE INDEX "audit_logs_entity_type_entity_id_idx" ON "audit_logs"("entity_type", "entity_id");

-- CreateIndex
CREATE INDEX "audit_logs_actor_id_created_at_idx" ON "audit_logs"("actor_id", "created_at");

-- CreateIndex
CREATE INDEX "audit_logs_created_at_idx" ON "audit_logs"("created_at");

-- AddForeignKey
ALTER TABLE "auth_sessions" ADD CONSTRAINT "auth_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "device_tokens" ADD CONSTRAINT "device_tokens_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "password_reset_codes" ADD CONSTRAINT "password_reset_codes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sites" ADD CONSTRAINT "sites_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "clients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sites" ADD CONSTRAINT "sites_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "engineer_assignments" ADD CONSTRAINT "engineer_assignments_site_id_fkey" FOREIGN KEY ("site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "engineer_assignments" ADD CONSTRAINT "engineer_assignments_engineer_id_fkey" FOREIGN KEY ("engineer_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "engineer_assignments" ADD CONSTRAINT "engineer_assignments_assigned_by_fkey" FOREIGN KEY ("assigned_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_assignments" ADD CONSTRAINT "staff_assignments_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_assignments" ADD CONSTRAINT "staff_assignments_site_id_fkey" FOREIGN KEY ("site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_assignments" ADD CONSTRAINT "staff_assignments_engineer_id_fkey" FOREIGN KEY ("engineer_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_assignments" ADD CONSTRAINT "staff_assignments_assigned_by_fkey" FOREIGN KEY ("assigned_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_assignments" ADD CONSTRAINT "staff_assignments_site_id_engineer_id_fkey" FOREIGN KEY ("site_id", "engineer_id") REFERENCES "engineer_assignments"("site_id", "engineer_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_history" ADD CONSTRAINT "assignment_history_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_history" ADD CONSTRAINT "assignment_history_site_id_fkey" FOREIGN KEY ("site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_history" ADD CONSTRAINT "assignment_history_engineer_id_fkey" FOREIGN KEY ("engineer_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_history" ADD CONSTRAINT "assignment_history_ended_by_fkey" FOREIGN KEY ("ended_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance" ADD CONSTRAINT "attendance_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance" ADD CONSTRAINT "attendance_site_id_fkey" FOREIGN KEY ("site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance" ADD CONSTRAINT "attendance_corrected_by_fkey" FOREIGN KEY ("corrected_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_updates" ADD CONSTRAINT "staff_updates_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_updates" ADD CONSTRAINT "staff_updates_site_id_fkey" FOREIGN KEY ("site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_updates" ADD CONSTRAINT "staff_updates_engineer_id_fkey" FOREIGN KEY ("engineer_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_updates" ADD CONSTRAINT "staff_updates_admin_viewed_by_fkey" FOREIGN KEY ("admin_viewed_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "missed_updates" ADD CONSTRAINT "missed_updates_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "missed_updates" ADD CONSTRAINT "missed_updates_site_id_fkey" FOREIGN KEY ("site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "missed_updates" ADD CONSTRAINT "missed_updates_engineer_id_fkey" FOREIGN KEY ("engineer_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "missed_updates" ADD CONSTRAINT "missed_updates_resolved_by_update_id_fkey" FOREIGN KEY ("resolved_by_update_id") REFERENCES "staff_updates"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "engineer_updates" ADD CONSTRAINT "engineer_updates_engineer_id_fkey" FOREIGN KEY ("engineer_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "engineer_updates" ADD CONSTRAINT "engineer_updates_site_id_fkey" FOREIGN KEY ("site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "engineer_updates" ADD CONSTRAINT "engineer_updates_admin_viewed_by_fkey" FOREIGN KEY ("admin_viewed_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "issues" ADD CONSTRAINT "issues_site_id_fkey" FOREIGN KEY ("site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "issues" ADD CONSTRAINT "issues_reported_by_fkey" FOREIGN KEY ("reported_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "issues" ADD CONSTRAINT "issues_resolved_by_fkey" FOREIGN KEY ("resolved_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_engineer_update_id_fkey" FOREIGN KEY ("engineer_update_id") REFERENCES "engineer_updates"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_issue_id_fkey" FOREIGN KEY ("issue_id") REFERENCES "issues"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_uploaded_by_fkey" FOREIGN KEY ("uploaded_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_milestones" ADD CONSTRAINT "payment_milestones_site_id_fkey" FOREIGN KEY ("site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_milestones" ADD CONSTRAINT "payment_milestones_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_site_id_fkey" FOREIGN KEY ("site_id") REFERENCES "sites"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_recorded_by_fkey" FOREIGN KEY ("recorded_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_voided_by_fkey" FOREIGN KEY ("voided_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_recipient_id_fkey" FOREIGN KEY ("recipient_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ─────────────────────────────────────────────────────────────────────────────
-- Integrity rules the Prisma schema language cannot express. Prisma leaves CHECK
-- constraints alone in later migrations, so they only need to be declared here.
-- ─────────────────────────────────────────────────────────────────────────────

-- Only staff have a designation.
ALTER TABLE "users" ADD CONSTRAINT "users_designation_staff_only"
  CHECK ("role" = 'STAFF' OR "designation" IS NULL);

ALTER TABLE "sites" ADD CONSTRAINT "sites_contract_amount_non_negative"
  CHECK ("contract_amount" >= 0);
ALTER TABLE "sites" ADD CONSTRAINT "sites_progress_percent_range"
  CHECK ("progress_percent" BETWEEN 0 AND 100);
ALTER TABLE "sites" ADD CONSTRAINT "sites_geofence_radius_positive"
  CHECK ("geofence_radius_m" IS NULL OR "geofence_radius_m" > 0);
ALTER TABLE "sites" ADD CONSTRAINT "sites_completion_after_start"
  CHECK ("expected_completion_date" IS NULL OR "expected_completion_date" >= "start_date");

-- Only an ABSENT day may lack a check-in; check-out can't precede check-in.
ALTER TABLE "attendance" ADD CONSTRAINT "attendance_check_in_required"
  CHECK ("status" = 'ABSENT' OR "check_in_at" IS NOT NULL);
ALTER TABLE "attendance" ADD CONSTRAINT "attendance_check_out_after_check_in"
  CHECK ("check_out_at" IS NULL OR "check_out_at" >= "check_in_at");

-- The photo path exists exactly until the photo is deleted.
ALTER TABLE "staff_updates" ADD CONSTRAINT "staff_updates_image_key_matches_status"
  CHECK (("image_status" = 'DELETED') = ("image_key" IS NULL));

ALTER TABLE "engineer_updates" ADD CONSTRAINT "engineer_updates_progress_percent_range"
  CHECK ("progress_percent" IS NULL OR "progress_percent" BETWEEN 0 AND 100);

-- An attachment belongs to exactly one engineer update or issue.
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_single_owner"
  CHECK (num_nonnulls("engineer_update_id", "issue_id") = 1);

ALTER TABLE "payment_milestones" ADD CONSTRAINT "payment_milestones_amount_positive"
  CHECK ("amount" > 0);
ALTER TABLE "payments" ADD CONSTRAINT "payments_amount_positive"
  CHECK ("amount" > 0);