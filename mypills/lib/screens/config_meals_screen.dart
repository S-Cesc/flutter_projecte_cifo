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
import '../providers/config_preferences.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/meals_table.dart';
import '../widgets/meals_table_special_days.dart';

/// Screen to set meal times
class ConfigMealsScreen extends StatelessWidget {
  /// Ctor
  const ConfigMealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    Future<void> saveValues() async {
      final pref = context.read<ConfigPreferences>();
      await pref.alarmSettings.setWeeklyTimeTable(pref.alarmSettings.wtt);
      if (context.mounted) Navigator.pop(context);
    }

    Future<void> requery() async {
      final pref = context.read<ConfigPreferences>();
      await pref.alarmSettings.requery();
    }

    List<Widget> buttons() {
      return [
        ElevatedButton(
          style: AppStyles.customButtonStyle,
          onPressed: () async {
            await requery();
          },
          child: Text(t.undoChanges),
        ),
        ElevatedButton(
          style: AppStyles.customButtonStyle,
          onPressed: () async {
            await saveValues();
          },
          child: Text(t.saveChanges),
        ),
      ];
    }

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppStyles.colors.mantis,
          appBar: AppBar(
            backgroundColor: AppStyles.colors.ochre[700],
            leading: CustomBackButton(),
            bottom: TabBar(isScrollable: true, tabs: [
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
          body: TabBarView(
            children: [
              OrientationBuilder(builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        Expanded(child: MealsTable(defaultMeals: true)),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: buttons(),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 40, top: 10, bottom: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: buttons(),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: MealsTable(defaultMeals: true),
                        ),
                      ],
                    ),
                  );
                }
              }),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: MealsTableSpecialDays(
                  requery: requery,
                  saveValues: saveValues,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
