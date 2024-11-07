import 'package:format/format.dart';

/// Extended [Duration] to include [years] and [months].
/// Note Duration is an independent period of time,
/// but [RelativeDuration] depends on the date it is applied
/// as moths or years not always have the same number of days.
/// The [RelativeDuration] has years and months, but also an
/// date independemt [Duration] part, which can contain more
/// than 365 days.
typedef RelativeDuration = ({int years, int months, Duration duration});

/// Soport for ISO 8601 duration format
/// ISO 8601 Durations are expressed using the following format, where (n) is replaced by the value for each of the date and time elements that follow the (n):
///
///     P(n)Y(n)M(n)DT(n)H(n)M(n)S
///
/// Where:
///
///     P is the duration designator (referred to as "period"), and is always placed at the beginning of the duration.
///     Y is the year designator that follows the value for the number of years.
///     M is the month designator that follows the value for the number of months.
///     W is the week designator that follows the value for the number of weeks.
///     D is the day designator that follows the value for the number of days.
///     T is the time designator that precedes the time components.
///     H is the hour designator that follows the value for the number of hours.
///     M is the minute designator that follows the value for the number of minutes.
///     S is the second designator that follows the value for the number of seconds.
///
/// For example:
///
///     P3Y6M4DT12H30M5S
/// Represents a duration of three years, six months, four days, twelve hours, thirty minutes, and five seconds.
abstract class DurationExtensions {
  static bool isNormalized(RelativeDuration d) {
    return (d.duration.isNegative && d.years <= 0 && d.months <= 0) ||
        (!d.duration.isNegative && d.years >= 0 && d.months >= 0);
    /*
      return d.duration.isNegative && hasNegativeValues(d) ||
            (!d.duration.isNegative && !hasNegativeValues(d));
    */
  }

  static bool hasNegativeValues(RelativeDuration d) {
    assert((d.years >= 0 && d.months >= 0 && !d.duration.isNegative) ||
        (d.years <= 0 &&
            d.months <= 0 &&
            (d.duration.isNegative || d.duration.inMilliseconds == 0)));

    return d.duration.isNegative || d.years < 0 || d.months < 0;
  }

  static int durationInWeeks(Duration d) {
    return d.inDays ~/ 7;
  }

  static String durationToISOString(dynamic d) {
    final bool isNegative;
    final Duration dPart;
    final int years;
    final int months;
    if (d is RelativeDuration) {
      assert(isNormalized(d));
      isNegative = d.duration.isNegative;
      dPart = d.duration.abs();
      years = d.years.abs();
      months = d.months.abs();
    } else if (d is Duration) {
      isNegative = d.isNegative;
      dPart = d.abs();
      years = 0;
      months = 0;
    } else {
      throw ArgumentError.value(d);
    }
    var buffer = StringBuffer();
    if (isNegative) buffer.write("-");
    buffer.write("P");
    if (years > 0 || months > 0 || dPart.inDays > 0) {
      if (years > 0) {
        buffer.write("${years}Y");
      }
      if (months > 0) {
        buffer.write("${months}M");
      }
      if (dPart.inDays > 0) {
        buffer.write("${d.duration.inDays}D");
      }
    }
    Duration tPart = Duration(
        milliseconds: dPart.inMilliseconds - dPart.inDays * 24 * 3600000);
    if (tPart.inMilliseconds > 0) {
      buffer.write("T");
      if (tPart.inHours > 0) {
        buffer.write("${tPart.inHours}H");
        tPart = Duration(
            milliseconds: tPart.inMilliseconds - tPart.inHours * 3600000);
      }
      if (tPart.inMinutes > 0) {
        buffer.write("${tPart.inMinutes}M");
        tPart = Duration(
            milliseconds: tPart.inMilliseconds - tPart.inMinutes * 60000);
      }
      if (tPart.inMilliseconds > 0) {
        buffer.write("${tPart.inSeconds}");
        tPart = Duration(
            milliseconds: tPart.inMilliseconds - tPart.inSeconds * 1000);
        if (tPart.inMilliseconds > 0) {
          buffer.write(".");
          buffer.write(format('{:03d}', tPart.inMilliseconds));
        }
        buffer.write("S");
      }
    }
    return buffer.toString();
  }

  static RelativeDuration parseDurationISOString(String v) {
    final bool isNegative;
    if (v.startsWith("-")) {
      isNegative = true;
      v = v.substring(1).trimRight();
    } else {
      isNegative = false;
      v = v.trimRight();
    }
    if (v.isEmpty || v[0] != "P") {
      throw ArgumentError.value(v);
    } else if (v.contains(RegExp(r'\s'))) {
      throw ArgumentError.value(v, "v", "spaces included");
    } else if (v.length == 1) {
      if (isNegative) {
        // -0 is not accepted
        throw ArgumentError.value(v, "v", "Invalid negative zero on duration");
      } else {
        return const (years: 0, months: 0, duration: Duration());
      }
    } else {
      var pparts = v.substring(1).split("T");
      if (pparts.isEmpty || pparts.length == 1 && pparts[0].isEmpty) {
        throw Exception("Empty duration string");
      } else if (pparts.length > 2 ||
          pparts.length == 2 && pparts[0].isEmpty && pparts[1].isEmpty) {
        throw Exception("Invalid duration string");
      } else {
        final int yearsValue;
        final int monthsValue;
        final int daysValue;
        final int hoursValue;
        final int minutesValue;
        final int secondsValue;
        final int mSecondsValue;
        if (pparts[0].isNotEmpty) {
          final regex = RegExp(r'^([0-9]+Y)?([0-9]+M)?([0-9]+W)?([0-9]+D)?$');
          final match = regex.firstMatch(pparts[0]);
          if (match != null) {
            final y = match.group(1);
            final m = match.group(2);
            final w = match.group(3);
            final d = match.group(4);
            yearsValue = int.parse(y?.substring(0, y.length - 1) ?? "0");
            monthsValue = int.parse(m?.substring(0, m.length - 1) ?? "0");
            daysValue = int.parse(d?.substring(0, d.length - 1) ?? "0") +
                7 * int.parse(w?.substring(0, w.length - 1) ?? "0");
          } else {
            throw ArgumentError.value(v);
          }
        } else {
          yearsValue = 0;
          monthsValue = 0;
          daysValue = 0;
        }
        if (pparts.length > 1 && pparts[1].isNotEmpty) {
          final regex = RegExp(r'^([0-9]+H)?([0-9]+M)?([0-9]+(?:\.[0-9])?S)?$');
          final match = regex.firstMatch(pparts[1]);
          if (match != null) {
            final hours = match.group(1);
            final minutes = match.group(2);
            final seconds = match.group(3);
            final secondsGrossValue =
                double.parse(seconds?.substring(0, seconds.length - 1) ?? "0");
            hoursValue =
                int.parse(hours?.substring(0, hours.length - 1) ?? "0");
            minutesValue =
                int.parse(minutes?.substring(0, minutes.length - 1) ?? "0");
            secondsValue = secondsGrossValue.truncate();
            mSecondsValue =
                ((secondsGrossValue - secondsValue) * 1000).truncate();
          } else {
            throw ArgumentError.value(v);
          }
        } else {
          hoursValue = 0;
          minutesValue = 0;
          secondsValue = 0;
          mSecondsValue = 0;
        }
        return (
          years: isNegative && yearsValue > 0 ? -yearsValue : yearsValue,
          months: isNegative && monthsValue > 0 ? -monthsValue : monthsValue,
          duration: Duration(
              days: isNegative ? -daysValue : daysValue,
              hours: isNegative ? -hoursValue : hoursValue,
              minutes: isNegative ? -minutesValue : minutesValue,
              seconds: isNegative ? -secondsValue : secondsValue,
              milliseconds: isNegative ? -mSecondsValue : mSecondsValue)
        );
      }
    }
  }
}
