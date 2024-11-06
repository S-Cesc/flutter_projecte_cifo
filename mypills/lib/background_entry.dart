// logging and debugging
import 'dart:developer' as developer;
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui' show IsolateNameServer;
// Flutter
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// Project files
import '../main.dart' show mainIsolateName;
import 'services/foreground_entry_helper.dart';

/* ONLY static MEMBERS */
class BackgroundEntry {
  static const String backgroundIsolateName = 'myPillsAlarm';
  static final int isolateId = Isolate.current.hashCode;
  static const id = 7;
  static SendPort? uiSendPort;
  static SendPort? foregroundSendPort;

  // The callback for our alarm
  @pragma('vm:entry-point')
  static Future<void> callback(int alarmId) async {
    developer.log('Alarm $alarmId fired!', level: Level.CONFIG.value);
    developer.log('ISOLATE: $backgroundIsolateName, $isolateId',
        level: Level.INFO.value);

    ForegroundEntryHelper.initService();
    await ForegroundEntryHelper.startService();

    FlutterRingtonePlayer.playAlarm(
      looping: true,
      asAlarm: true,
      volume: 1.0,
    );

    // TODO Establir ForegroundEntryHelper callback per rebre dades
    // des de sendDataToMain
    FlutterForegroundTask.addTaskDataCallback((Object obj) {
      //aquesta funció per retardar l'alarma
    });

    /*
    // Get the previous cached count and increment it.
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(countKey) ?? 0;
    await prefs.setInt(countKey, currentCount + 1);
  */

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(mainIsolateName);
    uiSendPort?.send(null);
  }

  static void _handleCommandsToIsolate(
    ReceivePort receivePort,
    SendPort sendPort,
  ) {
    receivePort.listen((message) {
      if (message is String) {
        if (message == 'shutdown') {
          receivePort.close();
          return;
        } else {
          try {
            final jsonMessage = jsonDecode(message);
            developer.log('Message to background: $jsonMessage',
                level: Level.INFO.value);
          } catch (e) {
            // TODO
          }
        }
      }
      /*
      final (int id, String jsonText) = message as (int, String);
      try {
        final jsonData = jsonDecode(jsonText);
        sendPort.send((id, jsonData));
      } catch (e) {
        sendPort.send((id, RemoteError(e.toString(), '')));
      }
      */
    });
  }

  @pragma('vm:entry-point')
  static Future<void> stopcallback(int alarmId) async {
    final cancelResult = await AndroidAlarmManager.cancel(alarmId);
    developer.log('Alarm $alarmId stoped! ($cancelResult)',
        level: Level.CONFIG.value);
    FlutterRingtonePlayer.stop();
    await ForegroundEntryHelper.stopService();
  }
}
