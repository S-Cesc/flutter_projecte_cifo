/*
// logging and debugging
import 'dart:developer' as developer;
import 'package:logging/logging.dart' show Level;
*/
// // Dart base
// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// // Project files

class MainAltEntryScreen extends StatefulWidget {
  const MainAltEntryScreen({super.key});

  @override
  State<MainAltEntryScreen> createState() => _MainAltEntryScreenState();
}

class _MainAltEntryScreenState extends State<MainAltEntryScreen> {
  bool _alarmIsActivated = true;

  void cancelAlarm() {
    _alarmIsActivated = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text('Android alarm manager plus example'),
            elevation: 4,
            actions: [
              if (_alarmIsActivated)
                IconButton(
                  onPressed: () {
                    cancelAlarm();
                  },
                  icon: const Icon(Icons.stop),
                ),
            ]),
        body: Center(
          child: Text(AppLocalizations.of(context)!.hereWeAre),
        ),
      ),
    );
  }
}
