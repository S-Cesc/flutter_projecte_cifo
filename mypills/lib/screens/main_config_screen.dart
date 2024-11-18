// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
// Dart base
import 'dart:async';
import 'dart:isolate';
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart'
    show FilteringTextInputFormatter, SystemNavigator, TextInputFormatter;
import 'package:provider/provider.dart';
import 'package:flutter_projecte_cifo/providers/config_preferences.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Project files
import '../background_entry.dart';
import '../styles/app_styles.dart';
import '../services/background_alarm_helper.dart';
import 'debug_config_screen.dart';

//=======================================================================

class MainConfigScreen extends StatefulWidget {
  const MainConfigScreen({super.key});

  @override
  State<MainConfigScreen> createState() => _MainConfigScreenState();
}

class _MainConfigScreenState extends State<MainConfigScreen> {
  final ConfigPreferences preferences = ConfigPreferences();
  //final int isolateId = Isolate.current.hashCode;
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConfigPreferences(),
      child: Scaffold(
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
          padding: EdgeInsets.symmetric(horizontal: 75),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                              builder: (context) => DebugConfigScreen(
                                    pref: preferences,
                                  )),
                        );
                      },
                      child: const Text('Debug page'),
                    ),
                  ),
                ),
              Center(
                child: TextField(
                  decoration:
                      InputDecoration(labelText: "alarmDurationSeconds"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], // Only numbers can be entered
                  controller: numberController,
                ),
              ),
              Center(
                child: TextField(
                  decoration: InputDecoration(labelText: "alarmSnoozeSeconds"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], // Only numbers can be entered
                  controller: numberController,
                ),
              ),
              Center(
                child: TextField(
                  decoration: InputDecoration(labelText: "alarmRepeatTimes"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], // Only numbers can be entered
                  controller: numberController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   numberController.dispose();
  //   super.dispose();
  // }
}
