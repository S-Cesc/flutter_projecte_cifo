// logging and debugging
//import 'dart:developer' as developer;
//import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
// Localization
import '../l10n/app_localizations.dart';
// Project files
import '../styles/app_styles.dart';
import '../model/general_preferences.dart';
import '../providers/edit_providers/edit_provider_time_preferences.dart';
import 'nat_number_field.dart';

/// Time preference editor for mealtime tablets
class TimePreferencesEditor extends StatefulWidget {
  final EditProviderTimePreferences _provider;

  /// Ctor
  const TimePreferencesEditor({
    super.key,
    required EditProviderTimePreferences provider,
  }) : _provider = provider;

  @override
  State<TimePreferencesEditor> createState() => _TimePreferencesEditorState();
}

class _TimePreferencesEditorState extends State<TimePreferencesEditor> {
  late final List<TextEditingController> _controllers;
  bool saved = true;

  @override
  void initState() {
    _controllers = [
      TextEditingController.fromValue(
        TextEditingValue(
          text: widget._provider.minutesLongBeforeMeals.toString(),
        ),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.minutesBeforeMeals.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.minutesAfterMeals.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(
          text: widget._provider.minutesLongAfterMeals.toString(),
        ),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        children: [
          SizedBox(
            height: 70,
            width: 400,
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 50, right: 50),
              child: ValueListenableBuilder(
                valueListenable: _controllers[0],
                builder: (context, TextEditingValue value, __) {
                  return NatNumberField(
                    controller: _controllers[0],
                    labelText: t.minutesLongBefore,
                    tooltipHelp: t.tooltipLongBefore,
                    iconColor: AppStyles.colors.ochre,
                    suffixText: "'",
                    minValue: GeneralPreferences.minMinutesLongAfterBefore,
                    maxValue: GeneralPreferences.maxMinutesLongAfterBefore,
                    errorText:
                        'invalid value: '
                        '${GeneralPreferences.minMinutesLongAfterBefore}'
                        '..${GeneralPreferences.maxMinutesLongAfterBefore}',
                    onChanged: (int? value) {
                      widget._provider.minutesLongBeforeMeals = value;
                    },
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 70,
            width: 400,
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 50, right: 50),
              child: ValueListenableBuilder(
                valueListenable: _controllers[1],
                builder: (context, TextEditingValue value, __) {
                  return NatNumberField(
                    controller: _controllers[1],
                    labelText: t.minutesBefore,
                    tooltipHelp: t.tooltipBefore,
                    iconColor: AppStyles.colors.ochre,
                    suffixText: "'",
                    minValue: GeneralPreferences.minMinutesAfterBefore,
                    maxValue: GeneralPreferences.maxMinutesAfterBefore,
                    errorText:
                        'invalid value: '
                        '${GeneralPreferences.minMinutesAfterBefore}'
                        '..${GeneralPreferences.maxMinutesAfterBefore}',
                    onChanged: (int? value) {
                      widget._provider.minutesBeforeMeals = value;
                    },
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 70,
            width: 400,
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 50, right: 50),
              child: ValueListenableBuilder(
                valueListenable: _controllers[2],
                builder: (context, TextEditingValue value, __) {
                  return NatNumberField(
                    controller: _controllers[2],
                    labelText: t.minutesAfter,
                    tooltipHelp: t.tooltipAfter,
                    iconColor: AppStyles.colors.ochre,
                    suffixText: "'",
                    minValue: GeneralPreferences.minMinutesAfterBefore,
                    maxValue: GeneralPreferences.maxMinutesAfterBefore,
                    errorText:
                        'invalid value: '
                        '${GeneralPreferences.minMinutesAfterBefore}'
                        '..${GeneralPreferences.maxMinutesAfterBefore}',
                    onChanged: (int? value) {
                      widget._provider.minutesAfterMeals = value;
                    },
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 70,
            width: 400,
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 50, right: 50),
              child: ValueListenableBuilder(
                valueListenable: _controllers[3],
                builder: (context, TextEditingValue value, __) {
                  return NatNumberField(
                    controller: _controllers[3],
                    labelText: t.minutesLongAfter,
                    tooltipHelp: t.tooltipLongAfter,
                    iconColor: AppStyles.colors.ochre,
                    suffixText: "'",
                    minValue: GeneralPreferences.minMinutesLongAfterBefore,
                    maxValue: GeneralPreferences.maxMinutesLongAfterBefore,
                    errorText:
                        'invalid value: '
                        '${GeneralPreferences.minMinutesLongAfterBefore}'
                        '..${GeneralPreferences.maxMinutesLongAfterBefore}',
                    onChanged: (int? value) {
                      widget._provider.minutesLongAfterMeals = value;
                    },
                  );
                },
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
