// logging and debugging
// Dart base
// Flutter
import 'package:shared_preferences/shared_preferences.dart';
// Project files
import '../model/alarm_preferences.dart';

//==============================================================================

class AlarmSettings {
  //-------------------------static/constant------------------------------------

  static String alarmJsonKey(int alarmId) => 'a$alarmId';

  //-----------------class state members and constructors ----------------------

  final SharedPreferencesAsync _shPrefs;
  final void Function()? callbackOnUpdate;
  late AlarmPreferences _data;

  AlarmSettings(this._shPrefs, this.callbackOnUpdate);

  //-----------------------class special members--------------------------------

  Future<void> init() async {
    await Future.wait([
      _shPrefs.getInt(AlarmPreferences.alarmDurationSecondsKey),
      _shPrefs.getInt(AlarmPreferences.alarmSnoozeSecondsKey),
      _shPrefs.getInt(AlarmPreferences.alarmRepeatTimesKey),
    ]).then((results) {
      _data = AlarmPreferences(
        results[0] ?? AlarmPreferences.defaultAlarmDurationSeconds,
        results[1] ?? AlarmPreferences.defaultAlarmSnoozeSeconds,
        results[2] ?? AlarmPreferences.defaultAlarmRepeatTimes,
      );
    });
  }

  ReadOnlyAlarmPreferences get data => _data.readOnlyValues;

  //-----------------------class rest of members--------------------------------

  Future<void> setAlarmDurationSeconds(int value) async {
    _data.alarmDurationSeconds = value;
    await _shPrefs.setInt(AlarmPreferences.alarmDurationSecondsKey, value);
    callbackOnUpdate!();
  }

  Future<void> setAlarmSnoozeSeconds(int value) async {
    _data.alarmSnoozeSeconds = value;
    await _shPrefs.setInt(AlarmPreferences.alarmSnoozeSecondsKey, value);
    callbackOnUpdate!();
  }

  Future<void> setAlarmRepeatTimes(int value) async {
    _data.alarmRepeatTimes = value;
    await _shPrefs.setInt(AlarmPreferences.alarmRepeatTimesKey, value);
    callbackOnUpdate!();
  }

}
