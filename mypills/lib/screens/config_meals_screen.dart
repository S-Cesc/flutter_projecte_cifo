// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
import 'package:mypills/model/weekly_time_table.dart';
import 'package:provider/provider.dart';
// Localizations
import '../l10n/app_localizations.dart';
// Project files
import '../model/global_constants.dart';
import '../styles/app_styles.dart';
import '../providers/config_preferences.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/meals_table.dart';
import '../widgets/meals_table_special_days.dart';

/// Screen to set meal times
class ConfigMealsScreen extends StatefulWidget {
  /// Ctor
  const ConfigMealsScreen({super.key});

  @override
  State<ConfigMealsScreen> createState() => _ConfigMealsScreenState();
}

class _ConfigMealsScreenState extends State<ConfigMealsScreen> {
  bool changed = false;

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    void callbackCheckUpdate() {
      // if there are changes then notify
      final pref = context.read<ConfigPreferences>();
      final tmpResult = pref.generalSettings.wtt.modified;
      if (tmpResult) {
        setState(() {
          changed = true;
          // Notify listeners
          pref.generalSettings.wtt.callbackUpdate();
        });
      }
    }

    bool areThereChanges() => changed;

    Future<void> saveValues() async {
      final pref = context.read<ConfigPreferences>();
      pref.generalSettings.wtt.callbackUpdate();
      await pref.generalSettings.setWeeklyTimeTable(pref.generalSettings.wtt);
      setState(() {
        changed = false;
        // Notify listeners
        pref.generalSettings.wtt.callbackUpdate();
      });
    }

    Future<void> discard() async {
      final pref = context.read<ConfigPreferences>();
      await pref.generalSettings.requery();
    }

    Future<void> requery() async {
      await discard();
      setState(() {
        changed = false;
      });
    }

    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppStyles.colors.mantis,
          appBar: AppBar(
            backgroundColor: AppStyles.colors.ochre[700],
            leading: CustomBackButton(
              areThereChanges: areThereChanges,
              discardChanges: discard,
              //NOTE: discard do not affect widget setState, when it moves back
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Stack(
                children: [
                  TabBar(
                    isScrollable: true,
                    tabs: [
                      Center(
                        child: Text(
                          WeeklyTimeTable.partitionNames(t).$1,
                          style: AppStyles.constFonts.display,
                        ),
                      ),
                      Center(
                        child: Text(
                          WeeklyTimeTable.partitionNames(t).$2[0],
                          style: AppStyles.constFonts.labelLarge,
                        ),
                      ),
                      Center(
                        child: Text(
                          WeeklyTimeTable.partitionNames(t).$2[1],
                          style: AppStyles.constFonts.labelLarge,
                        ),
                      ),
                      Center(
                        child: Text(
                          WeeklyTimeTable.partitionNames(t).$2[2],
                          style: AppStyles.constFonts.labelLarge,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Tooltip(
                      message: t.configMealsTooltip,
                      triggerMode: TooltipTriggerMode.tap,
                      showDuration: GlobalConstants.tooltipDuration(
                        t.configMealsTooltip.length,
                      ),
                      child: Icon(Icons.help, color: AppStyles.colors.ochre),
                    ),
                  ),
                ],
              ),
            ),
            elevation: 4,
            actions: <Widget>[
              IconButton(
                onPressed:
                    changed
                        ? () async {
                          developer.log(
                            "Undo button clicked! ",
                            level: Level.FINER.value,
                          );
                          await requery();
                        }
                        : null,
                style: AppStyles.textButtonstyle,
                icon: const Icon(Icons.undo),
              ),
              TextButton(
                onPressed:
                    changed
                        ? () async {
                          developer.log(
                            "Save button clicked! ",
                            level: Level.FINER.value,
                          );
                          await saveValues();
                        }
                        : null,
                style: AppStyles.textButtonstyle,
                child: const Icon(Icons.archive),
              ),
            ],
          ),
          body: TabBarView(
            children: [
              OrientationBuilder(
                builder: (orientationContext, orientation) {
                  if (orientation == Orientation.portrait) {
                    return Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: MealsTable(
                        mealsPartition: null,
                        callbackCheckUpdate: callbackCheckUpdate,
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 170,
                        vertical: 10,
                      ),
                      child: MealsTable(
                        mealsPartition: null,
                        callbackCheckUpdate: callbackCheckUpdate,
                      ),
                    );
                  }
                },
              ),
              for (var tabIndex = 0; tabIndex < 3; tabIndex++)
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: MealsTableSpecialDays(
                    partitionNumber: tabIndex,
                    callbackCheckUpdate: callbackCheckUpdate,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
