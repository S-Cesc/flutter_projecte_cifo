import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/global_constants.dart';

/// Widget to input a natural number,
/// a number greater than or equal to zero, with no sign or decimal place
class NatNumberField extends TextField {
  static bool _isValid(
    String text,
    int? v,
    bool acceptNull,
    int? minValue,
    int? maxValue,
  ) {
    if (v == null) {
      return acceptNull && text.isEmpty;
    } else {
      return (minValue == null || v >= minValue) &&
          (maxValue == null || v <= maxValue);
    }
  }

  /// Ctor
  NatNumberField({
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
    InputBorder? border,
    super.maxLength,
    super.readOnly,
    super.focusNode,
    super.enabled,
  }) : assert(minValue == null || maxValue == null || minValue <= maxValue),
       assert(
         maxLength == null ||
             (minValue == null || minValue.toString().length <= maxLength) &&
                 (maxValue == null || maxValue.toString().length <= maxLength),
       ),
       super(
         controller: controller,
         decoration: InputDecoration(
           labelText: labelText,
           errorText:
               _isValid(
                     controller.text,
                     int.tryParse(controller.text),
                     acceptNull,
                     minValue,
                     maxValue,
                   )
                   ? null
                   : errorText,
           icon: icon,
           iconColor: iconColor,
           prefixIcon:
               tooltipHelp == null
                   ? null
                   : Tooltip(
                     message: tooltipHelp,
                     triggerMode: TooltipTriggerMode.tap,
                     showDuration: GlobalConstants.tooltipDuration(
                       tooltipHelp.length,
                     ),
                     child: Icon(Icons.help, color: iconColor),
                   ),
           suffixText: suffixText,
           suffixStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
           contentPadding: EdgeInsets.all(10),
           border: border ?? OutlineInputBorder(),
         ),
         maxLines: 1,
         minLines: 1,
         autocorrect: false,
         enableSuggestions: false,
         textAlign: TextAlign.right,
         keyboardType: TextInputType.number,
         inputFormatters: <TextInputFormatter>[
           FilteringTextInputFormatter.digitsOnly,
         ],
         onChanged: (String value) {
           final int? tmpValue = int.tryParse(value);
           onChanged(
             _isValid(value, tmpValue, acceptNull, minValue, maxValue)
                 ? tmpValue
                 : null,
           );
         },
       );
}
