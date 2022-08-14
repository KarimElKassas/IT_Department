import 'custom_radio_button_text_position.dart';

class MyRadioButtonBuilder<T> {
  final String description;
  final MyRadioButtonTextPosition? textPosition;

  MyRadioButtonBuilder(
      this.description, {
        this.textPosition,
      });
}
