// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
// Fitxers del projecte
import '../model/alarm.dart';
import '../providers/config_preferences.dart';
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
    _refreshFrom(pref.alarms.currentAlarms);
    developer.log("List screen initial alarms: ${_lstAlarms.length}");
  }

  void _refreshFrom(Iterable<Alarm> sourceAlarms) {
    _lstAlarms.clear();
    for (final alarm in sourceAlarms) {
      _lstAlarms.add(alarm);
    }
    _lstAlarms.sort((x, y) => x.id.compareTo(y.id));
    setState(() {
      _lstAlarms;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> openDialogAddItem() async {
      Alarm? newAlarm =
          await Navigator.of(context).push(MaterialPageRoute<Alarm>(
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

    Future<void> deleteAlarm(int alarmId) async {
      if (await confirm(
            context,
            title: const Text('Confirm'),
            content: const Text('Would you like to remove?'),
            textOK: const Text('Yes'),
            textCancel: const Text('No'),            
          ) &&
          context.mounted) {
        setState(() {
          _lstAlarms.removeWhere((x) => x.id == alarmId);
        });
      }
    }

    Future<void> restoreAlarms() async {
      final pref = context.read<ConfigPreferences>();
      _refreshFrom(pref.alarms.currentAlarms);
    }

    Future<void> saveAlarms() async {
      final pref = context.read<ConfigPreferences>();
      developer.log("Save alarms: total ${_lstAlarms.length} alarms",
          level: Level.INFO.value);
      await pref.alarms.setCurrentAlarms(_lstAlarms);
      // ensure copy integrity (reload data from persistent)
      setState(() {
        _refreshFrom(pref.alarms.currentAlarms);
      });
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
                await openDialogAddItem();
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
