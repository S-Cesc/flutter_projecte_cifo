// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../styles/app_styles.dart';
import '../model/weekly_time_table.dart';
import '../providers/config_preferences.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/meals_table.dart';
import '../widgets/meals_table_special_days.dart';

class ConfigWeekdays extends StatelessWidget {
  const ConfigWeekdays({super.key});

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    Future<void> saveValues(WeeklyTimeTable wtt) async {
      final pref = context.read<ConfigPreferences>();
      await pref.alarmSettings.setWeeklyTimeTable(wtt);
      if (context.mounted) Navigator.pop(context);
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppStyles.colors.mantis,
        appBar: AppBar(
          backgroundColor: AppStyles.colors.ochre[700],
          leading: CustomBackButton(),
          bottom: TabBar(tabs: [
            Center(
              child: Text(
                t.weeklyDefaultTimetable,
                style: AppStyles.fonts.display(),
              ),
            ),
            Center(
              child: Text(
                t.weeklyAltTimetable,
                style: AppStyles.fonts.display(),
              ),
            ),
          ]),
          elevation: 4,
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: MealsTable(defaultMeals: true, saveValues: saveValues),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: MealsTableSpecialDays(saveValues: saveValues),
            ),
          ],
        ),
      ),
    );
  }
}
