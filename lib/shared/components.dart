import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui' as ui;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:it_department/shared/constants.dart';
import 'package:transition_plus/transition_plus.dart';

void navigateTo(context, widget) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushReplacement(
    context, MaterialPageRoute(builder: (context) => widget));

void finish(BuildContext context, route) {
  Navigator.pushReplacement(
      context,
      ScaleTransition1(
          page: route,
          startDuration: const Duration(milliseconds: 1000),
          closeDuration: const Duration(milliseconds: 400),
          type: ScaleTrasitionTypes.center));
}



Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.deepPurple,
  Color textColor = Colors.white,
  TextStyle? textStyle,
  double radius = 8.0,
  bool isUpperCase = true,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        height: 20,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          textAlign: TextAlign.center,
          style: textStyle?? TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 2,
              color: textColor),
        ),
      ),
    );

Future<bool?> showToast({
  required String message,
  required dynamic length,
  required dynamic gravity,
  required int timeInSecForIosWeb,
  Color? backgroundColor,
  Color? textColor,
  double? fontSize,
}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: length,
        gravity: gravity,
        timeInSecForIosWeb: timeInSecForIosWeb,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize);

class BlurryDialog extends StatelessWidget {

  String title;
  String content;
  TextStyle? titleTextStyle;
  TextStyle? contentTextStyle;
  TextStyle? okTextStyle;
  TextStyle? noTextStyle;
  double? titleTextMinSize;
  double? titleTextMaxSize;
  double? contentTextMinSize;
  double? contentTextMaxSize;
  int? contentTextMaxLines;
  double? okTextMinSize;
  double? okTextMaxSize;
  double? noTextMinSize;
  double? noTextMaxSize;
  double? blurValue;
  VoidCallback continueCallBack;
  VoidCallback cancelCallBack;

  BlurryDialog(this.title, this.content, this.continueCallBack, this.cancelCallBack, {this.titleTextStyle, this.contentTextStyle, this.okTextStyle, this.noTextStyle, this.blurValue, this.titleTextMinSize, this.titleTextMaxSize, this.contentTextMinSize, this.contentTextMaxSize, this.contentTextMaxLines, this.okTextMinSize, this.okTextMaxSize, this.noTextMinSize, this.noTextMaxSize});
  TextStyle textStyle = const TextStyle (color: Colors.teal, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blurValue??4, sigmaY: blurValue??4),
          child:  AlertDialog(
            title: AutoSizeText(title,style: titleTextStyle??textStyle, minFontSize: titleTextMinSize??10, maxLines: 1, maxFontSize: titleTextMaxSize??14,),
            content: AutoSizeText(content, style: contentTextStyle??textStyle, minFontSize: contentTextMinSize??8, maxLines: contentTextMaxLines??2, maxFontSize: contentTextMaxSize??12,),
            actions: <Widget>[
              TextButton(
                child: AutoSizeText("نعم", style: okTextStyle??textStyle, minFontSize: okTextMinSize??10, maxLines: 1, maxFontSize: okTextMaxSize??12,),
                onPressed: () {
                  continueCallBack();
                },
              ),
              TextButton(
                child: AutoSizeText("الغاء", style: noTextStyle??textStyle,minFontSize: noTextMinSize??10, maxLines: 1, maxFontSize: noTextMaxSize??12,),
                onPressed: () {
                  cancelCallBack();
                },
              ),
            ],
          )),
    );
  }
}

class BlurryProgressDialog extends StatelessWidget {
  final String title;
  TextStyle? titleStyle;
  double? titleMinSize, titleMaxSize, blurValue;
  int? titleMaxLines;
  BlurryProgressDialog({Key? key, required this.title, this.titleStyle, this.titleMaxLines, this.titleMaxSize, this.titleMinSize, this.blurValue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blurValue??4, sigmaY: blurValue??4),
          child: AlertDialog(
            scrollable: true,
            content: Column(
              children: [
                CircularProgressIndicator(color: lightGreen, strokeWidth: 0.8,),
                const SizedBox(height: 36,),
                AutoSizeText(title, style: titleStyle ?? TextStyle(color: Colors.teal[700], fontSize: 12), minFontSize: titleMinSize??12, maxFontSize: titleMaxSize??14, maxLines: titleMaxLines??2,),
                const SizedBox(height: 8,),
              ],
            ),
          )),
    );
  }
}

class DateUtil{

  static String formatDate(DateTime date){

    initializeDateFormatting('ar');
    Intl.defaultLocale = 'ar';
    final DateFormat formatter = DateFormat().add_yMMMd();
    final String formatted = formatter.format(date);

    return formatted;
  }

}

Widget getEmptyWidget() {
  return const SizedBox.shrink();
}

