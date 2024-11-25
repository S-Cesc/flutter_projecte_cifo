// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../styles/app_styles.dart';
import '../model/alarm.dart';

class AlarmList extends StatelessWidget {
  final List<Alarm> alarms;
  final Future<void> Function(int alarmId) deleteAlarm;
  final Future<void> Function() restoreAlarms;
  final Future<void> Function() saveAlarms;

  const AlarmList({
    super.key,
    required this.alarms,
    required this.deleteAlarm,
    required this.restoreAlarms,
    required this.saveAlarms,
  });

  @override
  Widget build(BuildContext context) {

    var t = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                // the list item - product
                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppStyles.colors.ochre),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          alarms[index].name(t),
                          style: AppStyles.fonts.labelSmall(),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            await deleteAlarm(alarms[index].id);
                          },
                          icon: Icon(Icons.delete)),
                    ],
                  ),
                );
              },
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsetsDirectional.only(bottom: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: Center(
                      child: ElevatedButton(
                        style: AppStyles.customButtonStyle,
                        onPressed: () async {
                          developer.log("Restore alarms button clicked! ",
                              level: Level.FINER.value);
                          await restoreAlarms();
                        },
                        child: Text(t.undoChanges),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: Center(
                      child: ElevatedButton(
                        style: AppStyles.customButtonStyle,
                        onPressed: () async {
                          developer.log("Save alarms button clicked! ",
                              level: Level.FINER.value);
                          await saveAlarms();
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(t.saveChanges),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
