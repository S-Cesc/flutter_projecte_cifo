/* // ignore_for_file: public_member_api_docs */

// logging and debugging
// Dart base
// Flutter
// Project files
import 'day_of_week.dart';
import 'day_of_week_bitset.dart';

//==============================================================================

/// Partition of the days of the week into disjoint sets:
/// A day of the week can't belong to more than one set
class DayOfWeekPartitions {
  //-----------------class state members and constructors ----------------------

  final List<DayOfWeekBitset> _weekdaysPartition;

  /// Partition of the days of the week into disjoint sets
  /// It allows the distribution of days into [numberOfSubsets] sets:
  /// at least one, at most six.
  DayOfWeekPartitions({required int numberOfSubsets})
      : _weekdaysPartition =
            List.filled(numberOfSubsets, DayOfWeekBitset.empty()) {
    assert(numberOfSubsets > 0 && numberOfSubsets < 7);
  }

  /// Restore from Json using [keyPrefix]
  factory DayOfWeekPartitions.fromJson(
    Map<String, dynamic> json,
    String keyPrefix,
  ) {
    final int n = json["${keyPrefix}N"] as int;
    final tmpResult = DayOfWeekPartitions(numberOfSubsets: n);
    for (int i = 0; i < n; i++) {
      final s = DayOfWeekBitset.fromJson(json, "$keyPrefix$i");
      tmpResult._weekdaysPartition[i].or(s);
    }
    return tmpResult;
  }

  //-----------------------class special members--------------------------------

  /// Convert to a Json object which must be encoded to became a string
  Map<String, dynamic> toJson(String keyPrefix) {
    Map<String, dynamic> tmpResult = {
      "${keyPrefix}N": _weekdaysPartition.length,
    };
    for (int i = 0; i < _weekdaysPartition.length; i++) {
      tmpResult.addAll(_weekdaysPartition[i].toJson("$keyPrefix$i"));
    }
    return tmpResult;
  }

  //-----------------------class rest of members--------------------------------

  /// Which is the partition index of the day [d]?
  int? operator [](DayOfWeek d) {
    for (int pos = 0; pos < _weekdaysPartition.length; pos++) {
      if (_weekdaysPartition[pos][d]) return pos;
    }
    return null;
  }

  /// Set the partition index of the day [d].
  /// Using a null value removes it from all partitions
  void operator []=(DayOfWeek d, int? pos) {
    if (pos == null || pos >= 0 && pos < _weekdaysPartition.length) {
      for (int i = 0; i < _weekdaysPartition.length; i++) {
        _weekdaysPartition[i][d] = (i == pos);
      }
    } else {
      throw RangeError.range(pos, 0, _weekdaysPartition.length - 1);
    }
  }

  /// Return the [Set] of [DayOfWeek] of a partition
  Set<DayOfWeek> partition(int pos) => _weekdaysPartition[pos].toSet;

  /// Return the [Set] of [DayOfWeek] which do not belong to any partition
  Set<DayOfWeek> get missingDays {
    DayOfWeekBitset s = DayOfWeekBitset.allDays();
    for (int pos = 0; pos < _weekdaysPartition.length; pos++) {
      s.and(~_weekdaysPartition[pos]);
    }
    return s.toSet;
  }
}
