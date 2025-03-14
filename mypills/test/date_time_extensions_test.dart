import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mypills/extensions/date_time_extensions.dart';

void main() {
  group('DateTimeExtensions Tests', () {
    test('today returns current date with time set to zero', () {
      final now = DateTime.now();
      final today = DateTimeExtensions.today();
      expect(today.year, now.year);
      expect(today.month, now.month);
      expect(today.day, now.day);
      expect(today.hour, 0);
      expect(today.minute, 0);
      expect(today.second, 0);
      expect(today.millisecond, 0);
    });

    test('tomorrow returns the next day with time set to zero', () {
      final now = DateTime.now();
      final tomorrow = DateTimeExtensions.tomorrow();
      final expectedTomorrow = now.add(Duration(days: 1));
      expect(tomorrow.year, expectedTomorrow.year);
      expect(tomorrow.month, expectedTomorrow.month);
      expect(tomorrow.day, expectedTomorrow.day);
      expect(tomorrow.hour, 0);
      expect(tomorrow.minute, 0);
      expect(tomorrow.second, 0);
      expect(tomorrow.millisecond, 0);
    });

    test('yesterday returns the previous day with time set to zero', () {
      final now = DateTime.now();
      final yesterday = DateTimeExtensions.yesterday();
      final expectedYesterday = now.subtract(Duration(days: 1));
      expect(yesterday.year, expectedYesterday.year);
      expect(yesterday.month, expectedYesterday.month);
      expect(yesterday.day, expectedYesterday.day);
      expect(yesterday.hour, 0);
      expect(yesterday.minute, 0);
      expect(yesterday.second, 0);
      expect(yesterday.millisecond, 0);
    });

    test('nextDay returns the next day with time set to zero', () {
      final date = DateTime(2023, 10, 10);
      final nextDay = DateTimeExtensions.nextDay(date);
      final expectedNextDay = date.add(Duration(days: 1));
      expect(nextDay.year, expectedNextDay.year);
      expect(nextDay.month, expectedNextDay.month);
      expect(nextDay.day, expectedNextDay.day);
      expect(nextDay.hour, 0);
      expect(nextDay.minute, 0);
      expect(nextDay.second, 0);
      expect(nextDay.millisecond, 0);
    });

    test('theDayBefore returns the previous day with time set to zero', () {
      final date = DateTime(2023, 10, 10);
      final theDayBefore = DateTimeExtensions.theDayBefore(date);
      final expectedTheDayBefore = date.subtract(Duration(days: 1));
      expect(theDayBefore.year, expectedTheDayBefore.year);
      expect(theDayBefore.month, expectedTheDayBefore.month);
      expect(theDayBefore.day, expectedTheDayBefore.day);
      expect(theDayBefore.hour, 0);
      expect(theDayBefore.minute, 0);
      expect(theDayBefore.second, 0);
      expect(theDayBefore.millisecond, 0);
    });

    test('todayAt returns today with specific TimeOfDay', () {
      final time = TimeOfDay(hour: 12, minute: 30);
      final todayAt = DateTimeExtensions.todayAt(time);
      final today = DateTimeExtensions.today();
      expect(todayAt.year, today.year);
      expect(todayAt.month, today.month);
      expect(todayAt.day, today.day);
      expect(todayAt.hour, time.hour);
      expect(todayAt.minute, time.minute);
    });

    test('tomorrowAt returns tomorrow with specific TimeOfDay', () {
      final time = TimeOfDay(hour: 12, minute: 30);
      final tomorrowAt = DateTimeExtensions.tomorrowAt(time);
      final tomorrow = DateTimeExtensions.tomorrow();
      expect(tomorrowAt.year, tomorrow.year);
      expect(tomorrowAt.month, tomorrow.month);
      expect(tomorrowAt.day, tomorrow.day);
      expect(tomorrowAt.hour, time.hour);
      expect(tomorrowAt.minute, time.minute);
    });

    test('isToday returns true if the time is today', () {
      final time = TimeOfDay(hour: 23, minute: 59);
      expect(DateTimeExtensions.isToday(time), isTrue);
    });

    test('isToday returns false if the time is tomorrow', () {
      final time = TimeOfDay(hour: 0, minute: 0);
      expect(DateTimeExtensions.isToday(time), isFalse);
    });

    test('date returns the date without time', () {
      final dateTime = DateTime(2023, 10, 10, 12, 30);
      final date = dateTime.date();
      expect(date.year, 2023);
      expect(date.month, 10);
      expect(date.day, 10);
      expect(date.hour, 0);
      expect(date.minute, 0);
      expect(date.second, 0);
      expect(date.millisecond, 0);
    });

    test('toDateString returns the date as a string', () {
      final dateTime = DateTime(2023, 10, 10);
      expect(dateTime.toDateString(), '2023-10-10');
    });

    test('at returns the date at a specific TimeOfDay', () {
      final dateTime = DateTime(2023, 10, 10);
      final time = TimeOfDay(hour: 12, minute: 30);
      final dateAtTime = dateTime.at(time);
      expect(dateAtTime.year, 2023);
      expect(dateAtTime.month, 10);
      expect(dateAtTime.day, 10);
      expect(dateAtTime.hour, 12);
      expect(dateAtTime.minute, 30);
    });

    test('round rounds the DateTime to the nearest minute', () {
      final dateTime = DateTime(2023, 10, 10, 12, 30, 30);
      final roundedDateTime = dateTime.round();
      expect(roundedDateTime.year, 2023);
      expect(roundedDateTime.month, 10);
      expect(roundedDateTime.day, 10);
      expect(roundedDateTime.hour, 12);
      expect(roundedDateTime.minute, 31);
      expect(roundedDateTime.second, 0);
    });

    test('round rounds the DateTime to the nearest second', () {
      final dateTime = DateTime(2023, 10, 10, 12, 30, 30, 500);
      final roundedDateTime = dateTime.round(RoundTimeTo.second);
      expect(roundedDateTime.year, 2023);
      expect(roundedDateTime.month, 10);
      expect(roundedDateTime.day, 10);
      expect(roundedDateTime.hour, 12);
      expect(roundedDateTime.minute, 30);
      expect(roundedDateTime.second, 31);
    });

    test(
      'isLastDayOfMonth returns true if the date is the last day of the month',
      () {
        final dateTime = DateTime(2023, 10, 31);
        expect(dateTime.isLastDayOfMonth(), isTrue);
      },
    );

    test(
      'isLastDayOfMonth returns false if the date is not the last day of the month',
      () {
        final dateTime = DateTime(2023, 10, 30);
        expect(dateTime.isLastDayOfMonth(), isFalse);
      },
    );
  });
}
