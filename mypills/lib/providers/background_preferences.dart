// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
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

/// Singleton to use as data provider
/// It has a readonly AlarmSettings object
/// with an [AlarmPreferences] and a [WeeklyTimeTable],
/// and a cached [Alarm] object.
/// State changes are registered in the cached [Alarm] (updated to disk)
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

  /// Initialize object
  Future<void> init() async {
    await _alarmSettings.init();
  }

  /// Requery values from disk
  Future<void> requery() async {
    await _alarmSettings.requery();
  }

  /// Force requery from disk of the cached [Alarm]
  Future<void> reloadCurrentAlarm() async {
    _currentAlarm = null;
  }

  //-----------------------class rest of members--------------------------------

  /// Access the depending [AlarmPreferences] object (readonly)
  ReadOnlyAlarmPreferences get alarmSettings => _alarmSettings.data;

  /// [WeeklyTimeTable] data
  WeeklyTimeTable get weeklyTimeTable => _alarmSettings.wtt;

  /// The cached [Alarm]
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

  /// Update the cached [Alarm]
  /// The changes done by the background service are only state changes
  /// State changes are not async operations;
  /// just after the change the cached Alarm must be saved to disk
  Future<void> storeChangedAlarm(int alarmId) async {
    if (_currentAlarm != null && _currentAlarm!.id == alarmId) {
      final Map<String, dynamic> jsonStructured = _currentAlarm!.toJson();
      await _shPrefs.setString(
          AlarmSettings.alarmJsonKey(alarmId), jsonEncode(jsonStructured));
    } else {
      developer.log("Cached alarm $alarmId missed; state not updated!!",
          level: Level.WARNING.value);
    }
  }
}
