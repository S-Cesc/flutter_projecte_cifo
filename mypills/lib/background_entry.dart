// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:isolate';
import 'dart:ui' show IsolateNameServer;
// Flutter
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// Project files
import '../main.dart' show isolateName;

/* static */ class BackgroundEntry {
  static const id = 7;
  static SendPort? uiSendPort;

  // The callback for our alarm
  @pragma('vm:entry-point')
  static Future<void> callback(int alarmId) async {
    developer.log('Alarm $alarmId fired!', level: Level.CONFIG.value);

    FlutterRingtonePlayer.playAlarm(
      looping: true,
      asAlarm: true,
      volume: 1.0,
    );

    //showNotification();

    /*
    // Get the previous cached count and increment it.
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(countKey) ?? 0;
    await prefs.setInt(countKey, currentCount + 1);
  */

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }


  @pragma('vm:entry-point')
  static Future<void> stopcallback(int alarmId) async {
    developer.log('Alarm stoped!');
    AndroidAlarmManager.initialize();
    AndroidAlarmManager.cancel(1);
    FlutterRingtonePlayer.stop();
  }

/*
  static void showNotification() async {
    // Initialize the notification plugin
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Initialize settings for Android
    var android = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(android: android);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Define the notification details
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0,
      'Reminder',
      'It\'s time for your task!',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
  */
}
