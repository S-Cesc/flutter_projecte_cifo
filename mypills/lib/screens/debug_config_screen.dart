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
import 'package:flutter_projecte_cifo/providers/config_preferences.dart';
import 'package:flutter_projecte_cifo/widgets/meals_table.dart';
import 'package:provider/provider.dart';
// Project files
import '../styles/app_styles.dart';
import '../main.dart' as main;
import './main_config_screen.dart' show isolateId;
import '../model/alarm.dart';
import '../model/meal.dart';
import '../model/pill_meal_time.dart';
import '../services/background_alarm_helper.dart';
import '../background_entry.dart';

class DebugConfigScreen extends StatefulWidget {
  final ConfigPreferences pref;
  const DebugConfigScreen({super.key, required this.pref});

  @override
  State<DebugConfigScreen> createState() => _DebugConfigScreenState();
}

class _DebugConfigScreenState extends State<DebugConfigScreen> {
  //late WeeklyTimeTable wtt;
  Alarm alarm = Alarm.empty(Meal.breakfast, PillMealTime.longBefore);
  final int isolateId = Isolate.current.hashCode;

  @override
  void initState() {
    super.initState();
    //wtt = pref.alarmSettings.wtt;
    // wtt.defineMealTime(Meal.breakfast, TimeOfDay(hour: 7, minute: 30));
    // wtt.defineMealTime(Meal.brunch, TimeOfDay(hour: 12, minute: 30));
    // wtt.defineMealTime(Meal.tea, TimeOfDay(hour: 16, minute: 00));
    // wtt.defineMealTime(Meal.dinner, TimeOfDay(hour: 20, minute: 30));
    // SAVE
    // unawaited(pref.alarmSettings.setWeeklyTimeTable(wtt));
    //unawaited(pref.alarms.setAlarm(alarm));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => widget.pref,
      child: Scaffold(
        backgroundColor: AppStyles.colors.mantis,
        appBar: AppBar(
          backgroundColor: AppStyles.colors.ochre[700],
          title: Center(
            child: Text(
              "Pantalla de proves",
              style: AppStyles.fonts.display(),
            ),
          ),
          elevation: 4,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 70),
              child: MealsTable(saveValues: (wtt) async {
                await widget.pref.alarmSettings.setWeeklyTimeTable(wtt);
                if (context.mounted) Navigator.pop(context);
              }),
            ),
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
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  developer.log("Cancel alarm button clicked!",
                      level: Level.FINER.value);
                  await _cancelAlarm();
                },
                child: const Text('Cancel the alarm'),
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
                      BackgroundEntry.idTstAlarm,
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
                      developer.log("Exit application",
                          level: Level.INFO.value);
                      exit(0); // kDebugMode
                    });
                  },
                  child: Text('End the application'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _fireAlarm() async {
    developer.log("Fire alarm", level: Level.INFO.value);
    final time = DateTime.now().add(Duration(seconds: 3));
    await BackgroundAlarmHelper.fireAlarm(
      time,
      BackgroundEntry.idTstAlarm,
      1,
      BackgroundEntry.callback,
      BackgroundEntry.snoozecallback,
    );
  }

  Future<void> _cancelAlarm() async {
    developer.log("Cancel alarm", level: Level.INFO.value);
    await BackgroundAlarmHelper.cancelAlarm(
      BackgroundEntry.idTstAlarm,
      BackgroundEntry.stopcallback,
    );
    await Future.delayed(const Duration(milliseconds: 7500), () async {
      developer.log("Pop screen", level: Level.INFO.value);
      await SystemNavigator.pop();
    });
  }
}
