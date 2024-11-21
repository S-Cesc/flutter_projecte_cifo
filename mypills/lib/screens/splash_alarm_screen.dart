// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:io';
import 'dart:async' show unawaited;
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../main.dart' show alarmScreenPath;
import '../styles/app_styles.dart';
import '../providers/background_preferences.dart';
import './main_alarm_screen.dart';

//=======================================================================

class SplashAlarmScreen extends StatefulWidget {
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
    return Scaffold(
      backgroundColor: AppStyles.colors.mantis,
      appBar: AppBar(
        title: const Text('Take the pills'),
        elevation: 4,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medication,
              size: 100,
              color: Colors.green,
            ),
            Text(status),
          ],
        ),
      ),
    );
  }

  Future<void> _init() async {
    bool failed = false;
    changeStatus(AppLocalizations.of(context)!.initializing);
    developer.log('Initializing alarm screen (splash screen)',
        level: Level.FINER.value);
    BackgroundPreferences preferences = BackgroundPreferences();
    await Future.delayed(const Duration(milliseconds: 100), () => null);
    if (mounted) {
      changeStatus(AppLocalizations.of(context)!.loadingParameters);
      developer.log('Alarm splash screen: parameters',
          level: Level.FINER.value);
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
              settings: RouteSettings(name: alarmScreenPath)));
    } else {
      failed = true;
    }
    if (failed) {
      developer.log("Non mounted context. Widget end",
          level: Level.SEVERE.value);
      developer.debugger();
      //REVIEW - exit(1) (App error)
      exit(1);
    }
  }

  void changeStatus(String st) {
    setState(() {
      status = st;
    });
  }
}
