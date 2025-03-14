// filepath: /home/cesc/Documents/cursos/flutter/flutter_projecte_cifo/mypills/test/model/meal_pillmealtime_pair_list_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mypills/model/alarm_key_list.dart';
import 'package:mypills/model/meal_pillmealtime_pair.dart';

void main() {
  group('MealPillmealtimePairList', () {
    test('Constructor initializes correctly', () {
      final list = AlarmKeyList([
        MealPillmealtimePair(1),
        MealPillmealtimePair(2),
        MealPillmealtimePair(3),
      ]);

      expect(list.length, 3);
      expect(list[0].id, 1);
      expect(list[1].id, 2);
      expect(list[2].id, 3);
    });

    test('fromJsonList initializes correctly', () {
      final list = AlarmKeyList.fromJsonList([1, 2, 3]);

      expect(list.length, 3);
      expect(list[0].id, 1);
      expect(list[1].id, 2);
      expect(list[2].id, 3);
    });

    test('parse initializes correctly', () {
      final list = AlarmKeyList.parse('[1,2,3]');

      expect(list.length, 3);
      expect(list[0].id, 1);
      expect(list[1].id, 2);
      expect(list[2].id, 3);
    });

    test('length getter returns correct length', () {
      final list = AlarmKeyList([
        MealPillmealtimePair(1),
        MealPillmealtimePair(2),
      ]);

      expect(list.length, 2);
    });

    test('operator [] returns correct element', () {
      final list = AlarmKeyList([
        MealPillmealtimePair(1),
        MealPillmealtimePair(2),
      ]);

      expect(list[0].id, 1);
      expect(list[1].id, 2);
    });

    test('operator []= updates element correctly', () {
      final list = AlarmKeyList([
        MealPillmealtimePair(1),
        MealPillmealtimePair(2),
      ]);

      list[0] = MealPillmealtimePair(3);
      expect(list[0].id, 3);
    });

    test('length setter throws UnsupportedError', () {
      final list = AlarmKeyList([
        MealPillmealtimePair(1),
        MealPillmealtimePair(2),
      ]);

      expect(() => list.length = 3, throwsUnsupportedError);
    });

    test('parse throws ArgumentError for invalid input', () {
      expect(() => AlarmKeyList.parse('invalid'), throwsArgumentError);
    });
  });
}
