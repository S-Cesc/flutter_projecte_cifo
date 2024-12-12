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
/// Class helper static facilities to use [BackgroundEntry] entry points
class BackgroundAlarmHelper {
  static const _initialitzationAlarmId = 0;

//=======================================================================

  /// Initialize the [BackgroundEntry] isolate data
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

  /// program alarm [alarmId] to fire at [time]
  static Future<void> fireAlarm(
    DateTime time,
    int alarmId,
    int alarmDurationSeconds,
  ) async {
    developer.log(
        "Helper: Fire alarm: $time"
        " until ${time.add(Duration(seconds: alarmDurationSeconds))}",
        level: Level.INFO.value);
    await AndroidAlarmManager.oneShotAt(
      time,
      alarmId,
      BackgroundEntry.callback,
      alarmClock: true,
      allowWhileIdle: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
    // Snooze the alarm after alarmDurationSeconds
    await AndroidAlarmManager.oneShotAt(
      time.add(Duration(seconds: alarmDurationSeconds)),
      alarmId + BackgroundEntry.snoozeId,
      BackgroundEntry.autoSnoozeCallback,
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

  /// sooze the alarm [alarmId] while it's firing
  static Future<void> snoozeAlarm(int alarmId) async {
    developer.log("Helper: Snooze alarm", level: Level.INFO.value);
    await AndroidAlarmManager.oneShot(
      const Duration(microseconds: 0),
      alarmId,
      BackgroundEntry.snoozeCallback,
      alarmClock: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
      exact: true,
      wakeup: true,
    );
  }

//=======================================================================

  /// User stops the alarm
  /// StopAlarm is espected to be called always from UI
  /// It must be the only place to call [BackgroundEntry.stopCallback]
  static Future<void> stopAlarm(int alarmId) async {
    developer.log("Helper: Stop alarm", level: Level.INFO.value);
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

  /// Cancel an alarm [alarmId], usually to reprogram it
  static Future<void> cancelAlarm(int alarmId) async {
    developer.log("Helper: Cancel alarm", level: Level.INFO.value);
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
