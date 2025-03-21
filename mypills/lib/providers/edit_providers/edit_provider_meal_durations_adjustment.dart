import 'package:flutter/material.dart';
import '../../model/general_preferences.dart';
import '../general_settings.dart';

/// Class acts as a provider between sibling widgets
class EditProviderMealDurationsAdjustment {
  final GeneralSettings _settings;
  final ValueNotifier<bool> _hasChanges = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasValidChanges = ValueNotifier<bool>(false);
  final List<bool> _changes = List.of([
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ], growable: false);

  (int?, int?) _breakfastMinutes;
  (int?, int?) _elevensesMinutes;
  (int?, int?) _brunchMinutes;
  (int?, int?) _lunchMinutes;
  (int?, int?) _teaMinutes;
  (int?, int?) _highTeaMinutes;
  (int?, int?) _dinnerMinutes;
  (int?, int?) _supperMinutes;

  /// Ctor
  EditProviderMealDurationsAdjustment(GeneralSettings settings)
    : _settings = settings,
      _breakfastMinutes = settings.data.breakfastMinutes,
      _elevensesMinutes = settings.data.elevensesMinutes,
      _brunchMinutes = settings.data.brunchMinutes,
      _lunchMinutes = settings.data.lunchMinutes,
      _teaMinutes = settings.data.teaMinutes,
      _highTeaMinutes = settings.data.highTeaMinutes,
      _dinnerMinutes = settings.data.dinnerMinutes,
      _supperMinutes = settings.data.supperMinutes;

  /// breakfast duration in minutes
  (int?, int?) get breakfastMinutes => _breakfastMinutes;

  /// elevenses duration in minutes
  (int?, int?) get elevensesMinutes => _elevensesMinutes;

  /// brunch duration in minutes
  (int?, int?) get brunchMinutes => _brunchMinutes;

  /// luch duration in minutes
  (int?, int?) get lunchMinutes => _lunchMinutes;

  /// tea duration in minutes
  (int?, int?) get teaMinutes => _teaMinutes;

  /// high tea duration in minutes
  (int?, int?) get highTeaMinutes => _highTeaMinutes;

  /// dinner duration in minutes
  (int?, int?) get dinnerMinutes => _dinnerMinutes;

  /// supper duration in minutes
  (int?, int?) get supperMinutes => _supperMinutes;

  /// Are there any value changed?
  bool get hasChanges => _changes.any((x) => x);

  void _checkChanges() {
    bool isChanged = hasChanges;
    _hasChanges.value = isChanged;
    _hasValidChanges.value = isChanged && hasValidValues;
  }

  set breakfastMinutes((int?, int?) value) {
    _breakfastMinutes = value;
    _changes[0] = _breakfastMinutes != _settings.data.breakfastMinutes;
    _checkChanges();
  }

  set elevensesMinutes((int?, int?) value) {
    _elevensesMinutes = value;
    _changes[1] = _elevensesMinutes != _settings.data.elevensesMinutes;
    _checkChanges();
  }

  set brunchMinutes((int?, int?) value) {
    _brunchMinutes = value;
    _changes[2] = _brunchMinutes != _settings.data.brunchMinutes;
    _checkChanges();
  }

  set lunchMinutes((int?, int?) value) {
    _lunchMinutes = value;
    _changes[3] = _lunchMinutes != _settings.data.lunchMinutes;
    _checkChanges();
  }

  set teaMinutes((int?, int?) value) {
    _teaMinutes = value;
    _changes[4] = _teaMinutes != _settings.data.teaMinutes;
    _checkChanges();
  }

  set highTeaMinutes((int?, int?) value) {
    _highTeaMinutes = value;
    _changes[5] = _highTeaMinutes != _settings.data.highTeaMinutes;
    _checkChanges();
  }

  set dinnerMinutes((int?, int?) value) {
    _dinnerMinutes = value;
    _changes[6] = _dinnerMinutes != _settings.data.dinnerMinutes;
    _checkChanges();
  }

  set supperMinutes((int?, int?) value) {
    _supperMinutes = value;
    _changes[7] = _supperMinutes != _settings.data.supperMinutes;
    _checkChanges();
  }

  /// Are all the values valid? It must be checked to save the values
  bool get hasValidValues {
    bool checkValue((int?, int?) value) {
      if (value.$1 != null && value.$2 != null) {
        return value.$1! <= GeneralPreferences.maxMealDurationMinutes &&
            value.$1! >= GeneralPreferences.minMealDurationMinutes &&
            value.$2! <= GeneralPreferences.maxMealDurationMinutes &&
            value.$2! >= GeneralPreferences.minMealDurationMinutes &&
            value.$1! <= value.$2!;
      } else {
        return false;
      }
    }

    return checkValue(_breakfastMinutes) &&
        checkValue(_elevensesMinutes) &&
        checkValue(_brunchMinutes) &&
        checkValue(_lunchMinutes) &&
        checkValue(_teaMinutes) &&
        checkValue(_highTeaMinutes) &&
        checkValue(_dinnerMinutes) &&
        checkValue(_supperMinutes);
  }

  /// Store temporal values in persistent media
  Future<bool> saveValues() async {
    if (hasValidValues) {
      try {
        await _settings.setBreakfastMinutes((
          _breakfastMinutes.$1!,
          _breakfastMinutes.$2!,
        ));
        await _settings.setElevensesMinutes((
          _elevensesMinutes.$1!,
          _elevensesMinutes.$2!,
        ));
        await _settings.setBrunchMinutes((
          _brunchMinutes.$1!,
          _brunchMinutes.$2!,
        ));
        await _settings.setLunchMinutes((_lunchMinutes.$1!, _lunchMinutes.$2!));
        await _settings.setTeaMinutes((_teaMinutes.$1!, _teaMinutes.$2!));
        await _settings.setHighTeaMinutes((
          _highTeaMinutes.$1!,
          _highTeaMinutes.$2!,
        ));
        await _settings.setDinnerMinutes((
          _dinnerMinutes.$1!,
          _dinnerMinutes.$2!,
        ));
        await _settings.setSupperMinutes((
          _supperMinutes.$1!,
          _supperMinutes.$2!,
        ));
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
    _breakfastMinutes = _settings.data.breakfastMinutes;
    _elevensesMinutes = _settings.data.elevensesMinutes;
    _brunchMinutes = _settings.data.brunchMinutes;
    _lunchMinutes = _settings.data.lunchMinutes;
    _teaMinutes = _settings.data.teaMinutes;
    _highTeaMinutes = _settings.data.highTeaMinutes;
    _dinnerMinutes = _settings.data.dinnerMinutes;
    _supperMinutes = _settings.data.supperMinutes;
    _hasChanges.value = false;
    _hasValidChanges.value = false;
  }

  /// Only valid values can be saved
  ValueNotifier<bool> notifyValidChanges() => _hasValidChanges;

  /// Detect changes to activate undo
  ValueNotifier<bool> notifyChanges() => _hasChanges;
}
