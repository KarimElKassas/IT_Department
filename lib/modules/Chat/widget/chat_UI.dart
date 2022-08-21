import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it_department/modules/Chat/conversation/cubit/conversation_states.dart';
import 'package:it_department/shared/constants.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/components.dart';
import '../conversation/cubit/conversation_cubit.dart';

class ChatUI extends StatefulWidget {
  static const route = '/ChatScreen';
  Function startRecord;
  Function sendRecord;
  Function deleteRecord;
  ConversationCubit cubit;
  Widget textfield;
  String receiverID;
  String receiverName;
  String receiverImage;
  String chatID;
  String receiverToken;
  TextEditingController messageController;

  Widget allMessagesWidget;

  Widget lockedStopWatch = Text(
    '00:00',
    style: TextStyle(fontSize: 20),
    textAlign: TextAlign.center,
  );
  Widget horizontalStopWatch = Text(
    '00:00',
    style: TextStyle(fontSize: 20, color: Colors.grey),
  );

  ChatUI(
      {Key? key,
      required this.startRecord,
      required this.sendRecord,
      required this.deleteRecord,
      required this.allMessagesWidget,
      required this.textfield,
      required this.receiverID,
      required this.receiverName,
      required this.receiverImage,
      required this.chatID,
      required this.receiverToken,
      required this.cubit,
      required this.messageController})
      : super(key: key);

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  double opacity = 1.0;
  double dX = 0.0;
  double dY = 0.0;
  double recordButtonSize = 50;
  double limit = 150;
  bool recording = false;
  Color recordButtonMicColor = Colors.white;
  bool movable = false;
  bool lockedRecord = false;
  Timer? timer;
  Timer? ampTimer;
  Amplitude? amplitude;
  int recordDuration = 0;

  Widget recordButton(ConversationCubit cubit) {
    return ValueListenableBuilder(
      valueListenable: messageControllerValue,
      builder: (context, value, state){
        if(value.toString().trim().isNotEmpty){
          return Positioned(
            right: cubit.dX,
            bottom: cubit.dY,
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ClipOval(
                child: Material(
                  color: white, // Button color
                  child: InkWell(
                    onTap: ()async{
                      if (cubit.isImageOnly) {
                      } else {
                        if (messageControllerValue.value
                            .toString()
                            .trim()
                            .isEmpty ||
                            messageControllerValue.value.toString().trim() ==
                                "") {
                          showToast(
                              message: "لا يمكن ارسال رسالة فارغة",
                              length: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3);
                          return;
                        }
                        print("User Token : ${widget.receiverToken}\n");
                        cubit.sendFireStoreMessage(
                            widget.receiverID,
                            widget.chatID,
                            messageControllerValue.value.toString(),
                            "Text",
                            false,
                            widget.receiverToken,
                            widget.messageController);
                        messageControllerValue.value = "";
                        messageControllerValue.value = "";
                      }
                    },
                    child: SizedBox(
                      width: cubit.recordButtonSize,
                      height: cubit.recordButtonSize,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor:
                        lightGreen,
                        child: Icon(
                          IconlyBold.send,
                          size: 24,
                          color: white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }else{
          return Positioned(
            right: cubit.dX,
            bottom: cubit.dY,
            child: GestureDetector(
              onLongPressStart: cubit.onLongPressStart,
              onLongPressMoveUpdate: cubit.onLongPressUpdating,
              onLongPressEnd: cubit.onLongPressEnd,
              child: Card(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular((cubit.recordButtonSize / 2))),
                margin: const EdgeInsets.only(right: 6),
                elevation: 5,
                child: Container(
                  width: cubit.recordButtonSize,
                  height: cubit.recordButtonSize,
                  decoration:
                  BoxDecoration(shape: BoxShape.circle, color: lightGreen),
                  child: cubit.dX >= (cubit.limit - (cubit.recordButtonSize / 2))
                      ? Icon(
                    Icons.delete_rounded,
                    color: cubit.recordButtonMicColor,
                    size: (cubit.recordButtonSize / 2),
                  )
                      : cubit.dY >= (cubit.limit - (cubit.recordButtonSize / 2))
                      ? Icon(
                    Icons.lock_rounded,
                    color: cubit.recordButtonMicColor,
                    size: (cubit.recordButtonSize / 2),
                  )
                      : Icon(
                    Icons.mic,
                    color: cubit.recordButtonMicColor,
                    size: (cubit.recordButtonSize / 2),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget verticalMoveWidget(ConversationCubit cubit) {
    return Positioned(
        bottom:
            cubit.dY + (cubit.recordButtonSize / 2) - (cubit.dX / (cubit.recordButtonSize / 2) * cubit.limit),
        right: 0,
        child: Card(
          margin: const EdgeInsets.only(right: (10)),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                if ((cubit.limit - cubit.dY) >= 40)
                  Icon(
                    Icons.lock_rounded,
                    color: cubit.dX <= (cubit.recordButtonSize / 2)
                        ? Colors.grey
                            .withOpacity(1 - (cubit.dX / (cubit.recordButtonSize / 2)))
                        : Colors.grey.withOpacity(0),
                  ),
                if (cubit.dY < cubit.limit - (cubit.recordButtonSize / 2) - 10)
                  const SizedBox(
                    height: 10,
                  ),
                if (cubit.dY < cubit.limit - (cubit.recordButtonSize) - 10)
                  Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: cubit.dX <= (cubit.recordButtonSize / 2)
                        ? Colors.grey
                            .withOpacity(1 - (cubit.dX / (cubit.recordButtonSize / 2)))
                        : Colors.grey.withOpacity(0),
                  ),
              ],
            ),
            width: cubit.recordButtonSize - 20,
            height: cubit.limit - cubit.dY,
            decoration: BoxDecoration(
              color: cubit.dX <= (cubit.recordButtonSize / 2)
                  ? Colors.white.withOpacity(1 - (cubit.dX / (cubit.recordButtonSize / 2)))
                  : Colors.white.withOpacity(0),
              borderRadius: const BorderRadius.all(Radius.circular(40)),
            ),
          ),
        ));
  }

  Widget horizontalMoveWidget(ConversationCubit cubit) {
    return Positioned(
        bottom: 0,
        left: 0,
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 5, left: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width - 35 - cubit.dX,
            child: Stack(
              children: [
                Positioned(
                    right: cubit.recordButtonSize / 2 + 25,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        height: 50,
                        child: Center(
                            child: Row(
                          children: const [
                            Icon(
                              Icons.keyboard_arrow_left_rounded,
                              color: Colors.grey,
                            ),
                            Text('إسحب لحذف التسجيل',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Questv",
                                    color: Colors.grey)),
                          ],
                        )))),
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      height: 50,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.mic,
                            color: Colors.white,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          buildText(cubit),
                          const SizedBox(
                            width: 30,
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

  Widget textFieldWidget() {
    return Positioned(
        bottom: 0,
        left: 0,
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.only(left: 4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 65,
            child: widget.textfield,
          ),
        ));
  }

  Widget allMessagesWidget() {
    return Container(
      padding: EdgeInsets.all(recording ? 0 : 0),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: widget.allMessagesWidget,
    );
  }

  Widget buildText(ConversationCubit cubit) {
    if (cubit.isRecording || cubit.isPaused) {
      return _buildTimer(cubit);
    }
    return const Text("");
  }
  Widget _buildTimer(ConversationCubit cubit) {
    final String minutes = _formatNumber(cubit.recordDuration ~/ 60);
    final String seconds = _formatNumber(cubit.recordDuration % 60);



    return Text(
      '$minutes : $seconds',
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: "Questv"),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }
    return numberStr;
  }

  Widget lockedRecordWidget(ConversationCubit cubit, String receiverID) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipOval(
                child: Material(
                  color: white, // Button color
                  child: InkWell(
                    onTap: () async {
                      cubit.sendRecord();
                    },
                    child: SizedBox(
                      height: 45,
                      width: 45,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: lightGreen,
                        child: Icon(
                          IconlyBold.send,
                          size: 24,
                          color: white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              AnimatedOpacity(
                  opacity: cubit.opacity,
                  duration: const Duration(milliseconds: 1500),
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "جارى التسجيل ...",
                        style: TextStyle(fontSize: 18, fontFamily: "Questv"),
                        textDirection: TextDirection.rtl,
                      ),
                  ),
              ),
              const Spacer(),
              Row(
                children: [
                  AnimatedOpacity(
                    opacity: cubit.opacity,
                    duration: const Duration(milliseconds: 1500),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: buildText(cubit),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        cubit.deleteRecord();
                      },
                      icon: const Icon(
                        Icons.delete_rounded,
                        size: 30,
                        color: Colors.grey,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  } // bottom widget

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConversationCubit()..changeOpacity()..getChatData(widget.receiverID, widget.chatID),
      child: BlocConsumer<ConversationCubit, ConversationStates>(
        listener: (context, state){},
        builder: (context,state){
          var cubit = ConversationCubit.get(context);

          return Container(
            padding: const EdgeInsets.only(bottom: 8),
            width: double.infinity,
            color: Colors.transparent,
            child: Stack(
              children: [
                allMessagesWidget(),
                cubit.recording && !cubit.lockedRecord ? verticalMoveWidget(cubit) : const SizedBox(),
                cubit.recording && !cubit.lockedRecord
                    ? horizontalMoveWidget(cubit)
                    : const SizedBox(),
                if (!cubit.recording) textFieldWidget(),
                recordButton(cubit),
                if (cubit.lockedRecord) lockedRecordWidget(cubit, widget.receiverID)
              ],
            ),
          );
        },
      ),
    );
  }
}

