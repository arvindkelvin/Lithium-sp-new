import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
    Locale('mr'),
    Locale('ta'),
    Locale('te')
  ];

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @your_ID.
  ///
  /// In en, this message translates to:
  /// **'Your ID'**
  String get your_ID;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @yourPassword.
  ///
  /// In en, this message translates to:
  /// **'Your Password'**
  String get yourPassword;

  /// No description provided for @forgot_Password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgot_Password;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get sign_in;

  /// No description provided for @enter_registered_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter registered phone number'**
  String get enter_registered_phone_number;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @please_use_your_fingerprint_to_login_as.
  ///
  /// In en, this message translates to:
  /// **'Please use your fingerprint to login as'**
  String get please_use_your_fingerprint_to_login_as;

  /// No description provided for @login_using_Biometric_Authentication.
  ///
  /// In en, this message translates to:
  /// **'Login using Biometric Authentication'**
  String get login_using_Biometric_Authentication;

  /// No description provided for @touch_the_fingerprint_sensor.
  ///
  /// In en, this message translates to:
  /// **'Touch the fingerprint sensor'**
  String get touch_the_fingerprint_sensor;

  /// No description provided for @apply_EOS.
  ///
  /// In en, this message translates to:
  /// **'Apply EOS'**
  String get apply_EOS;

  /// No description provided for @cancel_EOS.
  ///
  /// In en, this message translates to:
  /// **'Cancel EOS'**
  String get cancel_EOS;

  /// No description provided for @extra_Trip.
  ///
  /// In en, this message translates to:
  /// **'Extra Hours'**
  String get extra_Trip;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @fee_Invoices.
  ///
  /// In en, this message translates to:
  /// **'Fee Invoices'**
  String get fee_Invoices;

  /// No description provided for @refer_a_Friend.
  ///
  /// In en, this message translates to:
  /// **'Refer a Friend'**
  String get refer_a_Friend;

  /// No description provided for @grievance_List.
  ///
  /// In en, this message translates to:
  /// **'Grievance List'**
  String get grievance_List;

  /// No description provided for @extra_hours_List.
  ///
  /// In en, this message translates to:
  /// **'Extra hours list'**
  String get extra_hours_List;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @family_emergency.
  ///
  /// In en, this message translates to:
  /// **'Family Emergency'**
  String get family_emergency;

  /// No description provided for @festival.
  ///
  /// In en, this message translates to:
  /// **'Festival'**
  String get festival;

  /// No description provided for @personal_Reasons.
  ///
  /// In en, this message translates to:
  /// **'Personal Reasons'**
  String get personal_Reasons;

  /// No description provided for @areyousurewanttocancelthis.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to cancel this ?'**
  String get areyousurewanttocancelthis;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @trip_Date.
  ///
  /// In en, this message translates to:
  /// **'Trip Date'**
  String get trip_Date;

  /// No description provided for @trip_Id.
  ///
  /// In en, this message translates to:
  /// **'Trip Id'**
  String get trip_Id;

  /// No description provided for @trip_Id_select.
  ///
  /// In en, this message translates to:
  /// **'Enter Trip Id'**
  String get trip_Id_select;

  /// No description provided for @trip_StartTime.
  ///
  /// In en, this message translates to:
  /// **'Trip Start Time'**
  String get trip_StartTime;

  /// No description provided for @trip_endtime.
  ///
  /// In en, this message translates to:
  /// **'Trip End Time'**
  String get trip_endtime;

  /// No description provided for @shift_StartTime.
  ///
  /// In en, this message translates to:
  /// **'Shift Start Time'**
  String get shift_StartTime;

  /// No description provided for @shift_EndTime.
  ///
  /// In en, this message translates to:
  /// **'Shift End Time'**
  String get shift_EndTime;

  /// No description provided for @extra_Hours.
  ///
  /// In en, this message translates to:
  /// **'Extra Hours'**
  String get extra_Hours;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @upload_Attachments.
  ///
  /// In en, this message translates to:
  /// **'Upload Attachments'**
  String get upload_Attachments;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year & Month'**
  String get year;

  /// No description provided for @select_Year.
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get select_Year;

  /// No description provided for @pay_Cycle.
  ///
  /// In en, this message translates to:
  /// **'Pay Cycle'**
  String get pay_Cycle;

  /// No description provided for @select_Pay_Cycle.
  ///
  /// In en, this message translates to:
  /// **'Select Pay Cycle'**
  String get select_Pay_Cycle;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @invoice_amount.
  ///
  /// In en, this message translates to:
  /// **'Invoice Amount'**
  String get invoice_amount;

  /// No description provided for @rental_charges.
  ///
  /// In en, this message translates to:
  /// **'Rental Charges'**
  String get rental_charges;

  /// No description provided for @customerSLAComplianceDetails.
  ///
  /// In en, this message translates to:
  /// **'Customer SLA & Compliance Details'**
  String get customerSLAComplianceDetails;

  /// No description provided for @otherrecoveriesvehicleDamagesSecurityDepositAdvances.
  ///
  /// In en, this message translates to:
  /// **'Other Recoveries(vehicle Damages,Security Deposit,Advances)'**
  String get otherrecoveriesvehicleDamagesSecurityDepositAdvances;

  /// No description provided for @tds.
  ///
  /// In en, this message translates to:
  /// **'TDS'**
  String get tds;

  /// No description provided for @netAmount_Paid.
  ///
  /// In en, this message translates to:
  /// **'Net Amount Paid'**
  String get netAmount_Paid;

  /// No description provided for @referaFriendandearnwhenhejoins.
  ///
  /// In en, this message translates to:
  /// **'Refer a Friend and earn Rs.200 when he joins'**
  String get referaFriendandearnwhenhejoins;

  /// No description provided for @refer.
  ///
  /// In en, this message translates to:
  /// **'Refer'**
  String get refer;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @qRcode.
  ///
  /// In en, this message translates to:
  /// **'QR code'**
  String get qRcode;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @useBiometric.
  ///
  /// In en, this message translates to:
  /// **'Use Biometric'**
  String get useBiometric;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @checkInOutDetails.
  ///
  /// In en, this message translates to:
  /// **'Check In/Out Details'**
  String get checkInOutDetails;

  /// No description provided for @rosterStartTime.
  ///
  /// In en, this message translates to:
  /// **'Roster Start Time'**
  String get rosterStartTime;

  /// No description provided for @checkintime.
  ///
  /// In en, this message translates to:
  /// **'Check In Time'**
  String get checkintime;

  /// No description provided for @checkouttime.
  ///
  /// In en, this message translates to:
  /// **'Check Out Time'**
  String get checkouttime;

  /// No description provided for @rosterendTime.
  ///
  /// In en, this message translates to:
  /// **'Roster End Time'**
  String get rosterendTime;

  /// No description provided for @lateLeaveDetails.
  ///
  /// In en, this message translates to:
  /// **'Late & Leave Details'**
  String get lateLeaveDetails;

  /// No description provided for @late.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get late;

  /// No description provided for @eOS.
  ///
  /// In en, this message translates to:
  /// **'EOS'**
  String get eOS;

  /// No description provided for @uEOS.
  ///
  /// In en, this message translates to:
  /// **'UEOS'**
  String get uEOS;

  /// No description provided for @wEOS.
  ///
  /// In en, this message translates to:
  /// **'WEOS'**
  String get wEOS;

  /// No description provided for @tRIPBench.
  ///
  /// In en, this message translates to:
  /// **'TRIP/Bench'**
  String get tRIPBench;

  /// No description provided for @tripcount.
  ///
  /// In en, this message translates to:
  /// **'Trip Count'**
  String get tripcount;

  /// No description provided for @debitrecovery.
  ///
  /// In en, this message translates to:
  /// **'Debit/Recovery'**
  String get debitrecovery;

  /// No description provided for @debitdetails.
  ///
  /// In en, this message translates to:
  /// **'Debit Details'**
  String get debitdetails;

  /// No description provided for @todayEarnings.
  ///
  /// In en, this message translates to:
  /// **'Today Earnings'**
  String get todayEarnings;

  /// No description provided for @subcategory.
  ///
  /// In en, this message translates to:
  /// **'Subcategory'**
  String get subcategory;

  /// No description provided for @nooftrips.
  ///
  /// In en, this message translates to:
  /// **'No of Trips'**
  String get nooftrips;

  /// No description provided for @monthYear.
  ///
  /// In en, this message translates to:
  /// **'Month & Year'**
  String get monthYear;

  /// No description provided for @totalNoofServiceDays.
  ///
  /// In en, this message translates to:
  /// **'Total No of Service Days'**
  String get totalNoofServiceDays;

  /// No description provided for @totalNoofBenchDays.
  ///
  /// In en, this message translates to:
  /// **'Total No of Bench Days'**
  String get totalNoofBenchDays;

  /// No description provided for @totalNoofcontinuousDays.
  ///
  /// In en, this message translates to:
  /// **'Total No of continuous Days'**
  String get totalNoofcontinuousDays;

  /// No description provided for @totalNoofTrainingDays.
  ///
  /// In en, this message translates to:
  /// **'Total No of Training Days'**
  String get totalNoofTrainingDays;

  /// No description provided for @totalNoofEosDays.
  ///
  /// In en, this message translates to:
  /// **'Total No of Eos Days'**
  String get totalNoofEosDays;

  /// No description provided for @totalNoofExtraHoursDays.
  ///
  /// In en, this message translates to:
  /// **'Total No of Extra Hours Days'**
  String get totalNoofExtraHoursDays;

  /// No description provided for @conveyance.
  ///
  /// In en, this message translates to:
  /// **'Conveyance'**
  String get conveyance;

  /// No description provided for @serviceDaysattendanceBouns.
  ///
  /// In en, this message translates to:
  /// **'Service Days attendance Bouns'**
  String get serviceDaysattendanceBouns;

  /// No description provided for @totalNoofUEOSDays.
  ///
  /// In en, this message translates to:
  /// **'Total No of UEOS Days'**
  String get totalNoofUEOSDays;

  /// No description provided for @totalNoofLateDays.
  ///
  /// In en, this message translates to:
  /// **'Total No of Late Days'**
  String get totalNoofLateDays;

  /// No description provided for @campusDebit.
  ///
  /// In en, this message translates to:
  /// **'Campus Debit'**
  String get campusDebit;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @advanceRecovery.
  ///
  /// In en, this message translates to:
  /// **'Advance Recovery'**
  String get advanceRecovery;

  /// No description provided for @accidentrecovery.
  ///
  /// In en, this message translates to:
  /// **'Accident Recovery'**
  String get accidentrecovery;

  /// No description provided for @payCycleMaster.
  ///
  /// In en, this message translates to:
  /// **'Pay Cycle Master'**
  String get payCycleMaster;

  /// No description provided for @referralBonus.
  ///
  /// In en, this message translates to:
  /// **'Referral Bonus'**
  String get referralBonus;

  /// No description provided for @arrears.
  ///
  /// In en, this message translates to:
  /// **'Arrears'**
  String get arrears;

  /// No description provided for @award.
  ///
  /// In en, this message translates to:
  /// **'Award'**
  String get award;

  /// No description provided for @welfare.
  ///
  /// In en, this message translates to:
  /// **'Welfare'**
  String get welfare;

  /// No description provided for @festivalbonus.
  ///
  /// In en, this message translates to:
  /// **'Festival Bonus'**
  String get festivalbonus;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @netpayable.
  ///
  /// In en, this message translates to:
  /// **'Net Payable'**
  String get netpayable;

  /// No description provided for @serviceProvidedDays.
  ///
  /// In en, this message translates to:
  /// **'Service Provided Days'**
  String get serviceProvidedDays;

  /// No description provided for @bench.
  ///
  /// In en, this message translates to:
  /// **'Bench'**
  String get bench;

  /// No description provided for @additionalShift.
  ///
  /// In en, this message translates to:
  /// **'Additional Shift'**
  String get additionalShift;

  /// No description provided for @training.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get training;

  /// No description provided for @totalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get totalEarnings;

  /// No description provided for @applyforEOS.
  ///
  /// In en, this message translates to:
  /// **'Apply for EOS'**
  String get applyforEOS;

  /// No description provided for @lasteos.
  ///
  /// In en, this message translates to:
  /// **'Last 5 EOS Transactions'**
  String get lasteos;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @viewmore.
  ///
  /// In en, this message translates to:
  /// **'View More'**
  String get viewmore;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @areyousureyouwanttologout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout ?'**
  String get areyousureyouwanttologout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @plannedtrips.
  ///
  /// In en, this message translates to:
  /// **'Planned Trips For Today'**
  String get plannedtrips;

  /// No description provided for @engagementofficerremarks.
  ///
  /// In en, this message translates to:
  /// **'Engagement Officer Remarks'**
  String get engagementofficerremarks;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectmonth.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get selectmonth;

  /// No description provided for @selectweek.
  ///
  /// In en, this message translates to:
  /// **'Select Week'**
  String get selectweek;

  /// No description provided for @totalTripsPerformed.
  ///
  /// In en, this message translates to:
  /// **'Total No of Trips Performed'**
  String get totalTripsPerformed;

  /// No description provided for @servicedaydetails.
  ///
  /// In en, this message translates to:
  /// **'Service Days Details'**
  String get servicedaydetails;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @additionsdeletions.
  ///
  /// In en, this message translates to:
  /// **'Additions/Deletions'**
  String get additionsdeletions;

  /// No description provided for @debitdata.
  ///
  /// In en, this message translates to:
  /// **'Debit Data'**
  String get debitdata;

  /// No description provided for @biometricauthentication.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricauthentication;

  /// No description provided for @refersenone.
  ///
  /// In en, this message translates to:
  /// **'Refer a Friend and earn Rs.'**
  String get refersenone;

  /// No description provided for @refersentwo.
  ///
  /// In en, this message translates to:
  /// **'When he joins'**
  String get refersentwo;

  /// No description provided for @driversrefered.
  ///
  /// In en, this message translates to:
  /// **' Drivers Referred'**
  String get driversrefered;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @driversdetails.
  ///
  /// In en, this message translates to:
  /// **'Drivers Details'**
  String get driversdetails;

  /// No description provided for @mobilenumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobilenumber;

  /// No description provided for @phonenumberverify.
  ///
  /// In en, this message translates to:
  /// **'Phone Number Verification'**
  String get phonenumberverify;

  /// No description provided for @entercode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to'**
  String get entercode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languagecode.
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get languagecode;

  /// No description provided for @maxfilesize.
  ///
  /// In en, this message translates to:
  /// **'Maximum File Size Exceeds,Please Select a File Less Than 500kb'**
  String get maxfilesize;

  /// No description provided for @entervaildtrip.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Valid No of Trip'**
  String get entervaildtrip;

  /// No description provided for @pleaseslectroster.
  ///
  /// In en, this message translates to:
  /// **'Please Select Reason'**
  String get pleaseslectroster;

  /// No description provided for @selectdropdown.
  ///
  /// In en, this message translates to:
  /// **'Please Select Dropdown'**
  String get selectdropdown;

  /// No description provided for @selectfromdate.
  ///
  /// In en, this message translates to:
  /// **'Please Select From Date'**
  String get selectfromdate;

  /// No description provided for @selecttodate.
  ///
  /// In en, this message translates to:
  /// **'Please Select To Date'**
  String get selecttodate;

  /// No description provided for @selectreason.
  ///
  /// In en, this message translates to:
  /// **'Please Select Reason'**
  String get selectreason;

  /// No description provided for @somethingwentwrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong please try again'**
  String get somethingwentwrong;

  /// No description provided for @selectstartdate.
  ///
  /// In en, this message translates to:
  /// **'Please Select Start Date'**
  String get selectstartdate;

  /// No description provided for @selectstarttime.
  ///
  /// In en, this message translates to:
  /// **'Please Select Start Time'**
  String get selectstarttime;

  /// No description provided for @selectenddate.
  ///
  /// In en, this message translates to:
  /// **'Please Select End Date'**
  String get selectenddate;

  /// No description provided for @selectendtime.
  ///
  /// In en, this message translates to:
  /// **'Please Select End Time'**
  String get selectendtime;

  /// No description provided for @idorfile.
  ///
  /// In en, this message translates to:
  /// **'please enter trip id or upload file'**
  String get idorfile;

  /// No description provided for @selecttripdate.
  ///
  /// In en, this message translates to:
  /// **'Please Select Trip Date'**
  String get selecttripdate;

  /// No description provided for @pleaseentername.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Name'**
  String get pleaseentername;

  /// No description provided for @pleaseentermobilenumber.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Mobile'**
  String get pleaseentermobilenumber;

  /// No description provided for @pleasecheckinternetconnection.
  ///
  /// In en, this message translates to:
  /// **'Please Check Your Internet Connection'**
  String get pleasecheckinternetconnection;

  /// No description provided for @pleaseenterconfirmpassword.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Confirm Password'**
  String get pleaseenterconfirmpassword;

  /// No description provided for @pleaseenternewpassword.
  ///
  /// In en, this message translates to:
  /// **'Please Enter New Password'**
  String get pleaseenternewpassword;

  /// No description provided for @pleaseentervaildotp.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Valid OTP'**
  String get pleaseentervaildotp;

  /// No description provided for @pleaseclickback.
  ///
  /// In en, this message translates to:
  /// **'Please Click Back Again to exit'**
  String get pleaseclickback;

  /// No description provided for @enter_vaildphone.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Valid Phone Numbers'**
  String get enter_vaildphone;

  /// No description provided for @logoinsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Login Successfully'**
  String get logoinsuccessfully;

  /// No description provided for @employeeidpassword.
  ///
  /// In en, this message translates to:
  /// **'Please Enter EMPLOYEE ID & PASSWORD'**
  String get employeeidpassword;

  /// No description provided for @logoutsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Logout Successfully '**
  String get logoutsuccessfully;

  /// No description provided for @pleaseenterpassword.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Password'**
  String get pleaseenterpassword;

  /// No description provided for @passwordnotmatch.
  ///
  /// In en, this message translates to:
  /// **'New Password & Confirm Password Doesn\'t Match '**
  String get passwordnotmatch;

  /// No description provided for @pleaseenablefingerprint.
  ///
  /// In en, this message translates to:
  /// **'Please Enable Fingerprint'**
  String get pleaseenablefingerprint;

  /// No description provided for @pleaseenteroldpassword.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Old Password'**
  String get pleaseenteroldpassword;

  /// No description provided for @trip_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get trip_amount;

  /// No description provided for @total_extra_hours.
  ///
  /// In en, this message translates to:
  /// **'Total Extra Hours'**
  String get total_extra_hours;

  /// No description provided for @help_Line_Number.
  ///
  /// In en, this message translates to:
  /// **'Helpline Number'**
  String get help_Line_Number;

  /// No description provided for @sp_payment_name.
  ///
  /// In en, this message translates to:
  /// **'SP Payment Name'**
  String get sp_payment_name;

  /// No description provided for @sp_payment_start_date.
  ///
  /// In en, this message translates to:
  /// **'SP Payment Start Date'**
  String get sp_payment_start_date;

  /// No description provided for @sp_payment_end_date.
  ///
  /// In en, this message translates to:
  /// **'SP Payment End Date'**
  String get sp_payment_end_date;

  /// No description provided for @total_paid_duty_days.
  ///
  /// In en, this message translates to:
  /// **'Total Present'**
  String get total_paid_duty_days;

  /// No description provided for @training_days.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get training_days;

  /// No description provided for @weos.
  ///
  /// In en, this message translates to:
  /// **'No of WEOS Days'**
  String get weos;

  /// No description provided for @number_of_Extra_Hours.
  ///
  /// In en, this message translates to:
  /// **'Number of Extra Hours'**
  String get number_of_Extra_Hours;

  /// No description provided for @service_days_bonus.
  ///
  /// In en, this message translates to:
  /// **'Service Day Bonus'**
  String get service_days_bonus;

  /// No description provided for @trip_incentive.
  ///
  /// In en, this message translates to:
  /// **'Trip Incentive'**
  String get trip_incentive;

  /// No description provided for @no_of_over_speed.
  ///
  /// In en, this message translates to:
  /// **'No Over Speed Incentive'**
  String get no_of_over_speed;

  /// No description provided for @quarterly_incentive.
  ///
  /// In en, this message translates to:
  /// **'Quarterly Incentive'**
  String get quarterly_incentive;

  /// No description provided for @joining_bonus.
  ///
  /// In en, this message translates to:
  /// **'Joining Bonus'**
  String get joining_bonus;

  /// No description provided for @convenyenace.
  ///
  /// In en, this message translates to:
  /// **'convenyenace'**
  String get convenyenace;

  /// No description provided for @loyalty_bonus.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Bonus'**
  String get loyalty_bonus;

  /// No description provided for @awards.
  ///
  /// In en, this message translates to:
  /// **'Awards'**
  String get awards;

  /// No description provided for @arrear.
  ///
  /// In en, this message translates to:
  /// **'Arrear'**
  String get arrear;

  /// No description provided for @campus_debit_note.
  ///
  /// In en, this message translates to:
  /// **'Campus Debit Note'**
  String get campus_debit_note;

  /// No description provided for @advance_recovery.
  ///
  /// In en, this message translates to:
  /// **'Advance Recovery (Current Month)'**
  String get advance_recovery;

  /// No description provided for @accident_recovery.
  ///
  /// In en, this message translates to:
  /// **'Accident Recovery (Current Month)'**
  String get accident_recovery;

  /// No description provided for @pvc_recovered.
  ///
  /// In en, this message translates to:
  /// **'PVC (Current Month)'**
  String get pvc_recovered;

  /// No description provided for @vehicle_charge.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Charge'**
  String get vehicle_charge;

  /// No description provided for @trip_penalty.
  ///
  /// In en, this message translates to:
  /// **'Trip Penalty'**
  String get trip_penalty;

  /// No description provided for @pg_amount.
  ///
  /// In en, this message translates to:
  /// **'PG Amount'**
  String get pg_amount;

  /// No description provided for @karmalife_advance_withdrawal.
  ///
  /// In en, this message translates to:
  /// **'KarmaLife Advance Withdrawal'**
  String get karmalife_advance_withdrawal;

  /// No description provided for @karmalife_advance_withdrawal_subscript.
  ///
  /// In en, this message translates to:
  /// **'KarmaLife Subscription Fee'**
  String get karmalife_advance_withdrawal_subscript;

  /// No description provided for @uber_vehicle_charge.
  ///
  /// In en, this message translates to:
  /// **'Uber - Vehicle Charge'**
  String get uber_vehicle_charge;

  /// No description provided for @uber_balance_pay_out.
  ///
  /// In en, this message translates to:
  /// **'Uber - Balance Pay Out'**
  String get uber_balance_pay_out;

  /// No description provided for @over_speed.
  ///
  /// In en, this message translates to:
  /// **'Over Speed'**
  String get over_speed;

  /// No description provided for @total_ts_recovered_in_current_cycle.
  ///
  /// In en, this message translates to:
  /// **'Total TDS recovered in current cycle'**
  String get total_ts_recovered_in_current_cycle;

  /// No description provided for @no_of_training_days.
  ///
  /// In en, this message translates to:
  /// **'No of Training Days'**
  String get no_of_training_days;

  /// No description provided for @week_off_days.
  ///
  /// In en, this message translates to:
  /// **'Week Off Days'**
  String get week_off_days;

  /// No description provided for @bench_days.
  ///
  /// In en, this message translates to:
  /// **'Bench Days'**
  String get bench_days;

  /// No description provided for @continuous_shift_days.
  ///
  /// In en, this message translates to:
  /// **'Continuous Shift Days'**
  String get continuous_shift_days;

  /// No description provided for @no_of_eos_days.
  ///
  /// In en, this message translates to:
  /// **'No of EOS Days'**
  String get no_of_eos_days;

  /// No description provided for @total_no_extra_hours_day.
  ///
  /// In en, this message translates to:
  /// **'Total No Extra Hours Day'**
  String get total_no_extra_hours_day;

  /// No description provided for @conveyance_days.
  ///
  /// In en, this message translates to:
  /// **'Conveyance Days'**
  String get conveyance_days;

  /// No description provided for @service_attendance_bonus_days.
  ///
  /// In en, this message translates to:
  /// **'Service Attendance Bonus Days'**
  String get service_attendance_bonus_days;

  /// No description provided for @referral_bonus.
  ///
  /// In en, this message translates to:
  /// **'Referral Bonus'**
  String get referral_bonus;

  /// No description provided for @arrears_amount.
  ///
  /// In en, this message translates to:
  /// **'Arrears Amount'**
  String get arrears_amount;

  /// No description provided for @awards_amount.
  ///
  /// In en, this message translates to:
  /// **'Arrears Amount'**
  String get awards_amount;

  /// No description provided for @welfare_amount.
  ///
  /// In en, this message translates to:
  /// **'Welfare Amount'**
  String get welfare_amount;

  /// No description provided for @festival_amount.
  ///
  /// In en, this message translates to:
  /// **'Festival Amount'**
  String get festival_amount;

  /// No description provided for @bench_payment.
  ///
  /// In en, this message translates to:
  /// **'Bench Payment'**
  String get bench_payment;

  /// No description provided for @no_of_ueos_days.
  ///
  /// In en, this message translates to:
  /// **'No of UEOS Days'**
  String get no_of_ueos_days;

  /// No description provided for @no_of_days_late.
  ///
  /// In en, this message translates to:
  /// **'No of Days Late'**
  String get no_of_days_late;

  /// No description provided for @deposit_recovery.
  ///
  /// In en, this message translates to:
  /// **'Deposit Recovery'**
  String get deposit_recovery;

  /// No description provided for @total_additions.
  ///
  /// In en, this message translates to:
  /// **'Total Additions'**
  String get total_additions;

  /// No description provided for @total_deductions.
  ///
  /// In en, this message translates to:
  /// **'Total Deductions'**
  String get total_deductions;

  /// No description provided for @net_service_payment.
  ///
  /// In en, this message translates to:
  /// **'Net Service Payment'**
  String get net_service_payment;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'en',
        'hi',
        'kn',
        'mr',
        'ta',
        'te'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'mr':
      return AppLocalizationsMr();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
