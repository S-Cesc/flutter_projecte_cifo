import 'package:flutter/material.dart';
import '../../model/general_preferences.dart';
import '../general_settings.dart';

/// Class acts as a provider between sibling widgets
class EditProviderMealDurationsAdjustment {
  final GeneralSettings _settings;
  final ValueNotifier<bool> _hasChanges = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasValidChanges = ValueNotifier<bool>(false);

  int? _breakfastMinutes;
  int? _brunchMinutes;
  int? _lunchMinutes;
  int? _teaMinutes;
  int? _highTeaMinutes;
  int? _dinnerMinutes;
  int? _supperMinutes;

  /// Ctor
  EditProviderMealDurationsAdjustment(GeneralSettings settings)
      : _settings = settings,
        _breakfastMinutes = settings.data.breakfastMinutes,
        _brunchMinutes = settings.data.brunchMinutes,
        _lunchMinutes = settings.data.lunchMinutes,
        _teaMinutes = settings.data.teaMinutes,
        _highTeaMinutes = settings.data.highTeaMinutes,
        _dinnerMinutes = settings.data.dinnerMinutes,
        _supperMinutes = settings.data.supperMinutes;

  /// breakfast duration in minutes
  int? get breakfastMinutes => _breakfastMinutes;

  /// brunch duration in minutes
  int? get brunchMinutes => _brunchMinutes;

  /// luch duration in minutes
  int? get lunchMinutes => _lunchMinutes;

  /// tea duration in minutes
  int? get teaMinutes => _teaMinutes;

  /// high tea duration in minutes
  int? get highTeaMinutes => _highTeaMinutes;

  /// dinner duration in minutes
  int? get dinnerMinutes => _dinnerMinutes;

  /// supper duration in minutes
  int? get supperMinutes => _supperMinutes;

  set breakfastMinutes(int? value) {
    _breakfastMinutes = value;
    _hasChanges.value = (value != _settings.data.breakfastMinutes);
    _hasValidChanges.value = _hasChanges.value && hasValidValues;
  }

  set brunchMinutes(int? value) {
    _brunchMinutes = value;
    _hasChanges.value = (value != _settings.data.brunchMinutes);
    _hasValidChanges.value = _hasChanges.value && hasValidValues;
  }

  set lunchMinutes(int? value) {
    _lunchMinutes = value;
    _hasChanges.value = (value != _settings.data.lunchMinutes);
    _hasValidChanges.value = _hasChanges.value && hasValidValues;
  }

  set teaMinutes(int? value) {
    _teaMinutes = value;
    _hasChanges.value = (value != _settings.data.teaMinutes);
    _hasValidChanges.value = _hasChanges.value && hasValidValues;
  }

  set highTeaMinutes(int? value) {
    _highTeaMinutes = value;
    _hasChanges.value = (value != _settings.data.highTeaMinutes);
    _hasValidChanges.value = _hasChanges.value && hasValidValues;
  }

  set dinnerMinutes(int? value) {
    _dinnerMinutes = value;
    _hasChanges.value = (value != _settings.data.dinnerMinutes);
    _hasValidChanges.value = _hasChanges.value && hasValidValues;
  }

  set supperMinutes(int? value) {
    _supperMinutes = value;
    _hasChanges.value = (value != _settings.data.supperMinutes);
    _hasValidChanges.value = _hasChanges.value && hasValidValues;
  }

  /// Are all the values valid? It must be checked to save the values
  bool get hasValidValues {
    if (_breakfastMinutes != null &&
        _brunchMinutes != null &&
        _lunchMinutes != null &&
        _teaMinutes != null &&
        _highTeaMinutes != null &&
        _dinnerMinutes != null &&
        _supperMinutes != null) {
      return _breakfastMinutes! <= GeneralPreferences.maxMealDurationMinutes &&
          _breakfastMinutes! >= GeneralPreferences.minMealDurationMinutes &&
          _brunchMinutes! <= GeneralPreferences.maxMealDurationMinutes &&
          _brunchMinutes! >= GeneralPreferences.minMealDurationMinutes &&
          _lunchMinutes! <= GeneralPreferences.maxMealDurationMinutes &&
          _lunchMinutes! >= GeneralPreferences.minMealDurationMinutes &&
          _teaMinutes! <= GeneralPreferences.maxMealDurationMinutes &&
          _teaMinutes! >= GeneralPreferences.minMealDurationMinutes &&
          _highTeaMinutes! <= GeneralPreferences.maxMealDurationMinutes &&
          _highTeaMinutes! >= GeneralPreferences.minMealDurationMinutes &&
          _dinnerMinutes! <= GeneralPreferences.maxMealDurationMinutes &&
          _dinnerMinutes! >= GeneralPreferences.minMealDurationMinutes &&
          _supperMinutes! <= GeneralPreferences.maxMealDurationMinutes &&
          _supperMinutes! >= GeneralPreferences.minMealDurationMinutes;
    } else {
      return false;
    }
  }

  /// Store temporal values in persistent media
  Future<bool> saveValues() async {
    if (hasValidValues) {
      try {
        await _settings.setBreakfastMinutes(_breakfastMinutes!);
        await _settings.setBrunchMinutes(_brunchMinutes!);
        await _settings.setLunchMinutes(_lunchMinutes!);
        await _settings.setTeaMinutes(_teaMinutes!);
        await _settings.setHighTeaMinutes(_highTeaMinutes!);
        await _settings.setDinnerMinutes(_dinnerMinutes!);
        await _settings.setSupperMinutes(_supperMinutes!);
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
