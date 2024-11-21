// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:async';
import 'dart:io';
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart' show SystemNavigator;
// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../styles/app_styles.dart';
import '../screens/config_weekdays.dart';
import '../widgets/alarm_preferences_editor.dart';
import 'debug_config_screen.dart';

//=======================================================================

class MainConfigScreen extends StatefulWidget {
  const MainConfigScreen({super.key});

  @override
  State<MainConfigScreen> createState() => _MainConfigScreenState();
}

class _MainConfigScreenState extends State<MainConfigScreen> {
  //final int isolateId = Isolate.current.hashCode;

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppStyles.colors.mantis,
      appBar: AppBar(
        backgroundColor: AppStyles.colors.ochre[700],
        title: Center(
          child: Text(
            "Meues pastis",
            style: AppStyles.fonts.display(),
          ),
        ),
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (kDebugMode)
              Align(
                alignment: Alignment.topRight,
                child: OutlinedButton(
                  style: AppStyles.warningButtonStyle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<DebugConfigScreen>(
                          builder: (context) => DebugConfigScreen()),
                    );
                  },
                  child: const Text('Debug page'),
                ),
              ),
            AlarmPreferencesEditor(),
            Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                  child: Center(
                    child: ElevatedButton(
                      style: AppStyles.customHorizontalButtonStyle,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<ConfigWeekdays>(
                              builder: (context) => ConfigWeekdays()),
                        );
                      },
                      child: Text(t.weeklyTimetable),
                    ),
                  ),
                ),
                // TODO: Localization
                // TODO: Add special days
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(vertical: 2),
                  child: Center(
                    child: ElevatedButton(
                      style: AppStyles.customHorizontalButtonStyle,
                      onPressed: null,
                      child: Text('Add special days'),
                    ),
                  ),
                ),
              ],
            ),
            // TODO: Alarms
            Padding(
              padding: EdgeInsetsDirectional.symmetric(vertical: 2),
              child: Center(
                child: ElevatedButton(
                  style: AppStyles.customHorizontalButtonStyle,
                  onPressed: null,
                  child: Text(t.alarms),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: Center(
                child: OutlinedButton(
                  style: AppStyles.warningButtonStyle,
                  onPressed: () async {
                    developer.log("End application button clicked!",
                        level: Level.FINER.value);
                    await Future.delayed(const Duration(milliseconds: 5),
                        () async {
                      developer.log("Pop screen: " "Exit App button",
                          level: Level.INFO.value);
                      await SystemNavigator.pop();
                      developer.log("Exit application",
                          level: Level.INFO.value);
                      //REVIEW - exit (kDebugMode)
                      if (kDebugMode) exit(0); // kDebugMode
                    });
                  },
                  child: Text(t.endApplication),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
