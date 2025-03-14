// logging and debugging
// Dart base
// Flutter
// Project files

//=======================================================================

/* writable derived class has access to private setters */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'enum/speed_label.dart';
import 'enum/meal.dart';

/// Parameters for the general configuration of the application
/// Base class without setters (readonly)
base class ReadOnlyGeneralPreferences {
  //
  //----------------------------------------------------------------------------
  //-----------------class state members and constructors ----------------------

  int _alarmDurationSeconds;
  int _alarmSnoozeSeconds;
  int _alarmRepeatTimes;
  int _minutesToDealWithAlarm;

  int _minutesLongBefore;
  int _minutesBefore;
  int _minutesAfter;
  int _minutesLongAfter;

  (int, int) _breakfastMinutes;
  (int, int) _elevensesMinutes;
  (int, int) _brunchMinutes;
  (int, int) _lunchMinutes;
  (int, int) _teaMinutes;
  (int, int) _highTeaMinutes;
  (int, int) _dinnerMinutes;
  (int, int) _supperMinutes;

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
    this._elevensesMinutes,
    this._brunchMinutes,
    this._lunchMinutes,
    this._teaMinutes,
    this._highTeaMinutes,
    this._dinnerMinutes,
    this._supperMinutes,
  );

  //----------------------------------------------------------------------------
  //-----------------------class rest of members--------------------------------

  //-- (1) Alarm settings --//

  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get alarmDurationSeconds =>
      (_alarmDurationSeconds > GeneralPreferences.maxAlarmDurationSeconds ||
              _alarmDurationSeconds <
                  GeneralPreferences.minAlarmDurationSeconds)
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

  //-- (2) After/Before time settings --//

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

  //-- (3) Meal durations settings --//

  /// Brekfast duration
  (int, int) get breakfastMinutes => (
    _minBreakfastMinutes,
    _maxBreakfastMinutes,
  );

  /// Elevenses duration
  (int, int) get elevensesMinutes => (
    _minElevensesMinutes,
    _maxElevensesMinutes,
  );

  /// Brunch duration
  (int, int) get brunchMinutes => (_minBrunchMinutes, _maxBrunchMinutes);

  /// Lunch duration
  (int, int) get lunchMinutes => (_minLunchMinutes, _maxLunchMinutes);

  /// Tea duration
  (int, int) get teaMinutes => (_minTeaMinutes, _maxTeaMinutes);

  /// High tea duration
  (int, int) get highTeaMinutes => (_minHighTeaMinutes, _maxHighTeaMinutes);

  /// Dinner duration
  (int, int) get dinnerMinutes => (_minDinnerMinutes, _maxDinnerMinutes);

  /// Supper duration
  (int, int) get supperMinutes => (_minSupperMinutes, _maxSupperMinutes);

  //-- ...Meal duration

  /// returns the duration of a meal,
  /// depending on the user selected [speed]
  Duration getMealDuration(Meal meal, SpeedLabel speed) {
    return switch (meal) {
      Meal.breakfast => (switch (speed) {
        SpeedLabel.fast => Duration(minutes: _minBreakfastMinutes),
        SpeedLabel.medium => Duration(minutes: _meanBreakfastMinutes),
        SpeedLabel.slow => Duration(minutes: _maxBreakfastMinutes),
      }),
      Meal.elevenses => (switch (speed) {
        SpeedLabel.fast => Duration(minutes: _minElevensesMinutes),
        SpeedLabel.medium => Duration(minutes: _meanElevensesMinutes),
        SpeedLabel.slow => Duration(minutes: _maxElevensesMinutes),
      }),
      Meal.brunch => (switch (speed) {
        SpeedLabel.fast => Duration(minutes: _minBrunchMinutes),
        SpeedLabel.medium => Duration(minutes: _meanBrunchMinutes),
        SpeedLabel.slow => Duration(minutes: _maxBrunchMinutes),
      }),
      Meal.lunch => (switch (speed) {
        SpeedLabel.fast => Duration(minutes: _minLunchMinutes),
        SpeedLabel.medium => Duration(minutes: _meanLunchMinutes),
        SpeedLabel.slow => Duration(minutes: _maxLunchMinutes),
      }),
      Meal.tea => (switch (speed) {
        SpeedLabel.fast => Duration(minutes: _minTeaMinutes),
        SpeedLabel.medium => Duration(minutes: _meanTeaMinutes),
        SpeedLabel.slow => Duration(minutes: _maxTeaMinutes),
      }),
      Meal.highTea => (switch (speed) {
        SpeedLabel.fast => Duration(minutes: _minHighTeaMinutes),
        SpeedLabel.medium => Duration(minutes: _meanHighTeaMinutes),
        SpeedLabel.slow => Duration(minutes: _maxHighTeaMinutes),
      }),
      Meal.dinner => (switch (speed) {
        SpeedLabel.fast => Duration(minutes: _minDinnerMinutes),
        SpeedLabel.medium => Duration(minutes: _meanDinnerMinutes),
        SpeedLabel.slow => Duration(minutes: _maxDinnerMinutes),
      }),
      Meal.supper => (switch (speed) {
        SpeedLabel.fast => Duration(minutes: _minSupperMinutes),
        SpeedLabel.medium => Duration(minutes: _meanSupperMinutes),
        SpeedLabel.slow => Duration(minutes: _maxSupperMinutes),
      }),
    };
  }

  //-- ...Auxiliar: Mean meal duration

  /// Brekfast mean duration
  int get _meanBreakfastMinutes =>
      (2 * _minBreakfastMinutes + _maxBreakfastMinutes + 1) ~/ 3;

  /// Brekfast mean duration
  int get _meanElevensesMinutes =>
      (2 * _minElevensesMinutes + _maxElevensesMinutes + 1) ~/ 3;

  /// Brunch mean duration
  int get _meanBrunchMinutes =>
      (2 * _minBrunchMinutes + _maxBrunchMinutes + 1) ~/ 3;

  /// Lunch mean duration
  int get _meanLunchMinutes =>
      (2 * _minLunchMinutes + _maxLunchMinutes + 1) ~/ 3;

  /// Tea mean duration
  int get _meanTeaMinutes => (2 * _minTeaMinutes + _maxTeaMinutes + 1) ~/ 3;

  /// High tea mean duration
  int get _meanHighTeaMinutes =>
      (2 * _minHighTeaMinutes + _maxHighTeaMinutes + 1) ~/ 3;

  /// Dinner mean duration
  int get _meanDinnerMinutes =>
      (2 * _minDinnerMinutes + _maxDinnerMinutes + 1) ~/ 3;

  /// Supper mean duration
  int get _meanSupperMinutes =>
      (2 * _minSupperMinutes + _maxSupperMinutes + 1) ~/ 3;

  //-- ...Auxiliar: Min/Max meal duration

  /// Brekfast min duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _minBreakfastMinutes =>
      (_breakfastMinutes.$1 > GeneralPreferences.maxMealDurationMinutes ||
              _breakfastMinutes.$1 <
                  GeneralPreferences.minMealDurationMinutes ||
              _breakfastMinutes.$1 > _breakfastMinutes.$2)
          ? Meal.defaultMealDuration(Meal.breakfast).inMinutes
          : _breakfastMinutes.$1;

  /// Brekfast max duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _maxBreakfastMinutes =>
      (_breakfastMinutes.$2 > GeneralPreferences.maxMealDurationMinutes ||
              _breakfastMinutes.$2 <
                  GeneralPreferences.minMealDurationMinutes ||
              _breakfastMinutes.$1 > _breakfastMinutes.$2)
          ? Meal.defaultMealDuration(Meal.breakfast).inMinutes
          : _breakfastMinutes.$2;

  /// Elevenses min duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _minElevensesMinutes =>
      (_elevensesMinutes.$1 > GeneralPreferences.maxMealDurationMinutes ||
              _elevensesMinutes.$1 <
                  GeneralPreferences.minMealDurationMinutes ||
              _elevensesMinutes.$1 > _elevensesMinutes.$2)
          ? Meal.defaultMealDuration(Meal.elevenses).inMinutes
          : _elevensesMinutes.$1;

  /// Elevenses max duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _maxElevensesMinutes =>
      (_elevensesMinutes.$2 > GeneralPreferences.maxMealDurationMinutes ||
              _elevensesMinutes.$2 <
                  GeneralPreferences.minMealDurationMinutes ||
              _elevensesMinutes.$1 > _elevensesMinutes.$2)
          ? Meal.defaultMealDuration(Meal.elevenses).inMinutes
          : _elevensesMinutes.$2;

  /// Brunch min duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _minBrunchMinutes =>
      (_brunchMinutes.$1 > GeneralPreferences.maxMealDurationMinutes ||
              _brunchMinutes.$1 < GeneralPreferences.minMealDurationMinutes ||
              _brunchMinutes.$1 > _brunchMinutes.$2)
          ? Meal.defaultMealDuration(Meal.brunch).inMinutes
          : _brunchMinutes.$1;

  /// Brunch max duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _maxBrunchMinutes =>
      (_brunchMinutes.$2 > GeneralPreferences.maxMealDurationMinutes ||
              _brunchMinutes.$2 < GeneralPreferences.minMealDurationMinutes ||
              _brunchMinutes.$1 > _brunchMinutes.$2)
          ? Meal.defaultMealDuration(Meal.brunch).inMinutes
          : _brunchMinutes.$2;

  /// Lunch min duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _minLunchMinutes =>
      (_lunchMinutes.$1 > GeneralPreferences.maxMealDurationMinutes ||
              _lunchMinutes.$1 < GeneralPreferences.minMealDurationMinutes ||
              _lunchMinutes.$1 > _lunchMinutes.$2)
          ? Meal.defaultMealDuration(Meal.lunch).inMinutes
          : _lunchMinutes.$1;

  /// Lunch max duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _maxLunchMinutes =>
      (_lunchMinutes.$2 > GeneralPreferences.maxMealDurationMinutes ||
              _lunchMinutes.$2 < GeneralPreferences.minMealDurationMinutes ||
              _lunchMinutes.$1 > _lunchMinutes.$2)
          ? Meal.defaultMealDuration(Meal.lunch).inMinutes
          : _lunchMinutes.$2;

  /// Tea min duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _minTeaMinutes =>
      (_teaMinutes.$1 > GeneralPreferences.maxMealDurationMinutes ||
              _teaMinutes.$1 < GeneralPreferences.minMealDurationMinutes ||
              _teaMinutes.$1 > _teaMinutes.$2)
          ? Meal.defaultMealDuration(Meal.tea).inMinutes
          : _teaMinutes.$1;

  /// Tea max duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _maxTeaMinutes =>
      (_teaMinutes.$2 > GeneralPreferences.maxMealDurationMinutes ||
              _teaMinutes.$2 < GeneralPreferences.minMealDurationMinutes ||
              _teaMinutes.$1 > _teaMinutes.$2)
          ? Meal.defaultMealDuration(Meal.tea).inMinutes
          : _teaMinutes.$2;

  /// High tea min duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _minHighTeaMinutes =>
      (_highTeaMinutes.$1 > GeneralPreferences.maxMealDurationMinutes ||
              _highTeaMinutes.$1 < GeneralPreferences.minMealDurationMinutes ||
              _highTeaMinutes.$1 > _highTeaMinutes.$2)
          ? Meal.defaultMealDuration(Meal.highTea).inMinutes
          : _highTeaMinutes.$1;

  /// High tea max duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _maxHighTeaMinutes =>
      (_highTeaMinutes.$2 > GeneralPreferences.maxMealDurationMinutes ||
              _highTeaMinutes.$2 < GeneralPreferences.minMealDurationMinutes ||
              _highTeaMinutes.$1 > _highTeaMinutes.$2)
          ? Meal.defaultMealDuration(Meal.highTea).inMinutes
          : _highTeaMinutes.$2;

  /// Dinner min duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _minDinnerMinutes =>
      (_dinnerMinutes.$1 > GeneralPreferences.maxMealDurationMinutes ||
              _dinnerMinutes.$1 < GeneralPreferences.minMealDurationMinutes ||
              _dinnerMinutes.$1 > _dinnerMinutes.$2)
          ? Meal.defaultMealDuration(Meal.dinner).inMinutes
          : _dinnerMinutes.$1;

  /// Dinner max duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _maxDinnerMinutes =>
      (_dinnerMinutes.$2 > GeneralPreferences.maxMealDurationMinutes ||
              _dinnerMinutes.$2 < GeneralPreferences.minMealDurationMinutes ||
              _dinnerMinutes.$1 > _dinnerMinutes.$2)
          ? Meal.defaultMealDuration(Meal.dinner).inMinutes
          : _dinnerMinutes.$2;

  /// Supper min duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _minSupperMinutes =>
      (_supperMinutes.$1 > GeneralPreferences.maxMealDurationMinutes ||
              _supperMinutes.$1 < GeneralPreferences.minMealDurationMinutes ||
              _supperMinutes.$1 > _supperMinutes.$2)
          ? Meal.defaultMealDuration(Meal.supper).inMinutes
          : _supperMinutes.$1;

  /// Supper max duration
  /// returns default value when actual value is invalid
  /// actual value can be invalid,
  /// because valid range in debug mode and release mode are different
  int get _maxSupperMinutes =>
      (_supperMinutes.$2 > GeneralPreferences.maxMealDurationMinutes ||
              _supperMinutes.$2 < GeneralPreferences.minMealDurationMinutes ||
              _supperMinutes.$1 > _supperMinutes.$2)
          ? Meal.defaultMealDuration(Meal.supper).inMinutes
          : _supperMinutes.$2;

  //-------- end class ---------------------------------------------------------
}

//=======================================================================
// Using same file for class extension allows to access private fields ==
//=======================================================================

/// Parameters for the general configuration of the application
/// Writable class for use in setting configuration
final class GeneralPreferences extends ReadOnlyGeneralPreferences {
  //
  //----------------------------------------------------------------------------
  //-------------------------static/constant------------------------------------

  //-- (1) Alarm settings --//

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

  //-- ...Alarm settings defaults --//

  /// default value alarm duration
  static const defaultAlarmDurationSeconds = kDebugMode ? 15 : 300;

  /// default value alarm snooze
  static const defaultAlarmSnoozeSeconds = kDebugMode ? 90 : 900;

  /// default value alarm repeat times
  static const defaultAlarmRepeatTimes = 3;

  /// default time to deal with alarm
  static const defaultMinutesToDealWithAlarm = 15;

  //-- (2) After/Before time settings --//

  /// min value
  static const minMinutesLongAfterBefore = 90;

  /// max value
  static const maxMinutesLongAfterBefore = 150;

  /// min value
  static const minMinutesAfterBefore = 5;

  /// max value
  static const maxMinutesAfterBefore = 15;

  //-- (3) Meal durations settings --//

  /// min value
  static const minMealDurationMinutes = 5;

  /// max value
  static const maxMealDurationMinutes = 120;

  //-- ...Meal durations defaults --//

  /// default value
  static const defaultMinutesLongBefore = 90;

  /// default value
  static const defaultMinutesBefore = 7;

  /// default value
  static const defaultMinutesAfter = 5;

  /// default value
  static const defaultMinutesLongAfter = 90;

  /// default value
  static const TimeOfDay defaultTimeToSleep = TimeOfDay(hour: 22, minute: 00);

  //----------------------------------------------------------------------------
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
    super._elevensesMinutes,
    super._brunchMinutes,
    super._lunchMinutes,
    super._teaMinutes,
    super._highTeaMinutes,
    super._dinnerMinutes,
    super._supperMinutes,
  );

  //----------------------------------------------------------------------------
  //-----------------------class special members--------------------------------

  /// A readonly copy, without setters
  ReadOnlyGeneralPreferences get readOnlyValues =>
      this as ReadOnlyGeneralPreferences;

  //----------------------------------------------------------------------------
  //-----------------------class rest of members--------------------------------

  //-- (1) Alarm settings --//

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
      throw RangeError.range(value, minAlarmRepeatTimes, maxAlarmRepeatTimes);
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

  //-- (2) After/Before time settings --//

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

  //-- (3) Meal durations settings --//

  /// Set configuration; each [value] must be
  /// >= [minMealDurationMinutes] and
  /// <= [maxMealDurationMinutes]
  set breakfastMinutes((int, int) value) {
    _checkMealRange(value);
    super._breakfastMinutes = value;
  }

  /// Set configuration; each [value] must be
  /// >= [minMealDurationMinutes] and
  /// <= [maxMealDurationMinutes]
  set elevensesMinutes((int, int) value) {
    _checkMealRange(value);
    super._elevensesMinutes = value;
  }

  /// Set configuration; each [value] must be
  /// >= [minMealDurationMinutes] and
  /// <= [maxMealDurationMinutes]
  set brunchMinutes((int, int) value) {
    _checkMealRange(value);
    super._brunchMinutes = value;
  }

  /// Set configuration; each [value] must be
  /// >= [minMealDurationMinutes] and
  /// <= [maxMealDurationMinutes]
  set lunchMinutes((int, int) value) {
    _checkMealRange(value);
    super._lunchMinutes = value;
  }

  /// Set configuration; each [value] must be
  /// >= [minMealDurationMinutes] and
  /// <= [maxMealDurationMinutes]
  set teaMinutes((int, int) value) {
    _checkMealRange(value);
    super._teaMinutes = value;
  }

  /// Set configuration; each [value] must be
  /// >= [minMealDurationMinutes] and
  /// <= [maxMealDurationMinutes]
  set highTeaMinutes((int, int) value) {
    _checkMealRange(value);
    super._highTeaMinutes = value;
  }

  /// Set configuration; each [value] must be
  /// >= [minMealDurationMinutes] and
  /// <= [maxMealDurationMinutes]
  set dinnerMinutes((int, int) value) {
    _checkMealRange(value);
    super._dinnerMinutes = value;
  }

  /// Set configuration; each [value] must be
  /// >= [minMealDurationMinutes] and
  /// <= [maxMealDurationMinutes]
  set supperMinutes((int, int) value) {
    _checkMealRange(value);
    super._supperMinutes = value;
  }

  void _checkMealRange((int, int) value) {
    if (value.$1 < minMealDurationMinutes ||
        value.$1 > maxMealDurationMinutes) {
      throw RangeError.range(
        value.$1,
        minMealDurationMinutes,
        maxMealDurationMinutes,
      );
    } else if (value.$2 < minMealDurationMinutes ||
        value.$2 > maxMealDurationMinutes) {
      throw RangeError.range(
        value.$2,
        minMealDurationMinutes,
        maxMealDurationMinutes,
      );
    } else if (value.$1 > value.$2) {
      throw RangeError.range(value.$2, value.$1, maxMealDurationMinutes);
    }
  }

  //-------- end class ---------------------------------------------------------
}
