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


class MainAltEntryScreen extends StatelessWidget {
  const MainAltEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context)!.hereWeAre),
        ),
      ),
    );

  }
}
