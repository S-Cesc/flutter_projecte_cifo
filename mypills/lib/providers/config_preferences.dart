// Dart base
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_projecte_cifo/providers/alarm_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Project files
import 'alarm_settings.dart';

//==============================================================================

/// The object used to set the configuration
/// It is build from an [AlarmSettings] and an [AlarmCollection]
/// and a [SharedPreferencesAsync] where data is stored
class ConfigPreferences with ChangeNotifier {
  //-------------------------static/constant------------------------------------

  

  //-----------------class state members and constructors ----------------------

  final SharedPreferencesAsync _shPrefs = SharedPreferencesAsync();
  late AlarmSettings _alarmSettings;
  late AlarmCollection _alarmCollection;

  ConfigPreferences() {
    _alarmSettings = AlarmSettings(_shPrefs, callback);
    _alarmCollection = AlarmCollection(_shPrefs, this, callback);
  }

  //-----------------------class special members--------------------------------

  /// Child objects must call to notify changes done
  void callback() {
    notifyListeners();
  }

  /// Initialization of the object
  Future<void> init() async {
    await _alarmSettings.init();
    await _alarmCollection.init();
    notifyListeners();
  }

  //-----------------------class rest of members--------------------------------

  /// Access the depending [AlarmSettings] object
  AlarmSettings get alarmSettings => _alarmSettings;

  /// Access the depending [AlarmCollection] object
  AlarmCollection get alarms => _alarmCollection;
}
