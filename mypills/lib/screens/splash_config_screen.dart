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
import '../main.dart' show initializePort;
import './main_config_screen.dart';
import '../providers/preferences.dart';

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
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
      Permission.systemAlertWindow,
      Permission.ignoreBatteryOptimizations,
    ].request();
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
    developer.log("Result permission statuses: ${statuses.toString()}", level: Level.FINE.value);
    developer.log("Resulting permission: ${tmpResult.toString()}", level: Level.INFO.value);
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
    developer.log('Initializing (splash screen)', level: Level.FINER.value);
    /* loading parameters */
    if (mounted) {
      changeStatus(AppLocalizations.of(context)!.loadingParameters);
      developer.log('Splash screen: parameters', level: Level.FINER.value);
      await preferences.init();
    }
    /* setting configuration */
    if (mounted) {
      changeStatus(AppLocalizations.of(context)!.settingConfiguration);
      developer.log('Splash screen: configuration', level: Level.FINER.value);
      initializePort();
    }
    /* permissions */
    if (mounted) {
      changeStatus(AppLocalizations.of(context)!.requiredPermissions);
      developer.log('Splash screen: permissions', level: Level.FINER.value);
      await _checkPermissions();
    }
    /* iniciant servei */
    if (permissionStatus != PermissionStatus.granted && mounted) {
      changeStatus(AppLocalizations.of(context)!.failedPermissions);
    } else if (mounted) {
      changeStatus(AppLocalizations.of(context)!.initializingServices);
      developer.log('Splash screen: services', level: Level.FINER.value);
      await AndroidAlarmManager.initialize();
      /* missatge final */
      if (mounted) {
        changeStatus(AppLocalizations.of(context)!.informationLoaded);
        developer.log('Splash screen finalized', level: Level.FINE.value);
      }
      /* inici de l'app */
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute<MainConfigScreen>(
                builder: (context) => const MainConfigScreen()));
      }
    }
    if (!mounted) {
      developer.log("Non mounted context. Widget end",
          level: Level.SEVERE.value);
      developer.debugger();
      exit(1);
    }
  }
}
