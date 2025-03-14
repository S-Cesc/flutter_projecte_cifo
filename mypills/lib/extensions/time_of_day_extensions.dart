import 'package:flutter/material.dart';

//==============================================================================

/// Extensions for TimeOfDay
extension TimeOfDayExtension on TimeOfDay {
  //
  //----------------------------------------------------------------------------
  //-------------------------static/constant------------------------------------

  /// Minutes in a day: 24 * 60 = 1440
  static const minutesInaDay = TimeOfDay.hoursPerDay * TimeOfDay.minutesPerHour;

  /// The beginning of a new day at 00:00
  static const beginOfTheDay = TimeOfDay(hour: 0, minute: 0);

  /// Get the TimeOfDay from a string value compatible with json serialization
  /// Returns null either when:
  /// - [jsonStringValue] is null
  /// - It isn't a string compatible with the result of [toJsonString]
  static TimeOfDay? parseTimeOfDay(String? jsonStringValue) {
    if (jsonStringValue == null) {
      return null;
    } else {
      final lst = jsonStringValue.split(':');
      if (lst.length != 2) {
        return null;
      } else {
        final hour = int.tryParse(lst.first);
        if (hour == null || hour < 0 || hour >= 24) {
          return null;
        } else {
          final minute = int.tryParse(lst.last);
          if (minute == null || minute < 0 || minute >= 60) {
            return null;
          } else {
            return TimeOfDay(hour: hour, minute: minute);
          }
        }
      }
    }
  }

  /// Return the max value between two TimeOfDay values
  static TimeOfDay max(
    TimeOfDay x,
    TimeOfDay y, [
    int midnightMarginMinutes = 0,
  ]) {
    return (x.gte(y, midnightMarginMinutes) ? x : y);
  }

  /// Operator greater, with midnighMarginMinutes parameter
  /// It allows values near before midnight not to be greater
  /// than values with less than midnighMarginMinutes difference
  bool gt(TimeOfDay x, [int midnightMinutesMargin = 0]) {
    return isLater(x, midnightMinutesMargin);
  }

  /// Operator greater or equal, with midnighMarginMinutes parameter
  /// It allows values near before midnight not to be greater
  /// than values with less than midnighMarginMinutes difference
  bool gte(TimeOfDay x, [int midnightMinutesMargin = 0]) {
    return this == x || isLater(x, midnightMinutesMargin);
  }

  //----------------------------------------------------------------------------
  //-----------------TimeOfDay operator extensions -----------------------------

  /// ">" operator
  bool operator >(TimeOfDay x) {
    return isAfter(x);
  }

  /// ">=" operator
  bool operator >=(TimeOfDay x) {
    return isAfterOrAtSameTimeAs(x);
  }

  //----------------------------------------------------------------------------
  //-----------------TimeOfDay extensions --------------------------------------

  /// Add minutes to a TimeOfDay
  /// Ported from org.threeten.bp;
  TimeOfDay plusMinutes(int minutes) {
    if (minutes == 0) {
      return this;
    } else {
      int mofd = hour * TimeOfDay.minutesPerHour + minute;
      int newMofd = (minutes + mofd) % minutesInaDay;
      if (mofd == newMofd) {
        return this;
      } else {
        int newHour = newMofd ~/ TimeOfDay.minutesPerHour;
        int newMinute = newMofd % TimeOfDay.minutesPerHour;
        return TimeOfDay(hour: newHour, minute: newMinute);
      }
    }
  }

  /// Minutes which need to pass until other
  /// Acts as modular diference between two [TimeOfDay]
  /// Always returns positive value less than [minutesInaDay]
  /// Usually "other" would be some time after
  /// When other is "before" it returns
  /// the difference with the other time at the next day
  int minutesUntil(TimeOfDay other) {
    final diff =
        (other.hour - hour) * TimeOfDay.minutesPerHour + other.minute - minute;
    if (diff >= 0) {
      return diff;
    } else {
      return minutesInaDay + diff;
    }
  }

  /// isBefore or isAtSameTimeAs
  /// Same as isBefore(other) || isAtSameTimeAs(other);
  bool isBeforeOrAtSameTimeAs(TimeOfDay other) {
    if (hour < other.hour || hour == other.hour && minute <= other.minute) {
      return true;
    } else {
      return false;
    }
  }

  /// isBefore or isAtSameTimeAs
  /// Same as isAfter(other) || isAtSameTimeAs(other);
  bool isAfterOrAtSameTimeAs(TimeOfDay other) {
    if (hour > other.hour || hour == other.hour && minute >= other.minute) {
      return true;
    } else {
      return false;
    }
  }

  /// Like isAfter, but it uses difference between TimeOfDay of different days
  /// when TimeOfDay is less than [midnightMinutesMargin] before midnight
  /// and other is less than [midnightMinutesMargin] after midnight
  bool isLater(TimeOfDay other, int midnightMinutesMargin) {
    if (midnightMinutesMargin == 0) {
      return isAfter(other);
    } else if (midnightMinutesMargin > 0) {
      final shiftedValue = plusMinutes(midnightMinutesMargin);
      // doesn't shiftedValue pass the midnight?
      if (shiftedValue.isAfter(this)) {
        // 'this' is not just before midnight
        // but may be 'this' is just passed midnight
        final shiftedOtherValue = other.plusMinutes(midnightMinutesMargin);
        // doesn't shiftedOtherValue pass the midnight?
        if (shiftedOtherValue.isAfter(other)) {
          // 'this' is not just before midnight, and neither is other
          return isAfter(other);
        } else {
          // other is just before midnight
          // check wether 'this' is just passed midnight
          return shiftedOtherValue.isAfterOrAtSameTimeAs(this);
        }
      } else if (other.isAfter(shiftedValue)) {
        // 'this' is close to midnight (shiftedValue pass midnight)
        // and other don't pass or is later enough from midnight
        return isAfter(other);
      } else {
        // 'this' is close to midnight (the shifted value is pass midnight)
        // the other value is pass midnight, but it is before shifted value
        // i.e. it is after 'this'
        return false;
      }
    } else {
      throw RangeError.range(
        midnightMinutesMargin,
        0,
        null,
        "midnighMarginMinutes",
      );
    }
  }

  /// Serialize into a json compatible string
  String get toJsonString {
    return "${hour.toString().padLeft(2, '0')}:"
        "${minute.toString().padLeft(2, '0')}";
  }

  //-------- end extension -----------------------------------------------------
}
