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

  int get alarmDurationSeconds => _alarmDurationSeconds;
  int get alarmSnoozeSeconds => _alarmSnoozeSeconds;
  int get alarmRepeatTimes => _alarmRepeatTimes;
  int get minutesToDealWithAlarm => _minutesToDealWithAlarm;
  int get minutesLongBefore => _minutesLongBefore;
  int get minutesBefore => _minutesBefore;
  int get minutesAfter => _minutesAfter;
  int get minutesLongAfter => _minutesLongAfter;
}

/* ====================================================================== */
// Using same file for class extension allows to access private fields

/// Writable class for use in setting configuration
final class AlarmPreferences extends ReadOnlyAlarmPreferences {
  //-------------------------static/constant------------------------------------

  static const minAlarmDurationSeconds = kDebugMode ? 15 : 60;
  static const maxAlarmDurationSeconds = kDebugMode ? 90 : 600;
  static const minAlarmSnoozeSeconds = maxAlarmDurationSeconds ~/ 2;
  static const maxAlarmSnoozeSeconds = maxAlarmDurationSeconds * 2;
  static const minAlarmRepeatTimes = 1;
  static const maxAlarmRepeatTimes = 5;
  static const minMinutesToDealWithAlarm = 10;
  static const maxMinutesToDealWithAlarm = 40;

  static const defaultAlarmDurationSeconds = kDebugMode ? 15 : 300;
  static const defaultAlarmSnoozeSeconds = kDebugMode ? 90 : 900;
  static const defaultAlarmRepeatTimes = 3;
  static const defaultMinutesToDealWithAlarm = 15;

  static const minMinutesLongAfterBefore = 90;
  static const maxMinutesLongAfterBefore = 150;
  static const minMinutesAfterBefore = 5;
  static const maxMinutesAfterBefore = 15;

  static const defaultMinutesLongBefore = 90;
  static const defaultMinutesBefore = 7;
  static const defaultMinutesAfter = 5;
  static const defaultMinutesLongAfter = 90;

  //-----------------class state members and constructors ----------------------

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
