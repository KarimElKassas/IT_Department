import 'package:flutter/material.dart';

import 'custom_radio_button.dart';
import 'custom_radio_button_builder.dart';
import 'custom_radio_button_text_position.dart';

class MyRadioGroup<T> extends StatelessWidget {
  /// Creates a [RadioButton] group
  ///
  /// The [groupValue] is the selected value.
  /// The [items] are elements to contruct the group
  /// [onChanged] will called every time a radio is selected. The clouser return the selected item.
  /// [direction] most be horizontal or vertial.
  /// [spaceBetween] works only when [direction] is [Axis.vertical] and ignored when [Axis.horizontal].
  /// and represent the space between elements
  /// [horizontalAlignment] works only when [direction] is [Axis.horizontal] and ignored when [Axis.vertical].
  final T groupValue;
  final List<T> items;
  final MyRadioButtonBuilder Function(T value) itemBuilder;
  final void Function(T?)? onChanged;
  final Axis direction;
  final double spaceBetween;
  final MainAxisAlignment horizontalAlignment;
  final Color? activeColor;
  final TextStyle? textStyle;

  const MyRadioGroup.builder({Key? key,
    required this.groupValue,
    required this.onChanged,
    required this.items,
    required this.itemBuilder,
    this.direction = Axis.vertical,
    this.spaceBetween = 30,
    this.horizontalAlignment = MainAxisAlignment.spaceBetween,
    this.activeColor,
    this.textStyle,
  }) : super(key: key);

  List<Widget> get _group => items.map(
        (item) {
      final radioButtonBuilder = itemBuilder(item);

      return SizedBox(
          height: direction == Axis.vertical ? spaceBetween : 40.0,
          child: MyRadioButton(
            description: radioButtonBuilder.description,
            value: item,
            groupValue: groupValue,
            onChanged: onChanged,
            textStyle: textStyle,
            textPosition: radioButtonBuilder.textPosition ??
                MyRadioButtonTextPosition.right,
            activeColor: activeColor,
          )
      );
    },
  ).toList();

  @override
  Widget build(BuildContext context) => direction == Axis.vertical
      ? Column(
    children: _group,
  )
      : Row(
    mainAxisAlignment: horizontalAlignment,
    children: _group,
  );
}
