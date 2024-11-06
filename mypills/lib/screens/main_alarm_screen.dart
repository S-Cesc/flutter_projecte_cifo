// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:isolate';
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// Project files
import '../background_entry.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainAlarmScreen extends StatefulWidget {
  const MainAlarmScreen({super.key});

  @override
  State<MainAlarmScreen> createState() => _MainAlarmScreenState();
}

class _MainAlarmScreenState extends State<MainAlarmScreen> {
  bool _alarmIsActivated = true;

  Future<void> cancelAlarm() async {
    await AndroidAlarmManager.oneShot(
      const Duration(microseconds: 0),
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Take the pills'),
          elevation: 4,
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: Row(
              children: [
                if (_alarmIsActivated)
                  Expanded(
                    child: Center(
                        child: ElevatedButton(
                      onPressed: () async {
                        developer.log("Cancel alarm button clicked!",
                            level: Level.FINER.value);
                        await cancelAlarm();
                        // END APPLICATION
                        SystemNavigator.pop();
                      },
                      child: const Text('Cancel the alarm'),
                    )),
                  ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
