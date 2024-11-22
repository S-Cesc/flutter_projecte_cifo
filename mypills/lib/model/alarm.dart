// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_projecte_cifo/model/enums.dart';
// Localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import 'meal.dart';
import 'pill_meal_time.dart';
import 'weekly_time_table.dart';

//==============================================================================

class Alarm implements Comparable<Alarm> {
  //-------------------------static/constant------------------------------------

  static const _midnightId = 75;
  static const _mealKey = 'meal';
  static const _pillMealTimeKey = 'pillMealTime';
  static const _lastShootKey = 'lastShoot';
  static const _isRunningKey = 'isRunning';
  static const _isSnoozedKey = 'isSnoozed';
  static const _actualReplayKey = 'nReplay';

  static int getAlarmId(Meal meal, PillMealTime pillMealTime) {
    return meal.id + pillMealTime.id;
  }

  static String alarmKey(String key, Meal meal, PillMealTime pillMealTime) {
    return "$key${getAlarmId(meal, pillMealTime)}";
  }

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

  //-----------------class state members and constructors ----------------------

  final Meal meal;
  final PillMealTime pillMealTime;

  DateTime? _lastShoot;
  bool _isRunning;
  bool _isSnoozed;
  int _actualReplay;

  Alarm.empty(this.meal, this.pillMealTime)
      : _isRunning = false,
        _isSnoozed = false,
        _actualReplay = 0;

  // prepare for future functionality, involving new fields (prescriptions)
  Alarm.copyFrom(this.meal, this.pillMealTime, Alarm from)
      : _isRunning = false,
        _isSnoozed = false,
        _actualReplay = 0,
        _lastShoot = from._lastShoot;

  Alarm.fromJson(Map<String, dynamic> json)
      : meal = Meal.fromId(json[_mealKey] as int),
        pillMealTime = PillMealTime.fromId(json[_pillMealTimeKey] as int),
        _lastShoot = DateTime.tryParse(json[_lastShootKey].toString()),
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

  Map<String, dynamic> toJson() {
    return {
      _mealKey: meal.id,
      _pillMealTimeKey: pillMealTime.id,
      _lastShootKey: _lastShoot?.toIso8601String(),
      _isRunningKey: isRunning,
      _isSnoozedKey: isSnoozed,
      _actualReplayKey: _actualReplay
    };
  }

  //-----------------------class rest of members--------------------------------

  int get id => getAlarmId(meal, pillMealTime);
  bool get isRunning => _isRunning;
  bool get isSnoozed => _isSnoozed;
  bool get activated => _isRunning || _isSnoozed;
  int get actualReplay => _actualReplay;

  // Remember localization must be initialized:
  //    await initializeDateFormatting("ca", null)
  // You can get the current locale from widget
  // locale = WidgetsBinding.instance!.window.locale
  String name(AppLocalizations t) => pillMealTime.pillTimeName(meal, t);

  void fireAlarm() {
    if (_actualReplay == 0) {
      final DateTime now = DateTime.now();
      _lastShoot = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    }
    _actualReplay++;
    _isRunning = true;
    _isSnoozed = false;
  }

  void snoozeAlarm() {
    _isRunning = false;
    _isSnoozed = true;
  }

  void stopAlarm() {
    _isRunning = false;
    _isSnoozed = false;
    _actualReplay = 0;
  }

  TimeOfDay nextShoot(WeeklyTimeTable wtt) {
    if (_lastShoot == null) {
      developer.log("Uninitialitzed 'lastShoot'; unexpected null value",
          level: Level.SEVERE.value);
      throw TypeError();
    } else {
      final DayOfWeek todayWD = DayOfWeek.fromId(_lastShoot!.weekday);
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
