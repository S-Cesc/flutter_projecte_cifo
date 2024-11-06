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

// Project files
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'screens/splash_config_screen.dart';
import 'screens/splash_alarm_screen.dart';

/// The name associated with the UI isolate's [SendPort].
const String mainIsolateName = 'myPillsConfig';
const String alarmPortName = "$mainIsolateName/isolateComPort";
final int isolateId = Isolate.current.hashCode;

/// A port used to communicate from a background isolate to the UI isolate.
ReceivePort port = ReceivePort();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

void initializePort() {
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    alarmPortName,
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*
        theme: ThemeData(
            fontFamily: GoogleFonts.montserrat().fontFamily,
            scaffoldBackgroundColor: AppStyles.babyPowder),
        */
      routes: {
        '/config': (context) => const SplashConfigScreen(),
        '/alarm': (context) => const SplashAlarmScreen(),
      },
      initialRoute: '/config',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.appTitle;
      },
    );
  }
}
