// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:async' show unawaited;
import 'dart:ui' show IsolateNameServer;
import 'dart:convert';
import 'dart:isolate';
// Flutter
import 'package:flutter/material.dart' show DateUtils, TimeOfDay;
import 'package:flutter/foundation.dart' show kReleaseMode;
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
/// static members implementing Alarm entry points & data
class BackgroundEntry {
  /// Background service isolate name
  static const String backgroundIsolateName = 'myPillsAlarm';

  /// Background service isolate id
  static final int isolateId = Isolate.current.hashCode;

  /// Alarm snooze Id desplazament (each alarm has Id and id + snoozeId)
  static const int snoozeId = 128; // Greatest alarmId to sum is 75

  /// special test empty alarm Id (no data) 3 - 131
  static const idAlarmTest = 3; // AlarmId per proves

  /// channel communication [uiAlarmPortName] alarmId message key
  static const alarmIdMessageKey = "alarmId";

  /// channel communication [uiAlarmPortName] status message key
  static const alarmStatusMessageKey = "st";

  /// channel communication [uiAlarmPortName] status message (1)
  static const alarmStatusSnoozedMessage = "snoozed";

  /// channel communication [uiAlarmPortName] status message (2)
  static const alarmStatusStoppedMessage = "stopped";

  /// channel communication [uiAlarmPortName] status message (3)
  static const alarmStatusLostMessage = "lost";

  static const bool _soundAlarm =
      kReleaseMode || true; // lets avoid sound on debug

  static final BackgroundPreferences _preferences = BackgroundPreferences();

  // Sorry, an interevent comunication;
  // Dart doesn't have an other mechanism
  // This one avoids snooze while stop callback is executing
  // The object "Alarm" wold need safe access
  static bool _stopIsExecuting = false;

//=======================================================================

  @pragma('vm:entry-point')

  /// Entry point: initialize data objects for alarm isolate
  static Future<void> initialize() async {
    await _preferences.init();
  }

  @pragma('vm:entry-point')

  /// Entry point: The callback for our alarm
  /// programmed by user on [BackgroundAlarmHelper.fireAlarm]
  static Future<void> callback(int alarmId) async {
    Alarm? alarm;
    developer.log('ISOLATE: $backgroundIsolateName, $isolateId',
        level: Level.INFO.value);
    developer.log('Alarm $alarmId fired!', level: Level.CONFIG.value);
    await _preferences.requery();
    if (alarmId != idAlarmTest) {
      alarm = await _preferences.currentAlarm(alarmId);
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
          unawaited(FlutterRingtonePlayer.playAlarm(
            looping: true,
            asAlarm: true,
            volume: 1.0,
          ));
        }
        // update alarm status
        alarm.markAlarmfired();
        await _preferences.storeChangedAlarm(alarm.id);
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

  /// Entry point: The autosnooze callback
  /// programmed by user on [BackgroundAlarmHelper.fireAlarm]
  /// to fire [alarmDurationSeconds] later than alarm callback
  /// [snoozeAlarmId] = alarmId + [snoozeId]
  static Future<void> autoSnoozeCallback(int snoozeAlarmId) async {
    final alarmId = snoozeAlarmId - snoozeId;
    try {
      developer.log('ISOLATE: $backgroundIsolateName, $isolateId',
          level: Level.INFO.value);
      developer.log("Alarm $alarmId ($snoozeAlarmId) auto-snoozed",
          level: Level.CONFIG.value);
      if (alarmId != idAlarmTest) {
        var alarm = await _preferences.currentAlarm(alarmId);
        if (alarm != null && !alarm.isStopped) {
          // update alarm status
          alarm.markAlarmSnoozed();
          await _preferences.storeChangedAlarm(alarmId);
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

  /// Entry point: Callback for alarm snooze
  /// It's called from [autoSnoozeCallback]
  /// but also by user from [BackgroundAlarmHelper.snoozeAlarm] as 0ms oneShot
  static Future<void> snoozeCallback(int alarmId) async {
    try {
      // NOTE Manual-snoozed have no limit of repetitions
      // auto-snooze calls here to implement snooze
      // but auto-snooze adds more logic to update the alarm state (repetitions)
      bool repeat = true;
      developer.log('ISOLATE: $backgroundIsolateName, $isolateId',
          level: Level.INFO.value);
      developer.log("Alarm $alarmId snoozed", level: Level.CONFIG.value);
      if (alarmId != idAlarmTest) {
        unawaited(FlutterRingtonePlayer.stop());
        var alarm = await _preferences.currentAlarm(alarmId);
        if (alarm == null || alarm.isStopped) {
          // Don't repeat erroneous alarms nor stopped alarms
          repeat = false;
        } else if (alarm.actualReplay >=
            _preferences.alarmSettings.alarmRepeatTimes) {
          // LOST ALARM
          // REVIEW -  TODO: Alarm lost (importance of log)
          repeat = false;
          // update alarm status
          alarm.markAlarmStopped();
          await _preferences.storeChangedAlarm(alarmId);
          // inform status
          await _sendStatusMessage(alarmStatusLostMessage);
          // next shot
          // warning: it's not a replay, replays are exhausted
          await _fireNextShot(alarm);
        }
      }
      // Actions for all snoozed alarms, except lost alarms
      if (repeat) {
        await _cancelAlarm(alarmId);
        await _sendStatusMessage(alarmStatusSnoozedMessage);
        await _repeatAlarm(
          alarmId,
          _preferences.alarmSettings.alarmSnoozeSeconds,
          _preferences.alarmSettings.alarmDurationSeconds,
        );
      }
    } catch (e) {
      developer.log("ERROR: Alarm snooze ($alarmId): $e",
          level: Level.SEVERE.value);
    }
  }

//=======================================================================

  @pragma('vm:entry-point')

  /// Entry point: Callback to stop alarm
  /// called by user from [BackgroundAlarmHelper.stopAlarm] as 0ms oneShot
  static Future<void> stopCallback(int alarmId) async {
    _stopIsExecuting = true;
    try {
      bool alarmFound = true;
      developer.log('ISOLATE: $backgroundIsolateName, $isolateId',
          level: Level.INFO.value);
      developer.log('Alarm $alarmId required to stop',
          level: Level.CONFIG.value);
      if (alarmId != idAlarmTest) {
        unawaited(FlutterRingtonePlayer.stop());
        final alarm = await _preferences.currentAlarm(alarmId);
        if (alarm != null) {
          // update alarm status
          alarm.markAlarmStopped();
          await _preferences.storeChangedAlarm(alarmId);
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          developer.log("Fire next shot", level: Level.FINE.value);
          await _fireNextShot(alarm);
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        } else {
          alarmFound = false;
          await _cancelAlarm(alarmId);
          developer.log("Required to stop nonexistent alarm $alarmId",
              level: Level.WARNING.value);
        }
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
        while (result is ServiceRequestFailure) {
          developer.log(
              'Repeat stop foreground service '
              '${(result as ServiceRequestFailure).error}',
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

  /// Entry point: Cancel a programmed alarm (usually for reprogramming)
  /// called by user from [BackgroundAlarmHelper.cancelAlarm] as 0ms oneShot
  static Future<void> cancelCallback(int alarmId) async {
    await _cancelAlarm(alarmId);
  }

//=======================================================================
//                      PRIVATE
//=======================================================================

//=======================================================================
  static Future<void> _repeatAlarm(
      int alarmId, int alarmSnoozeSeconds, int alarmDurationSeconds) async {
    developer.log("Helper: Repeat alarm", level: Level.INFO.value);
    await AndroidAlarmManager.oneShot(
      Duration(seconds: alarmSnoozeSeconds),
      alarmId,
      BackgroundEntry.callback,
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
  static Future<void> _fireNextShot(Alarm alarm) async {
    await _cancelAlarm(alarm.id);
    // Compute next shot
    DateTime dateTime;
    {
      final TimeOfDay alarmTomorrowShot =
          alarm.tomorrowShot(_preferences.weeklyTimeTable);
      final Duration alarmNextShotTime = Duration(
          days: 1,
          hours: alarmTomorrowShot.hour,
          minutes: alarmTomorrowShot.minute);
      dateTime = DateUtils.dateOnly(DateTime.now()).add(alarmNextShotTime);
      developer.log(
          "Next shot at "
          "${dateTime.month}-${dateTime.day} "
          "${dateTime.hour}:${dateTime.minute}",
          level: Level.INFO.value);
    }
    // Fire next shot
    await BackgroundAlarmHelper.fireAlarm(
      dateTime,
      alarm.id,
      _preferences.alarmSettings.alarmDurationSeconds,
    );
  }

//=======================================================================
}
