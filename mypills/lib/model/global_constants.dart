import 'package:flutter/material.dart' show TimeOfDay;

/// Constants for the application
class GlobalConstants {
  //
  /// Number of tabs with alternative meal time tables
  static const nAltMealTimeTables = 3;

  /// Number of meals used for prescriptions
  /// It is the minimum required number of day meals
  /// which have to be defined
  static const nMealPrescriptions = 3;

  /// Max minutes between meals
  /// It is used to allow the meal sequence to pass to the next day
  /// It must be at least max(mealDuration) + minMinutesBetweenMeals
  /// It doesn't apply in the sleep time (after the last meal)
  /// Sleep time must be greater than this value
  static const int maxMinutesBetweenMeals =
      4 * TimeOfDay.minutesPerHour + 2 * TimeOfDay.minutesPerHour ~/ 3;

  /// Max number of retries for operations not expected to fail
  static const maxRetries = 3;

  /// Delay to retry operation
  static const delayToRetry = Duration(milliseconds: 50);

  /// Delay to retry operation, when a long delay is needed
  static const longDelayToRetry = Duration(milliseconds: 150);

  /// Very short delay for operation
  static const veryShortDelayForOperation = Duration(milliseconds: 5);

  /// Delay for operation
  static const shortDelayForOperation = Duration(milliseconds: 50);

  /// Delay for operation
  static const delayForOperation = Duration(milliseconds: 100);

  /// Long delay for operation
  static const longDelayForOperation = Duration(milliseconds: 300);

  /// Very short delay for operation
  static const veryLongDelayForOperation = Duration(milliseconds: 1500);

  /// Duration for long tooltips
  static const longTooltip = Duration(seconds: 6);

  /// Dynamic duration of a tooltip
  static Duration tooltipDuration(int messageLength) =>
      Duration(seconds: 1 + messageLength ~/ 5);
}
