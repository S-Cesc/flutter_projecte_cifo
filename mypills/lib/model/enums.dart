// SIMPLE ENUMS. No imports
import 'package:intl/intl.dart'; // localization: DateFormat

//==============================================================================

enum DayOfWeek {
  monday(1),
  tuesday(2),
  wednesday(3),
  thursday(4),
  friday(5),
  saturday(6),
  sunday(7);

  // TODO: NO FUTURE
  static Future<String> dayOfWeekName(DayOfWeek wd) async {
    final weekdays = DateFormat().dateSymbols.WEEKDAYS;
    return weekdays[wd.id % 7];
  }

  // TODO: NO FUTURE
  static Future<String> dayOfWeekShortName(DayOfWeek wd) async {
    final weekdays = DateFormat().dateSymbols.SHORTWEEKDAYS;
    return weekdays[wd.id % 7];
  }

  //-----------------class state members and constructors ----------------------

  // ISO-8601 requires starting on monday with value=1
  final int id;

  const DayOfWeek(this.id);

  factory DayOfWeek.fromId(int id) {
    return switch (id) {
      1 => monday,
      2 => tuesday,
      3 => wednesday,
      4 => thursday,
      5 => friday,
      6 => saturday,
      7 => sunday,
      _ => throw Error()
    };
  }

  factory DayOfWeek.fromDate(DateTime d) {
    return DayOfWeek.fromId(d.weekday);
  }

  //-----------------------class special members--------------------------------

  DayOfWeek next() {
    return DayOfWeek.fromId((id % 7) + 1);
  }
}

//==============================================================================

enum PrescriptionFrequency { dayly, weekly, fortnightly, monthly }
