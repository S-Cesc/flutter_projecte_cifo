// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:async' show StreamSubscription, unawaited;
import 'dart:ui' show IsolateNameServer;
import 'dart:isolate';
import 'dart:convert';
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypills/model/global_constants.dart';
import 'package:one_clock/one_clock.dart';
// Localization
import '../l10n/app_localizations.dart';
// Project files
import '../main.dart' as main;
import '../util/port_facilities.dart';
import '../model/alarm.dart';
import '../styles/app_styles.dart';
import '../background_entry.dart';
import '../providers/background_preferences.dart';
import '../services/background_alarm_helper.dart';

//=======================================================================

/// Alarm main screen
class MainAlarmScreen extends StatefulWidget {
  /// const ctor
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
      _infoPort.sendPort,
      main.uiAlarmPortName,
    )) {
      _subscription = _listenInfoPort(_infoPort);
    } else {
      developer.log(
        "Port ${main.uiAlarmPortName} couldn't be registered",
        level: Level.SEVERE.value,
      );
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
            level: Level.FINE.value,
          );
          if (jsonMessage.containsKey(BackgroundEntry.alarmIdMessageKey)) {
            _alarmId = jsonMessage[BackgroundEntry.alarmIdMessageKey] as int;
            if (_alarmId == BackgroundEntry.idAlarmTest) {
              developer.log(
                'Alarm message id=$_alarmId (test)'
                ' from ${main.uiAlarmPortName}',
              );
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
                  level: Level.WARNING.value,
                );
              }
            }
            //TODO always include alarmId in the message
          } else if (jsonMessage.containsKey(
            BackgroundEntry.alarmStatusMessageKey,
          )) {
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
            level: Level.WARNING.value,
          );
        }
      } else {
        developer.log(
          'Unknown message from ${main.uiAlarmPortName}: $obj',
          level: Level.WARNING.value,
        );
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

  Widget _takeThePills(AppLocalizations t) {
    return Center(
      child: Text(t.notificationTitle, style: AppStyles.constFonts.display),
    );
  }

  Widget _digitalClock(bool isLive, DateTime alarmDateTime) {
    return DigitalClock(
      showSeconds: true,
      datetime: alarmDateTime,
      textScaleFactor: 2,
      isLive: isLive,
    );
  }

  Widget _analogClock() {
    return AnalogClock(
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
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _alarmName(AppLocalizations t, int alarmId) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Text(
        Alarm.getAlarmNameFromId(t, alarmId),
        style: AppStyles.constFonts.labelLarge,
        softWrap: true,
      ),
    );
  }

  List<Widget> _actions(
    AppLocalizations t,
    int? alarmId,
    bool alarmIsActivated,
  ) {
    return [
      if (alarmId != null) ...[
        if (alarmIsActivated) ...[
          Expanded(
            child: Center(
              child: ElevatedButton(
                style: AppStyles.alarmButtonStyle,
                onPressed: () async {
                  developer.log(
                    "Cancel alarm button clicked!",
                    level: Level.FINER.value,
                  );
                  await _cancelAlarm(alarmId);
                  await Future.delayed(
                    const Duration(milliseconds: 1500),
                    () async {
                      developer.log(
                        "Pop screen: "
                        "Cancel button",
                        level: Level.INFO.value,
                      );
                      await SystemNavigator.pop();
                    },
                  );
                },
                // TODO: Next screen with the alarm paused
                child: Text(t.cancel, style: AppStyles.constFonts.headline),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                style: AppStyles.alarmButtonStyle,
                onPressed: () async {
                  developer.log(
                    "Snooze alarm button clicked!",
                    level: Level.FINER.value,
                  );
                  await _snoozeAlarm(alarmId);
                  await Future.delayed(
                    GlobalConstants.veryLongDelayForOperation,
                    () async {
                      developer.log(
                        "Pop screen: "
                        "Snooze button",
                        level: Level.INFO.value,
                      );
                      await SystemNavigator.pop();
                    },
                  );
                },
                child: Text(t.snooze, style: AppStyles.constFonts.headline),
              ),
            ),
          ),
        ] else ...[
          Expanded(
            child: Center(
              child: Builder(
                builder: (context) {
                  // little trick
                  unawaited(
                    // REVIEW: Can be set to a value from GlobalConstants?
                    Future.delayed(const Duration(seconds: 7), () {
                      SystemNavigator.pop();
                    }),
                  );
                  return Text(
                    _alarmIsLost
                        ? t.missedAlarm
                        : _alarmIsStopped
                        ? t.stoppedAlarm
                        : t.snoozedAlarm,
                    style: AppStyles.constFonts.headline,
                  );
                },
              ),
            ),
          ),
        ],
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    final DateTime alarmDateTime = _alarm?.lastShot ?? DateTime.now();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppStyles.colors.mantis,
        appBar: AppBar(title: Text(t.notificationTitle), elevation: 4),
        body: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _takeThePills(t),
                  if (_alarmId != null) ...[
                    _digitalClock(_alarm == null, alarmDateTime),
                  ],
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: _analogClock(),
                  ),
                  if (_alarmId != null) ...[
                    _alarmName(t, _alarmId!),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [..._actions(t, _alarmId, _alarmIsActivated)],
                    ),
                  ],
                ],
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (_alarmId != null) ...[
                            _digitalClock(_alarm == null, alarmDateTime),
                            _alarmName(t, _alarmId!),
                            ..._actions(t, _alarmId, _alarmIsActivated),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(child: _takeThePills(t)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 20,
                            ),
                            child: _analogClock(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
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
