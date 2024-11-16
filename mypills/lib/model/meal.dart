// Flutter
import 'package:flutter/material.dart';
// Localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//=======================================================================

enum Meal {
  breakfast(10),
  brunch(20),
  lunch(30),
  tea(40),
  highTea(50),
  dinner(60),
  supper(70);


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

  //-----------------class state members and constructors ----------------------

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

  //-----------------------class special members--------------------------------

  bool operator <(covariant Meal other) {
    return id < other.id;
  }

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

  //--------------------------------i18n----------------------------------------

  // Remember localization must be initialized:
  //    await initializeDateFormatting("ca", null)
  // You can get the current locale from widget
  // locale = WidgetsBinding.instance!.window.locale
  Future<String> mealName(Locale locale) async {
    AppLocalizations t = await AppLocalizations.delegate.load(locale);
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