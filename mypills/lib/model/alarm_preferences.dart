// logging and debugging
// Dart base
// Flutter
// Project files

//=======================================================================

/* writable derived class has access to private setters */
import 'package:flutter/foundation.dart';

/// Base class without setters
base class ReadOnlyAlarmPreferences {
  //-----------------class state members and constructors ----------------------
  int _alarmDurationSeconds;
  int _alarmSnoozeSeconds;
  int _alarmRepeatTimes;
  int _minutesToDealWithAlarm;

  int _minutesLongBefore;
  int _minutesBefore;
  int _minutesAfter;
  int _minutesLongAfter;

  /// Ctor
  ReadOnlyAlarmPreferences(
    this._alarmDurationSeconds,
    this._alarmSnoozeSeconds,
    this._alarmRepeatTimes,
    this._minutesToDealWithAlarm,
    this._minutesLongBefore,
    this._minutesBefore,
    this._minutesAfter,
    this._minutesLongAfter,
  );

  //-----------------------class rest of members--------------------------------

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get alarmDurationSeconds =>
      (_alarmDurationSeconds > AlarmPreferences.maxAlarmDurationSeconds ||
              _alarmDurationSeconds < AlarmPreferences.minAlarmDurationSeconds)
          ? AlarmPreferences.defaultAlarmDurationSeconds
          : _alarmDurationSeconds;

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get alarmSnoozeSeconds =>
      (_alarmSnoozeSeconds > AlarmPreferences.maxAlarmSnoozeSeconds ||
              _alarmSnoozeSeconds < AlarmPreferences.minAlarmSnoozeSeconds)
          ? AlarmPreferences.defaultAlarmSnoozeSeconds
          : _alarmSnoozeSeconds;

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get alarmRepeatTimes =>
      (_alarmRepeatTimes > AlarmPreferences.maxAlarmRepeatTimes ||
              _alarmRepeatTimes < AlarmPreferences.minAlarmRepeatTimes)
          ? AlarmPreferences.defaultAlarmRepeatTimes
          : _alarmRepeatTimes;

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get minutesToDealWithAlarm => (_minutesToDealWithAlarm >
              AlarmPreferences.maxMinutesToDealWithAlarm ||
          _minutesToDealWithAlarm < AlarmPreferences.minMinutesToDealWithAlarm)
      ? AlarmPreferences.defaultMinutesToDealWithAlarm
      : _minutesToDealWithAlarm;

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get minutesLongBefore =>
      (_minutesLongBefore > AlarmPreferences.maxMinutesLongAfterBefore ||
              _minutesLongBefore < AlarmPreferences.minMinutesLongAfterBefore)
          ? AlarmPreferences.defaultMinutesLongBefore
          : _minutesLongBefore;

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get minutesBefore =>
      (_minutesBefore > AlarmPreferences.maxMinutesAfterBefore ||
              _minutesBefore < AlarmPreferences.minMinutesAfterBefore)
          ? AlarmPreferences.defaultMinutesBefore
          : _minutesBefore;

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get minutesAfter =>
      (_minutesAfter > AlarmPreferences.maxMinutesAfterBefore ||
              _minutesAfter < AlarmPreferences.minMinutesAfterBefore)
          ? AlarmPreferences.defaultMinutesAfter
          : _minutesAfter;

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get minutesLongAfter => 
      (_minutesLongAfter > AlarmPreferences.maxMinutesLongAfterBefore ||
              _minutesLongAfter < AlarmPreferences.minMinutesLongAfterBefore)
          ? AlarmPreferences.defaultMinutesLongAfter
          : _minutesLongAfter;
}

/* ====================================================================== */
// Using same file for class extension allows to access private fields

/// Writable class for use in setting configuration
final class AlarmPreferences extends ReadOnlyAlarmPreferences {
  //-------------------------static/constant------------------------------------

  //-- Alarm settings --//

  /// min value alarm duration
  static const minAlarmDurationSeconds = kDebugMode ? 15 : 60;

  /// max value alarm duration
  static const maxAlarmDurationSeconds = kDebugMode ? 90 : 600;

  /// min value alarm snooze
  static const minAlarmSnoozeSeconds = maxAlarmDurationSeconds ~/ 2;

  /// max value alarm snooze
  static const maxAlarmSnoozeSeconds = maxAlarmDurationSeconds * 2;

  /// min value alarm repeat times
  static const minAlarmRepeatTimes = 1;

  /// max value alarm repeat times
  static const maxAlarmRepeatTimes = 5;

  /// min time to deal with alarm
  static const minMinutesToDealWithAlarm = 10;

  /// max time to deal with alarm
  static const maxMinutesToDealWithAlarm = 40;

  // defaults //

  /// default value alarm duration
  static const defaultAlarmDurationSeconds = kDebugMode ? 15 : 300;

  /// default value alarm snooze
  static const defaultAlarmSnoozeSeconds = kDebugMode ? 90 : 900;

  /// default value alarm repeat times
  static const defaultAlarmRepeatTimes = 3;

  /// default time to deal with alarm
  static const defaultMinutesToDealWithAlarm = 15;

  //-- After/Before time settings --//

  /// min value
  static const minMinutesLongAfterBefore = 90;

  /// max value
  static const maxMinutesLongAfterBefore = 150;

  /// min value
  static const minMinutesAfterBefore = 5;

  /// max value
  static const maxMinutesAfterBefore = 15;

  // defaults //

  /// default value
  static const defaultMinutesLongBefore = 90;

  /// default value
  static const defaultMinutesBefore = 7;

  /// default value
  static const defaultMinutesAfter = 5;

  /// default value
  static const defaultMinutesLongAfter = 90;

  //-----------------class state members and constructors ----------------------

  /// Ctor AlarmPreferences editable
  AlarmPreferences(
    super._alarmDurationSeconds,
    super._alarmSnoozeSeconds,
    super._alarmRepeatTimes,
    super._minutesToDealWithAlarm,
    super._minutesLongBefore,
    super._minutesBefore,
    super._minutesAfter,
    super._minutesLongAfter,
  );

  //-----------------------class special members--------------------------------

  /// A readonly copy, without setters
  ReadOnlyAlarmPreferences get readOnlyValues =>
      this as ReadOnlyAlarmPreferences;

  //-----------------------class rest of members--------------------------------

  /// Set configuration; [value] must be
  /// >= [minAlarmDurationSeconds] and
  /// <= [maxAlarmDurationSeconds]
  set alarmDurationSeconds(int value) {
    if (value >= minAlarmDurationSeconds && value <= maxAlarmDurationSeconds) {
      super._alarmDurationSeconds = value;
    } else {
      throw RangeError.range(
        value,
        minAlarmDurationSeconds,
        maxAlarmDurationSeconds,
      );
    }
  }

  /// Set configuration; [value] must be
  /// >= [minAlarmSnoozeSeconds] and
  /// <= [maxAlarmSnoozeSeconds]
  set alarmSnoozeSeconds(int value) {
    if (value >= minAlarmSnoozeSeconds && value <= maxAlarmSnoozeSeconds) {
      super._alarmSnoozeSeconds = value;
    } else {
      throw RangeError.range(
        value,
        maxAlarmDurationSeconds % 2,
        maxAlarmDurationSeconds,
      );
    }
  }

  /// Set configuration; [value] must be
  /// >= [minAlarmRepeatTimes] and
  /// <= [maxAlarmRepeatTimes]
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

  /// Set configuration; [value] must be
  /// >= [minMinutesToDealWithAlarm] and
  /// <= [maxMinutesToDealWithAlarm]
  set minutesToDealWithAlarm(int value) {
    if (value >= minMinutesToDealWithAlarm &&
        value <= maxMinutesToDealWithAlarm) {
      super._minutesToDealWithAlarm = value;
    } else {
      throw RangeError.range(
        value,
        minMinutesToDealWithAlarm,
        maxMinutesToDealWithAlarm,
      );
    }
  }

  /// Set configuration; [value] must be
  /// >= [minMinutesLongAfterBefore] and
  /// <= [maxMinutesLongAfterBefore]
  set minutesLongBefore(int value) {
    if (value >= minMinutesLongAfterBefore &&
        value <= maxMinutesLongAfterBefore) {
      super._minutesLongBefore = value;
    } else {
      throw RangeError.range(
        value,
        minMinutesLongAfterBefore,
        maxMinutesLongAfterBefore,
      );
    }
  }

  /// Set configuration; [value] must be
  /// >= [minMinutesAfterBefore] and
  /// <= [maxMinutesAfterBefore]
  set minutesBefore(int value) {
    if (value >= minMinutesAfterBefore && value <= maxMinutesAfterBefore) {
      super._minutesBefore = value;
    } else {
      throw RangeError.range(
        value,
        minMinutesAfterBefore,
        maxMinutesAfterBefore,
      );
    }
  }

  /// Set configuration; [value] must be
  /// >= [minMinutesAfterBefore] and
  /// <= [maxMinutesAfterBefore]
  set minutesAfter(int value) {
    if (value >= minMinutesAfterBefore && value <= maxMinutesAfterBefore) {
      super._minutesAfter = value;
    } else {
      throw RangeError.range(
        value,
        minMinutesAfterBefore,
        maxMinutesAfterBefore,
      );
    }
  }

  /// Set configuration; [value] must be
  /// >= [minMinutesLongAfterBefore] and
  /// <= [maxMinutesLongAfterBefore]
  set minutesLongAfter(int value) {
    if (value >= minMinutesLongAfterBefore &&
        value <= maxMinutesLongAfterBefore) {
      super._minutesLongAfter = value;
    } else {
      throw RangeError.range(
        value,
        minMinutesLongAfterBefore,
        maxMinutesLongAfterBefore,
      );
    }
  }
}
