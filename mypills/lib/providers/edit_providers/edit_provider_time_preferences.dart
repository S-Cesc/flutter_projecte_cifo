import 'package:flutter/material.dart';
import '../alarm_settings.dart';
import '../../model/alarm_preferences.dart';

/// Class acts as a provider between sibling widgets
class EditProviderTimePreferences {
  final AlarmSettings _settings;
  final ValueNotifier<bool> _hasChanges = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasValidChanges = ValueNotifier<bool>(false);

  int? _longBefore;
  int? _before;
  int? _after;
  int? _longAfter;

  /// Ctor
  EditProviderTimePreferences(this._settings)
      : _longBefore = _settings.data.minutesLongBefore,
        _before = _settings.data.minutesBefore,
        _after = _settings.data.minutesAfter,
        _longAfter = _settings.data.minutesLongAfter;

  /// Minutes for taking pills well before meals
  int? get minutesLongBeforeMeals => _longBefore;

  /// Minutes to take pills before meals
  int? get minutesBeforeMeals => _before;

  /// Minutes to take pills after finishing meals
  int? get minutesAfterMeals => _after;

  /// Minutes to take pills long after finishing dinner
  int? get minutesLongAfterMeals => _longAfter;

  /// Are there any value changed?
  bool get hasChanges => _hasChanges.value;

  set minutesLongBeforeMeals(int? value) {
    _longBefore = value;
    _hasChanges.value = (value != _settings.data.alarmDurationSeconds);
    _hasValidChanges.value = _hasChanges.value && hasValidValues;
  }

  set minutesBeforeMeals(int? value) {
    _before = value;
    _hasChanges.value = (value != _settings.data.alarmSnoozeSeconds);
    _hasValidChanges.value = _hasChanges.value && hasValidValues;
  }

  set minutesAfterMeals(int? value) {
    _after = value;
    _hasChanges.value = (value != _settings.data.alarmRepeatTimes);
    _hasValidChanges.value = _hasChanges.value && hasValidValues;
  }

  set minutesLongAfterMeals(int? value) {
    _longAfter = value;
    _hasChanges.value = (value != _settings.data.minutesToDealWithAlarm);
    _hasValidChanges.value = _hasChanges.value && hasValidValues;
  }

  /// Are all the values valid? It must be checked to save the values
  bool get hasValidValues {
    if (_longBefore != null &&
        _before != null &&
        _after != null &&
        _longAfter != null) {
      return _longBefore! <= AlarmPreferences.maxMinutesLongAfterBefore &&
          _longBefore! >= AlarmPreferences.minMinutesLongAfterBefore &&
          _before! <= AlarmPreferences.maxMinutesAfterBefore &&
          _before! >= AlarmPreferences.minMinutesAfterBefore &&
          _after! <= AlarmPreferences.maxMinutesAfterBefore &&
          _after! >= AlarmPreferences.minMinutesAfterBefore &&
          _longAfter! <= AlarmPreferences.maxMinutesLongAfterBefore &&
          _longAfter! >= AlarmPreferences.minMinutesLongAfterBefore &&
          _longBefore! > _before! && _longAfter! > _after!;
    } else {
      return false;
    }
  }

  /// Store temporal values in persistent media
  Future<bool> saveValues() async {
    if (hasValidValues) {
      try {
        await _settings.setMinutesLongBeforeMeal(_longBefore!);
        await _settings.setMinutesBeforeMeal(_before!);
        await _settings.setMinutesAfterMeal(_after!);
        await _settings.setMinutesLongAfterMeal(_longAfter!);
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
    _longBefore = _settings.data.minutesLongBefore;
    _before = _settings.data.minutesBefore;
    _after = _settings.data.minutesAfter;
    _longAfter = _settings.data.minutesLongAfter;
    _hasChanges.value = false;
    _hasValidChanges.value = false;
  }

  /// Only valid values can be saved
  ValueNotifier<bool> notifyValidChanges() => _hasValidChanges;

  /// Detect changes to activate undo
  ValueNotifier<bool> notifyChanges() => _hasChanges;
}
