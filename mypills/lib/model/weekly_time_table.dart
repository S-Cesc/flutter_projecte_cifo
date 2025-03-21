// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
// l10n
import '../l10n/app_localizations.dart' show AppLocalizations;
// projecte
import '../extensions/time_of_day_extensions.dart';
import 'global_constants.dart';
import 'enum/day_of_week_bitset.dart';
import 'enum/speed_label.dart';
import 'enum/meal.dart';
import 'enum/day_of_week.dart';
import 'day_of_week_partitions.dart';
import 'general_preferences.dart';

//==============================================================================

typedef _MealMap = Map<Meal, (TimeOfDay, SpeedLabel)>;

//==============================================================================

/// Two sets of meals (which meals) with its times,
/// and a set of DayOfWeek to diferenciate the set of meals for each day of week
class WeeklyTimeTable {
  //
  //----------------------------------------------------------------------------
  //-------------------------static/constant------------------------------------

  /// Shortname
  /// Min minutes between meals is added to meal duration
  static const int minMinutesBetweenMeals =
      GlobalConstants.minMinutesBetweenMeals;

  /// Shortname
  /// Allows time sequence to pass to the next day
  static const int maxMinutesBetweenMeals =
      GlobalConstants.maxMinutesBetweenMeals;

  /// Shortname
  static const _nAltMealTimeTables = GlobalConstants.nAltMealTimeTables;

  /// Shortname
  static const _nMealPrescriptions = GlobalConstants.nMealPrescriptions;

  /// The names of every partition:
  /// - The main one (without days of week)
  /// - The others ones
  static (String, List<String>) partitionNames(AppLocalizations t) {
    return (
      t.weeklyDefaultTimetable,
      List.unmodifiable([
        t.weeklyAltTimetable1,
        t.weeklyAltTimetable2,
        t.weeklyAltTimetable3,
      ]),
    );
  }

  static Map<String, dynamic> _timeTableToJson(
    Map<Meal, (TimeOfDay, SpeedLabel)> value,
  ) {
    // value conversion private function
    String toString((TimeOfDay, SpeedLabel) value) {
      return "${value.$1.toJsonString}@${value.$2.name}";
    }

    final Map<String, dynamic> result = {};
    for (var x in value.entries) {
      result[x.key.id.toString()] = toString(x.value);
    }
    return result;
  }

  static Map<Meal, (TimeOfDay, SpeedLabel)> _timeTableFromJson(
    Map<String, dynamic> jsonMealTimes,
  ) {
    // value conversion private function
    (TimeOfDay, SpeedLabel)? fromString(String? value) {
      if (value == null) {
        return null;
      } else {
        final vSplitted = value.split("@");
        if (vSplitted.length != 2) {
          return null;
        } else {
          return (
            TimeOfDayExtension.parseTimeOfDay(vSplitted[0])!,
            SpeedLabel.values.byName(vSplitted[1]),
          );
        }
      }
    }

    final _MealMap timeTable = {};
    for (var x in jsonMealTimes.entries) {
      final key = int.parse(x.key);
      final value = fromString(x.value as String?);
      if (value != null) {
        timeTable.putIfAbsent(Meal.fromId(key), () => value);
      }
    }
    return timeTable;
  }

  static List<dynamic> _lstTimeTableToJson(
    List<Map<Meal, (TimeOfDay, SpeedLabel)>> value,
  ) {
    assert(value.length == _nAltMealTimeTables);
    return List<Map<String, dynamic>>.generate(
      value.length,
      (int i) => _timeTableToJson(value[i]),
      growable: false,
    );
  }

  static List<Map<Meal, (TimeOfDay, SpeedLabel)>> _lstTimeTableFromJson(
    List<dynamic> value,
  ) {
    assert(value.length == _nAltMealTimeTables);
    return List<Map<Meal, (TimeOfDay, SpeedLabel)>>.generate(
      value.length,
      (int i) => _timeTableFromJson(value[i] as Map<String, dynamic>),
      growable: false,
    );
  }

  static List<dynamic> _lstTimeToSleepToJson(List<TimeOfDay> value) {
    assert(value.length == _nAltMealTimeTables);
    return List<dynamic>.generate(
      value.length,
      (int i) => value[i].toJsonString,
      growable: false,
    );
  }

  static List<TimeOfDay> _lstTimeToSleepFromJson(List<dynamic> value) {
    assert(value.length == _nAltMealTimeTables);
    return List<TimeOfDay>.generate(
      value.length,
      (int i) =>
          TimeOfDayExtension.parseTimeOfDay(value[i] as String) ??
          GeneralPreferences.defaultTimeToSleep,
      growable: false,
    );
  }

  //----------------------------------------------------------------------------
  //----------class state members and constructors------------------------------

  /// Some functions need to call preferences settings
  /// - Used to compute the meal durations
  final ReadOnlyGeneralPreferences _callback;

  final _MealMap _defaultDaysMeals;
  TimeOfDay _defaultDaysTimeToSleep;
  final DayOfWeekPartitions _specialWeekdays;
  final List<_MealMap> _specialDaysMeals;
  final List<TimeOfDay> _specialDaysTimeToSleep;
  bool _modified;

  /// Create an empty weekly time table
  WeeklyTimeTable.empty(
    ReadOnlyGeneralPreferences callback,
  ) : _callback = callback,
      _defaultDaysMeals = {},
      _defaultDaysTimeToSleep = GeneralPreferences.defaultTimeToSleep,
      _specialWeekdays = DayOfWeekPartitions(
        numberOfSubsets: _nAltMealTimeTables,
      ),
      _specialDaysMeals = List<_MealMap>.generate(
        _nAltMealTimeTables,
        (_) => _MealMap(),
        growable: false,
      ),
      _specialDaysTimeToSleep = List<TimeOfDay>.generate(
        _nAltMealTimeTables,
        (_) => GeneralPreferences.defaultTimeToSleep,
        growable: false,
      ),
      _modified = false;

  /// Clone from an other instance
  @protected
  WeeklyTimeTable.clone(WeeklyTimeTable wtt)
    : _callback = wtt._callback,
      _defaultDaysMeals = Map<Meal, (TimeOfDay, SpeedLabel)>.from(
        wtt.defaultDaysMeals,
      ),
      _defaultDaysTimeToSleep = wtt.getTimeToSleep(null),
      _specialWeekdays = DayOfWeekPartitions.clone(wtt.specialWeekdays),
      _specialDaysMeals = List<_MealMap>.generate(
        _nAltMealTimeTables,
        (int i) =>
            Map<Meal, (TimeOfDay, SpeedLabel)>.from(wtt.specialDaysMeals(i)),
        growable: false,
      ),
      _specialDaysTimeToSleep = List<TimeOfDay>.generate(
        _nAltMealTimeTables,
        (int i) => wtt._specialDaysTimeToSleep[i],
        growable: false,
      ),
      _modified = wtt._modified;

  // use Map<String, dynamic> parsedJson = jsonDecode(json);
  /// constructor from Json object got from jsonDecode of a string
  WeeklyTimeTable.fromJson(
    this._callback,
    Map<String, dynamic> parsedJson,
  ) : _defaultDaysMeals = _timeTableFromJson(
        parsedJson['defaultMeals'] as Map<String, dynamic>,
      ),
      _defaultDaysTimeToSleep =
          TimeOfDayExtension.parseTimeOfDay(
            parsedJson['defaultDaysTimeToSleep'] as String?,
          ) ??
          GeneralPreferences.defaultTimeToSleep,
      _specialWeekdays = DayOfWeekPartitions.parse(
        parsedJson['specialWD'] as String,
      ),
      _specialDaysMeals = (_lstTimeTableFromJson(
        parsedJson['specialDaysMeals'] as List<dynamic>,
      )),
      _specialDaysTimeToSleep = _lstTimeToSleepFromJson(
        parsedJson['specialDaysTimeToSleep'] as List<dynamic>,
      ),
      _modified = false {
    _ensureCoherence();
  }

  /// Are there any changes?
  bool get modified => _modified;

  /// There are no changes (changes saved)
  void resetModified() {
    _modified = false;
  }

  //----------------------------------------------------------------------------
  //----------class special members---------------------------------------------

  /// convert to Json object, which also must be encoded into a String
  Map<String, dynamic> toJson() {
    _ensureCoherence();
    return {
      'defaultMeals': _timeTableToJson(_defaultDaysMeals),
      'defaultDaysTimeToSleep': _defaultDaysTimeToSleep.toJsonString,
      'specialWD': _specialWeekdays.toString(),
      'specialDaysMeals': _lstTimeTableToJson(_specialDaysMeals),
      'specialDaysTimeToSleep': _lstTimeToSleepToJson(_specialDaysTimeToSleep),
    };
  }

  /// Copy values from another WeeklyTimeTable
  void copyValues(WeeklyTimeTable wtt) {
    _defaultDaysMeals.clear();
    _defaultDaysMeals.addAll(wtt._defaultDaysMeals);
    _defaultDaysTimeToSleep = wtt._defaultDaysTimeToSleep;
    _specialWeekdays.copyFrom(wtt._specialWeekdays);
    for (int i = 0; i < _nAltMealTimeTables; i++) {
      _specialDaysMeals[i].clear();
      _specialDaysMeals[i].addAll(wtt._specialDaysMeals[i]);
      _specialDaysTimeToSleep[i] = wtt._specialDaysTimeToSleep[i];
    }
    _modified = true;
  }

  /// Require a minimum of 3 meals a day (needed for prescriptions)
  /// It is required for all defined partitions:
  /// - The main partition always must be defined
  /// - The rest of partitions can be defined or not
  bool get isFullyDefined {
    final maxLength = Meal.values.length;
    if (_specialDaysMeals.length == _nAltMealTimeTables &&
        _specialWeekdays.numberOfSubsets == _nAltMealTimeTables &&
        _defaultDaysMeals.length <= maxLength &&
        _specialDaysMeals.every((x) => x.length <= maxLength)) {
      bool result = _defaultDaysMeals.length >= _nMealPrescriptions;
      {
        int i = 0;
        while (result && i < _nAltMealTimeTables) {
          if (_isPartitionConsistent(i)) {
            // Only take into account the partitions that are defined
            if (_isPartitionDefined(i)) {
              result &= _specialDaysMeals[i].length >= _nMealPrescriptions;
            }
          } else {
            // Editing partition may not be consistent
            result = false;
          }
          i++;
        }
      }
      return result;
    } else {
      throw FormatException("Incorrect WeeklyTimeTable structure.");
    }
  }

  // TODO: remove this
  /// Check which partition is not fully defined
  (bool, List<bool>) fullyDefinedPartitions() {
    final bool mainResult = _defaultDaysMeals.length >= _nMealPrescriptions;
    final restResults = List<bool>.generate(
      _nAltMealTimeTables,
      (int partition) =>
          _isPartitionConsistent(partition) &&
          _isPartitionDefined(partition) &&
          _specialDaysMeals[partition].length >= _nMealPrescriptions,
    );
    return (mainResult, restResults);
  }

  /// Check whether the partition is fully defined:
  /// it has [_nMealPrescriptions] meals well defined
  /// [partition] null means the main partition
  bool isPartitionFullyDefined([int? partition]) {
    if (partition == null) {
      return _defaultDaysMeals.length >= _nMealPrescriptions;
    } else if (partition > 0 && partition <= _nAltMealTimeTables) {
      return _isPartitionConsistent(partition) &&
          _isPartitionDefined(partition) &&
          _specialDaysMeals[partition].length >= _nMealPrescriptions;
    } else {
      throw ArgumentError("Invalid partition number: $partition");
    }
  }

  bool _isPartitionDefined(int i) {
    return specialWeekdays.partitionWeekdays(i).count() > 0 &&
        _specialDaysMeals[i].isNotEmpty;
  }

  bool _isPartitionConsistent(int i) {
    return specialWeekdays.partitionWeekdays(i).count() > 0 ==
        _specialDaysMeals[i].isNotEmpty;
  }

  //----------------------------------------------------------------------------
  //----------class special members---------------------------------------------
  //----------check coherence---------------------------------------------------

  /// Procedure to call when the data is updated
  /// It is also called when the data is retrieved
  /// It makes updates in the data, "special updates" as:
  /// - It is binded with a data update
  /// - Otherwise, it is called when the data is retrieved,
  ///   but changes don't require to be saved
  ///   (they are implicity the same values as the incorrect ones stored)
  void _ensureCoherence() {
    // begin
    _defaultDaysTimeToSleep = _ensureMealTimeCoherence(
      null,
      _defaultDaysMeals,
      _defaultDaysTimeToSleep,
    );
    for (int part = 0; part < _nAltMealTimeTables; part++) {
      // per a definir les hores de menjar en els dies alternatius
      // s'ha de definir quins son els dies alternatius
      final map = _specialDaysMeals[part];
      final weekDaySet = _specialWeekdays.partitionWeekdays(part);
      if (weekDaySet.isEmpty && map.isNotEmpty) {
        map.clear();
      } else if (map.isEmpty && weekDaySet.isNotEmpty) {
        _specialWeekdays.clear(part);
      } else {
        _specialDaysTimeToSleep[part] = _ensureMealTimeCoherence(
          null,
          map,
          _specialDaysTimeToSleep[part],
        );
      }
    }
  }

  /// Fix [fromMeal] subsequent values to ensure coherence
  /// Use a [fromMeal] null value to fix all the entries
  /// Returns the value of the time to sleep updated
  TimeOfDay _ensureMealTimeCoherence(
    Meal? fromMeal,
    _MealMap map,
    TimeOfDay timeToSleep, [
    void Function()? notifyChanges,
  ]) {
    //
    // local private function
    Meal min(Iterable<Meal> cjt) {
      return cjt.reduce((a, b) => a.id.compareTo(b.id) < 0 ? a : b);
    }

    // local private function
    Meal? previousDefinedMeal(Meal meal) {
      var prevMeal = meal.previous();
      while (prevMeal != null && !map.containsKey(prevMeal)) {
        prevMeal = prevMeal.previous();
      }
      return prevMeal;
    }

    // local private function
    Meal? nextDefinedMeal(Meal meal) {
      var nextMeal = meal.next();
      while (nextMeal != null && !map.containsKey(nextMeal)) {
        nextMeal = nextMeal.next();
      }
      return nextMeal;
    }

    // local private function
    /// Checks whether nextMealTime is a valid TimeOfDay for the next meal
    TimeOfDay nextMealTimeUpdated(
      TimeOfDay mealTime,
      int mealDurationMinutes,
      TimeOfDay nextMealTime,
    ) {
      final TimeOfDay mealEndTime = mealTime.plusMinutes(
        mealDurationMinutes + minMinutesBetweenMeals,
      );
      if (mealEndTime.isLater(nextMealTime, maxMinutesBetweenMeals)) {
        return mealEndTime;
      } else {
        return nextMealTime;
      }
    }

    // local private recursive function
    TimeOfDay ensureMealMapCoherence(Meal fromMeal, TimeOfDay timeToSleep) {
      developer.log("Coherence: $fromMeal", level: Level.FINER.value);
      final TimeOfDay fromMealTime = map[fromMeal]!.$1;
      final SpeedLabel fromMealSpeed = map[fromMeal]!.$2;
      final int mealDuration =
          _callback.getMealDuration(fromMeal, fromMealSpeed).inMinutes;
      final nextMeal = nextDefinedMeal(fromMeal);
      final currentTimeNextMeal =
          nextMeal == null ? timeToSleep : map[nextMeal]!.$1;
      final timeNextMeal = nextMealTimeUpdated(
        fromMealTime,
        mealDuration,
        currentTimeNextMeal,
      );
      if (nextMeal != null) {
        if (timeNextMeal.isLater(currentTimeNextMeal, maxMinutesBetweenMeals)) {
          map[nextMeal] = (timeNextMeal, map[nextMeal]!.$2);
          notifyChanges?.call();
        }
        // recursive
        return ensureMealMapCoherence(nextMeal, timeToSleep);
      } else {
        return timeNextMeal;
      }
    }

    // begin _ensureMealTimeCoherence
    if (map.isNotEmpty) {
      if (fromMeal == null) {
        developer.log(
          "Full coherence (default: from first meal)",
          level: Level.FINER.value,
        );
        final firstMeal = min(map.keys);
        final newTimeToSleep = ensureMealMapCoherence(firstMeal, timeToSleep);
        if (newTimeToSleep.gt(timeToSleep, maxMinutesBetweenMeals)) {
          notifyChanges?.call();
          return newTimeToSleep;
        } else {
          return timeToSleep;
        }
      } else {
        developer.log(
          "Incremental coherence: $fromMeal",
          level: Level.FINER.value,
        );
        final prevMeal = previousDefinedMeal(fromMeal);
        final newTimeToSleep = ensureMealMapCoherence(
          prevMeal ?? fromMeal,
          timeToSleep,
        );
        if (newTimeToSleep.gt(timeToSleep, maxMinutesBetweenMeals)) {
          notifyChanges?.call();
          return newTimeToSleep;
        } else {
          return timeToSleep;
        }
      }
    } else {
      return timeToSleep;
    }
  }

  //----------------------------------------------------------------------------
  //----------class rest of members---------------------------------------------

  /// Check wether a value is included in any of the special days partitions
  /// Otherwise it is in the _defaultDaysMeals
  bool isSpecialWeekDay(DayOfWeek dw) => _specialWeekdays.contains(dw);

  /// The default days meal timings
  /// NOTE: It's updatable
  Map<Meal, (TimeOfDay, SpeedLabel)> get defaultDaysMeals => _defaultDaysMeals;

  /// Return the Map of the partition [altTimeTable]
  /// The special days are divided into partitions
  /// Each partition has a map of meals with its timings
  /// NOTE: It's updatable
  Map<Meal, (TimeOfDay, SpeedLabel)> specialDaysMeals(int altTimeTable) =>
      _specialDaysMeals[altTimeTable];

  /// Selection of the special days divided into into partitions
  /// Each partition represent a different case
  /// NOTE: It's updatable
  DayOfWeekPartitions get specialWeekdays => _specialWeekdays;

  /// The DayOfWeekBitset of the [altTimeTable] partition
  /// Updates are not reflected in the object (readonly value)
  DayOfWeekBitset partitionWeekdays(int altTimeTable) =>
      _specialWeekdays.partitionWeekdays(altTimeTable);

  /// At what time is the [meal]?
  /// It can also ask for special days, using [altTimeTable]=true
  /// NOTE: It's updatable
  TimeOfDay? mealTime(Meal meal, int? altTimeTable) {
    if (altTimeTable == null) {
      return _defaultDaysMeals[meal]?.$1;
    } else {
      return _specialDaysMeals[altTimeTable][meal]?.$1;
    }
  }

  /// How long is the [meal]?
  /// It can also ask for special days, using [isSpecialWeekDay]=true
  /// NOTE: It's updatable
  SpeedLabel? mealSpeed(Meal meal, int? altTimeTable) {
    if (altTimeTable == null) {
      return _defaultDaysMeals[meal]?.$2;
    } else {
      return _specialDaysMeals[altTimeTable][meal]?.$2;
    }
  }

  /// Get timeToSleep configuration
  TimeOfDay getTimeToSleep(int? altTimeTable) {
    if (altTimeTable == null) {
      return _defaultDaysTimeToSleep;
    } else {
      return _specialDaysTimeToSleep[altTimeTable];
    }
  }

  //TODO: Meal application: The meal may be is not present on that day of week
  /// At what time is the [meal] on [day]
  /// To answer it selects the partition which [day] belongs to
  TimeOfDay? dayMealTime(Meal meal, DayOfWeek day) {
    final map =
        isSpecialWeekDay(day)
            ? _specialDaysMeals[_specialWeekdays[day]!]
            : _defaultDaysMeals;
    return map[meal]?.$1;
  }

  //TODO: Meal application: The meal may be is not present on that day of week
  /// What is the speed used for [meal] on [day]?
  /// To answer it selects the partition which [day] belongs to
  SpeedLabel? dayMealSpeed(Meal meal, DayOfWeek day) {
    final map =
        isSpecialWeekDay(day)
            ? _specialDaysMeals[_specialWeekdays[day]!]
            : _defaultDaysMeals;
    return map[meal]?.$2;
  }

  //TODO: Meal application: Remove all that!!! (use an alternative algorithm)
  /// Search tomorrow equivalent meal
  Meal tomorrowEquivalentMeal(Meal meal, DayOfWeek todayWD) {
    // DEBUG: l'ordenació es fa per l'hora;
    // hauria de quedar també ordenada per les menjades

    DayOfWeek tomorrow = todayWD.next();
    Map<Meal, (TimeOfDay, SpeedLabel)> tomorrowMeals = _dayOfWeekMap(tomorrow);

    if (tomorrowMeals.containsKey(meal)) {
      // Equivalence by name
      return meal;
    } else {
      final Map<Meal, (TimeOfDay, SpeedLabel)> todayMeals = _dayOfWeekMap(
        todayWD,
      );
      final List<Meal> todayMealsLst = todayMeals.keys.toList(growable: false);
      final List<Meal> tomorrowMealsLst = tomorrowMeals.keys.toList(
        growable: false,
      );
      todayMealsLst.sort((x, y) => x.id.compareTo(y.id));
      tomorrowMealsLst.sort((x, y) => x.id.compareTo(y.id));
      final int mealIndex = todayMealsLst.indexWhere((x) => x == meal);

      if (mealIndex == 0) {
        // First of the day
        return tomorrowMealsLst[0];
      } else if (mealIndex == 1) {
        // Second of the day
        // usually will be lunch or brunch
        return tomorrowMealsLst[1];
      } else if (mealIndex == todayMealsLst.length - 1) {
        // Last of the day
        return tomorrowMealsLst[tomorrowMealsLst.length - 1];
      } else if (tomorrowMealsLst.length == todayMealsLst.length) {
        // Equivalence by index
        return tomorrowMealsLst[mealIndex];
      } else {
        // Empiric
        final diff = (todayMealsLst.length - tomorrowMealsLst.length).abs();
        return tomorrowMealsLst[mealIndex +
            (tomorrowMealsLst.length > todayMealsLst.length ? diff : -diff)];
      }
    }
  }

  /// Which partition (map) does [day] belong to?
  /// It will return _defaultDaysMeals when it is not a SpecialWeekDay
  _MealMap _dayOfWeekMap(DayOfWeek day) {
    if (isSpecialWeekDay(day)) {
      return _specialDaysMeals[_specialWeekdays[day]!];
    } else {
      return _defaultDaysMeals;
    }
  }

  /// Get the minimum meal from [altTimeTable]
  ///  which is greater or equal to [from]
  Meal? minMeal(Meal from, [int? altTimeTable]) {
    final map =
        altTimeTable == null
            ? _defaultDaysMeals
            : _specialDaysMeals[altTimeTable];
    final result = map.keys.reduce(
      (a, b) => (a.id >= from.id && a.id.compareTo(b.id) < 0) ? a : b,
    );
    return result.id >= from.id ? result : null;
  }

  /// Is the meal defined?
  /// It can also be used for special days, using the [altTimeTable]
  bool isMealDefined(Meal meal, [int? altTimeTable]) {
    if (altTimeTable == null) {
      return defaultDaysMeals.containsKey(meal);
    } else {
      return _specialDaysMeals[altTimeTable].containsKey(meal);
    }
  }
}

//==============================================================================
//------------------------------------------------------------------------------
//--------- Edit Provider (UPDATE) ---------------------------------------------
//------------------------------------------------------------------------------

/// Edit provider for a WeeklyTimeTable
class EditProviderWeeklyTimeTable extends WeeklyTimeTable with ChangeNotifier {
  /// The WeeklyTimeTable edit provider
  /// is always built from an existing WeeklyTimeTable
  EditProviderWeeklyTimeTable(super.wtt) : super.clone();

  //TODO: use a callback function
  void _notifyChanges(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.timeTableModifiedWarning),
        backgroundColor: Colors.red,
      ),
    );
    notifyListeners();
  }

  //TODO: use a callback function
  void _notifyEmptyDayset(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.emptyDaysetError), backgroundColor: Colors.red),
    );
  }

  /// Define which days of week are "special"
  void defineSpecialWeekDays(Set<DayOfWeek> weekDays, int altTimeTable) {
    developer.log("- defineSpecialWeekDays", level: Level.FINER.value);
    if (weekDays.isEmpty) {
      developer.log("-> removeSpecialWeekDays", level: Level.FINER.value);
      if (_specialWeekdays.isNotEmpty) {
        _specialWeekdays.clear(altTimeTable);
        _specialDaysMeals[altTimeTable].clear();
        _modified = true;
        notifyListeners();
      }
    } else {
      bool hasChanges = false;
      final partitionDays = _specialWeekdays.partitionWeekdays(altTimeTable);
      for (int d = 1; d <= 7; d++) {
        final day = DayOfWeek.fromId(d);
        if (partitionDays.contains(day)) {
          if (!weekDays.contains(day)) {
            _specialWeekdays.remove(fromPart: altTimeTable, day: day);
            if (_specialWeekdays.isEmpty) {
              _specialDaysMeals[altTimeTable].clear();
            }
            hasChanges = true;
          }
        } else if (weekDays.contains(day)) {
          _specialWeekdays[day] = altTimeTable;
          // NOTE: structure now may be inconsistent (no meals defined)
          // - user must set the _specialDaysMeals[altTimeTable]
          hasChanges = true;
        }
      }
      if (hasChanges) {
        _modified = true;
        notifyListeners();
      }
    }
  }

  /// Add a meal definition
  /// It can also be used for special days, using the [altTimeTable]
  void defineMeal(
    BuildContext context,
    Meal meal,
    (TimeOfDay, SpeedLabel) value, [
    int? altTimeTable,
  ]) {
    if (!isMealDefined(meal, altTimeTable)) {
      bool timeTableModified = false;
      developer.log("- add Meal $meal: $value", level: Level.FINER.value);
      if (altTimeTable == null) {
        assert(!_defaultDaysMeals.containsKey(meal));
        _defaultDaysMeals[meal] = value;
        // coherence
        final tmpTimeToSleep = _defaultDaysTimeToSleep;
        _defaultDaysTimeToSleep = TimeOfDayExtension.max(
          tmpTimeToSleep,
          _ensureMealTimeCoherence(meal, _defaultDaysMeals, tmpTimeToSleep, () {
            timeTableModified = true;
          }),
          WeeklyTimeTable.maxMinutesBetweenMeals,
        );
      } else {
        assert(!_specialDaysMeals[altTimeTable].containsKey(meal));
        if (_specialWeekdays.partitionWeekdays(altTimeTable).isEmpty) {
          _specialDaysMeals[altTimeTable].clear();
          _notifyEmptyDayset(context);
        } else {
          _specialDaysMeals[altTimeTable][meal] = value;
          // coherence
          final tmpTimeToSleep = _specialDaysTimeToSleep[altTimeTable];
          _specialDaysTimeToSleep[altTimeTable] = TimeOfDayExtension.max(
            tmpTimeToSleep,
            _ensureMealTimeCoherence(
              meal,
              _specialDaysMeals[altTimeTable],
              tmpTimeToSleep,
              () {
                timeTableModified = true;
              },
            ),
            WeeklyTimeTable.maxMinutesBetweenMeals,
          );
        }
      }
      _modified = true;
      notifyListeners();
      if (timeTableModified) _notifyChanges(context);
    } else {
      developer.log(
        "Can't add the Meal $meal, because already exists",
        level: Level.FINER.value,
      );
    }
  }

  /// Remove a meal from the collection
  /// It can also be used for special days, using the [altTimeTable]
  void removeMeal(BuildContext context, Meal meal, [int? altTimeTable]) {
    if (isMealDefined(meal, altTimeTable)) {
      developer.log("- remove Meal $meal", level: Level.FINER.value);
      if (altTimeTable == null) {
        assert(_defaultDaysMeals.containsKey(meal));
        _defaultDaysMeals.removeWhere((m, _) => m == meal);
        // coherence check - not needed
      } else {
        assert(_specialDaysMeals[altTimeTable].containsKey(meal));
        _specialDaysMeals[altTimeTable].removeWhere((m, _) => m == meal);
        // coherence check - not needed
      }
      _modified = true;
      notifyListeners();
    } else {
      developer.log(
        "Can't remove not exisiting Meal $meal",
        level: Level.FINER.value,
      );
    }
  }

  /// Set the time for a meal
  /// It can also be used for special days, using the [altTimeTable]
  void defineMealTime(
    BuildContext context,
    Meal meal,
    TimeOfDay mealtime, [
    int? altTimeTable,
  ]) {
    if (isMealDefined(meal, altTimeTable)) {
      developer.log(
        "- defineMealTime on partition ${altTimeTable ?? 'usual'}"
        ": $meal, $mealtime",
        level: Level.FINER.value,
      );
      bool hasChanges = false;
      bool timeTableModified = false;
      if (altTimeTable == null) {
        assert(_defaultDaysMeals.containsKey(meal));
        bool isNewValue = _defaultDaysMeals[meal]!.$1 != mealtime;
        if (isNewValue) {
          final mealSpeed = _defaultDaysMeals[meal]!.$2;
          _defaultDaysMeals[meal] = (mealtime, mealSpeed);
          hasChanges = true;
          // coherence
          final tmpTimeToSleep = _defaultDaysTimeToSleep;
          _defaultDaysTimeToSleep = TimeOfDayExtension.max(
            tmpTimeToSleep,
            _ensureMealTimeCoherence(
              meal,
              _defaultDaysMeals,
              tmpTimeToSleep,
              () {
                timeTableModified = true;
              },
            ),
            WeeklyTimeTable.maxMinutesBetweenMeals,
          );
        }
      } else {
        assert(_specialWeekdays.partitionWeekdays(altTimeTable).isNotEmpty);
        assert(_specialDaysMeals[altTimeTable].containsKey(meal));
        bool isNewValue = _specialDaysMeals[altTimeTable][meal]!.$1 != mealtime;
        if (isNewValue) {
          final mealSpeed = _specialDaysMeals[altTimeTable][meal]!.$2;
          _specialDaysMeals[altTimeTable][meal] = (mealtime, mealSpeed);
          hasChanges = true;
          // coherence
          final tmpTimeToSleep = _specialDaysTimeToSleep[altTimeTable];
          _specialDaysTimeToSleep[altTimeTable] = TimeOfDayExtension.max(
            tmpTimeToSleep,
            _ensureMealTimeCoherence(
              meal,
              _specialDaysMeals[altTimeTable],
              tmpTimeToSleep,
              () {
                timeTableModified = true;
              },
            ),
            WeeklyTimeTable.maxMinutesBetweenMeals,
          );
        }
      }
      if (hasChanges) {
        _modified = true;
        notifyListeners();
        if (timeTableModified) _notifyChanges(context);
      }
    } else {
      developer.log(
        "Can't access to the not exisiting Meal $meal in the "
        "${altTimeTable == null ? 'default ' : ''}"
        "partition ${altTimeTable ?? ''}.",
        level: Level.FINER.value,
      );
    }
  }

  /// Set the time for a meal
  /// It can also be used for special days, using the [altTimeTable]
  void defineMealSpeed(
    BuildContext context,
    Meal meal,
    SpeedLabel speed, [
    int? altTimeTable,
  ]) {
    if (isMealDefined(meal, altTimeTable)) {
      developer.log(
        "- defineMealSpeed ${altTimeTable ?? 'usual'}: $meal, $speed",
        level: Level.FINER.value,
      );
      bool hasChanges = false;
      bool timeTableModified = false;
      if (altTimeTable == null) {
        assert(_defaultDaysMeals.containsKey(meal));
        bool isNewValue = _defaultDaysMeals[meal]!.$2 != speed;
        if (isNewValue) {
          final mealTime = _defaultDaysMeals[meal]!.$1;
          _defaultDaysMeals[meal] = (mealTime, speed);
          hasChanges = true;
          // coherence
          final tmpTimeToSleep = _defaultDaysTimeToSleep;
          _defaultDaysTimeToSleep = TimeOfDayExtension.max(
            tmpTimeToSleep,
            _ensureMealTimeCoherence(
              meal,
              _defaultDaysMeals,
              tmpTimeToSleep,
              () {
                timeTableModified = true;
              },
            ),
            WeeklyTimeTable.maxMinutesBetweenMeals,
          );
        }
      } else {
        assert(_specialWeekdays.partitionWeekdays(altTimeTable).isNotEmpty);
        assert(_specialDaysMeals[altTimeTable].containsKey(meal));
        bool isNewValue = _specialDaysMeals[altTimeTable][meal]!.$2 != speed;
        if (isNewValue) {
          final mealTime = _specialDaysMeals[altTimeTable][meal]!.$1;
          _specialDaysMeals[altTimeTable][meal] = (mealTime, speed);
          hasChanges = true;
          // coherence
          final tmpTimeToSleep = _specialDaysTimeToSleep[altTimeTable];
          _specialDaysTimeToSleep[altTimeTable] = TimeOfDayExtension.max(
            tmpTimeToSleep,
            _ensureMealTimeCoherence(
              meal,
              _specialDaysMeals[altTimeTable],
              tmpTimeToSleep,
              () {
                timeTableModified = true;
              },
            ),
            WeeklyTimeTable.maxMinutesBetweenMeals,
          );
        }
      }
      if (hasChanges) {
        _modified = true;
        notifyListeners();
        if (timeTableModified) _notifyChanges(context);
      }
    } else {
      developer.log(
        "Can't access to the not exisiting Meal $meal in the "
        "${altTimeTable == null ? 'default ' : ''}"
        "partition ${altTimeTable ?? ''}.",
        level: Level.FINER.value,
      );
    }
  }

  /// Set timeToSleep configuration
  void setTimeToSleep(
    BuildContext context,
    TimeOfDay value, [
    int? altTimeTable,
  ]) {
    //
    // local private proc
    bool effectiveSet(TimeOfDay value, [int? altTimeTable]) {
      if (altTimeTable == null) {
        if (_defaultDaysTimeToSleep != value) {
          _defaultDaysTimeToSleep = value;
          return true;
        } else {
          return false;
        }
      } else {
        if (_specialDaysTimeToSleep[altTimeTable] != value) {
          _specialDaysTimeToSleep[altTimeTable] = value;
          return true;
        } else {
          return false;
        }
      }
    }

    // local private function
    TimeOfDay getMinTimeToSleep(int? altTimeTable) {
      final _MealMap timeTable =
          altTimeTable == null
              ? _defaultDaysMeals
              : _specialDaysMeals[altTimeTable];
      if (timeTable.isEmpty) {
        return TimeOfDayExtension.beginOfTheDay;
      } else {
        Meal lastMeal = Meal.values.last;
        while (!timeTable.containsKey(lastMeal)) {
          lastMeal = lastMeal.previous()!;
        }
        final TimeOfDay lastMealTime = timeTable[lastMeal]!.$1;
        final mealDuration = _callback.getMealDuration(
          lastMeal,
          timeTable[lastMeal]!.$2,
        );
        return lastMealTime.plusMinutes(
          mealDuration.inMinutes + WeeklyTimeTable.minMinutesBetweenMeals,
        );
      }
    }

    // setTimeToSleep
    final minTimeToSleep = getMinTimeToSleep(altTimeTable);
    bool hasChanges = false;
    // Check that minTimeToSleep is before value
    // Warning! may be value is at the next day!
    // We use maxMinutesBetweenMeals to mesure difference,
    // which must be long enough
    if (value.gte(minTimeToSleep, WeeklyTimeTable.maxMinutesBetweenMeals) &&
        minTimeToSleep.minutesUntil(value) <=
            WeeklyTimeTable.maxMinutesBetweenMeals) {
      hasChanges = effectiveSet(value, altTimeTable);
    } else if (effectiveSet(minTimeToSleep, altTimeTable)) {
      hasChanges = true;
      _notifyChanges(context);
    }
    if (hasChanges) {
      _modified = true;
      notifyListeners();
    }
  }
}
