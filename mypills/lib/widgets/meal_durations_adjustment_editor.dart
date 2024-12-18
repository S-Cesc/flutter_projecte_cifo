// logging and debugging
//import 'dart:developer' as developer;
//import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../styles/app_styles.dart';
import '../model/general_preferences.dart';
import '../providers/edit_providers/edit_provider_meal_durations_adjustment.dart';
import 'nat_number_text_field.dart';

/// Time preference editor for mealtime tablets
class MealDurationsAdjustmentEditor extends StatefulWidget {
  final EditProviderMealDurationsAdjustment _provider;

  /// Ctor
  const MealDurationsAdjustmentEditor(
      {super.key, required EditProviderMealDurationsAdjustment provider})
      : _provider = provider;

  @override
  State<MealDurationsAdjustmentEditor> createState() => _MealDurationsAdjustmentEditorState();
}

class _MealDurationsAdjustmentEditorState extends State<MealDurationsAdjustmentEditor> {
  late List<TextEditingController> _controllers;
  bool saved = true;

  @override
  void initState() {
    _controllers = [
      TextEditingController.fromValue(TextEditingValue(
          text: widget._provider.breakfastMinutes.toString())),
      TextEditingController.fromValue(TextEditingValue(
          text: widget._provider.brunchMinutes.toString())),
      TextEditingController.fromValue(TextEditingValue(
          text: widget._provider.lunchMinutes.toString())),
      TextEditingController.fromValue(TextEditingValue(
          text: widget._provider.teaMinutes.toString())),
      TextEditingController.fromValue(TextEditingValue(
          text: widget._provider.highTeaMinutes.toString())),
      TextEditingController.fromValue(TextEditingValue(
          text: widget._provider.dinnerMinutes.toString())),
      TextEditingController.fromValue(TextEditingValue(
          text: widget._provider.supperMinutes.toString())),
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
                      labelText: t.bkfDuration,
                      tooltipHelp: null,
                      iconColor: AppStyles.colors.ochre,
                      suffixText: "'",
                      minValue: GeneralPreferences.minMealDurationMinutes,
                      maxValue: GeneralPreferences.maxMealDurationMinutes,
                      errorText: 'invalid value: '
                          '${GeneralPreferences.minMealDurationMinutes}'
                          '..${GeneralPreferences.maxMealDurationMinutes}',
                      onChanged: (int? value) {
                        widget._provider.breakfastMinutes = value;
                      },
                    );
                  }),
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
                      labelText: t.brunchDuration,
                      tooltipHelp: null,
                      iconColor: AppStyles.colors.ochre,
                      suffixText: "'",
                      minValue: GeneralPreferences.minMealDurationMinutes,
                      maxValue: GeneralPreferences.maxMealDurationMinutes,
                      errorText: 'invalid value: '
                          '${GeneralPreferences.minMealDurationMinutes}'
                          '..${GeneralPreferences.maxMealDurationMinutes}',
                      onChanged: (int? value) {
                        widget._provider.brunchMinutes = value;
                      },
                    );
                  }),
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
                      labelText: t.lunchDuration,
                      tooltipHelp: null,
                      iconColor: AppStyles.colors.ochre,
                      suffixText: "'",
                      minValue: GeneralPreferences.minMealDurationMinutes,
                      maxValue: GeneralPreferences.maxMealDurationMinutes,
                      errorText: 'invalid value: '
                          '${GeneralPreferences.minMealDurationMinutes}'
                          '..${GeneralPreferences.maxMealDurationMinutes}',
                      onChanged: (int? value) {
                        widget._provider.lunchMinutes = value;
                      },
                    );
                  }),
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
                      labelText: t.teaDuration,
                      tooltipHelp: null,
                      iconColor: AppStyles.colors.ochre,
                      suffixText: "'",
                      minValue: GeneralPreferences.minMealDurationMinutes,
                      maxValue: GeneralPreferences.maxMealDurationMinutes,
                      errorText: 'invalid value: '
                          '${GeneralPreferences.minMealDurationMinutes}'
                          '..${GeneralPreferences.maxMealDurationMinutes}',
                      onChanged: (int? value) {
                        widget._provider.teaMinutes = value;
                      },
                    );
                  }),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 50, right: 50),
              child: ValueListenableBuilder(
                  valueListenable: _controllers[4],
                  builder: (context, TextEditingValue value, __) {
                    return NatNumberTextField(
                      controller: _controllers[4],
                      labelText: t.highTeaDuration,
                      tooltipHelp: null,
                      iconColor: AppStyles.colors.ochre,
                      suffixText: "'",
                      minValue: GeneralPreferences.minMealDurationMinutes,
                      maxValue: GeneralPreferences.maxMealDurationMinutes,
                      errorText: 'invalid value: '
                          '${GeneralPreferences.minMealDurationMinutes}'
                          '..${GeneralPreferences.maxMealDurationMinutes}',
                      onChanged: (int? value) {
                        widget._provider.highTeaMinutes = value;
                      },
                    );
                  }),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 50, right: 50),
              child: ValueListenableBuilder(
                  valueListenable: _controllers[5],
                  builder: (context, TextEditingValue value, __) {
                    return NatNumberTextField(
                      controller: _controllers[5],
                      labelText: t.dinnerDuration,
                      tooltipHelp: null,
                      iconColor: AppStyles.colors.ochre,
                      suffixText: "'",
                      minValue: GeneralPreferences.minMealDurationMinutes,
                      maxValue: GeneralPreferences.maxMealDurationMinutes,
                      errorText: 'invalid value: '
                          '${GeneralPreferences.minMealDurationMinutes}'
                          '..${GeneralPreferences.maxMealDurationMinutes}',
                      onChanged: (int? value) {
                        widget._provider.dinnerMinutes = value;
                      },
                    );
                  }),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 50, right: 50),
              child: ValueListenableBuilder(
                  valueListenable: _controllers[6],
                  builder: (context, TextEditingValue value, __) {
                    return NatNumberTextField(
                      controller: _controllers[6],
                      labelText: t.supperDuration,
                      tooltipHelp: null,
                      iconColor: AppStyles.colors.ochre,
                      suffixText: "'",
                      minValue: GeneralPreferences.minMealDurationMinutes,
                      maxValue: GeneralPreferences.maxMealDurationMinutes,
                      errorText: 'invalid value: '
                          '${GeneralPreferences.minMealDurationMinutes}'
                          '..${GeneralPreferences.maxMealDurationMinutes}',
                      onChanged: (int? value) {
                        widget._provider.supperMinutes = value;
                      },
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
    for (int i = 0; i < 4; i++) {
      _controllers[i].dispose();
    }
    super.dispose();
  }
}
