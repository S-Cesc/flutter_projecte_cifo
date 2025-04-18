// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:io' show exit;
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
// Localization
import '../l10n/app_localizations.dart';
// Project files
import '../model/global_constants.dart';
import '../providers/config_preferences.dart';
import '../styles/app_styles.dart';
import 'alarm_list_screen.dart';
import 'alarm_preferences_screen.dart';
import 'config_meals_screen.dart';
import 'debug_config_screen.dart';
import 'time_preferences_screen.dart';
import 'meal_durations_adjustment_screen.dart';

//=======================================================================

/// Setup screen (initial application screen)
class MainConfigScreen extends StatefulWidget {
  /// Constructor
  const MainConfigScreen({super.key});

  @override
  State<MainConfigScreen> createState() => _MainConfigScreenState();
}

class _MainConfigScreenState extends State<MainConfigScreen> {
  //final int isolateId = Isolate.current.hashCode;

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppStyles.colors.mantis,
        appBar: AppBar(
          // leading: exit application
          leading: Padding(
            padding: EdgeInsets.only(left: 18, right: 8),
            child: CircleAvatar(
              backgroundColor: AppStyles.colors.mantis[700],
              child: GestureDetector(
                onTap: () async {
                  developer.log(
                    "End application button clicked!",
                    level: Level.FINER.value,
                  );
                  final alertDialog = AlertDialog(
                    title: Text(t.exitApplication),
                    content: Text(t.askExitApplication),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(t.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(t.yes),
                      ),
                    ],
                  );
                  await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return alertDialog;
                    },
                  ).then((b) async {
                    if ((b ?? false) && context.mounted) {
                      while (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                      await Future.delayed(
                        GlobalConstants.veryLongDelayForOperation,
                        () async {
                          developer.log(
                            "Pop screen: "
                            "Exit App button",
                            level: Level.INFO.value,
                          );
                          await SystemNavigator.pop();
                          developer.log(
                            "Exit application",
                            level: Level.INFO.value,
                          );
                          if (kDebugMode) exit(0); // kDebugMode
                        },
                      );
                    }
                  });
                },
                child: Icon(Icons.close, color: AppStyles.colors.forestGreen),
              ),
            ),
          ),
          backgroundColor: AppStyles.colors.ochre[700],
          title: Center(
            child: Text(t.appTitle, style: AppStyles.constFonts.display),
          ),
          elevation: 4,
          actions:
              kDebugMode
                  ? <Widget>[
                    TextButton(
                      onPressed: () async {
                        developer.log(
                          "Debug screen button clicked! ",
                          level: Level.FINER.value,
                        );
                        await Navigator.push(
                          context,
                          MaterialPageRoute<DebugConfigScreen>(
                            builder: (context) => DebugConfigScreen(),
                          ),
                        );
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
                        backgroundColor: WidgetStateProperty.all(
                          AppStyles.colors.forestGreen,
                        ),
                        foregroundColor: WidgetStateProperty.all(
                          AppStyles.colors.darkSlateGray,
                        ),
                      ),
                      child: const Icon(Icons.adb),
                    ),
                  ]
                  : null,
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            final bool isWttFullyDefined = context.select(
              (ConfigPreferences cp) => cp.generalSettings.wtt.isFullyDefined,
            );
            return GridView.count(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              scrollDirection: Axis.vertical,
              childAspectRatio:
                  orientation == Orientation.portrait ? 2 / 1 : 4 / 1,
              padding: EdgeInsets.all(12.0),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              addSemanticIndexes: false,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              children: [
                // alarm preferences
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<AlarmPreferencesScreen>(
                        builder: (context) => AlarmPreferencesScreen(),
                      ),
                    );
                  },
                  style: AppStyles.customButtonStyle,
                  icon: const Icon(Icons.edit_notifications),
                  label: Text(t.alarmSettings),
                  iconAlignment: IconAlignment.start,
                ),
                // before/after meal timings
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<TimePreferencesScreen>(
                        builder: (context) => TimePreferencesScreen(),
                      ),
                    );
                  },
                  style: AppStyles.customButtonStyle,
                  icon: const Icon(Icons.hourglass_full),
                  label: Text(t.timeSettings),
                  iconAlignment: IconAlignment.start,
                ),
                // meal durations
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<MealDurationsAdjustmentScreen>(
                        builder: (context) => MealDurationsAdjustmentScreen(),
                      ),
                    );
                  },
                  style: AppStyles.customButtonStyle,
                  icon: const Icon(Icons.flatware),
                  label: Text(t.timeEating),
                  iconAlignment: IconAlignment.start,
                ),
                // config weekdays
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Positioned.fill(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<ConfigMealsScreen>(
                              builder: (context) => ConfigMealsScreen(),
                            ),
                          );
                        },
                        style: AppStyles.customButtonStyle,
                        icon: const Icon(Symbols.calendar_clock),
                        label: Text(t.weeklyTimetable),
                        iconAlignment: IconAlignment.start,
                      ),
                    ),
                    if (!isWttFullyDefined)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(end: 25),
                          child: Wrap(
                            spacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(
                                Icons.warning,
                                color: AppStyles.colors.forestGreen,
                              ),
                              Text(
                                t.notFullyDefined,
                                style: AppStyles.constFonts.body,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                // config pill meals
                ElevatedButton.icon(
                  onPressed:
                      isWttFullyDefined
                          ? () {
                            // TODO: Meals for pills screen
                            /*
                    Navigator.push(
                      context,
                      MaterialPageRoute<ConfigMealsScreen>(
                        builder: (context) => ConfigMealsScreen(),
                      ),
                    );
                    */
                          }
                          : null,
                  style: AppStyles.customButtonStyle,
                  icon: const Icon(Symbols.pill_off),
                  label: Text(t.mealsForPills),
                  iconAlignment: IconAlignment.start,
                ),
                // alarm list
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<AlarmListScreen>(
                        builder: (context) => AlarmListScreen(),
                      ),
                    );
                  },
                  style: AppStyles.customButtonStyle,
                  icon: const Icon(Icons.notifications),
                  label: Text(t.alarms),
                  iconAlignment: IconAlignment.start,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
