// logging and debugging
// Dart base
import 'dart:convert';
// Flutter
import 'package:shared_preferences/shared_preferences.dart';
// Project files
import '../model/general_preferences.dart';
import '../model/meal.dart';
import '../model/weekly_time_table.dart';

//==============================================================================

/// A provider with simple object (int) parameters
/// and also a [WeeklyTimeTable]
/// It is used by [ConfigPreferences], but also by [BackgroundPreferences]
class GeneralSettings {
  //-------------------------static/constant------------------------------------

  /// JSON key for alarmDurationSeconds
  static const alarmDurationSecondsKey = 'aDuration';

  /// JSON key for alarmSnoozeSeconds
  static const alarmSnoozeSecondsKey = 'aSnooze';

  /// JSON key for alarmRepeatTimes
  static const alarmRepeatTimesKey = 'aRepeat';

  /// JSON key for minutesToDealWithAlarm
  static const minutesToDealWithAlarmKey = 'aDeal';

  /// JSON key for longBeforeMeal
  static const longBeforeMealKey = 'mLBefore';

  /// JSON key for beforeMeal
  static const beforeMealKey = 'mBefore';

  /// JSON key for afterMeal
  static const afterMealKey = 'mAfter';

  /// JSON key for longAfterMeal
  static const longAfterMealKey = 'mLAfter';

  /// JSON key for breakfastMinutes
  static const breakfastMinutesKey = 'bkfMin';

  /// JSON key for brunchMinutes
  static const brunchMinutesKey = 'brunchMin';

  /// JSON key for lunchMinutes
  static const lunchMinutesKey = 'lunchMin';

  /// JSON key for teaMinutes
  static const teaMinutesKey = 'teaMin';

  /// JSON key for highTeaMinutes
  static const highTeaMinutesKey = 'hTeaMin';

  /// JSON key for dinnerMinutes
  static const dinnerMinutesKey = 'dnrMin';

  /// JSON key for supperMinutes
  static const supperMinutesKey = 'supperMin';

  /// JSON key for weeklyTimeTable
  static const weeklyTimeTableKey = 'wTimeTable';

  /// JSON key for alarm objects, using its id
  static String alarmJsonKey(int alarmId) => 'a$alarmId';

  //-----------------class state members and constructors ----------------------

  final SharedPreferencesAsync _shPrefs;
  final void Function()? callbackOnUpdate;
  late GeneralPreferences _data;
  late WeeklyTimeTable _wtt;
  bool initialized = false;

  GeneralSettings(this._shPrefs, this.callbackOnUpdate);

  //-----------------------class special members--------------------------------

  /// Initialize: read values from disk
  Future<void> init() async {
    if (!initialized) {
      await Future.wait([
        _shPrefs.getInt(alarmDurationSecondsKey),
        _shPrefs.getInt(alarmSnoozeSecondsKey),
        _shPrefs.getInt(alarmRepeatTimesKey),
        _shPrefs.getInt(minutesToDealWithAlarmKey),
        _shPrefs.getInt(longBeforeMealKey),
        _shPrefs.getInt(beforeMealKey),
        _shPrefs.getInt(afterMealKey),
        _shPrefs.getInt(longAfterMealKey),
        _shPrefs.getInt(breakfastMinutesKey),
        _shPrefs.getInt(brunchMinutesKey),
        _shPrefs.getInt(lunchMinutesKey),
        _shPrefs.getInt(teaMinutesKey),
        _shPrefs.getInt(highTeaMinutesKey),
        _shPrefs.getInt(dinnerMinutesKey),
        _shPrefs.getInt(supperMinutesKey),
      ]).then((results) {
        _data = GeneralPreferences(
          results[0] ?? GeneralPreferences.defaultAlarmDurationSeconds,
          results[1] ?? GeneralPreferences.defaultAlarmSnoozeSeconds,
          results[2] ?? GeneralPreferences.defaultAlarmRepeatTimes,
          results[3] ?? GeneralPreferences.defaultMinutesToDealWithAlarm,
          results[4] ?? GeneralPreferences.defaultMinutesLongBefore,
          results[5] ?? GeneralPreferences.defaultMinutesBefore,
          results[6] ?? GeneralPreferences.defaultMinutesAfter,
          results[7] ?? GeneralPreferences.defaultMinutesLongAfter,
          results[8] ?? Meal.defaultMealDuration(Meal.breakfast).inMinutes,
          results[9] ?? Meal.defaultMealDuration(Meal.brunch).inMinutes,
          results[10] ?? Meal.defaultMealDuration(Meal.lunch).inMinutes,
          results[11] ?? Meal.defaultMealDuration(Meal.tea).inMinutes,
          results[12] ?? Meal.defaultMealDuration(Meal.highTea).inMinutes,
          results[13] ?? Meal.defaultMealDuration(Meal.dinner).inMinutes,
          results[14] ?? Meal.defaultMealDuration(Meal.supper).inMinutes,
        );
      });
      try {
        final String? strWtt = await _shPrefs.getString(weeklyTimeTableKey);
        if (strWtt != null) {
          final parsedJson = json.decode(strWtt) as Map<String, dynamic>;
          _wtt = WeeklyTimeTable.fromJson(parsedJson);
        } else {
          _wtt = WeeklyTimeTable.empty();
        }
      } catch (e) {
        _wtt = WeeklyTimeTable.empty();
      }
      initialized = true;
    }
  }

  /// Requery values from disk. Used for
  /// - Get updated values in the cached values of the Background Alarms
  /// - Undo changes in ConfigPreferences editing
  Future<void> requery() async {
    initialized = false;
    await init();
    callbackOnUpdate?.call();
  }

  /// GeneralPreferences values (read-only)
  ReadOnlyGeneralPreferences get data => _data.readOnlyValues;

  /// WeeklyTimeTable (times of meals and days of week for each time table)
  WeeklyTimeTable get wtt => _wtt;

  //-----------------------class rest of members--------------------------------

  /// sets the alarm setting and writes it to disk
  Future<void> setAlarmDurationSeconds(int value) async {
    _data.alarmDurationSeconds = value;
    await _shPrefs.setInt(alarmDurationSecondsKey, value);
    callbackOnUpdate!();
  }

  /// sets the alarm setting and writes it to disk
  Future<void> setAlarmSnoozeSeconds(int value) async {
    _data.alarmSnoozeSeconds = value;
    await _shPrefs.setInt(alarmSnoozeSecondsKey, value);
    callbackOnUpdate!();
  }

  /// sets the alarm setting and writes it to disk
  Future<void> setAlarmRepeatTimes(int value) async {
    _data.alarmRepeatTimes = value;
    await _shPrefs.setInt(alarmRepeatTimesKey, value);
    callbackOnUpdate!();
  }

  /// sets the alarm setting and writes it to disk
  Future<void> setMinutesToDealWithAlarm(int value) async {
    _data.minutesToDealWithAlarm = value;
    await _shPrefs.setInt(minutesToDealWithAlarmKey, value);
    callbackOnUpdate!();
  }

  // ----- //

  /// sets meal pill time value and writes it to disk
  Future<void> setMinutesLongBeforeMeal(int value) async {
    _data.minutesLongBefore = value;
    await _shPrefs.setInt(longBeforeMealKey, value);
    callbackOnUpdate!();
  }

  /// sets meal pill time value and writes it to disk
  Future<void> setMinutesBeforeMeal(int value) async {
    _data.minutesBefore = value;
    await _shPrefs.setInt(beforeMealKey, value);
    callbackOnUpdate!();
  }

  /// sets meal pill time value and writes it to disk
  Future<void> setMinutesAfterMeal(int value) async {
    _data.minutesAfter = value;
    await _shPrefs.setInt(afterMealKey, value);
    callbackOnUpdate!();
  }

  /// sets meal pill time value and writes it to disk
  Future<void> setMinutesLongAfterMeal(int value) async {
    _data.minutesLongAfter = value;
    await _shPrefs.setInt(longAfterMealKey, value);
    callbackOnUpdate!();
  }

  // ----- //

  /// sets the meal duration and writes it to disk
  Future<void> setBreakfastMinutes(int value) async {
    _data.breakfastMinutes = value;
    await _shPrefs.setInt(breakfastMinutesKey, value);
    callbackOnUpdate!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setBrunchMinutes(int value) async {
    _data.brunchMinutes = value;
    await _shPrefs.setInt(brunchMinutesKey, value);
    callbackOnUpdate!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setLunchMinutes(int value) async {
    _data.lunchMinutes = value;
    await _shPrefs.setInt(lunchMinutesKey, value);
    callbackOnUpdate!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setTeaMinutes(int value) async {
    _data.teaMinutes = value;
    await _shPrefs.setInt(teaMinutesKey, value);
    callbackOnUpdate!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setHighTeaMinutes(int value) async {
    _data.highTeaMinutes = value;
    await _shPrefs.setInt(highTeaMinutesKey, value);
    callbackOnUpdate!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setDinnerMinutes(int value) async {
    _data.dinnerMinutes = value;
    await _shPrefs.setInt(dinnerMinutesKey, value);
    callbackOnUpdate!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setSupperMinutes(int value) async {
    _data.supperMinutes = value;
    await _shPrefs.setInt(supperMinutesKey, value);
    callbackOnUpdate!();
  }

  // ----- //

  /// sets writes to disk the [WeeklyTimeTable]
  Future<void> setWeeklyTimeTable(WeeklyTimeTable value) async {
    _wtt = value;
    await _shPrefs.setString(weeklyTimeTableKey, json.encode(value.toJson()));
    callbackOnUpdate!();
  }
}
