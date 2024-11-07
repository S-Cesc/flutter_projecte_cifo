// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// Project files
import '../foreground_entry.dart';
import './foreground_task_handler.dart';

/* ONLY static MEMBERS */
class ForegroundEntryHelper {
  // Constants from ForegroundService
  static const String kPortName = 'flutter_foreground_task/isolateComPort';
  static const String _kNamePrefix = 'com.pravera.flutter_foreground_task';

  static void initService() {
    FlutterForegroundTask.initCommunicationPort();
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: ForegroundTaskHandler.foregroundIsolateName, // 'foreground_service',
        channelName: 'MyPills foreground service notification', // 'Foreground Service Notification',
        channelDescription: 'MyPills service foreground alarm',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.MAX,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  static Future<ServiceRequestResult> startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      developer.log('restart foreground service!', level: Level.FINE.value);
      return FlutterForegroundTask.restartService();
    } else {
      developer.log('Start foreground service!', level: Level.FINE.value);
      return FlutterForegroundTask.startService(
        serviceId: 257,
        notificationTitle: 'Take the pills!',
        notificationText:
            'You have to take the pills./nPlease, tap to open the app',
        // notificationIcon: NotificationIconData(
        //     resType: ResourceType.drawable,
        //     resPrefix: ResourcePrefix.ic,
        //     name: "launcher", backgroundColor: Colors.green),
        // notificationButtons: [
        //   const NotificationButton(id: 'btn_hello', text: 'hello'),
        // ],
        callback: startCallback,
      );
    }
  }

  static Future<ServiceRequestResult> stopService() async {
    return FlutterForegroundTask.stopService();
  }
}
