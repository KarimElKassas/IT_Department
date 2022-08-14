import 'package:flutter/material.dart';

Color darkGreen = const Color(0xff013d17);
Color lightGreen = const Color(0xff005c22);
Color veryLightGreen = const Color(0xff01a738);
Color lightGrey = const Color(0xffE5EEE8);
Color teal700 =  Colors.teal[700]!;
Color teal =  Colors.teal;
Color white =  Colors.white;
Color orangeColor =  const Color(0xffBF9A35);
Color greyBorderColor = const Color(0xffD4DDE8);
Color greyThreeColor = const Color(0xff92A8C4);
Color greyFiveColor = const Color(0xFFEBEEF5);
Color greySixColor = const Color(0xFFF8F9FC);

List<dynamic>? messageImagesStaticList = [];
bool customerLogged = false;
bool imagesUploaded = false;
String uploadingImagesMessageID = "";
String lastOpenedScreen = "";
String currentLanguage = "";
String currentTheme = "";
String currentDraggableRecord = "";
bool isFingerPrintEnabled = false;

final messageControllerValue = ValueNotifier<String>("");
final startedRecordValue = ValueNotifier<bool>(false);
final lastMessageValue = ValueNotifier<String>("");
final lastMessageTimeValue = ValueNotifier<String>("");

Duration stringToDuration(String format){
  var parts = format.split(':');
  var minutes = parts[0].trim();
  var seconds = parts[1].trim();

  int totalSeconds = (int.parse(minutes) * 60) + int.parse(seconds);

  return Duration(seconds: totalSeconds);
}
String urlint = '';
