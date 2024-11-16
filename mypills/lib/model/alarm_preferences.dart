// logging and debugging
// Dart base
// Flutter
// Project files

//=======================================================================

/* writable derived class has access to private setters */
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

  static const _minAlarmDurationSeconds = 150;
  static const _maxAlarmDurationSeconds = 900;
  static const _minAlarmRepeatTimes = 1;
  static const _maxAlarmRepeatTimes = 5;

  static const defaultAlarmDurationSeconds = 600;
  static const defaultAlarmSnoozeSeconds = 900;
  static const defaultAlarmRepeatTimes = 3;

  static const alarmDurationSecondsKey = 'aDuration';
  static const alarmSnoozeSecondsKey = 'aSnooze';
  static const alarmRepeatTimesKey = 'aRepeat';

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

  set alarmDurationSeconds(int value) {
    if (value >= _minAlarmDurationSeconds &&
        value <= _maxAlarmDurationSeconds) {
      super._alarmDurationSeconds = value;
    } else {
      throw RangeError.range(
        value,
        _minAlarmDurationSeconds,
        _maxAlarmDurationSeconds,
      );
    }
  }

  set alarmSnoozeSeconds(int value) {
    if (value >= _maxAlarmDurationSeconds % 2 &&
        value <= _maxAlarmDurationSeconds) {
      super._alarmSnoozeSeconds = value;
    } else {
      throw RangeError.range(
        value,
        _maxAlarmDurationSeconds % 2,
        _maxAlarmDurationSeconds,
      );
    }
  }

  set alarmRepeatTimes(int value) {
    if (value >= _minAlarmRepeatTimes &&
        value <= _maxAlarmRepeatTimes) {
      super._alarmRepeatTimes = value;
    } else {
      throw RangeError.range(
        value,
        _minAlarmDurationSeconds,
        _maxAlarmDurationSeconds,
      );
    }
  }
}
