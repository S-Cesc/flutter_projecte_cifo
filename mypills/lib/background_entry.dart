// logging and debugging
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:logging/logging.dart' show Level;
import 'package:flutter/foundation.dart' show kReleaseMode;
// Dart base
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui' show IsolateNameServer;
// Flutter
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// Project files
import '../main.dart' show uiWakeupPortName, uiAlarmPortName;
import '../model/alarm.dart';
import 'providers/background_preferences.dart';
import 'services/foreground_entry_helper.dart';

/* ONLY static MEMBERS */
class BackgroundEntry {
  static const String backgroundIsolateName = 'myPillsAlarm';
  static final int isolateId = Isolate.current.hashCode;
  static const int snoozeId = 128; // Greatest alarmId to sum is 75
  static const alarmIdMessageKey = "alarmId";

  static const idTstAlarm = 7; // AlarmId per proves inicials
  static const bool _soundAlarm =
      kReleaseMode || true; // lets avoid sound on debug

  static BackgroundPreferences preferences = BackgroundPreferences();

//=======================================================================

  // TODO snooze param is from frontend. Use Json instead of alarmId
  // Json param: id
  // Json param: snooze -> similar to stop, but with reprogram

  // pref.alarmSettings.alarmDurationSeconds;
  //  pref.alarmSettings.alarmRepeatTimes;
  //  pref.alarmSettings.alarmSnoozeSeconds;

  // The callback for our alarm
  @pragma('vm:entry-point')
  static Future<void> callback(int alarmId) async {
    developer.log('Alarm $alarmId fired!', level: Level.CONFIG.value);
    developer.log('ISOLATE: $backgroundIsolateName, $isolateId',
        level: Level.INFO.value);
    await preferences.requery();
    Alarm? alarm = await preferences.currentAlarm(alarmId);
    if (alarm != null) {
      final TimeOfDay nextShoot = alarm.nextShoot(preferences.weeklyTimeTable);
      developer.log("Next shoot at $nextShoot", level: Level.INFO.value);
      alarm.fireAlarm();
      {
        // init the port and send "wakeup" message
        // early message to arrive foreground config screen
        final SendPort? uiSendPort =
            IsolateNameServer.lookupPortByName(uiWakeupPortName);
        if (uiSendPort != null) {
          uiSendPort.send("wakeup");
          developer.log('Sent "wakeup" to App by uiSendPort',
              level: Level.FINE.value);
        } else {
          developer.log('Alarm fired, but uiSendPort IS null',
              level: Level.FINE.value);
        }
      }
      //
      // the rest of the code
      //
    } else {
      developer.log("Alarm $alarmId NOT FOUND", level: Level.SEVERE.value);
    }
    // init Foreground service
    ForegroundEntryHelper.initService();
    await ForegroundEntryHelper.startService();
    // Add callback from foreground service
    // Could be useful to snooze directly from notification
    // Recive Foreground service data
    FlutterForegroundTask.addTaskDataCallback((Object obj) {
      developer.log('ISOLATE: $backgroundIsolateName, $isolateId',
          level: Level.INFO.value);
      if (obj is String) {
        try {
          final SendPort? uiSendPort =
              IsolateNameServer.lookupPortByName(uiWakeupPortName);
          if (obj == "wakeup") {
            developer.log('Background callback received "wakeup" message',
                level: Level.INFO.value);
            if (uiSendPort != null) {
              uiSendPort.send("wakeup");
              developer.log('Sent "wakeup" to App by uiSendPort',
                  level: Level.FINE.value);
            } else {
              developer.log('"wakeup" message lost;' ' uiSendPort is null',
                  level: Level.FINE.value);
            }
          } else if (obj == "snooze") {
            // unawaited(snooze());
          } else {
            developer.log('Received background callback unknown message: $obj',
                level: Level.WARNING.value);
            /*
            final jsonMessage = jsonDecode(obj);
            developer.log('Background callback received message: $jsonMessage',
                level: Level.INFO.value);
            */
          }
        } catch (e) {
          developer.log(
              'Background callback received message throwed error: ${e.toString()}',
              level: Level.SEVERE.value);
        }
      } else {
        developer.log('Received background callback unknown message: $obj',
            level: Level.WARNING.value);
      }
    }
        // TODO ForegroundEntryHelper callback per rebre dades
        // En concret: quina alarma està sonant ????
        );
    // RING -- avoid night debugging sound
    if (_soundAlarm) {
      await FlutterRingtonePlayer.playAlarm(
        looping: true,
        asAlarm: true,
        volume: 1.0,
      );
    }
    // init the port and send alarmId message
    // use async as application needs time to start
    await Future.delayed(const Duration(milliseconds: 1500), () async {
      final SendPort? uiSendInfoPort =
          IsolateNameServer.lookupPortByName(uiAlarmPortName);
      if (uiSendInfoPort != null) {
        uiSendInfoPort.send(json.encode('{"$alarmIdMessageKey": $alarmId}'));
        developer.log('Sent "alarmId" to App by uiSendInfoPort',
            level: Level.FINE.value);
      } else {
        developer.log('Alarm fired, but uiSendInfoPort IS null',
            level: Level.FINE.value);
      }
    });
    /*
    // Get the previous cached count and increment it.
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(countKey) ?? 0;
    await prefs.setInt(countKey, currentCount + 1);
  */

    /*
      // This will be null if we're running in the background.
      uiSendPort ??= IsolateNameServer.lookupPortByName(mainIsolateName);
      uiSendPort?.send("wakeup");
    */
  } // end callback

  //TODO delay
  static Future<void> snoozecallback(int alarmId) async {
    developer.log('ISOLATE: $backgroundIsolateName, $isolateId',
        level: Level.INFO.value);
    developer.log("Alarm $alarmId snoozed", level: Level.INFO.value);
    await FlutterRingtonePlayer.stop();
  }

  @pragma('vm:entry-point')
  static Future<void> stopcallback(int alarmId) async {
    developer.log('Alarm required to stop', level: Level.FINE.value);
    // classic doEvents per permetre escriptura del missatge log
    await Future.delayed(const Duration(microseconds: 0), () => null);
    try {
      final cancelResult = await AndroidAlarmManager.cancel(alarmId);
      developer.log('Alarm $alarmId stoped! ($cancelResult)',
          level: Level.CONFIG.value);
      final cancelSnoozeResult =
          await AndroidAlarmManager.cancel(alarmId + snoozeId);
      developer.log('Snooze alarm $alarmId stoped! ($cancelSnoozeResult)',
          level: Level.CONFIG.value);

      // TODO check?? no other alarms are firing
      // It is a must simultaneus alarms joined in single alarm
      while (await FlutterForegroundTask.isRunningService) {
        developer.log('Stop foreground service', level: Level.FINE.value);
        ServiceRequestResult result = await ForegroundEntryHelper.stopService();
        while (!result.success) {
          developer.log('Repeat stop foreground service',
              level: Level.FINE.value);
          await Future.delayed(const Duration(milliseconds: 10), () async {
            result = await ForegroundEntryHelper.stopService();
          });
        }
      }
      await FlutterRingtonePlayer.stop();
    } catch (e) {
      developer.log('ERROR!');
    }
    // little wait time for everybody to stop...
    await Future.delayed(const Duration(milliseconds: 150), () => null);
  }
}
