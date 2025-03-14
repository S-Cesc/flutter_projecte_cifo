import 'package:flutter_test/flutter_test.dart';
import 'package:mypills/model/day_of_week_partitions.dart';
import 'package:mypills/model/enum/day_of_week.dart';
import 'package:mypills/model/enum/day_of_week_bitset.dart';

void main() {
  group('DayOfWeekPartitions Tests', () {
    test('Constructor initializes correctly', () {
      final partitions = DayOfWeekPartitions(numberOfSubsets: 3);
      expect(partitions.numberOfSubsets, 3);
    });

    test('Factory constructor parse initializes correctly', () {
      final partitions = DayOfWeekPartitions.parse('3012----');
      expect(partitions.numberOfSubsets, 3);
      expect(partitions[DayOfWeek.monday], 0);
      expect(partitions[DayOfWeek.tuesday], 1);
      expect(partitions[DayOfWeek.wednesday], 2);
    });

    test('count returns correct number of elements', () {
      final partitions = DayOfWeekPartitions(numberOfSubsets: 3);
      partitions[DayOfWeek.monday] = 0;
      partitions[DayOfWeek.tuesday] = 1;
      partitions[DayOfWeek.wednesday] = 2;
      expect(partitions.count(), 3);
    });

    test('contains returns correct boolean', () {
      final partitions = DayOfWeekPartitions(numberOfSubsets: 3);
      partitions[DayOfWeek.monday] = 0;
      expect(partitions.contains(DayOfWeek.monday), isTrue);
      expect(partitions.contains(DayOfWeek.tuesday), isFalse);
    });

    test('missingDays returns correct set of days', () {
      final partitions = DayOfWeekPartitions(numberOfSubsets: 3);
      partitions[DayOfWeek.monday] = 0;
      partitions[DayOfWeek.tuesday] = 1;
      final missingDays = partitions.missingDays;
      expect(missingDays.contains(DayOfWeek.monday), isFalse);
      expect(missingDays.contains(DayOfWeek.tuesday), isFalse);
      expect(missingDays.contains(DayOfWeek.wednesday), isTrue);
    });

    test('operator [] and []= work correctly', () {
      final partitions = DayOfWeekPartitions(numberOfSubsets: 3);
      partitions[DayOfWeek.monday] = 0;
      expect(partitions[DayOfWeek.monday], 0);
      partitions[DayOfWeek.monday] = null;
      expect(partitions[DayOfWeek.monday], isNull);
    });

    test('remove works correctly', () {
      final partitions = DayOfWeekPartitions(numberOfSubsets: 3);
      partitions[DayOfWeek.monday] = 0;
      partitions.remove(fromPart: 0, day: DayOfWeek.monday);
      expect(partitions[DayOfWeek.monday], isNull);
    });

    test('clear works correctly', () {
      final partitions = DayOfWeekPartitions(numberOfSubsets: 3);
      partitions[DayOfWeek.monday] = 0;
      partitions.clear(0);
      expect(partitions[DayOfWeek.monday], isNull);
    });

    test('copyFrom works correctly', () {
      final partitions1 = DayOfWeekPartitions(numberOfSubsets: 3);
      partitions1[DayOfWeek.monday] = 0;
      partitions1[DayOfWeek.tuesday] = 1;

      final partitions2 = DayOfWeekPartitions(numberOfSubsets: 3);
      partitions2.copyFrom(partitions1);

      expect(partitions2[DayOfWeek.monday], 0);
      expect(partitions2[DayOfWeek.tuesday], 1);
    });

    test('copyPartFrom works correctly', () {
      final partitions = DayOfWeekPartitions(numberOfSubsets: 3);
      final bitset = UpdatableDayOfWeekBitset.empty();
      bitset[DayOfWeek.monday] = true;
      bitset[DayOfWeek.tuesday] = true;

      partitions.copyPartFrom(bitset, toPartition: 0);

      expect(partitions[DayOfWeek.monday], 0);
      expect(partitions[DayOfWeek.tuesday], 0);
    });

    test('toString returns correct string representation', () {
      final partitions = DayOfWeekPartitions(numberOfSubsets: 3);
      partitions[DayOfWeek.monday] = 0;
      partitions[DayOfWeek.tuesday] = 1;
      partitions[DayOfWeek.wednesday] = 2;

      expect(partitions.toString(), '3012----');
    });

    test('parse throws FormatException for invalid string', () {
      expect(() => DayOfWeekPartitions.parse('invalid-andverylong'), throwsFormatException);
    });

    test('parse throws RangeError for invalid character', () {
      expect(() => DayOfWeekPartitions.parse('3-0-1-8-'), throwsRangeError);
    });
  });
}
