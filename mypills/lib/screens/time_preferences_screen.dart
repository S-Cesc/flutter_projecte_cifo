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
import '../styles/app_styles.dart';
import '../providers/config_preferences.dart';
import '../providers/edit_providers/edit_provider_time_preferences.dart';
import '../widgets/time_preferences_editor.dart';
import '../widgets/custom_back_button.dart';

/// Set Time Preferences: Long before, Before, After, Long after
class TimePreferencesScreen extends StatefulWidget {
  /// Ctor TimePreferencesScreen
  const TimePreferencesScreen({super.key});

  @override
  State<TimePreferencesScreen> createState() => _TimePreferencesScreenState();
}

class _TimePreferencesScreenState extends State<TimePreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    final EditProviderTimePreferences timePreferencesProvider =
        EditProviderTimePreferences(
          context.read<ConfigPreferences>().generalSettings,
        );
    final t = AppLocalizations.of(context)!;
    Key editorKey = GlobalKey();

    Widget discardChangesButton() {
      return ValueListenableBuilder(
        valueListenable: timePreferencesProvider.notifyChanges(),
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
                      timePreferencesProvider.discardChanges();
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
        valueListenable: timePreferencesProvider.notifyValidChanges(),
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
                      bool saved = await timePreferencesProvider.saveValues();
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
            areThereChanges: () => timePreferencesProvider.hasChanges,
            discardChanges: timePreferencesProvider.discardChanges,
            //NOTE: discard do not affect widget setState, as it moves back
          ),
          actions: <Widget>[discardChangesButton(), saveValuesButton()],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(
              children: [
                Text(t.timeSettings, style: AppStyles.constFonts.headline),
                TimePreferencesEditor(
                  provider: timePreferencesProvider,
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
