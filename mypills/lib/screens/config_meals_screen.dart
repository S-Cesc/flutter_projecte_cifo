// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Flutter
import 'package:flutter/material.dart';
import 'package:mypills/common/global_functions.dart';
import 'package:mypills/model/weekly_time_table.dart';
import 'package:provider/provider.dart';
// Localizations
import '../l10n/app_localizations.dart';
// Project files
import '../common/global_constants.dart';
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
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    bool areThereChanges(EditProviderWeeklyTimeTable wtt) => wtt.modified;

    Future<void> saveValues(EditProviderWeeklyTimeTable wtt) async {
      final pref = context.read<ConfigPreferences>();
      await pref.generalSettings.saveWeeklyTimeTable(wtt as WeeklyTimeTable);
      setState(() {});
    }

    //NOTE: discard do not affect widget setState,
    // because it is used to move back
    Future<void> discard(EditProviderWeeklyTimeTable wtt) async {
      final pref = context.read<ConfigPreferences>();
      wtt.copyValues(pref.generalSettings.wtt);
      wtt.resetModified();
      GlobalFunctions.notifyUndo(context, t);
    }

    Future<void> requery(EditProviderWeeklyTimeTable wtt) async {
      await discard(wtt);
      // requery does not move back: restore state
      setState(() {});
    }

    void notifyAutomatichanges() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.timeTableModifiedWarning),
          backgroundColor: Colors.red,
        ),
      );
    }

    void notifyEmptyDayset() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.emptyDaysetError),
          backgroundColor: Colors.red,
        ),
      );
    }

    return ChangeNotifierProvider(
      create:
          (context) => EditProviderWeeklyTimeTable(
            context.read<ConfigPreferences>().generalSettings.wtt,
            notifyAutomatichanges,
            notifyEmptyDayset,
          ),
      child: Builder(
        builder: (context) {
          return SafeArea(
            child: DefaultTabController(
              length: 4,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: AppStyles.colors.mantis,
                appBar: AppBar(
                  backgroundColor: AppStyles.colors.ochre[700],
                  leading: CustomBackButton(
                    // Flutter error: context is not included in the clousure
                    // so, you can't pass areThereChanges func as a parameter
                    // because it depends on a provider defined in context
                    // It seems that context has its own rules
                    // Riverpod does not use the context!
                    areThereChanges:
                        areThereChanges(
                              context.watch<EditProviderWeeklyTimeTable>(),
                            )
                            ? () => true
                            : null,
                    discardChanges:
                        () => discard(
                          context.read<EditProviderWeeklyTimeTable>(),
                        ),
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
                                GlobalFunctions.partitionNames(t).$1,
                                style: AppStyles.constFonts.display,
                              ),
                            ),
                            Center(
                              child: Text(
                                GlobalFunctions.partitionNames(t).$2[0],
                                style: AppStyles.constFonts.labelLarge,
                              ),
                            ),
                            Center(
                              child: Text(
                                GlobalFunctions.partitionNames(t).$2[1],
                                style: AppStyles.constFonts.labelLarge,
                              ),
                            ),
                            Center(
                              child: Text(
                                GlobalFunctions.partitionNames(t).$2[2],
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
                            child: Icon(
                              Icons.help,
                              color: AppStyles.colors.ochre,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  elevation: 4,
                  actions: <Widget>[
                    IconButton(
                      onPressed:
                          areThereChanges(
                                context.watch<EditProviderWeeklyTimeTable>(),
                              )
                              ? () async {
                                developer.log(
                                  "Undo button clicked! ",
                                  level: Level.FINER.value,
                                );
                                await requery(
                                  context.read<EditProviderWeeklyTimeTable>(),
                                );
                              }
                              : null,
                      style: AppStyles.textButtonstyle,
                      icon: const Icon(Icons.undo),
                    ),
                    TextButton(
                      onPressed:
                          areThereChanges(
                                context.watch<EditProviderWeeklyTimeTable>(),
                              )
                              ? () async {
                                developer.log(
                                  "Save button clicked! ",
                                  level: Level.FINER.value,
                                );
                                await saveValues(
                                  context.read<EditProviderWeeklyTimeTable>(),
                                );
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
                            child: MealsTable(mealsPartition: null),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 170,
                              vertical: 10,
                            ),
                            child: MealsTable(mealsPartition: null),
                          );
                        }
                      },
                    ),
                    for (var tabIndex = 0; tabIndex < 3; tabIndex++)
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: MealsTableSpecialDays(partitionNumber: tabIndex),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
