// SIMPLE ENUMS. No imports (except for localization)
import '../../l10n/app_localizations.dart';

//==============================================================================

/// Names to label how fast you are eating
enum SpeedLabel {
  /// slow food
  slow,

  /// eating at normal speed
  medium,

  /// fast food
  fast;

  //----------------------------------------------------------------------------
  //-------------------------static---------------------------------------------

  //--------------------------------i18n----------------------------------------

  // Remember localization must be initialized:
  //    await initializeDateFormatting("ca", null)
  // You can get the current locale from widget
  // locale = WidgetsBinding.instance!.window.locale
  /// Localized name for an enum value
  static String speedName(AppLocalizations locale, SpeedLabel value) {
    return switch (value) {
      SpeedLabel.slow => locale.slowLabel,
      SpeedLabel.medium => locale.mediumLabel,
      SpeedLabel.fast => locale.fastLabel,
    };
  }

  //----------------------------------------------------------------------------
  //-----------------------enum rest of members--------------------------------

  //--------------------------------i18n----------------------------------------

  /// Get the localized name
  String localeName(AppLocalizations locale) => speedName(locale, this);

  //-------- end enum ----------------------------------------------------------
}
