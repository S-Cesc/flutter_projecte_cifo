import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Common functions for the application
class GlobalFunctions {
  //
  /// Notify the user that the changes have been discarded
  static void notifyUndo(BuildContext context, AppLocalizations t) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.pendingChangesDiscarded),
          backgroundColor: Colors.red,
        ),
      );
}
