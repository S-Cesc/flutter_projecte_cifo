// logging and debugging
// Dart base
// Flutter
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// Project files
import '../model/alarm_preferences.dart';
import '../model/weekly_time_table.dart';

//==============================================================================

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

  Future<void> requery() async {
    initialized = false;
    await init();
    callbackOnUpdate?.call();
  }

  ReadOnlyAlarmPreferences get data => _data.readOnlyValues;
  WeeklyTimeTable get wtt => _wtt;

  //-----------------------class rest of members--------------------------------

  Future<void> setAlarmDurationSeconds(int value) async {
    _data.alarmDurationSeconds = value;
    await _shPrefs.setInt(alarmDurationSecondsKey, value);
    callbackOnUpdate!();
  }

  Future<void> setAlarmSnoozeSeconds(int value) async {
    _data.alarmSnoozeSeconds = value;
    await _shPrefs.setInt(alarmSnoozeSecondsKey, value);
    callbackOnUpdate!();
  }

  Future<void> setAlarmRepeatTimes(int value) async {
    _data.alarmRepeatTimes = value;
    await _shPrefs.setInt(alarmRepeatTimesKey, value);
    callbackOnUpdate!();
  }

  Future<void> setWeeklyTimeTable(WeeklyTimeTable value) async {
    _wtt = value;
    await _shPrefs.setString(weeklyTimeTableKey, json.encode(value.toJson()));
    callbackOnUpdate!();
  }
}
