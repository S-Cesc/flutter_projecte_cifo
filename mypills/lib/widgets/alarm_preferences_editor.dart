// logging and debugging
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_projecte_cifo/model/alarm_preferences.dart';
import 'package:flutter_projecte_cifo/providers/alarm_settings.dart';
import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show FilteringTextInputFormatter, TextInputFormatter;
import 'package:provider/provider.dart';
// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../providers/config_preferences.dart';
import '../styles/app_styles.dart';

class AlarmPreferencesEditor extends StatefulWidget {
  const AlarmPreferencesEditor({super.key});

  @override
  State<AlarmPreferencesEditor> createState() => _AlarmPreferencesEditorState();
}

class _AlarmPreferencesEditorState extends State<AlarmPreferencesEditor> {
  late ValueNotifier<int?> _alarmDurationSeconds;
  late ValueNotifier<int?> _alarmSnoozeSeconds;
  late ValueNotifier<int?> _alarmRepeatTimes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    final pref = context.read<ConfigPreferences>();
    _alarmDurationSeconds =
        ValueNotifier<int?>(pref.alarmSettings.data.alarmDurationSeconds);
    _alarmSnoozeSeconds =
        ValueNotifier<int?>(pref.alarmSettings.data.alarmSnoozeSeconds);
    _alarmRepeatTimes =
        ValueNotifier<int?>(pref.alarmSettings.data.alarmRepeatTimes);
    _controllers = [
      TextEditingController.fromValue(
          TextEditingValue(text: _alarmDurationSeconds.value.toString())),
      TextEditingController.fromValue(
          TextEditingValue(text: _alarmSnoozeSeconds.value.toString())),
      TextEditingController.fromValue(
          TextEditingValue(text: _alarmRepeatTimes.value.toString())),
    ];
    super.initState();
  }

  bool _validAlarmDurationSeconds() {
    if (_alarmDurationSeconds.value != null) {
      final pref = context.read<ConfigPreferences>();
      return pref.alarmSettings
          .isAlarmDurationSecondsInRange(_alarmDurationSeconds.value!);
    } else {
      return false;
    }
  }

  bool _validAlarmSnoozeSeconds() {
    if (_alarmSnoozeSeconds.value != null) {
      final pref = context.read<ConfigPreferences>();
      return pref.alarmSettings
          .isAlarmSnoozeSecondsInRange(_alarmSnoozeSeconds.value!);
    } else {
      return false;
    }
  }

  bool _validAlarmRepeatTimes() {
    if (_alarmRepeatTimes.value != null) {
      final pref = context.read<ConfigPreferences>();
      return pref.alarmSettings
          .isAlarmRepeatTimesInRange(_alarmRepeatTimes.value!);
    } else {
      return false;
    }
  }

  bool get _isValid {
    if (_alarmDurationSeconds.value != null &&
        _alarmRepeatTimes.value != null &&
        _alarmSnoozeSeconds.value != null) {
      final pref = context.read<ConfigPreferences>();
      return pref.alarmSettings
              .isAlarmDurationSecondsInRange(_alarmDurationSeconds.value!) &&
          pref.alarmSettings
              .isAlarmSnoozeSecondsInRange(_alarmSnoozeSeconds.value!) &&
          pref.alarmSettings
              .isAlarmRepeatTimesInRange(_alarmRepeatTimes.value!);
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    Future<void> saveValues(List<TextEditingController> controlers) async {
      final pref = context.read<ConfigPreferences>();
      if (_isValid) {
        await pref.alarmSettings
            .setAlarmDurationSeconds(_alarmDurationSeconds.value!);
        await pref.alarmSettings
            .setAlarmSnoozeSeconds(_alarmSnoozeSeconds.value!);
        await pref.alarmSettings.setAlarmRepeatTimes(_alarmRepeatTimes.value!);
      }
    }

    // TODO Localization errorText
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: TextField(
              decoration: InputDecoration(
                labelText: t.alarmDurationSeconds,
                errorText: _validAlarmDurationSeconds()
                    ? null
                    : 'invalid value: '
                        '${AlarmPreferences.minAlarmDurationSeconds}'
                        '..${AlarmPreferences.maxAlarmDurationSeconds}',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              onChanged: (String value) {
                setState(() {
                  _alarmDurationSeconds.value = int.tryParse(value);
                });
              },
              controller: _controllers[0],
            ),
          ),
          Center(
            child: TextField(
              decoration: InputDecoration(
                labelText: t.alarmSnoozeSeconds,
                errorText: _validAlarmSnoozeSeconds()
                    ? null
                    : 'invalid value: '
                        '${AlarmPreferences.minAlarmSnoozeSeconds}'
                        '..${AlarmPreferences.maxAlarmSnoozeSeconds}',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              onChanged: (String value) {
                setState(() {
                  _alarmSnoozeSeconds.value = int.tryParse(value);
                });
              },
              controller: _controllers[1],
            ),
          ),
          Center(
            child: TextField(
              decoration: InputDecoration(
                  labelText: t.alarmRepeatTimes,
                  errorText: _validAlarmRepeatTimes()
                      ? null
                      : 'invalid value: '
                          '${AlarmPreferences.minAlarmRepeatTimes}'
                          '..${AlarmPreferences.maxAlarmRepeatTimes}'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              onChanged: (String value) {
                setState(() {
                  _alarmRepeatTimes.value = int.tryParse(value);
                });
              },
              controller: _controllers[2],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(top: 30),
            child: Center(
              child: ValueListenableBuilder<bool>(
                  valueListenable: ValueNotifier<bool>(_isValid),
                  builder: (BuildContext context, bool value, Widget? child) {
                    return ElevatedButton(
                      style: AppStyles.customButtonStyle,
                      onPressed: _isValid
                          ? () async {
                              developer.log(
                                  "Save settings button clicked! "
                                  "$_isValid",
                                  level: Level.FINER.value);
                              await saveValues(_controllers);
                            }
                          : null,
                      child: Text(t.saveChanges),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    for (int i = 0; i < 3; i++) {
      _controllers[i].dispose();
    }
    super.dispose();
  }
}
