// Dart
import 'package:week_number/iso.dart';
// Project files
import 'enum/day_of_week.dart';
import 'enum/day_of_week_bitset.dart';
import 'enum/frequency.dart';
import 'meal_pillmealtime_pair.dart';
import 'alarm_key_list.dart';
import '../extensions/date_time_extensions.dart';

//==============================================================================
// NOTE Important limitation! This uses an AlarmKeyList
// It means that once PrescriptionFrequency is used
// that elements from the AlarmKeyList used can't be removed,
// so that and those (Meal, PillMealTime) pairs must remain fixed
// and not available to be modified in the settings
// Although, alternative routines can be defined as
// AlarmKeyList must be build from the main routine

//==============================================================================

// TODO: unbind prescription from selected routine
// The usual prescription uses 1-1-1-1 notation
// Using that the requeriment is limited to an AlarmKeyList to exist
// with the correct number of items
// The binding just will match items by index, independent from its contents
// Althought the index in the AlarmKeyList will be meanfully

// TODO: An other unbinded situation is for "Every 8 hours"
// It could be introduced the Meal "none" alternative
// to build alarms unbinded from meals,
// and then different pilmealtimes to make the 1-1-1 and the 1-1-1-1 options

//==============================================================================

/// Union class for all the possible frequency parameters
sealed class PrescriptionFrequency {
  //
  // Private utility function
  static bool _isDayOfMonth(DateTime date, int day) {
    return (day == 28 ? date.isLastDayOfMonth() : date.day == day);
  }

  /// the frequency value
  final Frequency frequency;

  /// the time of day, may be several times each day
  /// The list is not growable (add/remove not available)
  /// but the elements are updatable
  final AlarmKeyList pillTime;

  DateTime _lastDay;

  PrescriptionFrequency._(
    this.frequency,
    MealPillmealtimePair when,
    DateTime lastDay,
  ) : pillTime = AlarmKeyList([when]),
      _lastDay = lastDay.date();

  PrescriptionFrequency(this.frequency, this.pillTime, DateTime lastDay)
    : _lastDay = lastDay.date();

  /// Getter for the end date
  DateTime get lastDayPrescription => _lastDay;

  factory PrescriptionFrequency.fromJson(Map<String, dynamic> json) {
    final Frequency frequency = Frequency.values[json['frequency'] as int];
    final AlarmKeyList pillTime = AlarmKeyList.fromJsonList(
      json['pillTime'] as List<dynamic>,
    );
    final DateTime endDate = DateTime.parse(json['endDate'] as String);
    switch (frequency) {
      case Frequency.once:
        return PrescriptionOnce._(endDate, pillTime);
      case Frequency.onceADay:
        return PrescriptionOnceEachDay(pillTime, endDate);
      case Frequency.twiceADay:
        return PrescriptionTwiceEachDay(pillTime, endDate);
      case Frequency.threeTimesADay:
        return PrescriptionThreeTimesEachDay(pillTime, endDate);
      case Frequency.fourTimesADay:
        return PrescriptionFourTimesEachDay(pillTime, endDate);
      case Frequency.weekly:
        return PrescriptionWeekly._(
          DayOfWeekBitset.fromJson(json, 'daysOfWeek'),
          pillTime,
          endDate,
        );
      case Frequency.everyTwoWeeks:
        return PrescriptionEveryTwoWeeks._(
          DayOfWeek.fromId(json['dayOfWeek'] as int),
          json['evenWeek'] as bool,
          pillTime,
          endDate,
        );
      case Frequency.fortnightly:
        return PrescriptionFortnightly._(
          json['firstDayOfMonth'] as int,
          json['lastDayOfMonth'] as int,
          pillTime,
          endDate,
        );
      case Frequency.monthly:
        return PrescriptionMonthly._(
          json['dayOfMonth'] as int,
          pillTime,
          endDate,
        );
      case Frequency.everyFourWeeks:
        return PrescriptionEveryFourWeeks._(
          DayOfWeek.fromId(json['dayOfWeek'] as int),
          json['modulo'] as int,
          pillTime,
          endDate,
        );
    }
  }

  /// Returns a map representation of the object
  /// which can be encoded to a JSON string
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['frequency'] = frequency.index;
    map['pillTime'] = pillTime.toString();
    map['endDate'] = _lastDay.toDateString();
    switch (runtimeType) {
      case const (PrescriptionOnce) ||
          const (PrescriptionOnceEachDay) ||
          const (PrescriptionTwiceEachDay) ||
          const (PrescriptionThreeTimesEachDay) ||
          const (PrescriptionFourTimesEachDay):
        break;
      case const (PrescriptionWeekly):
        map['daysOfWeek'] = (this as PrescriptionWeekly)._daysOfWeek.toJson(
          'daysOfWeek',
        );
        break;
      case const (PrescriptionEveryTwoWeeks):
        map
          ..['dayOfWeek'] = (this as PrescriptionEveryTwoWeeks)._dayOfWeek.id
          ..['evenWeek'] = (this as PrescriptionEveryTwoWeeks)._evenWeeks;
        break;
      case const (PrescriptionFortnightly):
        map
          ..['firstDayOfMonth'] = (this as PrescriptionFortnightly)._dayOfMonth1
          ..['lastDayOfMonth'] = (this as PrescriptionFortnightly)._dayOfMonth2;
        break;
      case const (PrescriptionMonthly):
        map['dayOfMonth'] = (this as PrescriptionMonthly)._dayOfMonth;
        break;
      case const (PrescriptionEveryFourWeeks):
        map
          ..['dayOfWeek'] = (this as PrescriptionEveryFourWeeks)._dayOfWeek.id
          ..['modulo'] = (this as PrescriptionEveryFourWeeks)._modulo;
        break;
    }
    return map;
  }

  /// Reseting the end date will make the prescription to be expired
  /// It will represent "yesterday", an expired value
  void resetEndPrescription() {
    _lastDay = DateTimeExtensions.yesterday();
  }

  /// Incrementing the end of prescription can be easily done
  /// It will only increment if the new date is after the current end date
  /// It also can be used to compute a maximum end date, after [resetEndPrescription]
  void incrementEndPrescription(DateTime newEndDate) {
    if (newEndDate.isAfter(_lastDay)) _lastDay = newEndDate.date();
  }

  /// Set the end of prescription to a new arbitrary value
  void setEndPrescription(DateTime newEndDate) {
    resetEndPrescription();
    incrementEndPrescription(newEndDate);
  }

  /// Returns true if the date is after the end of prescription
  bool isOutOfDate(DateTime date) => date.isAfter(lastDayPrescription);

  /// Returns for the days when prescription applies
  bool isThisDayToTake(DateTime date) =>
      !isOutOfDate(date) && _isItThisDay(date);

  /// Returns true when the pill time matches
  /// Caution! the result is only valid for days when isThisDayToTake is true
  bool isThisThePillTime(MealPillmealtimePair pair) {
    return pillTime.any((x) => x == pair);
  }

  /// Returns true if the date matches the frequency
  bool _isItThisDay(DateTime date);
  //
} // FrequencyUnion

//==============================================================================

/// Once parameters
class PrescriptionOnce extends PrescriptionFrequency {
  /// Ctor
  PrescriptionOnce._(DateTime at, AlarmKeyList whenList)
    : super(Frequency.once, whenList, at) {
    assert(whenList.length == 1);
  }

  /// Ctor
  PrescriptionOnce(DateTime at, MealPillmealtimePair when)
    : super._(Frequency.once, when, at);

  /// Getter for the date
  DateTime get dateAt => lastDayPrescription;

  @override
  bool _isItThisDay(DateTime d) => d == dateAt;
} // Once

//==============================================================================

/// Dayly PrescriptionOnceEachDay parameters
class PrescriptionOnceEachDay extends PrescriptionFrequency {
  /// Ctor
  PrescriptionOnceEachDay(AlarmKeyList whenList, DateTime endPrescription)
    : super(Frequency.onceADay, whenList, endPrescription) {
    assert(whenList.length == 1);
  }

  @override
  bool _isItThisDay(DateTime date) => true;
  //
} // Dayly PrescriptionOnceEachDay

//==============================================================================

/// Dayly PrescriptionTwiceEachDay parameters
class PrescriptionTwiceEachDay extends PrescriptionFrequency {
  /// Ctor
  PrescriptionTwiceEachDay(AlarmKeyList whenList, DateTime endPrescription)
    : super(Frequency.twiceADay, whenList, endPrescription) {
    assert(whenList.length == 2);
  }

  @override
  bool _isItThisDay(DateTime date) => true;
  //
} // Dayly PrescriptionTwiceEachDay

//==============================================================================

/// Dayly PrescriptionThreeTimesEachDay parameters
class PrescriptionThreeTimesEachDay extends PrescriptionFrequency {
  /// Ctor
  PrescriptionThreeTimesEachDay(AlarmKeyList whenList, DateTime endPrescription)
    : super(Frequency.threeTimesADay, whenList, endPrescription) {
    assert(whenList.length == 3);
  }

  @override
  bool _isItThisDay(DateTime date) => true;
  //
} // Dayly PrescriptionThreeTimesEachDay

//==============================================================================

/// Dayly PrescriptionFourTimesEachDay parameters
class PrescriptionFourTimesEachDay extends PrescriptionFrequency {
  /// Ctor
  PrescriptionFourTimesEachDay(AlarmKeyList whenList, DateTime endPrescription)
    : super(Frequency.fourTimesADay, whenList, endPrescription) {
    assert(whenList.length == 4);
  }

  @override
  bool _isItThisDay(DateTime date) => true;
  //
} // Dayly PrescriptionFourTimesEachDay

//==============================================================================

/// Weekly parameters
class PrescriptionWeekly extends PrescriptionFrequency {
  final DayOfWeekBitset _daysOfWeek;

  /// Ctor
  PrescriptionWeekly._(
    DayOfWeekBitset daysOfWeek,
    AlarmKeyList whenList,
    DateTime endPrescription,
  ) : _daysOfWeek = daysOfWeek,
      super(Frequency.weekly, whenList, endPrescription) {
    assert(whenList.length == 1);
  }

  /// Ctor
  PrescriptionWeekly(
    DayOfWeekBitset daysOfWeek,
    MealPillmealtimePair when,
    DateTime endPrescription,
  ) : _daysOfWeek = daysOfWeek,
      super._(Frequency.weekly, when, endPrescription);

  @override
  bool _isItThisDay(DateTime date) =>
      _daysOfWeek.contains(DayOfWeek.fromId(date.weekday));
  //
} // Weekly

//==============================================================================

/// EveryTwoWeeks parameters
class PrescriptionEveryTwoWeeks extends PrescriptionFrequency {
  final DayOfWeek _dayOfWeek;
  final bool _evenWeeks;

  /// Ctor
  PrescriptionEveryTwoWeeks._(
    DayOfWeek dayOfWeek,
    bool onEvenWeeks,
    AlarmKeyList whenList,
    DateTime endPrescription,
  ) : _dayOfWeek = dayOfWeek,
      _evenWeeks = onEvenWeeks,
      super(Frequency.everyTwoWeeks, whenList, endPrescription) {
    assert(whenList.length == 1);
  }

  /// Ctor
  /// When [onEvenWeeks] is true then even weeks of the year, otherwise odd ones
  PrescriptionEveryTwoWeeks(
    DayOfWeek dayOfWeek,
    bool onEvenWeeks,
    MealPillmealtimePair when,
    DateTime endPrescription,
  ) : _dayOfWeek = dayOfWeek,
      _evenWeeks = onEvenWeeks,
      super._(Frequency.everyTwoWeeks, when, endPrescription);

  /// Ctor
  PrescriptionEveryTwoWeeks.fromDate(
    DateTime dayOfMonthFirstShot,
    MealPillmealtimePair when,
    DateTime endPrescription,
  ) : this(
        DayOfWeek.fromId(dayOfMonthFirstShot.weekday),
        dayOfMonthFirstShot.weekNumber % 2 == 0,
        when,
        endPrescription,
      );

  @override
  bool _isItThisDay(DateTime date) =>
      _dayOfWeek == DayOfWeek.fromId(date.weekday) &&
      date.weekNumber % 2 == (_evenWeeks ? 0 : 1);
  //
} // EveryTwoWeeks

//==============================================================================

/// Fortnightly parameters
/// Note that EveryTwoWeeks and Fortnightly are practically equivalent
/// but both are kept as both may be used in prescriptions
class PrescriptionFortnightly extends PrescriptionFrequency {
  final int _dayOfMonth1;
  final int _dayOfMonth2;

  PrescriptionFortnightly._(
    this._dayOfMonth1,
    this._dayOfMonth2,
    AlarmKeyList whenList,
    DateTime endPrescription,
  ) : super(Frequency.fortnightly, whenList, endPrescription) {
    assert(whenList.length == 1);
    assert(_dayOfMonth1 > 0 && _dayOfMonth1 < 29);
    assert(_dayOfMonth2 > 0 && _dayOfMonth2 < 29);
    final diff = (_dayOfMonth2 - _dayOfMonth1).abs();
    assert(diff > 7 && diff < 25);
  }

  /// Ctor
  PrescriptionFortnightly(
    int dayOfMonthFirstShot,
    MealPillmealtimePair when,
    DateTime endPrescription,
  ) : this._(
        dayOfMonthFirstShot,
        ((dayOfMonthFirstShot + 14) % 28) + 1,
        AlarmKeyList([when]),
        endPrescription,
      );

  @override
  bool _isItThisDay(DateTime date) =>
      PrescriptionFrequency._isDayOfMonth(date, _dayOfMonth1) ||
      PrescriptionFrequency._isDayOfMonth(date, _dayOfMonth2);
  //
} // Fortnightly

//==============================================================================

/// Monthly parameters
class PrescriptionMonthly extends PrescriptionFrequency {
  final int _dayOfMonth;

  /// Ctor
  PrescriptionMonthly._(
    this._dayOfMonth,
    AlarmKeyList whenList,
    DateTime endPrescription,
  ) : super(Frequency.monthly, whenList, endPrescription) {
    assert(_dayOfMonth > 0 && _dayOfMonth < 29);
    assert(whenList.length == 1);
  }

  /// Ctor
  PrescriptionMonthly(
    this._dayOfMonth,
    MealPillmealtimePair when,
    DateTime endPrescription,
  ) : super._(Frequency.monthly, when, endPrescription) {
    assert(_dayOfMonth > 0 && _dayOfMonth < 29);
  }

  @override
  bool _isItThisDay(DateTime date) =>
      PrescriptionFrequency._isDayOfMonth(date, _dayOfMonth);
  //
} // Monthly

//==============================================================================

/// EveryFourWeeks parameters
/// Note that EveryFourWeeks and Monthly are practically equivalent
/// but both are kept as both may be used in prescriptions
class PrescriptionEveryFourWeeks extends PrescriptionFrequency {
  final DayOfWeek _dayOfWeek;
  final int _modulo;

  PrescriptionEveryFourWeeks._(
    DayOfWeek dayOfWeek,
    int weekNumberModulo4,
    AlarmKeyList whenList,
    DateTime endDate,
  ) : _dayOfWeek = dayOfWeek,
      _modulo = weekNumberModulo4,
      super(Frequency.everyFourWeeks, whenList, endDate) {
    assert(_modulo > 0 && _modulo < 4);
  }

  /// Ctor
  PrescriptionEveryFourWeeks(
    DateTime firstShot,
    MealPillmealtimePair when,
    DateTime endPrescription,
  ) : this._(
        DayOfWeek.fromId(firstShot.weekday),
        firstShot.weekNumber % 4,
        AlarmKeyList([when]),
        endPrescription,
      );

  @override
  bool _isItThisDay(DateTime date) =>
      _dayOfWeek == DayOfWeek.fromId(date.weekday) &&
      date.weekNumber % 4 == _modulo;
  //
} // EveryFourWeeks
