// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:async';
import 'dart:convert';
// Flutter
import 'package:flutter/material.dart';
import 'package:mypills/model/global_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Project files
import '../extensions/date_time_extensions.dart';
import '../model/alarm.dart';
import '../model/alarm_key_iterator.dart';
import '../model/enum/day_of_week.dart';
import '../model/json_keys.dart';
import '../providers/config_preferences.dart';
import '../services/background_alarm_helper.dart';

//==============================================================================

/// Collection of existing defined alarms stored directly in SharedPreferences
final class AlarmCollection {
  //
  //----------------------------------------------------------------------------
  //-----------------class state members and constructors ----------------------

  final SharedPreferencesAsync _shPrefs;
  final ConfigPreferences _owner;
  final void Function() _callbackOnUpdate;
  final Map<int, Alarm> _alarms = <int, Alarm>{};

  /// Ctor
  /// [_owner] allows access to other settings (alarmSettings)
  /// [_callbackOnUpdate] allows to [notifyListeners]
  AlarmCollection(this._shPrefs, this._owner, this._callbackOnUpdate);

  //-----------------------class special members--------------------------------

  /// Initialize the alarm collection: read it from [SharedPreferencesAsync]
  /// Each element is directly stored using its numeric key and a key prefix
  /// It allows rapid retrieval of an alarm,
  /// but requieres a key full iteration to retrieve all of them
  Future<void> init() async {
    developer.log("LOAD ALARMS for editing pourposes");
    const keyPrefix = JsonKeys.alarmJsonKeyPrefix;
    var it = AlarmKeyIterator();
    while (it.moveNext()) {
      final String key = Alarm.alarmKey(
        keyPrefix,
        it.current.$1,
        it.current.$2,
      );
      final json = await _shPrefs.getString(key);
      developer.log("...prova clau: $key", level: Level.FINEST.value);
      if (json != null) {
        developer.log(":-> Trobada clau: $key", level: Level.FINE.value);
        try {
          final Map<String, dynamic> decodedJson =
              jsonDecode(json) as Map<String, dynamic>;
          final tmpAlarm = Alarm.fromJson(decodedJson);
          _alarms.putIfAbsent(tmpAlarm.id, () => tmpAlarm);
        } catch (e) {
          developer.log(
            "EXCEPTION (decode JSON alarm) ${e.toString()}",
            level: Level.SHOUT.value,
          );
        }
      }
    }
    developer.log("LOADED ALARMS: $_alarms", level: Level.FINE.value);
  }

  //-----------------------class rest of members--------------------------------

  /// In memory Alarm collection
  Iterable<Alarm> get currentAlarms {
    return _alarms.values;
  }

  /// Persist [value] the list of Alarms
  /// - Existing alarms present also in [value] are not affected
  /// - Add new alarms from [value]
  /// - Remove non existing alarms in [value]
  Future<void> setCurrentAlarms(List<Alarm> value) async {
    final inserted = <int>[], removed = <int>[];
    // remove alarms not present in parameter
    developer.log("Existing alarms: ${_alarms.length}");
    developer.log("Result edited alarms: ${value.length}");
    for (final id in _alarms.keys) {
      if (!value.any((x) => x.id == id)) {
        developer.log("Alarm to remove: $id");
        removed.add(id);
      }
    }
    for (final id in removed) {
      bool done = false;
      int count = 0;
      while (!done && count++ < GlobalConstants.maxRetries) {
        done = await _removeAlarm(id);
        if (!done) {
          await Future.delayed(GlobalConstants.delayToRetry, () => null);
          done = await _removeAlarm(id, force: true);
        }
      }
    }
    // insert absent alarms present in the parameter
    for (final a in value) {
      _alarms.putIfAbsent(a.id, () {
        unawaited(_setAlarm(a));
        inserted.add(a.id);
        developer.log("Alarm added: ${a.id}");
        return a;
      });
    }
  }

  /// Get a defined Alarm
  Alarm? getAlarm(int alarmId) => _alarms[alarmId];

  /// Persist & program an alarm
  Future<void> setAlarm(Alarm a) async {
    final int alarmId = a.id;
    _alarms[alarmId] = a;
    await _setAlarm(a);
  }

  Future<void> _setAlarm(Alarm a) async {
    final Map<String, dynamic> jsonStructured = a.toJson();

    Future<void> addFireAlarmProgramming(int alarmId) async {
      developer.log("User requires programming alarm $alarmId");
      Alarm? alarm = _alarms[alarmId];
      if (alarm != null) {
        // alarm.meal alarm.pillMealTime
        final today = DateTimeExtensions.today();
        DateTime? dateTimeToFire;
        // TODO: Alarm dayMealTime: requires all alarms to fire today or tomorrow
        // - Alarms do not fire everyday (use the list of prescriptions)
        // - The 'meal' from the Alarm only references 'usual' timetable routine
        // TODO: Alarm time to fire (pillMealTime; now depends only from meal)
        TimeOfDay? mealTime = _owner.generalSettings.wtt.dayMealTime(
          alarm.meal,
          DayOfWeek.fromDate(today),
        );
        if (mealTime != null && DateTimeExtensions.isToday(mealTime)) {
          dateTimeToFire = DateTimeExtensions.todayAt(mealTime);
        } else {
          // Hoy no... mañana
          developer.log("L'alarma hoy no, ...mañana");
          final tomorrow = DateTimeExtensions.tomorrow();
          mealTime = _owner.generalSettings.wtt.dayMealTime(
            alarm.meal,
            DayOfWeek.fromDate(tomorrow),
          );
          if (mealTime != null) {
            dateTimeToFire = DateTimeExtensions.tomorrowAt(mealTime);
          }
        }
        if (dateTimeToFire != null) {
          developer.log("Fire of alarm $alarmId programmed at $dateTimeToFire");
          await BackgroundAlarmHelper.fireAlarm(
            dateTimeToFire,
            alarmId,
            _owner.generalSettings.data.alarmDurationSeconds,
          );
        }
        developer.log(
          mealTime == null ? "No meal time" : "meal time: $mealTime",
          level: Level.INFO.value,
        );
      } else {
        developer.log("Alarm not found", level: Level.WARNING.value);
      }
    }

    await _shPrefs.setString(
      JsonKeys.alarmJsonKey(a.id),
      jsonEncode(jsonStructured),
    );
    await addFireAlarmProgramming(a.id);
    _callbackOnUpdate();
  }

  Future<bool> _removeAlarm(int alarmId, {bool force = false}) async {
    Future<void> removeFireAlarmProgramming(int alarmId) async {
      developer.log("User requires cancel the alarm $alarmId (reprogramming)");
      await BackgroundAlarmHelper.cancelAlarm(alarmId);
    }

    if (_alarms.containsKey(alarmId)) {
      final Alarm tmpAlarm = _alarms[alarmId]!;
      if (tmpAlarm.isActivated && !force) {
        developer.log(
          "The alarm is now active; "
          "it needs to be attended before to be removed",
          level: Level.WARNING.value,
        );
        return false;
      } else {
        await _shPrefs.remove(JsonKeys.alarmJsonKey(alarmId));
        await removeFireAlarmProgramming(alarmId);
        _alarms.remove(alarmId);
        _callbackOnUpdate();
        developer.log("Remove: $alarmId");
        return true;
      }
    } else {
      return true;
    }
  }

  /*
  Future<void> changeAlarmKey(
      Alarm a, Meal newMeal, PillMealTime newPillMealTime) async {
    if (await removeAlarm(a.id)) {
      final Alarm newAlarm = Alarm.copyFrom(newMeal, newPillMealTime, a);
      await setAlarm(newAlarm);
      callbackOnUpdate();
    }
  }
*/
}
