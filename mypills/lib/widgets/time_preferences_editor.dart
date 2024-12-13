// logging and debugging
//import 'dart:developer' as developer;
//import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../styles/app_styles.dart';
import '../model/alarm_preferences.dart';
import '../providers/edit_providers/edit_provider_time_preferences.dart';
import 'nat_number_text_field.dart';

/// Time preference editor for mealtime tablets
class TimePreferencesEditor extends StatefulWidget {
  final EditProviderTimePreferences _provider;

  /// Ctor
  const TimePreferencesEditor(
      {super.key, required EditProviderTimePreferences provider})
      : _provider = provider;

  @override
  State<TimePreferencesEditor> createState() => _TimePreferencesEditorState();
}

class _TimePreferencesEditorState extends State<TimePreferencesEditor> {
  late List<TextEditingController> _controllers;
  bool saved = true;

  @override
  void initState() {
    _controllers = [
      TextEditingController.fromValue(TextEditingValue(
          text: widget._provider.minutesLongBeforeMeals.toString())),
      TextEditingController.fromValue(TextEditingValue(
          text: widget._provider.minutesBeforeMeals.toString())),
      TextEditingController.fromValue(TextEditingValue(
          text: widget._provider.minutesAfterMeals.toString())),
      TextEditingController.fromValue(TextEditingValue(
          text: widget._provider.minutesLongAfterMeals.toString())),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 50, right: 50),
              child: ValueListenableBuilder(
                valueListenable: _controllers[0],
                builder: (context, TextEditingValue value, __) {
                  return NatNumberTextField(
                    controller: _controllers[0],
                    labelText: t.minutesLongBefore,
                    tooltipHelp: t.tooltipLongBefore,
                    iconColor: AppStyles.colors.ochre,
                    suffixText: "'",
                    minValue: AlarmPreferences.minMinutesLongAfterBefore,
                    maxValue: AlarmPreferences.maxMinutesLongAfterBefore,
                    errorText: 'invalid value: '
                        '${AlarmPreferences.minMinutesLongAfterBefore}'
                        '..${AlarmPreferences.maxMinutesLongAfterBefore}',
                    onChanged: (int? value) {
                          widget._provider.minutesLongBeforeMeals = value;
                    },
                  );
                }
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 50, right: 50),
              child: ValueListenableBuilder(
                valueListenable: _controllers[1],
                builder: (context, TextEditingValue value, __) {
                  return NatNumberTextField(
                    controller: _controllers[1],
                    labelText: t.minutesBefore,
                    tooltipHelp: t.tooltipBefore,
                    iconColor: AppStyles.colors.ochre,
                    suffixText: "'",
                    minValue: AlarmPreferences.minMinutesAfterBefore,
                    maxValue: AlarmPreferences.maxMinutesAfterBefore,
                    errorText: 'invalid value: '
                        '${AlarmPreferences.minMinutesAfterBefore}'
                        '..${AlarmPreferences.maxMinutesAfterBefore}',
                    onChanged: (int? value) {
                        widget._provider.minutesBeforeMeals = value;
                    },
                  );
                }
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 50, right: 50),
              child: ValueListenableBuilder(
                valueListenable: _controllers[2],
                builder: (context, TextEditingValue value, __) {
                  return NatNumberTextField(
                    controller: _controllers[2],
                    labelText: t.minutesAfter,
                    tooltipHelp: t.tooltipAfter,
                    iconColor: AppStyles.colors.ochre,
                    suffixText: "'",
                    errorText: 'invalid value: '
                        '${AlarmPreferences.minMinutesAfterBefore}'
                        '..${AlarmPreferences.maxMinutesAfterBefore}',
                    onChanged: (int? value) {
                        widget._provider.minutesAfterMeals = value;
                    },
                  );
                }
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 50, right: 50),
              child: ValueListenableBuilder(
                valueListenable: _controllers[3],
                builder: (context, TextEditingValue value, __) {
                  return NatNumberTextField(
                    controller: _controllers[3],
                    labelText: t.minutesLongAfter,
                    tooltipHelp: t.tooltipLongAfter,
                    iconColor: AppStyles.colors.ochre,
                    suffixText: "'",
                    errorText: 'invalid value: '
                        '${AlarmPreferences.minMinutesLongAfterBefore}'
                        '..${AlarmPreferences.maxMinutesLongAfterBefore}',
                    onChanged: (int? value) {
                        widget._provider.minutesLongAfterMeals = value;
                    },
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    for (int i = 0; i < 4; i++) {
      _controllers[i].dispose();
    }
    super.dispose();
  }
}
