import 'package:flutter/material.dart';
import 'package:clock/clock.dart';

//==============================================================================

/// Precission for the DateTime round operation
enum RoundTimeTo {
  /// Round the value to the minutes
  minute,

  /// Round the value to the seconds (exact value for minutes)
  second,
}

//==============================================================================

/// Days without time, and other extensions
extension DateTimeExtensions on DateTime {
  //
  //----------------------------------------------------------------------------
  //---------------------------------static/constant----------------------------

  /// DateTime.now() with hour, minute, second... set to zero
  static DateTime today() {
    return clock.now().date();
  }

  /// Next day of DateTime.today()
  static DateTime tomorrow() {
    return nextDay(clock.now());
  }

  /// The day before DateTime.today()
  static DateTime yesterday() {
    return theDayBefore(clock.now());
  }

  /// compute the next day of the date
  static DateTime nextDay(DateTime date) {
    // add 1 day and some hours to avoid DST problems
    const int minutesInADay = 24 * 60;
    const int maximumDstLoss = 65; //day saving time, including any leap seconds
    return date
        .date()
        .add(const Duration(minutes: minutesInADay + maximumDstLoss))
        .date();
  }

  /// compute the day before the date
  static DateTime theDayBefore(DateTime date) {
    // subtract 1 day minus some hours to avoid DST problems
    const int minutesInADay = 24 * 60;
    const int maximumDstLoss = 65; //day saving time, including any leap seconds
    return date
        .date()
        .subtract(const Duration(minutes: minutesInADay - maximumDstLoss))
        .date();
  }

  /// DateTime.today with specific TimeOfDay (Hour and minute)
  static DateTime todayAt(TimeOfDay time) {
    return today().at(time);
  }

  /// DateTime.tomorrow with specific TimeOfDay (Hour and minute)
  static DateTime tomorrowAt(TimeOfDay time) {
    return tomorrow().at(time);
  }

  /// Is today at future the time TimeOfDay ...
  /// ... or it won't happen until tomorrow ?
  /// It checks the time using minute precission
  static bool isToday(TimeOfDay time) {
    final now = DateTime.now().round();
    return now.hour < time.hour ||
        now.hour == time.hour && now.minute < time.minute ||
        now.hour == time.hour && now.minute <= time.minute;
  }

  //----------------------------------------------------------------------------
  //-----------------DateTime extensions ---------------------------------------

  /// The date without time
  DateTime date() {
    return DateTime(year, month, day);
  }

  /// The date as a string 'yyyy-MM-dd'
  String toDateString() {
    return '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  /// The data at a specific TimeOfDay
  DateTime at(TimeOfDay time) {
    return date().add(Duration(hours: time.hour, minutes: time.minute));
  }

  /// Round DateTime to precission of minutes or seconds
  DateTime round([RoundTimeTo precission = RoundTimeTo.minute]) {
    final s =
        (precission == RoundTimeTo.second
            ? second + (millisecond >= 500 ? 1 : 0)
            : 0);
    final m =
        minute +
        (precission == RoundTimeTo.minute ? (second >= 30 ? 1 : 0) : 0);
    return DateTime(year, month, day, hour, m, s);
  }

  /// Returns true when the date is the last day of the month
  bool isLastDayOfMonth() {
    return DateUtils.getDaysInMonth(year, month) == day;
  }

  //-------- end extension -----------------------------------------------------
}
