// logging and debugging
import 'dart:async';
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../styles/app_styles.dart';
import 'nat_number_text_field.dart';
import '../model/alarm_preferences.dart';
import '../providers/config_preferences.dart';

/// Alarm Preferences Editor
class AlarmPreferencesEditor extends StatefulWidget {
  /// Ctor
  const AlarmPreferencesEditor({super.key});

  @override
  State<AlarmPreferencesEditor> createState() => _AlarmPreferencesEditorState();
}

class _AlarmPreferencesEditorState extends State<AlarmPreferencesEditor> {
  late ValueNotifier<int?> _alarmDurationSeconds;
  late ValueNotifier<int?> _alarmSnoozeSeconds;
  late ValueNotifier<int?> _alarmRepeatTimes;
  late ValueNotifier<int?> _minutesToDealWithAlarm;
  late List<TextEditingController> _controllers;
  bool hasChanges = false;

  @override
  void initState() {
    _loadValues();
    // controllers; initial values != null
    _controllers = [
      TextEditingController.fromValue(
          TextEditingValue(text: _alarmDurationSeconds.value.toString())),
      TextEditingController.fromValue(
          TextEditingValue(text: _alarmSnoozeSeconds.value.toString())),
      TextEditingController.fromValue(
          TextEditingValue(text: _alarmRepeatTimes.value.toString())),
      TextEditingController.fromValue(
          TextEditingValue(text: _minutesToDealWithAlarm.value.toString())),
    ];
    super.initState();
  }

  // Convertir loadValues en funció ?
  (
    int alarmDurationSeconds,
    int alarmSnoozeSeconds,
    int alarmRepeatTimes,
    int minutesToDealWithAlarm
  ) initialValues(ConfigPreferences pref) {
    return (
      // Corregir aquest return que és de cartró
      _alarmDurationSeconds.value!,
      _alarmSnoozeSeconds.value!,
      _alarmRepeatTimes.value!,
      _minutesToDealWithAlarm.value!
    );
  }

  void _loadValues() {
    final pref = context.read<ConfigPreferences>();
    // actual value can be invalid,
    // because valid range in debug mode and release mode are different
    _alarmDurationSeconds = ValueNotifier<int?>(
        (pref.alarmSettings.data.alarmDurationSeconds >
                    AlarmPreferences.maxAlarmDurationSeconds ||
                pref.alarmSettings.data.alarmDurationSeconds <
                    AlarmPreferences.minAlarmDurationSeconds)
            ? AlarmPreferences.defaultAlarmDurationSeconds
            : pref.alarmSettings.data.alarmDurationSeconds);
    // actual value can be invalid,
    // because valid range in debug mode and release mode are different
    _alarmSnoozeSeconds = ValueNotifier<int?>(
        (pref.alarmSettings.data.alarmSnoozeSeconds >
                    AlarmPreferences.maxAlarmSnoozeSeconds ||
                pref.alarmSettings.data.alarmSnoozeSeconds <
                    AlarmPreferences.minAlarmSnoozeSeconds)
            ? AlarmPreferences.defaultAlarmSnoozeSeconds
            : pref.alarmSettings.data.alarmSnoozeSeconds);
    // actual value can be invalid,
    // because valid range in debug mode and release mode are different
    _alarmRepeatTimes = ValueNotifier<int?>(
        (pref.alarmSettings.data.alarmRepeatTimes >
                    AlarmPreferences.maxAlarmRepeatTimes ||
                pref.alarmSettings.data.alarmRepeatTimes <
                    AlarmPreferences.minAlarmRepeatTimes)
            ? AlarmPreferences.defaultAlarmRepeatTimes
            : pref.alarmSettings.data.alarmRepeatTimes);
    // actual value can be invalid,
    // because valid range in debug mode and release mode are different
    _minutesToDealWithAlarm = ValueNotifier<int?>(
        (pref.alarmSettings.data.minutesToDealWithAlarm >
                    AlarmPreferences.maxMinutesToDealWithAlarm ||
                pref.alarmSettings.data.minutesToDealWithAlarm <
                    AlarmPreferences.minMinutesToDealWithAlarm)
            ? AlarmPreferences.defaultMinutesToDealWithAlarm
            : pref.alarmSettings.data.minutesToDealWithAlarm);
  }

  bool get _isValid {
    if (_alarmDurationSeconds.value != null &&
        _alarmRepeatTimes.value != null &&
        _alarmSnoozeSeconds.value != null &&
        _minutesToDealWithAlarm.value != null) {
      return _alarmDurationSeconds.value! <=
              AlarmPreferences.maxAlarmDurationSeconds &&
          _alarmDurationSeconds.value! >=
              AlarmPreferences.minAlarmDurationSeconds &&
          _alarmSnoozeSeconds.value! <=
              AlarmPreferences.maxAlarmSnoozeSeconds &&
          _alarmSnoozeSeconds.value! >=
              AlarmPreferences.minAlarmSnoozeSeconds &&
          _alarmRepeatTimes.value! <= AlarmPreferences.maxAlarmRepeatTimes &&
          _alarmRepeatTimes.value! >= AlarmPreferences.minAlarmRepeatTimes &&
          _minutesToDealWithAlarm.value! <=
              AlarmPreferences.maxMinutesToDealWithAlarm &&
          _minutesToDealWithAlarm.value! >=
              AlarmPreferences.minMinutesToDealWithAlarm;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    bool hasPendingChanges() {
      final pref = context.read<ConfigPreferences>();
      return _alarmDurationSeconds.value !=
              pref.alarmSettings.data.alarmDurationSeconds ||
          _alarmSnoozeSeconds.value !=
              pref.alarmSettings.data.alarmSnoozeSeconds ||
          _alarmRepeatTimes.value != pref.alarmSettings.data.alarmRepeatTimes ||
          _minutesToDealWithAlarm.value !=
              pref.alarmSettings.data.minutesToDealWithAlarm;
    }

    Future<void> saveValues() async {
      final pref = context.read<ConfigPreferences>();
      FocusScope.of(context).unfocus();
      if (_isValid) {
        await pref.alarmSettings
            .setAlarmDurationSeconds(_alarmDurationSeconds.value!);
        await pref.alarmSettings
            .setAlarmSnoozeSeconds(_alarmSnoozeSeconds.value!);
        await pref.alarmSettings.setAlarmRepeatTimes(_alarmRepeatTimes.value!);
        await pref.alarmSettings
            .setMinutesToDealWithAlarm(_minutesToDealWithAlarm.value!);
        if (context.mounted) {
          developer.log("Show snackbar", level: Level.FINE.value);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t.saved),
            ),
          );
        }
        setState(() {
          hasChanges = false;
        });
      }
    }

    void undoChanges() {
      FocusScope.of(context).unfocus();
      _loadValues();
      _controllers[0].text = _alarmDurationSeconds.value.toString();
      _controllers[1].text = _alarmSnoozeSeconds.value.toString();
      _controllers[2].text = _alarmRepeatTimes.value.toString();
      _controllers[3].text = _minutesToDealWithAlarm.value.toString();
      setState(() {
        hasChanges = false;
      });
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 70, right: 70),
              child: NatNumberTextField(
                controller: _controllers[0],
                labelText: t.alarmDurationSeconds,
                tooltipHelp: t.tooltipAlarmDurationSeconds,
                iconColor: AppStyles.colors.ochre,
                suffixText: '"',
                minValue: AlarmPreferences.minAlarmDurationSeconds,
                maxValue: AlarmPreferences.maxAlarmDurationSeconds,
                errorText: 'invalid value: '
                    '${AlarmPreferences.minAlarmDurationSeconds}'
                    '..${AlarmPreferences.maxAlarmDurationSeconds}',
                onChanged: (int? value) {
                  setState(
                    () {
                      _alarmDurationSeconds.value = value;
                      hasChanges = hasPendingChanges();
                    },
                  );
                },
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 70, right: 70),
              child: NatNumberTextField(
                controller: _controllers[1],
                labelText: t.alarmSnoozeSeconds,
                suffixText: '"',
                minValue: AlarmPreferences.minAlarmSnoozeSeconds,
                maxValue: AlarmPreferences.maxAlarmSnoozeSeconds,
                errorText: 'invalid value: '
                    '${AlarmPreferences.minAlarmSnoozeSeconds}'
                    '..${AlarmPreferences.maxAlarmSnoozeSeconds}',
                onChanged: (int? value) {
                  setState(() {
                    _alarmSnoozeSeconds.value = value;
                    hasChanges = hasPendingChanges();
                  });
                },
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 70, right: 70),
              child: NatNumberTextField(
                controller: _controllers[2],
                labelText: t.alarmRepeatTimes,
                tooltipHelp: t.tooltipAlarmRepeatTimes,
                iconColor: AppStyles.colors.ochre,
                errorText: 'invalid value: '
                    '${AlarmPreferences.minAlarmRepeatTimes}'
                    '..${AlarmPreferences.maxAlarmRepeatTimes}',
                onChanged: (int? value) {
                  setState(() {
                    _alarmRepeatTimes.value = value;
                    hasChanges = hasPendingChanges();
                  });
                },
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 70, right: 70),
              child: NatNumberTextField(
                controller: _controllers[3],
                labelText: t.minutesToDealWithAlarm,
                suffixText: "'",
                tooltipHelp: t.tooltipMinutesToDealWithAlarm,
                iconColor: AppStyles.colors.ochre,
                errorText: 'invalid value: '
                    '${AlarmPreferences.minMinutesToDealWithAlarm}'
                    '..${AlarmPreferences.maxMinutesToDealWithAlarm}',
                onChanged: (int? value) {
                  setState(() {
                    _minutesToDealWithAlarm.value = value;
                    hasChanges = hasPendingChanges();
                  });
                },
              ),
            ),
          ),
          if (hasChanges)
            Padding(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: ValueListenableBuilder<bool>(
                        valueListenable: ValueNotifier<bool>(_isValid),
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return ElevatedButton(
                            style: AppStyles.customButtonStyle,
                            onPressed: () async {
                              developer.log("Undo settings button clicked!",
                                  level: Level.FINER.value);
                              undoChanges();
                            },
                            child: Text(t.undoChanges),
                          );
                        }),
                  ),
                  Center(
                    child: ValueListenableBuilder<bool>(
                        valueListenable: ValueNotifier<bool>(_isValid),
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return ElevatedButton(
                            style: AppStyles.customButtonStyle,
                            onPressed: _isValid
                                ? () async {
                                    developer.log(
                                        "Save settings button clicked! "
                                        "$_isValid",
                                        level: Level.FINER.value);
                                    await saveValues();
                                  }
                                : null,
                            child: Text(t.saveChanges),
                          );
                        }),
                  ),
                ],
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
