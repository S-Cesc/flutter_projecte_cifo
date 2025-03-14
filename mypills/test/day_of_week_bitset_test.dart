import 'package:flutter_test/flutter_test.dart';
import 'package:mypills/model/enum/day_of_week.dart';
import 'package:mypills/model/enum/day_of_week_bitset.dart';

void main() {
  group('DayOfWeekBitset Tests', () {
    test('Empty bitset is empty', () {
      final bitset = DayOfWeekBitset.empty();
      expect(bitset.isEmpty, isTrue);
      expect(bitset.isNotEmpty, isFalse);
    });

    test('Bitset from Set initializes correctly', () {
      final bitset = DayOfWeekBitset({DayOfWeek.monday, DayOfWeek.wednesday});
      expect(bitset.contains(DayOfWeek.monday), isTrue);
      expect(bitset.contains(DayOfWeek.tuesday), isFalse);
      expect(bitset.contains(DayOfWeek.wednesday), isTrue);
    });

    test('Bitset from raw value initializes correctly', () {
      final bitset = DayOfWeekBitset.fromRaw(5); // 101 in binary
      expect(bitset.contains(DayOfWeek.monday), isTrue);
      expect(bitset.contains(DayOfWeek.tuesday), isFalse);
      expect(bitset.contains(DayOfWeek.wednesday), isTrue);
    });

    test('Bitset from JSON initializes correctly', () {
      final bitset = DayOfWeekBitset.fromJson({'days': 5}, 'days');
      expect(bitset.contains(DayOfWeek.monday), isTrue);
      expect(bitset.contains(DayOfWeek.tuesday), isFalse);
      expect(bitset.contains(DayOfWeek.wednesday), isTrue);
    });

    test('toSet returns correct Set', () {
      final bitset = DayOfWeekBitset({DayOfWeek.monday, DayOfWeek.wednesday});
      final set = bitset.toSet;
      expect(set.contains(DayOfWeek.monday), isTrue);
      expect(set.contains(DayOfWeek.tuesday), isFalse);
      expect(set.contains(DayOfWeek.wednesday), isTrue);
    });

    test('toJson returns correct JSON', () {
      final bitset = DayOfWeekBitset({DayOfWeek.monday, DayOfWeek.wednesday});
      final json = bitset.toJson('days');
      expect(json['days'], 5); // 101 in binary
    });

    test('count returns correct number of elements', () {
      final bitset = DayOfWeekBitset({DayOfWeek.monday, DayOfWeek.wednesday});
      expect(bitset.count(), 2);
    });

    test('operator [] returns correct boolean', () {
      final bitset = DayOfWeekBitset({DayOfWeek.monday, DayOfWeek.wednesday});
      expect(bitset[DayOfWeek.monday], isTrue);
      expect(bitset[DayOfWeek.tuesday], isFalse);
      expect(bitset[DayOfWeek.wednesday], isTrue);
    });

    test('operator & returns correct bitset', () {
      final bitset1 = DayOfWeekBitset({DayOfWeek.monday, DayOfWeek.wednesday});
      final bitset2 = DayOfWeekBitset({DayOfWeek.monday, DayOfWeek.tuesday});
      final result = bitset1 & bitset2;
      expect(result.contains(DayOfWeek.monday), isTrue);
      expect(result.contains(DayOfWeek.tuesday), isFalse);
      expect(result.contains(DayOfWeek.wednesday), isFalse);
    });

    test('operator | returns correct bitset', () {
      final bitset1 = DayOfWeekBitset({DayOfWeek.monday, DayOfWeek.wednesday});
      final bitset2 = DayOfWeekBitset({DayOfWeek.monday, DayOfWeek.tuesday});
      final result = bitset1 | bitset2;
      expect(result.contains(DayOfWeek.monday), isTrue);
      expect(result.contains(DayOfWeek.tuesday), isTrue);
      expect(result.contains(DayOfWeek.wednesday), isTrue);
    });

    test('operator ~ returns correct bitset', () {
      final bitset = DayOfWeekBitset({DayOfWeek.monday, DayOfWeek.wednesday});
      final result = ~bitset;
      expect(result.contains(DayOfWeek.monday), isFalse);
      expect(result.contains(DayOfWeek.tuesday), isTrue);
      expect(result.contains(DayOfWeek.wednesday), isFalse);
    });
  });

  group('UpdatableDayOfWeekBitset Tests', () {
    test('Empty bitset is empty', () {
      final bitset = UpdatableDayOfWeekBitset.empty();
      expect(bitset.isEmpty, isTrue);
      expect(bitset.isNotEmpty, isFalse);
    });

    test('Bitset from Set initializes correctly', () {
      final bitset = UpdatableDayOfWeekBitset({
        DayOfWeek.monday,
        DayOfWeek.wednesday,
      });
      expect(bitset.contains(DayOfWeek.monday), isTrue);
      expect(bitset.contains(DayOfWeek.tuesday), isFalse);
      expect(bitset.contains(DayOfWeek.wednesday), isTrue);
    });

    test('Bitset from raw value initializes correctly', () {
      final bitset = UpdatableDayOfWeekBitset.fromRaw(5); // 101 in binary
      expect(bitset.contains(DayOfWeek.monday), isTrue);
      expect(bitset.contains(DayOfWeek.tuesday), isFalse);
      expect(bitset.contains(DayOfWeek.wednesday), isTrue);
    });

    test('Bitset from JSON initializes correctly', () {
      final bitset = UpdatableDayOfWeekBitset.fromJson({'days': 5}, 'days');
      expect(bitset.contains(DayOfWeek.monday), isTrue);
      expect(bitset.contains(DayOfWeek.tuesday), isFalse);
      expect(bitset.contains(DayOfWeek.wednesday), isTrue);
    });

    test('emptySet clears the bitset', () {
      final bitset = UpdatableDayOfWeekBitset({
        DayOfWeek.monday,
        DayOfWeek.wednesday,
      });
      bitset.emptySet();
      expect(bitset.isEmpty, isTrue);
    });

    test('operator []= updates the bitset correctly', () {
      final bitset = UpdatableDayOfWeekBitset.empty();
      bitset[DayOfWeek.monday] = true;
      expect(bitset.contains(DayOfWeek.monday), isTrue);
      bitset[DayOfWeek.monday] = false;
      expect(bitset.contains(DayOfWeek.monday), isFalse);
    });

    test('and updates the bitset correctly', () {
      final bitset1 = UpdatableDayOfWeekBitset({
        DayOfWeek.monday,
        DayOfWeek.wednesday,
      });
      final bitset2 = DayOfWeekBitset({DayOfWeek.monday, DayOfWeek.tuesday});
      bitset1.and(bitset2);
      expect(bitset1.contains(DayOfWeek.monday), isTrue);
      expect(bitset1.contains(DayOfWeek.tuesday), isFalse);
      expect(bitset1.contains(DayOfWeek.wednesday), isFalse);
    });

    test('or updates the bitset correctly', () {
      final bitset1 = UpdatableDayOfWeekBitset({
        DayOfWeek.monday,
        DayOfWeek.wednesday,
      });
      final bitset2 = DayOfWeekBitset({DayOfWeek.monday, DayOfWeek.tuesday});
      bitset1.or(bitset2);
      expect(bitset1.contains(DayOfWeek.monday), isTrue);
      expect(bitset1.contains(DayOfWeek.tuesday), isTrue);
      expect(bitset1.contains(DayOfWeek.wednesday), isTrue);
    });

    test('not updates the bitset correctly', () {
      final bitset = UpdatableDayOfWeekBitset({
        DayOfWeek.monday,
        DayOfWeek.wednesday,
      });
      bitset.not();
      expect(bitset.contains(DayOfWeek.monday), isFalse);
      expect(bitset.contains(DayOfWeek.tuesday), isTrue);
      expect(bitset.contains(DayOfWeek.wednesday), isFalse);
    });
  });
}
