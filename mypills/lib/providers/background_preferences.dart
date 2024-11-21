/*
// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
*/
// Dart base
import 'dart:convert';
// Flutter
import 'package:flutter_projecte_cifo/model/weekly_time_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Project files
import '../model/alarm.dart';
import '../model/alarm_preferences.dart';
import 'alarm_settings.dart';

//==============================================================================

class BackgroundPreferences {
  //-------------------------static/constant------------------------------------

  static final BackgroundPreferences _backgroundPrefs =
      BackgroundPreferences._();

  //-----------------class state members and constructors ----------------------

  final SharedPreferencesAsync _shPrefs;
  late AlarmSettings _alarmSettings;

  Alarm? _currentAlarm;

  BackgroundPreferences._() : _shPrefs = SharedPreferencesAsync() {
    _alarmSettings = AlarmSettings(_shPrefs, null);
  }

  factory BackgroundPreferences() => _backgroundPrefs;

  //-----------------------class special members--------------------------------

  Future<void> init() async {
    await _alarmSettings.init();
  }

  Future<void> requery() async {
    await _alarmSettings.requery();
  }

  Future<void> reloadCurrentAlarm() async {
    _currentAlarm = null;
  }

  //-----------------------class rest of members--------------------------------

  ReadOnlyAlarmPreferences get alarmSettings => _alarmSettings.data;
  WeeklyTimeTable get weeklyTimeTable => _alarmSettings.wtt;

  Future<Alarm?> currentAlarm(int alarmId) async {
    if (_currentAlarm?.id == alarmId) {
      return _currentAlarm;
    } else {
      final String key = AlarmSettings.alarmJsonKey(alarmId);
      final json = await _shPrefs.getString(key);
      if (json != null) {
        try {
          final Map<String, dynamic> decodedJson =
              jsonDecode(json) as Map<String, dynamic>;
          _currentAlarm = Alarm.fromJson(decodedJson);
          return _currentAlarm;
        } catch (e) {
          return null;
        }
      } else {
        return null;
      }
    }
  }

  Future<void> storeChangedAlarm(int alarmId) async {
    if (_currentAlarm != null && _currentAlarm!.id == alarmId) {
      final Map<String, dynamic> jsonStructured = _currentAlarm!.toJson();
      await _shPrefs.setString(
          AlarmSettings.alarmJsonKey(alarmId), jsonEncode(jsonStructured));
    }
  }
}
