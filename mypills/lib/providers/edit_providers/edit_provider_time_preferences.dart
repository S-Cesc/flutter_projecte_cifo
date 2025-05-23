import 'package:flutter/material.dart';
import '../general_settings.dart';
import '../../model/general_preferences.dart';

/// Class acts as a provider between sibling widgets
class EditProviderTimePreferences {
  final GeneralSettings _settings;
  final ValueNotifier<bool> _hasChanges = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasValidChanges = ValueNotifier<bool>(false);
  final List<bool> _changes = List.of([
    false,
    false,
    false,
    false,
  ], growable: false);

  int? _longBefore;
  int? _before;
  int? _after;
  int? _longAfter;

  /// Ctor
  EditProviderTimePreferences(GeneralSettings settings)
    : _settings = settings,
      _longBefore = settings.data.minutesLongBefore,
      _before = settings.data.minutesBefore,
      _after = settings.data.minutesAfter,
      _longAfter = settings.data.minutesLongAfter;

  /// Minutes for taking pills well before meals
  int? get minutesLongBeforeMeals => _longBefore;

  /// Minutes to take pills before meals
  int? get minutesBeforeMeals => _before;

  /// Minutes to take pills after finishing meals
  int? get minutesAfterMeals => _after;

  /// Minutes to take pills long after finishing dinner
  int? get minutesLongAfterMeals => _longAfter;

  /// Are there any value changed?
  bool get hasChanges => _changes.any((x) => x);

  void _checkChanges() {
    bool isChanged = hasChanges;
    _hasChanges.value = isChanged;
    _hasValidChanges.value = isChanged && hasValidValues;
  }

  set minutesLongBeforeMeals(int? value) {
    _longBefore = value;
    _changes[0] = _longBefore != _settings.data.minutesLongBefore;
    _checkChanges();
  }

  set minutesBeforeMeals(int? value) {
    _before = value;
    _changes[1] = _before != _settings.data.minutesBefore;
    _checkChanges();
  }

  set minutesAfterMeals(int? value) {
    _after = value;
    _changes[2] = _after != _settings.data.minutesAfter;
    _checkChanges();
  }

  set minutesLongAfterMeals(int? value) {
    _longAfter = value;
    _changes[3] = _longAfter != _settings.data.minutesLongAfter;
    _checkChanges();
  }

  /// Are all the values valid? It must be checked to save the values
  bool get hasValidValues {
    if (_longBefore != null &&
        _before != null &&
        _after != null &&
        _longAfter != null) {
      return _longBefore! <= GeneralPreferences.maxMinutesLongAfterBefore &&
          _longBefore! >= GeneralPreferences.minMinutesLongAfterBefore &&
          _before! <= GeneralPreferences.maxMinutesAfterBefore &&
          _before! >= GeneralPreferences.minMinutesAfterBefore &&
          _after! <= GeneralPreferences.maxMinutesAfterBefore &&
          _after! >= GeneralPreferences.minMinutesAfterBefore &&
          _longAfter! <= GeneralPreferences.maxMinutesLongAfterBefore &&
          _longAfter! >= GeneralPreferences.minMinutesLongAfterBefore &&
          _longBefore! > _before! &&
          _longAfter! > _after!;
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
