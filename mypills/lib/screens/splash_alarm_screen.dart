// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:async' show unawaited;
import 'dart:io' show exit;
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:mypills/model/global_constants.dart';
import '../l10n/app_localizations.dart';
// Project files
import '../main.dart' show alarmScreenPath;
import '../styles/app_styles.dart';
import '../providers/background_preferences.dart';
import './main_alarm_screen.dart';

//=======================================================================

/// Splash screen for [main_alarm_screen] data initialitzation
class SplashAlarmScreen extends StatefulWidget {
  /// const [SplashAlarmScreen] ctor
  const SplashAlarmScreen({super.key});

  @override
  State<SplashAlarmScreen> createState() => _SplashAlarmScreenState();
}

class _SplashAlarmScreenState extends State<SplashAlarmScreen> {
  String status = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // donat que _init fa servir textos localitzats
    // no es pot cridar en initState
    // s'ha de cridar en didChangeDependencies, amb la inicialització ja feta
    unawaited(_init());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppStyles.colors.mantis,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.medication, size: 100, color: Colors.green),
              Text(status),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _init() async {
    bool failed = false;
    changeStatus(AppLocalizations.of(context)!.initializing);
    developer.log(
      'Initializing alarm screen (splash screen)',
      level: Level.FINER.value,
    );
    BackgroundPreferences preferences = BackgroundPreferences();
    await Future.delayed(GlobalConstants.longDelayForOperation, () => null);
    if (mounted) {
      changeStatus(AppLocalizations.of(context)!.loadingParameters);
      developer.log(
        'Alarm splash screen: parameters',
        level: Level.FINER.value,
      );
      // alarm screen branch also initializes the main port?
      // main.initializePort();
      FlutterForegroundTask.setOnLockScreenVisibility(true);
      await preferences.init();
    }
    /* missatge final */
    if (mounted) {
      changeStatus(AppLocalizations.of(context)!.informationLoaded);
    }
    /* inici de l'app */
    if (mounted) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute<MainAlarmScreen>(
          builder: (context) => const MainAlarmScreen(),
          settings: RouteSettings(name: alarmScreenPath),
        ),
      );
    } else {
      failed = true;
    }
    if (failed) {
      developer.log(
        "Non mounted context. Widget end",
        level: Level.SEVERE.value,
      );
      developer.debugger();
      await SystemNavigator.pop();
      if (kDebugMode) exit(1); // App error
    }
  }

  void changeStatus(String st) {
    setState(() {
      status = st;
    });
  }
}
