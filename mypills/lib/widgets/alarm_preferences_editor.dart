// logging and debugging
// import 'dart:developer' as developer;
// import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
// Localization
import '../l10n/app_localizations.dart';
// Project files
import '../styles/app_styles.dart';
import '../model/general_preferences.dart';
import '../providers/edit_providers/edit_provider_alarm_preferences.dart';
import 'nat_number_field.dart';

/// Alarm Preferences Editor
class AlarmPreferencesEditor extends StatefulWidget {
  final EditProviderAlarmPreferences _provider;

  /// Ctor
  const AlarmPreferencesEditor({
    super.key,
    required EditProviderAlarmPreferences provider,
  }) : _provider = provider;

  @override
  State<AlarmPreferencesEditor> createState() => _AlarmPreferencesEditorState();
}

class _AlarmPreferencesEditorState extends State<AlarmPreferencesEditor> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    _controllers = [
      TextEditingController.fromValue(
        TextEditingValue(
          text: widget._provider.alarmDurationSeconds.toString(),
        ),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.alarmSnoozeSeconds.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.alarmRepeatTimes.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(
          text: widget._provider.minutesToDealWithAlarm.toString(),
        ),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

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
                    labelText: t.alarmDurationSeconds,
                    tooltipHelp: t.tooltipAlarmDurationSeconds,
                    iconColor: AppStyles.colors.ochre,
                    suffixText: '"',
                    minValue: GeneralPreferences.minAlarmDurationSeconds,
                    maxValue: GeneralPreferences.maxAlarmDurationSeconds,
                    errorText:
                        'invalid value: '
                        '${GeneralPreferences.minAlarmDurationSeconds}'
                        '..${GeneralPreferences.maxAlarmDurationSeconds}',
                    onChanged: (int? value) {
                      widget._provider.alarmDurationSeconds = value;
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
                    labelText: t.alarmSnoozeSeconds,
                    tooltipHelp: t.tooltipSnoozeSeconds,
                    iconColor: AppStyles.colors.ochre,
                    suffixText: '"',
                    minValue: GeneralPreferences.minAlarmSnoozeSeconds,
                    maxValue: GeneralPreferences.maxAlarmSnoozeSeconds,
                    errorText:
                        'invalid value: '
                        '${GeneralPreferences.minAlarmSnoozeSeconds}'
                        '..${GeneralPreferences.maxAlarmSnoozeSeconds}',
                    onChanged: (int? value) {
                      widget._provider.alarmSnoozeSeconds = value;
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
                    labelText: t.alarmRepeatTimes,
                    tooltipHelp: t.tooltipAlarmRepeatTimes,
                    iconColor: AppStyles.colors.ochre,
                    minValue: GeneralPreferences.minAlarmRepeatTimes,
                    maxValue: GeneralPreferences.maxAlarmRepeatTimes,
                    errorText:
                        'invalid value: '
                        '${GeneralPreferences.minAlarmRepeatTimes}'
                        '..${GeneralPreferences.maxAlarmRepeatTimes}',
                    onChanged: (int? value) {
                      widget._provider.alarmRepeatTimes = value;
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
                    labelText: t.minutesToDealWithAlarm,
                    suffixText: "'",
                    tooltipHelp: t.tooltipMinutesToDealWithAlarm,
                    iconColor: AppStyles.colors.ochre,
                    minValue: GeneralPreferences.minMinutesToDealWithAlarm,
                    maxValue: GeneralPreferences.maxMinutesToDealWithAlarm,
                    errorText:
                        'invalid value: '
                        '${GeneralPreferences.minMinutesToDealWithAlarm}'
                        '..${GeneralPreferences.maxMinutesToDealWithAlarm}',
                    onChanged: (int? value) {
                      widget._provider.minutesToDealWithAlarm = value;
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
