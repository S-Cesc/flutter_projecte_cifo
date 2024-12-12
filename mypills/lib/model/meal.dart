// Flutter
import 'package:flutter/material.dart';
// Localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//=======================================================================

/// Meals of the day; beleave that 7 are enough
enum Meal {
  /// breakfast
  breakfast(10),
  /// brunch
  brunch(20),
  /// lunch
  lunch(30),
  /// afternoon tea
  tea(40),
  /// highTea is used here as an early evening tea
  highTea(50),
  /// evening meal
  dinner(60),
  /// supper is used here as later than dinner
  supper(70);

  /// default meal times.
  /// Arbitrary set, programmer can change them without affectations
  static TimeOfDay defaultMealTime(Meal meal) {
    return switch (meal) {
      Meal.breakfast => const TimeOfDay(hour: 8, minute: 0),
      Meal.brunch => const TimeOfDay(hour: 11, minute: 0),
      Meal.lunch => const TimeOfDay(hour: 13, minute: 0),
      Meal.tea => const TimeOfDay(hour: 15, minute: 30),
      Meal.highTea => const TimeOfDay(hour: 18, minute: 0),
      Meal.dinner => const TimeOfDay(hour: 20, minute: 0),
      Meal.supper => const TimeOfDay(hour: 21, minute: 30),
    };
  }

  /// default duration of meals
  static Duration defaultMealDuration(Meal meal) {
    return switch (meal) {
      Meal.breakfast => const Duration(minutes: 35),
      Meal.brunch => const Duration(minutes: 45),
      Meal.lunch => const Duration(minutes: 50),
      Meal.tea => const Duration(minutes: 30),
      Meal.highTea => const Duration(minutes: 30),
      Meal.dinner => const Duration(minutes: 45),
      Meal.supper => const Duration(minutes: 35),
    };
  }

  //-----------------class state members and constructors ----------------------

  /// Identifier is defined from 10 to 70, leaving room for
  /// the increment or decrement of the forms ‘before’ and ‘after’.
  /// Also note that id=0 is used for testing purposes
  final int id;

  const Meal(this.id);

  factory Meal.fromId(int id) {
    return switch (id) {
      10 => Meal.breakfast,
      20 => Meal.brunch,
      30 => Meal.lunch,
      40 => Meal.tea,
      50 => Meal.highTea,
      60 => Meal.dinner,
      70 => Meal.supper,
      _ when id % 10 == 0 => throw RangeError.range(id, 10, 70),
      _ =>
        throw ArgumentError.value(id, "id", "MealTime.id are multiples of 10")
    };
  }

  /// Define ordinal; ordering
  factory Meal.fromOrdinal(int id) {
    return Meal.fromId(id * 10);
  }

  //-----------------------class special members--------------------------------

  /// Definition of natural time ordering, using the id
  bool operator <(covariant Meal other) {
    return id < other.id;
  }

  /// Next meal, not circular (supper is the last one, returning null)
  Meal? next() {
    return switch (this) {
      breakfast => brunch,
      brunch => lunch,
      lunch => tea,
      tea => highTea,
      highTea => dinner,
      dinner => supper,
      supper => null,
    };
  }

  //-----------------------class rest of members--------------------------------

  /// Define ordinal; ordering
  int get ordinal => id ~/ 10;

  //--------------------------------i18n----------------------------------------

  // Remember localization must be initialized:
  //    await initializeDateFormatting("ca", null)
  // You can get the current locale from widget
  // locale = WidgetsBinding.instance!.window.locale
  /// Localized name
  /// they are only seven ordered meals, they don't need especific translation
  String mealName(AppLocalizations t) {
    return switch (this) {
      breakfast => t.breakfast,
      brunch => t.brunch,
      lunch => t.lunch,
      tea => t.tea,
      highTea => t.highTea,
      dinner => t.dinner,
      supper => t.supper,
    };
  }
}
