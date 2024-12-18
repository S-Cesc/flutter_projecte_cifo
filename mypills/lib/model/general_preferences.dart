// logging and debugging
// Dart base
// Flutter
// Project files

//=======================================================================

/* writable derived class has access to private setters */
import 'package:flutter/foundation.dart';

import 'meal.dart';

/// Base class without setters
base class ReadOnlyGeneralPreferences {
  //-----------------class state members and constructors ----------------------
  int _alarmDurationSeconds;
  int _alarmSnoozeSeconds;
  int _alarmRepeatTimes;
  int _minutesToDealWithAlarm;

  int _minutesLongBefore;
  int _minutesBefore;
  int _minutesAfter;
  int _minutesLongAfter;

  int _breakfastMinutes;
  int _brunchMinutes;
  int _lunchMinutes;
  int _teaMinutes;
  int _highTeaMinutes;
  int _dinnerMinutes;
  int _supperMinutes;

  /// Ctor
  ReadOnlyGeneralPreferences(
    this._alarmDurationSeconds,
    this._alarmSnoozeSeconds,
    this._alarmRepeatTimes,
    this._minutesToDealWithAlarm,
    this._minutesLongBefore,
    this._minutesBefore,
    this._minutesAfter,
    this._minutesLongAfter,
    this._breakfastMinutes,
    this._brunchMinutes,
    this._lunchMinutes,
    this._teaMinutes,
    this._highTeaMinutes,
    this._dinnerMinutes,
    this._supperMinutes,
  );

  //-----------------------class rest of members--------------------------------

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get alarmDurationSeconds => (_alarmDurationSeconds >
              GeneralPreferences.maxAlarmDurationSeconds ||
          _alarmDurationSeconds < GeneralPreferences.minAlarmDurationSeconds)
      ? GeneralPreferences.defaultAlarmDurationSeconds
      : _alarmDurationSeconds;

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get alarmSnoozeSeconds =>
      (_alarmSnoozeSeconds > GeneralPreferences.maxAlarmSnoozeSeconds ||
              _alarmSnoozeSeconds < GeneralPreferences.minAlarmSnoozeSeconds)
          ? GeneralPreferences.defaultAlarmSnoozeSeconds
          : _alarmSnoozeSeconds;

  /// alarm repeat times
  int get alarmRepeatTimes => _alarmRepeatTimes;

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get minutesToDealWithAlarm =>
      (_minutesToDealWithAlarm > GeneralPreferences.maxMinutesToDealWithAlarm ||
              _minutesToDealWithAlarm <
                  GeneralPreferences.minMinutesToDealWithAlarm)
          ? GeneralPreferences.defaultMinutesToDealWithAlarm
          : _minutesToDealWithAlarm;

  // ------ //

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get minutesLongBefore =>
      (_minutesLongBefore > GeneralPreferences.maxMinutesLongAfterBefore ||
              _minutesLongBefore < GeneralPreferences.minMinutesLongAfterBefore)
          ? GeneralPreferences.defaultMinutesLongBefore
          : _minutesLongBefore;

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get minutesBefore =>
      (_minutesBefore > GeneralPreferences.maxMinutesAfterBefore ||
              _minutesBefore < GeneralPreferences.minMinutesAfterBefore)
          ? GeneralPreferences.defaultMinutesBefore
          : _minutesBefore;

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get minutesAfter =>
      (_minutesAfter > GeneralPreferences.maxMinutesAfterBefore ||
              _minutesAfter < GeneralPreferences.minMinutesAfterBefore)
          ? GeneralPreferences.defaultMinutesAfter
          : _minutesAfter;

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get minutesLongAfter =>
      (_minutesLongAfter > GeneralPreferences.maxMinutesLongAfterBefore ||
              _minutesLongAfter < GeneralPreferences.minMinutesLongAfterBefore)
          ? GeneralPreferences.defaultMinutesLongAfter
          : _minutesLongAfter;

  // ------ //

  /// Brekfast duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get breakfastMinutes =>
      (_breakfastMinutes > GeneralPreferences.maxMealDurationMinutes ||
              _breakfastMinutes < GeneralPreferences.minMealDurationMinutes)
          ? Meal.defaultMealDuration(Meal.breakfast).inMinutes
          : _breakfastMinutes;

  /// Brunch duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get brunchMinutes =>
      (_brunchMinutes > GeneralPreferences.maxMealDurationMinutes ||
              _brunchMinutes < GeneralPreferences.minMealDurationMinutes)
          ? Meal.defaultMealDuration(Meal.brunch).inMinutes
          : _brunchMinutes;

  /// Lunch duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get lunchMinutes =>
      (_lunchMinutes > GeneralPreferences.maxMealDurationMinutes ||
              _lunchMinutes < GeneralPreferences.minMealDurationMinutes)
          ? Meal.defaultMealDuration(Meal.lunch).inMinutes
          : _lunchMinutes;

  /// Tea duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get teaMinutes =>
      (_teaMinutes > GeneralPreferences.maxMealDurationMinutes ||
              _teaMinutes < GeneralPreferences.minMealDurationMinutes)
          ? Meal.defaultMealDuration(Meal.tea).inMinutes
          : _teaMinutes;

  /// High tea duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get highTeaMinutes =>
      (_highTeaMinutes > GeneralPreferences.maxMealDurationMinutes ||
              _highTeaMinutes < GeneralPreferences.minMealDurationMinutes)
          ? Meal.defaultMealDuration(Meal.highTea).inMinutes
          : _highTeaMinutes;

  /// Dinner duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get dinnerMinutes =>
      (_dinnerMinutes > GeneralPreferences.maxMealDurationMinutes ||
              _dinnerMinutes < GeneralPreferences.minMealDurationMinutes)
          ? Meal.defaultMealDuration(Meal.dinner).inMinutes
          : _dinnerMinutes;

  /// Supper duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get supperMinutes =>
      (_supperMinutes > GeneralPreferences.maxMealDurationMinutes ||
              _supperMinutes < GeneralPreferences.minMealDurationMinutes)
          ? Meal.defaultMealDuration(Meal.supper).inMinutes
          : _supperMinutes;
}

/* ====================================================================== */
// Using same file for class extension allows to access private fields

/// Writable class for use in setting configuration
final class GeneralPreferences extends ReadOnlyGeneralPreferences {
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

  //-- Meal durations settings --//

  /// min value
  static const minMealDurationMinutes = 5;

  /// max value
  static const maxMealDurationMinutes = 120;

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
  GeneralPreferences(
    super._alarmDurationSeconds,
    super._alarmSnoozeSeconds,
    super._alarmRepeatTimes,
    super._minutesToDealWithAlarm,
    super._minutesLongBefore,
    super._minutesBefore,
    super._minutesAfter,
    super._minutesLongAfter,
    super._breakfastMinutes,
    super._brunchMinutes,
    super._lunchMinutes,
    super._teaMinutes,
    super._highTeaMinutes,
    super._dinnerMinutes,
    super._supperMinutes,
  );

  //-----------------------class special members--------------------------------

  /// A readonly copy, without setters
  ReadOnlyGeneralPreferences get readOnlyValues =>
      this as ReadOnlyGeneralPreferences;

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
        minAlarmSnoozeSeconds,
        maxAlarmSnoozeSeconds,
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
        minAlarmRepeatTimes,
        maxAlarmRepeatTimes,
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

  /// Set configuration; [value] must be
  /// >= [minMealDurationMinutes] and
  /// <= [maxMealDurationMinutes]
  set breakfastMinutes(int value) {
    if (value >= minMealDurationMinutes && value <= maxMealDurationMinutes) {
      super._breakfastMinutes = value;
    } else {
      throw RangeError.range(
        value,
        minMealDurationMinutes,
        maxMealDurationMinutes,
      );
    }
  }

  /// Set configuration; [value] must be
  /// >= [minMealDurationMinutes] and
  /// <= [maxMealDurationMinutes]
  set brunchMinutes(int value) {
    if (value >= minMealDurationMinutes && value <= maxMealDurationMinutes) {
      super._brunchMinutes = value;
    } else {
      throw RangeError.range(
        value,
        minMealDurationMinutes,
        maxMealDurationMinutes,
      );
    }
  }

  /// Set configuration; [value] must be
  /// >= [minMealDurationMinutes] and
  /// <= [maxMealDurationMinutes]
  set lunchMinutes(int value) {
    if (value >= minMealDurationMinutes && value <= maxMealDurationMinutes) {
      super._lunchMinutes = value;
    } else {
      throw RangeError.range(
        value,
        minMealDurationMinutes,
        maxMealDurationMinutes,
      );
    }
  }

  /// Set configuration; [value] must be
  /// >= [minMealDurationMinutes] and
  /// <= [maxMealDurationMinutes]
  set teaMinutes(int value) {
    if (value >= minMealDurationMinutes && value <= maxMealDurationMinutes) {
      super._teaMinutes = value;
    } else {
      throw RangeError.range(
        value,
        minMealDurationMinutes,
        maxMealDurationMinutes,
      );
    }
  }

  /// Set configuration; [value] must be
  /// >= [minMealDurationMinutes] and
  /// <= [maxMealDurationMinutes]
  set highTeaMinutes(int value) {
    if (value >= minMealDurationMinutes && value <= maxMealDurationMinutes) {
      super._highTeaMinutes = value;
    } else {
      throw RangeError.range(
        value,
        minMealDurationMinutes,
        maxMealDurationMinutes,
      );
    }
  }

  /// Set configuration; [value] must be
  /// >= [minMealDurationMinutes] and
  /// <= [maxMealDurationMinutes]
  set dinnerMinutes(int value) {
    if (value >= minMealDurationMinutes && value <= maxMealDurationMinutes) {
      super._dinnerMinutes = value;
    } else {
      throw RangeError.range(
        value,
        minMealDurationMinutes,
        maxMealDurationMinutes,
      );
    }
  }

  /// Set configuration; [value] must be
  /// >= [minMealDurationMinutes] and
  /// <= [maxMealDurationMinutes]
  set supperMinutes(int value) {
    if (value >= minMealDurationMinutes && value <= maxMealDurationMinutes) {
      super._supperMinutes = value;
    } else {
      throw RangeError.range(
        value,
        minMealDurationMinutes,
        maxMealDurationMinutes,
      );
    }
  }
}
