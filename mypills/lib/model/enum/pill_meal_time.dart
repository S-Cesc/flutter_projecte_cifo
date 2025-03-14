// SIMPLE ENUMS. No imports (except for localization)
// This one is simple enough, but depends on Meal
// Localizations
import '../../l10n/app_localizations.dart';
// Project
import 'meal.dart'; //PillMealTime is a dependent enum defined from Meal

//=======================================================================

/// Represents before/after option for taking the pills
/// There is also a long before option when pills can't be taken at meal time
/// There is also a long after, it is used only for long after supper,
/// representing night pills
///
/// 1) Note longAfter a meal is the same as longBefore the next meal
/// System will always represent it as longBefore, with
/// longAfter reserved only for "long after supper" (midnight)
///
/// 2) Alarm time for "before" a meal and "at" meal would be the same,
/// but they are not exactly the same regard to pills,
/// so they stand as different, with some minutes "before" the meal.
///
/// 3) longBefore / longAfter alarms both shoud be at least
/// 1h30' before AND after any meals. Note default times, using all the meals
/// like a hobbit, only left enough time between meals for
/// "long before breakfast", "long before brunch" and "long after supper"
///
/// Usually english have brunch or lunch, tea or high te, and dinner or supper,
/// but sometimes the duality stands because one of them is limited to
/// have a little bite, or diferences on holidays or special days
///
enum PillMealTime {
  /// Long before the meal
  longBefore(-5),

  /// Before the meal
  before(-2),

  /// At the meal
  at(0),

  /// after the meal
  after(2),

  /// long after the meal (only stands for long after the supper)
  longAfter(5);

  //----------------------------------------------------------------------------
  //-------------------------static---------------------------------------------

  //--------------------------------i18n----------------------------------------

  /// Localized name of the items, to choice between them
  static String getSinglePillTimeName(
    AppLocalizations locale,
    PillMealTime value,
  ) {
    return switch (value) {
      longBefore => locale.longBefore,
      before => locale.before,
      at => locale.at,
      after => locale.after,
      longAfter => locale.longAfter,
    };
  }

  /// static function to get localized [PillMealTime] name;
  /// to get a localized PillMealTime name the Meal is also needed
  static String getPillTimeName(
    AppLocalizations locale,
    Meal meal,
    PillMealTime pillMealTime,
  ) {
    switch (meal) {
      case Meal.breakfast:
        {
          return switch (pillMealTime) {
            longBefore => locale.pillsLongBeforeBreakfast,
            before => locale.pillsBeforeBreakfast,
            at => locale.pillsAtBreakfast,
            after => locale.pillsAfterBreakfast,
            longAfter =>
              throw RangeError("'long after' only allowed at supper"),
          };
        }
      case Meal.elevenses:
        {
          return switch (pillMealTime) {
            longBefore => locale.pillsLongBeforeElevenses,
            before => locale.pillsBeforeElevenses,
            at => locale.pillsAtElevenses,
            after => locale.pillsAfterElevenses,
            longAfter =>
              throw RangeError("'long after' only allowed at supper"),
          };
        }
      case Meal.brunch:
        {
          return switch (pillMealTime) {
            longBefore => locale.pillsLongBeforeBrunch,
            before => locale.pillsBeforeBrunch,
            at => locale.pillsAtBrunch,
            after => locale.pillsAfterBrunch,
            longAfter =>
              throw RangeError("'long after' only allowed at supper"),
          };
        }
      case Meal.lunch:
        {
          return switch (pillMealTime) {
            longBefore => locale.pillsLongBeforeLunch,
            before => locale.pillsBeforeLunch,
            at => locale.pillsAtLunch,
            after => locale.pillsAfterLunch,
            longAfter =>
              throw RangeError("'long after' only allowed at supper"),
          };
        }
      case Meal.tea:
        {
          return switch (pillMealTime) {
            longBefore => locale.pillsLongBeforeTea,
            before => locale.pillsBeforeTea,
            at => locale.pillsAtTea,
            after => locale.pillsAfterTea,
            longAfter =>
              throw RangeError("'long after' only allowed at supper"),
          };
        }
      case Meal.highTea:
        {
          return switch (pillMealTime) {
            longBefore => locale.pillsLongBeforeHighTea,
            before => locale.pillsBeforeHighTea,
            at => locale.pillsAtHighTea,
            after => locale.pillsAfterHighTea,
            longAfter =>
              throw RangeError("'long after' only allowed at supper"),
          };
        }
      case Meal.dinner:
        {
          return switch (pillMealTime) {
            longBefore => locale.pillsLongBeforeDinner,
            before => locale.pillsBeforeDinner,
            at => locale.pillsAtDinner,
            after => locale.pillsAfterDinner,
            longAfter =>
              throw RangeError("'long after' only allowed at supper"),
          };
        }
      case Meal.supper:
        {
          return switch (pillMealTime) {
            longBefore => locale.pillsLongBeforeSupper,
            before => locale.pillsBeforeSupper,
            at => locale.pillsAtSupper,
            after => locale.pillsAfterSupper,
            longAfter => locale.pillsLongAfterSupper,
          };
        }
    }
  }

  //----------------------------------------------------------------------------
  //-----------------enum state members and constructors -----------------------

  /// Identifier setting an order
  /// The sum with the meal Id also sets a total order for the pair
  /// Meal+PillMealTime
  final int id;

  const PillMealTime(this.id);

  factory PillMealTime.fromId(int id) {
    return switch (id) {
      -5 => PillMealTime.longBefore,
      -2 => PillMealTime.before,
      0 => PillMealTime.at,
      2 => PillMealTime.after,
      5 => PillMealTime.longAfter,
      _ => throw RangeError.range(id, -5, 5),
    };
  }

  //----------------------------------------------------------------------------
  //-----------------------enum special members---------------------------------

  /// It implements the defined total order
  bool operator <(covariant PillMealTime other) {
    return id < other.id;
  }

  /// No circular next function; [longAfter].next() returns null
  PillMealTime? next() {
    return switch (this) {
      longBefore => before,
      before => at,
      at => after,
      after => longAfter,
      longAfter => null,
    };
  }

  //----------------------------------------------------------------------------
  //-----------------------enum rest of members--------------------------------

  //--------------------------------i18n----------------------------------------

  /// Localized name of the items, to choice between them
  String localeName(AppLocalizations locale) =>
      getSinglePillTimeName(locale, this);

  /// Full localized name, which needs the meal
  String pillTimeName(AppLocalizations locale, Meal meal) =>
      getPillTimeName(locale, meal, this);

  //-------- end enum ----------------------------------------------------------
}
