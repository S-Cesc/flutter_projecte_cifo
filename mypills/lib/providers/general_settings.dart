// logging and debugging
// Dart base
import 'dart:convert';
// Flutter
import 'package:shared_preferences/shared_preferences.dart';
// Project files
import '../model/general_preferences.dart';
import '../model/enum/meal.dart';
import '../model/meals_for_pills.dart';
import '../model/weekly_time_table.dart';

//==============================================================================

/// Access to persistent data on shared_preferences
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
  static const breakfastMinMinKey = 'bkfMinMin';

  /// JSON key for breakfastMinutes
  static const breakfastMaxMinKey = 'bkfMaxMin';

  /// JSON key for breakfastMinutes
  static const elevensesMinMinKey = 'elvnMinMin';

  /// JSON key for breakfastMinutes
  static const elevensesMaxMinKey = 'elvnMaxMin';

  /// JSON key for brunchMin
  static const brunchMinMinKey = 'brunchMinMin';

  /// JSON key for brunchMin
  static const brunchMaxMinKey = 'brunchMaxMin';

  /// JSON key for lunchMin
  static const lunchMinMinKey = 'lunchMinMin';

  /// JSON key for lunchMin
  static const lunchMaxMinKey = 'lunchMaxMin';

  /// JSON key for teaMin
  static const teaMinMinKey = 'teaMinMin';

  /// JSON key for teaMin
  static const teaMaxMinKey = 'teaMaxMin';

  /// JSON key for highTeaMin
  static const highTeaMinMinKey = 'hTeaMinMin';

  /// JSON key for highTeaMin
  static const highTeaMaxMinKey = 'hTeaMaxMin';

  /// JSON key for dinnerMin
  static const dinnerMinMinKey = 'dnrMinMin';

  /// JSON key for dinnerMin
  static const dinnerMaxMinKey = 'dnrMaxMin';

  /// JSON key for supperMin
  static const supperMinMinKey = 'supperMinMin';

  /// JSON key for supperMin
  static const supperMaxMinKey = 'supperMaxMin';

  /// JSON key for weeklyTimeTable
  static const weeklyTimeTableKey = 'wTimeTable';

  /// JSON key for meals for pills
  static const meals4PillsKey = 'm4p';

  /// JSON key prefix for alarm objects
  static const alarmJsonKeyPrefix = "a";

  /// JSON key for alarm objects, using its id
  static String alarmJsonKey(int alarmId) => '$alarmJsonKeyPrefix$alarmId';

  //-----------------class state members and constructors ----------------------

  final SharedPreferencesAsync _shPrefs;

  /// Function called on data update
  /// It allows call to NotifyListeners
  final void Function()? _callbackOnUpdate;

  late GeneralPreferences _data;
  late WeeklyTimeTable _wtt;
  late MealsForPillsWithAlt _m4p;
  bool _initialized = false;

  /// Ctor
  /// Note _callbackOnUpdate is only needed when editing the data
  GeneralSettings(this._shPrefs, this._callbackOnUpdate);

  //-----------------------class special members--------------------------------

  /// Initialize: read values from disk
  Future<void> init() async {
    if (!_initialized) {
      await Future.wait([
        _shPrefs.getInt(alarmDurationSecondsKey),
        _shPrefs.getInt(alarmSnoozeSecondsKey),
        _shPrefs.getInt(alarmRepeatTimesKey),
        _shPrefs.getInt(minutesToDealWithAlarmKey),
        _shPrefs.getInt(longBeforeMealKey),
        _shPrefs.getInt(beforeMealKey),
        _shPrefs.getInt(afterMealKey),
        _shPrefs.getInt(longAfterMealKey),
        _shPrefs.getInt(breakfastMinMinKey),
        _shPrefs.getInt(breakfastMaxMinKey),
        _shPrefs.getInt(elevensesMinMinKey),
        _shPrefs.getInt(elevensesMaxMinKey),
        _shPrefs.getInt(brunchMinMinKey),
        _shPrefs.getInt(brunchMaxMinKey),
        _shPrefs.getInt(lunchMinMinKey),
        _shPrefs.getInt(lunchMaxMinKey),
        _shPrefs.getInt(teaMinMinKey),
        _shPrefs.getInt(teaMaxMinKey),
        _shPrefs.getInt(highTeaMinMinKey),
        _shPrefs.getInt(highTeaMaxMinKey),
        _shPrefs.getInt(dinnerMinMinKey),
        _shPrefs.getInt(dinnerMaxMinKey),
        _shPrefs.getInt(supperMinMinKey),
        _shPrefs.getInt(supperMaxMinKey),
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
          (
            results[8] ?? Meal.defaultMealDuration(Meal.breakfast).inMinutes,
            results[9] ?? Meal.defaultMealDuration(Meal.breakfast).inMinutes,
          ),
          (
            results[10] ?? Meal.defaultMealDuration(Meal.elevenses).inMinutes,
            results[11] ?? Meal.defaultMealDuration(Meal.elevenses).inMinutes,
          ),
          (
            results[12] ?? Meal.defaultMealDuration(Meal.brunch).inMinutes,
            results[13] ?? Meal.defaultMealDuration(Meal.brunch).inMinutes,
          ),
          (
            results[14] ?? Meal.defaultMealDuration(Meal.lunch).inMinutes,
            results[15] ?? Meal.defaultMealDuration(Meal.lunch).inMinutes,
          ),
          (
            results[16] ?? Meal.defaultMealDuration(Meal.tea).inMinutes,
            results[17] ?? Meal.defaultMealDuration(Meal.tea).inMinutes,
          ),
          (
            results[18] ?? Meal.defaultMealDuration(Meal.highTea).inMinutes,
            results[19] ?? Meal.defaultMealDuration(Meal.highTea).inMinutes,
          ),
          (
            results[20] ?? Meal.defaultMealDuration(Meal.dinner).inMinutes,
            results[21] ?? Meal.defaultMealDuration(Meal.dinner).inMinutes,
          ),
          (
            results[22] ?? Meal.defaultMealDuration(Meal.supper).inMinutes,
            results[23] ?? Meal.defaultMealDuration(Meal.supper).inMinutes,
          ),
        );
      });
      try {
        final String? strWtt = await _shPrefs.getString(weeklyTimeTableKey);
        if (strWtt != null) {
          final parsedJson = json.decode(strWtt) as Map<String, dynamic>;
          _wtt = WeeklyTimeTable.fromJson(data, _callbackOnUpdate, parsedJson);
        } else {
          _wtt = WeeklyTimeTable.empty(data, _callbackOnUpdate);
        }
      } catch (e) {
        _wtt = WeeklyTimeTable.empty(data, _callbackOnUpdate);
      }
      try {
        final String? strM4p = await _shPrefs.getString(meals4PillsKey);
        if (strM4p != null) {
          final parsedJson = json.decode(strM4p) as Map<String, dynamic>;
          _m4p = MealsForPillsWithAlt.fromJson(
            _callbackOnUpdate,
            meals4PillsKey,
            parsedJson,
          );
        } else {
          _m4p = MealsForPillsWithAlt(_callbackOnUpdate);
        }
      } catch (e) {
        _m4p = MealsForPillsWithAlt(_callbackOnUpdate);
      }
      _initialized = true;
    }
  }

  /// Requery values from disk. Used for
  /// - Get updated values in the cached values of the Background Alarms
  /// - Undo changes in ConfigPreferences editing
  Future<void> requery() async {
    _initialized = false;
    await init();
    _callbackOnUpdate?.call();
  }

  /// GeneralPreferences values (read-only)
  ReadOnlyGeneralPreferences get data => _data.readOnlyValues;

  /// WeeklyTimeTable (times of meals and days of week for each time table)
  WeeklyTimeTable get wtt => _wtt;

  /// Meals for pils (meals associated with taking pills)
  MealsForPillsWithAlt get m4p => _m4p;

  //-----------------------class rest of members--------------------------------

  /// sets the alarm setting and writes it to disk
  Future<void> setAlarmDurationSeconds(int value) async {
    _data.alarmDurationSeconds = value;
    await _shPrefs.setInt(alarmDurationSecondsKey, value);
    _callbackOnUpdate!();
  }

  /// sets the alarm setting and writes it to disk
  Future<void> setAlarmSnoozeSeconds(int value) async {
    _data.alarmSnoozeSeconds = value;
    await _shPrefs.setInt(alarmSnoozeSecondsKey, value);
    _callbackOnUpdate!();
  }

  /// sets the alarm setting and writes it to disk
  Future<void> setAlarmRepeatTimes(int value) async {
    _data.alarmRepeatTimes = value;
    await _shPrefs.setInt(alarmRepeatTimesKey, value);
    _callbackOnUpdate!();
  }

  /// sets the alarm setting and writes it to disk
  Future<void> setMinutesToDealWithAlarm(int value) async {
    _data.minutesToDealWithAlarm = value;
    await _shPrefs.setInt(minutesToDealWithAlarmKey, value);
    _callbackOnUpdate!();
  }

  // ----- //

  /// sets meal pill time value and writes it to disk
  Future<void> setMinutesLongBeforeMeal(int value) async {
    _data.minutesLongBefore = value;
    await _shPrefs.setInt(longBeforeMealKey, value);
    _callbackOnUpdate!();
  }

  /// sets meal pill time value and writes it to disk
  Future<void> setMinutesBeforeMeal(int value) async {
    _data.minutesBefore = value;
    await _shPrefs.setInt(beforeMealKey, value);
    _callbackOnUpdate!();
  }

  /// sets meal pill time value and writes it to disk
  Future<void> setMinutesAfterMeal(int value) async {
    _data.minutesAfter = value;
    await _shPrefs.setInt(afterMealKey, value);
    _callbackOnUpdate!();
  }

  /// sets meal pill time value and writes it to disk
  Future<void> setMinutesLongAfterMeal(int value) async {
    _data.minutesLongAfter = value;
    await _shPrefs.setInt(longAfterMealKey, value);
    _callbackOnUpdate!();
  }

  // ----- //

  /// sets the meal duration and writes it to disk
  Future<void> setBreakfastMinutes((int, int) value) async {
    _data.breakfastMinutes = value;
    await _shPrefs.setInt(breakfastMinMinKey, value.$1);
    await _shPrefs.setInt(breakfastMaxMinKey, value.$2);
    _callbackOnUpdate!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setElevensesMinutes((int, int) value) async {
    _data.elevensesMinutes = value;
    await _shPrefs.setInt(elevensesMinMinKey, value.$1);
    await _shPrefs.setInt(elevensesMaxMinKey, value.$2);
    _callbackOnUpdate!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setBrunchMinutes((int, int) value) async {
    _data.brunchMinutes = value;
    await _shPrefs.setInt(brunchMinMinKey, value.$1);
    await _shPrefs.setInt(brunchMaxMinKey, value.$2);
    _callbackOnUpdate!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setLunchMinutes((int, int) value) async {
    _data.lunchMinutes = value;
    await _shPrefs.setInt(lunchMinMinKey, value.$1);
    await _shPrefs.setInt(lunchMaxMinKey, value.$2);
    _callbackOnUpdate!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setTeaMinutes((int, int) value) async {
    _data.teaMinutes = value;
    await _shPrefs.setInt(teaMinMinKey, value.$1);
    await _shPrefs.setInt(teaMaxMinKey, value.$2);
    _callbackOnUpdate!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setHighTeaMinutes((int, int) value) async {
    _data.highTeaMinutes = value;
    await _shPrefs.setInt(highTeaMinMinKey, value.$1);
    await _shPrefs.setInt(highTeaMaxMinKey, value.$2);
    _callbackOnUpdate!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setDinnerMinutes((int, int) value) async {
    _data.dinnerMinutes = value;
    await _shPrefs.setInt(dinnerMinMinKey, value.$1);
    await _shPrefs.setInt(dinnerMaxMinKey, value.$2);
    _callbackOnUpdate!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setSupperMinutes((int, int) value) async {
    _data.supperMinutes = value;
    await _shPrefs.setInt(supperMinMinKey, value.$1);
    await _shPrefs.setInt(supperMaxMinKey, value.$2);
    _callbackOnUpdate!();
  }

  // ----- //

  /// sets writes to disk the [WeeklyTimeTable] data
  Future<void> setWeeklyTimeTable(WeeklyTimeTable value) async {
    _wtt = value;
    await _shPrefs.setString(weeklyTimeTableKey, json.encode(value.toJson()));
    value.resetModified();
    _callbackOnUpdate!();
  }

  /// sets writes to disk the [MealsForPills] data
  Future<void> setMeals4Pills(MealsForPillsWithAlt value) async {
    _m4p = value;
    await _shPrefs.setString(
      meals4PillsKey,
      json.encode(value.toJson(meals4PillsKey)),
    );
    value.resetModified();
    _callbackOnUpdate!();
  }
}
