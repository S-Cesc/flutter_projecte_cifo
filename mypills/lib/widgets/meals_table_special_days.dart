// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart
import 'package:intl/intl.dart';
// Flutter
import 'package:day_picker/day_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../styles/app_styles.dart';
import 'meals_table.dart';
import '../model/enums.dart';
import '../providers/config_preferences.dart';

/// Meals time table for specific days
class MealsTableSpecialDays extends StatefulWidget {
  /// Save values callback
  final Future<void> Function() saveValues;

  /// Requery data callback to undo changes
  final Future<void> Function() requery;

  /// Ctor
  const MealsTableSpecialDays(
      {super.key, required this.requery, required this.saveValues});

  @override
  State<MealsTableSpecialDays> createState() => _MealsTableSpecialDaysState();
}

class _MealsTableSpecialDaysState extends State<MealsTableSpecialDays> {
  late List<String> weekDayNames;
  late AppLocalizations t;
  bool _isInitialized = false;

  void _initialize() {
    // Material app has to actually be started to initialize AppLocalizations.
    // Anywhere, you cannot access current App Locale during initState
    // (more concrete: before it completed).
    Locale loc = Localizations.localeOf(context);
    weekDayNames =
        DateFormat.E(loc.languageCode).dateSymbols.STANDALONESHORTWEEKDAYS;
    t = AppLocalizations.of(context)!; // only null when there's no object
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) _initialize();
    return Consumer<ConfigPreferences>(builder: (context, prefs, child) {
      final Set<DayOfWeek> selectedWeekDays =
          prefs.alarmSettings.wtt.specialWeekDays;
      // SelectWeekDays widget format for selectedWeekDays
      final List<DayInWeek> currentSelectedWeekdays = [
        DayInWeek(weekDayNames[1],
            dayKey: "1",
            isSelected: selectedWeekDays.contains(DayOfWeek.fromId(1))),
        DayInWeek(weekDayNames[2],
            dayKey: "2",
            isSelected: selectedWeekDays.contains(DayOfWeek.fromId(2))),
        DayInWeek(weekDayNames[3],
            dayKey: "3",
            isSelected: selectedWeekDays.contains(DayOfWeek.fromId(3))),
        DayInWeek(weekDayNames[4],
            dayKey: "4",
            isSelected: selectedWeekDays.contains(DayOfWeek.fromId(4))),
        DayInWeek(weekDayNames[5],
            dayKey: "5",
            isSelected: selectedWeekDays.contains(DayOfWeek.fromId(5))),
        DayInWeek(weekDayNames[6],
            dayKey: "6",
            isSelected: selectedWeekDays.contains(DayOfWeek.fromId(6))),
        DayInWeek(weekDayNames[0],
            dayKey: "7",
            isSelected: selectedWeekDays.contains(DayOfWeek.fromId(7))),
      ];
      Key refreshKey = UniqueKey();

      //Weekdays onSelect update selectedWeekDays
      void updateWeekdays(List<String> days) {
        setState(() {
          for (int d = 1; d <= 7; d++) {
            if (days.contains(d.toString())) {
              selectedWeekDays.add(DayOfWeek.fromId(d));
            } else {
              selectedWeekDays.remove(DayOfWeek.fromId(d));
            }
          }
        });
        developer.log("selected days: ${days.toString()}",
            level: Level.FINE.value);
      }

      //Action buttons: Undo / Save
      Widget actionButtonsWidget() {
        return Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: AppStyles.customButtonStyle,
                onPressed: () async {
                  await widget.requery();
                  setState(() {
                    refreshKey = UniqueKey();
                  });
                },
                child: Text(t.undoChanges),
              ),
              ElevatedButton(
                style: AppStyles.customButtonStyle,
                onPressed: () async {
                  await widget.saveValues();
                },
                child: Text(t.saveChanges),
              ),
            ],
          ),
        );
      }

      //Consumer builder return value
      return OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SelectWeekDays(
                  days: currentSelectedWeekdays,
                  onSelect: updateWeekdays,
                  key: refreshKey,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: MealsTable(
                    defaultMeals: false,
                    locked: selectedWeekDays.isEmpty,
                  ),
                ),
              ),
              actionButtonsWidget(),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: SelectWeekDays(
                        days: currentSelectedWeekdays,
                        onSelect: updateWeekdays,
                        key: refreshKey,
                      ),
                    ),
                    Spacer(),
                    actionButtonsWidget(),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  child: MealsTable(
                    defaultMeals: false,
                    locked: selectedWeekDays.isEmpty,
                  ),
                ),
              ),
            ],
          );
        }
      });
    });
  }
}
