// logging and debugging
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_projecte_cifo/providers/background_preferences.dart';
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:io' show exit;
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:one_clock/one_clock.dart';
// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../main.dart' as main;
import '../util/port_facilities.dart';
import '../model/alarm.dart';
import '../styles/app_styles.dart';
import '../background_entry.dart';
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
          if (jsonMessage.containsKey(BackgroundEntry.alarmIdMessageKey)) {
            _alarmId = jsonMessage[BackgroundEntry.alarmIdMessageKey] as int;
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
                  ' did not bind to an alarm object',
                  level: Level.WARNING.value);
            }
          }
        } catch (e) {
          _alarmId = null;
          _alarm = null;
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

  Future<void> _cancelAlarm(int alarmId, Alarm alarm) async {
    alarm.stopAlarm();
    await _pref.storeChangedAlarm(alarmId);
    await BackgroundAlarmHelper.cancelAlarm(
      BackgroundEntry.idTstAlarm,
      BackgroundEntry.stopcallback,
    );
    setState(() {
      _alarmIsActivated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        Row(
          children: [
            if (_alarmId != null && _alarmIsActivated)
              Expanded(
                child: Center(
                    child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppStyles.colors.mantis)),
                  onPressed: () async {
                    developer.log("Cancel alarm button clicked!",
                        level: Level.FINER.value);
                    await _cancelAlarm(_alarmId!, _alarm!);
                    await Future.delayed(const Duration(milliseconds: 1500),
                        () async {
                      developer.log("Pop screen", level: Level.INFO.value);
                      await SystemNavigator.pop();
                    });
                  },
                  child: Text('Cancel the alarm',
                      style: AppStyles.fonts.headline()),
                )),
              ),
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
