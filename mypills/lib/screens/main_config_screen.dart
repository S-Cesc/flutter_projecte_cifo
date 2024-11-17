// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:async';
import 'dart:isolate';
import 'dart:io' show exit;
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter_projecte_cifo/providers/config_preferences.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../background_entry.dart';
import '../main.dart' as main;
import '../styles/app_styles.dart';
import '../services/background_alarm_helper.dart';

//=======================================================================

class MainConfigScreen extends StatefulWidget {
  const MainConfigScreen({super.key});

  @override
  State<MainConfigScreen> createState() => _MainConfigScreenState();
}

class _MainConfigScreenState extends State<MainConfigScreen> {
  final int isolateId = Isolate.current.hashCode;
  TextEditingController controller = TextEditingController();

  Future<void> _fireAlarm() async {
    developer.log("Fire alarm", level: Level.INFO.value);
    final time = DateTime.now().add(Duration(seconds: 3));
    await BackgroundAlarmHelper.fireAlarm(
      time,
      BackgroundEntry.id,
      1,
      BackgroundEntry.callback,
      BackgroundEntry.snoozecallback,
    );
  }

  Future<void> _cancelAlarm() async {
    developer.log("Cancel alarm", level: Level.INFO.value);
    await BackgroundAlarmHelper.cancelAlarm(
      BackgroundEntry.id,
      BackgroundEntry.stopcallback,
    );
    await Future.delayed(const Duration(milliseconds: 7500), () async {
      developer.log("Pop screen", level: Level.INFO.value);
      await SystemNavigator.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConfigPreferences(),
      child: Scaffold(
          backgroundColor: AppStyles.colors.mantis,
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  developer.log('ISOLATE: ${main.mainIsolateName}, $isolateId',
                      level: Level.INFO.value);
                  developer.log("Fire alarm button clicked!",
                      level: Level.FINER.value);
                  await _fireAlarm();
                },
                child: const Text('Fire an alarm'),
              ),
            ),
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () async {
            //       developer.log(
            //           'ISOLATE: ${main.mainIsolateName}, $isolateId, '
            //           '${Isolate.current.debugName}',
            //           level: Level.INFO.value);
            //       developer.log("Program alarm button clicked!",
            //           level: Level.FINER.value);
            //       final time = DateTime.now().add(Duration(seconds: 30));
            //       BackgroundAlarmHelper.fireAlarm(
            //         time,
            //         BackgroundEntry.id,
            //         1,
            //         BackgroundEntry.callback,
            //         BackgroundEntry.snoozecallback,
            //       );
            //     },
            //     child: const Text('Program an alarm (30")'),
            //   ),
            // ),
            Center(
                child: ElevatedButton(
              onPressed: () async {
                developer.log("Cancel alarm button clicked!",
                    level: Level.FINER.value);
                await _cancelAlarm();
              },
              child: const Text('Cancel the alarm'),
            )),
            if (kDebugMode)
              Center(
                  child: ElevatedButton(
                onPressed: () async {
                  developer.log("End application button clicked!",
                      level: Level.FINER.value);
                  developer.log("Cancel alarm", level: Level.INFO.value);
                  await BackgroundAlarmHelper.cancelAlarm(
                    BackgroundEntry.id,
                    BackgroundEntry.stopcallback,
                  );
                  //FIXME - Application needs delay to finish gently, otherwise it restarts.
                  // END APPLICATION
                  // needs to be delayed to allow _cancelAlarm to start
                  // as _cancelAlarm is fired by AlarmManager
                  // the bug is the long delay needed
                  await Future.delayed(const Duration(milliseconds: 7500),
                      () async {
                    developer.log("Pop screen", level: Level.INFO.value);
                    await SystemNavigator.pop();
                    developer.log("Exit application", level: Level.INFO.value);
                    exit(0); // kDebugMode
                  });
                },
                child: Text('End the application'),
              )),
          ])
          // Text(AppLocalizations.of(context)!.helloWorld),
          ),
    );
  }

  // TODO: super.dispose només si no queden pantalles
  // @override
  // void dispose() {
  //   main.dispose();
  //   super.dispose();
  // }
}
