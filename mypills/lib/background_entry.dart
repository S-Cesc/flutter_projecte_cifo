// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:isolate';
import 'dart:ui' show IsolateNameServer;
// Flutter
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// Project files
import '../main.dart' show isolateName;

/* static */ class BackgroundEntry {
  static SendPort? uiSendPort;

  // The callback for our alarm
  @pragma('vm:entry-point')
  static Future<void> callback() async {
    developer.log('Alarm fired!', level: Level.CONFIG as int);

    FlutterRingtonePlayer.playAlarm(
      looping: true,
      asAlarm: true,
      volume: 1.0,
    );

    /*
    // Get the previous cached count and increment it.
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(countKey) ?? 0;
    await prefs.setInt(countKey, currentCount + 1);
  */

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }
}
