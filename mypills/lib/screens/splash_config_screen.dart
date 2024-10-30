// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:async' show unawaited;
import 'dart:io' show exit;
// Flutter
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../providers/preferences.dart';
import '../main.dart' show initializePort;
import './main_config_screen.dart';

class SplashConfigScreen extends StatefulWidget {
  const SplashConfigScreen({super.key});

  @override
  State<SplashConfigScreen> createState() => _SplashConfigScreenState();
}

class _SplashConfigScreenState extends State<SplashConfigScreen> {
  String status = "";
  PermissionStatus permissionStatus = PermissionStatus.granted;

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
            if (permissionStatus != PermissionStatus.granted)
              Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [                  
                Row(
                  children: [
                    Spacer(),
                    ElevatedButton(
                      onPressed: () => exit(1),
                      child: const Text('Close application'),
                    ),
                    ElevatedButton(
                      onPressed: () => _init(),
                      child: const Text('Restart app'),
                    ),
                    Spacer(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => unawaited(openAppSettings()),
                      child:
                          const Text('Change alarm permission configuration'),
                    ),
                  ],
                )
              ])
          ],
        ),
      ),
    );
  }

  void changeStatus(String st) {
    setState(() {
      status = st;
    });
  }

  Future<void> _checkPermissions() async {
    // Request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.scheduleExactAlarm,
      Permission.notification,
    ].request();
    developer.log("Permission statuses: ${statuses.toString()}");
    PermissionStatus tmpResult = statuses.values.reduce((result, st) {
      if (st == PermissionStatus.permanentlyDenied) {
        return PermissionStatus.permanentlyDenied;
      } else if (result == PermissionStatus.granted &&
          st != PermissionStatus.granted) {
        return st;
      } else {
        return result;
      }
    });
    developer.log("Resulting permission: ${tmpResult.toString()}");
    if (permissionStatus != tmpResult) {
      setState(() {
        permissionStatus = tmpResult;
      });
    }
  }

  Future<void> _init() async {
    Preferences preferences = Preferences();
    /* missatge inicial */
    changeStatus(AppLocalizations.of(context)!.initializing);
    await Future.delayed(const Duration(milliseconds: 700), () => null);
    developer.log('Initializing (splash screen)', level: Level.CONFIG.value);
    /* loading parameters */
    if (!mounted) return;
    changeStatus(AppLocalizations.of(context)!.loadingParameters);
    await preferences.init();
    /* setting configuration */
    if (!mounted) return;
    changeStatus(AppLocalizations.of(context)!.settingConfiguration);
    initializePort();
    AndroidAlarmManager.initialize();
    /* permissions */
    if (!mounted) return;
    changeStatus(AppLocalizations.of(context)!.requiredPermissions);
    await _checkPermissions();
    if (permissionStatus != PermissionStatus.granted) {
      if (!mounted) return;
      changeStatus(AppLocalizations.of(context)!.failedPermissions);
    } else {
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
    /* */
    
  }
}
