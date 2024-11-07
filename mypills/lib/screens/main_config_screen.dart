// logging and debugging
import 'dart:async';
import 'dart:developer' as developer;
import 'dart:isolate';
import 'package:flutter_projecte_cifo/providers/preferences.dart';
import 'package:logging/logging.dart' show Level;
// // Dart base
// Flutter
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../background_entry.dart';
import '../main.dart' as main;

class MainConfigScreen extends StatefulWidget {
  const MainConfigScreen({super.key});

  @override
  State<MainConfigScreen> createState() => _MainConfigScreenState();
}

class _MainConfigScreenState extends State<MainConfigScreen> {
  final int isolateId = Isolate.current.hashCode;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    unawaited(main.listenAlarmPort(context));
    return ChangeNotifierProvider(
      create: (context) => Preferences(),
      child: Scaffold(
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: ElevatedButton(
            onPressed: () async {
              developer.log('ISOLATE: ${main.mainIsolateName}, $isolateId',
                  level: Level.INFO.value);
              developer.log("Fire alarm button clicked!",
                  level: Level.FINER.value);
              final time = DateTime.now().add(Duration(seconds: 5));
              await AndroidAlarmManager.oneShotAt(
                time,
                BackgroundEntry.id,
                BackgroundEntry.callback,
                // alarmClock: true,
                allowWhileIdle: true,
                exact: true,
                wakeup: true,
                rescheduleOnReboot: true,
              );
            },
            child: const Text('Fire an alarm'),
          ),
        ),
        Center(
            child: ElevatedButton(
          onPressed: () async {
            developer.log("Cancel alarm button clicked!",
                level: Level.FINER.value);
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
          },
          child: const Text('Cancel the alarm'),
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
