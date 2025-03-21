// logging and debugging
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:logging/logging.dart' show Level;

// Flutter
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// Localization
import '../l10n/app_localizations.dart';
// Project files
import '../model/weekly_time_table.dart';
import '../model/enum/speed_label.dart';
import '../styles/app_styles.dart';
import '../model/enum/meal.dart';
import '../providers/config_preferences.dart';

/// Widget to edit a WeeklyTimeTable component
/// either the default one or one of the defined partitions
class MealsTable extends StatefulWidget {
  /// the partition edited; null for the default one
  final int? mealsPartition;

  /// Lock the widget to disable edit
  final bool locked;

  /// Ctor
  const MealsTable({
    super.key,
    required this.mealsPartition,
    this.locked = false,
  });

  @override
  State<MealsTable> createState() => _MealsTableState();
}

class _MealsTableState extends State<MealsTable> {
  late AppLocalizations _localizations;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  void _initializeLocale(BuildContext context) async {
    _localizations =
        AppLocalizations.of(context) ??
        await AppLocalizations.delegate.load(Localizations.localeOf(context));
    // Use of
    // await AppLocalizations.delegate.load
    // instead of
    // await AppLocalizations.of(context);
    // which requires Material app has to actually
    // be started to initialize AppLocalizations.
    // If the app hasn't yet started, AppLocalizations.of(context)!
    // causes a null exception.
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) _initializeLocale(context);
    EditProviderWeeklyTimeTable wtt = Provider.of<EditProviderWeeklyTimeTable>(
      context,
    );
    return Consumer<ConfigPreferences>(
      builder: (context, prefs, _) {
        final f = NumberFormat("00");
        var meals =
            (widget.mealsPartition != null)
                ? wtt.specialDaysMeals(widget.mealsPartition!)
                : wtt.defaultDaysMeals;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Text(
                  widget.mealsPartition == null
                      ? _localizations.defaultWeeklyTimetable
                      : _localizations.specialWeeklyTimetable,
                  textAlign: TextAlign.center,
                  style: AppStyles.constFonts.headline,
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: ListView(
                children: List.generate(Meal.values.length + 1, (v) {
                  if (v < Meal.values.length) {
                    final meal = Meal.fromOrdinal(v + 1);
                    var mealTime =
                        wtt.mealTime(meal, widget.mealsPartition) ??
                        Meal.defaultMealTime(meal);
                    var mealSpeed =
                        wtt.mealSpeed(meal, widget.mealsPartition) ??
                        Meal.defaultMealSpeed;
                    return CheckboxListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 160,
                            child: Text(
                              meal.localeName(_localizations),
                              style:
                                  meals.containsKey(meal)
                                      ? AppStyles.fonts.labelSmall()
                                      : AppStyles.fonts.labelSmallDisabled(),
                              softWrap: true,
                            ),
                          ),
                          Spacer(),
                          DropdownButton<SpeedLabel>(
                            menuWidth: 70,
                            padding: EdgeInsets.all(0),
                            items:
                                SpeedLabel.values.map<
                                  DropdownMenuItem<SpeedLabel>
                                >((SpeedLabel speed) {
                                  final txt =
                                      context
                                          .select<ConfigPreferences, Duration>(
                                            (ConfigPreferences p) => p
                                                .generalSettings
                                                .data
                                                .getMealDuration(meal, speed),
                                          )
                                          .inMinutes
                                          .toString();
                                  return DropdownMenuItem<SpeedLabel>(
                                    value: speed,
                                    child: Text(
                                      "$txt '",
                                      style: AppStyles.fonts.body(),
                                    ),
                                  );
                                }).toList(),
                            value: mealSpeed,
                            onChanged:
                                widget.locked || !meals.containsKey(meal)
                                    ? null
                                    : (SpeedLabel? value) {
                                      if (value != null) {
                                        setState(() {
                                          wtt.defineMealSpeed(
                                            context,
                                            meal,
                                            value,
                                            widget.mealsPartition,
                                          );
                                          mealSpeed = value;
                                          // Debug check
                                          if (kDebugMode) {
                                            developer.log(
                                              "Dropdown changed! $value",
                                              level: Level.FINER.value,
                                            );
                                            developer.log(
                                              "Local value: "
                                              "$meal = ${meals[meal]}",
                                              level: Level.FINER.value,
                                            );
                                            final dMealTime = wtt.mealTime(
                                              meal,
                                              widget.mealsPartition,
                                            );
                                            final dMealSpeed = wtt.mealSpeed(
                                              meal,
                                              widget.mealsPartition,
                                            );
                                            // check store object already updated
                                            developer.log(
                                              "Store Value: "
                                              "$meal = ($dMealTime, $dMealSpeed)",
                                              level: Level.FINER.value,
                                            );
                                            // Values from the same object !!
                                            assert(
                                              meals[meal] == null ||
                                                  meals[meal] ==
                                                      (dMealTime, dMealSpeed),
                                            );
                                          }
                                        });
                                      }
                                    },
                          ),
                        ],
                      ),
                      value: meals.containsKey(meal),
                      onChanged:
                          widget.locked
                              ? null
                              : (bool? value) {
                                if (value != null) {
                                  setState(() {
                                    if (value && !meals.containsKey(meal)) {
                                      wtt.defineMeal(context, meal, (
                                        mealTime,
                                        mealSpeed,
                                      ), widget.mealsPartition);
                                    } else if (!value &&
                                        meals.containsKey(meal)) {
                                      wtt.removeMeal(
                                        context,
                                        meal,
                                        widget.mealsPartition,
                                      );
                                    }
                                    // Debug check
                                    if (kDebugMode) {
                                      // Local value
                                      if (meals.containsKey(meal)) {
                                        developer.log(
                                          "Local value: "
                                          "$meal = ${meals[meal]}",
                                          level: Level.FINER.value,
                                        );
                                      } else {
                                        developer.log(
                                          "Local meal $meal has been removed.",
                                          level: Level.FINER.value,
                                        );
                                      }
                                      // Store value
                                      if (wtt.isMealDefined(meal)) {
                                        final dMealTime = wtt.mealTime(
                                          meal,
                                          widget.mealsPartition,
                                        );
                                        final dMealSpeed = wtt.mealSpeed(
                                          meal,
                                          widget.mealsPartition,
                                        );
                                        developer.log(
                                          "Store Value: "
                                          "$meal = ($dMealTime, $dMealSpeed)",
                                          level: Level.FINER.value,
                                        );
                                      } else {
                                        developer.log(
                                          "Store meal $meal has no entry.",
                                          level: Level.FINER.value,
                                        );
                                      }
                                    }
                                  });
                                }
                              },
                      secondary: InkWell(
                        onTap:
                            widget.locked || !meals.containsKey(meal)
                                ? null
                                : () async {
                                  var value = await showTimePicker(
                                    context: context,
                                    initialTime: mealTime,
                                    initialEntryMode:
                                        TimePickerEntryMode.dialOnly,
                                  );
                                  if (value != null) {
                                    setState(() {
                                      wtt.defineMealTime(
                                        context,
                                        meal,
                                        value,
                                        widget.mealsPartition,
                                      );
                                      mealTime = value;
                                      // Debug check
                                      if (kDebugMode) {
                                        final dMealTime = wtt.mealTime(
                                          meal,
                                          widget.mealsPartition,
                                        );
                                        final dMealSpeed = wtt.mealSpeed(
                                          meal,
                                          widget.mealsPartition,
                                        );
                                        // check store object already updated
                                        developer.log(
                                          "Local value: "
                                          "$meal = ${meals[meal]}",
                                          level: Level.FINER.value,
                                        );
                                        developer.log(
                                          "Store Value: "
                                          "$meal = ("
                                          "$dMealTime, "
                                          "$dMealSpeed)",
                                          level: Level.FINER.value,
                                        );
                                        // Values from the same object !!
                                        assert(
                                          meals[meal] == null ||
                                              meals[meal] ==
                                                  (dMealTime, dMealSpeed),
                                        );
                                      }
                                    });
                                  }
                                },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                meals.containsKey(meal)
                                    ? AppStyles.colors.ochre
                                    : AppStyles.colors.ochreDisabled,
                            border: Border.all(
                              color:
                                  meals.containsKey(meal)
                                      ? AppStyles.colors.ochre
                                      : AppStyles.colors.ochreDisabled,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(7),
                            child: Text(
                              "${f.format(mealTime.hour)}:"
                              "${f.format(mealTime.minute)}",
                              style:
                                  meals.containsKey(meal)
                                      ? AppStyles.constFonts.labelInverseLarge
                                      : AppStyles
                                          .constFonts
                                          .labelInverseLargeDisabled,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    TimeOfDay timeToSleep = wtt.getTimeToSleep(
                      widget.mealsPartition,
                    );
                    return CheckboxListTile(
                      title: Text("Going to sleep"),
                      value: true,
                      onChanged: null,
                      secondary: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppStyles.colors.ochre,
                            border: Border.all(color: AppStyles.colors.ochre),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(7),
                            child: Text(
                              "${f.format(timeToSleep.hour)}:"
                              "${f.format(timeToSleep.minute)}",
                              style: AppStyles.constFonts.labelInverseLarge,
                            ),
                          ),
                        ),
                        onTap: () async {
                          var value = await showTimePicker(
                            context: context,
                            initialTime: timeToSleep,
                            initialEntryMode: TimePickerEntryMode.dialOnly,
                          );
                          if (value != null) {
                            setState(() {
                              wtt.setTimeToSleep(
                                context,
                                value,
                                widget.mealsPartition,
                              );
                            });
                            developer.log(
                              "Time to sleep changed! $value",
                              level: Level.FINER.value,
                            );
                          }
                        },
                      ),
                    );
                  }
                }, growable: false),
              ),
            ),
          ],
        );
      },
    );
  }
}
