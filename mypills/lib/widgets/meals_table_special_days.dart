// Dart
import 'package:intl/intl.dart';
// Flutter
import 'package:day_picker/day_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Localization
import '../l10n/app_localizations.dart';
// Project files
import '../model/weekly_time_table.dart';
import 'meals_table.dart';
import '../model/enum/day_of_week_bitset.dart';
import '../model/enum/day_of_week.dart';
import '../providers/config_preferences.dart';

/// Meals time table for specific days
class MealsTableSpecialDays extends StatefulWidget {
  /// Partition which is referenced to
  final int partitionNumber;

  /// Ctor
  const MealsTableSpecialDays({
    super.key,
    required this.partitionNumber,
  });

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

    EditProviderWeeklyTimeTable wtt = Provider.of<EditProviderWeeklyTimeTable>(
      context,
    );


    // private local function
    List<DayInWeek> computeSelectedWeekdays() {
      final DayOfWeekBitset selectedWeekdays = wtt
          .partitionWeekdays(widget.partitionNumber);
      // SelectWeekDays widget format for selectedWeekDays
      final List<DayInWeek> currentSelectedWeekdays = [
        DayInWeek(
          weekDayNames[1],
          dayKey: "1",
          isSelected: selectedWeekdays[DayOfWeek.fromId(1)],
        ), // .contains(DayOfWeek.fromId(1))),
        DayInWeek(
          weekDayNames[2],
          dayKey: "2",
          isSelected: selectedWeekdays[DayOfWeek.fromId(2)],
        ),
        DayInWeek(
          weekDayNames[3],
          dayKey: "3",
          isSelected: selectedWeekdays[DayOfWeek.fromId(3)],
        ),
        DayInWeek(
          weekDayNames[4],
          dayKey: "4",
          isSelected: selectedWeekdays[DayOfWeek.fromId(4)],
        ),
        DayInWeek(
          weekDayNames[5],
          dayKey: "5",
          isSelected: selectedWeekdays[DayOfWeek.fromId(5)],
        ),
        DayInWeek(
          weekDayNames[6],
          dayKey: "6",
          isSelected: selectedWeekdays[DayOfWeek.fromId(6)],
        ),
        DayInWeek(
          weekDayNames[0],
          dayKey: "7",
          isSelected: selectedWeekdays[DayOfWeek.fromId(7)],
        ),
      ];
      return currentSelectedWeekdays;
    }

    if (!_isInitialized) _initialize();
    return Consumer<ConfigPreferences>(
      builder: (context, prefs, child) {
        final List<DayInWeek> currentSelectedWeekdays = computeSelectedWeekdays();
        final Key refreshKey = UniqueKey();

        //Weekdays onSelect update selectedWeekDays
        void updateWeekdays(List<String> days) {
          final weekDays =
              days.map((x) => DayOfWeek.fromId(int.parse(x))).toSet();
          wtt.defineSpecialWeekDays(
            weekDays,
            widget.partitionNumber,
          );
          if (wtt.modified) {
            setState(() {
            });
          }
        }

        //Consumer builder return value
        return OrientationBuilder(
          builder: (context, orientation) {
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
                      padding: EdgeInsets.only(left: 5),
                      child: MealsTable(
                        mealsPartition: widget.partitionNumber,
                        locked: false, //selectedWeekDays.isEmpty,
                      ),
                    ),
                  ),
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
                          padding: EdgeInsets.only(left: 10, top: 60),
                          child: SelectWeekDays(
                            days: currentSelectedWeekdays,
                            onSelect: updateWeekdays,
                            key: refreshKey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                        right: 20,
                        bottom: 20,
                        left: 40,
                      ),
                      child: MealsTable(
                        mealsPartition: widget.partitionNumber,
                        locked: false, //selectedWeekDays.isEmpty,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}
