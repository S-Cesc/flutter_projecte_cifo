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

class AlarmList extends StatefulWidget {
  final List<Alarm> alarms;
  final Future<bool> Function() addNewAlarm;
  final Future<bool> Function(int alarmId) deleteAlarm;
  final Future<void> Function() restoreAlarms;
  final Future<void> Function() saveAlarms;

  const AlarmList({
    super.key,
    required this.alarms,
    required this.addNewAlarm,
    required this.deleteAlarm,
    required this.restoreAlarms,
    required this.saveAlarms,
  });

  @override
  State<AlarmList> createState() => AlarmListState();
}

class AlarmListState extends State<AlarmList> {
  late AppLocalizations _localizations;
  bool _isInitialized = false;

  void _initializeLocale(BuildContext context) async {
    _localizations = //await AppLocalizations.of(context);
        await AppLocalizations.delegate.load(Localizations.localeOf(context));
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) _initializeLocale(context);
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: widget.alarms.length,
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
                          widget.alarms[index].name(_localizations),
                          style: AppStyles.fonts.labelSmall(),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            final result = await widget
                                .deleteAlarm(widget.alarms[index].id);
                            if (result) {
                              setState(() {
                                widget.alarms;
                              });
                            }
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
                          await widget.restoreAlarms();
                          setState(() {
                            widget.alarms;
                          });
                        },
                        child: Text(_localizations.undoChanges),
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
                          await widget.saveAlarms();
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(_localizations.saveChanges),
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
