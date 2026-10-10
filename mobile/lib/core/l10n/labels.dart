import '../models/enums.dart';
import '../theme/status_colors.dart';
import 'generated/app_localizations.dart';

// Display text and colour for API enums.

extension SiteStatusLabel on SiteStatus {
  String label(AppLocalizations l10n) => switch (this) {
    SiteStatus.notStarted => l10n.siteStatusNotStarted,
    SiteStatus.inProgress => l10n.siteStatusInProgress,
    SiteStatus.onHold => l10n.siteStatusOnHold,
    SiteStatus.completed => l10n.siteStatusCompleted,
  };

  StatusTone get tone => switch (this) {
    SiteStatus.notStarted => StatusTone.neutral,
    SiteStatus.inProgress => StatusTone.info,
    SiteStatus.onHold => StatusTone.warning,
    SiteStatus.completed => StatusTone.success,
  };
}

extension DesignationLabel on Designation {
  String label(AppLocalizations l10n) => switch (this) {
    Designation.mason => l10n.designationMason,
    Designation.helper => l10n.designationHelper,
    Designation.electrician => l10n.designationElectrician,
    Designation.carpenter => l10n.designationCarpenter,
    Designation.plumber => l10n.designationPlumber,
    Designation.supervisor => l10n.designationSupervisor,
    Designation.painter => l10n.designationPainter,
    Designation.generalWorker => l10n.designationGeneralWorker,
  };
}

extension MilestoneStatusLabel on MilestoneStatus {
  String label(AppLocalizations l10n) => switch (this) {
    MilestoneStatus.paid => l10n.milestonePaid,
    MilestoneStatus.partiallyPaid => l10n.milestonePartiallyPaid,
    MilestoneStatus.pending => l10n.milestonePending,
    MilestoneStatus.overdue => l10n.milestoneOverdue,
  };

  StatusTone get tone => switch (this) {
    MilestoneStatus.paid => StatusTone.success,
    MilestoneStatus.partiallyPaid => StatusTone.info,
    MilestoneStatus.pending => StatusTone.neutral,
    MilestoneStatus.overdue => StatusTone.danger,
  };
}

extension TimeSlotLabel on TimeSlot {
  String label(AppLocalizations l10n) => switch (this) {
    TimeSlot.morning => l10n.slotMorning,
    TimeSlot.afternoon => l10n.slotAfternoon,
    TimeSlot.evening => l10n.slotEvening,
  };
}

extension SlotStateLabel on SlotState {
  String label(AppLocalizations l10n) => switch (this) {
    SlotState.upcoming => l10n.slotStateUpcoming,
    SlotState.pending => l10n.slotStatePending,
    SlotState.submitted => l10n.slotStateSubmitted,
    SlotState.missing => l10n.slotStateMissing,
    SlotState.notExpected => l10n.slotStateNotExpected,
  };

  StatusTone get tone => switch (this) {
    SlotState.upcoming => StatusTone.neutral,
    SlotState.pending => StatusTone.warning,
    SlotState.submitted => StatusTone.success,
    SlotState.missing => StatusTone.danger,
    SlotState.notExpected => StatusTone.neutral,
  };
}

extension AttendanceStatusLabel on AttendanceStatus {
  String label(AppLocalizations l10n) => switch (this) {
    AttendanceStatus.present => l10n.attendancePresent,
    AttendanceStatus.late => l10n.attendanceLate,
    AttendanceStatus.halfDay => l10n.attendanceHalfDay,
    AttendanceStatus.absent => l10n.attendanceAbsent,
  };

  StatusTone get tone => switch (this) {
    AttendanceStatus.present => StatusTone.success,
    AttendanceStatus.late => StatusTone.warning,
    AttendanceStatus.halfDay => StatusTone.info,
    AttendanceStatus.absent => StatusTone.danger,
  };
}

extension PriorityLabel on Priority {
  String label(AppLocalizations l10n) => switch (this) {
    Priority.low => l10n.priorityLow,
    Priority.medium => l10n.priorityMedium,
    Priority.high => l10n.priorityHigh,
    Priority.critical => l10n.priorityCritical,
  };

  StatusTone get tone => switch (this) {
    Priority.low => StatusTone.neutral,
    Priority.medium => StatusTone.info,
    Priority.high => StatusTone.warning,
    Priority.critical => StatusTone.danger,
  };
}

extension IssueStatusLabel on IssueStatus {
  String label(AppLocalizations l10n) => switch (this) {
    IssueStatus.open => l10n.issueStatusOpen,
    IssueStatus.inProgress => l10n.issueStatusInProgress,
    IssueStatus.resolved => l10n.issueStatusResolved,
  };

  StatusTone get tone => switch (this) {
    IssueStatus.open => StatusTone.danger,
    IssueStatus.inProgress => StatusTone.warning,
    IssueStatus.resolved => StatusTone.success,
  };
}

extension LocationFlagLabel on LocationFlag {
  String label(AppLocalizations l10n) => switch (this) {
    LocationFlag.ok => l10n.locationFlagOk,
    LocationFlag.outsideSite => l10n.locationFlagOutside,
    LocationFlag.mocked => l10n.locationFlagMocked,
    LocationFlag.permissionDenied => l10n.locationFlagNoPermission,
    LocationFlag.unavailable => l10n.locationFlagUnavailable,
  };

  StatusTone get tone => switch (this) {
    LocationFlag.ok => StatusTone.success,
    LocationFlag.mocked => StatusTone.danger,
    LocationFlag.outsideSite || LocationFlag.permissionDenied || LocationFlag.unavailable => StatusTone.warning,
  };
}

extension EngineerUpdateTypeLabel on EngineerUpdateType {
  String label(AppLocalizations l10n) => switch (this) {
    EngineerUpdateType.progress => l10n.engineerUpdateTypeProgress,
    EngineerUpdateType.completedWork => l10n.engineerUpdateTypeCompletedWork,
    EngineerUpdateType.materialsRequired => l10n.engineerUpdateTypeMaterialsRequired,
    EngineerUpdateType.safetyConcern => l10n.engineerUpdateTypeSafetyConcern,
    EngineerUpdateType.clientRequirement => l10n.engineerUpdateTypeClientRequirement,
    EngineerUpdateType.remark => l10n.engineerUpdateTypeRemark,
    EngineerUpdateType.dailyReport => l10n.engineerUpdateTypeDailyReport,
  };

  StatusTone get tone => switch (this) {
    EngineerUpdateType.safetyConcern => StatusTone.danger,
    EngineerUpdateType.materialsRequired || EngineerUpdateType.clientRequirement => StatusTone.warning,
    EngineerUpdateType.completedWork => StatusTone.success,
    EngineerUpdateType.progress || EngineerUpdateType.dailyReport || EngineerUpdateType.remark => StatusTone.info,
  };
}

extension PaymentMethodLabel on PaymentMethod {
  String label(AppLocalizations l10n) => switch (this) {
    PaymentMethod.cash => l10n.paymentMethodCash,
    PaymentMethod.upi => l10n.paymentMethodUpi,
    PaymentMethod.bankTransfer => l10n.paymentMethodBankTransfer,
    PaymentMethod.cheque => l10n.paymentMethodCheque,
    PaymentMethod.other => l10n.paymentMethodOther,
  };
}

extension StockKindLabel on StockKind {
  String label(AppLocalizations l10n) => switch (this) {
    StockKind.purchase => l10n.stockKindPurchase,
    StockKind.transfer => l10n.stockKindTransfer,
    StockKind.usage => l10n.stockKindUsage,
    StockKind.writeOff => l10n.stockKindWriteOff,
    StockKind.adjustment => l10n.stockKindAdjustment,
  };
}
