// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
// Flutter
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// Project files
import 'services/foreground_task_handler.dart';

//=======================================================================

/// Bind a the [ForegroundTaskHandler] TaskHandler to the Foreground Service
/// It is called by [ForegroundEntryHelper.startService]
@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  developer.log('Foreground service callback!', level: Level.FINE.value);
  FlutterForegroundTask.setTaskHandler(ForegroundTaskHandler());
}
