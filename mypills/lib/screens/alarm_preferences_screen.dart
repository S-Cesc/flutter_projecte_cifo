// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
// Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../providers/config_preferences.dart';
import '../styles/app_styles.dart';
import '../widgets/alarm_preferences_editor.dart';
import '../widgets/custom_back_button.dart';

/// Set Alarm Preferences:  Alarm seconds, Snooze seconds, Repeat times
class AlarmPreferencesScreen extends StatelessWidget {

  /// Ctor AlarmPreferencesScreen
  const AlarmPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    Future<void> saveValues() async {
      final pref = context.read<ConfigPreferences>();
      // await pref.alarmSettings.
      if (context.mounted) Navigator.pop(context);
    }

    Future<void> requery() async {
      final pref = context.read<ConfigPreferences>();
      await pref.alarmSettings.requery();
    }

    return SafeArea(
        child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppStyles.colors.mantis,
        appBar: AppBar(
          backgroundColor: AppStyles.colors.ochre[700],
          title: Center(
            child: Text(
              t.appTitle,
              style: AppStyles.fonts.display(),
            ),
          ),
          elevation: 4,
          leading: CustomBackButton(),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  developer.log("Undo button clicked! ",
                      level: Level.FINER.value);
                  await requery();
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<CircleBorder>(
                    CircleBorder(
                      side: BorderSide(
                        color: AppStyles.colors.forestGreen[700]!,
                        width: 1.0,
                      ),
                    ),
                  ),
                  backgroundColor:
                      WidgetStateProperty.all(AppStyles.colors.forestGreen),
                  foregroundColor:
                      WidgetStateProperty.all(AppStyles.colors.darkSlateGray),
                ),
                child: const Icon(Icons.undo),
              ),
              TextButton(
                onPressed: () async {
                  developer.log("Save button clicked! ",
                      level: Level.FINER.value);
                  await saveValues();
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<CircleBorder>(
                    CircleBorder(
                      side: BorderSide(
                        color: AppStyles.colors.forestGreen[700]!,
                        width: 1.0,
                      ),
                    ),
                  ),
                  backgroundColor:
                      WidgetStateProperty.all(AppStyles.colors.forestGreen),
                  foregroundColor:
                      WidgetStateProperty.all(AppStyles.colors.darkSlateGray),
                ),
                child: const Icon(Icons.archive),
              ),
            ],
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top:10, left: 10, right: 10),
          child: Column(
            children: [
              Text(t.alarmSettings, style: AppStyles.fonts.headline(),),
              AlarmPreferencesEditor(),
            ],
          ),
          ),
      ),
    ));
  }
}
