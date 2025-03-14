// SIMPLE ENUMS. No imports (except for localization)
// Flutter
import 'package:flutter/material.dart'; // default TimeOfDay
// Localizations
import '../../l10n/app_localizations.dart';
// Project files
import 'speed_label.dart'; // default Speed for a meal

//=======================================================================

/// Meals of the day; beleave that 8 are enough
/// NOTE: it is used 'high tea' to make a difference from 'afternoon tea' (tea)
/// 'tea' is the notation for 'afternoon tea', but the visual text
/// stands as 'afternoon tea', while 'high tea' is shown as 'tea'
/// NOTE: 'afternoon tea' is translated into other languages as 
/// the 'coffee after the lunch' as it was the best fit into the list of meals,
/// and then, the light meal in the afternoon is binded to 'highTea',
/// although it is not adjusted to a correct translation
enum Meal {
  /// breakfast
  breakfast(10),

  /// tea break
  elevenses(20),

  /// brunch
  brunch(30),

  /// lunch
  lunch(40),

  /// afternoon tea
  tea(50),

  /// highTea is used here as an early evening tea
  highTea(60),

  /// evening meal
  dinner(70),

  /// supper is used here as later than dinner
  supper(80);

  //----------------------------------------------------------------------------
  //-------------------------static---------------------------------------------

  //--------------------------defaults------------------------------------------

  /// default meal times.
  /// Arbitrary set, programmer can change them without affectations
  static TimeOfDay defaultMealTime(Meal meal) {
    return switch (meal) {
      Meal.breakfast => const TimeOfDay(hour: 7, minute: 0),
      Meal.elevenses => const TimeOfDay(hour: 11, minute: 0),
      Meal.brunch => const TimeOfDay(hour: 12, minute: 0),
      Meal.lunch => const TimeOfDay(hour: 13, minute: 0),
      Meal.tea => const TimeOfDay(hour: 15, minute: 30),
      Meal.highTea => const TimeOfDay(hour: 18, minute: 0),
      Meal.dinner => const TimeOfDay(hour: 20, minute: 0),
      Meal.supper => const TimeOfDay(hour: 21, minute: 30),
    };
  }

  /// default meal speed
  static const SpeedLabel defaultMealSpeed = SpeedLabel.medium;

  /// default duration of meals
  /// used as both minimal (SpeedLabel.fast) and maximal (SpeedLabel.slow)
  static Duration defaultMealDuration(Meal meal) {
    return switch (meal) {
      Meal.breakfast => const Duration(minutes: 35),
      Meal.elevenses => const Duration(minutes: 15),
      Meal.brunch => const Duration(minutes: 45),
      Meal.lunch => const Duration(minutes: 50),
      Meal.tea => const Duration(minutes: 30),
      Meal.highTea => const Duration(minutes: 30),
      Meal.dinner => const Duration(minutes: 45),
      Meal.supper => const Duration(minutes: 35),
    };
  }

  //--------------------------------i18n----------------------------------------

  // Remember localization must be initialized:
  //    await initializeDateFormatting("ca", null)
  // You can get the current locale from widget
  // locale = WidgetsBinding.instance!.window.locale
  /// Localized name
  /// they are only seven ordered meals, they don't need specific translation
  static String mealName(AppLocalizations locale, Meal value) {
    return switch (value) {
      breakfast => locale.breakfast,
      elevenses => locale.elevenses,
      brunch => locale.brunch,
      lunch => locale.lunch,
      tea => locale.tea,
      highTea => locale.highTea,
      dinner => locale.dinner,
      supper => locale.supper,
    };
  }

  //----------------------------------------------------------------------------
  //-----------------enum state members and constructors ----------------------

  /// Identifier is defined from 10 to 70, leaving room for
  /// the increment or decrement of the forms ‘before’ and ‘after’.
  /// Also note that id=0 is used for testing purposes
  final int id;

  const Meal(this.id);

  factory Meal.fromId(int id) {
    return switch (id) {
      10 => Meal.breakfast,
      20 => Meal.elevenses,
      30 => Meal.brunch,
      40 => Meal.lunch,
      50 => Meal.tea,
      60 => Meal.highTea,
      70 => Meal.dinner,
      80 => Meal.supper,
      _ when id % 10 == 0 => throw RangeError.range(id, 10, 80),
      _ =>
        throw ArgumentError.value(id, "id", "MealTime.id are multiples of 10"),
    };
  }

  /// Define ordinal; ordering
  factory Meal.fromOrdinal(int id) {
    return Meal.fromId(id * 10);
  }

  //----------------------------------------------------------------------------
  //-----------------------enum special members--------------------------------

  /// Definition of natural time ordering, using the id
  bool operator <(covariant Meal other) {
    return id < other.id;
  }

  /// Next meal, not circular (supper is the last one, returning null)
  Meal? next() {
    return switch (this) {
      breakfast => elevenses,
      elevenses => brunch,
      brunch => lunch,
      lunch => tea,
      tea => highTea,
      highTea => dinner,
      dinner => supper,
      supper => null,
    };
  }

  /// Next meal, not circular (breakfast is the first one, returning null)
  Meal? previous() {
    return switch (this) {
      breakfast => null,
      elevenses => breakfast,
      brunch => elevenses,
      lunch => brunch,
      tea => lunch,
      highTea => tea,
      dinner => highTea,
      supper => dinner,
    };
  }

  //----------------------------------------------------------------------------
  //-----------------------enum rest of members--------------------------------

  /// Define ordinal; ordering
  int get ordinal => id ~/ 10;

  //--------------------------------i18n----------------------------------------

  /// Localized name
  /// they are only seven ordered meals, they don't need specific translation
  String localeName(AppLocalizations locale) => mealName(locale, this);

  //-------- end enum ----------------------------------------------------------
}
