/*
// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
*/

// Dart base
import 'dart:isolate';
import 'dart:ui' show IsolateNameServer;

// Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

// Project files
import '../l10n/fallback_localization_delegate.dart';
import 'providers/preferences.dart';
import 'screens/splash_config_screen.dart';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'myPillsConfig';

/// A port used to communicate from a background isolate to the UI isolate.
ReceivePort port = ReceivePort();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

void initializePort() {
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Preferences(),
      child: MaterialApp(
        /*
        theme: ThemeData(
            fontFamily: GoogleFonts.montserrat().fontFamily,
            scaffoldBackgroundColor: AppStyles.babyPowder),
        */
        home: const SplashConfigScreen(),
        supportedLocales: const [Locale('es'), Locale('ca'), Locale('en')],
        localizationsDelegates: [
          AppLocalizations.delegate,
          FallbackLocalizationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        onGenerateTitle: (context) {
          return AppLocalizations.of(context)!.appTitle;
        },
      ),
    );
  }
}
