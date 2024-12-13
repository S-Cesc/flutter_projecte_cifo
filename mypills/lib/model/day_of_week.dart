// SIMPLE ENUMS. No imports
import 'package:intl/intl.dart' show DateFormat; // localization

//==============================================================================

/// Days of the week; Monday=1 ... Sunday=7
enum DayOfWeek {
  /// Monday=1
  monday(1),

  /// Tuesday=2
  tuesday(2),

  /// Wednesday=3
  wednesday(3),

  /// Thursday=4
  thursday(4),

  /// Friday=5
  friday(5),

  /// Saturday=6
  saturday(6),

  /// Sunday=7
  sunday(7);

  /// Localized name
  static Future<String> dayOfWeekName(DayOfWeek wd) async {
    final weekdays = DateFormat().dateSymbols.WEEKDAYS;
    return weekdays[wd.id % 7];
  }

  /// Localized short name
  static Future<String> dayOfWeekShortName(DayOfWeek wd) async {
    final weekdays = DateFormat().dateSymbols.SHORTWEEKDAYS;
    return weekdays[wd.id % 7];
  }

  //-----------------class state members and constructors ----------------------

  /// DayOfWeek sequence: ISO-8601 requires starting on monday with value=1
  final int id;

  const DayOfWeek(this.id);

  /// DayOfWeek: acording to ISO-8601 values in the range [1..7]
  factory DayOfWeek.fromId(int id) {
    return switch (id) {
      1 => monday,
      2 => tuesday,
      3 => wednesday,
      4 => thursday,
      5 => friday,
      6 => saturday,
      7 => sunday,
      _ => throw RangeError.range(id, 1, 7)
    };
  }

  /// DayOfWeek of a date
  factory DayOfWeek.fromDate(DateTime d) {
    return DayOfWeek.fromId(d.weekday);
  }

  //-----------------------class special members--------------------------------

  /// Next day of week (circular: sunday turns again into monday)
  DayOfWeek next() {
    return DayOfWeek.fromId((id % 7) + 1);
  }
}

//==============================================================================

