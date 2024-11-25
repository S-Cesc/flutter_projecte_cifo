// projecte
import 'meal.dart';
import 'pill_meal_time.dart';

//==============================================================================

/// Iterate through the pair (Meal, PillMealTime)
class AlarmKeyIterator implements Iterator<(Meal, PillMealTime)> {
  //-------------------------static/constant------------------------------------

  /// Some additional static facilities provided by the class
  /// - Whether the pair (Meal, PillMealTime) has a next value
  /// or it is the last one
  static bool hasNext(Meal mealTime, PillMealTime pillMealTime) =>
      mealTime != Meal.supper || pillMealTime != PillMealTime.longAfter;

  /// Some additional static facilities provided by the class:
  /// - compute the next of a (Meal, PillMealTime) pair value
  static (Meal, PillMealTime) next(Meal mealTime, PillMealTime pillMealTime) {
    if (pillMealTime < PillMealTime.after) {
      return (mealTime, pillMealTime.next()!);
    } else if (mealTime < Meal.supper) {
      return (mealTime.next()!, PillMealTime.longBefore);
    } else {
      return (Meal.supper, PillMealTime.longAfter);
    }
  }

  //-----------------class state members and constructors ----------------------

  bool beforeBegin = true;
  Meal _mealTime;
  PillMealTime _pillMealTime;

  AlarmKeyIterator()
      : _mealTime = Meal.breakfast,
        _pillMealTime = PillMealTime.longBefore;

  //-----------------------class special members--------------------------------

  @override
  (Meal, PillMealTime) get current => (_mealTime, _pillMealTime);

  @override
  bool moveNext() {
    if (beforeBegin) {
      beforeBegin = false;
    } else if (_pillMealTime < PillMealTime.after) {
      _pillMealTime = _pillMealTime.next()!;
    } else if (_mealTime < Meal.supper) {
      _pillMealTime = PillMealTime.longBefore;
      _mealTime = _mealTime.next()!;
    } else if (_mealTime == Meal.supper &&
        _pillMealTime == PillMealTime.after) {
      _pillMealTime = PillMealTime.longAfter;
    } else {
      return false;
    }
    return true;
  }
}
