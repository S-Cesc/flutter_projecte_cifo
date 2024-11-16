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
import '../styles/app_styles.dart';
import '../background_entry.dart';
import '../services/background_alarm_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//=======================================================================

class MainAlarmScreen extends StatefulWidget {
  const MainAlarmScreen({super.key});

  @override
  State<MainAlarmScreen> createState() => _MainAlarmScreenState();
}

class _MainAlarmScreenState extends State<MainAlarmScreen> {
  bool _alarmIsActivated = true;

  Future<void> _cancelAlarm() async {
    developer.log("Cancel alarm", level: Level.INFO.value);
    await BackgroundAlarmHelper.cancelAlarm(
      BackgroundEntry.id,
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
            decoration: BoxDecoration(color: AppStyles.colors.forestGreen[200] , shape: BoxShape.circle),
          ),
        ),
        Row(
          children: [
            if (_alarmIsActivated)
              Expanded(
                child: Center(
                    child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppStyles.colors.mantis)),
                  onPressed: () async {
                    developer.log("Cancel alarm button clicked!",
                        level: Level.FINER.value);
                    await _cancelAlarm();
                    await Future.delayed(const Duration(milliseconds: 2500),
                        () async {
                      developer.log("Pop screen", level: Level.INFO.value);
                      await SystemNavigator.pop();
                    });
                  },
                  child:
                      Text('Cancel the alarm', style: AppStyles.fonts.headline()),
                )),
              ),
          ],
        ),
      ]),
    );
  }

  // TODO: super.dispose només si no queden pantalles (compte què matem)
  // @override
  // void dispose() {
  //   main.dispose();
  //   super.dispose();
  // }
}
