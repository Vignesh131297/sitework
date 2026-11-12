import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SiteWork'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Site work, tracked on time.'**
  String get appTagline;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @loginIdentifierLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number or e-mail'**
  String get loginIdentifierLabel;

  /// No description provided for @loginIdentifierRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number or e-mail.'**
  String get loginIdentifierRequired;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get loginPasswordRequired;

  /// No description provided for @loginShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get loginShowPassword;

  /// No description provided for @loginHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get loginHidePassword;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSubmit;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginSessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please sign in again.'**
  String get loginSessionEnded;

  /// No description provided for @loginDevQuickSignIn.
  ///
  /// In en, this message translates to:
  /// **'Quick sign-in (development build)'**
  String get loginDevQuickSignIn;

  /// No description provided for @forgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotTitle;

  /// No description provided for @forgotBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the mobile number or e-mail you sign in with. If your account has an e-mail address, we\'ll send it a 6-digit code.'**
  String get forgotBody;

  /// No description provided for @forgotSend.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get forgotSend;

  /// No description provided for @forgotSendAgain.
  ///
  /// In en, this message translates to:
  /// **'Send a new code'**
  String get forgotSendAgain;

  /// No description provided for @forgotHaveCode.
  ///
  /// In en, this message translates to:
  /// **'I have a code'**
  String get forgotHaveCode;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetTitle;

  /// No description provided for @resetCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get resetCodeLabel;

  /// No description provided for @resetCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from the e-mail.'**
  String get resetCodeInvalid;

  /// No description provided for @resetSubmit.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get resetSubmit;

  /// No description provided for @resetDone.
  ///
  /// In en, this message translates to:
  /// **'Password changed. Sign in with your new password.'**
  String get resetDone;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordForcedBody.
  ///
  /// In en, this message translates to:
  /// **'Your admin gave you a temporary password. Choose your own password to continue.'**
  String get changePasswordForcedBody;

  /// No description provided for @temporaryPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Temporary password'**
  String get temporaryPasswordLabel;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPasswordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmPasswordLabel;

  /// No description provided for @passwordHelper.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters, with letters and numbers.'**
  String get passwordHelper;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters.'**
  String get passwordTooShort;

  /// No description provided for @passwordNeedsLettersAndNumbers.
  ///
  /// In en, this message translates to:
  /// **'Use both letters and numbers.'**
  String get passwordNeedsLettersAndNumbers;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords don\'t match.'**
  String get passwordsDontMatch;

  /// No description provided for @changePasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get changePasswordSubmit;

  /// No description provided for @changePasswordDone.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed.'**
  String get changePasswordDone;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleEngineer.
  ///
  /// In en, this message translates to:
  /// **'Engineer'**
  String get roleEngineer;

  /// No description provided for @roleStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get roleStaff;

  /// No description provided for @serverChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking server…'**
  String get serverChecking;

  /// No description provided for @serverConnected.
  ///
  /// In en, this message translates to:
  /// **'Server connected'**
  String get serverConnected;

  /// No description provided for @serverUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the server'**
  String get serverUnreachable;

  /// No description provided for @serverDetails.
  ///
  /// In en, this message translates to:
  /// **'{environment} · v{version} · server time {time}'**
  String serverDetails(String environment, String version, String time);

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navSites.
  ///
  /// In en, this message translates to:
  /// **'Sites'**
  String get navSites;

  /// No description provided for @navPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get navPayments;

  /// No description provided for @navPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get navPeople;

  /// No description provided for @navAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get navAlerts;

  /// No description provided for @navUpdates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get navUpdates;

  /// No description provided for @navIssues.
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get navIssues;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get navAttendance;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @screenNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get screenNotifications;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get profilePhone;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get profileEmail;

  /// No description provided for @profileEmployeeId.
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get profileEmployeeId;

  /// No description provided for @profileSite.
  ///
  /// In en, this message translates to:
  /// **'Site'**
  String get profileSite;

  /// No description provided for @profileEngineer.
  ///
  /// In en, this message translates to:
  /// **'Engineer'**
  String get profileEngineer;

  /// No description provided for @profileSites.
  ///
  /// In en, this message translates to:
  /// **'Your sites'**
  String get profileSites;

  /// No description provided for @profileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profileChangePassword;

  /// No description provided for @profileServerSection.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get profileServerSection;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @profileSignOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get profileSignOutConfirmTitle;

  /// No description provided for @profileSignOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to use the app.'**
  String get profileSignOutConfirmBody;

  /// No description provided for @errorOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Check your internet connection and try again.'**
  String get errorOffline;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server is taking too long to respond. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please sign in again.'**
  String get errorSessionExpired;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to do that.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find what you were looking for.'**
  String get errorNotFound;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment and try again.'**
  String get errorRateLimited;

  /// No description provided for @errorServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable. Please try again shortly.'**
  String get errorServiceUnavailable;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our side. Please try again.'**
  String get errorServer;

  /// No description provided for @errorBadRequest.
  ///
  /// In en, this message translates to:
  /// **'Something about that request wasn\'t right. Please try again.'**
  String get errorBadRequest;

  /// No description provided for @errorFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The file is too large.'**
  String get errorFileTooLarge;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something unexpected happened. Please try again.'**
  String get errorUnexpected;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get commonCopy;

  /// No description provided for @commonCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get commonCopied;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get commonMore;

  /// No description provided for @commonNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get commonNone;

  /// No description provided for @commonActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get commonActive;

  /// No description provided for @commonInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get commonInactive;

  /// No description provided for @commonCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get commonCall;

  /// No description provided for @commonOpenMap.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get commonOpenMap;

  /// No description provided for @commonOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get commonOpenSettings;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get validationRequired;

  /// No description provided for @validationQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter a quantity like 60 or 12.5.'**
  String get validationQuantity;

  /// No description provided for @validationAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount like 1500000'**
  String get validationAmount;

  /// No description provided for @validationPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a 10-digit mobile number'**
  String get validationPhone;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid e-mail address'**
  String get validationEmail;

  /// No description provided for @validationNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get validationNumber;

  /// No description provided for @validationRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a value between {min} and {max}'**
  String validationRange(int min, int max);

  /// No description provided for @siteStatusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get siteStatusNotStarted;

  /// No description provided for @siteStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get siteStatusInProgress;

  /// No description provided for @siteStatusOnHold.
  ///
  /// In en, this message translates to:
  /// **'On hold'**
  String get siteStatusOnHold;

  /// No description provided for @siteStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get siteStatusCompleted;

  /// No description provided for @designationMason.
  ///
  /// In en, this message translates to:
  /// **'Mason'**
  String get designationMason;

  /// No description provided for @designationHelper.
  ///
  /// In en, this message translates to:
  /// **'Helper'**
  String get designationHelper;

  /// No description provided for @designationElectrician.
  ///
  /// In en, this message translates to:
  /// **'Electrician'**
  String get designationElectrician;

  /// No description provided for @designationCarpenter.
  ///
  /// In en, this message translates to:
  /// **'Carpenter'**
  String get designationCarpenter;

  /// No description provided for @designationPlumber.
  ///
  /// In en, this message translates to:
  /// **'Plumber'**
  String get designationPlumber;

  /// No description provided for @designationSupervisor.
  ///
  /// In en, this message translates to:
  /// **'Supervisor'**
  String get designationSupervisor;

  /// No description provided for @designationPainter.
  ///
  /// In en, this message translates to:
  /// **'Painter'**
  String get designationPainter;

  /// No description provided for @designationGeneralWorker.
  ///
  /// In en, this message translates to:
  /// **'General worker'**
  String get designationGeneralWorker;

  /// No description provided for @milestonePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get milestonePaid;

  /// No description provided for @milestonePartiallyPaid.
  ///
  /// In en, this message translates to:
  /// **'Partially paid'**
  String get milestonePartiallyPaid;

  /// No description provided for @milestonePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get milestonePending;

  /// No description provided for @milestoneOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get milestoneOverdue;

  /// No description provided for @slotMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get slotMorning;

  /// No description provided for @slotAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get slotAfternoon;

  /// No description provided for @slotEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get slotEvening;

  /// No description provided for @slotStateUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get slotStateUpcoming;

  /// No description provided for @slotStatePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get slotStatePending;

  /// No description provided for @slotStateSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get slotStateSubmitted;

  /// No description provided for @slotStateMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get slotStateMissing;

  /// No description provided for @slotStateNotExpected.
  ///
  /// In en, this message translates to:
  /// **'Not due'**
  String get slotStateNotExpected;

  /// No description provided for @attendancePresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get attendancePresent;

  /// No description provided for @attendanceLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get attendanceLate;

  /// No description provided for @attendanceHalfDay.
  ///
  /// In en, this message translates to:
  /// **'Half day'**
  String get attendanceHalfDay;

  /// No description provided for @attendanceAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get attendanceAbsent;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get priorityCritical;

  /// No description provided for @issueStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get issueStatusOpen;

  /// No description provided for @issueStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get issueStatusInProgress;

  /// No description provided for @issueStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get issueStatusResolved;

  /// No description provided for @dashboardHoliday.
  ///
  /// In en, this message translates to:
  /// **'Today is a holiday ({name}). No updates are expected.'**
  String dashboardHoliday(String name);

  /// No description provided for @dashboardDayOff.
  ///
  /// In en, this message translates to:
  /// **'Today is not a working day. No updates are expected.'**
  String get dashboardDayOff;

  /// No description provided for @statActiveSites.
  ///
  /// In en, this message translates to:
  /// **'Active sites'**
  String get statActiveSites;

  /// No description provided for @statClients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get statClients;

  /// No description provided for @statEngineers.
  ///
  /// In en, this message translates to:
  /// **'Engineers'**
  String get statEngineers;

  /// No description provided for @statStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get statStaff;

  /// No description provided for @paymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get paymentsTitle;

  /// No description provided for @paymentsContract.
  ///
  /// In en, this message translates to:
  /// **'Contract value'**
  String get paymentsContract;

  /// No description provided for @paymentsReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get paymentsReceived;

  /// No description provided for @paymentsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get paymentsPending;

  /// No description provided for @paymentsOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get paymentsOverdue;

  /// No description provided for @paymentsOverdueCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 milestone} other{{count} milestones}}'**
  String paymentsOverdueCount(int count);

  /// No description provided for @todayUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s updates'**
  String get todayUpdatesTitle;

  /// No description provided for @updatesSubmittedOf.
  ///
  /// In en, this message translates to:
  /// **'{submitted} of {expected} submitted'**
  String updatesSubmittedOf(int submitted, int expected);

  /// No description provided for @updatesMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing {count}'**
  String updatesMissing(int count);

  /// No description provided for @updatesPending.
  ///
  /// In en, this message translates to:
  /// **'Pending {count}'**
  String updatesPending(int count);

  /// No description provided for @updatesUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming {count}'**
  String updatesUpcoming(int count);

  /// No description provided for @updatesNotCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Not checked in {count}'**
  String updatesNotCheckedIn(int count);

  /// No description provided for @issuesOpen.
  ///
  /// In en, this message translates to:
  /// **'Open issues'**
  String get issuesOpen;

  /// No description provided for @issuesCritical.
  ///
  /// In en, this message translates to:
  /// **'{count} critical'**
  String issuesCritical(int count);

  /// No description provided for @attentionTitle.
  ///
  /// In en, this message translates to:
  /// **'Attention required'**
  String get attentionTitle;

  /// No description provided for @attentionNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing needs attention right now.'**
  String get attentionNothing;

  /// No description provided for @attentionMissing.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 missing update} other{{count} missing updates}}: {names}'**
  String attentionMissing(int count, String names);

  /// No description provided for @attentionNotCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person} other{{count} people}} not checked in: {names}'**
  String attentionNotCheckedIn(int count, String names);

  /// No description provided for @attentionOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue: {title}, {amount} since {date}'**
  String attentionOverdue(String title, String amount, String date);

  /// No description provided for @attentionCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical issue: {title}'**
  String attentionCritical(String title);

  /// No description provided for @siteActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s site activity'**
  String get siteActivityTitle;

  /// No description provided for @siteActivityLast.
  ///
  /// In en, this message translates to:
  /// **'Last activity {time}'**
  String siteActivityLast(String time);

  /// No description provided for @siteActivityNone.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get siteActivityNone;

  /// No description provided for @staffCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No staff} =1{1 staff} other{{count} staff}}'**
  String staffCount(int count);

  /// No description provided for @siteNoEngineer.
  ///
  /// In en, this message translates to:
  /// **'No engineer assigned'**
  String get siteNoEngineer;

  /// No description provided for @sitesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sites'**
  String get sitesTitle;

  /// No description provided for @clientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clientsTitle;

  /// No description provided for @sitesSearch.
  ///
  /// In en, this message translates to:
  /// **'Search sites'**
  String get sitesSearch;

  /// No description provided for @clientsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search clients'**
  String get clientsSearch;

  /// No description provided for @sitesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sites found.'**
  String get sitesEmpty;

  /// No description provided for @clientsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No clients found.'**
  String get clientsEmpty;

  /// No description provided for @siteNew.
  ///
  /// In en, this message translates to:
  /// **'New site'**
  String get siteNew;

  /// No description provided for @siteEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit site'**
  String get siteEdit;

  /// No description provided for @clientNew.
  ///
  /// In en, this message translates to:
  /// **'New client'**
  String get clientNew;

  /// No description provided for @clientEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit client'**
  String get clientEdit;

  /// No description provided for @siteTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get siteTabOverview;

  /// No description provided for @siteTabTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get siteTabTeam;

  /// No description provided for @siteTabPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get siteTabPayments;

  /// No description provided for @siteTabUpdates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get siteTabUpdates;

  /// No description provided for @siteTabIssues.
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get siteTabIssues;

  /// No description provided for @siteTabStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get siteTabStock;

  /// No description provided for @siteProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress {percent}%'**
  String siteProgress(int percent);

  /// No description provided for @siteClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get siteClient;

  /// No description provided for @siteContact.
  ///
  /// In en, this message translates to:
  /// **'Site contact'**
  String get siteContact;

  /// No description provided for @siteAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get siteAddress;

  /// No description provided for @siteStart.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get siteStart;

  /// No description provided for @siteExpectedCompletion.
  ///
  /// In en, this message translates to:
  /// **'Expected completion'**
  String get siteExpectedCompletion;

  /// No description provided for @siteLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get siteLocation;

  /// No description provided for @siteGeofence.
  ///
  /// In en, this message translates to:
  /// **'Updates count as on site within {meters} m'**
  String siteGeofence(int meters);

  /// No description provided for @siteEngineers.
  ///
  /// In en, this message translates to:
  /// **'Engineers'**
  String get siteEngineers;

  /// No description provided for @siteStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get siteStaff;

  /// No description provided for @siteManageEngineers.
  ///
  /// In en, this message translates to:
  /// **'Change engineers'**
  String get siteManageEngineers;

  /// No description provided for @siteAssignStaff.
  ///
  /// In en, this message translates to:
  /// **'Add staff'**
  String get siteAssignStaff;

  /// No description provided for @siteNoStaff.
  ///
  /// In en, this message translates to:
  /// **'No staff assigned yet.'**
  String get siteNoStaff;

  /// No description provided for @siteNoEngineers.
  ///
  /// In en, this message translates to:
  /// **'No engineers assigned yet.'**
  String get siteNoEngineers;

  /// No description provided for @siteOpenIssues.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No open issues} =1{1 open issue} other{{count} open issues}}'**
  String siteOpenIssues(int count);

  /// No description provided for @fieldSiteName.
  ///
  /// In en, this message translates to:
  /// **'Site name'**
  String get fieldSiteName;

  /// No description provided for @fieldSiteCode.
  ///
  /// In en, this message translates to:
  /// **'Site ID'**
  String get fieldSiteCode;

  /// No description provided for @fieldCodeHelper.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to use the next number'**
  String get fieldCodeHelper;

  /// No description provided for @fieldClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get fieldClient;

  /// No description provided for @fieldContactName.
  ///
  /// In en, this message translates to:
  /// **'Contact name'**
  String get fieldContactName;

  /// No description provided for @fieldContactPhone.
  ///
  /// In en, this message translates to:
  /// **'Contact phone'**
  String get fieldContactPhone;

  /// No description provided for @fieldAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get fieldAddress;

  /// No description provided for @fieldStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get fieldStartDate;

  /// No description provided for @fieldExpectedCompletion.
  ///
  /// In en, this message translates to:
  /// **'Expected completion'**
  String get fieldExpectedCompletion;

  /// No description provided for @fieldContractAmount.
  ///
  /// In en, this message translates to:
  /// **'Contract amount'**
  String get fieldContractAmount;

  /// No description provided for @fieldStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get fieldStatus;

  /// No description provided for @fieldProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress (%)'**
  String get fieldProgress;

  /// No description provided for @fieldLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get fieldLatitude;

  /// No description provided for @fieldLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get fieldLongitude;

  /// No description provided for @fieldGeofence.
  ///
  /// In en, this message translates to:
  /// **'Site radius (metres)'**
  String get fieldGeofence;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get useCurrentLocation;

  /// No description provided for @fieldEngineers.
  ///
  /// In en, this message translates to:
  /// **'Engineers'**
  String get fieldEngineers;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get fieldCompany;

  /// No description provided for @fieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get fieldPhone;

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get fieldEmail;

  /// No description provided for @fieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get fieldNotes;

  /// No description provided for @fieldEmployeeCode.
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get fieldEmployeeCode;

  /// No description provided for @fieldJoiningDate.
  ///
  /// In en, this message translates to:
  /// **'Joining date'**
  String get fieldJoiningDate;

  /// No description provided for @fieldDesignation.
  ///
  /// In en, this message translates to:
  /// **'Designation'**
  String get fieldDesignation;

  /// No description provided for @fieldSite.
  ///
  /// In en, this message translates to:
  /// **'Site'**
  String get fieldSite;

  /// No description provided for @fieldEngineer.
  ///
  /// In en, this message translates to:
  /// **'Engineer'**
  String get fieldEngineer;

  /// No description provided for @siteSaved.
  ///
  /// In en, this message translates to:
  /// **'Site saved.'**
  String get siteSaved;

  /// No description provided for @clientSaved.
  ///
  /// In en, this message translates to:
  /// **'Client saved.'**
  String get clientSaved;

  /// No description provided for @personSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get personSaved;

  /// No description provided for @locationServiceOff.
  ///
  /// In en, this message translates to:
  /// **'Turn on location (GPS) and try again.'**
  String get locationServiceOff;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Allow location access to use this.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionForever.
  ///
  /// In en, this message translates to:
  /// **'Location access is blocked. Allow it in Settings.'**
  String get locationPermissionForever;

  /// No description provided for @locationNoFix.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get your location. Move to an open area and try again.'**
  String get locationNoFix;

  /// No description provided for @clientSites.
  ///
  /// In en, this message translates to:
  /// **'Sites'**
  String get clientSites;

  /// No description provided for @clientNoSites.
  ///
  /// In en, this message translates to:
  /// **'No sites for this client yet.'**
  String get clientNoSites;

  /// No description provided for @peopleTitle.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get peopleTitle;

  /// No description provided for @engineersTitle.
  ///
  /// In en, this message translates to:
  /// **'Engineers'**
  String get engineersTitle;

  /// No description provided for @staffTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staffTitle;

  /// No description provided for @peopleSearch.
  ///
  /// In en, this message translates to:
  /// **'Search by name, phone or ID'**
  String get peopleSearch;

  /// No description provided for @engineersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No engineers found.'**
  String get engineersEmpty;

  /// No description provided for @staffEmpty.
  ///
  /// In en, this message translates to:
  /// **'No staff found.'**
  String get staffEmpty;

  /// No description provided for @engineerNew.
  ///
  /// In en, this message translates to:
  /// **'New engineer'**
  String get engineerNew;

  /// No description provided for @staffNew.
  ///
  /// In en, this message translates to:
  /// **'New staff member'**
  String get staffNew;

  /// No description provided for @filterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get filterActive;

  /// No description provided for @filterInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get filterInactive;

  /// No description provided for @filterUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get filterUnassigned;

  /// No description provided for @personLastSignIn.
  ///
  /// In en, this message translates to:
  /// **'Last sign-in'**
  String get personLastSignIn;

  /// No description provided for @personNeverSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Never signed in'**
  String get personNeverSignedIn;

  /// No description provided for @personPasswordPending.
  ///
  /// In en, this message translates to:
  /// **'Must set their own password at next sign-in'**
  String get personPasswordPending;

  /// No description provided for @personSites.
  ///
  /// In en, this message translates to:
  /// **'Sites'**
  String get personSites;

  /// No description provided for @personSupervises.
  ///
  /// In en, this message translates to:
  /// **'Supervises'**
  String get personSupervises;

  /// No description provided for @personAssignment.
  ///
  /// In en, this message translates to:
  /// **'Site and engineer'**
  String get personAssignment;

  /// No description provided for @personNotAssigned.
  ///
  /// In en, this message translates to:
  /// **'Not assigned to a site'**
  String get personNotAssigned;

  /// No description provided for @personAssign.
  ///
  /// In en, this message translates to:
  /// **'Assign to site'**
  String get personAssign;

  /// No description provided for @personChangeAssignment.
  ///
  /// In en, this message translates to:
  /// **'Change site'**
  String get personChangeAssignment;

  /// No description provided for @personUnassign.
  ///
  /// In en, this message translates to:
  /// **'Remove from site'**
  String get personUnassign;

  /// No description provided for @personUnassignConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from {site}?'**
  String personUnassignConfirm(String name, String site);

  /// No description provided for @personResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get personResetPassword;

  /// No description provided for @personResetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password?'**
  String get personResetConfirmTitle;

  /// No description provided for @personResetConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{name} will be signed out and must sign in with a temporary password, then choose a new one.'**
  String personResetConfirmBody(String name);

  /// No description provided for @personDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get personDeactivate;

  /// No description provided for @personActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get personActivate;

  /// No description provided for @personDeactivateConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Deactivate {name}?'**
  String personDeactivateConfirmTitle(String name);

  /// No description provided for @personDeactivateConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'They will be signed out and removed from their sites. Their history is kept.'**
  String get personDeactivateConfirmBody;

  /// No description provided for @tempPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Temporary password'**
  String get tempPasswordTitle;

  /// No description provided for @tempPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Give this password to {name}. They will choose their own password when they sign in.'**
  String tempPasswordBody(String name);

  /// No description provided for @assignTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign {name}'**
  String assignTitle(String name);

  /// No description provided for @assignNoEngineers.
  ///
  /// In en, this message translates to:
  /// **'This site has no engineers yet. Add one to the site first.'**
  String get assignNoEngineers;

  /// No description provided for @assignSave.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get assignSave;

  /// No description provided for @siteCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No sites} =1{1 site} other{{count} sites}}'**
  String siteCount(int count);

  /// No description provided for @assignStaffToSite.
  ///
  /// In en, this message translates to:
  /// **'Add staff to {site}'**
  String assignStaffToSite(String site);

  /// No description provided for @fieldStaffMember.
  ///
  /// In en, this message translates to:
  /// **'Staff member'**
  String get fieldStaffMember;

  /// No description provided for @assignNoUnassignedStaff.
  ///
  /// In en, this message translates to:
  /// **'Everyone is already assigned to a site. Add a new staff member from People.'**
  String get assignNoUnassignedStaff;

  /// No description provided for @engineerEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit engineer'**
  String get engineerEdit;

  /// No description provided for @staffEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit staff member'**
  String get staffEdit;

  /// No description provided for @personNoSites.
  ///
  /// In en, this message translates to:
  /// **'Not assigned to any site.'**
  String get personNoSites;

  /// No description provided for @personSupervisesNone.
  ///
  /// In en, this message translates to:
  /// **'No staff report to them yet.'**
  String get personSupervisesNone;

  /// No description provided for @personActivated.
  ///
  /// In en, this message translates to:
  /// **'{name} is active again.'**
  String personActivated(String name);

  /// No description provided for @personDeactivated.
  ///
  /// In en, this message translates to:
  /// **'{name} has been deactivated.'**
  String personDeactivated(String name);

  /// No description provided for @personInactiveBanner.
  ///
  /// In en, this message translates to:
  /// **'This account is deactivated. They can\'t sign in.'**
  String get personInactiveBanner;

  /// No description provided for @filterDesignation.
  ///
  /// In en, this message translates to:
  /// **'Designation'**
  String get filterDesignation;

  /// No description provided for @personInitialSitesHelper.
  ///
  /// In en, this message translates to:
  /// **'Optional. You can change this later from each site\'s Team tab.'**
  String get personInitialSitesHelper;

  /// No description provided for @personInitialAssignment.
  ///
  /// In en, this message translates to:
  /// **'Assign to a site now (optional)'**
  String get personInitialAssignment;

  /// No description provided for @siteLocationHelp.
  ///
  /// In en, this message translates to:
  /// **'Used to check that staff are at the site when they send updates.'**
  String get siteLocationHelp;

  /// No description provided for @validationCompletionBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'Must be on or after the start date'**
  String get validationCompletionBeforeStart;

  /// No description provided for @siteNoMilestones.
  ///
  /// In en, this message translates to:
  /// **'No payment milestones yet.'**
  String get siteNoMilestones;

  /// No description provided for @milestoneDue.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String milestoneDue(String date);

  /// No description provided for @milestonePaidOf.
  ///
  /// In en, this message translates to:
  /// **'{paid} of {amount} paid'**
  String milestonePaidOf(String paid, String amount);

  /// No description provided for @siteEngineersSaved.
  ///
  /// In en, this message translates to:
  /// **'Engineers updated.'**
  String get siteEngineersSaved;

  /// No description provided for @staffAssigned.
  ///
  /// In en, this message translates to:
  /// **'{name} assigned to {site}.'**
  String staffAssigned(String name, String site);

  /// No description provided for @staffUnassigned.
  ///
  /// In en, this message translates to:
  /// **'{name} removed from the site.'**
  String staffUnassigned(String name);

  /// No description provided for @locationCaptured.
  ///
  /// In en, this message translates to:
  /// **'Location set (accurate to about {meters} m).'**
  String locationCaptured(int meters);

  /// No description provided for @locationMocked.
  ///
  /// In en, this message translates to:
  /// **'Your phone is using a mock location app. Turn it off and try again.'**
  String get locationMocked;

  /// No description provided for @locationClear.
  ///
  /// In en, this message translates to:
  /// **'Clear location'**
  String get locationClear;

  /// No description provided for @siteNoLocation.
  ///
  /// In en, this message translates to:
  /// **'No location set. Staff updates can\'t be checked against the site.'**
  String get siteNoLocation;

  /// No description provided for @siteContactNone.
  ///
  /// In en, this message translates to:
  /// **'No site contact'**
  String get siteContactNone;

  /// No description provided for @personSupervisedBy.
  ///
  /// In en, this message translates to:
  /// **'Reports to {name}'**
  String personSupervisedBy(String name);

  /// No description provided for @commonActions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get commonActions;

  /// No description provided for @milestonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment schedule'**
  String get milestonesTitle;

  /// No description provided for @staffGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String staffGreeting(String name);

  /// No description provided for @staffYourEngineer.
  ///
  /// In en, this message translates to:
  /// **'Your engineer'**
  String get staffYourEngineer;

  /// No description provided for @staffNotAssigned.
  ///
  /// In en, this message translates to:
  /// **'You\'re not assigned to a site yet. Please contact your engineer or admin.'**
  String get staffNotAssigned;

  /// No description provided for @attendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendanceTitle;

  /// No description provided for @attendanceToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s attendance'**
  String get attendanceToday;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check out'**
  String get checkOut;

  /// No description provided for @checkingLocation.
  ///
  /// In en, this message translates to:
  /// **'Getting your location…'**
  String get checkingLocation;

  /// No description provided for @checkedInAt.
  ///
  /// In en, this message translates to:
  /// **'Checked in at {time}'**
  String checkedInAt(String time);

  /// No description provided for @checkedOutAt.
  ///
  /// In en, this message translates to:
  /// **'Checked out at {time}'**
  String checkedOutAt(String time);

  /// No description provided for @workedDuration.
  ///
  /// In en, this message translates to:
  /// **'Worked {hours} h {minutes} min'**
  String workedDuration(int hours, int minutes);

  /// No description provided for @notCheckedInYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t checked in yet.'**
  String get notCheckedInYet;

  /// No description provided for @checkInDone.
  ///
  /// In en, this message translates to:
  /// **'Checked in. Have a good day!'**
  String get checkInDone;

  /// No description provided for @checkOutDone.
  ///
  /// In en, this message translates to:
  /// **'Checked out. See you tomorrow!'**
  String get checkOutDone;

  /// No description provided for @checkOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Check out now?'**
  String get checkOutConfirmTitle;

  /// No description provided for @checkOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You can\'t check in again today.'**
  String get checkOutConfirmBody;

  /// No description provided for @checkInNotToday.
  ///
  /// In en, this message translates to:
  /// **'No check-in needed today.'**
  String get checkInNotToday;

  /// No description provided for @locationFlagOutside.
  ///
  /// In en, this message translates to:
  /// **'Away from the site'**
  String get locationFlagOutside;

  /// No description provided for @locationFlagMocked.
  ///
  /// In en, this message translates to:
  /// **'Mock location'**
  String get locationFlagMocked;

  /// No description provided for @locationFlagNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Location not allowed'**
  String get locationFlagNoPermission;

  /// No description provided for @locationFlagUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No location'**
  String get locationFlagUnavailable;

  /// No description provided for @locationFlagOk.
  ///
  /// In en, this message translates to:
  /// **'At the site'**
  String get locationFlagOk;

  /// No description provided for @slotWindow.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end}'**
  String slotWindow(String start, String end);

  /// No description provided for @slotTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get slotTakePhoto;

  /// No description provided for @slotSentAt.
  ///
  /// In en, this message translates to:
  /// **'Sent at {time}'**
  String slotSentAt(String time);

  /// No description provided for @slotSentOffline.
  ///
  /// In en, this message translates to:
  /// **'Sent later (offline)'**
  String get slotSentOffline;

  /// No description provided for @slotOpensAt.
  ///
  /// In en, this message translates to:
  /// **'Opens at {time}'**
  String slotOpensAt(String time);

  /// No description provided for @slotDueBy.
  ///
  /// In en, this message translates to:
  /// **'Due by {time}'**
  String slotDueBy(String time);

  /// No description provided for @slotCheckInFirst.
  ///
  /// In en, this message translates to:
  /// **'Check in first to send this update.'**
  String get slotCheckInFirst;

  /// No description provided for @slotSavedOnPhone.
  ///
  /// In en, this message translates to:
  /// **'Saved on this phone, waiting to send'**
  String get slotSavedOnPhone;

  /// No description provided for @captureTitle.
  ///
  /// In en, this message translates to:
  /// **'{slot} update'**
  String captureTitle(String slot);

  /// No description provided for @captureRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get captureRetake;

  /// No description provided for @captureFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get captureFromGallery;

  /// No description provided for @captureGalleryNote.
  ///
  /// In en, this message translates to:
  /// **'Photos from the gallery are marked for review. Use the camera when you can.'**
  String get captureGalleryNote;

  /// No description provided for @captureDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'What work was done?'**
  String get captureDescriptionLabel;

  /// No description provided for @captureDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Plastering on the 2nd floor, east side'**
  String get captureDescriptionHint;

  /// No description provided for @captureDescriptionTooShort.
  ///
  /// In en, this message translates to:
  /// **'Write a few words about the work.'**
  String get captureDescriptionTooShort;

  /// No description provided for @capturePhotoRequired.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of the work first.'**
  String get capturePhotoRequired;

  /// No description provided for @captureSend.
  ///
  /// In en, this message translates to:
  /// **'Send update'**
  String get captureSend;

  /// No description provided for @captureSending.
  ///
  /// In en, this message translates to:
  /// **'Sending… {percent}%'**
  String captureSending(int percent);

  /// No description provided for @captureSent.
  ///
  /// In en, this message translates to:
  /// **'{slot} update sent.'**
  String captureSent(String slot);

  /// No description provided for @captureQueued.
  ///
  /// In en, this message translates to:
  /// **'No connection. Your update is saved and will be sent automatically.'**
  String get captureQueued;

  /// No description provided for @captureLocationFound.
  ///
  /// In en, this message translates to:
  /// **'Location found (accurate to about {meters} m)'**
  String captureLocationFound(int meters);

  /// No description provided for @captureLocationMarked.
  ///
  /// In en, this message translates to:
  /// **'The update will be sent without a location and marked.'**
  String get captureLocationMarked;

  /// No description provided for @captureCameraFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the camera. Please try again.'**
  String get captureCameraFailed;

  /// No description provided for @queueTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting to send'**
  String get queueTitle;

  /// No description provided for @queueWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for a connection'**
  String get queueWaiting;

  /// No description provided for @queueSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get queueSending;

  /// No description provided for @queueFailed.
  ///
  /// In en, this message translates to:
  /// **'Not sent: {reason}'**
  String queueFailed(String reason);

  /// No description provided for @queueTaken.
  ///
  /// In en, this message translates to:
  /// **'{slot} · taken {time}'**
  String queueTaken(String slot, String time);

  /// No description provided for @queueDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get queueDiscard;

  /// No description provided for @queueDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard this update?'**
  String get queueDiscardTitle;

  /// No description provided for @queueDiscardBody.
  ///
  /// In en, this message translates to:
  /// **'The photo and description will be deleted from this phone.'**
  String get queueDiscardBody;

  /// No description provided for @queueSendNow.
  ///
  /// In en, this message translates to:
  /// **'Send now'**
  String get queueSendNow;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your updates'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No updates yet.'**
  String get historyEmpty;

  /// No description provided for @attendanceHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Past days'**
  String get attendanceHistoryTitle;

  /// No description provided for @attendanceHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No attendance yet.'**
  String get attendanceHistoryEmpty;

  /// No description provided for @photoAwaitingReview.
  ///
  /// In en, this message translates to:
  /// **'Photo waiting for review'**
  String get photoAwaitingReview;

  /// No description provided for @photoReviewed.
  ///
  /// In en, this message translates to:
  /// **'Photo reviewed, being removed'**
  String get photoReviewed;

  /// No description provided for @photoRemovedReviewed.
  ///
  /// In en, this message translates to:
  /// **'Photo reviewed and removed'**
  String get photoRemovedReviewed;

  /// No description provided for @photoRemovedExpired.
  ///
  /// In en, this message translates to:
  /// **'Photo removed after the review period'**
  String get photoRemovedExpired;

  /// No description provided for @photoFromGallery.
  ///
  /// In en, this message translates to:
  /// **'From gallery'**
  String get photoFromGallery;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up.'**
  String get notificationsEmpty;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notificationsMarkAllRead;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String timeMinutesAgo(int minutes);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} h ago'**
  String timeHoursAgo(int hours);

  /// No description provided for @timeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday, {time}'**
  String timeYesterday(String time);

  /// No description provided for @notificationUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notificationUnread;

  /// No description provided for @statYourSites.
  ///
  /// In en, this message translates to:
  /// **'Your sites'**
  String get statYourSites;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos to review'**
  String get reviewTitle;

  /// No description provided for @reviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'All photos have been reviewed.'**
  String get reviewEmpty;

  /// No description provided for @siteTabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get siteTabToday;

  /// No description provided for @boardNoStaff.
  ///
  /// In en, this message translates to:
  /// **'No staff on this site.'**
  String get boardNoStaff;

  /// No description provided for @boardNotCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Not checked in'**
  String get boardNotCheckedIn;

  /// No description provided for @boardCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'In {time}'**
  String boardCheckedIn(String time);

  /// No description provided for @boardCheckedOut.
  ///
  /// In en, this message translates to:
  /// **'Out {time}'**
  String boardCheckedOut(String time);

  /// No description provided for @boardPreviousDay.
  ///
  /// In en, this message translates to:
  /// **'Previous day'**
  String get boardPreviousDay;

  /// No description provided for @boardNextDay.
  ///
  /// In en, this message translates to:
  /// **'Next day'**
  String get boardNextDay;

  /// No description provided for @boardToReview.
  ///
  /// In en, this message translates to:
  /// **'To review'**
  String get boardToReview;

  /// No description provided for @photoViewerTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} · {slot}'**
  String photoViewerTitle(String name, String slot);

  /// No description provided for @photoDeleted.
  ///
  /// In en, this message translates to:
  /// **'This photo has been deleted. Photos are removed once reviewed, or after a day. The update itself is kept.'**
  String get photoDeleted;

  /// No description provided for @photoLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the photo.'**
  String get photoLoadFailed;

  /// No description provided for @updateTakenAt.
  ///
  /// In en, this message translates to:
  /// **'Taken {time}'**
  String updateTakenAt(String time);

  /// No description provided for @updateSentAt.
  ///
  /// In en, this message translates to:
  /// **'Sent {time}'**
  String updateSentAt(String time);

  /// No description provided for @updateDistance.
  ///
  /// In en, this message translates to:
  /// **'{meters} m from the site'**
  String updateDistance(int meters);

  /// No description provided for @reviewEngineerDone.
  ///
  /// In en, this message translates to:
  /// **'Engineer reviewed'**
  String get reviewEngineerDone;

  /// No description provided for @reviewEngineerPending.
  ///
  /// In en, this message translates to:
  /// **'Engineer hasn\'t reviewed'**
  String get reviewEngineerPending;

  /// No description provided for @reviewAdminDone.
  ///
  /// In en, this message translates to:
  /// **'Admin reviewed'**
  String get reviewAdminDone;

  /// No description provided for @reviewAdminPending.
  ///
  /// In en, this message translates to:
  /// **'Admin hasn\'t reviewed'**
  String get reviewAdminPending;

  /// No description provided for @engineerUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Updates to admin'**
  String get engineerUpdatesTitle;

  /// No description provided for @engineerUpdateNew.
  ///
  /// In en, this message translates to:
  /// **'New update'**
  String get engineerUpdateNew;

  /// No description provided for @engineerUpdatesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No updates yet.'**
  String get engineerUpdatesEmpty;

  /// No description provided for @engineerUpdateSent.
  ///
  /// In en, this message translates to:
  /// **'Update sent to the admin.'**
  String get engineerUpdateSent;

  /// No description provided for @engineerUpdateSeen.
  ///
  /// In en, this message translates to:
  /// **'Seen by admin {time}'**
  String engineerUpdateSeen(String time);

  /// No description provided for @engineerUpdateNotSeen.
  ///
  /// In en, this message translates to:
  /// **'Not seen by the admin yet'**
  String get engineerUpdateNotSeen;

  /// No description provided for @engineerUpdateTypeProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get engineerUpdateTypeProgress;

  /// No description provided for @engineerUpdateTypeCompletedWork.
  ///
  /// In en, this message translates to:
  /// **'Completed work'**
  String get engineerUpdateTypeCompletedWork;

  /// No description provided for @engineerUpdateTypeMaterialsRequired.
  ///
  /// In en, this message translates to:
  /// **'Materials required'**
  String get engineerUpdateTypeMaterialsRequired;

  /// No description provided for @engineerUpdateTypeSafetyConcern.
  ///
  /// In en, this message translates to:
  /// **'Safety concern'**
  String get engineerUpdateTypeSafetyConcern;

  /// No description provided for @engineerUpdateTypeClientRequirement.
  ///
  /// In en, this message translates to:
  /// **'Client requirement'**
  String get engineerUpdateTypeClientRequirement;

  /// No description provided for @engineerUpdateTypeRemark.
  ///
  /// In en, this message translates to:
  /// **'Remark'**
  String get engineerUpdateTypeRemark;

  /// No description provided for @engineerUpdateTypeDailyReport.
  ///
  /// In en, this message translates to:
  /// **'Daily report'**
  String get engineerUpdateTypeDailyReport;

  /// No description provided for @fieldType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fieldType;

  /// No description provided for @fieldPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get fieldPriority;

  /// No description provided for @fieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldTitle;

  /// No description provided for @fieldTitleOptional.
  ///
  /// In en, this message translates to:
  /// **'Title (optional)'**
  String get fieldTitleOptional;

  /// No description provided for @fieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get fieldDescription;

  /// No description provided for @fieldPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get fieldPhotos;

  /// No description provided for @fieldProgressValue.
  ///
  /// In en, this message translates to:
  /// **'Site progress: {percent}%'**
  String fieldProgressValue(int percent);

  /// No description provided for @photosAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get photosAdd;

  /// No description provided for @photosLimit.
  ///
  /// In en, this message translates to:
  /// **'Up to {max} photos'**
  String photosLimit(int max);

  /// No description provided for @photoCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get photoCamera;

  /// No description provided for @photoGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get photoGallery;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get commonSend;

  /// No description provided for @issuesTitle.
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get issuesTitle;

  /// No description provided for @issueNew.
  ///
  /// In en, this message translates to:
  /// **'Report issue'**
  String get issueNew;

  /// No description provided for @issuesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No issues here.'**
  String get issuesEmpty;

  /// No description provided for @issueReportedDone.
  ///
  /// In en, this message translates to:
  /// **'Issue reported.'**
  String get issueReportedDone;

  /// No description provided for @issueReportedBy.
  ///
  /// In en, this message translates to:
  /// **'Reported by {name} · {time}'**
  String issueReportedBy(String name, String time);

  /// No description provided for @issueResolvedBy.
  ///
  /// In en, this message translates to:
  /// **'Resolved by {name} · {time}'**
  String issueResolvedBy(String name, String time);

  /// No description provided for @issueStartWork.
  ///
  /// In en, this message translates to:
  /// **'Start work'**
  String get issueStartWork;

  /// No description provided for @issueResolve.
  ///
  /// In en, this message translates to:
  /// **'Mark resolved'**
  String get issueResolve;

  /// No description provided for @issueReopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get issueReopen;

  /// No description provided for @issueResolveTitle.
  ///
  /// In en, this message translates to:
  /// **'Resolve issue'**
  String get issueResolveTitle;

  /// No description provided for @issueResolutionLabel.
  ///
  /// In en, this message translates to:
  /// **'What was done?'**
  String get issueResolutionLabel;

  /// No description provided for @issueUpdatedDone.
  ///
  /// In en, this message translates to:
  /// **'Issue updated.'**
  String get issueUpdatedDone;

  /// No description provided for @issueFilterUnresolved.
  ///
  /// In en, this message translates to:
  /// **'Unresolved'**
  String get issueFilterUnresolved;

  /// No description provided for @attachmentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo} other{{count} photos}}'**
  String attachmentsCount(int count);

  /// No description provided for @commonView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get commonView;

  /// No description provided for @paymentsAll.
  ///
  /// In en, this message translates to:
  /// **'All payments'**
  String get paymentsAll;

  /// No description provided for @paymentsRecord.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get paymentsRecord;

  /// No description provided for @paymentRecorded.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded.'**
  String get paymentRecorded;

  /// No description provided for @paymentVoid.
  ///
  /// In en, this message translates to:
  /// **'Void payment'**
  String get paymentVoid;

  /// No description provided for @paymentVoidTitle.
  ///
  /// In en, this message translates to:
  /// **'Void this payment?'**
  String get paymentVoidTitle;

  /// No description provided for @paymentVoidBody.
  ///
  /// In en, this message translates to:
  /// **'It stays in the history, marked void, and stops counting toward the site\'s total.'**
  String get paymentVoidBody;

  /// No description provided for @paymentVoidReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get paymentVoidReason;

  /// No description provided for @paymentVoided.
  ///
  /// In en, this message translates to:
  /// **'Payment voided.'**
  String get paymentVoided;

  /// No description provided for @paymentVoidedBy.
  ///
  /// In en, this message translates to:
  /// **'Voided by {name}: {reason}'**
  String paymentVoidedBy(String name, String reason);

  /// No description provided for @paymentVoidChip.
  ///
  /// In en, this message translates to:
  /// **'Void'**
  String get paymentVoidChip;

  /// No description provided for @paymentRecordedBy.
  ///
  /// In en, this message translates to:
  /// **'Recorded by {name}'**
  String paymentRecordedBy(String name);

  /// No description provided for @paymentMethodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// No description provided for @paymentMethodUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get paymentMethodUpi;

  /// No description provided for @paymentMethodBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get paymentMethodBankTransfer;

  /// No description provided for @paymentMethodCheque.
  ///
  /// In en, this message translates to:
  /// **'Cheque'**
  String get paymentMethodCheque;

  /// No description provided for @paymentMethodOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get paymentMethodOther;

  /// No description provided for @fieldAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get fieldAmount;

  /// No description provided for @fieldPaidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid on'**
  String get fieldPaidOn;

  /// No description provided for @fieldMethod.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get fieldMethod;

  /// No description provided for @fieldReference.
  ///
  /// In en, this message translates to:
  /// **'Reference (cheque or UTR no.)'**
  String get fieldReference;

  /// No description provided for @fieldRemarks.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get fieldRemarks;

  /// No description provided for @fieldDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get fieldDueDate;

  /// No description provided for @milestoneAdd.
  ///
  /// In en, this message translates to:
  /// **'Add milestone'**
  String get milestoneAdd;

  /// No description provided for @milestoneEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit milestone'**
  String get milestoneEdit;

  /// No description provided for @milestoneSaved.
  ///
  /// In en, this message translates to:
  /// **'Milestone saved.'**
  String get milestoneSaved;

  /// No description provided for @milestoneDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete milestone'**
  String get milestoneDelete;

  /// No description provided for @milestoneDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this milestone?'**
  String get milestoneDeleteTitle;

  /// No description provided for @milestoneDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Payments stay recorded and count toward the remaining milestones.'**
  String get milestoneDeleteBody;

  /// No description provided for @milestoneDeleted.
  ///
  /// In en, this message translates to:
  /// **'Milestone deleted.'**
  String get milestoneDeleted;

  /// No description provided for @paymentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No payments yet.'**
  String get paymentsEmpty;

  /// No description provided for @paymentsReceivedOf.
  ///
  /// In en, this message translates to:
  /// **'{received} of {contract} received'**
  String paymentsReceivedOf(String received, String contract);

  /// No description provided for @paymentsNextDue.
  ///
  /// In en, this message translates to:
  /// **'Next: {title} · {amount} due {date}'**
  String paymentsNextDue(String title, String amount, String date);

  /// No description provided for @paymentsShowVoided.
  ///
  /// In en, this message translates to:
  /// **'Show voided'**
  String get paymentsShowVoided;

  /// No description provided for @paymentsReceivedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payments received'**
  String get paymentsReceivedTitle;

  /// No description provided for @paymentsBySite.
  ///
  /// In en, this message translates to:
  /// **'By site'**
  String get paymentsBySite;

  /// No description provided for @paymentsNoSites.
  ///
  /// In en, this message translates to:
  /// **'No sites yet.'**
  String get paymentsNoSites;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportsEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance, photo updates and more, for any dates'**
  String get reportsEntrySubtitle;

  /// No description provided for @reportsExport.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get reportsExport;

  /// No description provided for @reportsTooLong.
  ///
  /// In en, this message translates to:
  /// **'Choose at most {days} days.'**
  String reportsTooLong(int days);

  /// No description provided for @reportsRange.
  ///
  /// In en, this message translates to:
  /// **'{from} – {to}'**
  String reportsRange(String from, String to);

  /// No description provided for @reportsAllSites.
  ///
  /// In en, this message translates to:
  /// **'All sites'**
  String get reportsAllSites;

  /// No description provided for @reportKindSites.
  ///
  /// In en, this message translates to:
  /// **'Sites'**
  String get reportKindSites;

  /// No description provided for @reportKindStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get reportKindStaff;

  /// No description provided for @reportKindEngineers.
  ///
  /// In en, this message translates to:
  /// **'Engineers'**
  String get reportKindEngineers;

  /// No description provided for @reportKindPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get reportKindPayments;

  /// No description provided for @reportKindStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get reportKindStock;

  /// No description provided for @reportPeriodThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get reportPeriodThisWeek;

  /// No description provided for @reportPeriodThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get reportPeriodThisMonth;

  /// No description provided for @reportPeriodLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get reportPeriodLastMonth;

  /// No description provided for @reportPeriodCustom.
  ///
  /// In en, this message translates to:
  /// **'Pick dates'**
  String get reportPeriodCustom;

  /// No description provided for @reportsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing to report for these dates.'**
  String get reportsEmpty;

  /// No description provided for @reportsGroupUpdates.
  ///
  /// In en, this message translates to:
  /// **'Photo updates'**
  String get reportsGroupUpdates;

  /// No description provided for @reportsGroupAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get reportsGroupAttendance;

  /// No description provided for @reportsGroupWork.
  ///
  /// In en, this message translates to:
  /// **'Updates and issues'**
  String get reportsGroupWork;

  /// No description provided for @reportsGroupReviews.
  ///
  /// In en, this message translates to:
  /// **'Photo reviews'**
  String get reportsGroupReviews;

  /// No description provided for @reportsUpdatesSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get reportsUpdatesSent;

  /// No description provided for @reportsUpdatesMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get reportsUpdatesMissed;

  /// No description provided for @reportsSentOffline.
  ///
  /// In en, this message translates to:
  /// **'Sent offline'**
  String get reportsSentOffline;

  /// No description provided for @reportsLocationFlagged.
  ///
  /// In en, this message translates to:
  /// **'Location flagged'**
  String get reportsLocationFlagged;

  /// No description provided for @reportsEngineerUpdates.
  ///
  /// In en, this message translates to:
  /// **'Updates to admin'**
  String get reportsEngineerUpdates;

  /// No description provided for @reportsIssuesOpened.
  ///
  /// In en, this message translates to:
  /// **'Issues opened'**
  String get reportsIssuesOpened;

  /// No description provided for @reportsIssuesResolved.
  ///
  /// In en, this message translates to:
  /// **'Issues resolved'**
  String get reportsIssuesResolved;

  /// No description provided for @reportsIssuesOpenNow.
  ///
  /// In en, this message translates to:
  /// **'Open now'**
  String get reportsIssuesOpenNow;

  /// No description provided for @reportsIssuesReported.
  ///
  /// In en, this message translates to:
  /// **'Issues reported'**
  String get reportsIssuesReported;

  /// No description provided for @reportsPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get reportsPhotos;

  /// No description provided for @reportsReviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get reportsReviewed;

  /// No description provided for @reportsReviewRate.
  ///
  /// In en, this message translates to:
  /// **'Review rate'**
  String get reportsReviewRate;

  /// No description provided for @reportsReviewMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes to review'**
  String get reportsReviewMinutes;

  /// No description provided for @reportsCompliance.
  ///
  /// In en, this message translates to:
  /// **'{percent}% sent'**
  String reportsCompliance(int percent);

  /// No description provided for @reportsNothingDue.
  ///
  /// In en, this message translates to:
  /// **'Nothing due'**
  String get reportsNothingDue;

  /// No description provided for @reportsReceivedInRange.
  ///
  /// In en, this message translates to:
  /// **'Received in these dates'**
  String get reportsReceivedInRange;

  /// No description provided for @reportsPaymentCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 payment} other{{count} payments}}'**
  String reportsPaymentCount(int count);

  /// No description provided for @reportsInRange.
  ///
  /// In en, this message translates to:
  /// **'In these dates'**
  String get reportsInRange;

  /// No description provided for @reportsReceivedToDate.
  ///
  /// In en, this message translates to:
  /// **'Received to date'**
  String get reportsReceivedToDate;

  /// No description provided for @reportsPaymentsInRange.
  ///
  /// In en, this message translates to:
  /// **'Payments in these dates'**
  String get reportsPaymentsInRange;

  /// No description provided for @reportsNoPayments.
  ///
  /// In en, this message translates to:
  /// **'No payments in these dates.'**
  String get reportsNoPayments;

  /// No description provided for @locationApproximate.
  ///
  /// In en, this message translates to:
  /// **'Only approximate location is allowed, so this may be marked away from the site. Turn on \"Use precise location\" for this app.'**
  String get locationApproximate;

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'This page isn\'t available'**
  String get notFoundTitle;

  /// No description provided for @notFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'The link may be old or mistyped.'**
  String get notFoundMessage;

  /// No description provided for @notFoundGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get notFoundGoHome;

  /// No description provided for @fieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldDate;

  /// No description provided for @fieldNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get fieldNoteOptional;

  /// No description provided for @stockTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stockTitle;

  /// No description provided for @stockEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Godowns, materials and deliveries'**
  String get stockEntrySubtitle;

  /// No description provided for @stockEngineerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What the godowns hold'**
  String get stockEngineerSubtitle;

  /// No description provided for @stockDeliveriesToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Deliveries to confirm'**
  String get stockDeliveriesToConfirm;

  /// No description provided for @stockLowCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 low on stock} other{{count} low on stock}}'**
  String stockLowCount(int count);

  /// No description provided for @stockToConfirmCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 to confirm} other{{count} to confirm}}'**
  String stockToConfirmCount(int count);

  /// No description provided for @stockGodowns.
  ///
  /// In en, this message translates to:
  /// **'Godowns'**
  String get stockGodowns;

  /// No description provided for @stockGodownLabel.
  ///
  /// In en, this message translates to:
  /// **'Godown'**
  String get stockGodownLabel;

  /// No description provided for @stockSiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Site'**
  String get stockSiteLabel;

  /// No description provided for @stockNoGodowns.
  ///
  /// In en, this message translates to:
  /// **'No godowns yet.'**
  String get stockNoGodowns;

  /// No description provided for @stockNoGodownsAdmin.
  ///
  /// In en, this message translates to:
  /// **'No godowns yet. Add one from the menu above.'**
  String get stockNoGodownsAdmin;

  /// No description provided for @stockArrivingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} on the way'**
  String stockArrivingCount(int count);

  /// No description provided for @stockPlaceSupplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get stockPlaceSupplier;

  /// No description provided for @stockPlaceUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get stockPlaceUsed;

  /// No description provided for @stockPlaceWaste.
  ///
  /// In en, this message translates to:
  /// **'Written off'**
  String get stockPlaceWaste;

  /// No description provided for @stockPlaceCount.
  ///
  /// In en, this message translates to:
  /// **'Count correction'**
  String get stockPlaceCount;

  /// No description provided for @stockKindPurchase.
  ///
  /// In en, this message translates to:
  /// **'Bought'**
  String get stockKindPurchase;

  /// No description provided for @stockKindTransfer.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get stockKindTransfer;

  /// No description provided for @stockKindUsage.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get stockKindUsage;

  /// No description provided for @stockKindWriteOff.
  ///
  /// In en, this message translates to:
  /// **'Written off'**
  String get stockKindWriteOff;

  /// No description provided for @stockKindAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Count correction'**
  String get stockKindAdjustment;

  /// No description provided for @stockStatusOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get stockStatusOnTheWay;

  /// No description provided for @stockStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get stockStatusCancelled;

  /// No description provided for @stockStatusShort.
  ///
  /// In en, this message translates to:
  /// **'Short'**
  String get stockStatusShort;

  /// No description provided for @stockShortChip.
  ///
  /// In en, this message translates to:
  /// **'{quantity} short'**
  String stockShortChip(String quantity);

  /// No description provided for @stockLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get stockLow;

  /// No description provided for @stockAndMore.
  ///
  /// In en, this message translates to:
  /// **'{first} and {count} more'**
  String stockAndMore(String first, int count);

  /// No description provided for @stockCountNoDifference.
  ///
  /// In en, this message translates to:
  /// **'Counted: no difference'**
  String get stockCountNoDifference;

  /// No description provided for @stockEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock entry'**
  String get stockEntryTitle;

  /// No description provided for @stockConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get stockConfirm;

  /// No description provided for @stockConfirmReceived.
  ///
  /// In en, this message translates to:
  /// **'Confirm received'**
  String get stockConfirmReceived;

  /// No description provided for @stockReceiveIntro.
  ///
  /// In en, this message translates to:
  /// **'Sent from {from} on {date}. Enter what actually arrived.'**
  String stockReceiveIntro(String from, String date);

  /// No description provided for @stockWhatArrived.
  ///
  /// In en, this message translates to:
  /// **'What arrived'**
  String get stockWhatArrived;

  /// No description provided for @stockSentQuantity.
  ///
  /// In en, this message translates to:
  /// **'Sent: {quantity}'**
  String stockSentQuantity(String quantity);

  /// No description provided for @stockReceiveTooMuch.
  ///
  /// In en, this message translates to:
  /// **'Only {quantity} was sent.'**
  String stockReceiveTooMuch(String quantity);

  /// No description provided for @stockShortNote.
  ///
  /// In en, this message translates to:
  /// **'What happened to the rest?'**
  String get stockShortNote;

  /// No description provided for @stockReceivePhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos of what arrived'**
  String get stockReceivePhotos;

  /// No description provided for @stockPhotoRequired.
  ///
  /// In en, this message translates to:
  /// **'Add at least one photo of what arrived.'**
  String get stockPhotoRequired;

  /// No description provided for @stockReceived.
  ///
  /// In en, this message translates to:
  /// **'Stock received.'**
  String get stockReceived;

  /// No description provided for @stockReceivedTitle.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get stockReceivedTitle;

  /// No description provided for @stockReceivedOf.
  ///
  /// In en, this message translates to:
  /// **'{received} of {sent} arrived'**
  String stockReceivedOf(String received, String sent);

  /// No description provided for @stockReceivedBy.
  ///
  /// In en, this message translates to:
  /// **'Confirmed by {name}'**
  String stockReceivedBy(String name);

  /// No description provided for @stockRecordedBy.
  ///
  /// In en, this message translates to:
  /// **'Recorded by {name}'**
  String stockRecordedBy(String name);

  /// No description provided for @stockDcNumberIs.
  ///
  /// In en, this message translates to:
  /// **'DC {number}'**
  String stockDcNumberIs(String number);

  /// No description provided for @stockBillNoIs.
  ///
  /// In en, this message translates to:
  /// **'Bill {number}'**
  String stockBillNoIs(String number);

  /// No description provided for @stockAtRate.
  ///
  /// In en, this message translates to:
  /// **'{price} per {unit}'**
  String stockAtRate(String price, String unit);

  /// No description provided for @stockTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get stockTotalAmount;

  /// No description provided for @stockDcPhotos.
  ///
  /// In en, this message translates to:
  /// **'Delivery challan photo'**
  String get stockDcPhotos;

  /// No description provided for @stockBillPhotos.
  ///
  /// In en, this message translates to:
  /// **'Bill photos'**
  String get stockBillPhotos;

  /// No description provided for @stockBillPhotosOptional.
  ///
  /// In en, this message translates to:
  /// **'Bill photos (optional)'**
  String get stockBillPhotosOptional;

  /// No description provided for @stockPhotosOptional.
  ///
  /// In en, this message translates to:
  /// **'Photos (optional)'**
  String get stockPhotosOptional;

  /// No description provided for @stockDcPhotoRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a photo of the delivery challan.'**
  String get stockDcPhotoRequired;

  /// No description provided for @stockCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel entry'**
  String get stockCancel;

  /// No description provided for @stockCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this entry?'**
  String get stockCancelTitle;

  /// No description provided for @stockCancelBody.
  ///
  /// In en, this message translates to:
  /// **'The stock goes back to where it came from. The entry stays in the history, marked cancelled.'**
  String get stockCancelBody;

  /// No description provided for @stockCancelReason.
  ///
  /// In en, this message translates to:
  /// **'Why?'**
  String get stockCancelReason;

  /// No description provided for @stockCancelled.
  ///
  /// In en, this message translates to:
  /// **'Entry cancelled.'**
  String get stockCancelled;

  /// No description provided for @stockCancelledBy.
  ///
  /// In en, this message translates to:
  /// **'Cancelled by {name}: {reason}'**
  String stockCancelledBy(String name, String reason);

  /// No description provided for @stockActionPurchase.
  ///
  /// In en, this message translates to:
  /// **'Stock in'**
  String get stockActionPurchase;

  /// No description provided for @stockActionSend.
  ///
  /// In en, this message translates to:
  /// **'Send stock'**
  String get stockActionSend;

  /// No description provided for @stockActionSendOn.
  ///
  /// In en, this message translates to:
  /// **'Return to godown'**
  String get stockActionSendOn;

  /// No description provided for @stockActionUse.
  ///
  /// In en, this message translates to:
  /// **'Record usage'**
  String get stockActionUse;

  /// No description provided for @stockActionWriteOff.
  ///
  /// In en, this message translates to:
  /// **'Write off'**
  String get stockActionWriteOff;

  /// No description provided for @stockActionCount.
  ///
  /// In en, this message translates to:
  /// **'Stock count'**
  String get stockActionCount;

  /// No description provided for @stockIntoGodown.
  ///
  /// In en, this message translates to:
  /// **'Into godown'**
  String get stockIntoGodown;

  /// No description provided for @stockSendFrom.
  ///
  /// In en, this message translates to:
  /// **'Send from'**
  String get stockSendFrom;

  /// No description provided for @stockSendTo.
  ///
  /// In en, this message translates to:
  /// **'Send to'**
  String get stockSendTo;

  /// No description provided for @stockAt.
  ///
  /// In en, this message translates to:
  /// **'At'**
  String get stockAt;

  /// No description provided for @stockChooseSource.
  ///
  /// In en, this message translates to:
  /// **'Choose where the stock comes from first.'**
  String get stockChooseSource;

  /// No description provided for @stockCountedOn.
  ///
  /// In en, this message translates to:
  /// **'Counted on'**
  String get stockCountedOn;

  /// No description provided for @stockSupplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier (optional)'**
  String get stockSupplier;

  /// No description provided for @stockBillNo.
  ///
  /// In en, this message translates to:
  /// **'Bill or invoice number (optional)'**
  String get stockBillNo;

  /// No description provided for @stockDcNumber.
  ///
  /// In en, this message translates to:
  /// **'DC number'**
  String get stockDcNumber;

  /// No description provided for @stockMaterials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get stockMaterials;

  /// No description provided for @stockMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get stockMaterial;

  /// No description provided for @stockQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get stockQuantity;

  /// No description provided for @stockCountedQuantity.
  ///
  /// In en, this message translates to:
  /// **'Counted quantity'**
  String get stockCountedQuantity;

  /// No description provided for @stockRate.
  ///
  /// In en, this message translates to:
  /// **'Price per unit (₹)'**
  String get stockRate;

  /// No description provided for @stockRatePer.
  ///
  /// In en, this message translates to:
  /// **'Price per {unit} (₹)'**
  String stockRatePer(String unit);

  /// No description provided for @stockAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available: {quantity}'**
  String stockAvailable(String quantity);

  /// No description provided for @stockOnBooks.
  ///
  /// In en, this message translates to:
  /// **'On the books: {quantity}'**
  String stockOnBooks(String quantity);

  /// No description provided for @stockOnlyAvailable.
  ///
  /// In en, this message translates to:
  /// **'Only {quantity} available.'**
  String stockOnlyAvailable(String quantity);

  /// No description provided for @stockAddMaterial.
  ///
  /// In en, this message translates to:
  /// **'Add material'**
  String get stockAddMaterial;

  /// No description provided for @stockRemoveLine.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get stockRemoveLine;

  /// No description provided for @stockNothingToChoose.
  ///
  /// In en, this message translates to:
  /// **'There is no stock here to choose from.'**
  String get stockNothingToChoose;

  /// No description provided for @stockUsedFor.
  ///
  /// In en, this message translates to:
  /// **'Used for, e.g. first floor slab (optional)'**
  String get stockUsedFor;

  /// No description provided for @stockWhatHappened.
  ///
  /// In en, this message translates to:
  /// **'What happened to it'**
  String get stockWhatHappened;

  /// No description provided for @stockCountNote.
  ///
  /// In en, this message translates to:
  /// **'Why the count differs'**
  String get stockCountNote;

  /// No description provided for @stockSaved.
  ///
  /// In en, this message translates to:
  /// **'Stock saved.'**
  String get stockSaved;

  /// No description provided for @stockCountMatched.
  ///
  /// In en, this message translates to:
  /// **'The count matches the books. Nothing to correct.'**
  String get stockCountMatched;

  /// No description provided for @stockSendHere.
  ///
  /// In en, this message translates to:
  /// **'Send stock here'**
  String get stockSendHere;

  /// No description provided for @stockSendEverything.
  ///
  /// In en, this message translates to:
  /// **'Return everything to a godown'**
  String get stockSendEverything;

  /// No description provided for @stockArrivingHere.
  ///
  /// In en, this message translates to:
  /// **'On the way here'**
  String get stockArrivingHere;

  /// No description provided for @stockLeavingHere.
  ///
  /// In en, this message translates to:
  /// **'Sent, not yet confirmed'**
  String get stockLeavingHere;

  /// No description provided for @stockOnSite.
  ///
  /// In en, this message translates to:
  /// **'On site'**
  String get stockOnSite;

  /// No description provided for @stockInGodown.
  ///
  /// In en, this message translates to:
  /// **'In this godown'**
  String get stockInGodown;

  /// No description provided for @stockUsedUp.
  ///
  /// In en, this message translates to:
  /// **'Used up or sent on'**
  String get stockUsedUp;

  /// No description provided for @stockNothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here now.'**
  String get stockNothingHere;

  /// No description provided for @stockSiteEmpty.
  ///
  /// In en, this message translates to:
  /// **'No stock at this site yet'**
  String get stockSiteEmpty;

  /// No description provided for @stockSiteEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Stock sent from a godown shows here once the site confirms it.'**
  String get stockSiteEmptyBody;

  /// No description provided for @godownEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing in this godown yet'**
  String get godownEmpty;

  /// No description provided for @stockReceivedTotal.
  ///
  /// In en, this message translates to:
  /// **'Received {quantity}'**
  String stockReceivedTotal(String quantity);

  /// No description provided for @stockUsedTotal.
  ///
  /// In en, this message translates to:
  /// **'used {quantity}'**
  String stockUsedTotal(String quantity);

  /// No description provided for @stockSentOutTotal.
  ///
  /// In en, this message translates to:
  /// **'sent on {quantity}'**
  String stockSentOutTotal(String quantity);

  /// No description provided for @stockWastedTotal.
  ///
  /// In en, this message translates to:
  /// **'wasted {quantity}'**
  String stockWastedTotal(String quantity);

  /// No description provided for @stockWorth.
  ///
  /// In en, this message translates to:
  /// **'worth {amount}'**
  String stockWorth(String amount);

  /// No description provided for @stockValueUsed.
  ///
  /// In en, this message translates to:
  /// **'Material used'**
  String get stockValueUsed;

  /// No description provided for @stockValueOnSite.
  ///
  /// In en, this message translates to:
  /// **'On site now'**
  String get stockValueOnSite;

  /// No description provided for @stockValueOnHand.
  ///
  /// In en, this message translates to:
  /// **'Stock value'**
  String get stockValueOnHand;

  /// No description provided for @stockHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get stockHistory;

  /// No description provided for @stockToConfirm.
  ///
  /// In en, this message translates to:
  /// **'To confirm'**
  String get stockToConfirm;

  /// No description provided for @stockNothingToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Nothing waiting for you to confirm.'**
  String get stockNothingToConfirm;

  /// No description provided for @stockNoEntries.
  ///
  /// In en, this message translates to:
  /// **'No stock entries yet.'**
  String get stockNoEntries;

  /// No description provided for @stockSearch.
  ///
  /// In en, this message translates to:
  /// **'Search materials'**
  String get stockSearch;

  /// No description provided for @stockNoMaterials.
  ///
  /// In en, this message translates to:
  /// **'No materials yet'**
  String get stockNoMaterials;

  /// No description provided for @stockNoMaterialsBody.
  ///
  /// In en, this message translates to:
  /// **'Add the materials you keep in stock. You can add more at any time.'**
  String get stockNoMaterialsBody;

  /// No description provided for @stockNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No materials match.'**
  String get stockNoMatch;

  /// No description provided for @stockOnSitesTotal.
  ///
  /// In en, this message translates to:
  /// **'{quantity} at sites'**
  String stockOnSitesTotal(String quantity);

  /// No description provided for @stockInGodowns.
  ///
  /// In en, this message translates to:
  /// **'In the godowns'**
  String get stockInGodowns;

  /// No description provided for @stockMinimum.
  ///
  /// In en, this message translates to:
  /// **'Minimum {quantity}'**
  String stockMinimum(String quantity);

  /// No description provided for @stockInTransitTotal.
  ///
  /// In en, this message translates to:
  /// **'{quantity} on the way'**
  String stockInTransitTotal(String quantity);

  /// No description provided for @stockAveragePrice.
  ///
  /// In en, this message translates to:
  /// **'Average {price} per {unit}'**
  String stockAveragePrice(String price, String unit);

  /// No description provided for @stockNoneInGodowns.
  ///
  /// In en, this message translates to:
  /// **'None in the godowns now.'**
  String get stockNoneInGodowns;

  /// No description provided for @stockAtSites.
  ///
  /// In en, this message translates to:
  /// **'At sites'**
  String get stockAtSites;

  /// No description provided for @stockNotAtSites.
  ///
  /// In en, this message translates to:
  /// **'None at sites now.'**
  String get stockNotAtSites;

  /// No description provided for @stockLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get stockLatest;

  /// No description provided for @stockStaffUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s material use'**
  String get stockStaffUsageTitle;

  /// No description provided for @stockUsageRecorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get stockUsageRecorded;

  /// No description provided for @stockUsageNotRecorded.
  ///
  /// In en, this message translates to:
  /// **'Not recorded yet'**
  String get stockUsageNotRecorded;

  /// No description provided for @stockRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get stockRecord;

  /// No description provided for @stockLeftTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock is still at this site'**
  String get stockLeftTitle;

  /// No description provided for @stockLeftMore.
  ///
  /// In en, this message translates to:
  /// **'and {count} more'**
  String stockLeftMore(int count);

  /// No description provided for @stockLeftOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'Some stock is also on the way to or from this site.'**
  String get stockLeftOnTheWay;

  /// No description provided for @stockLeftBody.
  ///
  /// In en, this message translates to:
  /// **'Send it back to a godown from the site\'s Stock tab first, or complete the site now and deal with it later.'**
  String get stockLeftBody;

  /// No description provided for @stockLeftComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete anyway'**
  String get stockLeftComplete;

  /// No description provided for @godownNew.
  ///
  /// In en, this message translates to:
  /// **'New godown'**
  String get godownNew;

  /// No description provided for @godownEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit godown'**
  String get godownEdit;

  /// No description provided for @godownSaved.
  ///
  /// In en, this message translates to:
  /// **'Godown saved.'**
  String get godownSaved;

  /// No description provided for @godownName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get godownName;

  /// No description provided for @godownNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Main godown'**
  String get godownNameHint;

  /// No description provided for @godownAddress.
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get godownAddress;

  /// No description provided for @godownActive.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get godownActive;

  /// No description provided for @godownActiveHelper.
  ///
  /// In en, this message translates to:
  /// **'A closed godown takes no new stock. Its history stays. Move its stock out before closing it.'**
  String get godownActiveHelper;

  /// No description provided for @godownClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get godownClosed;

  /// No description provided for @materialNew.
  ///
  /// In en, this message translates to:
  /// **'New material'**
  String get materialNew;

  /// No description provided for @materialEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit material'**
  String get materialEdit;

  /// No description provided for @materialSaved.
  ///
  /// In en, this message translates to:
  /// **'Material saved.'**
  String get materialSaved;

  /// No description provided for @materialName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get materialName;

  /// No description provided for @materialNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cement OPC 53'**
  String get materialNameHint;

  /// No description provided for @materialUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get materialUnit;

  /// No description provided for @materialUnitHelper.
  ///
  /// In en, this message translates to:
  /// **'How it is counted. It can\'t change once stock is recorded.'**
  String get materialUnitHelper;

  /// No description provided for @materialCategory.
  ///
  /// In en, this message translates to:
  /// **'Category (optional)'**
  String get materialCategory;

  /// No description provided for @materialCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cement, Steel'**
  String get materialCategoryHint;

  /// No description provided for @materialMinimum.
  ///
  /// In en, this message translates to:
  /// **'Minimum in godowns (optional)'**
  String get materialMinimum;

  /// No description provided for @materialMinimumHelper.
  ///
  /// In en, this message translates to:
  /// **'Admins are alerted when all godowns together drop below this.'**
  String get materialMinimumHelper;

  /// No description provided for @materialActive.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get materialActive;

  /// No description provided for @materialActiveHelper.
  ///
  /// In en, this message translates to:
  /// **'Switched off, it can\'t be bought or sent from godowns. Its history stays.'**
  String get materialActiveHelper;

  /// No description provided for @materialInactive.
  ///
  /// In en, this message translates to:
  /// **'Not in use'**
  String get materialInactive;

  /// No description provided for @reportsStockOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening'**
  String get reportsStockOpening;

  /// No description provided for @reportsStockReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get reportsStockReceived;

  /// No description provided for @reportsStockUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get reportsStockUsed;

  /// No description provided for @reportsStockClosing.
  ///
  /// In en, this message translates to:
  /// **'Closing'**
  String get reportsStockClosing;

  /// No description provided for @reportsStockSentOut.
  ///
  /// In en, this message translates to:
  /// **'Sent out'**
  String get reportsStockSentOut;

  /// No description provided for @reportsStockWasted.
  ///
  /// In en, this message translates to:
  /// **'Wasted'**
  String get reportsStockWasted;

  /// No description provided for @reportsStockAdjusted.
  ///
  /// In en, this message translates to:
  /// **'Count corrections'**
  String get reportsStockAdjusted;

  /// No description provided for @reportsStockUsedValue.
  ///
  /// In en, this message translates to:
  /// **'Used value'**
  String get reportsStockUsedValue;

  /// No description provided for @roleGodownManager.
  ///
  /// In en, this message translates to:
  /// **'Godown manager'**
  String get roleGodownManager;

  /// No description provided for @navRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get navRequests;

  /// No description provided for @navStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get navStock;

  /// No description provided for @signUpLink.
  ///
  /// In en, this message translates to:
  /// **'Set up SiteWork (first admin)'**
  String get signUpLink;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up SiteWork'**
  String get signUpTitle;

  /// No description provided for @signUpIntro.
  ///
  /// In en, this message translates to:
  /// **'Create the first admin account. After this, admins add everyone else (engineers, staff, godown managers and other admins) from People.'**
  String get signUpIntro;

  /// No description provided for @signUpSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create admin account'**
  String get signUpSubmit;

  /// No description provided for @godownManagersTitle.
  ///
  /// In en, this message translates to:
  /// **'Godown managers'**
  String get godownManagersTitle;

  /// No description provided for @godownManagersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No godown managers yet.'**
  String get godownManagersEmpty;

  /// No description provided for @godownManagerNew.
  ///
  /// In en, this message translates to:
  /// **'New godown manager'**
  String get godownManagerNew;

  /// No description provided for @godownManagerEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit godown manager'**
  String get godownManagerEdit;

  /// No description provided for @adminsTitle.
  ///
  /// In en, this message translates to:
  /// **'Admins'**
  String get adminsTitle;

  /// No description provided for @adminsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No admins found.'**
  String get adminsEmpty;

  /// No description provided for @adminNew.
  ///
  /// In en, this message translates to:
  /// **'New admin'**
  String get adminNew;

  /// No description provided for @adminEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit admin'**
  String get adminEdit;

  /// No description provided for @personGodowns.
  ///
  /// In en, this message translates to:
  /// **'Godowns'**
  String get personGodowns;

  /// No description provided for @personGodownsHelper.
  ///
  /// In en, this message translates to:
  /// **'They buy stock in, send it to sites against approved requests, and confirm returns at these godowns.'**
  String get personGodownsHelper;

  /// No description provided for @personNoGodowns.
  ///
  /// In en, this message translates to:
  /// **'No godown yet'**
  String get personNoGodowns;

  /// No description provided for @godownManagedBy.
  ///
  /// In en, this message translates to:
  /// **'Managed by {names}'**
  String godownManagedBy(String names);

  /// No description provided for @godownNoManager.
  ///
  /// In en, this message translates to:
  /// **'No manager yet: admins confirm what arrives here.'**
  String get godownNoManager;

  /// No description provided for @godownsYours.
  ///
  /// In en, this message translates to:
  /// **'Your godowns'**
  String get godownsYours;

  /// No description provided for @stockReturnTo.
  ///
  /// In en, this message translates to:
  /// **'Return to'**
  String get stockReturnTo;

  /// No description provided for @stockSendSitesHint.
  ///
  /// In en, this message translates to:
  /// **'Sites get stock only against an approved material request: open the request to send it.'**
  String get stockSendSitesHint;

  /// No description provided for @stockNoGodownsManager.
  ///
  /// In en, this message translates to:
  /// **'No godown is assigned to you yet. Ask your admin.'**
  String get stockNoGodownsManager;

  /// No description provided for @stockReturnsToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Returns to confirm'**
  String get stockReturnsToConfirm;

  /// No description provided for @stockLowTitle.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get stockLowTitle;

  /// No description provided for @stockLowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All godowns together, below the minimum'**
  String get stockLowSubtitle;

  /// No description provided for @stockForRequest.
  ///
  /// In en, this message translates to:
  /// **'For {code}'**
  String stockForRequest(String code);

  /// No description provided for @requestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Material requests'**
  String get requestsTitle;

  /// No description provided for @requestTitle.
  ///
  /// In en, this message translates to:
  /// **'Material request'**
  String get requestTitle;

  /// No description provided for @requestsAdminSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Approve what sites ask for'**
  String get requestsAdminSubtitle;

  /// No description provided for @requestsEngineerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask for material for your sites'**
  String get requestsEngineerSubtitle;

  /// No description provided for @requestsToApproveCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 waiting for approval} other{{count} waiting for approval}}'**
  String requestsToApproveCount(int count);

  /// No description provided for @requestsToSend.
  ///
  /// In en, this message translates to:
  /// **'Requests to send'**
  String get requestsToSend;

  /// No description provided for @requestsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No material requests here.'**
  String get requestsEmpty;

  /// No description provided for @requestsEmptyManager.
  ///
  /// In en, this message translates to:
  /// **'Nothing to send. Approved requests for your godowns show up here.'**
  String get requestsEmptyManager;

  /// No description provided for @requestsOpenTitle.
  ///
  /// In en, this message translates to:
  /// **'Material requests'**
  String get requestsOpenTitle;

  /// No description provided for @requestsAll.
  ///
  /// In en, this message translates to:
  /// **'All requests'**
  String get requestsAll;

  /// No description provided for @requestsNoneOpen.
  ///
  /// In en, this message translates to:
  /// **'No open requests.'**
  String get requestsNoneOpen;

  /// No description provided for @requestFilterOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get requestFilterOpen;

  /// No description provided for @requestFilterApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get requestFilterApproved;

  /// No description provided for @requestStagePending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval'**
  String get requestStagePending;

  /// No description provided for @requestStageToSend.
  ///
  /// In en, this message translates to:
  /// **'Approved · to send'**
  String get requestStageToSend;

  /// No description provided for @requestStagePartSent.
  ///
  /// In en, this message translates to:
  /// **'Part sent'**
  String get requestStagePartSent;

  /// No description provided for @requestStageOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get requestStageOnTheWay;

  /// No description provided for @requestStageAtSite.
  ///
  /// In en, this message translates to:
  /// **'At site'**
  String get requestStageAtSite;

  /// No description provided for @requestStageRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get requestStageRejected;

  /// No description provided for @requestStageWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get requestStageWithdrawn;

  /// No description provided for @requestStageClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get requestStageClosed;

  /// No description provided for @requestAskedBy.
  ///
  /// In en, this message translates to:
  /// **'Asked by {name} · {date}'**
  String requestAskedBy(String name, String date);

  /// No description provided for @requestFromGodown.
  ///
  /// In en, this message translates to:
  /// **'From {godown}'**
  String requestFromGodown(String godown);

  /// No description provided for @requestNeededBy.
  ///
  /// In en, this message translates to:
  /// **'Needed by {date}'**
  String requestNeededBy(String date);

  /// No description provided for @requestSiteStock.
  ///
  /// In en, this message translates to:
  /// **'Site\'s stock'**
  String get requestSiteStock;

  /// No description provided for @requestMaterial.
  ///
  /// In en, this message translates to:
  /// **'Request material'**
  String get requestMaterial;

  /// No description provided for @requestNew.
  ///
  /// In en, this message translates to:
  /// **'New request'**
  String get requestNew;

  /// No description provided for @requestNeededByOptional.
  ///
  /// In en, this message translates to:
  /// **'Needed by (optional)'**
  String get requestNeededByOptional;

  /// No description provided for @requestQuantityNeeded.
  ///
  /// In en, this message translates to:
  /// **'Quantity needed'**
  String get requestQuantityNeeded;

  /// No description provided for @requestWhatFor.
  ///
  /// In en, this message translates to:
  /// **'What is it for? (optional)'**
  String get requestWhatFor;

  /// No description provided for @requestSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get requestSubmit;

  /// No description provided for @requestSent.
  ///
  /// In en, this message translates to:
  /// **'{code} sent for approval.'**
  String requestSent(String code);

  /// No description provided for @requestApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get requestApprove;

  /// No description provided for @requestApproveTitle.
  ///
  /// In en, this message translates to:
  /// **'Approve {code}'**
  String requestApproveTitle(String code);

  /// No description provided for @requestApproveIntro.
  ///
  /// In en, this message translates to:
  /// **'{site} asked for this ({name}). Choose the godown that sends it and how much of each material.'**
  String requestApproveIntro(String site, String name);

  /// No description provided for @requestSupplyFrom.
  ///
  /// In en, this message translates to:
  /// **'Send from godown'**
  String get requestSupplyFrom;

  /// No description provided for @requestApprovedQuantities.
  ///
  /// In en, this message translates to:
  /// **'Approved quantities'**
  String get requestApprovedQuantities;

  /// No description provided for @requestApproveZeroHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 0 for a material that won\'t be sent.'**
  String get requestApproveZeroHint;

  /// No description provided for @requestApprovedQuantity.
  ///
  /// In en, this message translates to:
  /// **'Approved quantity'**
  String get requestApprovedQuantity;

  /// No description provided for @requestInGodown.
  ///
  /// In en, this message translates to:
  /// **'In godown: {quantity}'**
  String requestInGodown(String quantity);

  /// No description provided for @requestNoteForSite.
  ///
  /// In en, this message translates to:
  /// **'Note for the site (optional)'**
  String get requestNoteForSite;

  /// No description provided for @requestApproveSomething.
  ///
  /// In en, this message translates to:
  /// **'Approve at least one material, or reject the request.'**
  String get requestApproveSomething;

  /// No description provided for @requestApproved.
  ///
  /// In en, this message translates to:
  /// **'{code} approved. The godown will send it.'**
  String requestApproved(String code);

  /// No description provided for @requestReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get requestReject;

  /// No description provided for @requestRejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject this request?'**
  String get requestRejectTitle;

  /// No description provided for @requestRejectReason.
  ///
  /// In en, this message translates to:
  /// **'Why? The site will see this.'**
  String get requestRejectReason;

  /// No description provided for @requestRejected.
  ///
  /// In en, this message translates to:
  /// **'{code} rejected.'**
  String requestRejected(String code);

  /// No description provided for @requestRejectedBecause.
  ///
  /// In en, this message translates to:
  /// **'Rejected by {name}: {reason}'**
  String requestRejectedBecause(String name, String reason);

  /// No description provided for @requestApprovedFrom.
  ///
  /// In en, this message translates to:
  /// **'Approved by {name} · sent from {godown}'**
  String requestApprovedFrom(String name, String godown);

  /// No description provided for @requestWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw request'**
  String get requestWithdraw;

  /// No description provided for @requestWithdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw {code}?'**
  String requestWithdrawTitle(String code);

  /// No description provided for @requestWithdrawBody.
  ///
  /// In en, this message translates to:
  /// **'It has not been approved yet. Withdrawing it means nothing will be sent.'**
  String get requestWithdrawBody;

  /// No description provided for @requestWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'{code} withdrawn.'**
  String requestWithdrawn(String code);

  /// No description provided for @requestSendNow.
  ///
  /// In en, this message translates to:
  /// **'Send material'**
  String get requestSendNow;

  /// No description provided for @requestSendTitle.
  ///
  /// In en, this message translates to:
  /// **'Send {code}'**
  String requestSendTitle(String code);

  /// No description provided for @requestDeliveries.
  ///
  /// In en, this message translates to:
  /// **'Deliveries and returns'**
  String get requestDeliveries;

  /// No description provided for @requestAsked.
  ///
  /// In en, this message translates to:
  /// **'Asked {quantity}'**
  String requestAsked(String quantity);

  /// No description provided for @requestNotSupplied.
  ///
  /// In en, this message translates to:
  /// **'Not supplied'**
  String get requestNotSupplied;

  /// No description provided for @requestSentAmount.
  ///
  /// In en, this message translates to:
  /// **'Sent {quantity}'**
  String requestSentAmount(String quantity);

  /// No description provided for @requestOnTheWayAmount.
  ///
  /// In en, this message translates to:
  /// **'{quantity} on the way'**
  String requestOnTheWayAmount(String quantity);

  /// No description provided for @requestArrivedAmount.
  ///
  /// In en, this message translates to:
  /// **'Arrived {quantity}'**
  String requestArrivedAmount(String quantity);

  /// No description provided for @requestLeftAmount.
  ///
  /// In en, this message translates to:
  /// **'{quantity} left to send'**
  String requestLeftAmount(String quantity);

  /// No description provided for @requestConfirmFirst.
  ///
  /// In en, this message translates to:
  /// **'Confirm the delivery on its way before closing this request.'**
  String get requestConfirmFirst;

  /// No description provided for @requestClose.
  ///
  /// In en, this message translates to:
  /// **'Close request'**
  String get requestClose;

  /// No description provided for @requestCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Close {code}'**
  String requestCloseTitle(String code);

  /// No description provided for @requestCloseIntro.
  ///
  /// In en, this message translates to:
  /// **'Is the work done? Say whether everything was used, or send what is left back to the godown.'**
  String get requestCloseIntro;

  /// No description provided for @requestOutcomeAllUsed.
  ///
  /// In en, this message translates to:
  /// **'All used'**
  String get requestOutcomeAllUsed;

  /// No description provided for @requestOutcomeReturn.
  ///
  /// In en, this message translates to:
  /// **'Return the leftover to {godown}'**
  String requestOutcomeReturn(String godown);

  /// No description provided for @requestGoingBack.
  ///
  /// In en, this message translates to:
  /// **'Going back'**
  String get requestGoingBack;

  /// No description provided for @requestNothingToReturn.
  ///
  /// In en, this message translates to:
  /// **'Nothing from this request is left at the site.'**
  String get requestNothingToReturn;

  /// No description provided for @requestReturnZeroHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 0 for anything staying at the site.'**
  String get requestReturnZeroHint;

  /// No description provided for @requestReturnSomething.
  ///
  /// In en, this message translates to:
  /// **'Enter what is going back, or choose \"All used\".'**
  String get requestReturnSomething;

  /// No description provided for @requestClosed.
  ///
  /// In en, this message translates to:
  /// **'{code} closed.'**
  String requestClosed(String code);

  /// No description provided for @requestClosedAllUsed.
  ///
  /// In en, this message translates to:
  /// **'Closed by {name}: all used.'**
  String requestClosedAllUsed(String name);

  /// No description provided for @requestClosedLeftover.
  ///
  /// In en, this message translates to:
  /// **'Closed by {name}: leftover sent back to the godown.'**
  String requestClosedLeftover(String name);

  /// No description provided for @attendanceOnLeave.
  ///
  /// In en, this message translates to:
  /// **'On leave'**
  String get attendanceOnLeave;

  /// No description provided for @requestsMyTitle.
  ///
  /// In en, this message translates to:
  /// **'My requests'**
  String get requestsMyTitle;

  /// No description provided for @requestsSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get requestsSeeAll;

  /// No description provided for @requestsTabLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get requestsTabLeave;

  /// No description provided for @requestsTabMoneyFood.
  ///
  /// In en, this message translates to:
  /// **'Money & food'**
  String get requestsTabMoneyFood;

  /// No description provided for @requestsTabMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get requestsTabMaterial;

  /// No description provided for @requestsNew.
  ///
  /// In en, this message translates to:
  /// **'New request'**
  String get requestsNew;

  /// No description provided for @requestsChooseKind.
  ///
  /// In en, this message translates to:
  /// **'What do you need?'**
  String get requestsChooseKind;

  /// No description provided for @requestKindLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get requestKindLeave;

  /// No description provided for @requestKindLeaveHint.
  ///
  /// In en, this message translates to:
  /// **'Days off work'**
  String get requestKindLeaveHint;

  /// No description provided for @requestKindMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get requestKindMoney;

  /// No description provided for @requestKindMoneyHint.
  ///
  /// In en, this message translates to:
  /// **'An advance on your wages'**
  String get requestKindMoneyHint;

  /// No description provided for @requestKindFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get requestKindFood;

  /// No description provided for @requestKindFoodHint.
  ///
  /// In en, this message translates to:
  /// **'A meal for yourself'**
  String get requestKindFoodHint;

  /// No description provided for @requestKindMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get requestKindMaterial;

  /// No description provided for @requestKindMaterialHint.
  ///
  /// In en, this message translates to:
  /// **'Material for your site'**
  String get requestKindMaterialHint;

  /// No description provided for @requestSendForApproval.
  ///
  /// In en, this message translates to:
  /// **'Send for approval'**
  String get requestSendForApproval;

  /// No description provided for @requestSentForApproval.
  ///
  /// In en, this message translates to:
  /// **'{code} sent for approval.'**
  String requestSentForApproval(String code);

  /// No description provided for @requestAskedByLabel.
  ///
  /// In en, this message translates to:
  /// **'Asked by'**
  String get requestAskedByLabel;

  /// No description provided for @requestAskedOn.
  ///
  /// In en, this message translates to:
  /// **'Asked on'**
  String get requestAskedOn;

  /// No description provided for @approvalPending.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get approvalPending;

  /// No description provided for @approvalApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approvalApproved;

  /// No description provided for @approvalRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get approvalRejected;

  /// No description provided for @approvalCancelled.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get approvalCancelled;

  /// No description provided for @approvalApprovedBy.
  ///
  /// In en, this message translates to:
  /// **'Approved by {name}'**
  String approvalApprovedBy(String name);

  /// No description provided for @approvalApprovedDone.
  ///
  /// In en, this message translates to:
  /// **'{code} approved.'**
  String approvalApprovedDone(String code);

  /// No description provided for @approvalWithdrawnNote.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn by the person who asked.'**
  String get approvalWithdrawnNote;

  /// No description provided for @approvalApproveTitle.
  ///
  /// In en, this message translates to:
  /// **'Approve {code}?'**
  String approvalApproveTitle(String code);

  /// No description provided for @approvalRejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject {code}?'**
  String approvalRejectTitle(String code);

  /// No description provided for @approvalRejectReason.
  ///
  /// In en, this message translates to:
  /// **'Why? The person who asked will see this.'**
  String get approvalRejectReason;

  /// No description provided for @approvalWithdrawBody.
  ///
  /// In en, this message translates to:
  /// **'No one will be able to approve it after this.'**
  String get approvalWithdrawBody;

  /// No description provided for @approvalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave & requests'**
  String get approvalsTitle;

  /// No description provided for @approvalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Leave, money and food to approve'**
  String get approvalsSubtitle;

  /// No description provided for @approvalsWaitingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} waiting for you'**
  String approvalsWaitingCount(int count);

  /// No description provided for @approvalsWaitingForYou.
  ///
  /// In en, this message translates to:
  /// **'Waiting for you'**
  String get approvalsWaitingForYou;

  /// No description provided for @approvalsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here.'**
  String get approvalsEmpty;

  /// No description provided for @myLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'My leave'**
  String get myLeaveTitle;

  /// No description provided for @leaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leaveTitle;

  /// No description provided for @leaveNewTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask for leave'**
  String get leaveNewTitle;

  /// No description provided for @leaveType.
  ///
  /// In en, this message translates to:
  /// **'Kind of leave'**
  String get leaveType;

  /// No description provided for @leaveTypeSick.
  ///
  /// In en, this message translates to:
  /// **'Sick'**
  String get leaveTypeSick;

  /// No description provided for @leaveTypeCasual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get leaveTypeCasual;

  /// No description provided for @leaveTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get leaveTypeOther;

  /// No description provided for @leaveFrom.
  ///
  /// In en, this message translates to:
  /// **'First day'**
  String get leaveFrom;

  /// No description provided for @leaveTo.
  ///
  /// In en, this message translates to:
  /// **'Last day'**
  String get leaveTo;

  /// No description provided for @leaveToBeforeFrom.
  ///
  /// In en, this message translates to:
  /// **'The last day can\'t be before the first day.'**
  String get leaveToBeforeFrom;

  /// No description provided for @leaveReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get leaveReason;

  /// No description provided for @leaveWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get leaveWhen;

  /// No description provided for @leaveDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String leaveDays(int count);

  /// No description provided for @leaveEmpty.
  ///
  /// In en, this message translates to:
  /// **'No leave asked for yet.'**
  String get leaveEmpty;

  /// No description provided for @staffRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get staffRequestTitle;

  /// No description provided for @staffRequestsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No money or food asked for yet.'**
  String get staffRequestsEmpty;

  /// No description provided for @moneyNewTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask for money'**
  String get moneyNewTitle;

  /// No description provided for @moneyAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get moneyAmount;

  /// No description provided for @moneyAmountHelper.
  ///
  /// In en, this message translates to:
  /// **'An advance on your wages'**
  String get moneyAmountHelper;

  /// No description provided for @moneyAdvance.
  ///
  /// In en, this message translates to:
  /// **'{amount} advance'**
  String moneyAdvance(String amount);

  /// No description provided for @foodNewTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask for food'**
  String get foodNewTitle;

  /// No description provided for @foodDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get foodDay;

  /// No description provided for @foodMeal.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get foodMeal;

  /// No description provided for @foodMealOn.
  ///
  /// In en, this message translates to:
  /// **'{meal} on {date}'**
  String foodMealOn(String meal, String date);

  /// No description provided for @mealBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get mealBreakfast;

  /// No description provided for @mealLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get mealLunch;

  /// No description provided for @mealDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get mealDinner;

  /// No description provided for @vehiclesTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehiclesTitle;

  /// No description provided for @vehiclesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Company bikes and who has them'**
  String get vehiclesSubtitle;

  /// No description provided for @vehiclesRepairWaiting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 repair request waiting} other{{count} repair requests waiting}}'**
  String vehiclesRepairWaiting(int count);

  /// No description provided for @vehiclesSearch.
  ///
  /// In en, this message translates to:
  /// **'Search vehicle or person'**
  String get vehiclesSearch;

  /// No description provided for @vehiclesFilterGiven.
  ///
  /// In en, this message translates to:
  /// **'Given'**
  String get vehiclesFilterGiven;

  /// No description provided for @vehiclesFilterFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get vehiclesFilterFree;

  /// No description provided for @vehiclesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No vehicles here.'**
  String get vehiclesEmpty;

  /// No description provided for @vehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleTitle;

  /// No description provided for @vehicleNewTitle.
  ///
  /// In en, this message translates to:
  /// **'Add vehicle'**
  String get vehicleNewTitle;

  /// No description provided for @vehicleEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit vehicle'**
  String get vehicleEditTitle;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Kind of vehicle'**
  String get vehicleType;

  /// No description provided for @vehicleTypeBike.
  ///
  /// In en, this message translates to:
  /// **'Bike'**
  String get vehicleTypeBike;

  /// No description provided for @vehicleTypeScooter.
  ///
  /// In en, this message translates to:
  /// **'Scooter'**
  String get vehicleTypeScooter;

  /// No description provided for @vehicleTypeCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get vehicleTypeCar;

  /// No description provided for @vehicleTypeVan.
  ///
  /// In en, this message translates to:
  /// **'Van'**
  String get vehicleTypeVan;

  /// No description provided for @vehicleTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get vehicleTypeOther;

  /// No description provided for @vehicleRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration number'**
  String get vehicleRegistration;

  /// No description provided for @vehicleRegistrationHelper.
  ///
  /// In en, this message translates to:
  /// **'As on the number plate'**
  String get vehicleRegistrationHelper;

  /// No description provided for @vehicleMakeModel.
  ///
  /// In en, this message translates to:
  /// **'Make and model'**
  String get vehicleMakeModel;

  /// No description provided for @vehicleMakeModelHelper.
  ///
  /// In en, this message translates to:
  /// **'For example, Hero Splendor Plus'**
  String get vehicleMakeModelHelper;

  /// No description provided for @vehicleSave.
  ///
  /// In en, this message translates to:
  /// **'Save vehicle'**
  String get vehicleSave;

  /// No description provided for @vehicleSaved.
  ///
  /// In en, this message translates to:
  /// **'{code} saved'**
  String vehicleSaved(String code);

  /// No description provided for @vehicleWith.
  ///
  /// In en, this message translates to:
  /// **'With {name}'**
  String vehicleWith(String name);

  /// No description provided for @vehicleFree.
  ///
  /// In en, this message translates to:
  /// **'With nobody'**
  String get vehicleFree;

  /// No description provided for @vehicleOutOfUse.
  ///
  /// In en, this message translates to:
  /// **'Out of use'**
  String get vehicleOutOfUse;

  /// No description provided for @vehicleHolder.
  ///
  /// In en, this message translates to:
  /// **'With'**
  String get vehicleHolder;

  /// No description provided for @vehicleSince.
  ///
  /// In en, this message translates to:
  /// **'Since {date}'**
  String vehicleSince(String date);

  /// No description provided for @vehicleGive.
  ///
  /// In en, this message translates to:
  /// **'Give to someone'**
  String get vehicleGive;

  /// No description provided for @vehicleGiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Give {vehicle}'**
  String vehicleGiveTitle(String vehicle);

  /// No description provided for @vehicleGiveToTitle.
  ///
  /// In en, this message translates to:
  /// **'Give a vehicle to {name}'**
  String vehicleGiveToTitle(String name);

  /// No description provided for @vehicleGiveTo.
  ///
  /// In en, this message translates to:
  /// **'Give to'**
  String get vehicleGiveTo;

  /// No description provided for @vehicleChoose.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleChoose;

  /// No description provided for @vehicleGivenOn.
  ///
  /// In en, this message translates to:
  /// **'Given on'**
  String get vehicleGivenOn;

  /// No description provided for @vehicleNoFree.
  ///
  /// In en, this message translates to:
  /// **'No free vehicle. Add one, or take one back first.'**
  String get vehicleNoFree;

  /// No description provided for @vehicleGiveSave.
  ///
  /// In en, this message translates to:
  /// **'Give vehicle'**
  String get vehicleGiveSave;

  /// No description provided for @vehicleGivenTo.
  ///
  /// In en, this message translates to:
  /// **'{vehicle} given to {name}'**
  String vehicleGivenTo(String vehicle, String name);

  /// No description provided for @vehicleTakeBack.
  ///
  /// In en, this message translates to:
  /// **'Take back'**
  String get vehicleTakeBack;

  /// No description provided for @vehicleTakeBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Take back {vehicle}'**
  String vehicleTakeBackTitle(String vehicle);

  /// No description provided for @vehicleTakeBackFrom.
  ///
  /// In en, this message translates to:
  /// **'From {name}'**
  String vehicleTakeBackFrom(String name);

  /// No description provided for @vehicleReturnedOn.
  ///
  /// In en, this message translates to:
  /// **'Came back on'**
  String get vehicleReturnedOn;

  /// No description provided for @vehicleTakenBack.
  ///
  /// In en, this message translates to:
  /// **'{vehicle} taken back'**
  String vehicleTakenBack(String vehicle);

  /// No description provided for @vehicleHistory.
  ///
  /// In en, this message translates to:
  /// **'Who had it'**
  String get vehicleHistory;

  /// No description provided for @vehicleHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Not given to anyone yet.'**
  String get vehicleHistoryEmpty;

  /// No description provided for @vehicleHistoryRange.
  ///
  /// In en, this message translates to:
  /// **'{from} – {to}'**
  String vehicleHistoryRange(String from, String to);

  /// No description provided for @vehicleHistoryNow.
  ///
  /// In en, this message translates to:
  /// **'{from} – now'**
  String vehicleHistoryNow(String from);

  /// No description provided for @vehicleMarkOutOfUse.
  ///
  /// In en, this message translates to:
  /// **'Mark out of use'**
  String get vehicleMarkOutOfUse;

  /// No description provided for @vehicleMarkOutOfUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark {vehicle} out of use?'**
  String vehicleMarkOutOfUseTitle(String vehicle);

  /// No description provided for @vehicleMarkOutOfUseBody.
  ///
  /// In en, this message translates to:
  /// **'It can no longer be given to anyone. Its history is kept.'**
  String get vehicleMarkOutOfUseBody;

  /// No description provided for @vehicleBringBack.
  ///
  /// In en, this message translates to:
  /// **'Bring back into use'**
  String get vehicleBringBack;

  /// No description provided for @vehicleMarkedOutOfUse.
  ///
  /// In en, this message translates to:
  /// **'{vehicle} is out of use'**
  String vehicleMarkedOutOfUse(String vehicle);

  /// No description provided for @vehicleBackInUse.
  ///
  /// In en, this message translates to:
  /// **'{vehicle} is back in use'**
  String vehicleBackInUse(String vehicle);

  /// No description provided for @vehicleRepairs.
  ///
  /// In en, this message translates to:
  /// **'Repair money'**
  String get vehicleRepairs;

  /// No description provided for @vehicleRepairsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No repair money asked for.'**
  String get vehicleRepairsEmpty;

  /// No description provided for @myVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'My vehicle'**
  String get myVehicleTitle;

  /// No description provided for @repairTitle.
  ///
  /// In en, this message translates to:
  /// **'Repair money'**
  String get repairTitle;

  /// No description provided for @repairAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask for repair money'**
  String get repairAsk;

  /// No description provided for @repairAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get repairAmount;

  /// No description provided for @repairAmountHelper.
  ///
  /// In en, this message translates to:
  /// **'What the repair will cost'**
  String get repairAmountHelper;

  /// No description provided for @repairWhat.
  ///
  /// In en, this message translates to:
  /// **'What needs repair?'**
  String get repairWhat;

  /// No description provided for @repairMoney.
  ///
  /// In en, this message translates to:
  /// **'{amount} for repair'**
  String repairMoney(String amount);

  /// No description provided for @repairMine.
  ///
  /// In en, this message translates to:
  /// **'My repair requests'**
  String get repairMine;

  /// No description provided for @repairNoVehicle.
  ///
  /// In en, this message translates to:
  /// **'You do not have a company vehicle now.'**
  String get repairNoVehicle;

  /// No description provided for @requestsTabRepair.
  ///
  /// In en, this message translates to:
  /// **'Bike repair'**
  String get requestsTabRepair;

  /// No description provided for @requestKindRepair.
  ///
  /// In en, this message translates to:
  /// **'Bike repair'**
  String get requestKindRepair;

  /// No description provided for @requestKindRepairHint.
  ///
  /// In en, this message translates to:
  /// **'Money to repair your company vehicle'**
  String get requestKindRepairHint;

  /// No description provided for @personVehicle.
  ///
  /// In en, this message translates to:
  /// **'Company vehicle'**
  String get personVehicle;

  /// No description provided for @personNoVehicle.
  ///
  /// In en, this message translates to:
  /// **'No company vehicle'**
  String get personNoVehicle;

  /// No description provided for @personGiveVehicle.
  ///
  /// In en, this message translates to:
  /// **'Give a vehicle'**
  String get personGiveVehicle;

  /// No description provided for @approvalsSubtitleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Leave, money, food and bike repair to approve'**
  String get approvalsSubtitleAdmin;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
