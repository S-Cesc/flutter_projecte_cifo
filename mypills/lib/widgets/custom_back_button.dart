import 'package:flutter/material.dart';
import 'package:mypills/model/global_functions.dart';

import '../l10n/app_localizations.dart';
import '../styles/app_styles.dart';

/// AppBar leading component
/// Actual default AppBar leading width is 56 (leadingWidth: 56)
/// 26 is used in padding, the remainder 30 are for the back arrow
class CustomBackButton extends StatelessWidget {
  //
  /// A function to allow move back only when there are not pending changes
  /// When the function is not defined it will be always allowed to go back
  final bool Function()? areThereChanges;

  /// Discard changes
  /// When not defined it will not be allowed to go back
  /// until changes are resolved
  final void Function()? discardChanges;

  /// Ctor
  const CustomBackButton({
    super.key,
    this.areThereChanges,
    this.discardChanges,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    Future<bool?> showAlertDialog(BuildContext context) async {
      // set up the button
      final Widget cancelButton = TextButton(
        child: Text(t.cancel),
        onPressed: () {
          Navigator.pop(context, false);
        },
      );
      final Widget? discardButton =
          discardChanges == null
              ? null
              : TextButton(
                child: Text(t.discard),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              );
      final List<Widget> actions =
          discardChanges == null
              ? [cancelButton]
              : [cancelButton, discardButton!];
      return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final q =
              discardChanges == null
                  ? ''
                  : (' ${t.pendingChangesDiscardQuestion}');
          return AlertDialog(
            title: Text(t.pendingChanges),
            content: Text("${t.pendingChangesMessage}$q"),
            actions: actions,
          ); // show the dialog
        },
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 18, right: 8),
      child: CircleAvatar(
        //radius: 12,
        backgroundColor: AppStyles.colors.mantis[700],
        child: GestureDetector(
          onTap: () async {
            if (areThereChanges?.call() ?? false) {
              final bool result = await showAlertDialog(context) ?? false;
              if (result) {
                discardChanges!.call();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Icon(Icons.arrow_back, color: AppStyles.colors.forestGreen),
        ),
      ),
    );
  }
}
