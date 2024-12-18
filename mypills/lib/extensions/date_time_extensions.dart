import 'package:flutter/material.dart';

/// Precission for the DateTime round operation
enum RoundTimeTo {
  /// Round the value of the minutes
  minute,

  /// Round the value of the seconds, exact value for minutes
  second,
}

/// Days without time, and other extensions
extension DateTimeExtensions on DateTime {
  /// DateTime.now() with hour, minute, second... set to zero
  static DateTime today() {
    return DateTime.now().date();
  }

  /// Next day of DateTime.today()
  static DateTime tomorrow() {
    return today().add(const Duration(days: 1));
  }

  /// DateTime.today with specific TimeOfDay (Hour and minute)
  static DateTime todayAt(TimeOfDay time) {
    return today().at(time);
  }

  /// DateTime.tomorrow with specific TimeOfDay (Hour and minute)
  static DateTime tomorrowAt(TimeOfDay time) {
    return tomorrow().at(time);
  }

  /// Is the TimeOfDay today at future... or it won't happen until tomorrow ?
  /// It checks the time using minute precission
  static bool isToday(TimeOfDay time) {
    final now = DateTime.now().round();
    return now.hour < time.hour ||
        now.hour == time.hour && now.minute < time.minute ||
        now.hour == time.hour && now.minute <= time.minute;
  }

  /// The date without time
  DateTime date() {
    return DateTime(year, month, day);
  }

  /// The data at a specific TimeOfDay
  DateTime at(TimeOfDay time) {
    return date().add(Duration(hours: time.hour, minutes: time.minute));
  }

  /// Round DateTime to precission of minutes or seconds
  DateTime round([RoundTimeTo precission = RoundTimeTo.minute]) {
    final s = (precission == RoundTimeTo.second
        ? second + (millisecond >= 500 ? 1 : 0)
        : 0);
    final m = minute +
        (precission == RoundTimeTo.minute ? (second >= 30 ? 1 : 0) : 0);
    return DateTime(
      year,
      month,
      day,
      hour,
      m,
      s,
    );
  }
}
