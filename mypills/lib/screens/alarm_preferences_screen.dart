// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
// Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Localization
import '../l10n/app_localizations.dart';
// Project files
import '../model/global_functions.dart';
import '../providers/config_preferences.dart';
import '../providers/edit_providers/edit_provider_alarm_preferences.dart';
import '../styles/app_styles.dart';
import '../widgets/alarm_preferences_editor.dart';
import '../widgets/custom_back_button.dart';

/// Set Alarm Preferences:  Alarm seconds, Snooze seconds, Repeat times
class AlarmPreferencesScreen extends StatefulWidget {
  /// Ctor AlarmPreferencesScreen
  const AlarmPreferencesScreen({super.key});

  @override
  State<AlarmPreferencesScreen> createState() => _AlarmPreferencesScreenState();
}

class _AlarmPreferencesScreenState extends State<AlarmPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    final EditProviderAlarmPreferences alarmPreferencesProvider =
        EditProviderAlarmPreferences(
          context.read<ConfigPreferences>().generalSettings,
        );
    final t = AppLocalizations.of(context)!;
    Key editorKey = GlobalKey();

    Widget discardChangesButton() {
      return ValueListenableBuilder(
        valueListenable: alarmPreferencesProvider.notifyChanges(),
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
                      alarmPreferencesProvider.discardChanges();
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
        valueListenable: alarmPreferencesProvider.notifyValidChanges(),
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
                      bool saved = await alarmPreferencesProvider.saveValues();
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
            areThereChanges: () => alarmPreferencesProvider.hasChanges,
            discardChanges: () {
              alarmPreferencesProvider.discardChanges();
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
              children: [
                Text(t.alarmSettings, style: AppStyles.constFonts.headline),
                AlarmPreferencesEditor(
                  provider: alarmPreferencesProvider,
                  key: editorKey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
