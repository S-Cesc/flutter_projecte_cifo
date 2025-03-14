// logging and debugging
import 'dart:developer' as developer;
import 'dart:ui';
import 'package:logging/logging.dart' show Level;
// Dart base
// Flutter
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// Localizations
import '../l10n/app_localizations.dart';
// Project files
import '../styles/app_styles.dart';
import '../foreground_entry.dart';
import './foreground_task_handler.dart';

//=======================================================================

/* ONLY static MEMBERS */
/// static members class helper for Foreground Service functionality
class ForegroundEntryHelper {
  // static const String kPortName = 'flutter_foreground_task/isolateComPort';

  // from Foreground Service plugin
  // static const String _kNamePrefix = 'com.pravera.flutter_foreground_task';

  /// Init the Foreground Service; then it must be started
  static void initService() {
    FlutterForegroundTask.initCommunicationPort();
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId:
            ForegroundTaskHandler
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
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );
  }

  /// Start the Foreground Service
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
        (x) =>
            supported
                .where((sup) => sup.languageCode == x.languageCode)
                .isNotEmpty,
        orElse: () => supported.first,
      );
      /*----------------------------------------------------------------------*/
      final t = await AppLocalizations.delegate.load(locale);
      developer.log('Start foreground service!', level: Level.FINE.value);
      return FlutterForegroundTask.startService(
        serviceId: myForegroundTaskId,
        notificationTitle: t.notificationTitle,
        notificationText: '''${t.notificationText1}
${t.notificationText2}''',
        notificationIcon: NotificationIcon(
          metaDataName: 'cat.mypills.service.MEDICATION',
          backgroundColor: AppStyles.colors.ochre,
        ),
        // notificationButtons: [
        //   const NotificationButton(id: 'btn_hello', text: 'hello'),
        // ],
        callback: startCallback,
      );
    }
  }

  /// Request to stop the foreground service
  static Future<ServiceRequestResult> stopService() async {
    return FlutterForegroundTask.stopService();
  }
}
