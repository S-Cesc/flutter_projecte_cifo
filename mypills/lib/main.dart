// logging and debugging
import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:logging/logging.dart' show Level;

// Dart base
import 'dart:isolate';
import 'dart:async' show StreamSubscription;
import 'dart:ui' show IsolateNameServer;

// Flutter
import 'package:flutter/material.dart';

// Project files
import './styles/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/splash_config_screen.dart';
import 'screens/splash_alarm_screen.dart';

/// The name associated with the UI isolate's [SendPort].
const String mainIsolateName = 'myPillsConfig';
const String alarmPortName = "$mainIsolateName/isolateComPort";
final int isolateId = Isolate.current.hashCode;

/// A port used to communicate from a background isolate to the UI isolate.
ReceivePort port = ReceivePort();
// the stream listened on RecivePort
StreamSubscription<dynamic>? subscription;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

void initializePort() {
  bool initialized = IsolateNameServer.registerPortWithName(
    port.sendPort,
    alarmPortName,
  );
  developer.log(
      'Alarm send port ${initialized ? "" : "NOT "}registered.'
      '${initialized ? " Possibly it already were" : ""}',
      level: Level.FINE.value);
}

Future<StreamSubscription<dynamic>> listenAlarmPort(
    BuildContext context) async {
  subscription = port.listen(
    (d) async {
      if (d is String && d == "wakeup") {
        developer.log('Wakeup message arrived foreground',
            level: Level.INFO.value);
        while (context.mounted && Navigator.canPop(context)) {
          await SystemNavigator.pop();
        }
        if (context.mounted) {
          developer.log(
              '${Navigator.canPop(context) ? "More" : "No"} foreground routes need pop',
              level: Level.FINEST.value);
          Navigator.of(context).popUntil((route) => route.isFirst);
          developer.log('Foreground routes popped', level: Level.FINEST.value);
          Navigator.pushReplacementNamed(context, "/alarm");
//              result: MaterialPageRoute<SplashAlarmScreen>(
//                  builder: (context) => const SplashAlarmScreen()));
        } else {
          developer.log('Context is not mounted', level: Level.SEVERE.value);
        }
      }
    },
  );
  return subscription!;
}

void dispose() {
  subscription?.cancel();
  IsolateNameServer.removePortNameMapping(alarmPortName);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: AppStyles.fonts.fontFamilyName,
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: AppStyles.colors.mantis),
            color: AppStyles.colors.ochre,
          )),
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
