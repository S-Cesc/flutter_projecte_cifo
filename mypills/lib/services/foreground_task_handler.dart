// logging and debugging
import 'dart:async';
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:isolate';
// Flutter
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// Project files

//=======================================================================

class ForegroundTaskHandler extends TaskHandler {
  static const String foregroundIsolateName = 'myPillsService';
  static final int isolateId = Isolate.current.hashCode;

  // TODO FlutterForegroundTask.updateService(notificationText: message);

  // Launch d'App at '/alarm' point
  Future<void> _launchApp() async {
    developer.log('LAUNCH APP', level: Level.FINE.value);
    FlutterForegroundTask.launchApp('/alarm');
    bool isAppOnForeground = await FlutterForegroundTask.isAppOnForeground;
    developer.log(
        'APP launched is ${isAppOnForeground ? "" : "not "}on foreground',
        level: Level.FINE.value);
    if (isAppOnForeground) {
      developer.log('Foreground APP', level: Level.FINE.value);
      FlutterForegroundTask.sendDataToMain("wakeup");
      developer.log('"wakeup" command sent', level: Level.FINE.value);
    }
  }

  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    developer.log('onStart(starter: ${starter.name})',
        level: Level.CONFIG.value);
    developer.log(
        'ISOLATE: $foregroundIsolateName, $isolateId, '
        '${Isolate.current.debugName}',
        level: Level.INFO.value);
    FlutterForegroundTask.wakeUpScreen();
    // TODO setOnLockScreenVisibility
    // setOnLockScreenVisibility gives "ActivityNotAttachedException"
    // Activity is not attached to FlutterEngine
    //FlutterForegroundTask.setOnLockScreenVisibility(true);
    await _launchApp();
  }

  // Called by eventAction in [ForegroundTaskOptions].
  // - nothing() : Not use onRepeatEvent callback.
  // - once() : Call onRepeatEvent only once.
  // - repeat(interval) : Call onRepeatEvent at milliseconds interval.
  @override
  void onRepeatEvent(DateTime timestamp) {}

  // Called when the task is destroyed.
  @override
  Future<void> onDestroy(DateTime timestamp) async {
    developer.log('onDestroy', level: Level.CONFIG.value);
  }

  // Called when data is sent using [FlutterForegroundTask.sendDataToTask].
  // @override
  // void onReceiveData(Object data) {
  //   developer.log('onReceiveData: $data', level: Level.FINE.value);
  // }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    developer.log('onNotificationButtonPressed: $id', level: Level.FINE.value);
    // Aquí només admet comunicar-se amb alarmManager i retrassar
    // FlutterForegroundTask.sendDataToMain(obj);
  }

  // Called when the notification itself is pressed.
  //
  // AOS: "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted
  // for this function to be called.
  @override
  void onNotificationPressed() {
    developer.log('onNotificationPressed', level: Level.FINE.value);
    unawaited(_launchApp());
  }

  // Called when the notification itself is dismissed.
  //
  // AOS: only work Android 14+
  // iOS: only work iOS 10+
  @override
  void onNotificationDismissed() {
    developer.log('onNotificationDismissed', level: Level.FINE.value);
  }
}
