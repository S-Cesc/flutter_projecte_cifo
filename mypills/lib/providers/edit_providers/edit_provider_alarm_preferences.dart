import 'package:flutter/material.dart';
import '../general_settings.dart';
import '../../model/general_preferences.dart';

/// Class acts as a provider between sibling widgets
class EditProviderAlarmPreferences {
  final GeneralSettings _settings;
  final ValueNotifier<bool> _hasChanges = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasValidChanges = ValueNotifier<bool>(false);
  final List<bool> _changes = List.of([
    false,
    false,
    false,
    false,
  ], growable: false);

  int? _alarmDurationSeconds;
  int? _alarmSnoozeSeconds;
  int? _alarmRepeatTimes;
  int? _minutesToDealWithAlarm;

  /// Ctor
  EditProviderAlarmPreferences(GeneralSettings settings)
    : _settings = settings,
      _alarmDurationSeconds = settings.data.alarmDurationSeconds,
      _alarmSnoozeSeconds = settings.data.alarmSnoozeSeconds,
      _alarmRepeatTimes = settings.data.alarmRepeatTimes,
      _minutesToDealWithAlarm = settings.data.minutesToDealWithAlarm;

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
  bool get hasChanges => _changes.any((x) => x);

  void _checkChanges() {
    bool isChanged = hasChanges;
    _hasChanges.value = isChanged;
    _hasValidChanges.value = isChanged && hasValidValues;
  }

  set alarmDurationSeconds(int? value) {
    _alarmDurationSeconds = value;
    _changes[0] = _alarmDurationSeconds != _settings.data.alarmDurationSeconds;
    _checkChanges();
  }

  set alarmSnoozeSeconds(int? value) {
    _alarmSnoozeSeconds = value;
    _changes[1] = _alarmSnoozeSeconds != _settings.data.alarmSnoozeSeconds;
    _checkChanges();
  }

  set alarmRepeatTimes(int? value) {
    _alarmRepeatTimes = value;
    _changes[2] = _alarmRepeatTimes != _settings.data.alarmRepeatTimes;
    _checkChanges();
  }

  set minutesToDealWithAlarm(int? value) {
    _minutesToDealWithAlarm = value;
    _changes[3] =
        _minutesToDealWithAlarm != _settings.data.minutesToDealWithAlarm;
    _checkChanges();
  }

  /// Are all the values valid? It must be checked to save the values
  bool get hasValidValues {
    if (_alarmDurationSeconds != null &&
        _alarmRepeatTimes != null &&
        _alarmSnoozeSeconds != null &&
        _minutesToDealWithAlarm != null) {
      return _alarmDurationSeconds! <=
              GeneralPreferences.maxAlarmDurationSeconds &&
          _alarmDurationSeconds! >=
              GeneralPreferences.minAlarmDurationSeconds &&
          _alarmSnoozeSeconds! <= GeneralPreferences.maxAlarmSnoozeSeconds &&
          _alarmSnoozeSeconds! >= GeneralPreferences.minAlarmSnoozeSeconds &&
          _alarmRepeatTimes! <= GeneralPreferences.maxAlarmRepeatTimes &&
          _alarmRepeatTimes! >= GeneralPreferences.minAlarmRepeatTimes &&
          _minutesToDealWithAlarm! <=
              GeneralPreferences.maxMinutesToDealWithAlarm &&
          _minutesToDealWithAlarm! >=
              GeneralPreferences.minMinutesToDealWithAlarm;
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
