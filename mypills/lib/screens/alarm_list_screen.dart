// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
// Fitxers del projecte
import '../background_entry.dart';
import '../extensions/date_time_extensions.dart';
import '../model/alarm.dart';
import '../model/enums.dart';
import '../providers/config_preferences.dart';
import '../services/background_alarm_helper.dart';
import '../styles/app_styles.dart';
import '../widgets/alarm_list.dart';
import 'dialog_add_alarm.dart';

class AlarmListScreen extends StatefulWidget {
  const AlarmListScreen({super.key});

  @override
  State<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends State<AlarmListScreen> {
  final List<Alarm> _lstAlarms = <Alarm>[];

  @override
  void initState() {
    super.initState();
    final pref = context.read<ConfigPreferences>();
    developer.log(
        "ConfigPreferences currentAlarms: ${pref.alarms.currentAlarms.toList()}");
    _refreshFrom(pref.alarms.currentAlarms);
    developer.log("List screen initial alarms: ${_lstAlarms.length}");
  }

  void _refreshFrom(Iterable<Alarm> sourceAlarms) {
    _lstAlarms.clear();
    for (final alarm in sourceAlarms) {
      _lstAlarms.add(alarm);
    }
    _lstAlarms.sort((x, y) => x.id.compareTo(y.id));
  }

  Future<bool> _openDialogAddItem() async {
    Alarm? newAlarm = await Navigator.of(context).push(MaterialPageRoute<Alarm>(
        builder: (BuildContext context) {
          return DialogAddAlarm();
        },
        fullscreenDialog: true));
    developer.log("S'ha retornat una nova alarma per afegir: $newAlarm",
        level: Level.INFO.value);
    if (newAlarm != null && !_lstAlarms.any((x) => x.id == newAlarm.id)) {
      setState(() {
        _lstAlarms.add(newAlarm);
        _lstAlarms.sort((x, y) => x.id.compareTo(y.id));
      });
      return true;
    } else {
      return false;
    }
  }

  Future<void> _addFireAlarmProgramming(int alarmId) async {
    final pref = context.read<ConfigPreferences>();
    Alarm? alarm = pref.alarms.getAlarm(alarmId);
    if (alarm != null) {
      // alarm.meal alarm.pillMealTime
      final today = DateTimeExtensions.today();
      DateTime? dateTimeToFire;
      TimeOfDay? mealTime = pref.alarmSettings.wtt
          .dayMealTime(alarm.meal, DayOfWeek.fromDate(today));
      if (mealTime != null) {
        if (DateTimeExtensions.isToday(mealTime)) {
          dateTimeToFire = DateTimeExtensions.todayAt(mealTime);
        } else {
          // Hoy no... mañana
          final tomorrow = DateTimeExtensions.tomorrow();
          mealTime = pref.alarmSettings.wtt
              .dayMealTime(alarm.meal, DayOfWeek.fromDate(tomorrow));
          if (mealTime != null) {
            dateTimeToFire = DateTimeExtensions.tomorrowAt(mealTime);
          }
        }
        if (dateTimeToFire != null) {
          developer.log("Fire of alarm $alarmId programmed at $dateTimeToFire");
          await BackgroundAlarmHelper.fireAlarm(
            dateTimeToFire,
            alarmId,
            pref.alarmSettings.data.alarmDurationSeconds,
            BackgroundEntry.callback,
            BackgroundEntry.autoSnoozeCallback,
          );
        }
      }
      developer.log(mealTime == null ? "No meal time" : "meal time: $mealTime");
    }
  }

  Future<void> _removeFireAlarmProgramming(int alarmId) async {
    developer.log("User requires cancel the alarm $alarmId (reprogramming)");
    await BackgroundAlarmHelper.cancelAlarm(alarmId);
  }

  @override
  Widget build(BuildContext context) {
    Future<void> restoreAlarms() async {
      final pref = context.read<ConfigPreferences>();
      _refreshFrom(pref.alarms.currentAlarms);
    }

    Future<void> saveAlarms() async {
      final pref = context.read<ConfigPreferences>();
      developer.log("Save alarms: total ${_lstAlarms.length} alarms",
          level: Level.INFO.value);
      List<int> inserted, deleted;
      // TODO: Program / Desprogram alarms (use background_alarm_helper)
      (inserted, deleted) = pref.alarms.setCurrentAlarms(_lstAlarms,
          insertCallback: _addFireAlarmProgramming,
          removeCallback: _removeFireAlarmProgramming);
      // ensure copy integrity (reload data from persistent)
      developer.log(
          "Observed ${inserted.length} inserts, ${deleted.length} removes");
      _refreshFrom(pref.alarms.currentAlarms);
    }

    Future<bool> deleteAlarm(int alarmId) async {
      if (await confirm(
            context,
            title: const Text('Confirm'),
            content: const Text('Would you like to remove?'),
            textOK: const Text('Yes'),
            textCancel: const Text('No'),
          ) &&
          context.mounted) {
        final pref = context.read<ConfigPreferences>();
        final bool result = await pref.alarms.removeAlarm(alarmId);
        _refreshFrom(pref.alarms.currentAlarms);
        return result;
      } else {
        return false;
      }
    }

    return Scaffold(
      backgroundColor: AppStyles.colors.mantis,
      appBar: AppBar(
          title: Text("Llista d'alarmes"),
          backgroundColor: AppStyles.colors.ochre[700],
          elevation: 4,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppStyles.colors.forestGreen,
            ),
            onPressed: () {
              // Navigate back to the previous screen by popping the current route
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                developer.log("Add alarm button clicked! ",
                    level: Level.FINER.value);
                await _openDialogAddItem();
              },
              style: ButtonStyle(
                shape: WidgetStateProperty.all<CircleBorder>(
                  CircleBorder(
                    side: BorderSide(
                      color: AppStyles.colors.forestGreen[700]!,
                      width: 1.0,
                    ),
                  ),
                ),
                backgroundColor:
                    WidgetStateProperty.all(AppStyles.colors.forestGreen),
                foregroundColor:
                    WidgetStateProperty.all(AppStyles.colors.darkSlateGray),
              ),
              child: const Icon(Icons.add_alarm), // Text('ADD'),
            ),
          ]),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: AlarmList(
          alarms: _lstAlarms,
          addNewAlarm: _openDialogAddItem,
          deleteAlarm: deleteAlarm,
          restoreAlarms: restoreAlarms,
          saveAlarms: saveAlarms,
        ),
        // insertAlarmCallback: _addFireAlarmProgramming,
        // removeAlarmCallback: _removeFireAlarmProgramming,
      ),
    );
  }
}
