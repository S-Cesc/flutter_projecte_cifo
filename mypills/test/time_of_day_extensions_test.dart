import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mypills/extensions/time_of_day_extensions.dart';

void main() {
  group('TimeOfDayExtension Tests', () {
    test('parseTimeOfDay returns correct TimeOfDay', () {
      expect(
        TimeOfDayExtension.parseTimeOfDay('12:30'),
        TimeOfDay(hour: 12, minute: 30),
      );
      expect(
        TimeOfDayExtension.parseTimeOfDay('00:00'),
        TimeOfDay(hour: 0, minute: 0),
      );
      expect(
        TimeOfDayExtension.parseTimeOfDay('23:59'),
        TimeOfDay(hour: 23, minute: 59),
      );
      expect(TimeOfDayExtension.parseTimeOfDay(null), isNull);
      expect(TimeOfDayExtension.parseTimeOfDay('invalid'), isNull);
      expect(TimeOfDayExtension.parseTimeOfDay('24:00'), isNull);
      expect(TimeOfDayExtension.parseTimeOfDay('12:60'), isNull);
    });

    test('max returns the correct maximum TimeOfDay', () {
      final time1 = TimeOfDay(hour: 12, minute: 30);
      final time2 = TimeOfDay(hour: 13, minute: 0);
      expect(TimeOfDayExtension.max(time1, time2), time2);
      expect(TimeOfDayExtension.max(time2, time1), time2);
      expect(TimeOfDayExtension.max(time1, time1), time1);
    });

    test('gt returns correct boolean', () {
      final time1 = TimeOfDay(hour: 23, minute: 30);
      final time2 = TimeOfDay(hour: 23, minute: 45);
      final time3 = TimeOfDay(hour: 0, minute: 30);
      expect(time1.gt(time2, 180), isFalse);
      expect(time1.gt(time3, 180), isFalse);
      expect(time2.gt(time1, 180), isTrue);
      expect(time3.gt(time1, 180), isTrue);
      expect(time2.gt(time3, 180), isFalse);
      expect(time3.gt(time2, 180), isTrue);
    });

    test('gte returns correct boolean', () {
      final time1 = TimeOfDay(hour: 23, minute: 30);
      final time2 = TimeOfDay(hour: 23, minute: 45);
      final time3 = TimeOfDay(hour: 0, minute: 30);
      final time3b = TimeOfDay(hour: 0, minute: 30);
      expect(time1.gte(time1), isTrue);
      expect(time2.gte(time2), isTrue);
      expect(time3.gte(time3b), isTrue);
      expect(time1.gte(time2, 180), isFalse);
      expect(time1.gte(time3, 180), isFalse);
      expect(time2.gte(time1, 180), isTrue);
      expect(time3.gte(time1, 180), isTrue);
      expect(time2.gte(time3, 180), isFalse);
      expect(time3.gte(time2, 180), isTrue);
    });

    test('operator > returns correct boolean', () {
      final time1 = TimeOfDay(hour: 12, minute: 30);
      final time2 = TimeOfDay(hour: 13, minute: 0);
      expect(time2 > time1, isTrue);
      expect(time1 > time2, isFalse);
    });

    test('operator >= returns correct boolean', () {
      final time1 = TimeOfDay(hour: 12, minute: 30);
      final time2 = TimeOfDay(hour: 13, minute: 0);
      expect(time2 >= time1, isTrue);
      expect(time1 >= time2, isFalse);
      expect(time1 >= time1, isTrue);
    });

    test('plusMinutes adds minutes correctly', () {
      final time = TimeOfDay(hour: 12, minute: 30);
      expect(time.plusMinutes(30), TimeOfDay(hour: 13, minute: 0));
      expect(time.plusMinutes(90), TimeOfDay(hour: 14, minute: 0));
      expect(time.plusMinutes(-30), TimeOfDay(hour: 12, minute: 0));
      expect(time.plusMinutes(1440), time); // 1440 minutes in a day
    });

    test('minutesUntil returns correct difference', () {
      final time1 = TimeOfDay(hour: 12, minute: 30);
      final time2 = TimeOfDay(hour: 13, minute: 0);
      expect(time1.minutesUntil(time2), 30);
      expect(time2.minutesUntil(time1), 1410); // 1440 - 30
    });

    test('isBeforeOrAtSameTimeAs returns correct boolean', () {
      final time1 = TimeOfDay(hour: 12, minute: 30);
      final time2 = TimeOfDay(hour: 13, minute: 0);
      expect(time1.isBeforeOrAtSameTimeAs(time2), isTrue);
      expect(time2.isBeforeOrAtSameTimeAs(time1), isFalse);
      expect(time1.isBeforeOrAtSameTimeAs(time1), isTrue);
    });

    test('isAfterOrAtSameTimeAs returns correct boolean', () {
      final time1 = TimeOfDay(hour: 12, minute: 30);
      final time2 = TimeOfDay(hour: 13, minute: 0);
      expect(time1.isAfterOrAtSameTimeAs(time2), isFalse);
      expect(time2.isAfterOrAtSameTimeAs(time1), isTrue);
      expect(time1.isAfterOrAtSameTimeAs(time1), isTrue);
    });

    test('isLater returns correct boolean', () {
      final time1 = TimeOfDay(hour: 23, minute: 30);
      final time2 = TimeOfDay(hour: 23, minute: 45);
      final time3 = TimeOfDay(hour: 0, minute: 30);
      expect(time1.isLater(time2, 180), isFalse);
      expect(time1.isLater(time3, 180), isFalse);
      expect(time2.isLater(time1, 180), isTrue);
      expect(time3.isLater(time1, 180), isTrue);
      expect(time2.isLater(time3, 180), isFalse);
      expect(time3.isLater(time2, 180), isTrue);
    });

    test('toJsonString returns correct string', () {
      final time = TimeOfDay(hour: 12, minute: 30);
      expect(time.toJsonString, '12:30');
      expect(TimeOfDay(hour: 0, minute: 0).toJsonString, '00:00');
      expect(TimeOfDay(hour: 23, minute: 59).toJsonString, '23:59');
    });
  });
}
