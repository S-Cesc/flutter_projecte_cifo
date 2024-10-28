// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:async' show unawaited;
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../providers/preferences.dart';
import '../main.dart' show initializePort;
import './main_config_screen.dart';


class SplashAltEntryScreen extends StatefulWidget {
  const SplashAltEntryScreen({super.key});

  @override
  State<SplashAltEntryScreen> createState() => _SplashAltEntryScreenState();
}

class _SplashAltEntryScreenState extends State<SplashAltEntryScreen> {
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

  // TODO
  
  Future<void> _init() async {
    Preferences preferences = Preferences();
    /* missatge inicial */
    changeStatus(AppLocalizations.of(context)!.initializing);
    await Future.delayed(const Duration(milliseconds: 700), () => null);
    developer.log('Alarm fired!', level: Level.CONFIG.value);
    /* loading parameters */
    if (!mounted) return;
    changeStatus(AppLocalizations.of(context)!.loadingParameters);
    await preferences.init();
    /* setting configuration */
    if (!mounted) return;
    changeStatus(AppLocalizations.of(context)!.settingConfiguration);
    initializePort();
    /* missatge final */
    if (!mounted) return;
    changeStatus(AppLocalizations.of(context)!.informationLoaded);
    /* inici de l'app */
    if (!mounted) return;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute<MainConfigScreen>(
            builder: (context) => const MainConfigScreen()));
  }

  void changeStatus(String st) {
    setState(() {
      status = st;
    });
  }
}
