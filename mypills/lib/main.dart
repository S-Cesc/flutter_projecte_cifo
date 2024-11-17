// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;

// Dart base
import 'dart:isolate';
import 'dart:async' show unawaited, StreamSubscription;
import 'dart:ui' show IsolateNameServer;

// Flutter
import 'package:flutter/material.dart';

// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project files
import './styles/app_styles.dart';
import 'package:provider/provider.dart';
import 'screens/splash_config_screen.dart';
import 'screens/splash_alarm_screen.dart';

//=======================================================================

/// The name associated with the UI isolate's [SendPort].
const String mainIsolateName = 'myPillsConfig';
const String alarmPortName = "$mainIsolateName/isolateComPort";
const alarmScreenPath = '/alarm';
const configScreenPath = '/config';

final int isolateId = Isolate.current.hashCode;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// A port used to communicate from a background isolate to the UI isolate.
ReceivePort? port; // warning! there is a late intialization
// the stream listened on RecivePort
StreamSubscription<dynamic>? subscription;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: AppStyles.fonts.fontFamilyName,
          useMaterial3: true,
          scaffoldBackgroundColor: AppStyles.colors.mantis,
          dialogBackgroundColor: AppStyles.colors.ochre,
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
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.appTitle;
      },
    );
  }
}

Future<void> initializePort() async {
  Future<StreamSubscription<dynamic>> listenAlarmPort() async {
    subscription = port!.listen(
      (d) async {
        if (d is String && d == "wakeup") {
          developer.log('Wakeup message arrived foreground',
              level: Level.INFO.value);
          final navigator = navigatorKey.currentState;
          if (navigator != null) {
            bool currentRouteIsNewRoute = false;
            navigator.popUntil((currentRoute) {
              // This is just a way to access currentRoute; the top route in the
              // Navigator stack.
              if (currentRoute.settings.name == alarmScreenPath) {
                currentRouteIsNewRoute = true;
              }
              // Return true so popUntil() pops nothing.
              return true;
            });
            if (currentRouteIsNewRoute) {
              developer.log('Alarm screen is already on top of stack',
                  level: Level.FINEST.value);
            } else {
              while (navigator.canPop()) {
                navigator.pop();
              }
              developer.log(
                  "Foreground routes popped: now let's replace screen",
                  level: Level.FINEST.value);
              await navigator.pushReplacementNamed(alarmScreenPath);
            }
          } else {
            developer.log('NAVIGATOR is null', level: Level.SEVERE.value);
          }
        }
      },
    );
    return subscription!;
  }

  //final dTime = DateTime.now();
  var newPort = ReceivePort();
  IsolateNameServer.removePortNameMapping(alarmPortName);
  if (IsolateNameServer.registerPortWithName(newPort.sendPort, alarmPortName)) {
    await subscription?.cancel();
    port?.close();
    port = newPort;
    subscription = null;
    developer.log('Alarm send port registered', level: Level.FINE.value);
  } else {
    developer.log('Problems to register Alarm send port',
        level: Level.FINE.value);
  }
  if (port == null) {
    developer.log('Alarm send port NOT registered', level: Level.CONFIG.value);
    throw TypeError();
  } else {
    await listenAlarmPort();
  }
}

@override
void dispose() {
  developer.log('DISPOSE', level: Level.CONFIG.value);
  subscription?.cancel();
  IsolateNameServer.removePortNameMapping(alarmPortName);
}
