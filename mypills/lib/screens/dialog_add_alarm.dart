// Flutter
import 'package:flutter/material.dart';
// Localizations
import '../l10n/app_localizations.dart';
// Project files
import '../styles/app_styles.dart';
import '../model/alarm.dart';
import '../model/enum/meal.dart';
import '../model/enum/pill_meal_time.dart';
import '../widgets/custom_back_button.dart';

/// Dialog to add an alarm
class DialogAddAlarm extends StatefulWidget {
  /// Ctor
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(t.createNewAlarm),
          backgroundColor: AppStyles.colors.ochre[700],
          elevation: 4,
          leading: CustomBackButton(),
          actions: <Widget>[
            TextButton(
              onPressed:
                  _canSave
                      ? () {
                        Navigator.of(context).pop(
                          Alarm.empty(_selectedMeal!, _selectedPillMealTime!),
                        );
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
                backgroundColor: WidgetStateProperty.all(
                  AppStyles.colors.forestGreen,
                ),
                foregroundColor: WidgetStateProperty.all(
                  AppStyles.colors.darkSlateGray,
                ),
              ),
              child: Icon(Icons.add_alarm), // Text('ADD'),
            ),
          ],
        ),
        body: Form(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 16.0,
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: DropdownMenu<Meal>(
                    width: double.infinity,
                    initialSelection: initialMeal,
                    controller: null,
                    label: Text(t.meal),
                    onSelected: (Meal? meal) {
                      setState(() {
                        _setMeal(meal);
                      });
                    },
                    dropdownMenuEntries:
                        Meal.values.map<DropdownMenuEntry<Meal>>((Meal meal) {
                          return DropdownMenuEntry<Meal>(
                            value: meal,
                            label: meal.localeName(t),
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
                      'Time for the mealtime pills',
                    ), //hora de las pastillas de la comida
                    onSelected: (PillMealTime? pillMealTime) {
                      setState(() {
                        _setPillMealTime(pillMealTime);
                      });
                    },
                    dropdownMenuEntries:
                        PillMealTime.values
                            .map<DropdownMenuEntry<PillMealTime>>((
                              PillMealTime pillMealTime,
                            ) {
                              return DropdownMenuEntry<PillMealTime>(
                                value: pillMealTime,
                                label: pillMealTime.localeName(t),
                              );
                            })
                            .toList(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    style: AppStyles.constFonts.labelSmall,
                    _canSave
                        ? _selectedPillMealTime!.pillTimeName(t, _selectedMeal!)
                        : "",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
