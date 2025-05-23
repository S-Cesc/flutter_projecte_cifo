// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:convert';
// Flutter
import 'package:shared_preferences/shared_preferences.dart';
// Project files
import '../model/alarm.dart';
import '../model/general_preferences.dart';
import '../model/json_keys.dart';
import '../model/weekly_time_table.dart';
import 'general_settings.dart';

//==============================================================================

/// Singleton to use as data provider
/// It has a readonly AlarmSettings object
/// with an [GeneralPreferences] and a [WeeklyTimeTable],
/// and a cached [Alarm] object.
/// State changes are registered in the cached [Alarm] (updated to disk)
class BackgroundPreferences {
  //-------------------------static/constant------------------------------------

  static final BackgroundPreferences _backgroundPrefs =
      BackgroundPreferences._();

  //-----------------class state members and constructors ----------------------

  final SharedPreferencesAsync _shPrefs;
  late ReadOnlyGeneralSettings _generalSettings;

  Alarm? _currentAlarm;

  BackgroundPreferences._() : _shPrefs = SharedPreferencesAsync() {
    _generalSettings = ReadOnlyGeneralSettings(_shPrefs);
  }

  /// Instance creation: Get the singleton
  factory BackgroundPreferences() => _backgroundPrefs;

  //-----------------------class special members--------------------------------

  /// Initialize object
  Future<void> init() async {
    await _generalSettings.init();
  }

  /// Requery values from disk
  Future<void> requery() async {
    await _generalSettings.requery();
  }

  /// Force requery from disk of the cached [Alarm]
  Future<void> reloadCurrentAlarm() async {
    _currentAlarm = null;
  }

  //-----------------------class rest of members--------------------------------

  /// Access the depending [GeneralPreferences] object (readonly)
  ReadOnlyGeneralPreferences get alarmSettings => _generalSettings.data;

  /// Access the depending [WeeklyTimeTable] data
  WeeklyTimeTable get weeklyTimeTable => _generalSettings.wtt;

  /// The cached [Alarm]
  Future<Alarm?> currentAlarm(int alarmId) async {
    if (_currentAlarm?.id == alarmId) {
      return _currentAlarm;
    } else {
      final String key = JsonKeys.alarmJsonKey(alarmId);
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
  /// The changes done by the background service are only state changes.
  /// State changes are not async operations;
  /// just after the change the cached Alarm must be saved to disk.
  Future<void> storeChangedAlarm(int alarmId) async {
    if (_currentAlarm != null && _currentAlarm!.id == alarmId) {
      final Map<String, dynamic> jsonStructured = _currentAlarm!.toJson();
      await _shPrefs.setString(
        JsonKeys.alarmJsonKey(alarmId),
        jsonEncode(jsonStructured),
      );
    } else {
      developer.log(
        "Cached alarm $alarmId missed; state not updated!!",
        level: Level.WARNING.value,
      );
    }
  }
}
