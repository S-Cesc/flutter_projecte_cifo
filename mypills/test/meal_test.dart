import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mypills/model/enum/meal.dart';

void main() {
  group('Meal Enum Tests', () {
    test('defaultMealTime returns correct TimeOfDay', () {
      expect(
        Meal.defaultMealTime(Meal.breakfast),
        const TimeOfDay(hour: 7, minute: 0),
      );
      expect(
        Meal.defaultMealTime(Meal.elevenses),
        const TimeOfDay(hour: 11, minute: 0),
      );
      expect(
        Meal.defaultMealTime(Meal.brunch),
        const TimeOfDay(hour: 12, minute: 0),
      );
      expect(
        Meal.defaultMealTime(Meal.lunch),
        const TimeOfDay(hour: 13, minute: 0),
      );
      expect(
        Meal.defaultMealTime(Meal.tea),
        const TimeOfDay(hour: 15, minute: 30),
      );
      expect(
        Meal.defaultMealTime(Meal.highTea),
        const TimeOfDay(hour: 18, minute: 0),
      );
      expect(
        Meal.defaultMealTime(Meal.dinner),
        const TimeOfDay(hour: 20, minute: 0),
      );
      expect(
        Meal.defaultMealTime(Meal.supper),
        const TimeOfDay(hour: 21, minute: 30),
      );
    });

    test('defaultMealDuration returns correct Duration', () {
      expect(
        Meal.defaultMealDuration(Meal.breakfast),
        const Duration(minutes: 35),
      );
      expect(
        Meal.defaultMealDuration(Meal.elevenses),
        const Duration(minutes: 15),
      );
      expect(
        Meal.defaultMealDuration(Meal.brunch),
        const Duration(minutes: 45),
      );
      expect(Meal.defaultMealDuration(Meal.lunch), const Duration(minutes: 50));
      expect(Meal.defaultMealDuration(Meal.tea), const Duration(minutes: 30));
      expect(
        Meal.defaultMealDuration(Meal.highTea),
        const Duration(minutes: 30),
      );
      expect(
        Meal.defaultMealDuration(Meal.dinner),
        const Duration(minutes: 45),
      );
      expect(
        Meal.defaultMealDuration(Meal.supper),
        const Duration(minutes: 35),
      );
    });

    test('fromId returns correct Meal', () {
      expect(Meal.fromId(10), Meal.breakfast);
      expect(Meal.fromId(20), Meal.elevenses);
      expect(Meal.fromId(30), Meal.brunch);
      expect(Meal.fromId(40), Meal.lunch);
      expect(Meal.fromId(50), Meal.tea);
      expect(Meal.fromId(60), Meal.highTea);
      expect(Meal.fromId(70), Meal.dinner);
      expect(Meal.fromId(80), Meal.supper);
    });

    test('fromId throws RangeError for invalid id', () {
      expect(() => Meal.fromId(-10), throwsRangeError);
      expect(() => Meal.fromId(0), throwsRangeError);
      expect(() => Meal.fromId(100), throwsRangeError);
    });

    test('fromId throws ArgumentError for non-multiple of 10 id', () {
      expect(() => Meal.fromId(5), throwsArgumentError);
      expect(() => Meal.fromId(85), throwsArgumentError);
      expect(() => Meal.fromId(15), throwsArgumentError);
    });

    test('fromOrdinal returns correct Meal', () {
      expect(Meal.fromOrdinal(1), Meal.breakfast);
      expect(Meal.fromOrdinal(2), Meal.elevenses);
      expect(Meal.fromOrdinal(3), Meal.brunch);
      expect(Meal.fromOrdinal(4), Meal.lunch);
      expect(Meal.fromOrdinal(5), Meal.tea);
      expect(Meal.fromOrdinal(6), Meal.highTea);
      expect(Meal.fromOrdinal(7), Meal.dinner);
      expect(Meal.fromOrdinal(8), Meal.supper);
    });

    test('operator < returns correct boolean', () {
      expect(Meal.breakfast < Meal.lunch, isTrue);
      expect(Meal.dinner < Meal.breakfast, isFalse);
    });

    test('next returns correct next Meal', () {
      expect(Meal.breakfast.next(), Meal.elevenses);
      expect(Meal.elevenses.next(), Meal.brunch);
      expect(Meal.brunch.next(), Meal.lunch);
      expect(Meal.lunch.next(), Meal.tea);
      expect(Meal.tea.next(), Meal.highTea);
      expect(Meal.highTea.next(), Meal.dinner);
      expect(Meal.dinner.next(), Meal.supper);
      expect(Meal.supper.next(), isNull);
    });

    test('previous returns correct previous Meal', () {
      expect(Meal.breakfast.previous(), isNull);
      expect(Meal.elevenses.previous(), Meal.breakfast);
      expect(Meal.brunch.previous(), Meal.elevenses);
      expect(Meal.lunch.previous(), Meal.brunch);
      expect(Meal.tea.previous(), Meal.lunch);
      expect(Meal.highTea.previous(), Meal.tea);
      expect(Meal.dinner.previous(), Meal.highTea);
      expect(Meal.supper.previous(), Meal.dinner);
    });

    test('ordinal returns correct ordinal', () {
      expect(Meal.breakfast.ordinal, 1);
      expect(Meal.elevenses.ordinal, 2);
      expect(Meal.brunch.ordinal, 3);
      expect(Meal.lunch.ordinal, 4);
      expect(Meal.tea.ordinal, 5);
      expect(Meal.highTea.ordinal, 6);
      expect(Meal.dinner.ordinal, 7);
      expect(Meal.supper.ordinal, 8);
    });

  });
}
