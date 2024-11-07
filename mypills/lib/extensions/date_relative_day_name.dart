import 'package:intl/intl.dart';
import 'string_extensions.dart';

enum DateRelativeDayName {
  daysBeforeYesterday(null),
  theDayBeforeYesterday("abans d'ahir"),
  yesterday("ahir"),
  today("avui"),
  tomorrow("demà"),
  theDayAfterTomorrow("demà passat"),
  daysAfterTomorrow(null);

  const DateRelativeDayName(this.name);

  final String? name;

  String? capitalizedName() {
    return name?.capitalize();
  }

  String weekDay(DateTime date, DateTime today) {
    final int dayDiff = today.difference(date).inDays;
    if (dayDiff.abs() <= 2) {
      return DateRelativeDayName.fromDate(date).name!;
    } else {
      final String weekDayName = DateFormat.EEEE().format(date);
      if (dayDiff > 0) {
        if (dayDiff <= 7) {
          return 'proxim $weekDayName';
        } else {
          // TODO: durationExtensions: named period
          return "$weekDayName d'aquí a $dayDiff dies";
        }
      } else {
        if (dayDiff >= -7) {
          return '$weekDayName passat';
        } else {
          // TODO: durationExtensions: named period
          return "$weekDayName de fa $dayDiff dies";
        }
      }
    }
  }

  static bool isSameDay(DateTime d1, DateTime d2) =>
      d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;

  static DateTime getYesterday(DateTime today) =>
      today.add(const Duration(days: -1));

  static bool isYesterday(DateTime date, DateTime today) {
    return isSameDay(date, getYesterday(today));
  }

  static DateTime getTomorrow(DateTime today) =>
      today.add(const Duration(days: 1));

  static bool isTomorrow(DateTime date, DateTime today) {
    return isSameDay(date, getTomorrow(today));
  }

  factory DateRelativeDayName.fromDate(DateTime d) {
    final now = DateTime.now();
    if (isSameDay(d, now)) {
      return DateRelativeDayName.today;
    } else if (d.isBefore(now)) {
      final yesterday = getYesterday(now);
      if (isSameDay(d, yesterday)) {
        return DateRelativeDayName.yesterday;
      } else {
        final dayBefore = getYesterday(yesterday);
        if (isSameDay(d, dayBefore)) {
          return DateRelativeDayName.theDayBeforeYesterday;
        } else {
          return DateRelativeDayName.daysBeforeYesterday;
        }
      }
    } else {
      final tomorrow = getTomorrow(now);
      if (isSameDay(d, tomorrow)) {
        return DateRelativeDayName.tomorrow;
      } else {
        final dayAfter = getTomorrow(tomorrow);
        if (isSameDay(d, dayAfter)) {
          return DateRelativeDayName.theDayAfterTomorrow;
        } else {
          return DateRelativeDayName.daysAfterTomorrow;
        }
      }
    }
  }
}
