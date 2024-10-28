/*
// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
*/
// // Dart base
// Flutter
import 'package:shared_preferences/shared_preferences.dart';
// Project files
import '../model/alarm_preferences.dart';

class AlarmSettings {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  late AlarmPreferences _data;

  Future<void> init() async {
    Future.wait([
      _prefs.getInt(AlarmPreferences.alarmDurationSecondsKey),
    ]).then((results) {
      _data = AlarmPreferences(
          results[0] ?? AlarmPreferences.defaultAlarmDurationSeconds);
    });
  }

  ReadOnlyAlarmPreferences get data => _data.readOnlyValues;

  set alarmDurationSeconds(int value) {
    _data.alarmDurationSeconds = value;
    _prefs.setInt(AlarmPreferences.alarmDurationSecondsKey, value);
  }
}
