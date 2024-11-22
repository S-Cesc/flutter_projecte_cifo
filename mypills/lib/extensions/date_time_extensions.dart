import 'package:flutter/material.dart';

extension DateTimeExtensions on DateTime {
  static DateTime today() {
    return DateTime.now().dateBeginning();
  }

  static DateTime tomorrow() {
    return DateTime.now().add(const Duration(days: 1)).dateBeginning();
  }

  static DateTime todayAt(TimeOfDay time) {
    var todayDate = today();
    return todayDate.add(Duration(hours: time.hour, minutes: time.minute));
  }

  static DateTime tomorrowAt(TimeOfDay time) {
    var tomorrowDate = today();
    return tomorrowDate.add(Duration(hours: time.hour, minutes: time.minute));
  }

  static bool isToday(TimeOfDay time) {
    var now = DateTime.now();
    return now.hour < time.hour ||
        now.hour == time.hour && now.minute <= time.minute;
  }

  DateTime dateBeginning() {
    return DateTime(year, month, day);
  }

  DateTime at(TimeOfDay time) {
    return dateBeginning()
        .add(Duration(hours: time.hour, minutes: time.minute));
  }

}
