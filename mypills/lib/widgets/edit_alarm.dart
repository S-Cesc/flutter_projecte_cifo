// Flutter
import 'package:flutter/material.dart';
// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../model/meal.dart';
import '../model/pill_meal_time.dart';
import '../styles/app_styles.dart';

class EditAlarm extends StatefulWidget {
  const EditAlarm({super.key});

  @override
  State<EditAlarm> createState() => _EditAlarmState();
}

class _EditAlarmState extends State<EditAlarm> {
  late AppLocalizations _localizations;
  bool _isInitialized = false;
  Meal? mealValue;
  PillMealTime? pillMealTimeValue;

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
    return Column(
      children: [
        Text(
          mealValue?.mealName(_localizations) ?? "",
          style: AppStyles.fonts.labelSmall(),
        ),
        DropdownButton<Meal>(
          value: mealValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (Meal? value) {
            // This is called when the user selects an item.
            setState(() {
              mealValue = value!;
            });
          },
          items: Meal.values.map<DropdownMenuItem<Meal>>((Meal value) {
            return DropdownMenuItem<Meal>(
              value: value,
              child: Text(value.mealName(_localizations)),
            );
          }).toList(),
        ),
        //----------------------------------
        const Divider(
          height: 20,
          thickness: 5,
          indent: 20,
          endIndent: 0,
          color: Colors.black,
        ),
        //----------------------------------
        Text(
          pillMealTimeValue?.pillTimeName(
                  mealValue ?? Meal.breakfast, _localizations) ??
              "",
          style: AppStyles.fonts.labelSmall(),
        ),
        DropdownButton<PillMealTime>(
          value: pillMealTimeValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (PillMealTime? value) {
            // This is called when the user selects an item.
            setState(() {
              pillMealTimeValue = value!;
            });
          },
          items: PillMealTime.values
              .map<DropdownMenuItem<PillMealTime>>((PillMealTime value) {
            return DropdownMenuItem<PillMealTime>(
              value: value,
              child: Text(value.pillTimeName(
                  mealValue ?? Meal.breakfast, _localizations)),
            );
          }).toList(),
        ),
      ],
    );
  }
}
