// logging and debugging
// Dart base
import 'dart:typed_data';
// Flutter
// Project files
import 'day_of_week.dart';

//==============================================================================

/// A bitset of the days of the week
class DayOfWeekBitset {
  //
  //----------------------------------------------------------------------------
  //---------------------------------static/constant----------------------------

  static int _bitRepresentation(DayOfWeek d) {
    return 1 << (d.id - 1);
  }

  //----------------------------------------------------------------------------
  //----------------- state members and constructors ---------------------------

  final Uint8List _value;

  /// Empty bitset = {}
  DayOfWeekBitset.empty() : _value = Uint8List(1);

  /// Initialize from a [Set]
  DayOfWeekBitset(Set<DayOfWeek> init) : _value = Uint8List(1) {
    for (var d in init) {
      _value[0] |= _bitRepresentation(d);
    }
  }

  /// Import from raw Uint8List data
  DayOfWeekBitset.fromRaw(int value) : _value = Uint8List(1) {
    assert(value >= 0 && value <= 127);
    _value[0] = value;
  }

  /// Restore from Json using [key]
  factory DayOfWeekBitset.fromJson(Map<String, dynamic> json, String key) {
    return DayOfWeekBitset.fromRaw(json[key] as int);
  }

  //----------------------------------------------------------------------------
  //----------------------- special members-------------------------------------

  /// Get the internal representation
  int get rawValue => _value[0];

  /// Transform to [Set]
  Set<DayOfWeek> get toSet {
    final Set<DayOfWeek> tmpResult = {};
    for (int i = 1; i <= 7; i++) {
      final DayOfWeek d = DayOfWeek.fromId(i);
      if (this[d]) {
        tmpResult.add(d);
      }
    }
    return tmpResult;
  }

  /// Get an updatable version of this bitset
  UpdatableDayOfWeekBitset get updatableValue {
    return UpdatableDayOfWeekBitset.fromRaw(rawValue);
  }

  /// Convert to a Json object which must be encoded to became a string.
  /// The object will be coded as an integer valued entry using [key]
  /// This entry can be inserted into an existing [map],
  /// otherwise a new map with this single entry will be returned.
  Map<String, dynamic> toJson(String key, [Map<String, dynamic>? map]) {
    final Map<String, dynamic> result = map ?? {};
    result[key] = rawValue;
    return result;
  }

  //----------------------------------------------------------------------------
  //----------------------- rest of members-------------------------------------

  /// Is it an empty set?
  bool get isEmpty {
    return rawValue == 0;
  }

  /// Is it an empty set?
  bool get isNotEmpty {
    return rawValue != 0;
  }

  /// Check if the day of the week is in the set
  bool contains(DayOfWeek d) => this[d];

  /// Number of elements
  int count() {
    var result = 0;
    var tmp = rawValue;
    while (tmp != 0) {
      if (tmp & 1 != 0) {
        result++;
      }
      tmp = tmp >> 1;
    }
    return result;
  }

  /// Is the day in the set?
  bool operator [](DayOfWeek d) {
    return (rawValue & _bitRepresentation(d)) != 0;
  }

  /// Days which are in both bitsets
  DayOfWeekBitset operator &(DayOfWeekBitset v) {
    return DayOfWeekBitset.fromRaw(rawValue & v.rawValue);
  }

  /// Days which are in any of the bitsets
  DayOfWeekBitset operator |(DayOfWeekBitset v) {
    return DayOfWeekBitset.fromRaw(rawValue | v.rawValue);
  }

  /// Days which are not in the bitset
  DayOfWeekBitset operator ~() {
    return DayOfWeekBitset.fromRaw(~rawValue & 127);
  }

  //-------- end class ---------------------------------------------------------
}

//==============================================================================

/// DayOfWeekBitset with update operations
/// UPDATABLE extension
class UpdatableDayOfWeekBitset extends DayOfWeekBitset {
  //
  //----------------------------------------------------------------------------
  //----------------- state members and constructors ---------------------------

  /// Initialize from a [Set]
  UpdatableDayOfWeekBitset(super.init);

  /// Empty bitset = {}
  UpdatableDayOfWeekBitset.empty() : super.empty();

  /// Import from raw Uint8List data
  UpdatableDayOfWeekBitset.fromRaw(super.value) : super.fromRaw();

  /// Full bitset: all the days of the week included
  factory UpdatableDayOfWeekBitset.allDays() {
    return UpdatableDayOfWeekBitset.fromRaw(127);
  }

  /// Restore from Json using [key]
  factory UpdatableDayOfWeekBitset.fromJson(
    Map<String, dynamic> json,
    String key,
  ) {
    return UpdatableDayOfWeekBitset.fromRaw(json[key] as int);
  }

  //----------------------------------------------------------------------------
  //----------------------- special members-------------------------------------

  /// Get an updatable version of this bitset
  DayOfWeekBitset get readOnlyValue {
    return DayOfWeekBitset.fromRaw(rawValue);
  }

  //----------------------------------------------------------------------------
  //----------------------- rest of members-------------------------------------

  /// Remove all items
  void emptySet() {
    _value[0] = 0;
  }

  /// include (true) or exclude (false) a day in the set
  void operator []=(DayOfWeek d, bool value) {
    final dayBitsetValue = DayOfWeekBitset._bitRepresentation(d);
    if (value) {
      _value[0] |= dayBitsetValue;
    } else {
      _value[0] &= ~dayBitsetValue;
    }
  }

  /// Alter de bitset:
  /// Restrict the days to those that are also in [v]
  void and(DayOfWeekBitset v) {
    _value[0] &= v.rawValue;
  }

  /// Alter de bitset:
  /// Include also all the days which are in [v]
  void or(DayOfWeekBitset v) {
    _value[0] |= v.rawValue;
  }

  /// Alter de bitset:
  /// Reverse the set (get the elements which were not in the set)
  void not() {
    _value[0] = ~rawValue & 127;
  }

  //-------- end class ---------------------------------------------------------
}
