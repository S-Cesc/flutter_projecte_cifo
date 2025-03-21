import 'package:mypills/model/weekly_time_table.dart';

import 'enum/meal.dart';
import 'enum/pill_meal_time.dart';
import 'meal_pillmealtime_pair.dart';

//==============================================================================

/// Defines the meals used for prescriptions
/// 0 - 0 - 0 (0)
class MealsForPills {
  //
  //----------------------------------------------------------------------------
  //-------------------------static/constant------------------------------------

  /// local key prefix for the list of meals component
  static const String _lstKey = 'lst';

  /// local key prefix for the between meals component
  static const String _betweenMealsKey = 'ac'; // ante cibum

  //----------------------------------------------------------------------------
  //----------class state members and constructors------------------------------

  /// Function called on data update
  /// It allows call to NotifyListeners
  final void Function()? _onChanged;

  bool _modified = false;

  /// List of three meals
  final List<Meal?> meals = List<Meal?>.of([null, null, null], growable: false);

  /// Between meals value
  MealPillmealtimePair? _betweenMeals;

  /// Ctor
  MealsForPills(void Function()? onChanged)
    : _onChanged = onChanged;

  /// constructor from Json object got from jsonDecode of a string
  factory MealsForPills.fromJson(
    void Function()? onChanged,
    String key,
    Map<String, dynamic> json,
  ) {
    final meals = json["$_lstKey$key"] as List;
    final betweenMeals = json["$_betweenMealsKey$key"] as int?;
    final List<Meal?> mealsList = List<Meal?>.of(
      meals.map((e) => Meal.values[e as int]),
      growable: false,
    );
    return MealsForPills(onChanged)
      ..meals[0] = mealsList[0]
      ..meals[1] = mealsList[1]
      ..meals[2] = mealsList[2]
      ..betweenMeals =
          betweenMeals != null ? MealPillmealtimePair(betweenMeals) : null;
  }

  //----------------------------------------------------------------------------
  //----------class special members---------------------------------------------

  /// Are there any changes?
  bool get modified => _modified;

  /// There are no changes (changes saved)
  void resetModified() {
    _modified = false;
  }

  /// The between meals component
  /// MealTime should be longBefore or longAfter
  /// but longAfter only stands for long after the supper
  MealPillmealtimePair? get betweenMeals => _betweenMeals;

  set betweenMeals(MealPillmealtimePair? value) {
    if (value != null) {
      switch (value.pillMealTime) {
        case PillMealTime.before:
        case PillMealTime.after:
        case PillMealTime.at:
          throw ArgumentError('Invalid value for betweenMeals');
        case PillMealTime.longAfter:
        case PillMealTime.longBefore:
          _betweenMeals = value;
          break;
      }
    }
  }

  /// Check if all the values are defined
  bool get isDefined =>
      meals[0] != null &&
      meals[1] != null &&
      meals[2] != null &&
      _betweenMeals != null;

  /// Check values defined are also available in the weekly time table
  /// It checks values against one of the weekly time table partitions
  bool _isLocalCoherent(WeeklyTimeTable wtt, int? partition) {
    if (wtt.isPartitionFullyDefined(partition)) {
      if (isDefined) {
        bool result = true;
        for (int i = 0; i < 3; i++) {
          result &= wtt.isMealDefined(meals[i]!, partition);
        }
        return result && wtt.isMealDefined(_betweenMeals!.meal, partition);
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  /// convert to Json object, which also must be encoded into a String
  Map<String, dynamic> toJson(String key) {
    return {
      "$_lstKey$key": meals.map((e) => e?.index).toList(),
      "$_betweenMealsKey$key": _betweenMeals?.pillMealTime.id,
    };
  }
}

/// Defines the meals used for prescriptions
/// 0 - 0 - 0 (0)
/// and three alternatives for the alternative days
class MealsForPillsWithAlt extends MealsForPills {
  /// Alternative days
  final List<MealsForPills> alt;

  /// Ctor
  MealsForPillsWithAlt(super.onChanged)
    : alt = List<MealsForPills>.of([
        MealsForPills(onChanged),
        MealsForPills(onChanged),
        MealsForPills(onChanged),
      ], growable: false);

  /// constructor from Json object got from jsonDecode of a string
  factory MealsForPillsWithAlt.fromJson(
    void Function()? onChanged,
    String key,
    Map<String, dynamic> json,
  ) {
    final meals = json["$MealsForPills._lstKey$key"] as List;
    final betweenMeals = json["$MealsForPills._betweenMealsKey$key"] as int?;
    final List<Meal?> mealsList = List<Meal?>.of(
      meals.map((e) => Meal.values[e as int]),
      growable: false,
    );
    final alt1 = MealsForPills.fromJson(onChanged, "${key}1", json);
    final alt2 = MealsForPills.fromJson(onChanged, "${key}2", json);
    final alt3 = MealsForPills.fromJson(onChanged, "${key}3", json);
    return MealsForPillsWithAlt(onChanged)
      ..meals[0] = mealsList[0]
      ..meals[1] = mealsList[1]
      ..meals[2] = mealsList[2]
      ..betweenMeals =
          betweenMeals != null ? MealPillmealtimePair(betweenMeals) : null
      ..alt[0] = alt1
      ..alt[1] = alt2
      ..alt[2] = alt3;
  }

  //----------------------------------------------------------------------------
  //----------class special members---------------------------------------------

  /// convert to Json object, which also must be encoded into a String
  @override
  Map<String, dynamic> toJson(String key) {
    return {
      "${MealsForPills._lstKey}$key": meals.map((e) => e?.index).toList(),
      "${MealsForPills._betweenMealsKey}$key": _betweenMeals?.pillMealTime.id,
      "${key}1": alt[0].toJson(key),
      "${key}2": alt[1].toJson(key),
      "${key}3": alt[2].toJson(key),
    };
  }

  bool isFullyDefined(WeeklyTimeTable wtt) {
    bool result = isDefined && wtt.isPartitionFullyDefined();
    for (int partition = 0; partition < 3; partition++) {
      final altPartition = alt[partition];
      result =
          result &&
          (wtt.isPartitionFullyDefined(partition) == altPartition.isDefined);
    }
    return result;
  }

  /// Check values defined are also available in the weekly time table
  bool isCoherent(WeeklyTimeTable wtt) {
    bool result = super._isLocalCoherent(wtt, null);
    for (int i = 0; i < 3; i++) {
      result &= alt[i]._isLocalCoherent(wtt, i);
    }
    return result;
  }

  /// Infer a valid value for the meals for pills
  /// requires the weekly time table to be fully defined
  void inferTheResult(WeeklyTimeTable wtt) {
    if (isFullyDefined(wtt)) {
      bool hasChanges = false;
      if (wtt.isPartitionFullyDefined()) {
        if (!isDefined || !super._isLocalCoherent(wtt, null)) {
          if (meals[0] == null || !wtt.isMealDefined(meals[0]!, null)) {
            meals[0] = wtt.minMeal(Meal.breakfast);
            hasChanges = true;
          }
          if (meals[1] == null || !wtt.isMealDefined(meals[1]!, null)) {
            meals[1] =
                wtt.defaultDaysMeals.containsKey(Meal.lunch)
                    ? Meal.lunch
                    : wtt.minMeal(Meal.brunch);
            hasChanges = true;
          }
          if (meals[1] == null || !wtt.isMealDefined(meals[1]!, null)) {
            meals[2] =
                wtt.defaultDaysMeals.containsKey(Meal.dinner)
                    ? Meal.dinner
                    : wtt.minMeal(Meal.highTea);
            hasChanges = true;
          }
        }
      }
      for (int partition = 0; partition < 3; partition++) {
        if (wtt.isPartitionFullyDefined(partition)) {
          final altPartition = alt[partition];
          if (!altPartition.isDefined ||
              !altPartition._isLocalCoherent(wtt, partition)) {
            if (altPartition.meals[0] == null ||
                !wtt.isMealDefined(altPartition.meals[0]!, partition)) {
              altPartition.meals[0] = wtt.minMeal(Meal.breakfast, partition);
              hasChanges = true;
            }
            if (altPartition.meals[1] == null ||
                !wtt.isMealDefined(altPartition.meals[1]!, partition)) {
              altPartition.meals[1] =
                  wtt.specialDaysMeals(partition).containsKey(Meal.lunch)
                      ? Meal.lunch
                      : wtt.minMeal(Meal.brunch, partition);
              hasChanges = true;
            }
            if (altPartition.meals[1] == null ||
                !wtt.isMealDefined(altPartition.meals[1]!, partition)) {
              altPartition.meals[2] =
                  wtt.specialDaysMeals(partition).containsKey(Meal.dinner)
                      ? Meal.dinner
                      : wtt.minMeal(Meal.highTea, partition);
              hasChanges = true;
            }
          }
        }
      }
      if (hasChanges) {
        _modified = true;
        _onChanged?.call();
      }
    }
  }
}
