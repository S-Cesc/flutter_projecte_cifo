// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:isolate';
import 'dart:async' show StreamSubscription, unawaited;
import 'dart:io' show exit;
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
// Project files
import '../main.dart' as main;
import '../common/global_constants.dart';
import '../styles/app_styles.dart';
import '../util/port_facilities.dart';
import '../services/background_alarm_helper.dart';
import '../providers/config_preferences.dart';
import './main_config_screen.dart';

//=======================================================================

/// Splash screen for [main_config_screen] data initialitzation
class SplashConfigScreen extends StatefulWidget {
  /// const [SplashConfigScreen] ctor
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
              if (permissionStatus != PermissionStatus.granted)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        if (kDebugMode) ...[
                          OutlinedButton(
                            style: AppStyles.warningButtonStyle,
                            onPressed: () => exit(0),
                            child: Text(
                              AppLocalizations.of(context)!.exitApplication,
                            ),
                          ),
                        ],
                        ElevatedButton(
                          style: AppStyles.customButtonStyle,
                          onPressed: () => _init(),
                          child: Text(
                            AppLocalizations.of(context)!.restartApplication,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: AppStyles.customButtonStyle,
                          onPressed: () => unawaited(openAppSettings()),
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.changeAlarmPermissions,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void changeStatus(String st) {
    setState(() {
      status = st;
    });
  }

  //

  Future<void> initializePort() async {
    main.wakeupPort = await PortFacilities.initializePort(
      main.wakeupPort,
      main.uiWakeupPortName,
      main.subscription,
    );
    developer.log(
      'Port ${main.uiWakeupPortName} registered',
      level: Level.CONFIG.value,
    );
    main.subscription = null;
    main.subscription = _listenWakeupPort(
      main.wakeupPort!,
      main.uiWakeupPortName,
    );
  }

  StreamSubscription<dynamic> _listenWakeupPort(
    ReceivePort port,
    String portName,
  ) {
    return port.listen((d) async {
      if (d is String && d == "wakeup") {
        developer.log(
          'Wakeup message arrived foreground',
          level: Level.INFO.value,
        );
        final navigator = main.navigatorKey.currentState;
        if (navigator != null) {
          bool currentRouteIsNewRoute = false;
          navigator.popUntil((currentRoute) {
            // This is just a way to access currentRoute; the top route in the
            // Navigator stack.
            if (currentRoute.settings.name == main.alarmScreenPath) {
              currentRouteIsNewRoute = true;
            }
            developer.log(
              'popuntil; now in: ${currentRoute.settings.name ?? "null"}',
              level: Level.FINEST.value,
            );
            // Return true so popUntil() pops nothing.
            return true;
          });
          if (currentRouteIsNewRoute) {
            developer.log(
              'Alarm screen is already on top of stack',
              level: Level.FINEST.value,
            );
          } else {
            while (navigator.canPop()) {
              navigator.pop();
            }
            developer.log(
              "Foreground routes popped: now let's replace screen",
              level: Level.FINEST.value,
            );
            await navigator.pushReplacementNamed(main.alarmScreenPath);
          }
        } else {
          developer.log('NAVIGATOR is null', level: Level.SEVERE.value);
        }
      } else {
        developer.log(
          'Unknown message from $portName: $d',
          level: Level.WARNING.value,
        );
      }
    });
  }

  Future<void> _checkPermissions() async {
    // Request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses =
        await [
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
    developer.log(
      "Result permission statuses: ${statuses.toString()}",
      level: Level.FINE.value,
    );
    developer.log(
      "Resulting permission: ${tmpResult.toString()}",
      level: Level.INFO.value,
    );
    if (permissionStatus != tmpResult) {
      setState(() {
        permissionStatus = tmpResult;
      });
    }
  }

  Future<void> _init() async {
    bool failed = false;
    /* missatge inicial */
    changeStatus(AppLocalizations.of(context)!.initializing);
    developer.log('Initializing (splash screen)', level: Level.FINER.value);
    ConfigPreferences preferences = context.read<ConfigPreferences>();
    await Future.delayed(GlobalConstants.longDelayForOperation, () => null);
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
      await initializePort();
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
      await BackgroundAlarmHelper.initialize();
      /* missatge final */
      if (mounted) {
        changeStatus(AppLocalizations.of(context)!.informationLoaded);
        developer.log('Splash screen finalized', level: Level.FINE.value);
      }
      /* inici de l'app */
      if (mounted) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute<MainConfigScreen>(
            builder: (context) => const MainConfigScreen(),
            settings: RouteSettings(name: main.configScreenPath),
          ),
        );
      } else {
        failed = true;
      }
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
}
