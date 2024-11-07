// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:io' show exit;
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:one_clock/one_clock.dart';
// Project files
import '../main.dart' as main;
import '../background_entry.dart';
import '../styles/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainAlarmScreen extends StatefulWidget {
  const MainAlarmScreen({super.key});

  @override
  State<MainAlarmScreen> createState() => _MainAlarmScreenState();
}

class _MainAlarmScreenState extends State<MainAlarmScreen> {
  bool _alarmIsActivated = true;

  Future<void> _cancelAlarm() async {
    await AndroidAlarmManager.oneShot(
      const Duration(microseconds: 3000),
      BackgroundEntry.id,
      BackgroundEntry.stopcallback,
      // alarmClock: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
      exact: true,
      wakeup: true,
    );
    setState(() {
      _alarmIsActivated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime alarmDateTime = DateTime.now();
    return MaterialApp(
      home: Scaffold(
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
              width: 120,
              height: 120,
            ),
          ),
          Row(
            children: [
              if (_alarmIsActivated)
                Expanded(
                  child: Center(
                      child: ElevatedButton(
                    onPressed: () async {
                      developer.log("Cancel alarm button clicked!",
                          level: Level.FINER.value);
                      await _cancelAlarm();
                      // END APPLICATION
                      await Future.delayed(const Duration(milliseconds: 10000),
                          () async {
                        developer.log("Exit application",
                            level: Level.INFO.value);
                        await SystemNavigator.pop();
                        if (kDebugMode) exit(0);
                      });
                    },
                    child: Text('Cancel the alarm',
                        style: AppStyles.fonts.headline()),
                  )),
                ),
            ],
          ),
        ]),
      ),
    );
  }

  // TODO: super.dispose només si no queden pantalles (compte què matem)
  // @override
  // void dispose() {
  //   main.dispose();
  //   super.dispose();
  // }
}
