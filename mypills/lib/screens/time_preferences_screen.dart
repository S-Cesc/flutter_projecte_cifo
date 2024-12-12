import 'package:flutter/material.dart';
// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../styles/app_styles.dart';
import '../widgets/time_preferences_editor.dart';
import '../widgets/custom_back_button.dart';

/// Set Time Preferences: Long before, Before, After, Long after
class TimePreferencesScreen extends StatelessWidget {

  /// Ctor TimePreferencesScreen
  const TimePreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
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
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top:10, left: 10, right: 10),
          child: Column(
            children: [
              Text(t.timeSettings, style: AppStyles.fonts.headline(),),
              TimePreferencesEditor(),
            ],
          ),
          ),
      ),
    ));
  }
}