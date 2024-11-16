// logging and debugging
import 'dart:developer' as developer;
import 'dart:ui';
import 'package:flutter_projecte_cifo/styles/app_styles.dart';
import 'package:logging/logging.dart' show Level;
// Dart base
// Flutter
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// Localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../foreground_entry.dart';
import './foreground_task_handler.dart';

//=======================================================================

/* ONLY static MEMBERS */
class ForegroundEntryHelper {
  // Constants from ForegroundService
  static const String kPortName = 'flutter_foreground_task/isolateComPort';
  static const String _kNamePrefix = 'com.pravera.flutter_foreground_task';

  static void initService() {
    FlutterForegroundTask.initCommunicationPort();
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: ForegroundTaskHandler
            .foregroundIsolateName, // 'foreground_service',
        channelName:
            'MyPills foreground service notification', // 'Foreground Service Notification',
        channelDescription: 'MyPills service foreground alarm',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.MAX,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  static Future<ServiceRequestResult> startService() async {
    const myForegroundTaskId =
        257; // only one instance launched, so it's unmeaningfully
    if (await FlutterForegroundTask.isRunningService) {
      developer.log('restart foreground service!', level: Level.FINE.value);
      return FlutterForegroundTask.restartService();
    } else {
      /* Using locale in service */
      /*----------------------------------------------------------------------*/
      const supported = AppLocalizations.supportedLocales;
      var preferred = PlatformDispatcher.instance.locales;
      // simple version of basicLocaleListResolution(preferred, supported)
      // using only languageCode (as from Widgets.dart)
      final Locale locale = preferred.firstWhere(
          (x) => supported
              .where((sup) => sup.languageCode == x.languageCode)
              .isNotEmpty,
          orElse: () => supported.first);
      /*----------------------------------------------------------------------*/
      final t = await AppLocalizations.delegate.load(locale);
      developer.log('Start foreground service!', level: Level.FINE.value);
      return FlutterForegroundTask.startService(
        serviceId: myForegroundTaskId,
        notificationTitle: t.notificationTitle,
        notificationText: '''${t.notificationText1}
${t.notificationText2}''',
        notificationIcon: NotificationIconData(
             resType: ResourceType.mipmap,
             resPrefix: ResourcePrefix.ic,
             name: "launcher",
             backgroundColor: AppStyles.colors.ochre),
        // notificationButtons: [
        //   const NotificationButton(id: 'btn_hello', text: 'hello'),
        // ],
        callback: startCallback,
      );
    }
  }

  static Future<ServiceRequestResult> stopService() async {
    return FlutterForegroundTask.stopService();
  }
}
