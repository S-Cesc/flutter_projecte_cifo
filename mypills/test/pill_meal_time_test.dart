import 'package:flutter_test/flutter_test.dart';
import 'package:mypills/model/enum/pill_meal_time.dart';

void main() {
  group('PillMealTime Tests', () {
    test('PillMealTime.fromId initializes correctly', () {
      expect(PillMealTime.fromId(-5), PillMealTime.longBefore);
      expect(PillMealTime.fromId(-2), PillMealTime.before);
      expect(PillMealTime.fromId(0), PillMealTime.at);
      expect(PillMealTime.fromId(2), PillMealTime.after);
      expect(PillMealTime.fromId(5), PillMealTime.longAfter);
      expect(() => PillMealTime.fromId(10), throwsRangeError);
    });

    test('PillMealTime.next returns correct next value', () {
      expect(PillMealTime.longBefore.next(), PillMealTime.before);
      expect(PillMealTime.before.next(), PillMealTime.at);
      expect(PillMealTime.at.next(), PillMealTime.after);
      expect(PillMealTime.after.next(), PillMealTime.longAfter);
      expect(PillMealTime.longAfter.next(), isNull);
    });

    test('PillMealTime.operator < returns correct boolean', () {
      expect(PillMealTime.longBefore < PillMealTime.before, isTrue);
      expect(PillMealTime.before < PillMealTime.at, isTrue);
      expect(PillMealTime.at < PillMealTime.after, isTrue);
      expect(PillMealTime.after < PillMealTime.longAfter, isTrue);
      expect(PillMealTime.longAfter < PillMealTime.longBefore, isFalse);
    });

  });
}
