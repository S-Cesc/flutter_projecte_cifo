// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// // Dart base
// Flutter
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../background_entry.dart';
// // Project files

class MainConfigScreen extends StatefulWidget {
  const MainConfigScreen({super.key});

  @override
  State<MainConfigScreen> createState() => _MainConfigScreenState();
}

class _MainConfigScreenState extends State<MainConfigScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                  Center(
          child: ElevatedButton(
            onPressed: () async {
              developer.log("Fire alarm button clicked!",
                  level: Level.CONFIG.value);
              final time = DateTime.now().add(Duration(seconds: 15));
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
                level: Level.CONFIG.value);
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
}
