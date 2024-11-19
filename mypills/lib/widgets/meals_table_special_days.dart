// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart
import 'package:intl/intl.dart';
// Flutter
import 'package:day_picker/day_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Project files
import 'meals_table.dart';
import '../model/enums.dart';
import '../model/weekly_time_table.dart';
import '../providers/config_preferences.dart';

class MealsTableSpecialDays extends StatefulWidget {
  final Future<void> Function(WeeklyTimeTable wtt) saveValues;

  const MealsTableSpecialDays({super.key, required this.saveValues});

  @override
  State<MealsTableSpecialDays> createState() => _MealsTableSpecialDaysState();
}

class _MealsTableSpecialDaysState extends State<MealsTableSpecialDays> {
  bool _isInitialized = false;
  late List<String> weekDayNames;

  void _initialize() {
    weekDayNames = DateFormat.E(Localizations.localeOf(context).languageCode)
        .dateSymbols
        .STANDALONESHORTWEEKDAYS;
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) _initialize();
    return Consumer<ConfigPreferences>(builder: (context, prefs, child) {
      Set<DayOfWeek> specialWeekDays = prefs.alarmSettings.wtt.specialWeekDays;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SelectWeekDays(
            days: _days(weekDayNames, specialWeekDays),
            onSelect: (days) {
              setState(() {
                for (int d = 1; d <= 7; d++) {
                  if (days.contains(d.toString())) {
                    specialWeekDays.add(DayOfWeek.fromId(d));
                  } else {
                    specialWeekDays.remove(DayOfWeek.fromId(d));
                  }
                }
              });
            },
          ),
          Expanded(
            child: MealsTable(
              defaultMeals: false,
              saveValues: widget.saveValues,
            ),
          ),
        ]),
      );
    });
  }

  List<DayInWeek> _days(List<String> weekDayNames, Set<DayOfWeek> value) {
    List<DayInWeek> result = <DayInWeek>[
      DayInWeek(weekDayNames[1],
          dayKey: "1", isSelected: value.contains(DayOfWeek.fromId(1))),
      DayInWeek(weekDayNames[2],
          dayKey: "2", isSelected: value.contains(DayOfWeek.fromId(2))),
      DayInWeek(weekDayNames[3],
          dayKey: "3", isSelected: value.contains(DayOfWeek.fromId(3))),
      DayInWeek(weekDayNames[4],
          dayKey: "4", isSelected: value.contains(DayOfWeek.fromId(4))),
      DayInWeek(weekDayNames[5],
          dayKey: "5", isSelected: value.contains(DayOfWeek.fromId(5))),
      DayInWeek(weekDayNames[6],
          dayKey: "6", isSelected: value.contains(DayOfWeek.fromId(6))),
      DayInWeek(weekDayNames[0],
          dayKey: "7", isSelected: value.contains(DayOfWeek.fromId(7))),
    ];
    return result;
  }
}
