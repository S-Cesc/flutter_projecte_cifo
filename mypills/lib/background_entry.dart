// logging and debugging
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_projecte_cifo/services/background_alarm_helper.dart';
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
  static const alarmStatusMessageKey = "st";
  static const alarmStatusSnoozedKey = "snoozed";
  static const alarmStatusLostKey = "lost";

  static const idAlarmTest = 3; // AlarmId per proves
  static const bool _soundAlarm =
      kReleaseMode || true; // lets avoid sound on debug

  static BackgroundPreferences preferences = BackgroundPreferences();

//=======================================================================

  @pragma('vm:entry-point')
  static Future<void> initialize() async {
    await preferences.init();
  }

  // The callback for our alarm
  @pragma('vm:entry-point')
  static Future<void> callback(int alarmId) async {
    Alarm? alarm;
    // TimeOfDay? alarmNextShoot;
    developer.log('Alarm $alarmId fired!', level: Level.CONFIG.value);
    developer.log('ISOLATE: $backgroundIsolateName, $isolateId',
        level: Level.INFO.value);
    await preferences.requery();
    if (alarmId != idAlarmTest) {
      alarm = await preferences.currentAlarm(alarmId);
    }
    if (alarm != null || alarmId == idAlarmTest) {
      // block: dispose uiSendPort variable quickly
      // as foreground-service will create a new App instance and a new port
      // and there'd be a race condition on registered name
      {
        // init the port and send "wakeup" message to App
        // early message to arrive when config screen in foreground
        final SendPort? uiSendPort =
            IsolateNameServer.lookupPortByName(uiWakeupPortName);
        if (uiSendPort != null) {
          uiSendPort.send("wakeup");
          developer.log('Sent "wakeup" to App by uiWakeupPortName',
              level: Level.FINE.value);
        } else {
          developer.log('Alarm fired, but uiWakeupPortName IS null',
              level: Level.FINE.value);
        }
      }
      // init Foreground service
      ForegroundEntryHelper.initService();
      await ForegroundEntryHelper.startService();
      if (alarm != null) {
        // RING -- _soundAlarm bool to avoid night debugging sound
        if (_soundAlarm) {
          await FlutterRingtonePlayer.playAlarm(
            looping: true,
            asAlarm: true,
            volume: 1.0,
          );
        }
        alarm.fireAlarm();
        await preferences.storeChangedAlarm(alarm.id);
      }
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      // Add CALLBACK from foreground-service
      // It forwards foreground-service messages to App
      // Maybe it's not needed for "wakeup" message, but it
      // also could be useful to snooze directly from notification
      // (foreground-service) instead of doing that from the App
      FlutterForegroundTask.addTaskDataCallback((Object obj) {
        developer.log('ISOLATE: $backgroundIsolateName, $isolateId',
            level: Level.INFO.value);
        if (obj is String) {
          try {
            // foreground-service must have opened the App, and also its port
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
              // case: snooze from notification
              // unawaited(snooze());
            } else {
              developer.log(
                  'Received background callback unknown message: $obj',
                  level: Level.WARNING.value);
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
      });
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      // init the port and send alarmId message DELAYED
      // use async as App may still need some more time to start
      await Future.delayed(const Duration(milliseconds: 8000), () async {
        final SendPort? uiSendInfoPort =
            IsolateNameServer.lookupPortByName(uiAlarmPortName);
        if (uiSendInfoPort != null) {
          uiSendInfoPort
              .send(json.encode(<String, dynamic>{alarmIdMessageKey: alarmId}));
          developer.log('Sent "alarmId" to App by uiSendInfoPort',
              level: Level.FINE.value);
        } else {
          developer.log('Alarm fired, but uiSendInfoPort IS null',
              level: Level.FINE.value);
        }
      });
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    } else {
      developer.log("Alarm $alarmId NOT FOUND", level: Level.SEVERE.value);
    }
  } // end callback

//=======================================================================

  @pragma('vm:entry-point')
  static Future<void> snoozecallback(int alarmId) async {
    // NOTE No limit of repetitions, no alarm state changed (manual-snooze)
    bool repeat = true;
    developer.log('ISOLATE: $backgroundIsolateName, $isolateId',
        level: Level.INFO.value);
    developer.log("Alarm $alarmId ($alarmId) snoozed", level: Level.INFO.value);
    if (alarmId != idAlarmTest) {
      var alarm = await preferences.currentAlarm(alarmId);
      if (alarm != null) {
        repeat =
            alarm.actualReplay <= preferences.alarmSettings.alarmRepeatTimes;
        await FlutterRingtonePlayer.stop();
      }
    }
    // cancel autosnooze
    await AndroidAlarmManager.cancel(alarmId + snoozeId);
    // Don't repeat test-alarm, erroneus alarms
    // or autoSnoozeCallback repeating more than max times
    if (repeat) {
      await BackgroundAlarmHelper.repeatAlarm(
        alarmId,
        preferences.alarmSettings.alarmSnoozeSeconds,
        preferences.alarmSettings.alarmDurationSeconds,
        callback,
        autoSnoozeCallback,
      );
    }
  }

//=======================================================================

  @pragma('vm:entry-point')
  static Future<void> autoSnoozeCallback(int snoozeAlarmId) async {
    var alarmId = snoozeAlarmId - snoozeId;
    await snoozecallback(alarmId);
    developer.log("Alarm $alarmId ($snoozeAlarmId - $snoozeId) auto-snoozed",
        level: Level.INFO.value);
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // init the port and send alarmSnoozed message
    await Future.delayed(const Duration(milliseconds: 50), () async {
      final SendPort? uiSendInfoPort =
          IsolateNameServer.lookupPortByName(uiAlarmPortName);
      if (uiSendInfoPort != null) {
        uiSendInfoPort.send(json.encode(
            <String, dynamic>{alarmStatusMessageKey: alarmStatusSnoozedKey}));
        developer.log(
            'Sent "$alarmStatusMessageKey": '
            '"$alarmStatusSnoozedKey" '
            'to App by uiSendInfoPort',
            level: Level.FINE.value);
      } else {
        developer.log('Alarm snoozed, but uiSendInfoPort IS null',
            level: Level.FINE.value);
      }
    });
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    if (alarmId != idAlarmTest) {
      var alarm = await preferences.currentAlarm(alarmId);
      if (alarm != null) {
        alarm.snoozeAlarm();
        await preferences.storeChangedAlarm(alarmId);
        if (alarm.actualReplay > preferences.alarmSettings.alarmRepeatTimes) {
          // NOTE - En stopCallback es pot detectar que l'alarma està perduda:
          await stopcallback(alarmId);
        } else {
          await FlutterRingtonePlayer.stop();
        }
      }
    }
  }

//=======================================================================

  @pragma('vm:entry-point')
  static Future<void> stopcallback(int alarmId) async {
    developer.log('Alarm required to stop', level: Level.FINE.value);
    try {
      final cancelResult = await AndroidAlarmManager.cancel(alarmId);
      developer.log('Alarm $alarmId stoped! ($cancelResult)',
          level: Level.CONFIG.value);
      final cancelSnoozeResult =
          await AndroidAlarmManager.cancel(alarmId + snoozeId);
      developer.log(
          'Snooze alarm ${alarmId + snoozeId} stoped! ($cancelSnoozeResult)',
          level: Level.CONFIG.value);
      if (alarmId != idAlarmTest) {
        var alarm = await preferences.currentAlarm(alarmId);
        if (alarm != null) {
          // Next shoot
          var alarmNextShoot = alarm.nextShoot(preferences.weeklyTimeTable);
          Duration alarmNextShootTime = Duration(
              hours: alarmNextShoot.hour, minutes: alarmNextShoot.minute);
          DateTime now = DateTime.now();
          DateTime dateTime = DateUtils.dateOnly(now);
          if (now.hour < alarmNextShoot.hour ||
              (now.hour == alarmNextShoot.hour &&
                  now.minute < alarmNextShoot.minute)) {
            dateTime.add(Duration(days: 1));
          }
          dateTime.add(alarmNextShootTime);
          await BackgroundAlarmHelper.fireAlarm(
            dateTime,
            alarmId,
            preferences.alarmSettings.alarmDurationSeconds,
            callback,
            autoSnoozeCallback,
          );
          developer.log(
              "Next shoot at "
              "${dateTime.month}-${dateTime.day} "
              "${alarmNextShoot.hour}:${alarmNextShoot.minute}",
              level: Level.INFO.value);
          await FlutterRingtonePlayer.stop();
          if (alarm.isSnoozed &&
              alarm.actualReplay > preferences.alarmSettings.alarmRepeatTimes) {
            // REVIEW -  TODO: Alarm lost (importance of log)
            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            // init the port and send alarmLost message
            await Future.delayed(const Duration(milliseconds: 50), () async {
              final SendPort? uiSendInfoPort =
                  IsolateNameServer.lookupPortByName(uiAlarmPortName);
              if (uiSendInfoPort != null) {
                uiSendInfoPort.send(json.encode(<String, dynamic>{
                  alarmStatusMessageKey: alarmStatusLostKey
                }));
                developer.log(
                    'Sent "$alarmStatusMessageKey": '
                    '"$alarmStatusLostKey" '
                    'to App by uiSendInfoPort',
                    level: Level.FINE.value);
              } else {
                developer.log('Alarm lost, but uiSendInfoPort IS null',
                    level: Level.FINE.value);
              }
            });
            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          }
          alarm.stopAlarm();
          await preferences.storeChangedAlarm(alarmId);
        } else {
          developer.log("Required to stop innexistent alarm $alarmId",
              level: Level.WARNING.value);
        }
      }
      // TODO check?? no other alarms are firing
      // It is a must simultaneus alarms joined in single alarm
      while (await FlutterForegroundTask.isRunningService) {
        developer.log('Stop foreground service', level: Level.FINE.value);
        ServiceRequestResult result = await ForegroundEntryHelper.stopService();
        while (!result.success) {
          developer.log('Repeat stop foreground service',
              level: Level.FINE.value);
          await Future.delayed(const Duration(milliseconds: 300), () async {
            result = await ForegroundEntryHelper.stopService();
          });
        }
      }
    } catch (e) {
      developer.log('ERROR!');
    }
    // little wait time for everybody to stop...
    await Future.delayed(const Duration(milliseconds: 150), () => null);
  }
}
