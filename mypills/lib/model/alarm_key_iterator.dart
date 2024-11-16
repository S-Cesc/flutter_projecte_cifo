// projecte
import 'meal.dart';
import 'pill_meal_time.dart';

//==============================================================================

class AlarmKeyIterator implements Iterator<(Meal, PillMealTime)> {
  //-------------------------static/constant------------------------------------

  static bool hasNext(Meal mealTime, PillMealTime pillMealTime) =>
      mealTime != Meal.supper || pillMealTime != PillMealTime.longAfter;

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
