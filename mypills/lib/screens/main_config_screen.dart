// logging and debugging
import 'dart:developer' as developer;
import 'package:flutter_projecte_cifo/model/alarm_preferences.dart';
import 'package:flutter_projecte_cifo/providers/alarm_settings.dart';
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:async';
import 'dart:io';
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart'
    show FilteringTextInputFormatter, SystemNavigator, TextInputFormatter;
import 'package:flutter_projecte_cifo/providers/config_preferences.dart';
// Localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
// Project files
import '../styles/app_styles.dart';
import '../screens/config_weekdays.dart';
import 'debug_config_screen.dart';

//=======================================================================

class MainConfigScreen extends StatefulWidget {
  const MainConfigScreen({super.key});

  @override
  State<MainConfigScreen> createState() => _MainConfigScreenState();
}

class _MainConfigScreenState extends State<MainConfigScreen> {
  //final int isolateId = Isolate.current.hashCode;
  late List<TextEditingController> _controlers;
  
  @override
  void initState() {
    final pref = context.read<ConfigPreferences>();
    // TODO: implement initState
    _controlers = [
      TextEditingController.fromValue(TextEditingValue(
          text: pref.alarmSettings.data.alarmDurationSeconds.toString())),
      TextEditingController.fromValue(TextEditingValue(
          text: pref.alarmSettings.data.alarmRepeatTimes.toString())),
      TextEditingController.fromValue(TextEditingValue(
          text: pref.alarmSettings.data.alarmSnoozeSeconds.toString())),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    Future<void> saveValues(List<TextEditingController> controlers) async {
      List<int> values = [];
      for (int i = 0; i < 3; i++) {
        values.add(int.parse(controlers[i].text));
      }
      final pref = context.read<ConfigPreferences>();
      await pref.alarmSettings.setAlarmDurationSeconds(values[0]);
      await pref.alarmSettings.setAlarmRepeatTimes(values[1]);
      await pref.alarmSettings.setAlarmSnoozeSeconds(values[2]);
      setState(() {});
    }

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
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (kDebugMode)
              Padding(
                padding: EdgeInsetsDirectional.only(bottom: 20),
                child: Center(
                  child: ElevatedButton(
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
              ),
            Center(
              child: TextField(
                decoration: InputDecoration(labelText: t.alarmDurationSeconds),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
                controller: _controlers[0],
              ),
            ),
            Center(
              child: TextField(
                decoration: InputDecoration(labelText: t.alarmRepeatTimes),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
                controller: _controlers[1],
              ),
            ),
            Center(
              child: TextField(
                decoration: InputDecoration(labelText: t.alarmSnoozeSeconds),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
                controller: _controlers[2],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 40)),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(vertical: 10),
              child: Center(
                child: ElevatedButton(
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
            Padding(
              padding: EdgeInsetsDirectional.symmetric(vertical: 10),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<DebugConfigScreen>(
                          builder: (context) => DebugConfigScreen()),
                    );
                  },
                  child: Text(t.alarms),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    developer.log("End application button clicked!",
                        level: Level.FINER.value);
                    await Future.delayed(const Duration(milliseconds: 5),
                        () async {
                      developer.log("Pop screen", level: Level.INFO.value);
                      await SystemNavigator.pop();
                      developer.log("Exit application",
                          level: Level.INFO.value);
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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    for (int i = 0; i < 3; i++) {
      _controlers[i].dispose();
    }
    super.dispose();
  }
}
