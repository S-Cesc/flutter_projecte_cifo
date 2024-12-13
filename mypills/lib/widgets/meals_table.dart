// Flutter
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../styles/app_styles.dart';
import '../model/meal.dart';
import '../providers/config_preferences.dart';

class MealsTable extends StatefulWidget {
  final bool defaultMeals;
  final bool locked;
  //final Future<void> Function(WeeklyTimeTable wtt) saveValues;

  const MealsTable({
    super.key,
    required this.defaultMeals,
    //required this.saveValues,
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
    _localizations = //await AppLocalizations.of(context);
        await AppLocalizations.delegate.load(Localizations.localeOf(context));
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) _initializeLocale(context);
    return Consumer<ConfigPreferences>(
      builder: (context, prefs, child) {
        final f = NumberFormat("00");
        var meals = widget.defaultMeals
            ? prefs.alarmSettings.wtt.defaultDaysMeals
            : prefs.alarmSettings.wtt.specialDaysMeals;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  widget.defaultMeals
                      ? _localizations.defaultWeeklyTimetable
                      : _localizations.specialWeeklyTimetable,
                  textAlign: TextAlign.center,
                  style: AppStyles.fonts.headline(),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: ListView(
                children: List.generate(Meal.values.length, (v) {
                  //if (v < Meal.values.length) {
                  final meal = Meal.fromOrdinal(v + 1);
                  var mealTime = prefs.alarmSettings.wtt
                          .mealTime(meal, !widget.defaultMeals) ??
                      Meal.defaultMealTime(meal);
                  return CheckboxListTile(
                    title: Text(meal.mealName(_localizations)),
                    value: meals.containsKey(meal),
                    onChanged: (bool? value) {
                      if (!widget.locked) {
                        setState(() {
                          if (value ?? false) {
                            meals[meal] = mealTime;
                          } else {
                            meals.remove(meal);
                          }
                        });
                      }
                    },
                    secondary: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppStyles.colors.ochre,
                            border: Border.all(color: AppStyles.colors.ochre),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                              "${f.format(mealTime.hour)}:${f.format(mealTime.minute)}",
                              style: AppStyles.fonts.labelInverseLarge()),
                        ),
                      ),
                      onTap: () async {
                        if (!widget.locked && meals.containsKey(meal)) {
                          var value = await showTimePicker(
                            context: context,
                            initialTime: mealTime,
                            initialEntryMode: TimePickerEntryMode.dialOnly,
                          );
                          if (value != null) {
                            setState(() {
                              prefs.alarmSettings.wtt.defineMealTime(
                                  meal, value, !widget.defaultMeals);
                              meals[meal] = value;
                              mealTime = value;
                            });
                          }
                        }
                      },
                    ),
                  );
                }, growable: false),
              ),
            ),
          ],
        );
      },
    );
  }
}
