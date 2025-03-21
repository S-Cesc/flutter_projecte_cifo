// ignore_for_file: public_member_api_docs

// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Localization
import '../l10n/app_localizations.dart';
// Project files
import '../model/global_constants.dart';
import '../model/global_functions.dart';
import '../styles/app_styles.dart';
import '../providers/config_preferences.dart';
import '../providers/edit_providers/edit_provider_meal_durations_adjustment.dart';
import '../widgets/meal_durations_adjustment_editor.dart';
import '../widgets/custom_back_button.dart';

class MealDurationsAdjustmentScreen extends StatefulWidget {
  const MealDurationsAdjustmentScreen({super.key});

  @override
  State<MealDurationsAdjustmentScreen> createState() =>
      _MealDurationsAdjustmentScreenState();
}

class _MealDurationsAdjustmentScreenState
    extends State<MealDurationsAdjustmentScreen> {
  @override
  Widget build(BuildContext context) {
    final EditProviderMealDurationsAdjustment mealDurationsAdjustmentProvider =
        EditProviderMealDurationsAdjustment(
          context.read<ConfigPreferences>().generalSettings,
        );
    final t = AppLocalizations.of(context)!;
    Key editorKey = GlobalKey();

    Widget discardChangesButton() {
      return ValueListenableBuilder(
        valueListenable: mealDurationsAdjustmentProvider.notifyChanges(),
        builder: (context, value, child) {
          return IconButton(
            onPressed:
                value
                    ? () {
                      developer.log(
                        "Undo button clicked! ",
                        level: Level.FINER.value,
                      );
                      FocusScope.of(context).unfocus();
                      mealDurationsAdjustmentProvider.discardChanges();
                      GlobalFunctions.notifyUndo(context, t);
                      setState(() {
                        editorKey = GlobalKey();
                      });
                    }
                    : null,
            style: AppStyles.textButtonstyle,
            icon: const Icon(Icons.undo),
          );
        },
      );
    }

    Widget saveValuesButton() {
      return ValueListenableBuilder(
        valueListenable: mealDurationsAdjustmentProvider.notifyValidChanges(),
        builder: (context, value, child) {
          return IconButton(
            onPressed:
                value
                    ? () async {
                      developer.log(
                        "Save button clicked! ",
                        level: Level.FINER.value,
                      );
                      FocusScope.of(context).unfocus();
                      bool saved =
                          await mealDurationsAdjustmentProvider.saveValues();
                      if (context.mounted) {
                        developer.log("Show snackbar", level: Level.FINE.value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              saved ? t.saved : t.notSavedCauseOfError,
                            ),
                            backgroundColor: saved ? null : Colors.red,
                          ),
                        );
                      }
                      setState(() {
                        editorKey = GlobalKey();
                      });
                    }
                    : null,
            style: AppStyles.textButtonstyle,
            icon: const Icon(Icons.archive),
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppStyles.colors.mantis,
        appBar: AppBar(
          backgroundColor: AppStyles.colors.ochre[700],
          title: Center(
            child: Text(t.appTitle, style: AppStyles.constFonts.display),
          ),
          elevation: 4,
          leading: CustomBackButton(
            areThereChanges: () => mealDurationsAdjustmentProvider.hasChanges,
            discardChanges: () {
              mealDurationsAdjustmentProvider.discardChanges();
              GlobalFunctions.notifyUndo(context, t);
            },
            //NOTE: discard do not affect widget setState, as it moves back
          ),
          actions: <Widget>[discardChangesButton(), saveValuesButton()],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Tooltip(
                        message: t.timeEatingTooltip,
                        triggerMode: TooltipTriggerMode.tap,
                        showDuration: GlobalConstants.longTooltip,
                        child: Icon(Icons.help, color: AppStyles.colors.ochre),
                      ),
                    ),
                    Text(
                      t.timeEating,
                      style: AppStyles.constFonts.headline,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                MealDurationsAdjustmentEditor(
                  provider: mealDurationsAdjustmentProvider,
                  key: editorKey,
                ),
                Padding(padding: EdgeInsets.only(bottom: 30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
