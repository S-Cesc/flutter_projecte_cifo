import 'package:flutter_test/flutter_test.dart';
import 'package:mypills/model/alarm.dart';
import 'package:mypills/model/enum/meal.dart';
import 'package:mypills/model/enum/pill_meal_time.dart';

void main() {
  group('Alarm Tests', () {
    test('Constructor initializes correctly', () {
      final alarm = Alarm(10);
      expect(alarm.id, 10);
      expect(alarm.isRunning, isFalse);
      expect(alarm.isSnoozed, isFalse);
      expect(alarm.actualReplay, 0);
      expect(alarm.lastShot, isNull);
      expect(alarm.whenWasStopped, isNull);
      expect(alarm.dealingWith, isNull);
    });

    test('Empty constructor initializes correctly', () {
      final alarm = Alarm.empty(Meal.breakfast, PillMealTime.before);
      expect(alarm.meal, Meal.breakfast);
      expect(alarm.pillMealTime, PillMealTime.before);
      expect(alarm.isRunning, isFalse);
      expect(alarm.isSnoozed, isFalse);
      expect(alarm.actualReplay, 0);
      expect(alarm.lastShot, isNull);
      expect(alarm.whenWasStopped, isNull);
      expect(alarm.dealingWith, isNull);
    });

    test('Copy constructor initializes correctly', () {
      final original = Alarm(10);
      original.markAlarmfired();
      final copy = Alarm.copyFrom(
        Meal.breakfast,
        PillMealTime.before,
        original,
      );
      expect(copy.meal, Meal.breakfast);
      expect(copy.pillMealTime, PillMealTime.before);
      expect(copy.isRunning, isFalse);
      expect(copy.isSnoozed, isFalse);
      expect(copy.actualReplay, 0);
      expect(copy.lastShot, original.lastShot);
      expect(copy.whenWasStopped, original.whenWasStopped);
      expect(copy.dealingWith, original.dealingWith);
    });

    test('fromJson initializes correctly', () {
      final json = {
        'IdKey': 10,
        'lastShot': '2023-10-10T12:30:00.000',
        'stopped': '2023-10-10T12:45:00.000',
        'dealingWith': '2023-10-10T12:35:00.000',
        'isRunning': true,
        'isSnoozed': false,
        'nReplay': 1,
      };
      final alarm = Alarm.fromJson(json);
      expect(alarm.id, 10);
      expect(alarm.lastShot, DateTime.parse('2023-10-10T12:30:00.000'));
      expect(alarm.whenWasStopped, DateTime.parse('2023-10-10T12:45:00.000'));
      expect(alarm.dealingWith, DateTime.parse('2023-10-10T12:35:00.000'));
      expect(alarm.isRunning, isTrue);
      expect(alarm.isSnoozed, isFalse);
      expect(alarm.actualReplay, 1);
    });

    test('toJson returns correct JSON', () {
      final alarm = Alarm(10);
      alarm.markAlarmfired();
      final json = alarm.toJson();
      expect(json['IdKey'], 10);
      expect(json['lastShot'], isNotNull);
      expect(json['stopped'], isNull);
      expect(json['dealingWith'], isNull);
      expect(json['isRunning'], isTrue);
      expect(json['isSnoozed'], isFalse);
      expect(json['nReplay'], 1);
    });

    test('compareTo returns correct comparison', () {
      final alarm1 = Alarm(10);
      final alarm2 = Alarm(20);
      expect(alarm1.compareTo(alarm2), -1);
      expect(alarm2.compareTo(alarm1), 1);
      expect(alarm1.compareTo(alarm1), 0);
    });

    test('markAlarmfired sets correct state', () {
      final alarm = Alarm(10);
      alarm.markAlarmfired();
      expect(alarm.isRunning, isTrue);
      expect(alarm.isSnoozed, isFalse);
      expect(alarm.actualReplay, 1);
      expect(alarm.lastShot, isNotNull);
    });

    test('markAlarmDealingWith sets correct state', () {
      final alarm = Alarm(10);
      alarm.markAlarmDealingWith();
      expect(alarm.isRunning, isTrue);
      expect(alarm.isSnoozed, isFalse);
      expect(alarm.dealingWith, isNotNull);
    });

    test('markAlarmSnoozed sets correct state', () {
      final alarm = Alarm(10);
      alarm.markAlarmSnoozed();
      expect(alarm.isRunning, isFalse);
      expect(alarm.isSnoozed, isTrue);
    });

    test('markAlarmStopped sets correct state', () {
      final alarm = Alarm(10);
      alarm.markAlarmfired();
      alarm.markAlarmStopped();
      expect(alarm.isRunning, isFalse);
      expect(alarm.isSnoozed, isFalse);
      expect(alarm.actualReplay, 0);
      expect(alarm.whenWasStopped, isNotNull);
    });

  });
}
