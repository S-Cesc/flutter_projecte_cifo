// ignore_for_file: unused_local_variable
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
    Locale('es'),
    Locale('ca'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'My Pills'**
  String get appTitle;

  /// Title of the notification
  ///
  /// In en, this message translates to:
  /// **'Take the pills!'**
  String get notificationTitle;

  /// Notification detail text (1st line)
  ///
  /// In en, this message translates to:
  /// **'You have to take the pills.'**
  String get notificationText1;

  /// Notification detail text (2nd line)
  ///
  /// In en, this message translates to:
  /// **'Please tap to open the app'**
  String get notificationText2;

  /// Progress title
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// Progress: parameters
  ///
  /// In en, this message translates to:
  /// **'Loading parameters...'**
  String get loadingParameters;

  /// Progress: settings
  ///
  /// In en, this message translates to:
  /// **'Setting configuration...'**
  String get settingConfiguration;

  /// Progress: permissions
  ///
  /// In en, this message translates to:
  /// **'Checking the required permissions...'**
  String get requiredPermissions;

  /// Progress: services
  ///
  /// In en, this message translates to:
  /// **'Initializing services...'**
  String get initializingServices;

  /// Progress fail: required permissions not granted
  ///
  /// In en, this message translates to:
  /// **'Required permissions have not been granted'**
  String get failedPermissions;

  /// Last progress message
  ///
  /// In en, this message translates to:
  /// **'Ready!'**
  String get informationLoaded;

  /// Answer question
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Answer question
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Save pending changes
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveChanges;

  /// Discard pending changes
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoChanges;

  /// Cancel operation
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Discard pending operations
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// Data saved message
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// Item added message
  ///
  /// In en, this message translates to:
  /// **'Item added'**
  String get added;

  /// Pending changes (dialog) title
  ///
  /// In en, this message translates to:
  /// **'Pending changes'**
  String get pendingChanges;

  /// There are pending changes information message
  ///
  /// In en, this message translates to:
  /// **'There are pending changes.'**
  String get pendingChangesMessage;

  /// Ask user if he want to discard the pending changes
  ///
  /// In en, this message translates to:
  /// **'Discard the pending changes?'**
  String get pendingChangesDiscardQuestion;

  /// Pending changes discarded (after user acknowledgement)
  ///
  /// In en, this message translates to:
  /// **'Pending changes have been discarded.'**
  String get pendingChangesDiscarded;

  /// Data not saved because of an error
  ///
  /// In en, this message translates to:
  /// **'Error. Not saved'**
  String get notSavedCauseOfError;

  /// Item not added because the item already exists message
  ///
  /// In en, this message translates to:
  /// **'Not added: it already exists'**
  String get notAddedExisting;

  /// Ask for confirmation to perform the operation
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Ask for confirmation to remove item
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{ {gender, select, other{Would you like to remove?}}}}'**
  String confirmDeletion(num count, String gender);

  /// button end application
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitApplication;

  /// button restart application
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restartApplication;

  /// Exit application question
  ///
  /// In en, this message translates to:
  /// **'Exit application?'**
  String get askExitApplication;

  /// Set alarm system permissions
  ///
  /// In en, this message translates to:
  /// **'Change alarm permission configuration'**
  String get changeAlarmPermissions;

  /// Defined dayset is required
  ///
  /// In en, this message translates to:
  /// **'Meals cannot be defined if it is not indicated for which days.'**
  String get emptyDaysetError;

  /// Warning: the times of the time table has been automatically modified
  ///
  /// In en, this message translates to:
  /// **'Times have been modified to maintain consistency.'**
  String get timeTableModifiedWarning;

  /// Snooze alarm operation
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get snooze;

  /// Alarm status: Missed, because it automaticaly snoozed too many times
  ///
  /// In en, this message translates to:
  /// **'Missed alarm'**
  String get missedAlarm;

  /// Alarm status: Stopped by the user
  ///
  /// In en, this message translates to:
  /// **'Alarm stopped'**
  String get stoppedAlarm;

  /// Alarm status: Snoozed (user requeriment or after a long ring)
  ///
  /// In en, this message translates to:
  /// **'Alarm snoozed'**
  String get snoozedAlarm;

  /// Take pills once (just once)
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get once;

  /// Take pills daily (every 24h)
  ///
  /// In en, this message translates to:
  /// **'Once a day (24h)'**
  String get onceADay;

  /// Take pills twice a day (every 12h)
  ///
  /// In en, this message translates to:
  /// **'Twice a day (12h)'**
  String get twiceADay;

  /// Take pills three times a day (every 8h)
  ///
  /// In en, this message translates to:
  /// **'Three times a day (8h)'**
  String get threeTimesADay;

  /// Take pills four times a day (every 6h)
  ///
  /// In en, this message translates to:
  /// **'Four times a day (6h)'**
  String get fourTimesADay;

  /// Take pills weekly (once a week)
  ///
  /// In en, this message translates to:
  /// **'Once a week'**
  String get weekly;

  /// Take pills every two weeks
  ///
  /// In en, this message translates to:
  /// **'Every two weeks'**
  String get everyTwoWeeks;

  /// Take pills every fortnight
  ///
  /// In en, this message translates to:
  /// **'Every fortnight (twice each month)'**
  String get fortnightly;

  /// Take pills every four weeks
  ///
  /// In en, this message translates to:
  /// **'Every four weeks'**
  String get everyFourWeeks;

  /// Take pills once a month
  ///
  /// In en, this message translates to:
  /// **'Once a month'**
  String get monthly;

  /// Take pills once (just once)
  ///
  /// In en, this message translates to:
  /// **'Take the pills once, just once.'**
  String get once_tooltip;

  /// Take pills daily (every 24h)
  ///
  /// In en, this message translates to:
  /// **'Take the pills daily, every 24h.'**
  String get onceADay_tooltip;

  /// Take pills twice a day (every 12h)
  ///
  /// In en, this message translates to:
  /// **'Take the pills twice a day, every 12h.'**
  String get twiceADay_tooltip;

  /// Take pills three times a day (every 8h)
  ///
  /// In en, this message translates to:
  /// **'Take the pills three times a day, every 8h.'**
  String get threeTimesADay_tooltip;

  /// Take pills four times a day (every 6h)
  ///
  /// In en, this message translates to:
  /// **'Take the pills four times a day, every 6h.'**
  String get fourTimesADay_tooltip;

  /// Take pills weekly (once a week)
  ///
  /// In en, this message translates to:
  /// **'Take the pills weekly, once a week, always the same day of week.'**
  String get weekly_tooltip;

  /// Take pills every two weeks
  ///
  /// In en, this message translates to:
  /// **'Take the pills every two weeks, always the same day of week.'**
  String get everyTwoWeeks_tooltip;

  /// Take pills every fortnight
  ///
  /// In en, this message translates to:
  /// **'Take pills every fortnight, twice each month, always the same day of month.'**
  String get fortnightly_tooltip;

  /// Take pills every four weeks
  ///
  /// In en, this message translates to:
  /// **'Take pills every four weeks, always the same day of week.'**
  String get everyFourWeeks_tooltip;

  /// Take pills once a month
  ///
  /// In en, this message translates to:
  /// **'Take pills once a month, always the same day of month.'**
  String get monthly_tooltip;

  /// Alarm settings title
  ///
  /// In en, this message translates to:
  /// **'Alarm settings'**
  String get alarmSettings;

  /// Ask for alarm repeat times value
  ///
  /// In en, this message translates to:
  /// **'Repeat times'**
  String get alarmRepeatTimes;

  /// Ask for alarm duration seconds value
  ///
  /// In en, this message translates to:
  /// **'Duration seconds'**
  String get alarmDurationSeconds;

  /// Ask for alarm snooze seconds value
  ///
  /// In en, this message translates to:
  /// **'Snooze time in seconds'**
  String get alarmSnoozeSeconds;

  /// Ask how many minutes do you need to deal with alarm
  ///
  /// In en, this message translates to:
  /// **'Minutes to deal with alarm'**
  String get minutesToDealWithAlarm;

  /// Explain the alarm repeating field
  ///
  /// In en, this message translates to:
  /// **'Number of times the alarm sounds until it is given up as lost'**
  String get tooltipAlarmRepeatTimes;

  /// Explain the alarm snooze duration field
  ///
  /// In en, this message translates to:
  /// **'Seconds from the end of the alarm sounding without stopping it until it automatically repeats itself'**
  String get tooltipSnoozeSeconds;

  /// Explain the alarm duration field
  ///
  /// In en, this message translates to:
  /// **'Seconds the alarm sounds if not stopped'**
  String get tooltipAlarmDurationSeconds;

  /// Explain the question about minutes to deal with alarm
  ///
  /// In en, this message translates to:
  /// **'Maximum number of minutes from the time the alarm is acknowledged until the pills are taken'**
  String get tooltipMinutesToDealWithAlarm;

  /// Before/after time settings title
  ///
  /// In en, this message translates to:
  /// **'Before/after minutes'**
  String get timeSettings;

  /// Minutes long before meal
  ///
  /// In en, this message translates to:
  /// **'Minutes long before meal'**
  String get minutesLongBefore;

  /// Minutes before meal
  ///
  /// In en, this message translates to:
  /// **'Minutes before meal'**
  String get minutesBefore;

  /// Minutes after meal
  ///
  /// In en, this message translates to:
  /// **'Minutes after meal'**
  String get minutesAfter;

  /// Minutes long after supper
  ///
  /// In en, this message translates to:
  /// **'Minutes long after supper'**
  String get minutesLongAfter;

  /// Explain the minutes long before meals field
  ///
  /// In en, this message translates to:
  /// **'Minutes from taking the pills between meals until eating. Combined with the value indicated for long after the previous meal. Applies if you take pills between meals.'**
  String get tooltipLongBefore;

  /// Explain the minutes before meals field
  ///
  /// In en, this message translates to:
  /// **'Minutes before meals you are notified to take the pills before meals. Applies if you take pills before meals.'**
  String get tooltipBefore;

  /// Explain the minutes after meals field
  ///
  /// In en, this message translates to:
  /// **'Minutes in addition to the time used for eating. Applies if you take pills after meals.'**
  String get tooltipAfter;

  /// Explain the minutes long after meals field
  ///
  /// In en, this message translates to:
  /// **'Minutes that need to pass after meals to take pills between meals. Applies if you take pills between meals.'**
  String get tooltipLongAfter;

  /// Time spent eating
  ///
  /// In en, this message translates to:
  /// **'Time spent eating'**
  String get timeEating;

  /// Explain the time spent eating setting screen
  ///
  /// In en, this message translates to:
  /// **'Time you spend on each meal. You only have to set values for those meals you have. A distinction is made between \'fast\' and \'slow\' values.'**
  String get timeEatingTooltip;

  /// breakfast duration
  ///
  /// In en, this message translates to:
  /// **'Breakfast duration, in minutes.'**
  String get bkfDuration;

  /// elevenses duration
  ///
  /// In en, this message translates to:
  /// **'Elevenses duration, in minutes.'**
  String get elevensesDuration;

  /// brunch duration
  ///
  /// In en, this message translates to:
  /// **'Brunch duration, in minutes.'**
  String get brunchDuration;

  /// lunch duration
  ///
  /// In en, this message translates to:
  /// **'Lunch duration, in minutes.'**
  String get lunchDuration;

  /// afternoon tea duration
  ///
  /// In en, this message translates to:
  /// **'Afternoon tea duration, in minutes.'**
  String get teaDuration;

  /// high tea duration
  ///
  /// In en, this message translates to:
  /// **'Tea duration, in minutes.'**
  String get highTeaDuration;

  /// dinner duration
  ///
  /// In en, this message translates to:
  /// **'Dinner duration, in minutes.'**
  String get dinnerDuration;

  /// supper duration
  ///
  /// In en, this message translates to:
  /// **'Supper duration, in minutes.'**
  String get supperDuration;

  /// Meal selection title
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get meal;

  /// Meal time
  ///
  /// In en, this message translates to:
  /// **'breakfast'**
  String get breakfast;

  /// Meal time
  ///
  /// In en, this message translates to:
  /// **'elevenses'**
  String get elevenses;

  /// Meal time
  ///
  /// In en, this message translates to:
  /// **'brunch'**
  String get brunch;

  /// Meal time
  ///
  /// In en, this message translates to:
  /// **'lunch'**
  String get lunch;

  /// Meal time
  ///
  /// In en, this message translates to:
  /// **'afternoon tea'**
  String get tea;

  /// Meal time
  ///
  /// In en, this message translates to:
  /// **'tea'**
  String get highTea;

  /// Meal time
  ///
  /// In en, this message translates to:
  /// **'dinner'**
  String get dinner;

  /// Meal time
  ///
  /// In en, this message translates to:
  /// **'supper'**
  String get supper;

  /// Pill meal time, for using alone to pick one option
  ///
  /// In en, this message translates to:
  /// **'long before'**
  String get longBefore;

  /// Pill meal time, for using alone to pick one option
  ///
  /// In en, this message translates to:
  /// **'before'**
  String get before;

  /// Pill meal time, for using alone to pick one option
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get at;

  /// Pill meal time, for using alone to pick one option
  ///
  /// In en, this message translates to:
  /// **'after'**
  String get after;

  /// Pill meal time, for using alone to pick one option
  ///
  /// In en, this message translates to:
  /// **'long after'**
  String get longAfter;

  /// Slow speed (enum SpeedLabel)
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get slowLabel;

  /// Medium speed (enum SpeedLabel)
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get mediumLabel;

  /// Fast speed (enum SpeedLabel)
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fastLabel;

  /// Button text for setting Weekly time for each meal
  ///
  /// In en, this message translates to:
  /// **'Weekly routine'**
  String get weeklyTimetable;

  /// Usual/Alt tabs
  ///
  /// In en, this message translates to:
  /// **'Usual'**
  String get weeklyDefaultTimetable;

  /// Usual/Alt tabs
  ///
  /// In en, this message translates to:
  /// **'Alt-1'**
  String get weeklyAltTimetable1;

  /// Usual/Alt tabs
  ///
  /// In en, this message translates to:
  /// **'Alt-2'**
  String get weeklyAltTimetable2;

  /// Usual/Alt tabs
  ///
  /// In en, this message translates to:
  /// **'Alt-3'**
  String get weeklyAltTimetable3;

  /// Default weekly time table for each meal
  ///
  /// In en, this message translates to:
  /// **'Meals you usually have and at what time'**
  String get defaultWeeklyTimetable;

  /// Special days of week time table for each meal
  ///
  /// In en, this message translates to:
  /// **'Meals and its time on designated days '**
  String get specialWeeklyTimetable;

  /// Not enough meal times defined in the time table; overlay tag which appears in the button
  ///
  /// In en, this message translates to:
  /// **'Needs to be defined'**
  String get notFullyDefined;

  /// Tooltip for the config meals screen
  ///
  /// In en, this message translates to:
  /// **'Meals should be defined for each day, so that the system can know the time intervals between meals. In addition, you can optionally define up to three alternative routines for specific days of the week.'**
  String get configMealsTooltip;

  /// Button text for choosing the meals available for prescriptions
  ///
  /// In en, this message translates to:
  /// **'Meals for pills'**
  String get mealsForPills;

  /// Alarm list screen title
  ///
  /// In en, this message translates to:
  /// **'Alarm list'**
  String get alarmList;

  /// Button & title Alarms
  ///
  /// In en, this message translates to:
  /// **'Alarms'**
  String get alarms;

  /// New alarm screen title
  ///
  /// In en, this message translates to:
  /// **'Create new alarm'**
  String get createNewAlarm;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'morning pills'**
  String get pillsLongBeforeBreakfast;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'pre-breakfast pills'**
  String get pillsBeforeBreakfast;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'breakfast pills'**
  String get pillsAtBreakfast;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'after-breakfast pills'**
  String get pillsAfterBreakfast;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'pills well before elevenses'**
  String get pillsLongBeforeElevenses;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'pre-elevenses pills'**
  String get pillsBeforeElevenses;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'elevenses pills'**
  String get pillsAtElevenses;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'after-elevenses pills'**
  String get pillsAfterElevenses;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'pills well before brunch'**
  String get pillsLongBeforeBrunch;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'pre-brunch pills'**
  String get pillsBeforeBrunch;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'brunch pills'**
  String get pillsAtBrunch;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'after-brunch pills'**
  String get pillsAfterBrunch;

  /// Meal time
  ///
  /// In en, this message translates to:
  /// **'pills well before lunch'**
  String get pillsLongBeforeLunch;

  /// Meal time
  ///
  /// In en, this message translates to:
  /// **'pre-lunch pills'**
  String get pillsBeforeLunch;

  /// Meal time
  ///
  /// In en, this message translates to:
  /// **'lunch pills'**
  String get pillsAtLunch;

  /// Meal time
  ///
  /// In en, this message translates to:
  /// **'after-lunch pills'**
  String get pillsAfterLunch;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'pills well before afternoon tea'**
  String get pillsLongBeforeTea;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'pills before afternoon tea'**
  String get pillsBeforeTea;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'afternoon tea pills'**
  String get pillsAtTea;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'after-afternoon tea pills'**
  String get pillsAfterTea;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'pills well before tea'**
  String get pillsLongBeforeHighTea;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'pills before tea'**
  String get pillsBeforeHighTea;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'tea pills'**
  String get pillsAtHighTea;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'after-tea pills'**
  String get pillsAfterHighTea;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'pills well before dinner'**
  String get pillsLongBeforeDinner;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'pre-dinner pills'**
  String get pillsBeforeDinner;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'dinner pills'**
  String get pillsAtDinner;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'after-dinner pills'**
  String get pillsAfterDinner;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'pills well before supper'**
  String get pillsLongBeforeSupper;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'pre-supper pills'**
  String get pillsBeforeSupper;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'supper pills'**
  String get pillsAtSupper;

  /// Pill time
  ///
  /// In en, this message translates to:
  /// **'after-supper pills'**
  String get pillsAfterSupper;

  /// Pill time (long after supper)
  ///
  /// In en, this message translates to:
  /// **'midnight pills'**
  String get pillsLongAfterSupper;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ca', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
