// Localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project
import 'meal.dart';

//=======================================================================

// 1) Note longAfter a meal is the same as longBefore the next meal
// System will always represent it as longBefore, with
// longAfter reserved only for "long after supper" (midnight)
// 2) Alarm time for "before" a meal and "at" meal will be the same,
// but they are not exactly the same regard to pills
// alarm time for "after" a meal will be 30 minutes after the meal time
// 3) longBefore / longAfter alarms both shoud be
// 1h30' before AND after any meals. Note default times, using all the meals
// like a hobbit, only left enough time between meals for
// "long before breakfast", "long before brunch" and "long after supper"
// Usually english have brunch or lunch, tea or high te, and dinner or supper,
// but sometimes the duality stands because one of them is limited to
// have a little bite
enum PillMealTime {
  longBefore(-5),
  before(-2),
  at(0),
  after(2),
  longAfter(5);

  //-----------------class state members and constructors ----------------------

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

  bool operator <(covariant PillMealTime other) {
    return id < other.id;
  }

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

  String pillTimeName(Meal meal, AppLocalizations t) {
    switch (meal) {
      case Meal.breakfast:
        {
          return switch (this) {
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
          return switch (this) {
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
          return switch (this) {
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
          return switch (this) {
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
          return switch (this) {
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
          return switch (this) {
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
          return switch (this) {
            longBefore => t.pillsLongBeforeSupper,
            before => t.pillsBeforeSupper,
            at => t.pillsAtSupper,
            after => t.pillsAfterSupper,
            longAfter => t.pillsLongAfterSupper,
          };
        }
    }
  }
}
