// Dart base
// Flutter
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Project files
import 'general_settings.dart';
import 'alarm_collection.dart';

//==============================================================================

/// The object used to set the configuration
/// It is build from an [GeneralSettings] and an [AlarmCollection]
/// and a [SharedPreferencesAsync] where data is stored
class ConfigPreferences with ChangeNotifier {
  //-------------------------static/constant------------------------------------

  //-----------------class state members and constructors ----------------------

  final SharedPreferencesAsync _shPrefs = SharedPreferencesAsync();
  late GeneralSettings _generalSettings;
  late AlarmCollection _alarmCollection;

  /// Ctor
  ConfigPreferences() {
    _generalSettings = GeneralSettings(_shPrefs, callback);
    _alarmCollection = AlarmCollection(_shPrefs, this, callback);
  }

  //-----------------------class special members--------------------------------

  /// Child objects must call to notify changes done
  void callback() {
    notifyListeners();
  }

  /// Initialization of the object
  Future<void> init() async {
    await _generalSettings.init();
    await _alarmCollection.init();
    notifyListeners();
  }

  //-----------------------class rest of members--------------------------------

  /// Access the depending [GeneralSettings] object
  GeneralSettings get generalSettings => _generalSettings;

  /// Access the depending [AlarmCollection] object
  AlarmCollection get alarms => _alarmCollection;
}
