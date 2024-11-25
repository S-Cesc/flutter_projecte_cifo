// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_clock/one_clock.dart';
// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../main.dart' as main;
import '../util/port_facilities.dart';
import '../model/alarm.dart';
import '../styles/app_styles.dart';
import '../background_entry.dart';
import '../providers/background_preferences.dart';
import '../services/background_alarm_helper.dart';

//=======================================================================

class MainAlarmScreen extends StatefulWidget {
  const MainAlarmScreen({super.key});

  @override
  State<MainAlarmScreen> createState() => _MainAlarmScreenState();
}

class _MainAlarmScreenState extends State<MainAlarmScreen> {
  final BackgroundPreferences _pref = BackgroundPreferences();
  final _infoPort = ReceivePort();
  late StreamSubscription<dynamic>? _subscription;
  int? _alarmId;
  Alarm? _alarm;
  bool _alarmIsActivated = true;
  bool _alarmIsStopped = false;
  bool _alarmIsLost = false;

  @override
  void initState() {
    super.initState();
    if (PortFacilities.reRegisterPortWithName(
        _infoPort.sendPort, main.uiAlarmPortName)) {
      _subscription = _listenInfoPort(_infoPort);
    } else {
      developer.log("Port ${main.uiAlarmPortName} couldn't be registered",
          level: Level.SEVERE.value);
      TypeError();
    }
  }

  StreamSubscription<dynamic> _listenInfoPort(ReceivePort port) {
    return port.listen((obj) async {
      if (obj is String) {
        try {
          final jsonMessage = jsonDecode(obj) as Map<String, dynamic>;
          developer.log(
              'Alarm message received '
              'from ${main.uiAlarmPortName}: '
              '$jsonMessage',
              level: Level.FINE.value);
          if (jsonMessage.containsKey(BackgroundEntry.alarmIdMessageKey)) {
            _alarmId = jsonMessage[BackgroundEntry.alarmIdMessageKey] as int;
            if (_alarmId == BackgroundEntry.idAlarmTest) {
              developer.log('Alarm message id=$_alarmId (test)'
                  ' from ${main.uiAlarmPortName}');
              setState(() {
                _alarmId;
              });
            } else {
              _alarm = await _pref.currentAlarm(_alarmId!);
              if (_alarm != null) {
                setState(() {
                  _alarmId;
                  _alarm;
                });
              } else {
                _alarmId = null;
                developer.log(
                    'Alarm id=${_alarmId ?? "null"} message'
                    ' from ${main.uiAlarmPortName}'
                    ' is not binded to an alarm object',
                    level: Level.WARNING.value);
              }
            }
            //TODO always include alarmId in the message
          } else if (jsonMessage
              .containsKey(BackgroundEntry.alarmStatusMessageKey)) {
            final String status =
                jsonMessage[BackgroundEntry.alarmStatusMessageKey] as String;
            switch (status) {
              case BackgroundEntry.alarmStatusSnoozedMessage:
                setState(() {
                  _alarmIsActivated = false;
                  // _alarmIsLost = false;
                  // _alarmIsStopped = false;
                });
              case BackgroundEntry.alarmStatusStoppedMessage:
                setState(() {
                  _alarmIsActivated = false;
                  // _alarmIsLost = false;
                  _alarmIsStopped = true;
                });
              case BackgroundEntry.alarmStatusLostMessage:
                setState(() {
                  _alarmIsActivated = false;
                  _alarmIsLost = true;
                  _alarmIsStopped = true;
                });
              default:
                throw TypeError();
            }
          }
        } catch (e) {
          setState(() {
            _alarmId = null;
            _alarm = null;
          });
          developer.log(
              'Error receiving message from ${main.uiAlarmPortName}: $e',
              level: Level.WARNING.value);
        }
      } else {
        developer.log('Unknown message from ${main.uiAlarmPortName}: $obj',
            level: Level.WARNING.value);
      }
    });
  }

  Future<void> _cancelAlarm(int alarmId) async {
    await BackgroundAlarmHelper.stopAlarm(alarmId);
    setState(() {
      _alarmIsActivated = false;
      _alarmIsStopped = true;
      _alarmIsLost = false;
    });
  }

  Future<void> _snoozeAlarm(int alarmId) async {
    await BackgroundAlarmHelper.snoozeAlarm(alarmId);
    setState(() {
      _alarmIsActivated = false;
      _alarmIsStopped = false;
      _alarmIsLost = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    final DateTime alarmDateTime = DateTime.now();
    return Scaffold(
      backgroundColor: AppStyles.colors.mantis,
      appBar: AppBar(
        title: const Text('Take the pills'),
        elevation: 4,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Take the pills', style: AppStyles.fonts.display()),
        DigitalClock(
          showSeconds: true,
          datetime: alarmDateTime,
          textScaleFactor: 2,
          isLive: false,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: AnalogClock(
            isLive: true,
            showDigitalClock: false,
            width: 180,
            height: 180,
            showNumbers: true,
            showAllNumbers: false,
            showTicks: true,
            tickColor: AppStyles.colors.darkSlateGray[700]!,
            hourHandColor: AppStyles.colors.darkSlateGray[800]!,
            minuteHandColor: AppStyles.colors.darkSlateGray[800]!,
            numberColor: AppStyles.colors.darkSlateGray[900]!,
            decoration: BoxDecoration(
                color: AppStyles.colors.forestGreen[200],
                shape: BoxShape.circle),
          ),
        ),
        if (_alarmId != null) ...[
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              Alarm.getAlarmName(_alarmId!, t),
              style: AppStyles.fonts.labelLarge(),
              softWrap: true,
            ),
          ),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (_alarmId != null) ...[
              if (_alarmIsActivated) ...[
                Expanded(
                  child: Center(
                      child: ElevatedButton(
                    style: AppStyles.alarmButtonStyle,
                    onPressed: () async {
                      developer.log("Cancel alarm button clicked!",
                          level: Level.FINER.value);
                      await _cancelAlarm(_alarmId!);
                      await Future.delayed(const Duration(milliseconds: 1500),
                          () async {
                        developer.log("Pop screen: " "Cancel button",
                            level: Level.INFO.value);
                        await SystemNavigator.pop();
                      });
                    },
                    // TODO: Next screen with the alarm paused
                    child: Text(
                      t.cancel,
                      style: AppStyles.fonts.headline(),
                    ),
                  )),
                ),
                Expanded(
                  child: Center(
                      child: ElevatedButton(
                    style: AppStyles.alarmButtonStyle,
                    onPressed: () async {
                      developer.log("Snooze alarm button clicked!",
                          level: Level.FINER.value);
                      await _snoozeAlarm(_alarmId!);
                      await Future.delayed(const Duration(milliseconds: 1500),
                          () async {
                        developer.log("Pop screen: " "Snooze button",
                            level: Level.INFO.value);
                        await SystemNavigator.pop();
                      });
                    },
                    child: Text(
                      t.snooze,
                      style: AppStyles.fonts.headline(),
                    ),
                  )),
                )
              ] else ...[
                Expanded(
                  child: Center(
                    child: Builder(builder: (context) {
                      // little trick
                      unawaited(Future.delayed(const Duration(seconds: 7), () {
                        SystemNavigator.pop();
                      }));
                      return Text(
                        _alarmIsLost
                            ? t.missedAlarm
                            : _alarmIsStopped
                                ? t.stoppedAlarm
                                : t.snoozedAlarm,
                        style: AppStyles.fonts.headline(),
                      );
                    }),
                  ),
                )
              ]
            ]
          ],
        ),
      ]),
    );
  }

  @override
  void dispose() {
    developer.log('ALARM SCREEN DISPOSE', level: Level.CONFIG.value);
    unawaited(_subscription?.cancel());
    IsolateNameServer.removePortNameMapping(main.uiAlarmPortName);
    _infoPort.close();
    _subscription = null;
    super.dispose();
  }
}
