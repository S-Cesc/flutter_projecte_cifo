// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;

// Dart base
import 'dart:isolate';
import 'dart:async' show StreamSubscription;
import 'dart:ui' show IsolateNameServer;

// Flutter
import 'package:flutter/material.dart';

// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project files
import './styles/app_styles.dart';
import 'package:provider/provider.dart';
import 'providers/config_preferences.dart';
import 'screens/splash_config_screen.dart';
import 'screens/splash_alarm_screen.dart';

//=======================================================================

/// The name associated with the UI isolate's [SendPort].
const String mainIsolateName = 'myPills';

/// listen to "wakeup" message
const String uiWakeupPortName = "$mainIsolateName/isolateComPort";

/// listen to background status changes
const String uiAlarmPortName = "$mainIsolateName/alarmComPort";

/// the Alarm Screen path
const alarmScreenPath = '/alarm';

/// Settings Screen (default) path
const configScreenPath = '/config';

/// Main isolate id
final int isolateId = Isolate.current.hashCode;

/// Navigator GlobalKey (used on wakeup)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// A port used to communicate from a background isolate to the UI isolate.
ReceivePort? wakeupPort; // warning! there is a late intialization

/// the stream listened on the [wakeupPort] [ReceivePort]
/// with name [uiWakeupPortName]
StreamSubscription<dynamic>? subscription;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

/// Class for the application (MyPills)
class MainApp extends StatefulWidget {
  /// const ctor
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ConfigPreferences(),
        child: MaterialApp(
          theme: ThemeData(
              fontFamily: AppStyles.fonts.fontFamilyName,
              useMaterial3: true,
              scaffoldBackgroundColor: AppStyles.colors.mantis,
              dialogBackgroundColor: AppStyles.colors.ochre[700],
              dialogTheme: DialogTheme(
                iconColor: AppStyles.colors.mantis,
                surfaceTintColor: AppStyles.colors.darkSpringGreen[200],
                elevation: 4,
              ),
              appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(color: AppStyles.colors.mantis),
                color: AppStyles.colors.ochre,
              )),
          routes: {
            configScreenPath: (context) => const SplashConfigScreen(),
            alarmScreenPath: (context) => const SplashAlarmScreen(),
          },
          navigatorKey: navigatorKey,
          initialRoute: configScreenPath,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          localeListResolutionCallback: (locales, supportedLocales) {
            if (locales != null) {
              for (final locale in locales) {
                for (final supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }
              }
              // Per si un despistat té definit el basc però no el castellà
              for (final locale in locales) {
                if (locale.countryCode == 'ES') {
                  return supportedLocales
                      .firstWhere((l) => l.languageCode == 'es');
                }
              }
            }
            return supportedLocales.first; // per defecte, anglès
          },
          onGenerateTitle: (context) {
            return AppLocalizations.of(context)!.appTitle;
          },
          //showPerformanceOverlay: true,
        ));
  }
}

/// Dispose main
@override
void dispose() {
  developer.log('DISPOSE', level: Level.CONFIG.value);
  subscription?.cancel();
  IsolateNameServer.removePortNameMapping(uiWakeupPortName);
}
