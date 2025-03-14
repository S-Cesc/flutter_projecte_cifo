// Localizations
import '../l10n/app_localizations.dart';
// Project files
import 'enum/meal.dart';
import 'enum/pill_meal_time.dart';

// TODO: The "long-after" is rewritten a "long before"
// but it can't be done when the next Meal is not active

//==============================================================================

/// A pair of [Meal] and [PillMealTime] defines [Alarm] identity
/// The [Meal.id] and [PillMealTime.id] are defined to allow a unique id
/// for each pair, so that [MealPillmealtimePair] is implemented
/// using a single integer.
class MealPillmealtimePair implements Comparable<MealPillmealtimePair> {
  //
  //----------------------------------------------------------------------------
  //-------------------------static/constant------------------------------------
  static const _midnightId = 75;

  /// Get the Meal component from the id
  static Meal mealComponent(int id) {
    return id == _midnightId
        ? Meal.supper
        : Meal.fromId(id - _pmtIdComponent(id));
  }

  /// Get the PillMealTime component from the id
  static PillMealTime pillMealTimeComponent(int id) {
    return id == _midnightId
        ? PillMealTime.longAfter
        : PillMealTime.fromId(_pmtIdComponent(id));
  }

  /// Get the key pair ([meal], [pillMealTime]) from the id
  static (Meal, PillMealTime) getComponents(int id) {
    if (id == _midnightId) {
      return (Meal.supper, PillMealTime.longAfter);
    } else {
      int pmt = _pmtIdComponent(id);
      return (Meal.fromId(id - pmt), PillMealTime.fromId(pmt));
    }
  }

  /// Get the id from the key pair ([meal], [pillMealTime])
  static int getIdFromPair(Meal meal, PillMealTime pillMealTime) {
    return meal.id + pillMealTime.id;
  }

  // Remember localization must be initialized:
  //    await initializeDateFormatting("ca", null)
  // You can get the current locale from widget
  // locale = WidgetsBinding.instance!.window.locale
  /// Get the localized name for the pair ([meal], [pillMealTime])
  static String getPairNameFromId(AppLocalizations t, int id) {
    final (meal, pillMealTime) = getComponents(id);
    return PillMealTime.getPillTimeName(t, meal, pillMealTime);
  }

  /// Get the name for the pair ([meal], [pillMealTime])
  static String getPairName(
    AppLocalizations t,
    Meal meal,
    PillMealTime pillMealTime,
  ) {
    return PillMealTime.getPillTimeName(t, meal, pillMealTime);
  }

  static int _pmtIdComponent(int id) {
    return (id % 2) == 0
        ? ((id % 10) == 0 ? 0 : (((id - 2) % 10) == 0 ? 2 : -2))
        : -5;
  }

  //----------------------------------------------------------------------------
  //-----------------class state members and constructors ----------------------

  /// Integer Id
  final int id;

  /// Ctor
  const MealPillmealtimePair(this.id);

  /// Ctor from Id
  MealPillmealtimePair.fromComponents(Meal meal, PillMealTime pillMealTime)
    : this(getIdFromPair(meal, pillMealTime));

  /// Meal (pseudo-component)
  Meal get meal => mealComponent(id);

  /// PillMealTime (pseudo-component)
  PillMealTime get pillMealTime => pillMealTimeComponent(id);

  //----------------------------------------------------------------------------
  //-----------------------class special members--------------------------------

  @override
  bool operator ==(Object other) {
    if (other is MealPillmealtimePair) {
      return id == other.id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(MealPillmealtimePair other) {
    return id.compareTo(other.id);
  }

  /// Localized and contextualized name
  String pillTimeName(AppLocalizations t) {
    return PillMealTime.getPillTimeName(t, meal, pillMealTime);
  }

}
