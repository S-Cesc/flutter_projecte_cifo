import 'package:flutter/material.dart';
import './titled_container.dart';

import 'nat_number_field.dart';

/// Widget to input a pair of natural numbers
class PairNatNumberField extends StatefulWidget {
  /// Title for the title and each of the pair of natural number input labels
  final String title;

  /// Title style for each of the components
  final TextStyle labelStyle;
  final Color? _titleBackgroundColor;

  /// Title (label) for the first natural number
  final String? labelText1;

  /// Title (label) for the first natural number
  final String? labelText2;
  final String? _errorText;

  /// Must the pair be an ordered pair,
  /// value of the first below the value of the second?
  final bool ordered;

  /// Is null acceptable as any of the natural value pair?
  final bool acceptNull;

  /// Is the widget readonly?
  final bool readOnly;

  /// Is the widget enabled?
  final bool enabled;

  /// Max length of each natural number (logarithm of its max value)
  final int? maxLength;

  /// Min value for both natural values
  final int? minValue;

  /// Max value for both natural values
  final int? maxValue;

  /// Used for first value units
  final String? suffixText1;

  /// Used for second value units
  final String? suffixText2;

  /// width of the default OutlineInputBorder for each natural value
  /// and the OutlineInputBorder for the pair
  final double borderWidth;
  final Color? _enabledBorderColor;
  final Color? _disabledBorderColor;
  final Color? _focusedBorderColor;
  final String? _tooltipHelp1;
  final String? _tooltipHelp2;

  /// required controller for the first value
  final TextEditingController controller1;

  /// required controller for the sedond value
  final TextEditingController controller2;

  /// required function to obtain the values
  final void Function((int?, int?) t, bool valid) onChanged;

  /// Ctor
  const PairNatNumberField({
    super.key,
    required this.title,
    required this.labelStyle,
    Color? titleBackgroundColor,
    this.labelText1,
    this.labelText2,
    String? errorText,
    required this.controller1,
    required this.controller2,
    required this.onChanged,
    this.acceptNull = false,
    this.ordered = true,
    this.maxLength,
    this.minValue,
    this.maxValue,
    this.suffixText1,
    this.suffixText2,
    String? tooltipHelp1,
    String? tooltipHelp2,
    this.borderWidth = 1.0,
    Color? enabledBorderColor,
    Color? disabledBorderColor,
    Color? focusedBorderColor,
    this.readOnly = false,
    this.enabled = true,
  }) : _tooltipHelp2 = tooltipHelp2,
       _tooltipHelp1 = tooltipHelp1,
       _focusedBorderColor = focusedBorderColor,
       _disabledBorderColor = disabledBorderColor,
       _enabledBorderColor = enabledBorderColor,
       _titleBackgroundColor = titleBackgroundColor,
       _errorText =
           errorText ??
           'invalid value: '
               '$minValue'
               '..$maxValue';

  @override
  State<PairNatNumberField> createState() => _PairNatNumberFieldState();
}

class _PairNatNumberFieldState extends State<PairNatNumberField> {
  //TODO: Translate
  static const nullErrorMsg = "Natural number required";
  late final String rangeErrorMsg;

  bool _isValid(int? value1, int? value2) {
    bool result;
    if (value1 == null || value2 == null) {
      result = widget.acceptNull;
      errorMessage = result ? null : nullErrorMsg;
    } else if (widget.ordered) {
      result = (value1 <= value2);
      errorMessage = result ? null : rangeErrorMsg;
    } else {
      errorMessage = null;
      result = true;
    }
    actualBorderColor = result ? focusColor : errorColor;
    return result;
  }

  final FocusNode _focus1 = FocusNode();
  final FocusNode _focus2 = FocusNode();
  late final Color borderColor;
  late final Color focusColor;
  late final Color errorColor;
  Color? actualBorderColor;
  String? errorMessage;
  int? value1;
  int? value2;

  @override
  void initState() {
    super.initState();
    value1 = int.tryParse(widget.controller1.text);
    value2 = int.tryParse(widget.controller2.text);
    rangeErrorMsg =
        "Required "
        "${widget.labelText1 ?? 'min'} ≤ ${widget.labelText2 ?? 'max'}";
    _focus1.addListener(_onFocus1Change);
    _focus2.addListener(_onFocus2Change);
  }

  @override
  void dispose() {
    super.dispose();
    _focus1.removeListener(_onFocus1Change);
    _focus2.removeListener(_onFocus2Change);
    _focus1.dispose();
    _focus2.dispose();
  }

  void _onFocus1Change() {
    setState(() {
      if (_focus1.hasFocus) {
        actualBorderColor = (errorMessage == null) ? focusColor : errorColor;
      } else {
        actualBorderColor = (errorMessage == null) ? borderColor : errorColor;
      }
    });
  }

  void _onFocus2Change() {
    setState(() {
      if (_focus2.hasFocus) {
        actualBorderColor = (errorMessage == null) ? focusColor : errorColor;
      } else {
        actualBorderColor = (errorMessage == null) ? borderColor : errorColor;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    borderColor =
        widget.enabled
            ? (widget._enabledBorderColor ?? ColorScheme.of(context).outline)
            : widget._disabledBorderColor ??
                ColorScheme.of(context).outline.withValues(alpha: 0.38);
    focusColor = widget._focusedBorderColor ?? ColorScheme.of(context).primary;
    errorColor = ColorScheme.of(context).error;
    if (value1 == null || value2 == null) {
      errorMessage = widget.acceptNull ? null : nullErrorMsg;
    } else if (widget.ordered) {
      errorMessage = (value1! <= value2!) ? null : rangeErrorMsg;
    } else {
      errorMessage = null;
    }
    actualBorderColor =
        (errorMessage == null)
            ? ((_focus1.hasFocus || _focus2.hasFocus)
                ? focusColor
                : borderColor)
            : errorColor;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TitledContainer(
        titleText: widget.title,
        titleStyle: widget.labelStyle,
        focused: _focus1.hasFocus || _focus2.hasFocus,
        borderColor: actualBorderColor,
        titleBackgroundColor: widget._titleBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ValueListenableBuilder(
                      valueListenable: widget.controller1,
                      builder: (context, TextEditingValue value, __) {
                        return NatNumberField(
                          readOnly: widget.readOnly,
                          enabled: widget.enabled,
                          controller: widget.controller1,
                          focusNode: _focus1,
                          labelText: widget.labelText1,
                          suffixText: widget.suffixText1,
                          acceptNull: widget.acceptNull,
                          minValue: widget.minValue,
                          maxValue: widget.maxValue,
                          maxLength: widget.maxLength,
                          errorText: widget._errorText,
                          border: OutlineInputBorder().copyWith(
                            borderSide: BorderSide(
                              width:
                                  (_focus1.hasFocus ? 2 : 1) *
                                  widget.borderWidth,
                              color: actualBorderColor!,
                            ),
                          ),
                          onChanged: (int? value) {
                            value1 = value;
                            setState(() {
                              final bool isValid =
                                  (widget.acceptNull || value != null)
                                      ? _isValid(value, value2)
                                      : false;
                              widget.onChanged((value1, value2), isValid);
                            });
                          },
                          tooltipHelp: widget._tooltipHelp1,
                        );
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ValueListenableBuilder(
                      valueListenable: widget.controller2,
                      builder: (context, TextEditingValue value, __) {
                        return NatNumberField(
                          readOnly: widget.readOnly,
                          enabled: widget.enabled,
                          controller: widget.controller2,
                          focusNode: _focus2,
                          labelText: widget.labelText2,
                          suffixText: widget.suffixText2,
                          acceptNull: widget.acceptNull,
                          minValue: widget.minValue,
                          maxValue: widget.maxValue,
                          maxLength: widget.maxLength,
                          errorText: widget._errorText,
                          border: OutlineInputBorder().copyWith(
                            borderSide: BorderSide(
                              width:
                                  (_focus2.hasFocus ? 2 : 1) *
                                  widget.borderWidth,
                              color: actualBorderColor!,
                            ),
                          ),
                          onChanged: (int? value) {
                            value2 = value;
                            setState(() {
                              final bool isValid =
                                  (widget.acceptNull || value != null)
                                      ? _isValid(value, value2)
                                      : false;
                              widget.onChanged((value1, value2), isValid);
                            });
                          },
                          tooltipHelp: widget._tooltipHelp2,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (errorMessage != null && !_focus1.hasFocus && !_focus2.hasFocus)
              Flexible(
                child: Text(
                  errorMessage!,
                  style: widget.labelStyle.apply(color: errorColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
