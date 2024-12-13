// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// Localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import 'meal.dart';
import 'day_of_week.dart';
import 'pill_meal_time.dart';
import 'weekly_time_table.dart';
//import '../background_entry.dart' show BackgroundEntry;

//==============================================================================

/// Objects representing an alarm
class Alarm implements Comparable<Alarm> {
  //-------------------------static/constant------------------------------------

  static const _midnightId = 75;
  static const _mealKey = 'meal';
  static const _pillMealTimeKey = 'pillMealTime';
  static const _lastShotKey = 'lastShot';
  static const _stoppedKey = 'stopped';
  static const _isRunningKey = 'isRunning';
  static const _isSnoozedKey = 'isSnoozed';
  static const _actualReplayKey = 'nReplay';

  /// Get the id from the key pair ([meal], [pillMealTime])
  static int getAlarmId(Meal meal, PillMealTime pillMealTime) {
    return meal.id + pillMealTime.id;
  }

  /// Get the string key used to store the alarm
  /// from its key pair ([meal], [pillMealTime])
  static String alarmKey(String key, Meal meal, PillMealTime pillMealTime) {
    return "$key${getAlarmId(meal, pillMealTime)}";
  }

  /// Get the key pair ([meal], [pillMealTime]) from the id
  static (Meal, PillMealTime) getAlarmKeys(int id) {
    if (id == Alarm._midnightId) {
      return (Meal.supper, PillMealTime.longAfter);
    } else {
      int pmt = (id % 2) == 0
          ? ((id % 10) == 0 ? 0 : (((id - 2) % 10) == 0 ? 2 : -2))
          : -5;
      return (Meal.fromId(id - pmt), PillMealTime.fromId(pmt));
    }
  }

  // Remember localization must be initialized:
  //    await initializeDateFormatting("ca", null)
  // You can get the current locale from widget
  // locale = WidgetsBinding.instance!.window.locale
  /// Localized Alarm name from [id]
  static String getAlarmNameFromId(int id, AppLocalizations t) {
    // idAlarmText not imported from BackgroundEntry to avoid circular reference
    if (kDebugMode) {
      final idAlarmText = 3;
      if (id == idAlarmText) {
        return "Alarma de prova";
      }
    }
    Meal meal;
    PillMealTime pillMealTime;
    (meal, pillMealTime) = getAlarmKeys(id);
    return PillMealTime.getPillTimeName(meal, pillMealTime, t);
  }

  /// Localized Alarm name from its key pair ([meal], [pillMealTime])
  static String getAlarmName(
      Meal meal, PillMealTime pillMealTime, AppLocalizations t) {
    return PillMealTime.getPillTimeName(meal, pillMealTime, t);
  }

  //-----------------class state members and constructors ----------------------

  /// Alarm binded meal
  final Meal meal;

  /// Alarm binded pill meal time (long before, before, at, after, long after)
  final PillMealTime pillMealTime;

  DateTime? _lastShot;
  DateTime? _stopped;
  DateTime? _dealingWith;
  bool _isRunning;
  bool _isSnoozed;
  int _actualReplay;

  /// Alarm with empty (default) values.
  /// The key inmutable values ([meal], [pillMealTime]) are needed
  Alarm.empty(this.meal, this.pillMealTime)
      : _isRunning = false,
        _isSnoozed = false,
        _actualReplay = 0;

  // prepare for future functionality, involving new fields (prescriptions)
  /// Copy Alarm values into new Alarm with key values ([meal], [pillMealTime])
  Alarm.copyFrom(this.meal, this.pillMealTime, Alarm from)
      : _isRunning = false,
        _isSnoozed = false,
        _actualReplay = 0,
        _lastShot = from._lastShot,
        _stopped = from._stopped;

  /// Build Alarm fromJson decoded
  Alarm.fromJson(Map<String, dynamic> json)
      : meal = Meal.fromId(json[_mealKey] as int),
        pillMealTime = PillMealTime.fromId(json[_pillMealTimeKey] as int),
        _lastShot = DateTime.tryParse(json[_lastShotKey].toString()),
        _stopped = DateTime.tryParse(json[_stoppedKey].toString()),
        _isRunning = json[_isRunningKey] as bool,
        _isSnoozed = json[_isSnoozedKey] as bool,
        _actualReplay = json[_actualReplayKey] as int;

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
      _mealKey: meal.id,
      _pillMealTimeKey: pillMealTime.id,
      _lastShotKey: _lastShot?.toIso8601String(),
      _stoppedKey: _stopped?.toIso8601String(),
      _isRunningKey: isRunning,
      _isSnoozedKey: isSnoozed,
      _actualReplayKey: _actualReplay
    };
  }

  //-----------------------class rest of members--------------------------------

  /// Compute the alarm unique id
  int get id => getAlarmId(meal, pillMealTime);

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
  DateTime? get stopped => _stopped;

  /// When were the last shot
  DateTime? get lastShot => _lastShot;

  /// Whether [stopped] is after [lastShot]
  bool get isStopped => _stopped != null && _stopped!.isAfter(_lastShot!);

  DateTime? get DealingWith => _dealingWith;

  /// For how long is been edited?
  Duration? get dealingWithTime => _dealingWith?.difference(_lastShot!);

  // Remember localization must be initialized:
  //    await initializeDateFormatting("ca", null)
  // You can get the current locale from widget
  // locale = WidgetsBinding.instance!.window.locale
  /// Localized name
  String name(AppLocalizations t) => pillMealTime.pillTimeName(meal, t);

  /// mark the alarm as fired:
  /// - set the [lastShot] DateTime on first replay
  /// - increment the [replay]
  void markAlarmfired() {
    if (_actualReplay == 0) {
      final DateTime now = DateTime.now();
      _lastShot = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    }
    _actualReplay++;
    _isRunning = true;
    _isSnoozed = false;
  }

  void markAlarmDealingWith() {
    final DateTime now = DateTime.now();
    _dealingWith = DateTime(now.year, now.month, now.day, now.hour, now.minute);
  }

  /// mark the alarm as snoozed
  void markAlarmSnoozed() {
    _isRunning = false;
    _isSnoozed = true;
  }

  /// mark the alarm as stopped
  /// - register the [stopped] DateTime
  /// - reset the [replay] to zero
  void markAlarmStopped() {
    _isRunning = false;
    _isSnoozed = false;
    _dealingWith = null;
    _actualReplay = 0;
    final DateTime now = DateTime.now();
    _stopped = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
  }

  /// Compute the TimeOfDay of the tomorrow shot using weekly meal time
  TimeOfDay tomorrowShot(WeeklyTimeTable wtt) {
    if (_lastShot == null) {
      developer.log("Uninitialitzed 'lastShot'; unexpected null value",
          level: Level.SEVERE.value);
      throw TypeError();
    } else {
      final DayOfWeek todayWD = DayOfWeek.fromId(_lastShot!.weekday);
      final DayOfWeek tomorrowWD = todayWD.next();
      final Meal tomorrowMeal = wtt.tomorrowEquivalentMeal(meal, todayWD);
      final tomorrowMealTime = wtt.dayMealTime(tomorrowMeal, tomorrowWD);
      if (tomorrowMealTime == null) {
        developer.log("'tomorrowMeal' not found in WeeklyTimeTable",
            level: Level.SEVERE.value);
        throw TypeError();
      } else {
        return tomorrowMealTime;
      }
    }
  }
}
