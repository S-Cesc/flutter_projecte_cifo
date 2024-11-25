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
import 'services/background_alarm_helper.dart';
import 'services/foreground_entry_helper.dart';

/* ONLY static MEMBERS */
class BackgroundEntry {
  static const String backgroundIsolateName = 'myPillsAlarm';
  static final int isolateId = Isolate.current.hashCode;
  static const int snoozeId = 128; // Greatest alarmId to sum is 75
  static const alarmIdMessageKey = "alarmId";
  static const alarmStatusMessageKey = "st";
  static const alarmStatusSnoozedMessage = "snoozed";
  static const alarmStatusStoppedMessage = "stopped";
  static const alarmStatusLostMessage = "lost";

  static const idAlarmTest = 3; // AlarmId per proves
  static const bool _soundAlarm =
      kReleaseMode || true; // lets avoid sound on debug

  static BackgroundPreferences preferences = BackgroundPreferences();

  // Sorry, an interevent comunication;
  // Dart doesn't have an other mechanism
  // This one avoids snooze while stop callback is executing
  // The object "Alarm" wold need safe access
  static bool _stopIsExecuting = false;

//=======================================================================

  @pragma('vm:entry-point')
  static Future<void> initialize() async {
    await preferences.init();
  }

  // The callback for our alarm
  @pragma('vm:entry-point')
  static Future<void> callback(int alarmId) async {
    Alarm? alarm;
    developer.log('ISOLATE: $backgroundIsolateName, $isolateId',
        level: Level.INFO.value);
    developer.log('Alarm $alarmId fired!', level: Level.CONFIG.value);
    await preferences.requery();
    if (alarmId != idAlarmTest) {
      alarm = await preferences.currentAlarm(alarmId);
    }
    if (alarm != null || alarmId == idAlarmTest) {
      // block: dispose uiSendPort variable quickly
      // as foreground-service will create a new App instance and a new port
      // and there would be a race condition on registered name
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
        // update alarm status
        alarm.markAlarmfired();
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
                'Background callback received message threw error: ${e.toString()}',
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
  static Future<void> snoozeCallback(int alarmId) async {
    try {
      // NOTE Manual-snoozed have no limit of repetitions, no alarm state changed
      // auto-snooze calls here to implement snooze
      // but auto-snooze adds more logic to update the alarm state
      bool repeat = true;
      developer.log('ISOLATE: $backgroundIsolateName, $isolateId',
          level: Level.INFO.value);
      developer.log("Alarm $alarmId snoozed", level: Level.CONFIG.value);
      if (alarmId != idAlarmTest) {
        var alarm = await preferences.currentAlarm(alarmId);
        if (alarm == null || alarm.isStopped) {
          // Don't repeat erroneous alarms nor stopped alarms
          repeat = false;
        } else if (alarm.actualReplay >=
            preferences.alarmSettings.alarmRepeatTimes) {
          // LOST ALARM
          // REVIEW -  TODO: Alarm lost (importance of log)
          repeat = false;
          // update alarm status
          alarm.markAlarmStopped();
          await preferences.storeChangedAlarm(alarmId);
          // inform status
          await _sendStatusMessage(alarmStatusLostMessage);
          // next shoot
          // warning: it's not a replay, replays are exhausted
          await _fireNextShoot(alarm);
        }
        unawaited(FlutterRingtonePlayer.stop());
      }
      // Actions for all snoozed alarms, except lost alarms
      if (repeat) {
        await _cancelAlarm(alarmId);
        await _sendStatusMessage(alarmStatusSnoozedMessage);
        await BackgroundAlarmHelper.repeatAlarm(
          alarmId,
          preferences.alarmSettings.alarmSnoozeSeconds,
          preferences.alarmSettings.alarmDurationSeconds,
        );
      }
    } catch (e) {
      developer.log("ERROR: Alarm snooze ($alarmId): $e",
          level: Level.SEVERE.value);
    }
  }

//=======================================================================

  @pragma('vm:entry-point')
  static Future<void> autoSnoozeCallback(int snoozeAlarmId) async {
    final alarmId = snoozeAlarmId - snoozeId;
    try {
      developer.log('ISOLATE: $backgroundIsolateName, $isolateId',
          level: Level.INFO.value);
      developer.log("Alarm $alarmId ($snoozeAlarmId) auto-snoozed",
          level: Level.CONFIG.value);
      if (alarmId != idAlarmTest) {
        var alarm = await preferences.currentAlarm(alarmId);
        if (alarm != null && !alarm.isStopped) {
          // update alarm status
          alarm.markAlarmSnoozed();
          await preferences.storeChangedAlarm(alarmId);
        }
      }
      await snoozeCallback(alarmId);
    } catch (e) {
      developer.log("ERROR: Alarm auto-snooze ($snoozeAlarmId: $alarmId): $e",
          level: Level.SEVERE.value);
    }
  }

//=======================================================================

  @pragma('vm:entry-point')
  static Future<void> stopCallback(int alarmId) async {
    _stopIsExecuting = true;
    try {
      bool alarmFound = true;
      developer.log('ISOLATE: $backgroundIsolateName, $isolateId',
          level: Level.INFO.value);
      developer.log('Alarm $alarmId required to stop',
          level: Level.CONFIG.value);
      if (alarmId != idAlarmTest) {
        final alarm = await preferences.currentAlarm(alarmId);
        if (alarm != null) {
          // update alarm status
          alarm.markAlarmStopped();
          await preferences.storeChangedAlarm(alarmId);
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          developer.log("Fire next shoot", level: Level.FINE.value);
          await _fireNextShoot(alarm);
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        } else {
          alarmFound = false;
          await _cancelAlarm(alarmId);
          developer.log("Required to stop nonexistent alarm $alarmId",
              level: Level.WARNING.value);
        }
        await FlutterRingtonePlayer.stop();
      } else {
        await _cancelAlarm(alarmId);
      }
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if (alarmFound) {
        await _sendStatusMessage(alarmStatusStoppedMessage);
      }
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      // TODO check?? no other alarms are firing
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      // Stop foregroundTask (full-screen notification)
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
      // little wait time for everybody to stop...
      await Future.delayed(const Duration(milliseconds: 150), () => null);
    } catch (e) {
      developer.log("ERROR: Alarm stop ($alarmId): $e",
          level: Level.SEVERE.value);
    }
    _stopIsExecuting = false;
  }

//=======================================================================

  @pragma('vm:entry-point')
  static Future<void> cancelCallback(int alarmId) async {
    await _cancelAlarm(alarmId);
  }

//=======================================================================
//                      PRIVATE
//=======================================================================
  static Future<bool> _cancelAlarm(int alarmId) async {
    // stop the alarm & it's auto-snooze
    // cancel the alarm... usually should be already finished
    final cancelResult = await AndroidAlarmManager.cancel(alarmId);
    developer.log('Cancel alarm $alarmId ($cancelResult)',
        level: Level.CONFIG.value);
    // cancel the auto-snoze
    final cancelSnoozeResult =
        await AndroidAlarmManager.cancel(alarmId + snoozeId);
    developer.log(
        'Cancel snooze alarm ${alarmId + snoozeId} ($cancelSnoozeResult)',
        level: Level.CONFIG.value);
    return cancelResult && cancelSnoozeResult;
  }

//=======================================================================
  static Future<void> _sendStatusMessage(String message) async {
    await Future.delayed(const Duration(milliseconds: 50), () async {
      final SendPort? uiSendInfoPort =
          IsolateNameServer.lookupPortByName(uiAlarmPortName);
      if (uiSendInfoPort != null) {
        uiSendInfoPort.send(
            json.encode(<String, dynamic>{alarmStatusMessageKey: message}));
        developer.log(
            'Sent "$alarmStatusMessageKey": '
            '"$message" '
            'to App by uiSendInfoPort',
            level: Level.FINE.value);
      } else {
        developer.log(
            'No alarm status sent ($message): ' 'uiSendInfoPort IS null',
            level: Level.FINE.value);
      }
    });
  }

//=======================================================================
  static Future<void> _fireNextShoot(Alarm alarm) async {
    await _cancelAlarm(alarm.id);
    // Compute next shoot
    DateTime dateTime;
    {
      final TimeOfDay alarmTomorrowShoot =
          alarm.tomorrowShoot(preferences.weeklyTimeTable);
      final Duration alarmNextShootTime = Duration(
          days: 1,
          hours: alarmTomorrowShoot.hour,
          minutes: alarmTomorrowShoot.minute);
      dateTime = DateUtils.dateOnly(DateTime.now()).add(alarmNextShootTime);
      developer.log(
          "Next shoot at "
          "${dateTime.month}-${dateTime.day} "
          "${dateTime.hour}:${dateTime.minute}",
          level: Level.INFO.value);
    }
    // Fire next shoot
    await BackgroundAlarmHelper.fireAlarm(
      dateTime,
      alarm.id,
      preferences.alarmSettings.alarmDurationSeconds,
    );
  }

//=======================================================================
}
