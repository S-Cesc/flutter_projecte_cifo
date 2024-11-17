// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:async';
// Flutter
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// Project files
import '../background_entry.dart';

//=======================================================================

// DEFINITION FOR CALLBACK FUNCTIONS
// =================================
//
//    assert(callback is Function() ||
//        callback is Function(int) ||
//        callback is Function(int, Map<String, dynamic>));
//


// ONLY STATIC MEMBERS
class BackgroundAlarmHelper {
  static Future<void> fireAlarm(
    DateTime time,
    int alarmId,
    int alarmDurationMinutes,
    Future<void> Function(int) callback,
    Future<void> Function(int) snoozeCallback,
  ) async {
    await AndroidAlarmManager.oneShotAt(
      time,
      alarmId,
      callback,
      alarmClock: true,
      allowWhileIdle: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
    // Snooze the alarm after alarmDurationMinutes
    await AndroidAlarmManager.oneShot(
      Duration(minutes: alarmDurationMinutes),
      alarmId + BackgroundEntry.snoozeId,
      snoozeCallback,
      alarmClock: true,
      allowWhileIdle: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
    developer.log(
        'Alarm $alarmId progammed'
        ' with ${alarmId + BackgroundEntry.snoozeId} autosnooze programmed, ',
        level: Level.INFO.value);
  }

    static Future<void> snoozeAlarm(
    int alarmId,
    Future<void> Function(int) snoozeCallback,
  ) async {
    developer.log("Snooze alarm", level: Level.INFO.value);
    await AndroidAlarmManager.oneShot(
      const Duration(microseconds: 0),
      alarmId,
      snoozeCallback,
      alarmClock: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
      exact: true,
      wakeup: true,
    );
  }

  static Future<void> cancelAlarm(
    int alarmId,
    Future<void> Function(int) stopcallback,
  ) async {
    developer.log("Cancel alarm", level: Level.INFO.value);
    await AndroidAlarmManager.oneShot(
      const Duration(microseconds: 0),
      alarmId,
      stopcallback,
      alarmClock: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
      exact: true,
      wakeup: true,
    );
  }
}
