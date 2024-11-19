// Dart base
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_projecte_cifo/providers/alarm_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Project files
import 'alarm_settings.dart';

//==============================================================================

class ConfigPreferences with ChangeNotifier {
  //-------------------------static/constant------------------------------------

  

  //-----------------class state members and constructors ----------------------

  final SharedPreferencesAsync _shPrefs = SharedPreferencesAsync();
  late AlarmSettings _alarmSettings;
  late AlarmCollection _alarmCollection;

  ConfigPreferences() {
    _alarmSettings = AlarmSettings(_shPrefs, callback);
    _alarmCollection = AlarmCollection(_shPrefs, callback);
  }

  //-----------------------class special members--------------------------------

  void callback() {
    notifyListeners();
  }

  Future<void> init() async {
    await _alarmSettings.init();
    await _alarmCollection.init();
    notifyListeners();
  }

  //-----------------------class rest of members--------------------------------

  AlarmSettings get alarmSettings => _alarmSettings;
  AlarmCollection get alarms => _alarmCollection;
}
