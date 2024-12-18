// logging and debugging
// Dart base
import 'dart:typed_data';
// Flutter
// Project files
import 'day_of_week.dart';

//==============================================================================

/// A bitset of the days of the week
class DayOfWeekBitset {

  //-------------------------static/constant------------------------------------

  static int _bitRepresentation(DayOfWeek d) {
    return 1 << (d.id - 1);
  }

  //-----------------class state members and constructors ----------------------

  final Uint8List _value;

  /// Empty bitset = {}
  DayOfWeekBitset.empty() : _value = Uint8List(1);

  /// Initialize from a [Set]
  DayOfWeekBitset(Set<DayOfWeek> init) : _value = Uint8List(1) {
    for (var d in init) {
      _value[0] |= _bitRepresentation(d);
    }
  }

  /// Full bitset: all the days of the week included
  factory DayOfWeekBitset.allDays() {
    return DayOfWeekBitset._fromInt(127);
  }

  /// Restore from Json using [key]
  factory DayOfWeekBitset.fromJson(Map<String, dynamic> json, String key) {
    return DayOfWeekBitset._fromInt(json[key] as int);
  }

  factory DayOfWeekBitset._fromInt(int value) {
    DayOfWeekBitset tmpResult = DayOfWeekBitset.empty();
    tmpResult._value[0] = (value as Uint8List)[0];
    return tmpResult;
  }

  //-----------------------class special members--------------------------------

  /// Transform to [Set]
  Set<DayOfWeek> get toSet {
    Set<DayOfWeek> tmpResult = {};
    for (int i = 0; i < 7; i++) {
      final DayOfWeek d = DayOfWeek.fromId(i);
      if (this[d]) {
        tmpResult.add(d);
      }
    }
    return tmpResult;
  }

  /// Convert to a Json object which must be encoded to became a string
  Map<String, dynamic> toJson(String key) {
    return {
      key: _rawValue,
    };
  }

  int get _rawValue => _value[0];

  //-----------------------class rest of members--------------------------------

  /// Is the day in the set?
  bool operator [](DayOfWeek d) {
    return (_rawValue & _bitRepresentation(d)) != 0;
  }

  /// include (true) or exclude (false) a day in the set
  void operator []=(DayOfWeek d, bool value) {
    if (value) {
      _value[0] |= _bitRepresentation(d);
    } else {
      _value[0] &= ~_bitRepresentation(d);
    }
  }

  /// Days which are in both bitsets
  DayOfWeekBitset operator &(DayOfWeekBitset v) {
    return DayOfWeekBitset._fromInt(_rawValue & v._rawValue);
  }

  /// Days which are in any of the bitsets
  DayOfWeekBitset operator |(DayOfWeekBitset v) {
    return DayOfWeekBitset._fromInt(_rawValue | v._rawValue);
  }

  /// Days which are not in the bitset
  DayOfWeekBitset operator ~() {
    return DayOfWeekBitset._fromInt(~_rawValue);
  }

  /// Restrict the days to those that are also in [v]
  void and(DayOfWeekBitset v) {
    _value[0] &= v._rawValue;
  }

  /// Include also all the days which are in [v]
  void or(DayOfWeekBitset v) {
    _value[0] |= v._rawValue;
  }

  /// Reversing the set
  void not() {
    _value[0] = ~_value[0];
  }

}
