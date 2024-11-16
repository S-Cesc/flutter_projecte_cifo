import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

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
    Future<void> Function(int) callback,
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
  }

  static Future<void> cancelAlarm(
    int alarmId,
    Future<void> Function(int) stopcallback,
  ) async {
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
