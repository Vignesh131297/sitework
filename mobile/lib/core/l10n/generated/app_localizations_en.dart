// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SiteWork';

  @override
  String get appTagline => 'Site work, tracked on time.';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Try again';

  @override
  String get loginIdentifierLabel => 'Mobile number or e-mail';

  @override
  String get loginIdentifierRequired => 'Enter your mobile number or e-mail.';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordRequired => 'Enter your password.';

  @override
  String get loginShowPassword => 'Show password';

  @override
  String get loginHidePassword => 'Hide password';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginSessionEnded => 'Your session has ended. Please sign in again.';

  @override
  String get loginDevQuickSignIn => 'Quick sign-in (development build)';

  @override
  String get forgotTitle => 'Forgot password';

  @override
  String get forgotBody =>
      'Enter the mobile number or e-mail you sign in with. If your account has an e-mail address, we\'ll send it a 6-digit code.';

  @override
  String get forgotSend => 'Send code';

  @override
  String get forgotSendAgain => 'Send a new code';

  @override
  String get forgotHaveCode => 'I have a code';

  @override
  String get resetTitle => 'Reset password';

  @override
  String get resetCodeLabel => '6-digit code';

  @override
  String get resetCodeInvalid => 'Enter the 6-digit code from the e-mail.';

  @override
  String get resetSubmit => 'Set new password';

  @override
  String get resetDone => 'Password changed. Sign in with your new password.';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get changePasswordForcedBody =>
      'Your admin gave you a temporary password. Choose your own password to continue.';

  @override
  String get temporaryPasswordLabel => 'Temporary password';

  @override
  String get currentPasswordLabel => 'Current password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmPasswordLabel => 'Confirm new password';

  @override
  String get passwordHelper => 'At least 8 characters, with letters and numbers.';

  @override
  String get passwordTooShort => 'Use at least 8 characters.';

  @override
  String get passwordNeedsLettersAndNumbers => 'Use both letters and numbers.';

  @override
  String get passwordsDontMatch => 'The passwords don\'t match.';

  @override
  String get changePasswordSubmit => 'Save password';

  @override
  String get changePasswordDone => 'Your password has been changed.';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleEngineer => 'Engineer';

  @override
  String get roleStaff => 'Staff';

  @override
  String get serverChecking => 'Checking server…';

  @override
  String get serverConnected => 'Server connected';

  @override
  String get serverUnreachable => 'Can\'t reach the server';

  @override
  String serverDetails(String environment, String version, String time) {
    return '$environment · v$version · server time $time';
  }

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navSites => 'Sites';

  @override
  String get navPayments => 'Payments';

  @override
  String get navPeople => 'People';

  @override
  String get navAlerts => 'Alerts';

  @override
  String get navUpdates => 'Updates';

  @override
  String get navIssues => 'Issues';

  @override
  String get navHome => 'Home';

  @override
  String get navAttendance => 'Attendance';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get screenNotifications => 'Notifications';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profilePhone => 'Mobile';

  @override
  String get profileEmail => 'E-mail';

  @override
  String get profileEmployeeId => 'Employee ID';

  @override
  String get profileSite => 'Site';

  @override
  String get profileEngineer => 'Engineer';

  @override
  String get profileSites => 'Your sites';

  @override
  String get profileChangePassword => 'Change password';

  @override
  String get profileServerSection => 'Server';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileSignOutConfirmTitle => 'Sign out?';

  @override
  String get profileSignOutConfirmBody => 'You will need to sign in again to use the app.';

  @override
  String get errorOffline => 'You\'re offline. Check your internet connection and try again.';

  @override
  String get errorTimeout => 'The server is taking too long to respond. Please try again.';

  @override
  String get errorSessionExpired => 'Your session has ended. Please sign in again.';

  @override
  String get errorForbidden => 'You don\'t have permission to do that.';

  @override
  String get errorNotFound => 'We couldn\'t find what you were looking for.';

  @override
  String get errorRateLimited => 'Too many attempts. Please wait a moment and try again.';

  @override
  String get errorServiceUnavailable => 'The service is temporarily unavailable. Please try again shortly.';

  @override
  String get errorServer => 'Something went wrong on our side. Please try again.';

  @override
  String get errorBadRequest => 'Something about that request wasn\'t right. Please try again.';

  @override
  String get errorFileTooLarge => 'The file is too large.';

  @override
  String get errorUnexpected => 'Something unexpected happened. Please try again.';

  @override
  String get commonSave => 'Save';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonCopied => 'Copied';

  @override
  String get commonAll => 'All';

  @override
  String get commonMore => 'More';

  @override
  String get commonNone => 'None';

  @override
  String get commonActive => 'Active';

  @override
  String get commonInactive => 'Inactive';

  @override
  String get commonCall => 'Call';

  @override
  String get commonOpenMap => 'Open in Maps';

  @override
  String get commonOpenSettings => 'Open settings';

  @override
  String get validationRequired => 'Required';

  @override
  String get validationQuantity => 'Enter a quantity like 60 or 12.5.';

  @override
  String get validationAmount => 'Enter an amount like 1500000';

  @override
  String get validationPhone => 'Enter a 10-digit mobile number';

  @override
  String get validationEmail => 'Enter a valid e-mail address';

  @override
  String get validationNumber => 'Enter a number';

  @override
  String validationRange(int min, int max) {
    return 'Enter a value between $min and $max';
  }

  @override
  String get siteStatusNotStarted => 'Not started';

  @override
  String get siteStatusInProgress => 'In progress';

  @override
  String get siteStatusOnHold => 'On hold';

  @override
  String get siteStatusCompleted => 'Completed';

  @override
  String get designationMason => 'Mason';

  @override
  String get designationHelper => 'Helper';

  @override
  String get designationElectrician => 'Electrician';

  @override
  String get designationCarpenter => 'Carpenter';

  @override
  String get designationPlumber => 'Plumber';

  @override
  String get designationSupervisor => 'Supervisor';

  @override
  String get designationPainter => 'Painter';

  @override
  String get designationGeneralWorker => 'General worker';

  @override
  String get milestonePaid => 'Paid';

  @override
  String get milestonePartiallyPaid => 'Partially paid';

  @override
  String get milestonePending => 'Pending';

  @override
  String get milestoneOverdue => 'Overdue';

  @override
  String get slotMorning => 'Morning';

  @override
  String get slotAfternoon => 'Afternoon';

  @override
  String get slotEvening => 'Evening';

  @override
  String get slotStateUpcoming => 'Upcoming';

  @override
  String get slotStatePending => 'Pending';

  @override
  String get slotStateSubmitted => 'Submitted';

  @override
  String get slotStateMissing => 'Missing';

  @override
  String get slotStateNotExpected => 'Not due';

  @override
  String get attendancePresent => 'Present';

  @override
  String get attendanceLate => 'Late';

  @override
  String get attendanceHalfDay => 'Half day';

  @override
  String get attendanceAbsent => 'Absent';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityCritical => 'Critical';

  @override
  String get issueStatusOpen => 'Open';

  @override
  String get issueStatusInProgress => 'In progress';

  @override
  String get issueStatusResolved => 'Resolved';

  @override
  String dashboardHoliday(String name) {
    return 'Today is a holiday ($name). No updates are expected.';
  }

  @override
  String get dashboardDayOff => 'Today is not a working day. No updates are expected.';

  @override
  String get statActiveSites => 'Active sites';

  @override
  String get statClients => 'Clients';

  @override
  String get statEngineers => 'Engineers';

  @override
  String get statStaff => 'Staff';

  @override
  String get paymentsTitle => 'Payments';

  @override
  String get paymentsContract => 'Contract value';

  @override
  String get paymentsReceived => 'Received';

  @override
  String get paymentsPending => 'Pending';

  @override
  String get paymentsOverdue => 'Overdue';

  @override
  String paymentsOverdueCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count milestones', one: '1 milestone');
    return '$_temp0';
  }

  @override
  String get todayUpdatesTitle => 'Today\'s updates';

  @override
  String updatesSubmittedOf(int submitted, int expected) {
    return '$submitted of $expected submitted';
  }

  @override
  String updatesMissing(int count) {
    return 'Missing $count';
  }

  @override
  String updatesPending(int count) {
    return 'Pending $count';
  }

  @override
  String updatesUpcoming(int count) {
    return 'Upcoming $count';
  }

  @override
  String updatesNotCheckedIn(int count) {
    return 'Not checked in $count';
  }

  @override
  String get issuesOpen => 'Open issues';

  @override
  String issuesCritical(int count) {
    return '$count critical';
  }

  @override
  String get attentionTitle => 'Attention required';

  @override
  String get attentionNothing => 'Nothing needs attention right now.';

  @override
  String attentionMissing(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count missing updates',
      one: '1 missing update',
    );
    return '$_temp0: $names';
  }

  @override
  String attentionNotCheckedIn(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count people', one: '1 person');
    return '$_temp0 not checked in: $names';
  }

  @override
  String attentionOverdue(String title, String amount, String date) {
    return 'Overdue: $title, $amount since $date';
  }

  @override
  String attentionCritical(String title) {
    return 'Critical issue: $title';
  }

  @override
  String get siteActivityTitle => 'Today\'s site activity';

  @override
  String siteActivityLast(String time) {
    return 'Last activity $time';
  }

  @override
  String get siteActivityNone => 'No activity yet';

  @override
  String staffCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count staff',
      one: '1 staff',
      zero: 'No staff',
    );
    return '$_temp0';
  }

  @override
  String get siteNoEngineer => 'No engineer assigned';

  @override
  String get sitesTitle => 'Sites';

  @override
  String get clientsTitle => 'Clients';

  @override
  String get sitesSearch => 'Search sites';

  @override
  String get clientsSearch => 'Search clients';

  @override
  String get sitesEmpty => 'No sites found.';

  @override
  String get clientsEmpty => 'No clients found.';

  @override
  String get siteNew => 'New site';

  @override
  String get siteEdit => 'Edit site';

  @override
  String get clientNew => 'New client';

  @override
  String get clientEdit => 'Edit client';

  @override
  String get siteTabOverview => 'Overview';

  @override
  String get siteTabTeam => 'Team';

  @override
  String get siteTabPayments => 'Payments';

  @override
  String get siteTabUpdates => 'Updates';

  @override
  String get siteTabIssues => 'Issues';

  @override
  String get siteTabStock => 'Stock';

  @override
  String siteProgress(int percent) {
    return 'Progress $percent%';
  }

  @override
  String get siteClient => 'Client';

  @override
  String get siteContact => 'Site contact';

  @override
  String get siteAddress => 'Address';

  @override
  String get siteStart => 'Start date';

  @override
  String get siteExpectedCompletion => 'Expected completion';

  @override
  String get siteLocation => 'Location';

  @override
  String siteGeofence(int meters) {
    return 'Updates count as on site within $meters m';
  }

  @override
  String get siteEngineers => 'Engineers';

  @override
  String get siteStaff => 'Staff';

  @override
  String get siteManageEngineers => 'Change engineers';

  @override
  String get siteAssignStaff => 'Add staff';

  @override
  String get siteNoStaff => 'No staff assigned yet.';

  @override
  String get siteNoEngineers => 'No engineers assigned yet.';

  @override
  String siteOpenIssues(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count open issues',
      one: '1 open issue',
      zero: 'No open issues',
    );
    return '$_temp0';
  }

  @override
  String get fieldSiteName => 'Site name';

  @override
  String get fieldSiteCode => 'Site ID';

  @override
  String get fieldCodeHelper => 'Leave empty to use the next number';

  @override
  String get fieldClient => 'Client';

  @override
  String get fieldContactName => 'Contact name';

  @override
  String get fieldContactPhone => 'Contact phone';

  @override
  String get fieldAddress => 'Address';

  @override
  String get fieldStartDate => 'Start date';

  @override
  String get fieldExpectedCompletion => 'Expected completion';

  @override
  String get fieldContractAmount => 'Contract amount';

  @override
  String get fieldStatus => 'Status';

  @override
  String get fieldProgress => 'Progress (%)';

  @override
  String get fieldLatitude => 'Latitude';

  @override
  String get fieldLongitude => 'Longitude';

  @override
  String get fieldGeofence => 'Site radius (metres)';

  @override
  String get useCurrentLocation => 'Use my current location';

  @override
  String get fieldEngineers => 'Engineers';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldCompany => 'Company';

  @override
  String get fieldPhone => 'Mobile number';

  @override
  String get fieldEmail => 'E-mail';

  @override
  String get fieldNotes => 'Notes';

  @override
  String get fieldEmployeeCode => 'Employee ID';

  @override
  String get fieldJoiningDate => 'Joining date';

  @override
  String get fieldDesignation => 'Designation';

  @override
  String get fieldSite => 'Site';

  @override
  String get fieldEngineer => 'Engineer';

  @override
  String get siteSaved => 'Site saved.';

  @override
  String get clientSaved => 'Client saved.';

  @override
  String get personSaved => 'Saved.';

  @override
  String get locationServiceOff => 'Turn on location (GPS) and try again.';

  @override
  String get locationPermissionDenied => 'Allow location access to use this.';

  @override
  String get locationPermissionForever => 'Location access is blocked. Allow it in Settings.';

  @override
  String get locationNoFix => 'Couldn\'t get your location. Move to an open area and try again.';

  @override
  String get clientSites => 'Sites';

  @override
  String get clientNoSites => 'No sites for this client yet.';

  @override
  String get peopleTitle => 'People';

  @override
  String get engineersTitle => 'Engineers';

  @override
  String get staffTitle => 'Staff';

  @override
  String get peopleSearch => 'Search by name, phone or ID';

  @override
  String get engineersEmpty => 'No engineers found.';

  @override
  String get staffEmpty => 'No staff found.';

  @override
  String get engineerNew => 'New engineer';

  @override
  String get staffNew => 'New staff member';

  @override
  String get filterActive => 'Active';

  @override
  String get filterInactive => 'Inactive';

  @override
  String get filterUnassigned => 'Unassigned';

  @override
  String get personLastSignIn => 'Last sign-in';

  @override
  String get personNeverSignedIn => 'Never signed in';

  @override
  String get personPasswordPending => 'Must set their own password at next sign-in';

  @override
  String get personSites => 'Sites';

  @override
  String get personSupervises => 'Supervises';

  @override
  String get personAssignment => 'Site and engineer';

  @override
  String get personNotAssigned => 'Not assigned to a site';

  @override
  String get personAssign => 'Assign to site';

  @override
  String get personChangeAssignment => 'Change site';

  @override
  String get personUnassign => 'Remove from site';

  @override
  String personUnassignConfirm(String name, String site) {
    return 'Remove $name from $site?';
  }

  @override
  String get personResetPassword => 'Reset password';

  @override
  String get personResetConfirmTitle => 'Reset password?';

  @override
  String personResetConfirmBody(String name) {
    return '$name will be signed out and must sign in with a temporary password, then choose a new one.';
  }

  @override
  String get personDeactivate => 'Deactivate';

  @override
  String get personActivate => 'Activate';

  @override
  String personDeactivateConfirmTitle(String name) {
    return 'Deactivate $name?';
  }

  @override
  String get personDeactivateConfirmBody =>
      'They will be signed out and removed from their sites. Their history is kept.';

  @override
  String get tempPasswordTitle => 'Temporary password';

  @override
  String tempPasswordBody(String name) {
    return 'Give this password to $name. They will choose their own password when they sign in.';
  }

  @override
  String assignTitle(String name) {
    return 'Assign $name';
  }

  @override
  String get assignNoEngineers => 'This site has no engineers yet. Add one to the site first.';

  @override
  String get assignSave => 'Assign';

  @override
  String siteCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sites',
      one: '1 site',
      zero: 'No sites',
    );
    return '$_temp0';
  }

  @override
  String assignStaffToSite(String site) {
    return 'Add staff to $site';
  }

  @override
  String get fieldStaffMember => 'Staff member';

  @override
  String get assignNoUnassignedStaff => 'Everyone is already assigned to a site. Add a new staff member from People.';

  @override
  String get engineerEdit => 'Edit engineer';

  @override
  String get staffEdit => 'Edit staff member';

  @override
  String get personNoSites => 'Not assigned to any site.';

  @override
  String get personSupervisesNone => 'No staff report to them yet.';

  @override
  String personActivated(String name) {
    return '$name is active again.';
  }

  @override
  String personDeactivated(String name) {
    return '$name has been deactivated.';
  }

  @override
  String get personInactiveBanner => 'This account is deactivated. They can\'t sign in.';

  @override
  String get filterDesignation => 'Designation';

  @override
  String get personInitialSitesHelper => 'Optional. You can change this later from each site\'s Team tab.';

  @override
  String get personInitialAssignment => 'Assign to a site now (optional)';

  @override
  String get siteLocationHelp => 'Used to check that staff are at the site when they send updates.';

  @override
  String get validationCompletionBeforeStart => 'Must be on or after the start date';

  @override
  String get siteNoMilestones => 'No payment milestones yet.';

  @override
  String milestoneDue(String date) {
    return 'Due $date';
  }

  @override
  String milestonePaidOf(String paid, String amount) {
    return '$paid of $amount paid';
  }

  @override
  String get siteEngineersSaved => 'Engineers updated.';

  @override
  String staffAssigned(String name, String site) {
    return '$name assigned to $site.';
  }

  @override
  String staffUnassigned(String name) {
    return '$name removed from the site.';
  }

  @override
  String locationCaptured(int meters) {
    return 'Location set (accurate to about $meters m).';
  }

  @override
  String get locationMocked => 'Your phone is using a mock location app. Turn it off and try again.';

  @override
  String get locationClear => 'Clear location';

  @override
  String get siteNoLocation => 'No location set. Staff updates can\'t be checked against the site.';

  @override
  String get siteContactNone => 'No site contact';

  @override
  String personSupervisedBy(String name) {
    return 'Reports to $name';
  }

  @override
  String get commonActions => 'More actions';

  @override
  String get milestonesTitle => 'Payment schedule';

  @override
  String staffGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get staffYourEngineer => 'Your engineer';

  @override
  String get staffNotAssigned => 'You\'re not assigned to a site yet. Please contact your engineer or admin.';

  @override
  String get attendanceTitle => 'Attendance';

  @override
  String get attendanceToday => 'Today\'s attendance';

  @override
  String get checkIn => 'Check in';

  @override
  String get checkOut => 'Check out';

  @override
  String get checkingLocation => 'Getting your location…';

  @override
  String checkedInAt(String time) {
    return 'Checked in at $time';
  }

  @override
  String checkedOutAt(String time) {
    return 'Checked out at $time';
  }

  @override
  String workedDuration(int hours, int minutes) {
    return 'Worked $hours h $minutes min';
  }

  @override
  String get notCheckedInYet => 'You haven\'t checked in yet.';

  @override
  String get checkInDone => 'Checked in. Have a good day!';

  @override
  String get checkOutDone => 'Checked out. See you tomorrow!';

  @override
  String get checkOutConfirmTitle => 'Check out now?';

  @override
  String get checkOutConfirmBody => 'You can\'t check in again today.';

  @override
  String get checkInNotToday => 'No check-in needed today.';

  @override
  String get locationFlagOutside => 'Away from the site';

  @override
  String get locationFlagMocked => 'Mock location';

  @override
  String get locationFlagNoPermission => 'Location not allowed';

  @override
  String get locationFlagUnavailable => 'No location';

  @override
  String get locationFlagOk => 'At the site';

  @override
  String slotWindow(String start, String end) {
    return '$start – $end';
  }

  @override
  String get slotTakePhoto => 'Take photo';

  @override
  String slotSentAt(String time) {
    return 'Sent at $time';
  }

  @override
  String get slotSentOffline => 'Sent later (offline)';

  @override
  String slotOpensAt(String time) {
    return 'Opens at $time';
  }

  @override
  String slotDueBy(String time) {
    return 'Due by $time';
  }

  @override
  String get slotCheckInFirst => 'Check in first to send this update.';

  @override
  String get slotSavedOnPhone => 'Saved on this phone, waiting to send';

  @override
  String captureTitle(String slot) {
    return '$slot update';
  }

  @override
  String get captureRetake => 'Retake';

  @override
  String get captureFromGallery => 'Choose from gallery';

  @override
  String get captureGalleryNote => 'Photos from the gallery are marked for review. Use the camera when you can.';

  @override
  String get captureDescriptionLabel => 'What work was done?';

  @override
  String get captureDescriptionHint => 'e.g. Plastering on the 2nd floor, east side';

  @override
  String get captureDescriptionTooShort => 'Write a few words about the work.';

  @override
  String get capturePhotoRequired => 'Take a photo of the work first.';

  @override
  String get captureSend => 'Send update';

  @override
  String captureSending(int percent) {
    return 'Sending… $percent%';
  }

  @override
  String captureSent(String slot) {
    return '$slot update sent.';
  }

  @override
  String get captureQueued => 'No connection. Your update is saved and will be sent automatically.';

  @override
  String captureLocationFound(int meters) {
    return 'Location found (accurate to about $meters m)';
  }

  @override
  String get captureLocationMarked => 'The update will be sent without a location and marked.';

  @override
  String get captureCameraFailed => 'Couldn\'t open the camera. Please try again.';

  @override
  String get queueTitle => 'Waiting to send';

  @override
  String get queueWaiting => 'Waiting for a connection';

  @override
  String get queueSending => 'Sending…';

  @override
  String queueFailed(String reason) {
    return 'Not sent: $reason';
  }

  @override
  String queueTaken(String slot, String time) {
    return '$slot · taken $time';
  }

  @override
  String get queueDiscard => 'Discard';

  @override
  String get queueDiscardTitle => 'Discard this update?';

  @override
  String get queueDiscardBody => 'The photo and description will be deleted from this phone.';

  @override
  String get queueSendNow => 'Send now';

  @override
  String get historyTitle => 'Your updates';

  @override
  String get historyEmpty => 'No updates yet.';

  @override
  String get attendanceHistoryTitle => 'Past days';

  @override
  String get attendanceHistoryEmpty => 'No attendance yet.';

  @override
  String get photoAwaitingReview => 'Photo waiting for review';

  @override
  String get photoReviewed => 'Photo reviewed, being removed';

  @override
  String get photoRemovedReviewed => 'Photo reviewed and removed';

  @override
  String get photoRemovedExpired => 'Photo removed after the review period';

  @override
  String get photoFromGallery => 'From gallery';

  @override
  String get notificationsEmpty => 'You\'re all caught up.';

  @override
  String get notificationsMarkAllRead => 'Mark all as read';

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String timeHoursAgo(int hours) {
    return '$hours h ago';
  }

  @override
  String timeYesterday(String time) {
    return 'Yesterday, $time';
  }

  @override
  String get notificationUnread => 'Unread';

  @override
  String get statYourSites => 'Your sites';

  @override
  String get reviewTitle => 'Photos to review';

  @override
  String get reviewEmpty => 'All photos have been reviewed.';

  @override
  String get siteTabToday => 'Today';

  @override
  String get boardNoStaff => 'No staff on this site.';

  @override
  String get boardNotCheckedIn => 'Not checked in';

  @override
  String boardCheckedIn(String time) {
    return 'In $time';
  }

  @override
  String boardCheckedOut(String time) {
    return 'Out $time';
  }

  @override
  String get boardPreviousDay => 'Previous day';

  @override
  String get boardNextDay => 'Next day';

  @override
  String get boardToReview => 'To review';

  @override
  String photoViewerTitle(String name, String slot) {
    return '$name · $slot';
  }

  @override
  String get photoDeleted =>
      'This photo has been deleted. Photos are removed once reviewed, or after a day. The update itself is kept.';

  @override
  String get photoLoadFailed => 'Couldn\'t load the photo.';

  @override
  String updateTakenAt(String time) {
    return 'Taken $time';
  }

  @override
  String updateSentAt(String time) {
    return 'Sent $time';
  }

  @override
  String updateDistance(int meters) {
    return '$meters m from the site';
  }

  @override
  String get reviewEngineerDone => 'Engineer reviewed';

  @override
  String get reviewEngineerPending => 'Engineer hasn\'t reviewed';

  @override
  String get reviewAdminDone => 'Admin reviewed';

  @override
  String get reviewAdminPending => 'Admin hasn\'t reviewed';

  @override
  String get engineerUpdatesTitle => 'Updates to admin';

  @override
  String get engineerUpdateNew => 'New update';

  @override
  String get engineerUpdatesEmpty => 'No updates yet.';

  @override
  String get engineerUpdateSent => 'Update sent to the admin.';

  @override
  String engineerUpdateSeen(String time) {
    return 'Seen by admin $time';
  }

  @override
  String get engineerUpdateNotSeen => 'Not seen by the admin yet';

  @override
  String get engineerUpdateTypeProgress => 'Progress';

  @override
  String get engineerUpdateTypeCompletedWork => 'Completed work';

  @override
  String get engineerUpdateTypeMaterialsRequired => 'Materials required';

  @override
  String get engineerUpdateTypeSafetyConcern => 'Safety concern';

  @override
  String get engineerUpdateTypeClientRequirement => 'Client requirement';

  @override
  String get engineerUpdateTypeRemark => 'Remark';

  @override
  String get engineerUpdateTypeDailyReport => 'Daily report';

  @override
  String get fieldType => 'Type';

  @override
  String get fieldPriority => 'Priority';

  @override
  String get fieldTitle => 'Title';

  @override
  String get fieldTitleOptional => 'Title (optional)';

  @override
  String get fieldDescription => 'Description';

  @override
  String get fieldPhotos => 'Photos';

  @override
  String fieldProgressValue(int percent) {
    return 'Site progress: $percent%';
  }

  @override
  String get photosAdd => 'Add photo';

  @override
  String photosLimit(int max) {
    return 'Up to $max photos';
  }

  @override
  String get photoCamera => 'Camera';

  @override
  String get photoGallery => 'Gallery';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonSend => 'Send';

  @override
  String get issuesTitle => 'Issues';

  @override
  String get issueNew => 'Report issue';

  @override
  String get issuesEmpty => 'No issues here.';

  @override
  String get issueReportedDone => 'Issue reported.';

  @override
  String issueReportedBy(String name, String time) {
    return 'Reported by $name · $time';
  }

  @override
  String issueResolvedBy(String name, String time) {
    return 'Resolved by $name · $time';
  }

  @override
  String get issueStartWork => 'Start work';

  @override
  String get issueResolve => 'Mark resolved';

  @override
  String get issueReopen => 'Reopen';

  @override
  String get issueResolveTitle => 'Resolve issue';

  @override
  String get issueResolutionLabel => 'What was done?';

  @override
  String get issueUpdatedDone => 'Issue updated.';

  @override
  String get issueFilterUnresolved => 'Unresolved';

  @override
  String attachmentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count photos', one: '1 photo');
    return '$_temp0';
  }

  @override
  String get commonView => 'View';

  @override
  String get paymentsAll => 'All payments';

  @override
  String get paymentsRecord => 'Record payment';

  @override
  String get paymentRecorded => 'Payment recorded.';

  @override
  String get paymentVoid => 'Void payment';

  @override
  String get paymentVoidTitle => 'Void this payment?';

  @override
  String get paymentVoidBody => 'It stays in the history, marked void, and stops counting toward the site\'s total.';

  @override
  String get paymentVoidReason => 'Reason';

  @override
  String get paymentVoided => 'Payment voided.';

  @override
  String paymentVoidedBy(String name, String reason) {
    return 'Voided by $name: $reason';
  }

  @override
  String get paymentVoidChip => 'Void';

  @override
  String paymentRecordedBy(String name) {
    return 'Recorded by $name';
  }

  @override
  String get paymentMethodCash => 'Cash';

  @override
  String get paymentMethodUpi => 'UPI';

  @override
  String get paymentMethodBankTransfer => 'Bank transfer';

  @override
  String get paymentMethodCheque => 'Cheque';

  @override
  String get paymentMethodOther => 'Other';

  @override
  String get fieldAmount => 'Amount';

  @override
  String get fieldPaidOn => 'Paid on';

  @override
  String get fieldMethod => 'Method';

  @override
  String get fieldReference => 'Reference (cheque or UTR no.)';

  @override
  String get fieldRemarks => 'Remarks';

  @override
  String get fieldDueDate => 'Due date';

  @override
  String get milestoneAdd => 'Add milestone';

  @override
  String get milestoneEdit => 'Edit milestone';

  @override
  String get milestoneSaved => 'Milestone saved.';

  @override
  String get milestoneDelete => 'Delete milestone';

  @override
  String get milestoneDeleteTitle => 'Delete this milestone?';

  @override
  String get milestoneDeleteBody => 'Payments stay recorded and count toward the remaining milestones.';

  @override
  String get milestoneDeleted => 'Milestone deleted.';

  @override
  String get paymentsEmpty => 'No payments yet.';

  @override
  String paymentsReceivedOf(String received, String contract) {
    return '$received of $contract received';
  }

  @override
  String paymentsNextDue(String title, String amount, String date) {
    return 'Next: $title · $amount due $date';
  }

  @override
  String get paymentsShowVoided => 'Show voided';

  @override
  String get paymentsReceivedTitle => 'Payments received';

  @override
  String get paymentsBySite => 'By site';

  @override
  String get paymentsNoSites => 'No sites yet.';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsEntrySubtitle => 'Attendance, photo updates and more, for any dates';

  @override
  String get reportsExport => 'Export CSV';

  @override
  String reportsTooLong(int days) {
    return 'Choose at most $days days.';
  }

  @override
  String reportsRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get reportsAllSites => 'All sites';

  @override
  String get reportKindSites => 'Sites';

  @override
  String get reportKindStaff => 'Staff';

  @override
  String get reportKindEngineers => 'Engineers';

  @override
  String get reportKindPayments => 'Payments';

  @override
  String get reportKindStock => 'Stock';

  @override
  String get reportPeriodThisWeek => 'This week';

  @override
  String get reportPeriodThisMonth => 'This month';

  @override
  String get reportPeriodLastMonth => 'Last month';

  @override
  String get reportPeriodCustom => 'Pick dates';

  @override
  String get reportsEmpty => 'Nothing to report for these dates.';

  @override
  String get reportsGroupUpdates => 'Photo updates';

  @override
  String get reportsGroupAttendance => 'Attendance';

  @override
  String get reportsGroupWork => 'Updates and issues';

  @override
  String get reportsGroupReviews => 'Photo reviews';

  @override
  String get reportsUpdatesSent => 'Sent';

  @override
  String get reportsUpdatesMissed => 'Missed';

  @override
  String get reportsSentOffline => 'Sent offline';

  @override
  String get reportsLocationFlagged => 'Location flagged';

  @override
  String get reportsEngineerUpdates => 'Updates to admin';

  @override
  String get reportsIssuesOpened => 'Issues opened';

  @override
  String get reportsIssuesResolved => 'Issues resolved';

  @override
  String get reportsIssuesOpenNow => 'Open now';

  @override
  String get reportsIssuesReported => 'Issues reported';

  @override
  String get reportsPhotos => 'Photos';

  @override
  String get reportsReviewed => 'Reviewed';

  @override
  String get reportsReviewRate => 'Review rate';

  @override
  String get reportsReviewMinutes => 'Minutes to review';

  @override
  String reportsCompliance(int percent) {
    return '$percent% sent';
  }

  @override
  String get reportsNothingDue => 'Nothing due';

  @override
  String get reportsReceivedInRange => 'Received in these dates';

  @override
  String reportsPaymentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count payments', one: '1 payment');
    return '$_temp0';
  }

  @override
  String get reportsInRange => 'In these dates';

  @override
  String get reportsReceivedToDate => 'Received to date';

  @override
  String get reportsPaymentsInRange => 'Payments in these dates';

  @override
  String get reportsNoPayments => 'No payments in these dates.';

  @override
  String get locationApproximate =>
      'Only approximate location is allowed, so this may be marked away from the site. Turn on \"Use precise location\" for this app.';

  @override
  String get notFoundTitle => 'This page isn\'t available';

  @override
  String get notFoundMessage => 'The link may be old or mistyped.';

  @override
  String get notFoundGoHome => 'Go to home';

  @override
  String get fieldDate => 'Date';

  @override
  String get fieldNoteOptional => 'Note (optional)';

  @override
  String get stockTitle => 'Stock';

  @override
  String get stockEntrySubtitle => 'Godowns, materials and deliveries';

  @override
  String get stockEngineerSubtitle => 'What the godowns hold';

  @override
  String get stockDeliveriesToConfirm => 'Deliveries to confirm';

  @override
  String stockLowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count low on stock',
      one: '1 low on stock',
    );
    return '$_temp0';
  }

  @override
  String stockToConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count to confirm', one: '1 to confirm');
    return '$_temp0';
  }

  @override
  String get stockGodowns => 'Godowns';

  @override
  String get stockGodownLabel => 'Godown';

  @override
  String get stockSiteLabel => 'Site';

  @override
  String get stockNoGodowns => 'No godowns yet.';

  @override
  String get stockNoGodownsAdmin => 'No godowns yet. Add one from the menu above.';

  @override
  String stockArrivingCount(int count) {
    return '$count on the way';
  }

  @override
  String get stockPlaceSupplier => 'Supplier';

  @override
  String get stockPlaceUsed => 'Used';

  @override
  String get stockPlaceWaste => 'Written off';

  @override
  String get stockPlaceCount => 'Count correction';

  @override
  String get stockKindPurchase => 'Bought';

  @override
  String get stockKindTransfer => 'Sent';

  @override
  String get stockKindUsage => 'Used';

  @override
  String get stockKindWriteOff => 'Written off';

  @override
  String get stockKindAdjustment => 'Count correction';

  @override
  String get stockStatusOnTheWay => 'On the way';

  @override
  String get stockStatusCancelled => 'Cancelled';

  @override
  String get stockStatusShort => 'Short';

  @override
  String stockShortChip(String quantity) {
    return '$quantity short';
  }

  @override
  String get stockLow => 'Low';

  @override
  String stockAndMore(String first, int count) {
    return '$first and $count more';
  }

  @override
  String get stockCountNoDifference => 'Counted: no difference';

  @override
  String get stockEntryTitle => 'Stock entry';

  @override
  String get stockConfirm => 'Confirm';

  @override
  String get stockConfirmReceived => 'Confirm received';

  @override
  String stockReceiveIntro(String from, String date) {
    return 'Sent from $from on $date. Enter what actually arrived.';
  }

  @override
  String get stockWhatArrived => 'What arrived';

  @override
  String stockSentQuantity(String quantity) {
    return 'Sent: $quantity';
  }

  @override
  String stockReceiveTooMuch(String quantity) {
    return 'Only $quantity was sent.';
  }

  @override
  String get stockShortNote => 'What happened to the rest?';

  @override
  String get stockReceivePhotos => 'Photos of what arrived';

  @override
  String get stockPhotoRequired => 'Add at least one photo of what arrived.';

  @override
  String get stockReceived => 'Stock received.';

  @override
  String get stockReceivedTitle => 'Received';

  @override
  String stockReceivedOf(String received, String sent) {
    return '$received of $sent arrived';
  }

  @override
  String stockReceivedBy(String name) {
    return 'Confirmed by $name';
  }

  @override
  String stockRecordedBy(String name) {
    return 'Recorded by $name';
  }

  @override
  String stockDcNumberIs(String number) {
    return 'DC $number';
  }

  @override
  String stockBillNoIs(String number) {
    return 'Bill $number';
  }

  @override
  String stockAtRate(String price, String unit) {
    return '$price per $unit';
  }

  @override
  String get stockTotalAmount => 'Total';

  @override
  String get stockDcPhotos => 'Delivery challan photo';

  @override
  String get stockBillPhotos => 'Bill photos';

  @override
  String get stockBillPhotosOptional => 'Bill photos (optional)';

  @override
  String get stockPhotosOptional => 'Photos (optional)';

  @override
  String get stockDcPhotoRequired => 'Add a photo of the delivery challan.';

  @override
  String get stockCancel => 'Cancel entry';

  @override
  String get stockCancelTitle => 'Cancel this entry?';

  @override
  String get stockCancelBody =>
      'The stock goes back to where it came from. The entry stays in the history, marked cancelled.';

  @override
  String get stockCancelReason => 'Why?';

  @override
  String get stockCancelled => 'Entry cancelled.';

  @override
  String stockCancelledBy(String name, String reason) {
    return 'Cancelled by $name: $reason';
  }

  @override
  String get stockActionPurchase => 'Stock in';

  @override
  String get stockActionSend => 'Send stock';

  @override
  String get stockActionSendOn => 'Return to godown';

  @override
  String get stockActionUse => 'Record usage';

  @override
  String get stockActionWriteOff => 'Write off';

  @override
  String get stockActionCount => 'Stock count';

  @override
  String get stockIntoGodown => 'Into godown';

  @override
  String get stockSendFrom => 'Send from';

  @override
  String get stockSendTo => 'Send to';

  @override
  String get stockAt => 'At';

  @override
  String get stockChooseSource => 'Choose where the stock comes from first.';

  @override
  String get stockCountedOn => 'Counted on';

  @override
  String get stockSupplier => 'Supplier (optional)';

  @override
  String get stockBillNo => 'Bill or invoice number (optional)';

  @override
  String get stockDcNumber => 'DC number';

  @override
  String get stockMaterials => 'Materials';

  @override
  String get stockMaterial => 'Material';

  @override
  String get stockQuantity => 'Quantity';

  @override
  String get stockCountedQuantity => 'Counted quantity';

  @override
  String get stockRate => 'Price per unit (₹)';

  @override
  String stockRatePer(String unit) {
    return 'Price per $unit (₹)';
  }

  @override
  String stockAvailable(String quantity) {
    return 'Available: $quantity';
  }

  @override
  String stockOnBooks(String quantity) {
    return 'On the books: $quantity';
  }

  @override
  String stockOnlyAvailable(String quantity) {
    return 'Only $quantity available.';
  }

  @override
  String get stockAddMaterial => 'Add material';

  @override
  String get stockRemoveLine => 'Remove';

  @override
  String get stockNothingToChoose => 'There is no stock here to choose from.';

  @override
  String get stockUsedFor => 'Used for, e.g. first floor slab (optional)';

  @override
  String get stockWhatHappened => 'What happened to it';

  @override
  String get stockCountNote => 'Why the count differs';

  @override
  String get stockSaved => 'Stock saved.';

  @override
  String get stockCountMatched => 'The count matches the books. Nothing to correct.';

  @override
  String get stockSendHere => 'Send stock here';

  @override
  String get stockSendEverything => 'Return everything to a godown';

  @override
  String get stockArrivingHere => 'On the way here';

  @override
  String get stockLeavingHere => 'Sent, not yet confirmed';

  @override
  String get stockOnSite => 'On site';

  @override
  String get stockInGodown => 'In this godown';

  @override
  String get stockUsedUp => 'Used up or sent on';

  @override
  String get stockNothingHere => 'Nothing here now.';

  @override
  String get stockSiteEmpty => 'No stock at this site yet';

  @override
  String get stockSiteEmptyBody => 'Stock sent from a godown shows here once the site confirms it.';

  @override
  String get godownEmpty => 'Nothing in this godown yet';

  @override
  String stockReceivedTotal(String quantity) {
    return 'Received $quantity';
  }

  @override
  String stockUsedTotal(String quantity) {
    return 'used $quantity';
  }

  @override
  String stockSentOutTotal(String quantity) {
    return 'sent on $quantity';
  }

  @override
  String stockWastedTotal(String quantity) {
    return 'wasted $quantity';
  }

  @override
  String stockWorth(String amount) {
    return 'worth $amount';
  }

  @override
  String get stockValueUsed => 'Material used';

  @override
  String get stockValueOnSite => 'On site now';

  @override
  String get stockValueOnHand => 'Stock value';

  @override
  String get stockHistory => 'History';

  @override
  String get stockToConfirm => 'To confirm';

  @override
  String get stockNothingToConfirm => 'Nothing waiting for you to confirm.';

  @override
  String get stockNoEntries => 'No stock entries yet.';

  @override
  String get stockSearch => 'Search materials';

  @override
  String get stockNoMaterials => 'No materials yet';

  @override
  String get stockNoMaterialsBody => 'Add the materials you keep in stock. You can add more at any time.';

  @override
  String get stockNoMatch => 'No materials match.';

  @override
  String stockOnSitesTotal(String quantity) {
    return '$quantity at sites';
  }

  @override
  String get stockInGodowns => 'In the godowns';

  @override
  String stockMinimum(String quantity) {
    return 'Minimum $quantity';
  }

  @override
  String stockInTransitTotal(String quantity) {
    return '$quantity on the way';
  }

  @override
  String stockAveragePrice(String price, String unit) {
    return 'Average $price per $unit';
  }

  @override
  String get stockNoneInGodowns => 'None in the godowns now.';

  @override
  String get stockAtSites => 'At sites';

  @override
  String get stockNotAtSites => 'None at sites now.';

  @override
  String get stockLatest => 'Latest';

  @override
  String get stockStaffUsageTitle => 'Today\'s material use';

  @override
  String get stockUsageRecorded => 'Recorded';

  @override
  String get stockUsageNotRecorded => 'Not recorded yet';

  @override
  String get stockRecord => 'Record';

  @override
  String get stockLeftTitle => 'Stock is still at this site';

  @override
  String stockLeftMore(int count) {
    return 'and $count more';
  }

  @override
  String get stockLeftOnTheWay => 'Some stock is also on the way to or from this site.';

  @override
  String get stockLeftBody =>
      'Send it back to a godown from the site\'s Stock tab first, or complete the site now and deal with it later.';

  @override
  String get stockLeftComplete => 'Complete anyway';

  @override
  String get godownNew => 'New godown';

  @override
  String get godownEdit => 'Edit godown';

  @override
  String get godownSaved => 'Godown saved.';

  @override
  String get godownName => 'Name';

  @override
  String get godownNameHint => 'e.g. Main godown';

  @override
  String get godownAddress => 'Address (optional)';

  @override
  String get godownActive => 'Open';

  @override
  String get godownActiveHelper =>
      'A closed godown takes no new stock. Its history stays. Move its stock out before closing it.';

  @override
  String get godownClosed => 'Closed';

  @override
  String get materialNew => 'New material';

  @override
  String get materialEdit => 'Edit material';

  @override
  String get materialSaved => 'Material saved.';

  @override
  String get materialName => 'Name';

  @override
  String get materialNameHint => 'e.g. Cement OPC 53';

  @override
  String get materialUnit => 'Unit';

  @override
  String get materialUnitHelper => 'How it is counted. It can\'t change once stock is recorded.';

  @override
  String get materialCategory => 'Category (optional)';

  @override
  String get materialCategoryHint => 'e.g. Cement, Steel';

  @override
  String get materialMinimum => 'Minimum in godowns (optional)';

  @override
  String get materialMinimumHelper => 'Admins are alerted when all godowns together drop below this.';

  @override
  String get materialActive => 'In use';

  @override
  String get materialActiveHelper => 'Switched off, it can\'t be bought or sent from godowns. Its history stays.';

  @override
  String get materialInactive => 'Not in use';

  @override
  String get reportsStockOpening => 'Opening';

  @override
  String get reportsStockReceived => 'Received';

  @override
  String get reportsStockUsed => 'Used';

  @override
  String get reportsStockClosing => 'Closing';

  @override
  String get reportsStockSentOut => 'Sent out';

  @override
  String get reportsStockWasted => 'Wasted';

  @override
  String get reportsStockAdjusted => 'Count corrections';

  @override
  String get reportsStockUsedValue => 'Used value';

  @override
  String get roleGodownManager => 'Godown manager';

  @override
  String get navRequests => 'Requests';

  @override
  String get navStock => 'Stock';

  @override
  String get signUpLink => 'Set up SiteWork (first admin)';

  @override
  String get signUpTitle => 'Set up SiteWork';

  @override
  String get signUpIntro =>
      'Create the first admin account. After this, admins add everyone else (engineers, staff, godown managers and other admins) from People.';

  @override
  String get signUpSubmit => 'Create admin account';

  @override
  String get godownManagersTitle => 'Godown managers';

  @override
  String get godownManagersEmpty => 'No godown managers yet.';

  @override
  String get godownManagerNew => 'New godown manager';

  @override
  String get godownManagerEdit => 'Edit godown manager';

  @override
  String get adminsTitle => 'Admins';

  @override
  String get adminsEmpty => 'No admins found.';

  @override
  String get adminNew => 'New admin';

  @override
  String get adminEdit => 'Edit admin';

  @override
  String get personGodowns => 'Godowns';

  @override
  String get personGodownsHelper =>
      'They buy stock in, send it to sites against approved requests, and confirm returns at these godowns.';

  @override
  String get personNoGodowns => 'No godown yet';

  @override
  String godownManagedBy(String names) {
    return 'Managed by $names';
  }

  @override
  String get godownNoManager => 'No manager yet: admins confirm what arrives here.';

  @override
  String get godownsYours => 'Your godowns';

  @override
  String get stockReturnTo => 'Return to';

  @override
  String get stockSendSitesHint =>
      'Sites get stock only against an approved material request: open the request to send it.';

  @override
  String get stockNoGodownsManager => 'No godown is assigned to you yet. Ask your admin.';

  @override
  String get stockReturnsToConfirm => 'Returns to confirm';

  @override
  String get stockLowTitle => 'Low stock';

  @override
  String get stockLowSubtitle => 'All godowns together, below the minimum';

  @override
  String stockForRequest(String code) {
    return 'For $code';
  }

  @override
  String get requestsTitle => 'Material requests';

  @override
  String get requestTitle => 'Material request';

  @override
  String get requestsAdminSubtitle => 'Approve what sites ask for';

  @override
  String get requestsEngineerSubtitle => 'Ask for material for your sites';

  @override
  String requestsToApproveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count waiting for approval',
      one: '1 waiting for approval',
    );
    return '$_temp0';
  }

  @override
  String get requestsToSend => 'Requests to send';

  @override
  String get requestsEmpty => 'No material requests here.';

  @override
  String get requestsEmptyManager => 'Nothing to send. Approved requests for your godowns show up here.';

  @override
  String get requestsOpenTitle => 'Material requests';

  @override
  String get requestsAll => 'All requests';

  @override
  String get requestsNoneOpen => 'No open requests.';

  @override
  String get requestFilterOpen => 'Open';

  @override
  String get requestFilterApproved => 'Approved';

  @override
  String get requestStagePending => 'Waiting for approval';

  @override
  String get requestStageToSend => 'Approved · to send';

  @override
  String get requestStagePartSent => 'Part sent';

  @override
  String get requestStageOnTheWay => 'On the way';

  @override
  String get requestStageAtSite => 'At site';

  @override
  String get requestStageRejected => 'Rejected';

  @override
  String get requestStageWithdrawn => 'Withdrawn';

  @override
  String get requestStageClosed => 'Closed';

  @override
  String requestAskedBy(String name, String date) {
    return 'Asked by $name · $date';
  }

  @override
  String requestFromGodown(String godown) {
    return 'From $godown';
  }

  @override
  String requestNeededBy(String date) {
    return 'Needed by $date';
  }

  @override
  String get requestSiteStock => 'Site\'s stock';

  @override
  String get requestMaterial => 'Request material';

  @override
  String get requestNew => 'New request';

  @override
  String get requestNeededByOptional => 'Needed by (optional)';

  @override
  String get requestQuantityNeeded => 'Quantity needed';

  @override
  String get requestWhatFor => 'What is it for? (optional)';

  @override
  String get requestSubmit => 'Send request';

  @override
  String requestSent(String code) {
    return '$code sent for approval.';
  }

  @override
  String get requestApprove => 'Approve';

  @override
  String requestApproveTitle(String code) {
    return 'Approve $code';
  }

  @override
  String requestApproveIntro(String site, String name) {
    return '$site asked for this ($name). Choose the godown that sends it and how much of each material.';
  }

  @override
  String get requestSupplyFrom => 'Send from godown';

  @override
  String get requestApprovedQuantities => 'Approved quantities';

  @override
  String get requestApproveZeroHint => 'Enter 0 for a material that won\'t be sent.';

  @override
  String get requestApprovedQuantity => 'Approved quantity';

  @override
  String requestInGodown(String quantity) {
    return 'In godown: $quantity';
  }

  @override
  String get requestNoteForSite => 'Note for the site (optional)';

  @override
  String get requestApproveSomething => 'Approve at least one material, or reject the request.';

  @override
  String requestApproved(String code) {
    return '$code approved. The godown will send it.';
  }

  @override
  String get requestReject => 'Reject';

  @override
  String get requestRejectTitle => 'Reject this request?';

  @override
  String get requestRejectReason => 'Why? The site will see this.';

  @override
  String requestRejected(String code) {
    return '$code rejected.';
  }

  @override
  String requestRejectedBecause(String name, String reason) {
    return 'Rejected by $name: $reason';
  }

  @override
  String requestApprovedFrom(String name, String godown) {
    return 'Approved by $name · sent from $godown';
  }

  @override
  String get requestWithdraw => 'Withdraw request';

  @override
  String requestWithdrawTitle(String code) {
    return 'Withdraw $code?';
  }

  @override
  String get requestWithdrawBody => 'It has not been approved yet. Withdrawing it means nothing will be sent.';

  @override
  String requestWithdrawn(String code) {
    return '$code withdrawn.';
  }

  @override
  String get requestSendNow => 'Send material';

  @override
  String requestSendTitle(String code) {
    return 'Send $code';
  }

  @override
  String get requestDeliveries => 'Deliveries and returns';

  @override
  String requestAsked(String quantity) {
    return 'Asked $quantity';
  }

  @override
  String get requestNotSupplied => 'Not supplied';

  @override
  String requestSentAmount(String quantity) {
    return 'Sent $quantity';
  }

  @override
  String requestOnTheWayAmount(String quantity) {
    return '$quantity on the way';
  }

  @override
  String requestArrivedAmount(String quantity) {
    return 'Arrived $quantity';
  }

  @override
  String requestLeftAmount(String quantity) {
    return '$quantity left to send';
  }

  @override
  String get requestConfirmFirst => 'Confirm the delivery on its way before closing this request.';

  @override
  String get requestClose => 'Close request';

  @override
  String requestCloseTitle(String code) {
    return 'Close $code';
  }

  @override
  String get requestCloseIntro =>
      'Is the work done? Say whether everything was used, or send what is left back to the godown.';

  @override
  String get requestOutcomeAllUsed => 'All used';

  @override
  String requestOutcomeReturn(String godown) {
    return 'Return the leftover to $godown';
  }

  @override
  String get requestGoingBack => 'Going back';

  @override
  String get requestNothingToReturn => 'Nothing from this request is left at the site.';

  @override
  String get requestReturnZeroHint => 'Enter 0 for anything staying at the site.';

  @override
  String get requestReturnSomething => 'Enter what is going back, or choose \"All used\".';

  @override
  String requestClosed(String code) {
    return '$code closed.';
  }

  @override
  String requestClosedAllUsed(String name) {
    return 'Closed by $name: all used.';
  }

  @override
  String requestClosedLeftover(String name) {
    return 'Closed by $name: leftover sent back to the godown.';
  }

  @override
  String get attendanceOnLeave => 'On leave';

  @override
  String get requestsMyTitle => 'My requests';

  @override
  String get requestsSeeAll => 'See all';

  @override
  String get requestsTabLeave => 'Leave';

  @override
  String get requestsTabMoneyFood => 'Money & food';

  @override
  String get requestsTabMaterial => 'Material';

  @override
  String get requestsNew => 'New request';

  @override
  String get requestsChooseKind => 'What do you need?';

  @override
  String get requestKindLeave => 'Leave';

  @override
  String get requestKindLeaveHint => 'Days off work';

  @override
  String get requestKindMoney => 'Money';

  @override
  String get requestKindMoneyHint => 'An advance on your wages';

  @override
  String get requestKindFood => 'Food';

  @override
  String get requestKindFoodHint => 'A meal for yourself';

  @override
  String get requestKindMaterial => 'Material';

  @override
  String get requestKindMaterialHint => 'Material for your site';

  @override
  String get requestSendForApproval => 'Send for approval';

  @override
  String requestSentForApproval(String code) {
    return '$code sent for approval.';
  }

  @override
  String get requestAskedByLabel => 'Asked by';

  @override
  String get requestAskedOn => 'Asked on';

  @override
  String get approvalPending => 'Waiting';

  @override
  String get approvalApproved => 'Approved';

  @override
  String get approvalRejected => 'Rejected';

  @override
  String get approvalCancelled => 'Withdrawn';

  @override
  String approvalApprovedBy(String name) {
    return 'Approved by $name';
  }

  @override
  String approvalApprovedDone(String code) {
    return '$code approved.';
  }

  @override
  String get approvalWithdrawnNote => 'Withdrawn by the person who asked.';

  @override
  String approvalApproveTitle(String code) {
    return 'Approve $code?';
  }

  @override
  String approvalRejectTitle(String code) {
    return 'Reject $code?';
  }

  @override
  String get approvalRejectReason => 'Why? The person who asked will see this.';

  @override
  String get approvalWithdrawBody => 'No one will be able to approve it after this.';

  @override
  String get approvalsTitle => 'Leave & requests';

  @override
  String get approvalsSubtitle => 'Leave, money and food to approve';

  @override
  String approvalsWaitingCount(int count) {
    return '$count waiting for you';
  }

  @override
  String get approvalsWaitingForYou => 'Waiting for you';

  @override
  String get approvalsEmpty => 'Nothing here.';

  @override
  String get myLeaveTitle => 'My leave';

  @override
  String get leaveTitle => 'Leave';

  @override
  String get leaveNewTitle => 'Ask for leave';

  @override
  String get leaveType => 'Kind of leave';

  @override
  String get leaveTypeSick => 'Sick';

  @override
  String get leaveTypeCasual => 'Casual';

  @override
  String get leaveTypeOther => 'Other';

  @override
  String get leaveFrom => 'First day';

  @override
  String get leaveTo => 'Last day';

  @override
  String get leaveToBeforeFrom => 'The last day can\'t be before the first day.';

  @override
  String get leaveReason => 'Reason';

  @override
  String get leaveWhen => 'When';

  @override
  String leaveDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get leaveEmpty => 'No leave asked for yet.';

  @override
  String get staffRequestTitle => 'Request';

  @override
  String get staffRequestsEmpty => 'No money or food asked for yet.';

  @override
  String get moneyNewTitle => 'Ask for money';

  @override
  String get moneyAmount => 'Amount';

  @override
  String get moneyAmountHelper => 'An advance on your wages';

  @override
  String moneyAdvance(String amount) {
    return '$amount advance';
  }

  @override
  String get foodNewTitle => 'Ask for food';

  @override
  String get foodDay => 'Day';

  @override
  String get foodMeal => 'Meal';

  @override
  String foodMealOn(String meal, String date) {
    return '$meal on $date';
  }

  @override
  String get mealBreakfast => 'Breakfast';

  @override
  String get mealLunch => 'Lunch';

  @override
  String get mealDinner => 'Dinner';
}
