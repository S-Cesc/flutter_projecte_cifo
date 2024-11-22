// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:convert';
// Flutter
import 'package:shared_preferences/shared_preferences.dart';
// Project files
import '../model/alarm.dart';
import '../model/alarm_key_iterator.dart';
import '../model/meal.dart';
import '../model/pill_meal_time.dart';
import 'alarm_settings.dart';

//==============================================================================

final class AlarmCollection {
  //-----------------class state members and constructors ----------------------

  final SharedPreferencesAsync _shPrefs;
  final void Function() callbackOnUpdate;
  final Map<int, Alarm> _alarms = <int, Alarm>{};

  AlarmCollection(this._shPrefs, this.callbackOnUpdate);

  //-----------------------class special members--------------------------------

  Future<void> init() async {
    developer.log("LOAD ALARMS for editing pourposes");
    var it = AlarmKeyIterator();
    while (it.moveNext()) {
      final String key = Alarm.alarmKey("a", it.current.$1, it.current.$2);
      //  'a${it.current}';
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
          developer.log("EXCEPTION (decode JSON alarm) ${e.toString()}",
              level: Level.SHOUT.value);
        }
      }
    }
    developer.log("LOADED ALARMS: $_alarms", level: Level.FINE.value);
  }

  //-----------------------class rest of members--------------------------------

  Iterable<Alarm> get currentAlarms {
    return _alarms.values;
  }

  (List<int> insertedIds, List<int> removedIds) setCurrentAlarms(
    List<Alarm> value, {
    required Future<void> Function(int) insertCallback,
    required Future<void> Function(int) removeCallback,
  }) {
    final inserted = <int>[], removed = <int>[];
    // remove alarms not present in parameter
    for (final id in _alarms.keys) {
      if (!value.any((x) => x.id == id)) {
        removeAlarm(id);
        removed.add(id);
        removeCallback.call(id);
      }
    }
    // insert absent alarms present in the parameter
    for (final a in value) {
      _alarms.putIfAbsent(a.id, () {
        _setAlarm(a);
        inserted.add(a.id);
        insertCallback(a.id);
        return a;
      });
    }
    return (inserted, removed);
  }

  Alarm? getAlarm(int alarmId) => _alarms[alarmId];

  Future<void> setAlarm(Alarm a) async {
    final int alarmId = a.id;
    _alarms[alarmId] = a;
    await _setAlarm(a);
  }

  Future<void> _setAlarm(Alarm a) async {
    final Map<String, dynamic> jsonStructured = a.toJson();
    await _shPrefs.setString(
        AlarmSettings.alarmJsonKey(a.id), jsonEncode(jsonStructured));
    callbackOnUpdate();
  }
  Future<bool> removeAlarm(int alarmId, {bool force = false}) async {
    if (_alarms.containsKey(alarmId)) {
      final Alarm tmpAlarm = _alarms[alarmId]!;
      if (tmpAlarm.activated && !force) {
        developer.log(
            "The alarm is now active; "
            "it needs to be attended before to be removed",
            level: Level.WARNING.value);
        return false;
      } else {
        _alarms.remove(alarmId);
        await _shPrefs.remove(AlarmSettings.alarmJsonKey(alarmId));
        callbackOnUpdate();
        return true;
      }
    } else {
      return true;
    }
  }

  Future<void> changeAlarmKey(
      Alarm a, Meal newMeal, PillMealTime newPillMealTime) async {
    if (await removeAlarm(a.id)) {
      final Alarm newAlarm = Alarm.copyFrom(newMeal, newPillMealTime, a);
      await setAlarm(newAlarm);
      callbackOnUpdate();
    }
  }

}
