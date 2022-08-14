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

class TextFieldDialog extends StatelessWidget {

  Widget content;
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

  TextFieldDialog(this.content, this.continueCallBack, this.cancelCallBack, {this.titleTextStyle, this.contentTextStyle, this.okTextStyle, this.noTextStyle, this.blurValue, this.titleTextMinSize, this.titleTextMaxSize, this.contentTextMinSize, this.contentTextMaxSize, this.contentTextMaxLines, this.okTextMinSize, this.okTextMaxSize, this.noTextMinSize, this.noTextMaxSize});
  TextStyle textStyle = const TextStyle (color: Colors.teal, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blurValue??4, sigmaY: blurValue??4),
          child:  AlertDialog(
            content: content,
            contentPadding: EdgeInsets.all(8),
            actions: <Widget>[
              TextButton(
                child: AutoSizeText("نعم", style: okTextStyle??textStyle, minFontSize: okTextMinSize??10, maxLines: 1, maxFontSize: okTextMaxSize??12,),
                onPressed: () {
                  continueCallBack();
                },
                style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => veryLightGreen.withOpacity(0.08))),
              ),
              TextButton(
                child: AutoSizeText("الغاء", style: noTextStyle??textStyle,minFontSize: noTextMinSize??10, maxLines: 1, maxFontSize: noTextMaxSize??12,),
                onPressed: () {
                  cancelCallBack();
                },
                style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => veryLightGreen.withOpacity(0.08))),
              ),
            ],
            buttonPadding: const EdgeInsets.all(4),
          ),
      ),
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

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  CustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation? _circleAnimation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
        begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Container(
            width: 48.0,
            height: 28.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              color: !widget.value
                  ? Colors.grey
                  : lightGreen,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
              child: Container(
                alignment:
                widget.value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
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

