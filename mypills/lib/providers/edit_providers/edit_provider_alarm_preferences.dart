import 'package:flutter/material.dart';
import '../alarm_settings.dart';
import '../../model/alarm_preferences.dart';

/// Class acts as a provider between sibling widgets
class EditProviderAlarmPreferences {
  final AlarmSettings _settings;
  final ValueNotifier<bool> _hasChanges = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasValidChanges = ValueNotifier<bool>(false);

  int? _alarmDurationSeconds;
  int? _alarmSnoozeSeconds;
  int? _alarmRepeatTimes;
  int? _minutesToDealWithAlarm;

  /// Ctor
  EditProviderAlarmPreferences(this._settings)
      : _alarmDurationSeconds = _settings.data.alarmDurationSeconds,
        _alarmSnoozeSeconds = _settings.data.alarmSnoozeSeconds,
        _alarmRepeatTimes = _settings.data.alarmRepeatTimes,
        _minutesToDealWithAlarm = _settings.data.minutesToDealWithAlarm;

  /// Alarm duration in seconds
  int? get alarmDurationSeconds => _alarmDurationSeconds;

  /// Alarm snooze time in seconds
  int? get alarmSnoozeSeconds => _alarmSnoozeSeconds;

  /// Alarm repeat times (one means do not repeat)
  int? get alarmRepeatTimes => _alarmRepeatTimes;

  /// Minutes after user stoped the alarm and before actions
  /// (taking the pills) are done
  int? get minutesToDealWithAlarm => _minutesToDealWithAlarm;

  /// Are there any value changed?
  bool get hasChanges => _hasChanges.value;

  set alarmDurationSeconds(int? value) {
    _alarmDurationSeconds = value;
    _hasChanges.value = (value != _settings.data.alarmDurationSeconds);
    _hasValidChanges.value = _hasChanges.value && hasValidValues;
  }

  set alarmSnoozeSeconds(int? value) {
    _alarmSnoozeSeconds = value;
    _hasChanges.value = (value != _settings.data.alarmSnoozeSeconds);
    _hasValidChanges.value = _hasChanges.value && hasValidValues;
  }

  set alarmRepeatTimes(int? value) {
    _alarmRepeatTimes = value;
    _hasChanges.value = (value != _settings.data.alarmRepeatTimes);
    _hasValidChanges.value = _hasChanges.value && hasValidValues;
  }

  set minutesToDealWithAlarm(int? value) {
    _minutesToDealWithAlarm = value;
    _hasChanges.value = (value != _settings.data.minutesToDealWithAlarm);
    _hasValidChanges.value = _hasChanges.value && hasValidValues;
  }

  /// Are all the values valid? It must be checked to save the values
  bool get hasValidValues {
    if (_alarmDurationSeconds != null &&
        _alarmRepeatTimes != null &&
        _alarmSnoozeSeconds != null &&
        _minutesToDealWithAlarm != null) {
      return _alarmDurationSeconds! <=
              AlarmPreferences.maxAlarmDurationSeconds &&
          _alarmDurationSeconds! >= AlarmPreferences.minAlarmDurationSeconds &&
          _alarmSnoozeSeconds! <= AlarmPreferences.maxAlarmSnoozeSeconds &&
          _alarmSnoozeSeconds! >= AlarmPreferences.minAlarmSnoozeSeconds &&
          _alarmRepeatTimes! <= AlarmPreferences.maxAlarmRepeatTimes &&
          _alarmRepeatTimes! >= AlarmPreferences.minAlarmRepeatTimes &&
          _minutesToDealWithAlarm! <=
              AlarmPreferences.maxMinutesToDealWithAlarm &&
          _minutesToDealWithAlarm! >=
              AlarmPreferences.minMinutesToDealWithAlarm;
    } else {
      return false;
    }
  }

  /// Store temporal values in persistent media
  Future<bool> saveValues() async {
    if (hasValidValues) {
      try {
        await _settings.setAlarmDurationSeconds(_alarmDurationSeconds!);
        await _settings.setAlarmSnoozeSeconds(_alarmSnoozeSeconds!);
        await _settings.setAlarmRepeatTimes(_alarmRepeatTimes!);
        await _settings.setMinutesToDealWithAlarm(_minutesToDealWithAlarm!);
        _hasChanges.value = false;
        _hasValidChanges.value = false;
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  /// Discard temporal values
  void discardChanges() {
    _alarmDurationSeconds = _settings.data.alarmDurationSeconds;
    _alarmSnoozeSeconds = _settings.data.alarmSnoozeSeconds;
    _alarmRepeatTimes = _settings.data.alarmRepeatTimes;
    _minutesToDealWithAlarm = _settings.data.minutesToDealWithAlarm;
    _hasChanges.value = false;
    _hasValidChanges.value = false;
  }

  /// Only valid values can be saved
  ValueNotifier<bool> notifyValidChanges() => _hasValidChanges;

  /// Detect changes to activate undo
  ValueNotifier<bool> notifyChanges() => _hasChanges;
}
