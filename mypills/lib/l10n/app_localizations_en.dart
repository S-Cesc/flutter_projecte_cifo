// ignore_for_file: unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Pills';

  @override
  String get notificationTitle => 'Take the pills!';

  @override
  String get notificationText1 => 'You have to take the pills.';

  @override
  String get notificationText2 => 'Please tap to open the app';

  @override
  String get initializing => 'Initializing...';

  @override
  String get loadingParameters => 'Loading parameters...';

  @override
  String get settingConfiguration => 'Setting configuration...';

  @override
  String get requiredPermissions => 'Checking the required permissions...';

  @override
  String get initializingServices => 'Initializing services...';

  @override
  String get failedPermissions => 'Required permissions have not been granted';

  @override
  String get informationLoaded => 'Ready!';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get saveChanges => 'Save';

  @override
  String get undoChanges => 'Undo';

  @override
  String get cancel => 'Cancel';

  @override
  String get discard => 'Discard';

  @override
  String get saved => 'Saved';

  @override
  String get added => 'Item added';

  @override
  String get pendingChanges => 'Pending changes';

  @override
  String get pendingChangesMessage => 'There are pending changes.';

  @override
  String get pendingChangesDiscardQuestion => 'Discard the pending changes?';

  @override
  String get pendingChangesDiscarded => 'Pending changes have been discarded.';

  @override
  String get notSavedCauseOfError => 'Error. Not saved';

  @override
  String get notAddedExisting => 'Not added: it already exists';

  @override
  String get confirm => 'Confirm';

  @override
  String confirmDeletion(num count, String gender) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'other': 'Would you like to remove?',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $_temp0',
    );
    return '$_temp1';
  }

  @override
  String get exitApplication => 'Exit';

  @override
  String get restartApplication => 'Restart';

  @override
  String get askExitApplication => 'Exit application?';

  @override
  String get changeAlarmPermissions => 'Change alarm permission configuration';

  @override
  String get emptyDaysetError => 'Meals cannot be defined if it is not indicated for which days.';

  @override
  String get timeTableModifiedWarning => 'Times have been modified to maintain consistency.';

  @override
  String get snooze => 'Snooze';

  @override
  String get missedAlarm => 'Missed alarm';

  @override
  String get stoppedAlarm => 'Alarm stopped';

  @override
  String get snoozedAlarm => 'Alarm snoozed';

  @override
  String get once => 'Once';

  @override
  String get onceADay => 'Once a day (24h)';

  @override
  String get twiceADay => 'Twice a day (12h)';

  @override
  String get threeTimesADay => 'Three times a day (8h)';

  @override
  String get fourTimesADay => 'Four times a day (6h)';

  @override
  String get weekly => 'Once a week';

  @override
  String get everyTwoWeeks => 'Every two weeks';

  @override
  String get fortnightly => 'Every fortnight (twice each month)';

  @override
  String get everyFourWeeks => 'Every four weeks';

  @override
  String get monthly => 'Once a month';

  @override
  String get once_tooltip => 'Take the pills once, just once.';

  @override
  String get onceADay_tooltip => 'Take the pills daily, every 24h.';

  @override
  String get twiceADay_tooltip => 'Take the pills twice a day, every 12h.';

  @override
  String get threeTimesADay_tooltip => 'Take the pills three times a day, every 8h.';

  @override
  String get fourTimesADay_tooltip => 'Take the pills four times a day, every 6h.';

  @override
  String get weekly_tooltip => 'Take the pills weekly, once a week, always the same day of week.';

  @override
  String get everyTwoWeeks_tooltip => 'Take the pills every two weeks, always the same day of week.';

  @override
  String get fortnightly_tooltip => 'Take pills every fortnight, twice each month, always the same day of month.';

  @override
  String get everyFourWeeks_tooltip => 'Take pills every four weeks, always the same day of week.';

  @override
  String get monthly_tooltip => 'Take pills once a month, always the same day of month.';

  @override
  String get alarmSettings => 'Alarm settings';

  @override
  String get alarmRepeatTimes => 'Repeat times';

  @override
  String get alarmDurationSeconds => 'Duration seconds';

  @override
  String get alarmSnoozeSeconds => 'Snooze time in seconds';

  @override
  String get minutesToDealWithAlarm => 'Minutes to deal with alarm';

  @override
  String get tooltipAlarmRepeatTimes => 'Number of times the alarm sounds until it is given up as lost';

  @override
  String get tooltipSnoozeSeconds => 'Seconds from the end of the alarm sounding without stopping it until it automatically repeats itself';

  @override
  String get tooltipAlarmDurationSeconds => 'Seconds the alarm sounds if not stopped';

  @override
  String get tooltipMinutesToDealWithAlarm => 'Maximum number of minutes from the time the alarm is acknowledged until the pills are taken';

  @override
  String get timeSettings => 'Before/after minutes';

  @override
  String get minutesLongBefore => 'Minutes long before meal';

  @override
  String get minutesBefore => 'Minutes before meal';

  @override
  String get minutesAfter => 'Minutes after meal';

  @override
  String get minutesLongAfter => 'Minutes long after supper';

  @override
  String get tooltipLongBefore => 'Minutes from taking the pills between meals until eating. Combined with the value indicated for long after the previous meal. Applies if you take pills between meals.';

  @override
  String get tooltipBefore => 'Minutes before meals you are notified to take the pills before meals. Applies if you take pills before meals.';

  @override
  String get tooltipAfter => 'Minutes in addition to the time used for eating. Applies if you take pills after meals.';

  @override
  String get tooltipLongAfter => 'Minutes that need to pass after meals to take pills between meals. Applies if you take pills between meals.';

  @override
  String get timeEating => 'Time spent eating';

  @override
  String get timeEatingTooltip => 'Time you spend on each meal. You only have to set values for those meals you have. A distinction is made between \'fast\' and \'slow\' values.';

  @override
  String get bkfDuration => 'Breakfast duration, in minutes.';

  @override
  String get elevensesDuration => 'Elevenses duration, in minutes.';

  @override
  String get brunchDuration => 'Brunch duration, in minutes.';

  @override
  String get lunchDuration => 'Lunch duration, in minutes.';

  @override
  String get teaDuration => 'Afternoon tea duration, in minutes.';

  @override
  String get highTeaDuration => 'Tea duration, in minutes.';

  @override
  String get dinnerDuration => 'Dinner duration, in minutes.';

  @override
  String get supperDuration => 'Supper duration, in minutes.';

  @override
  String get meal => 'Meal';

  @override
  String get breakfast => 'breakfast';

  @override
  String get elevenses => 'elevenses';

  @override
  String get brunch => 'brunch';

  @override
  String get lunch => 'lunch';

  @override
  String get tea => 'afternoon tea';

  @override
  String get highTea => 'tea';

  @override
  String get dinner => 'dinner';

  @override
  String get supper => 'supper';

  @override
  String get longBefore => 'long before';

  @override
  String get before => 'before';

  @override
  String get at => 'at';

  @override
  String get after => 'after';

  @override
  String get longAfter => 'long after';

  @override
  String get slowLabel => 'Slow';

  @override
  String get mediumLabel => 'Normal';

  @override
  String get fastLabel => 'Fast';

  @override
  String get alarmList => 'Alarm list';

  @override
  String get alarms => 'Alarms';

  @override
  String get weeklyTimetable => 'Weekly routine';

  @override
  String get mealsForPills => 'Meals for pills';

  @override
  String get weeklyDefaultTimetable => 'Usual';

  @override
  String get weeklyAltTimetable1 => 'Alt-1';

  @override
  String get weeklyAltTimetable2 => 'Alt-2';

  @override
  String get weeklyAltTimetable3 => 'Alt-3';

  @override
  String get defaultWeeklyTimetable => 'Meals you usually have and at what time';

  @override
  String get specialWeeklyTimetable => 'Meals and its time on designated days ';

  @override
  String get configMealsTooltip => 'Meals should be defined for each day, so that the system can know the time intervals between meals. In addition, three other alternative routines can be defined for specific days of the week.';

  @override
  String get createNewAlarm => 'Create new alarm';

  @override
  String get pillsLongBeforeBreakfast => 'morning pills';

  @override
  String get pillsBeforeBreakfast => 'pre-breakfast pills';

  @override
  String get pillsAtBreakfast => 'breakfast pills';

  @override
  String get pillsAfterBreakfast => 'after-breakfast pills';

  @override
  String get pillsLongBeforeElevenses => 'pills well before elevenses';

  @override
  String get pillsBeforeElevenses => 'pre-elevenses pills';

  @override
  String get pillsAtElevenses => 'elevenses pills';

  @override
  String get pillsAfterElevenses => 'after-elevenses pills';

  @override
  String get pillsLongBeforeBrunch => 'pills well before brunch';

  @override
  String get pillsBeforeBrunch => 'pre-brunch pills';

  @override
  String get pillsAtBrunch => 'brunch pills';

  @override
  String get pillsAfterBrunch => 'after-brunch pills';

  @override
  String get pillsLongBeforeLunch => 'pills well before lunch';

  @override
  String get pillsBeforeLunch => 'pre-lunch pills';

  @override
  String get pillsAtLunch => 'lunch pills';

  @override
  String get pillsAfterLunch => 'after-lunch pills';

  @override
  String get pillsLongBeforeTea => 'pills well before afternoon tea';

  @override
  String get pillsBeforeTea => 'pills before afternoon tea';

  @override
  String get pillsAtTea => 'afternoon tea pills';

  @override
  String get pillsAfterTea => 'after-afternoon tea pills';

  @override
  String get pillsLongBeforeHighTea => 'pills well before tea';

  @override
  String get pillsBeforeHighTea => 'pills before tea';

  @override
  String get pillsAtHighTea => 'tea pills';

  @override
  String get pillsAfterHighTea => 'after-tea pills';

  @override
  String get pillsLongBeforeDinner => 'pills well before dinner';

  @override
  String get pillsBeforeDinner => 'pre-dinner pills';

  @override
  String get pillsAtDinner => 'dinner pills';

  @override
  String get pillsAfterDinner => 'after-dinner pills';

  @override
  String get pillsLongBeforeSupper => 'pills well before supper';

  @override
  String get pillsBeforeSupper => 'pre-supper pills';

  @override
  String get pillsAtSupper => 'supper pills';

  @override
  String get pillsAfterSupper => 'after-supper pills';

  @override
  String get pillsLongAfterSupper => 'midnight pills';
}
