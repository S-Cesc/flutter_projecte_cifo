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

/// Time preference editor for mealtime tablets
class TimePreferencesEditor extends StatefulWidget {

  /// Ctor
  const TimePreferencesEditor({super.key});

  @override
  State<TimePreferencesEditor> createState() => _TimePreferencesEditorState();
}

class _TimePreferencesEditorState extends State<TimePreferencesEditor> {
  late ValueNotifier<int?> _longBefore;
  late ValueNotifier<int?> _before;
  late ValueNotifier<int?> _after;
  late ValueNotifier<int?> _longAfter;
  late List<TextEditingController> _controllers;
  bool saved = true;

  @override
  void initState() {
    _loadValues();
    // controllers; initial values != null
    _controllers = [
      TextEditingController.fromValue(
          TextEditingValue(text: _longBefore.value.toString())),
      TextEditingController.fromValue(
          TextEditingValue(text: _before.value.toString())),
      TextEditingController.fromValue(
          TextEditingValue(text: _after.value.toString())),
      TextEditingController.fromValue(
          TextEditingValue(text: _longAfter.value.toString())),
    ];
    super.initState();
  }

  void _loadValues() {
    final pref = context.read<ConfigPreferences>();
    // actual value can be invalid,
    // because valid range in debug mode and release mode are different
    _longBefore = ValueNotifier<int?>(
        (pref.alarmSettings.data.minutesLongBefore >
                    AlarmPreferences.maxMinutesLongAfterBefore ||
                pref.alarmSettings.data.minutesLongBefore <
                    AlarmPreferences.minMinutesLongAfterBefore)
            ? AlarmPreferences.defaultMinutesLongBefore
            : pref.alarmSettings.data.minutesLongBefore);
    // actual value can be invalid,
    // because valid range in debug mode and release mode are different
    _before = ValueNotifier<int?>((pref.alarmSettings.data.minutesBefore >
                AlarmPreferences.maxMinutesAfterBefore ||
            pref.alarmSettings.data.minutesBefore <
                AlarmPreferences.minMinutesAfterBefore)
        ? AlarmPreferences.defaultMinutesBefore
        : pref.alarmSettings.data.minutesBefore);
    // actual value can be invalid,
    // because valid range in debug mode and release mode are different
    _after = ValueNotifier<int?>((pref.alarmSettings.data.minutesAfter >
                AlarmPreferences.maxMinutesAfterBefore ||
            pref.alarmSettings.data.minutesAfter <
                AlarmPreferences.minMinutesAfterBefore)
        ? AlarmPreferences.defaultMinutesAfter
        : pref.alarmSettings.data.minutesAfter);
    // actual value can be invalid,
    // because valid range in debug mode and release mode are different
    _longAfter = ValueNotifier<int?>((pref.alarmSettings.data.minutesLongAfter >
                AlarmPreferences.maxMinutesLongAfterBefore ||
            pref.alarmSettings.data.minutesLongAfter <
                AlarmPreferences.minMinutesLongAfterBefore)
        ? AlarmPreferences.defaultMinutesLongAfter
        : pref.alarmSettings.data.minutesLongAfter);
  }

  bool get _isValid {
    if (_longBefore.value != null &&
        _before.value != null &&
        _after.value != null &&
        _longAfter.value != null) {
      return _longBefore.value! <= AlarmPreferences.maxAlarmDurationSeconds &&
          _longBefore.value! >= AlarmPreferences.minAlarmDurationSeconds &&
          _before.value! <= AlarmPreferences.maxAlarmSnoozeSeconds &&
          _before.value! >= AlarmPreferences.minAlarmSnoozeSeconds &&
          _after.value! <= AlarmPreferences.maxAlarmRepeatTimes &&
          _after.value! >= AlarmPreferences.minAlarmRepeatTimes &&
          _longAfter.value! <= AlarmPreferences.maxAlarmDurationSeconds &&
          _longAfter.value! >= AlarmPreferences.minAlarmDurationSeconds;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    bool isLongBeforeValueSaved() {
      final pref = context.read<ConfigPreferences>();
      return _longBefore.value == pref.alarmSettings.data.minutesLongBefore;
    }

    bool isBeforeValueSaved() {
      final pref = context.read<ConfigPreferences>();
      return _before.value == pref.alarmSettings.data.minutesBefore;
    }

    bool isAfterValueSaved() {
      final pref = context.read<ConfigPreferences>();
      return _after.value == pref.alarmSettings.data.minutesAfter;
    }

    bool isLongAfterValueSaved() {
      final pref = context.read<ConfigPreferences>();
      return _longAfter.value == pref.alarmSettings.data.minutesLongAfter;
    }

    Future<void> saveValues() async {
      final pref = context.read<ConfigPreferences>();
      FocusScope.of(context).unfocus();
      if (_isValid) {
        await pref.alarmSettings.setMinutesLongBeforeMeal(_longBefore.value!);
        await pref.alarmSettings.setMinutesBeforeMeal(_before.value!);
        await pref.alarmSettings.setMinutesAfterMeal(_after.value!);
        await pref.alarmSettings.setMinutesLongAfterMeal(_longAfter.value!);
        setState(() {
          saved = true;
        });
      }
    }

    void undoChanges() {
      FocusScope.of(context).unfocus();
      _loadValues();
      _controllers[0].text = _longBefore.value.toString();
      _controllers[1].text = _before.value.toString();
      _controllers[2].text = _after.value.toString();
      _controllers[3].text = _longAfter.value.toString();
      setState(() {
        saved = true;
      });
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 30, right: 30),
              child: NatNumberTextField(
                controller: _controllers[0],
                labelText: t.longBefore,
                suffixText: "'",
                minValue: AlarmPreferences.minMinutesLongAfterBefore,
                maxValue: AlarmPreferences.maxMinutesLongAfterBefore,
                errorText: 'invalid value: '
                    '${AlarmPreferences.minMinutesLongAfterBefore}'
                    '..${AlarmPreferences.maxMinutesLongAfterBefore}',
                onChanged: (int? value) {
                  setState(
                    () {
                      _longBefore.value = value;
                      saved &= isLongBeforeValueSaved();
                    },
                  );
                },
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 30, right: 30),
              child: NatNumberTextField(
                controller: _controllers[1],
                labelText: t.before,
                suffixText: "'",
                minValue: AlarmPreferences.minMinutesAfterBefore,
                maxValue: AlarmPreferences.maxMinutesAfterBefore,
                errorText: 'invalid value: '
                    '${AlarmPreferences.minMinutesAfterBefore}'
                    '..${AlarmPreferences.maxMinutesAfterBefore}',
                onChanged: (int? value) {
                  setState(() {
                    _before.value = value;
                    saved &= isBeforeValueSaved();
                  });
                },
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 30, right: 30),
              child: NatNumberTextField(
                controller: _controllers[2],
                labelText: t.after,
                suffixText: "'",
                errorText: 'invalid value: '
                    '${AlarmPreferences.minMinutesAfterBefore}'
                    '..${AlarmPreferences.maxMinutesAfterBefore}',
                onChanged: (int? value) {
                  setState(() {
                    _after.value = value;
                    saved &= isAfterValueSaved();
                  });
                },
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 30, right: 30),
              child: NatNumberTextField(
                controller: _controllers[3],
                labelText: t.longAfter,
                suffixText: "'",
                errorText: 'invalid value: '
                    '${AlarmPreferences.minMinutesLongAfterBefore}'
                    '..${AlarmPreferences.maxMinutesLongAfterBefore}',
                onChanged: (int? value) {
                  setState(() {
                    _longAfter.value = value;
                    saved &= isLongAfterValueSaved();
                  });
                },
              ),
            ),
          ),
          if (!saved) ...[
            Padding(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: ValueListenableBuilder<bool>(
                        valueListenable: ValueNotifier<bool>(_isValid),
                        builder: (BuildContext context, bool value, Widget? child) {
                          return ElevatedButton(
                            style: AppStyles.customButtonStyle,
                            onPressed: () async {
                                    developer.log(
                                        "Undo after/before settings button clicked!"
                                        " $_isValid",
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
                        builder: (BuildContext context, bool value, Widget? child) {
                          return ElevatedButton(
                            style: AppStyles.customButtonStyle,
                            onPressed: _isValid
                                ? () async {
                                    developer.log(
                                        "Save after/before settings button clicked!"
                                        " $_isValid",
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
          ]
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
