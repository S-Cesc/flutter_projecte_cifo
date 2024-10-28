/*
// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
*/
// // Dart base
// // Flutter
// // Project files


/* writable derived class has access to private setters */
base class ReadOnlyAlarmPreferences {
  int _alarmDurationSeconds;

  ReadOnlyAlarmPreferences(this._alarmDurationSeconds);

  int get alarmDurationSeconds => _alarmDurationSeconds;
}

//writable for use in configuration
final class AlarmPreferences extends ReadOnlyAlarmPreferences {
  static const defaultAlarmDurationSeconds = 600;
  static const alarmDurationSecondsKey = '';

  AlarmPreferences(super.alarmDurationSeconds);

  ReadOnlyAlarmPreferences get readOnlyValues =>
      this as ReadOnlyAlarmPreferences;

  set alarmDurationSeconds(int value) {
    super._alarmDurationSeconds = value;
  }
}
