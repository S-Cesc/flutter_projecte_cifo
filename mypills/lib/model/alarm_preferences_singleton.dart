/*
// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
*/
// // Dart base
// // Flutter
// Project files
import 'alarm_preferences.dart';

//Singleton for use in alarm screens
final class AlarmPreferencesSingleton {
  static late AlarmPreferencesSingleton _singleton;
  late ReadOnlyAlarmPreferences _alarmPreferences;

  AlarmPreferencesSingleton._(ReadOnlyAlarmPreferences instance) {
    _alarmPreferences = instance;
  }

  factory AlarmPreferencesSingleton.create(ReadOnlyAlarmPreferences instance) {
    return AlarmPreferencesSingleton._(instance);
  }

  factory AlarmPreferencesSingleton() {
    return _singleton;
  }

  ReadOnlyAlarmPreferences get data => _alarmPreferences;
}
