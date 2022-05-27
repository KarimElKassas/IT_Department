import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui' as ui;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void navigateTo(context, widget) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushReplacement(
    context, MaterialPageRoute(builder: (context) => widget));

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
  VoidCallback continueCallBack;

  BlurryDialog(this.title, this.content, this.continueCallBack);
  TextStyle textStyle = const TextStyle (color: Colors.teal, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child:  AlertDialog(
            title: Text(title,style: textStyle,),
            content: Text(content, style: textStyle,),
            actions: <Widget>[
              TextButton(
                child: Text("نعم", style: textStyle,),
                onPressed: () {
                  continueCallBack();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("الغاء", style: textStyle,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )),
    );
  }
}

class BlurryProgressDialog extends StatelessWidget {
  final String title;

  const BlurryProgressDialog({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            scrollable: true,
            content: Column(
              children: [
                Text(title, style: TextStyle(color: Colors.teal[700], fontSize: 12),),
                const SizedBox(height: 36,),
                CircularProgressIndicator(color: Colors.teal[700], strokeWidth: 0.8,),
                const SizedBox(height: 8,),

              ],
            ),
          )),
    );
  }
}

class PulsatingCircleIconButton extends StatefulWidget {
  const PulsatingCircleIconButton({
    Key? key,
    required this.onLongPressStart,
    required this.onLongPressUp,
    required this.icon,
  }) : super(key: key);

  final Function onLongPressStart;
  final Function onLongPressUp;
  final Icon icon;

  @override
  _PulsatingCircleIconButtonState createState() => _PulsatingCircleIconButtonState();
}

class _PulsatingCircleIconButtonState extends State<PulsatingCircleIconButton> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
    );
    _animationController!.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart : widget.onLongPressStart(),
      onLongPressUp : widget.onLongPressUp(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: AnimatedBuilder(
          animation: _animation!,
          builder: (context, _) {
            return Ink(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  for (int i = 1; i <= 2; i++)
                    BoxShadow(
                      color: Colors.white.withOpacity(_animationController!.value / 2),
                      spreadRadius: _animation!.value * i,
                    )
                ],
              ),
              child: widget.icon,
            );
          },
        ),
      ),
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