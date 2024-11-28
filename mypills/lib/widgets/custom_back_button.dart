import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

/// AppBar leading component
/// Actual default AppBar leading width is 56 (leadingWidth: 56)
/// 26 is used in padding, the remainder 30 are for the back arrow
class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 18, right: 8),
      child: CircleAvatar(
        //radius: 12,
        backgroundColor: AppStyles.colors.mantis[700],
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: AppStyles.colors.forestGreen,
          ),
        ),
      ),
    );
  }
}
