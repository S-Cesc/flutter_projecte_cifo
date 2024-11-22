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

// DEFINITION FOR AndroidAlarmManager CALLBACK FUNCTIONS
// =====================================================
//
//    assert(callback is Function() ||
//        callback is Function(int) ||
//        callback is Function(int, Map<String, dynamic>));
//

// ONLY STATIC MEMBERS
class BackgroundAlarmHelper {
  static const _initialitzationAlarmId = 0;

//=======================================================================

  static Future<void> initialize() async {
    await AndroidAlarmManager.oneShot(
      Duration(microseconds: 0),
      _initialitzationAlarmId,
      BackgroundEntry.initialize,
      alarmClock: true,
      allowWhileIdle: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

//=======================================================================

  static Future<void> fireAlarm(
    DateTime time,
    int alarmId,
    int alarmDurationSeconds,
    Future<void> Function(int) callback,
    Future<void> Function(int) autoSnoozeCallback,
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
    // Snooze the alarm after alarmDurationSeconds
    await AndroidAlarmManager.oneShot(
      Duration(seconds: alarmDurationSeconds),
      alarmId + BackgroundEntry.snoozeId,
      autoSnoozeCallback,
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

//=======================================================================

  static Future<void> repeatAlarm(
    int alarmId,
    int alarmSnoozeSeconds,
    int alarmDurationSeconds,
    Future<void> Function(int) callback,
    Future<void> Function(int) autoSnoozeCallback,
  ) async {
    await AndroidAlarmManager.oneShot(
      Duration(seconds: alarmSnoozeSeconds),
      alarmId,
      callback,
      alarmClock: true,
      allowWhileIdle: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
    // Snooze the alarm after alarmDurationSeconds
    await AndroidAlarmManager.oneShot(
      Duration(seconds: alarmSnoozeSeconds + alarmDurationSeconds + 30),
      alarmId + BackgroundEntry.snoozeId,
      autoSnoozeCallback,
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

//=======================================================================

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

//=======================================================================

  // StopAlarm is espected to be called always from UI
  // It must be the only place to call BackgroundEntry.stopCallback
  static Future<void> stopAlarm(int alarmId) async {
    developer.log("Stop alarm", level: Level.INFO.value);
    await AndroidAlarmManager.oneShot(
      const Duration(microseconds: 0),
      alarmId,
      BackgroundEntry.stopCallback,
      alarmClock: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
      exact: true,
      wakeup: true,
    );
  }

//=======================================================================

  // Always from UI, usually reprogramming the alarm
  static Future<void> cancelAlarm(int alarmId) async {
    developer.log("Cancel alarm", level: Level.INFO.value);
    await AndroidAlarmManager.oneShot(
      const Duration(microseconds: 0),
      alarmId,
      BackgroundEntry.cancelCallback,
      alarmClock: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
      exact: true,
      wakeup: true,
    );
  }
}
