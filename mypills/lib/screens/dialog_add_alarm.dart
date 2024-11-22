// Flutter
import 'package:flutter/material.dart';
// Localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../styles/app_styles.dart';
import '../model/alarm.dart';
import '../model/meal.dart';
import '../model/pill_meal_time.dart';

class DialogAddAlarm extends StatefulWidget {
  const DialogAddAlarm({super.key});

  @override
  State<DialogAddAlarm> createState() => _DialogAddAlarmState();
}

class _DialogAddAlarmState extends State<DialogAddAlarm> {
  static const initialMeal = Meal.breakfast;
  static const initialPillMealTime = PillMealTime.at;
  Meal? _selectedMeal = initialMeal;
  PillMealTime? _selectedPillMealTime = initialPillMealTime;

  bool get _canSave {
    return _selectedMeal != null && _selectedPillMealTime != null;
  }

  void _setMeal(Meal? value) {
    if (value != _selectedMeal) {
      _selectedMeal = value;
      if (value != Meal.supper &&
          _selectedPillMealTime == PillMealTime.longAfter) {
        _setPillMealTime(_selectedPillMealTime);
      }
    }
  }

  void _setPillMealTime(PillMealTime? value) {
    if (value == PillMealTime.longAfter) {
      if (_selectedMeal != null) {
        if (_selectedMeal == Meal.supper) {
          _selectedPillMealTime = value;
        } else {
          _selectedMeal = _selectedMeal!.next();
          _selectedPillMealTime = PillMealTime.longBefore;
        }
      }
    } else {
      _selectedPillMealTime = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            t.createNewAlarm,
          ),
          backgroundColor: AppStyles.colors.ochre[700],
          elevation: 4,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppStyles.colors.forestGreen,
            ),
            onPressed: () {
              // Navigate back to the previous screen by popping the current route
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: _canSave
                  ? () {
                      Navigator.of(context).pop(
                          Alarm.empty(_selectedMeal!, _selectedPillMealTime!));
                    }
                  : null,
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
              child: Icon(Icons.add_alarm), // Text('ADD'),
            ),
          ]),
      body: SafeArea(
        child: Form(
          child: ListView(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: DropdownMenu<Meal>(
                    width: double.infinity,
                    initialSelection: initialMeal,
                    controller: null,
                    label: const Text('Meal'),
                    onSelected: (Meal? meal) {
                      setState(() {
                        _setMeal(meal);
                      });
                    },
                    dropdownMenuEntries:
                        Meal.values.map<DropdownMenuEntry<Meal>>((Meal meal) {
                      return DropdownMenuEntry<Meal>(
                        value: meal,
                        label: meal.name, // meal.mealName(t),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: DropdownMenu<PillMealTime>(
                    width: double.infinity,
                    initialSelection: initialPillMealTime,
                    controller: null,
                    label: const Text(
                        'Time for the mealtime pills'), //hora de las pastillas de la comida
                    onSelected: (PillMealTime? pillMealTime) {
                      setState(() {
                        _setPillMealTime(pillMealTime);
                      });
                    },
                    dropdownMenuEntries: PillMealTime.values
                        .map<DropdownMenuEntry<PillMealTime>>(
                            (PillMealTime pillMealTime) {
                      return DropdownMenuEntry<PillMealTime>(
                        value: pillMealTime,
                        label: pillMealTime.name, // pillMealTime.simpleName(t),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                      style: AppStyles.fonts.labelSmall(),
                      _canSave
                          ? _selectedPillMealTime!
                              .pillTimeName(_selectedMeal!, t)
                          : ""),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
