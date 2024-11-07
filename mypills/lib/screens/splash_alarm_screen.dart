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
import '../main.dart' as main;
import '../providers/preferences.dart';
import './main_alarm_screen.dart';

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
    Preferences preferences = Preferences();
    if (mounted) {
      changeStatus(AppLocalizations.of(context)!.loadingParameters);
      developer.log('Splash screen: parameters', level: Level.FINER.value);
      // alarm screen branch also initializes the main port (it doesn't harm)
      main.initializePort();
      FlutterForegroundTask.setOnLockScreenVisibility(true);
      await preferences.init();
    }
    /* missatge final */
    if (mounted) {
      changeStatus(AppLocalizations.of(context)!.informationLoaded);
    }
    /* inici de l'app */
    if (mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute<MainAlarmScreen>(
              builder: (context) => const MainAlarmScreen()));
    }
    if (!mounted) {
      developer.log("Non mounted context. Widget end",
          level: Level.SEVERE.value);
      developer.debugger();
      exit(1);
    }
  }

  void changeStatus(String st) {
    setState(() {
      status = st;
    });
  }

}
