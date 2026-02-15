// Flutter
import 'package:flutter/material.dart';
// Localization
import '../l10n/app_localizations.dart';
// Project files
import '../styles/app_styles.dart';
import '../model/general_preferences.dart';
import '../providers/edit_providers/edit_provider_meal_durations_adjustment.dart';
import 'pair_nat_number_field.dart';

/// Time preference editor for mealtime tablets
class MealDurationsAdjustmentEditor extends StatefulWidget {
  final EditProviderMealDurationsAdjustment _provider;

  /// Ctor
  const MealDurationsAdjustmentEditor({
    super.key,
    required EditProviderMealDurationsAdjustment provider,
  }) : _provider = provider;

  @override
  State<MealDurationsAdjustmentEditor> createState() =>
      _MealDurationsAdjustmentEditorState();
}

class _MealDurationsAdjustmentEditorState
    extends State<MealDurationsAdjustmentEditor> {
  late final List<TextEditingController> _controllers;
  bool saved = true;

  @override
  void initState() {
    _controllers = [
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.breakfastMinutes.$1.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.breakfastMinutes.$2.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.elevensesMinutes.$1.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.elevensesMinutes.$2.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.brunchMinutes.$1.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.brunchMinutes.$2.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.lunchMinutes.$1.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.lunchMinutes.$2.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.teaMinutes.$1.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.teaMinutes.$2.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.highTeaMinutes.$1.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.highTeaMinutes.$2.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.dinnerMinutes.$1.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.dinnerMinutes.$2.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.supperMinutes.$1.toString()),
      ),
      TextEditingController.fromValue(
        TextEditingValue(text: widget._provider.supperMinutes.$2.toString()),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    return OrientationBuilder(
      builder: (context, orientation) {
        const boxConstraints = BoxConstraints(
          minHeight: 125,
          maxHeight: 145,
          maxWidth: 400,
        );
        const padding = EdgeInsets.only(left: 10, right: 10);
        final slow = t.slowLabel;
        final fast = t.fastLabel;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Wrap(
            children: [
              Padding(
                padding: padding,
                child: ConstrainedBox(
                  constraints: boxConstraints,
                  child: PairNatNumberField(
                    title: t.bkfDuration,
                    labelText1: fast,
                    labelText2: slow,
                    suffixText1: "'",
                    suffixText2: "'",
                    labelStyle: AppStyles.constFonts.body,
                    titleBackgroundColor: AppStyles.colors.mantis,
                    controller1: _controllers[0],
                    controller2: _controllers[1],
                    minValue: GeneralPreferences.minMealDurationMinutes,
                    maxValue: GeneralPreferences.maxMealDurationMinutes,
                    onChanged: (t, _) {
                      widget._provider.breakfastMinutes = t;
                    },
                    tooltipHelp1: null,
                    tooltipHelp2: null,
                  ),
                ),
              ),
              Padding(
                padding: padding,
                child: ConstrainedBox(
                  constraints: boxConstraints,
                  child: PairNatNumberField(
                    title: t.elevensesDuration,
                    labelText1: fast,
                    labelText2: slow,
                    suffixText1: "'",
                    suffixText2: "'",
                    labelStyle: AppStyles.constFonts.body,
                    titleBackgroundColor: AppStyles.colors.mantis,
                    controller1: _controllers[2],
                    controller2: _controllers[3],
                    minValue: GeneralPreferences.minMealDurationMinutes,
                    maxValue: GeneralPreferences.maxMealDurationMinutes,
                    onChanged: (t, _) {
                      widget._provider.elevensesMinutes = t;
                    },
                    tooltipHelp1: null,
                    tooltipHelp2: null,
                  ),
                ),
              ),
              Padding(
                padding: padding,
                child: ConstrainedBox(
                  constraints: boxConstraints,
                  child: PairNatNumberField(
                    title: t.brunchDuration,
                    labelText1: fast,
                    labelText2: slow,
                    suffixText1: "'",
                    suffixText2: "'",
                    labelStyle: AppStyles.constFonts.body,
                    titleBackgroundColor: AppStyles.colors.mantis,
                    controller1: _controllers[4],
                    controller2: _controllers[5],
                    minValue: GeneralPreferences.minMealDurationMinutes,
                    maxValue: GeneralPreferences.maxMealDurationMinutes,
                    onChanged: (t, _) {
                      widget._provider.brunchMinutes = t;
                    },
                    tooltipHelp1: null,
                    tooltipHelp2: null,
                  ),
                ),
              ),
              Padding(
                padding: padding,
                child: ConstrainedBox(
                  constraints: boxConstraints,
                  child: PairNatNumberField(
                    title: t.lunchDuration,
                    labelText1: fast,
                    labelText2: slow,
                    suffixText1: "'",
                    suffixText2: "'",
                    labelStyle: AppStyles.constFonts.body,
                    titleBackgroundColor: AppStyles.colors.mantis,
                    controller1: _controllers[6],
                    controller2: _controllers[7],
                    minValue: GeneralPreferences.minMealDurationMinutes,
                    maxValue: GeneralPreferences.maxMealDurationMinutes,
                    onChanged: (t, _) {
                      widget._provider.lunchMinutes = t;
                    },
                    tooltipHelp1: null,
                    tooltipHelp2: null,
                  ),
                ),
              ),
              Padding(
                padding: padding,
                child: ConstrainedBox(
                  constraints: boxConstraints,
                  child: PairNatNumberField(
                    title: t.teaDuration,
                    labelText1: fast,
                    labelText2: slow,
                    suffixText1: "'",
                    suffixText2: "'",
                    labelStyle: AppStyles.constFonts.body,
                    titleBackgroundColor: AppStyles.colors.mantis,
                    controller1: _controllers[8],
                    controller2: _controllers[9],
                    minValue: GeneralPreferences.minMealDurationMinutes,
                    maxValue: GeneralPreferences.maxMealDurationMinutes,
                    onChanged: (t, _) {
                      widget._provider.teaMinutes = t;
                    },
                    tooltipHelp1: null,
                    tooltipHelp2: null,
                  ),
                ),
              ),
              Padding(
                padding: padding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 125,
                    maxHeight: 145,
                    maxWidth: 400,
                  ),
                  child: PairNatNumberField(
                    title: t.highTeaDuration,
                    labelText1: fast,
                    labelText2: slow,
                    suffixText1: "'",
                    suffixText2: "'",
                    labelStyle: AppStyles.constFonts.body,
                    titleBackgroundColor: AppStyles.colors.mantis,
                    controller1: _controllers[10],
                    controller2: _controllers[11],
                    minValue: GeneralPreferences.minMealDurationMinutes,
                    maxValue: GeneralPreferences.maxMealDurationMinutes,
                    onChanged: (t, _) {
                      widget._provider.highTeaMinutes = t;
                    },
                    tooltipHelp1: null,
                    tooltipHelp2: null,
                  ),
                ),
              ),
              Padding(
                padding: padding,
                child: ConstrainedBox(
                  constraints: boxConstraints,
                  child: PairNatNumberField(
                    title: t.dinnerDuration,
                    labelText1: fast,
                    labelText2: slow,
                    suffixText1: "'",
                    suffixText2: "'",
                    labelStyle: AppStyles.constFonts.body,
                    titleBackgroundColor: AppStyles.colors.mantis,
                    controller1: _controllers[12],
                    controller2: _controllers[13],
                    minValue: GeneralPreferences.minMealDurationMinutes,
                    maxValue: GeneralPreferences.maxMealDurationMinutes,
                    onChanged: (t, _) {
                      widget._provider.dinnerMinutes = t;
                    },
                    tooltipHelp1: null,
                    tooltipHelp2: null,
                  ),
                ),
              ),
              Padding(
                padding: padding,
                child: ConstrainedBox(
                  constraints: boxConstraints,
                  child: PairNatNumberField(
                    title: t.supperDuration,
                    labelText1: fast,
                    labelText2: slow,
                    suffixText1: "'",
                    suffixText2: "'",
                    labelStyle: AppStyles.constFonts.body,
                    titleBackgroundColor: AppStyles.colors.mantis,
                    controller1: _controllers[14],
                    controller2: _controllers[15],
                    minValue: GeneralPreferences.minMealDurationMinutes,
                    maxValue: GeneralPreferences.maxMealDurationMinutes,
                    onChanged: (t, _) {
                      widget._provider.supperMinutes = t;
                    },
                    tooltipHelp1: null,
                    tooltipHelp2: null,
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
