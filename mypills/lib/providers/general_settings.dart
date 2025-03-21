// logging and debugging
// Dart base
import 'dart:convert';
// Flutter
import 'package:flutter/material.dart' show protected;
import 'package:shared_preferences/shared_preferences.dart';
// Project files
import '../model/json_keys.dart';
import '../model/general_preferences.dart';
import '../model/meals_for_pills.dart';
import '../model/weekly_time_table.dart';

//==============================================================================

/// Access to persistent data on shared_preferences
/// A provider with simple object (int) parameters
/// and also a [WeeklyTimeTable]
/// It is used by [ConfigPreferences], but also by [BackgroundPreferences]
class ReadOnlyGeneralSettings {
  //-------------------------static/constant------------------------------------


  //-----------------class state members and constructors ----------------------

  final SharedPreferencesAsync _shPrefs;

  /// Function called on data update
  /// It allows call to NotifyListeners
  /// The read-only version does not use it, so it is always null
  /// But the read/write from/to disk functions call it when it's not null
  final void Function()? _onChanged;

  late final ReadOnlyGeneralPreferences _data;
  late final WeeklyTimeTable _wtt;
  late final MealsForPillsWithAlt _m4p;
  bool _initialized = false;

  /// Ctor
  /// Note _callbackOnUpdate is only needed when editing the data
  ReadOnlyGeneralSettings(SharedPreferencesAsync shPrefs)
    : _shPrefs = shPrefs,
      _onChanged = null;

  @protected
  ReadOnlyGeneralSettings._(
    SharedPreferencesAsync shPrefs, {
    required void Function() onChanged,
  }) : _shPrefs = shPrefs,
       _onChanged = onChanged;

  //-----------------------class special members--------------------------------

  /// Initialize: read values from disk
  Future<void> init() async {
    if (!_initialized) {
      _data = ReadOnlyGeneralPreferences.create(
        await _readGeneralPreferencesData(),
      );
      await _initModel();
      _initialized = true;
    }
  }

  @protected
  Future<List<int?>> _readGeneralPreferencesData() async {
    List<int?> result = await Future.wait([
      _shPrefs.getInt(JsonKeys.alarmDurationSecondsKey),
      _shPrefs.getInt(JsonKeys.alarmSnoozeSecondsKey),
      _shPrefs.getInt(JsonKeys.alarmRepeatTimesKey),
      _shPrefs.getInt(JsonKeys.minutesToDealWithAlarmKey),
      _shPrefs.getInt(JsonKeys.longBeforeMealKey),
      _shPrefs.getInt(JsonKeys.beforeMealKey),
      _shPrefs.getInt(JsonKeys.afterMealKey),
      _shPrefs.getInt(JsonKeys.longAfterMealKey),
      _shPrefs.getInt(JsonKeys.breakfastMinMinKey),
      _shPrefs.getInt(JsonKeys.breakfastMaxMinKey),
      _shPrefs.getInt(JsonKeys.elevensesMinMinKey),
      _shPrefs.getInt(JsonKeys.elevensesMaxMinKey),
      _shPrefs.getInt(JsonKeys.brunchMinMinKey),
      _shPrefs.getInt(JsonKeys.brunchMaxMinKey),
      _shPrefs.getInt(JsonKeys.lunchMinMinKey),
      _shPrefs.getInt(JsonKeys.lunchMaxMinKey),
      _shPrefs.getInt(JsonKeys.teaMinMinKey),
      _shPrefs.getInt(JsonKeys.teaMaxMinKey),
      _shPrefs.getInt(JsonKeys.highTeaMinMinKey),
      _shPrefs.getInt(JsonKeys.highTeaMaxMinKey),
      _shPrefs.getInt(JsonKeys.dinnerMinMinKey),
      _shPrefs.getInt(JsonKeys.dinnerMaxMinKey),
      _shPrefs.getInt(JsonKeys.supperMinMinKey),
      _shPrefs.getInt(JsonKeys.supperMaxMinKey),
    ]).then((values) {
      return values;
    });
    return result;
  }

  @protected
  Future<void> _initModel() async {
    try {
      // WeeklyTimeTable uses an edit provider
      // we can create a readonly instance
      final String? strWtt = await _shPrefs.getString(
        JsonKeys.weeklyTimeTableKey,
      );
      if (strWtt != null) {
        final parsedJson = json.decode(strWtt) as Map<String, dynamic>;
        _wtt = WeeklyTimeTable.fromJson(data, parsedJson);
      } else {
        _wtt = WeeklyTimeTable.empty(data);
      }
    } catch (e) {
      _wtt = WeeklyTimeTable.empty(data);
    }
    // TODO: Meals4Pils must use an edit provider
    // so we can create a readonly instance
    try {
      final String? strM4p = await _shPrefs.getString(JsonKeys.meals4PillsKey);
      if (strM4p != null) {
        final parsedJson = json.decode(strM4p) as Map<String, dynamic>;
        _m4p = MealsForPillsWithAlt.fromJson(
          null,
          JsonKeys.meals4PillsKey,
          parsedJson,
        );
      } else {
        _m4p = MealsForPillsWithAlt(null);
      }
    } catch (e) {
      _m4p = MealsForPillsWithAlt(null);
    }
  }

  /// sets writes to disk the [WeeklyTimeTable] data
  Future<void> setWeeklyTimeTable(WeeklyTimeTable value) async {
    _wtt.copyValues(value);
    await _shPrefs.setString(
      JsonKeys.weeklyTimeTableKey,
      json.encode(value.toJson()),
    );
    value.resetModified();
    _onChanged?.call();
  }

  /// Requery values from disk. Used for
  /// - Get cached updated values from the Background Alarms
  /// - Undo changes in ConfigPreferences editing
  Future<void> requery() async {
    _initialized = false;
    await init();
    _onChanged?.call();
  }

  /// GeneralPreferences values (read-only)
  ReadOnlyGeneralPreferences get data => _data;

  /// WeeklyTimeTable (times of meals and days of week for each time table)
  WeeklyTimeTable get wtt => _wtt;

  /// Meals for pils (meals associated with taking pills)
  MealsForPillsWithAlt get m4p => _m4p;

  //-------- end class ---------------------------------------------------------
}

//==============================================================================
//------------------------------------------------------------------------------
//-------------- UPDATABLE VERSION ---------------------------------------------
//------------------------------------------------------------------------------
//==============================================================================
//     Using same file for class extension allows to access private fields =====
//==============================================================================

/// Editable version of [ReadOnlyGeneralSettings]
class GeneralSettings extends ReadOnlyGeneralSettings {
  //
  // -----------------------class state members and constructors ---------------
  //

  /// Ctor
  /// Note _callbackOnUpdate is only needed when editing the data
  GeneralSettings(super.shPrefs, void Function() onChanged)
    : super._(onChanged: onChanged);

  /// Ctor
  GeneralSettings.copy(ReadOnlyGeneralSettings gs, void Function() onChanged)
    : super._(gs._shPrefs, onChanged: onChanged) {
    _data = gs._data;
    _wtt = gs._wtt;
    _m4p = gs._m4p;
    _initialized = gs._initialized;
  }

  //-----------------------class special members--------------------------------

  /// Initialize: read values from disk
  @override
  Future<void> init() async {
    if (!_initialized) {
      _data = GeneralPreferences.create(await _readGeneralPreferencesData());
      await _initModel();
      _initialized = true;
    }
  }

  /// Get the GeneralPreferences data
  @override
  GeneralPreferences get _data => super._data as GeneralPreferences;

  //-----------------------class rest of members--------------------------------

  /// sets the alarm setting and writes it to disk
  Future<void> setAlarmDurationSeconds(int value) async {
    _data.alarmDurationSeconds = value;
    await _shPrefs.setInt(JsonKeys.alarmDurationSecondsKey, value);
    _onChanged!();
  }

  /// sets the alarm setting and writes it to disk
  Future<void> setAlarmSnoozeSeconds(int value) async {
    _data.alarmSnoozeSeconds = value;
    await _shPrefs.setInt(JsonKeys.alarmSnoozeSecondsKey, value);
    _onChanged!();
  }

  /// sets the alarm setting and writes it to disk
  Future<void> setAlarmRepeatTimes(int value) async {
    _data.alarmRepeatTimes = value;
    await _shPrefs.setInt(JsonKeys.alarmRepeatTimesKey, value);
    _onChanged!();
  }

  /// sets the alarm setting and writes it to disk
  Future<void> setMinutesToDealWithAlarm(int value) async {
    _data.minutesToDealWithAlarm = value;
    await _shPrefs.setInt(JsonKeys.minutesToDealWithAlarmKey, value);
    _onChanged!();
  }

  // ----- //

  /// sets meal pill time value and writes it to disk
  Future<void> setMinutesLongBeforeMeal(int value) async {
    _data.minutesLongBefore = value;
    await _shPrefs.setInt(JsonKeys.longBeforeMealKey, value);
    _onChanged!();
  }

  /// sets meal pill time value and writes it to disk
  Future<void> setMinutesBeforeMeal(int value) async {
    _data.minutesBefore = value;
    await _shPrefs.setInt(JsonKeys.beforeMealKey, value);
    _onChanged!();
  }

  /// sets meal pill time value and writes it to disk
  Future<void> setMinutesAfterMeal(int value) async {
    _data.minutesAfter = value;
    await _shPrefs.setInt(JsonKeys.afterMealKey, value);
    _onChanged!();
  }

  /// sets meal pill time value and writes it to disk
  Future<void> setMinutesLongAfterMeal(int value) async {
    _data.minutesLongAfter = value;
    await _shPrefs.setInt(JsonKeys.longAfterMealKey, value);
    _onChanged!();
  }

  // ----- //

  /// sets the meal duration and writes it to disk
  Future<void> setBreakfastMinutes((int, int) value) async {
    _data.breakfastMinutes = value;
    await _shPrefs.setInt(JsonKeys.breakfastMinMinKey, value.$1);
    await _shPrefs.setInt(JsonKeys.breakfastMaxMinKey, value.$2);
    _onChanged!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setElevensesMinutes((int, int) value) async {
    _data.elevensesMinutes = value;
    await _shPrefs.setInt(JsonKeys.elevensesMinMinKey, value.$1);
    await _shPrefs.setInt(JsonKeys.elevensesMaxMinKey, value.$2);
    _onChanged!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setBrunchMinutes((int, int) value) async {
    _data.brunchMinutes = value;
    await _shPrefs.setInt(JsonKeys.brunchMinMinKey, value.$1);
    await _shPrefs.setInt(JsonKeys.brunchMaxMinKey, value.$2);
    _onChanged!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setLunchMinutes((int, int) value) async {
    _data.lunchMinutes = value;
    await _shPrefs.setInt(JsonKeys.lunchMinMinKey, value.$1);
    await _shPrefs.setInt(JsonKeys.lunchMaxMinKey, value.$2);
    _onChanged!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setTeaMinutes((int, int) value) async {
    _data.teaMinutes = value;
    await _shPrefs.setInt(JsonKeys.teaMinMinKey, value.$1);
    await _shPrefs.setInt(JsonKeys.teaMaxMinKey, value.$2);
    _onChanged!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setHighTeaMinutes((int, int) value) async {
    _data.highTeaMinutes = value;
    await _shPrefs.setInt(JsonKeys.highTeaMinMinKey, value.$1);
    await _shPrefs.setInt(JsonKeys.highTeaMaxMinKey, value.$2);
    _onChanged!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setDinnerMinutes((int, int) value) async {
    _data.dinnerMinutes = value;
    await _shPrefs.setInt(JsonKeys.dinnerMinMinKey, value.$1);
    await _shPrefs.setInt(JsonKeys.dinnerMaxMinKey, value.$2);
    _onChanged!();
  }

  /// sets the meal duration and writes it to disk
  Future<void> setSupperMinutes((int, int) value) async {
    _data.supperMinutes = value;
    await _shPrefs.setInt(JsonKeys.supperMinMinKey, value.$1);
    await _shPrefs.setInt(JsonKeys.supperMaxMinKey, value.$2);
    _onChanged!();
  }

  // ----- //

  /// sets writes to disk the [MealsForPills] data
  Future<void> setMeals4Pills(MealsForPillsWithAlt value) async {
    _m4p = value;
    await _shPrefs.setString(
      JsonKeys.meals4PillsKey,
      json.encode(value.toJson(JsonKeys.meals4PillsKey)),
    );
    value.resetModified();
    _onChanged!();
  }
}
