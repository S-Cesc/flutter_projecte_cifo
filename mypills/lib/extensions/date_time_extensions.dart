import 'package:flutter/material.dart';

extension DateTimeExtensions on DateTime {

  /// DateTime.now() with hour, minute, second... set to zero
  static DateTime today() {
    return DateTime.now().dateBeginning();
  }

  /// Next day of DateTime.today()
  static DateTime tomorrow() {
    return DateTime.now().add(const Duration(days: 1)).dateBeginning();
  }

  /// DateTime.today with specific TimeOfDay (Hour and minute)
  static DateTime todayAt(TimeOfDay time) {
    var todayDate = today();
    return todayDate.add(Duration(hours: time.hour, minutes: time.minute));
  }

  /// DateTime.tomorrow with specific TimeOfDay (Hour and minute)
  static DateTime tomorrowAt(TimeOfDay time) {
    var tomorrowDate = today();
    return tomorrowDate.add(Duration(hours: time.hour, minutes: time.minute));
  }

  /// Is the TimeOfDay today at future... or it won't happen until tomorrow ?
  static bool isToday(TimeOfDay time) {
    var now = DateTime.now();
    return now.hour < time.hour ||
        now.hour == time.hour && now.minute <= time.minute;
  }

  /// The date without time
  DateTime dateBeginning() {
    return DateTime(year, month, day);
  }

  // The data at a specific TimeOfDay
  DateTime at(TimeOfDay time) {
    return dateBeginning()
        .add(Duration(hours: time.hour, minutes: time.minute));
  }

}
