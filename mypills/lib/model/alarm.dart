// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// Localizations
import '../l10n/app_localizations.dart';
// Project files
import 'enum/meal.dart';
import 'enum/day_of_week.dart';
import 'enum/pill_meal_time.dart';
import 'meal_pillmealtime_pair.dart';
import 'weekly_time_table.dart';
// Project extensions
import '../extensions/date_time_extensions.dart';

//==============================================================================

//TODO: Include iterable of PrescriptionKeys
// - as an iterable of <PrescriptionKey, PrescriptionFrequency>

/// Objects representing an alarm at some time in the day:
/// - Meal
/// - pillMealTime
class Alarm implements Comparable<Alarm> {
  //
  //----------------------------------------------------------------------------
  //-------------------------static/constant------------------------------------

  static const _pairKey = 'IdKey';
  static const _lastShotKey = 'lastShot';
  static const _stoppedKey = 'stopped';
  static const _dealingWithKey = 'dealingWith';
  static const _isRunningKey = 'isRunning';
  static const _isSnoozedKey = 'isSnoozed';
  static const _actualReplayKey = 'nReplay';

  /// Get the string key used to store the alarm
  /// from its key pair ([meal], [pillMealTime])
  static String alarmKey(
    String keyPrefix,
    Meal meal,
    PillMealTime pillMealTime,
  ) {
    return "$keyPrefix"
        "${MealPillmealtimePair.getIdFromPair(meal, pillMealTime)}";
  }

  // Remember localization must be initialized:
  //    await initializeDateFormatting("ca", null)
  // You can get the current locale from widget
  // locale = WidgetsBinding.instance!.window.locale
  /// Localized Alarm name from [id]
  static String getAlarmNameFromId(AppLocalizations t, int id) {
    if (kDebugMode) {
      // idAlarmText
      // not imported from BackgroundEntry to avoid circular reference
      const idAlarmText = 3;
      if (id == idAlarmText) {
        return "Alarma de prova";
      }
    }
    return MealPillmealtimePair.getPairNameFromId(t, id);
  }

  /// Localized Alarm name from its key pair ([meal], [pillMealTime])
  static String getAlarmName(
    Meal meal,
    PillMealTime pillMealTime,
    AppLocalizations t,
  ) {
    return MealPillmealtimePair.getPairName(t, meal, pillMealTime);
  }

  //----------------------------------------------------------------------------
  //-----------------class state members and constructors ----------------------

  /// Alarm key pair ([meal], [pillMealTime])
  final MealPillmealtimePair pair;

  /// Compute the alarm unique id
  int get id => pair.id;

  DateTime? _lastShot;
  DateTime? _stopped;
  DateTime? _dealingWith;
  bool _isRunning;
  bool _isSnoozed;
  int _actualReplay;

  /// Ctor
  Alarm(int id)
    : pair = MealPillmealtimePair(id),
      _isRunning = false,
      _isSnoozed = false,
      _actualReplay = 0,
      _lastShot = null,
      _stopped = null,
      _dealingWith = null;

  /// Alarm with empty (default) values.
  /// The key inmutable values ([meal], [pillMealTime]) are needed
  Alarm.empty(Meal meal, PillMealTime pillMealTime)
    : pair = MealPillmealtimePair.fromComponents(meal, pillMealTime),
      _isRunning = false,
      _isSnoozed = false,
      _actualReplay = 0,
      _lastShot = null,
      _stopped = null,
      _dealingWith = null;

  // prepare for future functionality, involving new fields (prescriptions)
  /// Copy Alarm values into new Alarm with key values ([meal], [pillMealTime])
  Alarm.copyFrom(Meal meal, PillMealTime pillMealTime, Alarm from)
    : pair = MealPillmealtimePair.fromComponents(meal, pillMealTime),
      _isRunning = false,
      _isSnoozed = false,
      _actualReplay = 0,
      _lastShot = from._lastShot,
      _stopped = from._stopped,
      _dealingWith = from._dealingWith;

  /// Build Alarm fromJson decoded
  Alarm.fromJson(Map<String, dynamic> json)
    : pair = MealPillmealtimePair(json[_pairKey] as int),
      _lastShot = DateTime.tryParse(json[_lastShotKey].toString()),
      _stopped = DateTime.tryParse(json[_stoppedKey].toString()),
      _dealingWith = DateTime.tryParse(json[_dealingWithKey].toString()),
      _isRunning = json[_isRunningKey] as bool,
      _isSnoozed = json[_isSnoozedKey] as bool,
      _actualReplay = json[_actualReplayKey] as int;

  //----------------------------------------------------------------------------
  //-----------------------class special members--------------------------------

  @override
  int compareTo(Alarm other) {
    if (meal < other.meal ||
        meal == other.meal && pillMealTime < other.pillMealTime) {
      return -1;
    } else if (meal == other.meal && pillMealTime == other.pillMealTime) {
      return 0;
    } else {
      return 1;
    }
  }

  /// Convert to a Json object which must be encoded to became a string
  Map<String, dynamic> toJson() {
    return {
      _pairKey: id,
      _lastShotKey: _lastShot?.toIso8601String(),
      _stoppedKey: _stopped?.toIso8601String(),
      _dealingWithKey: _dealingWith?.toIso8601String(),
      _isRunningKey: isRunning,
      _isSnoozedKey: isSnoozed,
      _actualReplayKey: _actualReplay,
    };
  }

  //----------------------------------------------------------------------------
  //-----------------------class rest of members--------------------------------

  /// Alarm binded meal
  Meal get meal => pair.meal;

  /// Alarm binded pill meal time (long before, before, at, after, long after)
  PillMealTime get pillMealTime => pair.pillMealTime;

  /// Alarm is just firing
  /// But note it also can be dealing with, which is a substate of firing
  bool get isRunning => _isRunning;

  /// User is dealing with the alarm
  bool get isDealingWith => _dealingWith != null;

  /// Alarm snoozed
  bool get isSnoozed => _isSnoozed;

  /// Firing or snoozed
  bool get isActivated => _isRunning || _isSnoozed;

  /// Replays
  int get actualReplay => _actualReplay;

  /// When has been stopped?
  DateTime? get whenWasStopped => _stopped;

  /// When were the last shot
  DateTime? get lastShot => _lastShot;

  /// Whether last time [whenWasStopped] is after [lastShot]
  bool get isStopped => _stopped != null && _stopped!.isAfter(_lastShot!);

  /// Not null when user is dealing with the alarm (taking the pills)
  /// DateTime when user began to deal with the alarm
  DateTime? get dealingWith => _dealingWith;

  /// For how long is been edited?
  Duration? get dealingWithTime => _dealingWith?.difference(_lastShot!);

  // Remember localization must be initialized:
  //    await initializeDateFormatting("ca", null)
  // You can get the current locale from widget
  // locale = WidgetsBinding.instance!.window.locale
  /// Localized name
  String name(AppLocalizations t) => pair.pillTimeName(t);

  /// mark the alarm as fired:
  /// - set the [lastShot] DateTime on first replay
  /// - increment the [replay]
  void markAlarmfired() {
    if (_actualReplay == 0) {
      _lastShot = DateTime.now().round();
    }
    _actualReplay++;
    _isRunning = true;
    _isSnoozed = false;
  }

  /// Begin to deal with the alarm (take the pills)
  void markAlarmDealingWith() {
    _dealingWith = DateTime.now().round();
    _isRunning = true;
    _isSnoozed = false;
  }

  /// mark the alarm as snoozed
  void markAlarmSnoozed() {
    _isRunning = false;
    _isSnoozed = true;
  }

  /// mark the alarm as stopped
  /// - register the [whenWasStopped] DateTime
  /// - reset the [replay] to zero
  void markAlarmStopped() {
    _isRunning = false;
    _isSnoozed = false;
    _dealingWith = null;
    _actualReplay = 0;
    _stopped = DateTime.now().round(RoundTimeTo.second);
  }

  /// Compute the TimeOfDay of the tomorrow shot using weekly meal time
  TimeOfDay tomorrowShot(WeeklyTimeTable wtt) {
    if (_lastShot == null) {
      developer.log(
        "Uninitialitzed 'lastShot'; unexpected null value",
        level: Level.SEVERE.value,
      );
      throw TypeError();
    } else {
      final DayOfWeek todayWD = DayOfWeek.fromId(_lastShot!.weekday);
      final DayOfWeek tomorrowWD = todayWD.next();
      final Meal tomorrowMeal = wtt.tomorrowEquivalentMeal(meal, todayWD);
      final tomorrowMealTime = wtt.dayMealTime(tomorrowMeal, tomorrowWD);
      if (tomorrowMealTime == null) {
        developer.log(
          "'tomorrowMeal' not found in WeeklyTimeTable",
          level: Level.SEVERE.value,
        );
        throw TypeError();
      } else {
        return tomorrowMealTime;
      }
    }
  }

  //-------- end class ---------------------------------------------------------
}
