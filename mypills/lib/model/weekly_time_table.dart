// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
// projecte
import 'meal.dart';
import 'day_of_week.dart';

//==============================================================================

/// Two sets of meals (which meals) with its times,
/// and a set of DayOfWeek to diferenciate the set of meals for each day of week
class WeeklyTimeTable {
  //-------------------------static/constant------------------------------------

  static Set<DayOfWeek> _setOfWeekdaysFromJson(List<dynamic> jsonDays) {
    Set<DayOfWeek> days = {};
    for (var x in jsonDays) {
      days.add(DayOfWeek.fromId(x as int));
    }
    return days;
  }

  static Map<Meal, TimeOfDay> _timeTableFromJson(
      Map<String, dynamic> jsonMealTimes) {
    Map<Meal, TimeOfDay> timeTable = {};
    for (var x in jsonMealTimes.entries) {
      final value = x.value as String?;
      if (value != null) {
        final int pos = value.indexOf(':');
        final int hour = int.parse(value.substring(0, pos));
        final int minute = int.parse(value.substring(pos + 1));
        timeTable.putIfAbsent(
          Meal.fromId(int.parse(x.key)),
          () => TimeOfDay(hour: hour, minute: minute),
        );
      }
    }
    return timeTable;
  }

  static List<dynamic> _setOfWeekdaysToJson(Set<DayOfWeek> value) {
    // => value.toList(growable: false);
    List<dynamic> result = [];
    for (var d in value) {
      result.add(d.id);
    }
    return result;
  }

  static Map<String, dynamic> _timeTableToJson(Map<Meal, TimeOfDay> value) {
    Map<String, dynamic> result = {};
    for (var x in value.entries) {
      result[x.key.id.toString()] = "${x.value.hour}:${x.value.minute}";
    }
    return result;
  }

  //-----------------class state members and constructors ----------------------

  final Map<Meal, TimeOfDay> _defaultDaysMeals;
  final Set<DayOfWeek> _specialWeekDays;
  final Map<Meal, TimeOfDay> _specialDaysMeals;

  /// Create an empty weekly time table
  WeeklyTimeTable.empty()
      : _defaultDaysMeals = {},
        _specialWeekDays = {},
        _specialDaysMeals = {};

  // use Map<String, dynamic> parsedJson = jsonDecode(json);
  /// constructor from Json object got from jsonDecode of a string
  WeeklyTimeTable.fromJson(Map<String, dynamic> parsedJson)
      : _defaultDaysMeals = _timeTableFromJson(
            parsedJson['defaultMeals'] as Map<String, dynamic>),
        _specialWeekDays =
            _setOfWeekdaysFromJson(parsedJson['specialWD'] as List<dynamic>),
        _specialDaysMeals = _timeTableFromJson(
            parsedJson['specialDaysMeals'] as Map<String, dynamic>) {
    _ensureCoherence();
  }

  //-----------------------class special members--------------------------------

  // use String jsonEncode(value.toJson());
  /// convert to Json object, which also must be encoded into a String
  Map<String, dynamic> toJson() {
    _ensureCoherence();
    return {
      'defaultMeals': _timeTableToJson(_defaultDaysMeals),
      'specialWD': _setOfWeekdaysToJson(_specialWeekDays),
      'specialDaysMeals': _timeTableToJson(_specialDaysMeals)
    };
  }

  void _ensureCoherence() {
    if (_specialWeekDays.isEmpty) {
      if (_specialDaysMeals.isNotEmpty) {
        _specialDaysMeals.removeWhere((m, t) => true);
      }
    }
  }

  /// Require a minimum of 3 meals a day (needed for prescriptions)
  bool get isFullyDefined {
    return _defaultDaysMeals.length >= 3 &&
        (_specialWeekDays.isEmpty && _specialDaysMeals.isEmpty ||
            _specialWeekDays.isNotEmpty && _specialDaysMeals.length >= 3);
  }

  //-----------------------class rest of members--------------------------------

  Map<Meal, TimeOfDay> get defaultDaysMeals => _defaultDaysMeals;
  Map<Meal, TimeOfDay> get specialDaysMeals => _specialDaysMeals;
  Set<DayOfWeek> get specialWeekDays => _specialWeekDays;

  bool isSpecialWeekDay(DayOfWeek dw) => _specialWeekDays.contains(dw);

  /// At what time is the [meal]?
  /// It can also ask for special days, using [isSpecialWeekDay]=true
  TimeOfDay? mealTime(Meal meal, [bool isSpecialWeekDay = false]) {
    if (isSpecialWeekDay) {
      return _specialDaysMeals[meal];
    } else {
      return _defaultDaysMeals[meal];
    }
  }

  /// At what time is the [meal] on [dw]
  TimeOfDay? dayMealTime(Meal meal, DayOfWeek dw) {
    if (isSpecialWeekDay(dw)) {
      return _specialDaysMeals[meal];
    } else {
      return _defaultDaysMeals[meal];
    }
  }

  /// Search tomorrow equivalent meal
  Meal tomorrowEquivalentMeal(Meal meal, DayOfWeek todayWD) {
    DayOfWeek tomorrow = todayWD.next();
    if (isSpecialWeekDay(todayWD) == isSpecialWeekDay(tomorrow)) {
      return meal;
    } else {
      final defaultMealsLst = _sortedDefaultMeals();
      final specialDaysMealsLst = _sortedSpecialDaysMeals();
      if (isSpecialWeekDay(todayWD)) {
        final int mealIndex =
            specialDaysMealsLst.indexWhere((x) => x.key == meal);
        if (mealIndex == specialDaysMealsLst.length - 1) {
          return defaultMealsLst[defaultMealsLst.length - 1].key;
        } else {
          return defaultMealsLst[mealIndex].key;
        }
      } else {
        assert(isSpecialWeekDay(tomorrow));
        final int mealIndex = defaultMealsLst.indexWhere((x) => x.key == meal);
        if (mealIndex == defaultMealsLst.length - 1) {
          return specialDaysMealsLst[specialDaysMealsLst.length - 1].key;
        } else {
          return specialDaysMealsLst[mealIndex].key;
        }
      }
    }
  }

  /*
  List<MapEntry<Meal, TimeOfDay>> sortedMeals(DayOfWeek dw) =>
      isSpecialWeekDay(dw) ? sortedSpecialDaysMeals() : sortedDefaultMeals();
  */

  List<MapEntry<Meal, TimeOfDay>> _sortedDefaultMeals() {
    final defaultMealsLst = _defaultDaysMeals.entries.toList();
    defaultMealsLst.sort((x, y) => _compareTimeOfDay(x.value, y.value));
    developer.log("Els elements per defecte correctament ordenats: "
        "${_sortOrderIsCorrect(defaultMealsLst)}");
    return defaultMealsLst;
  }

  List<MapEntry<Meal, TimeOfDay>> _sortedSpecialDaysMeals() {
    final specialDaysMealsLst = _specialDaysMeals.entries.toList();
    specialDaysMealsLst.sort((x, y) => _compareTimeOfDay(x.value, y.value));
    developer.log("Els elements especificats correctament ordenats: "
        "${_sortOrderIsCorrect(specialDaysMealsLst)}");
    return specialDaysMealsLst;
  }

  int _compareTimeOfDay(TimeOfDay x, TimeOfDay other) {
    final int hourCmp = x.hour.compareTo(other.hour);
    if (hourCmp == 0) {
      return x.minute.compareTo(other.minute);
    } else {
      return hourCmp;
    }
  }

  // DEBUG: l'ordenació es fa per l'hora;
  // hauria de quedar també ordenada per les menjades
  bool _sortOrderIsCorrect(List<MapEntry<Meal, TimeOfDay>> lst) {
    return lst.indexed.every(
        (x) => x.$1 == lst.length - 1 || x.$2.key.id < lst[x.$1 + 1].key.id);
  }

  //----------------------------------------------------------------------------
  //------------   UPDATE   ----------------------------------------------------

  /// Define which days of week are "special"
  void defineSpecialWeekDays(Set<DayOfWeek> weekDays) {
    developer.log("- defineSpecialWeekDays", level: Level.FINER.value);
    if (weekDays.isEmpty) {
      removeSpecialWeekDays();
    } else if (weekDays.length < 7) {
      _specialWeekDays.addAll(weekDays);
    }
  }

  /// Remove all special days
  void removeSpecialWeekDays() {
    developer.log("- removeSpecialWeekDays", level: Level.FINER.value);
    _specialWeekDays.removeAll(_specialWeekDays.toList());
    // _specialDaysMeals.removeWhere((_, __) => true);
  }

  /// Set the time for a meal
  /// It can also be used for special days, using [isSpecialWeekDay]=true
  void defineMealTime(Meal meal, TimeOfDay time,
      [bool specialWeekDay = false]) {
    developer.log("- defineMealTime: $meal, $time", level: Level.FINER.value);
    if (specialWeekDay) {
      if (_specialWeekDays.isEmpty) {
        throw Exception(
            "Can't define special day meal time when special days are undefined");
      } else {
        _specialDaysMeals[meal] = time;
      }
    } else {
      _defaultDaysMeals[meal] = time;
    }
  }
}
