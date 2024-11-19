// logging and debugging
import 'dart:developer' as developer;
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:async';
import 'dart:io' show exit;
// Flutter
import 'package:flutter/material.dart';
// Project files
import '../styles/app_styles.dart';
import '../main.dart' as main;
import '../model/alarm.dart';
import '../model/meal.dart';
import '../model/pill_meal_time.dart';
import '../services/background_alarm_helper.dart';
import '../background_entry.dart';

class DebugConfigScreen extends StatefulWidget {
  const DebugConfigScreen({super.key});

  @override
  State<DebugConfigScreen> createState() => _DebugConfigScreenState();
}

class _DebugConfigScreenState extends State<DebugConfigScreen> {
  Alarm alarm = Alarm.empty(Meal.breakfast, PillMealTime.longBefore);
  final int isolateId = Isolate.current.hashCode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.colors.mantis,
      appBar: AppBar(
        backgroundColor: AppStyles.colors.ochre[700],
        title: Center(
          child: Text(
            "proves",
            style: AppStyles.fonts.display(),
          ),
        ),
        elevation: 4,
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 60)),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                developer.log('ISOLATE: ${main.mainIsolateName}, $isolateId',
                    level: Level.INFO.value);
                developer.log("Fire alarm button clicked!",
                    level: Level.FINER.value);
                await _fireAlarm(BackgroundEntry.idAlarmTest);
              },
              child: const Text('Fire an alarm'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                developer.log("Cancel alarm button clicked!",
                    level: Level.FINER.value);
                await _cancelAlarm(BackgroundEntry.idAlarmTest);
              },
              child: const Text('Cancel the alarm'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                developer.log("Back button clicked!", level: Level.FINER.value);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
          ),
          if (kDebugMode)
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  developer.log("End application button clicked!",
                      level: Level.FINER.value);
                  developer.log("Cancel alarm", level: Level.INFO.value);
                  await BackgroundAlarmHelper.cancelAlarm(
                    BackgroundEntry.idAlarmTest,
                    BackgroundEntry.stopcallback,
                  );
                  await Future.delayed(const Duration(milliseconds: 5),
                      () async {
                    developer.log("Pop screen", level: Level.INFO.value);
                    await SystemNavigator.pop();
                    developer.log("Exit application", level: Level.INFO.value);
                    exit(0); // kDebugMode
                  });
                },
                child: Text('End the application'),
              ),
            ),
          Padding(padding: EdgeInsets.only(bottom: 40))
        ],
      ),
    );
  }

  Future<void> _fireAlarm(int alarmId) async {
    developer.log("Fire alarm", level: Level.INFO.value);
    final time = DateTime.now().add(Duration(seconds: 3));
    await BackgroundAlarmHelper.fireAlarm(
      time,
      alarmId,
      20,
      BackgroundEntry.callback,
      BackgroundEntry.autoSnoozeCallback,
    );
  }

  Future<void> _cancelAlarm(int alarmId) async {
    developer.log("Cancel alarm", level: Level.INFO.value);
    await BackgroundAlarmHelper.cancelAlarm(
      alarmId,
      BackgroundEntry.stopcallback,
    );
    await Future.delayed(const Duration(milliseconds: 7500), () async {
      developer.log("Pop screen", level: Level.INFO.value);
      await SystemNavigator.pop();
    });
  }
}
