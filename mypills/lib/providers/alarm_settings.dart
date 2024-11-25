// logging and debugging
// Dart base
// Flutter
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// Project files
import '../model/alarm_preferences.dart';
import '../model/weekly_time_table.dart';

//==============================================================================

/// A provider with simple object (int) parameters
/// and also a [WeeklyTimeTable]
/// It is used by [ConfigPreferences], but also by [BackgroundPreferences]
class AlarmSettings {
  //-------------------------static/constant------------------------------------

  static const alarmDurationSecondsKey = 'aDuration';
  static const alarmSnoozeSecondsKey = 'aSnooze';
  static const alarmRepeatTimesKey = 'aRepeat';
  static const weeklyTimeTableKey = 'wTimeTable';

  static String alarmJsonKey(int alarmId) => 'a$alarmId';

  //-----------------class state members and constructors ----------------------

  final SharedPreferencesAsync _shPrefs;
  final void Function()? callbackOnUpdate;
  late AlarmPreferences _data;
  late WeeklyTimeTable _wtt;
  bool initialized = false;

  AlarmSettings(this._shPrefs, this.callbackOnUpdate);

  //-----------------------class special members--------------------------------

  /// Initialize: read values from disk
  Future<void> init() async {
    if (!initialized) {
      await Future.wait([
        _shPrefs.getInt(alarmDurationSecondsKey),
        _shPrefs.getInt(alarmSnoozeSecondsKey),
        _shPrefs.getInt(alarmRepeatTimesKey),
      ]).then((results) {
        _data = AlarmPreferences(
          results[0] ?? AlarmPreferences.defaultAlarmDurationSeconds,
          results[1] ?? AlarmPreferences.defaultAlarmSnoozeSeconds,
          results[2] ?? AlarmPreferences.defaultAlarmRepeatTimes,
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

  /// AlarmPreferences values (read-only)
  ReadOnlyAlarmPreferences get data => _data.readOnlyValues;

  /// WeeklyTimeTable (times of meals and days of week for each time table)
  WeeklyTimeTable get wtt => _wtt;

  //-----------------------class rest of members--------------------------------

  /// wrapper of AlarmPreferences procedure
  bool isAlarmDurationSecondsInRange(int value) {
    return _data.isAlarmDurationSecondsInRange(value);
  }

  /// wrapper of AlarmPreferences procedure
  bool isAlarmSnoozeSecondsInRange(int value) {
    return _data.isAlarmSnoozeSecondsInRange(value);
  }

  /// wrapper of AlarmPreferences procedure
  bool isAlarmRepeatTimesInRange(int value) {
    return _data.isAlarmRepeatTimesInRange(value);
  }


  /// sets AlarmPreferences value and writes it to disk
  Future<void> setAlarmDurationSeconds(int value) async {
    _data.alarmDurationSeconds = value;
    await _shPrefs.setInt(alarmDurationSecondsKey, value);
    callbackOnUpdate!();
  }

  /// sets AlarmPreferences value and writes it to disk
  Future<void> setAlarmSnoozeSeconds(int value) async {
    _data.alarmSnoozeSeconds = value;
    await _shPrefs.setInt(alarmSnoozeSecondsKey, value);
    callbackOnUpdate!();
  }

  /// sets AlarmPreferences value and writes it to disk
  Future<void> setAlarmRepeatTimes(int value) async {
    _data.alarmRepeatTimes = value;
    await _shPrefs.setInt(alarmRepeatTimesKey, value);
    callbackOnUpdate!();
  }

  /// sets writes to disk the [WeeklyTimeTable]
  Future<void> setWeeklyTimeTable(WeeklyTimeTable value) async {
    _wtt = value;
    await _shPrefs.setString(weeklyTimeTableKey, json.encode(value.toJson()));
    callbackOnUpdate!();
  }
}
