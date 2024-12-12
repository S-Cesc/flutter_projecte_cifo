import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NatNumberTextField extends TextField {
  static bool _isValid(int? v, bool acceptNull, int? minValue, int? maxValue) {
    if (v == null) {
      return acceptNull;
    } else {
      return (minValue == null || v >= minValue) &&
          (maxValue == null || v <= maxValue);
    }
  }

  NatNumberTextField({
    super.key,
    Widget? icon,
    Color? iconColor,
    String? labelText,
    String? errorText,
    required TextEditingController controller,
    required void Function(int?) onChanged,
    bool acceptNull = false,
    int? minValue,
    int? maxValue,
    String? suffixText,
    String? tooltipHelp,
    super.maxLength,
    super.readOnly,
    super.enabled,
  })  : assert(maxLength == null ||
            (minValue == null || minValue.toString().length <= maxLength) &&
                (maxValue == null || maxValue.toString().length <= maxLength)),
        super(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              errorText: _isValid(int.tryParse(controller.text), acceptNull,
                      minValue, maxValue)
                  ? null
                  : errorText,
              icon: icon,
              iconColor: iconColor,
              prefixIcon: tooltipHelp == null
                  ? null
                  : Tooltip(
                      message: tooltipHelp,
                      triggerMode: TooltipTriggerMode.tap,
                      showDuration:
                        Duration(seconds: 1 + tooltipHelp.length ~/ 4),
                      child: Icon(Icons.help, color: iconColor,),
                    ),
              suffixText: suffixText,
              suffixStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(),
            ),
            maxLines: 1,
            minLines: 1,
            autocorrect: false,
            enableSuggestions: false,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (String value) {
              final int? tmpValue = int.tryParse(value);
              onChanged(_isValid(tmpValue, acceptNull, minValue, maxValue)
                  ? tmpValue
                  : null);
            });
}
