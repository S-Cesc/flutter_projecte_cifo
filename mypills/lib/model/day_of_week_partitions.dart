// Dart base
import 'dart:typed_data';
// Flutter
// Project files

import 'enum/day_of_week.dart';
import 'enum/day_of_week_bitset.dart';

//==============================================================================

/// Partition of the days of the week into disjoint sets:
/// A day of the week can't belong to more than one set
class DayOfWeekPartitions {
  //
  //----------------------------------------------------------------------------
  //-----------------class state members and constructors ----------------------

  final Uint8List _partitionsWeekdays;

  /// Partition of the days of the week into disjoint sets
  /// It allows the distribution of days into [numberOfSubsets] sets:
  /// at least one, at most seven (which would be an ordering).
  DayOfWeekPartitions({required int numberOfSubsets})
    : _partitionsWeekdays = Uint8List(numberOfSubsets) {
    assert(numberOfSubsets > 0 && numberOfSubsets <= 7);
  }

  /// Restore from a String
  /// The String must be build with toString() method
  factory DayOfWeekPartitions.parse(String value) {
    if (value.length != 8) {
      throw FormatException("Invalid string: $value");
    } else {
      final numberOfSubsets = int.parse(value[0]);
      final DayOfWeekPartitions result = DayOfWeekPartitions(
        numberOfSubsets: numberOfSubsets,
      );
      for (int d = 1; d <= 7; d++) {
        if (value[d] != "-") {
          final setPos = int.tryParse(value[d]);
          if (setPos == null || setPos >= numberOfSubsets) {
            throw RangeError("Invalid character found: ${value[d]}");
          } else {
            result[DayOfWeek.fromId(d)] = setPos;
          }
        }
      }
      return result;
    }
  }

  //----------------------------------------------------------------------------
  //-----------------------class special members--------------------------------

  /// Number of subsets of the partition
  int get numberOfSubsets => _partitionsWeekdays.lengthInBytes;

  /// Return the [Set] of [DayOfWeek] corresponding to a partition,
  /// that is to say, a copy of one of the partition components
  DayOfWeekBitset partitionWeekdays(int partition) =>
      DayOfWeekBitset.fromRaw(_partitionsWeekdays[partition]);

  @override
  String toString() {
    String result = _partitionsWeekdays.lengthInBytes.toString();
    for (int d = 1; d <= 7; d++) {
      final value = this[DayOfWeek.fromId(d)];
      result += value != null ? value.toString() : "-";
    }
    return result;
  }

  @override
  bool operator ==(Object other) =>
      other is DayOfWeekPartitions &&
      other.runtimeType == runtimeType &&
      other.numberOfSubsets == numberOfSubsets &&
      _partitionsWeekdays == other._partitionsWeekdays;

  @override
  int get hashCode => _partitionsWeekdays.hashCode;

  //----------------------------------------------------------------------------
  //-----------------------class rest of members--------------------------------

  /// Total number of elements which belong to any of the partitions
  int count() {
    int result = 0;
    for (int part = 0; part < numberOfSubsets; part++) {
      result += partitionWeekdays(part).count();
    }
    return result;
  }

  /// Are all the partitions empty?
  bool get isEmpty {
    bool result = true;
    for (int part = 0; part < numberOfSubsets; part++) {
      result &= partitionWeekdays(part).rawValue == 0;
    }
    return result;
  }

  /// Are there any partition with elements defined
  bool get isNotEmpty {
    bool result = false;
    for (int part = 0; part < numberOfSubsets; part++) {
      result |= partitionWeekdays(part).rawValue != 0;
    }
    return result;
  }

  /// Check wether a value is included in any of the partitions
  bool contains(DayOfWeek d) {
    bool result = false;
    for (int pos = 0; pos < numberOfSubsets; pos++) {
      result |= partitionWeekdays(pos)[d];
    }
    return result;
  }

  /// Return the [Set] of [DayOfWeek] which doesn't belong to any partition
  Set<DayOfWeek> get missingDays {
    UpdatableDayOfWeekBitset s = UpdatableDayOfWeekBitset.allDays();
    for (int part = 0; part < numberOfSubsets; part++) {
      s.and(~partitionWeekdays(part));
    }
    return s.toSet;
  }

  /// Which is the partition index of the day [d]?
  int? operator [](DayOfWeek d) {
    for (int part = 0; part < numberOfSubsets; part++) {
      if (partitionWeekdays(part)[d]) return part;
    }
    return null;
  }

  //----------- UPDATING OPERATIONS --------------------------------------------

  /// Set the partition index of the day [d].
  /// Using a null value removes the day [d] from ALL partitions
  /// Anyway it'd affect all the partitions,
  /// as the partition for [d] must be unique
  void operator []=(DayOfWeek d, int? pos) {
    if (pos == null || pos >= 0 && pos < numberOfSubsets) {
      for (int part = 0; part < numberOfSubsets; part++) {
        final partition = UpdatableDayOfWeekBitset.fromRaw(
          _partitionsWeekdays[part],
        );
        partition[d] = (part == pos);
        _partitionsWeekdays[part] = partition.rawValue;
      }
    } else {
      throw RangeError.range(pos, 0, _partitionsWeekdays.length - 1);
    }
  }

  /// Remove a day from an explicit partition
  /// The remove can be done on the partition [fromPart]
  /// without affecting the rest of partitions
  void remove({required int fromPart, required DayOfWeek day}) {
    final partition = UpdatableDayOfWeekBitset.fromRaw(
      _partitionsWeekdays[fromPart],
    );
    partition[day] = false;
    _partitionsWeekdays[fromPart] = partition.rawValue;
  }

  /// Empty a partition
  void clear(int partition) {
    _partitionsWeekdays[partition] = 0;
  }

  /// Deep copy, but the object remains
  /// It needs [value] to have the same numberOfSubsets as the instance
  void copyFrom(DayOfWeekPartitions value) {
    if (value.numberOfSubsets == numberOfSubsets) {
      for (int part = 0; part < numberOfSubsets; part++) {
        _partitionsWeekdays[part] = value._partitionsWeekdays[part];
      }
    } else {
      throw ArgumentError("Number of partitions doesn't match.");
    }
  }

  /// Copy one part value
  void copyPartFrom(DayOfWeekBitset value, {required int toPartition}) {
    if (toPartition < numberOfSubsets) {
      final negated = ~(value.rawValue);
      for (int part = 0; part < numberOfSubsets; part++) {
        if (part == toPartition) {
          _partitionsWeekdays[toPartition] = value.rawValue;
        } else {
          _partitionsWeekdays[part] &= negated;
        }
      }
    } else {
      throw ArgumentError(
        "Partition $toPartition "
        "exceding the number of partitions ($numberOfSubsets).",
      );
    }
  }

  //-------- end class ---------------------------------------------------------
}
