// Dart base
// Flutter
import 'dart:async';

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
  late final GeneralSettings _generalSettings;
  late final AlarmCollection _alarmCollection;

  /// Ctor
  ConfigPreferences() {
    _generalSettings = GeneralSettings(_shPrefs, notifyListeners);
    _alarmCollection = AlarmCollection(_shPrefs, this, notifyListeners);
  }

  //-----------------------class special members--------------------------------

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
