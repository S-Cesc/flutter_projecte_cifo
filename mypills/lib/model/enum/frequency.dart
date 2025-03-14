// SIMPLE ENUMS. No imports (except for localization)
// Flutter
// Localizations
import '../../l10n/app_localizations.dart';

//=======================================================================

/// Frequency of prescription. Often needs some more information
/// The end date (expiration date) will be needed for each case
/// as well as to bind them with a time of day (the pair [Meal], [PillMealTime])
enum Frequency {
  /// Once: It won't need any more information
  /// - Expìration date will be the same as the only date
  once,

  /// Dayly, every 24 hours
  onceADay,

  /// Dayly, every 12 hours
  twiceADay,

  /// Dayly, every 8 hours
  threeTimesADay,

  /// Dayly, every 6 hours
  fourTimesADay,

  /// Weekly will also need to know a list of days of week
  /// (implicit, how many times a week)
  weekly,

  /// Every four weeks will need also to know which day of week
  /// and boolean to know if it applies for even/odd weeks of year
  everyTwoWeeks,

  /// fortnightly will need also to know which two days of month
  fortnightly,

  /// Every four weeks will need also to know which day of week
  /// and a number: which number of week (of year) modulo four it applies
  everyFourWeeks,

  /// monthly will need also to know which day of month
  monthly;

  //----------------------------------------------------------------------------
  //-------------------------static---------------------------------------------

  /// Nom dels valors
  static String frequencyName(AppLocalizations locale, Frequency value) {
    switch (value) {
      case Frequency.once:
        return locale.once;
      case Frequency.onceADay:
        return locale.onceADay;
      case Frequency.twiceADay:
        return locale.twiceADay;
      case Frequency.threeTimesADay:
        return locale.threeTimesADay;
      case Frequency.fourTimesADay:
        return locale.fourTimesADay;
      case Frequency.weekly:
        return locale.weekly;
      case Frequency.everyTwoWeeks:
        return locale.everyTwoWeeks;
      case Frequency.fortnightly:
        return locale.fortnightly;
      case Frequency.everyFourWeeks:
        return locale.everyFourWeeks;
      case Frequency.monthly:
        return locale.monthly;
    }
  }

  /// Nom dels valors
  static String frequencyTooltip(AppLocalizations locale, Frequency value) {
    switch (value) {
      case Frequency.once:
        return locale.once_tooltip;
      case Frequency.onceADay:
        return locale.onceADay_tooltip;
      case Frequency.twiceADay:
        return locale.twiceADay_tooltip;
      case Frequency.threeTimesADay:
        return locale.threeTimesADay_tooltip;
      case Frequency.fourTimesADay:
        return locale.fourTimesADay_tooltip;
      case Frequency.weekly:
        return locale.weekly_tooltip;
      case Frequency.everyTwoWeeks:
        return locale.everyTwoWeeks_tooltip;
      case Frequency.fortnightly:
        return locale.fortnightly_tooltip;
      case Frequency.everyFourWeeks:
        return locale.everyFourWeeks_tooltip;
      case Frequency.monthly:
        return locale.monthly_tooltip;
    }
  }

  //--------------------------------i18n----------------------------------------

  //----------------------------------------------------------------------------
  //-----------------------enum rest of members--------------------------------

  //--------------------------------i18n----------------------------------------

  /*
  /// Localized name
  /// they are only seven ordered meals, they don't need specific translation
  String localeName(AppLocalizations locale) => frequencyName(locale, this);
*/

  //-------- end enum ----------------------------------------------------------
}
