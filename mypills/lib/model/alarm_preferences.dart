// logging and debugging
// Dart base
// Flutter
// Project files

//=======================================================================

/* writable derived class has access to private setters */
import 'package:flutter/foundation.dart';

base class ReadOnlyAlarmPreferences {
  //-----------------class state members and constructors ----------------------
  int _alarmDurationSeconds;
  int _alarmSnoozeSeconds;
  int _alarmRepeatTimes;

  ReadOnlyAlarmPreferences(
    this._alarmDurationSeconds,
    this._alarmSnoozeSeconds,
    this._alarmRepeatTimes,
  );

  //-----------------------class rest of members--------------------------------

  int get alarmDurationSeconds => _alarmDurationSeconds;
  int get alarmSnoozeSeconds => _alarmSnoozeSeconds;
  int get alarmRepeatTimes => _alarmRepeatTimes;
}

/* ====================================================================== */
// Using same file for class extension allows to access private fields

//writable for use in configuration
final class AlarmPreferences extends ReadOnlyAlarmPreferences {
  //-------------------------static/constant------------------------------------

  static const minAlarmDurationSeconds = kDebugMode ? 15 : 150;
  static const maxAlarmDurationSeconds = kDebugMode ? 90 : 900;
  static const minAlarmSnoozeSeconds = maxAlarmDurationSeconds ~/ 2;
  static const maxAlarmSnoozeSeconds = maxAlarmDurationSeconds;
  static const minAlarmRepeatTimes = 1;
  static const maxAlarmRepeatTimes = 5;

  static const defaultAlarmDurationSeconds = 600;
  static const defaultAlarmSnoozeSeconds = 900;
  static const defaultAlarmRepeatTimes = 3;

  //-----------------class state members and constructors ----------------------

  AlarmPreferences(
    super._alarmDurationSeconds,
    super._alarmSnoozeSeconds,
    super._alarmRepeatTimes,
  );

  //-----------------------class special members--------------------------------

  ReadOnlyAlarmPreferences get readOnlyValues =>
      this as ReadOnlyAlarmPreferences;

  //-----------------------class rest of members--------------------------------

  // Check before set
  bool isAlarmDurationSecondsInRange(int value) {
    return value >= minAlarmDurationSeconds && value <= maxAlarmDurationSeconds;
  }

  // Check before set
  bool isAlarmSnoozeSecondsInRange(int value) {
    return (value >= minAlarmSnoozeSeconds) && value <= maxAlarmSnoozeSeconds;
  }

  // Check before set
  bool isAlarmRepeatTimesInRange(int value) {
    return value >= minAlarmRepeatTimes && value <= maxAlarmRepeatTimes;
  }

  set alarmDurationSeconds(int value) {
    if (isAlarmDurationSecondsInRange(value)) {
      super._alarmDurationSeconds = value;
    } else {
      throw RangeError.range(
        value,
        minAlarmDurationSeconds,
        maxAlarmDurationSeconds,
      );
    }
  }

  set alarmSnoozeSeconds(int value) {
    if (isAlarmSnoozeSecondsInRange(value)) {
      super._alarmSnoozeSeconds = value;
    } else {
      throw RangeError.range(
        value,
        maxAlarmDurationSeconds % 2,
        maxAlarmDurationSeconds,
      );
    }
  }

  set alarmRepeatTimes(int value) {
    if (value >= minAlarmRepeatTimes && value <= maxAlarmRepeatTimes) {
      super._alarmRepeatTimes = value;
    } else {
      throw RangeError.range(
        value,
        minAlarmDurationSeconds,
        maxAlarmDurationSeconds,
      );
    }
  }
}
