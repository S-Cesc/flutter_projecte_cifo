import 'package:flutter/material.dart';

/// A Container with border and title
class TitledContainer extends StatelessWidget {
  final Widget _child;
  final String _titleText;
  final double _idden;
  final TextStyle _titleStyle;
  final bool _focused;
  final Color? _borderColor;
  final Color? _backgroundColor;

  /// Ctor
  const TitledContainer({
    required String titleText,
    required TextStyle titleStyle,
    required Widget child,
    required bool focused,
    Color? borderColor,
    Color? titleBackgroundColor,
    double idden = 8,
    super.key,
  }) : _child = child,
       _idden = idden,
       _focused = focused,
       _titleText = titleText,
       _titleStyle = titleStyle,
       _borderColor = borderColor,
       _backgroundColor = titleBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: EdgeInsets.all(_idden),
          decoration: BoxDecoration(
            border: Border.all(
              color: _borderColor ?? Color(0xFF000000),
              width: _focused ? 2.0 : 1.0,
            ),
            borderRadius: BorderRadius.circular(_idden * 0.6),
          ),
          child: _child,
        ),
        Positioned(
          left: 10,
          right: 10,
          top: 0,
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              color: _backgroundColor,
              child: Text(
                _titleText,
                style: _titleStyle,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
