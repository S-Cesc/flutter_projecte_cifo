/*
// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
*/
// // Dart base
// Flutter
import 'package:flutter/material.dart';
// Project files
import 'alarm_settings.dart';

class Preferences extends ChangeNotifier {

  static final Preferences _preferences = Preferences._();
  final AlarmSettings _alarmSettings = AlarmSettings();

  Preferences._();

  factory Preferences() {
    return _preferences;
  }

  Future<void> init() async {
    await _alarmSettings.init();
    notifyListeners();
  }

  AlarmSettings get alarmSettings => _alarmSettings;
  
}
