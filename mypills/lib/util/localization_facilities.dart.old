import 'dart:ui';
// Localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizationFacilities {

  // When context available use AppLocalizations.of(context), but the Material
  // app has to actually be started to initialize AppLocalizations.
  // Anywhere, you cannot access current App Locale during initState
  // (more concrete: before it completed).
  // Also you can get the current locale from widget
  // locale = WidgetsBinding.instance!.window.locale

  Future<AppLocalizations> localizations(Locale locale) async {
    return await AppLocalizations.delegate.load(locale);
  }

}
