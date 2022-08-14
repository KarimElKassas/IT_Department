import 'package:flutter/material.dart';
import 'package:it_department/shared/constants.dart';

import 'custom_radio_button_text_position.dart';

class MyRadioButton<T> extends StatelessWidget {
  final String description;
  final T value;
  final T groupValue;
  final void Function(T?)? onChanged;
  final MyRadioButtonTextPosition textPosition;
  final Color? activeColor;
  final TextStyle? textStyle;

  const MyRadioButton({Key? key,
    required this.description,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.textPosition = MyRadioButtonTextPosition.right,
    this.activeColor,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () {
      if (onChanged != null) {
        onChanged!(value);
      }
    },
    splashColor: veryLightGreen.withOpacity(0.1),
    child: Row(
      mainAxisAlignment: textPosition == MyRadioButtonTextPosition.right
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: <Widget>[
        textPosition == MyRadioButtonTextPosition.left
            ? Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Text(
            description,
            style: textStyle,
            textAlign: TextAlign.left,
          ),
        )
            : Container(),
        Radio<T>(
            groupValue: groupValue,
            onChanged: onChanged,
            value: value,
            activeColor: activeColor,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap
        ),
        textPosition == MyRadioButtonTextPosition.right
            ? Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: Text(
            description,
            style: textStyle,
            textAlign: TextAlign.right,
          ),
        )
            : Container(),
      ],
    ),
  );
}
