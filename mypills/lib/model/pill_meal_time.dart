// Localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project
import 'meal.dart';

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

  /// static function to get localized [PillMealTime] name
  /// To get a localized PillMealTime name the Meal is also needed
  static String getPillTimeName(
      Meal meal, PillMealTime pillMealTime, AppLocalizations t) {
    switch (meal) {
      case Meal.breakfast:
        {
          return switch (pillMealTime) {
            longBefore => t.pillsLongBeforeBreakfast,
            before => t.pillsBeforeBreakfast,
            at => t.pillsAtBreakfast,
            after => t.pillsAfterBreakfast,
            longAfter =>
              throw RangeError("'long after' only allowed at supper"),
          };
        }
      case Meal.brunch:
        {
          return switch (pillMealTime) {
            longBefore => t.pillsLongBeforeBrunch,
            before => t.pillsBeforeBrunch,
            at => t.pillsAtBrunch,
            after => t.pillsAfterBrunch,
            longAfter =>
              throw RangeError("'long after' only allowed at supper"),
          };
        }
      case Meal.lunch:
        {
          return switch (pillMealTime) {
            longBefore => t.pillsLongBeforeLunch,
            before => t.pillsBeforeLunch,
            at => t.pillsAtLunch,
            after => t.pillsAfterLunch,
            longAfter =>
              throw RangeError("'long after' only allowed at supper"),
          };
        }
      case Meal.tea:
        {
          return switch (pillMealTime) {
            longBefore => t.pillsLongBeforeTea,
            before => t.pillsBeforeTea,
            at => t.pillsAtTea,
            after => t.pillsAfterTea,
            longAfter =>
              throw RangeError("'long after' only allowed at supper"),
          };
        }
      case Meal.highTea:
        {
          return switch (pillMealTime) {
            longBefore => t.pillsLongBeforeHighTea,
            before => t.pillsBeforeHighTea,
            at => t.pillsAtHighTea,
            after => t.pillsAfterHighTea,
            longAfter =>
              throw RangeError("'long after' only allowed at supper"),
          };
        }
      case Meal.dinner:
        {
          return switch (pillMealTime) {
            longBefore => t.pillsLongBeforeDinner,
            before => t.pillsBeforeDinner,
            at => t.pillsAtDinner,
            after => t.pillsAfterDinner,
            longAfter =>
              throw RangeError("'long after' only allowed at supper"),
          };
        }
      case Meal.supper:
        {
          return switch (pillMealTime) {
            longBefore => t.pillsLongBeforeSupper,
            before => t.pillsBeforeSupper,
            at => t.pillsAtSupper,
            after => t.pillsAfterSupper,
            longAfter => t.pillsLongAfterSupper,
          };
        }
    }
  }

  //-----------------class state members and constructors ----------------------

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

  //-----------------------class special members--------------------------------

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
      longAfter => null
    };
  }

  //-----------------------class rest of members--------------------------------

  //--------------------------------i18n----------------------------------------

  /// Localized name of the items, to choice between them
  String simpleName(AppLocalizations t) {
    return switch (this) {
      longBefore => t.longBefore,
      before => t.before,
      at => t.at,
      after => t.after,
      longAfter => t.longAfter,
    };
  }

  /// Full localized name, which needs the meal
  String pillTimeName(Meal meal, AppLocalizations t) {
    return getPillTimeName(meal, this, t);
  }
}
