import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it_department/modules/Chat/widget/chat_UI.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/components.dart';
import '../../../shared/constants.dart';
import '../conversation/cubit/conversation_cubit.dart';
import '../conversation/cubit/conversation_states.dart';

class InputFieldWidget extends StatefulWidget {

  final String userID;
  final String chatID;
  final String userName;
  final String userToken;
  final String userImage;

  const InputFieldWidget({Key? key, required this.userID, required this.chatID, required this.userName, required this.userToken, required this.userImage}) : super(key: key);

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  var messageController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConversationCubit, ConversationStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ConversationCubit.get(context);

        return Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child:  !cubit.isRecording ?
                  Container(
                      padding: const EdgeInsets.only(
                        left: 4,
                        right: 24,
                      ),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              textDirection: TextDirection.rtl,
                              autofocus: false,
                              style: TextStyle(
                                  color: lightGreen, fontFamily: "Questv", fontSize: 14),
                              maxLines: 3,
                              minLines: 1,
                              decoration: InputDecoration(
                                hintText: "رسالتك ... ",
                                hintStyle:
                                TextStyle(color: lightGreen, fontFamily: "Questv", fontSize: 14),
                                hintTextDirection: TextDirection.rtl,
                                border: InputBorder.none,
                              ),

                              onChanged: (String value) {

                                messageControllerValue.value = value.toString();

                                if (value.isEmpty || value.characters.isEmpty) {
                                  print("FIRST CASE\n");
                                  cubit.changeUserState("1", widget.userID);
                                }else{
                                  print("SECOND CASE\n");
                                  cubit.changeUserState("2", widget.userID);
                                }
                              },
                              onEditingComplete: () {
                                cubit.changeUserState("1", widget.userID);
                              },
                            ),
                          ),
                          const SizedBox(width: 6),
                          IconButton(
                            onPressed: () {
                              cubit.selectFile(widget.userID, widget.chatID);
                            },
                            icon: Icon(IconlyBroken.paperUpload,
                                color: lightGreen),
                            iconSize: 25,
                            constraints: const BoxConstraints(maxWidth: 25),
                          ),
                          const SizedBox(width: 6),
                          IconButton(
                            onPressed: () {
                              cubit.selectImages(context, widget.userID, widget.userToken, widget.userName, widget.userImage, widget.chatID);
                            },
                            icon: Icon(IconlyBroken.camera,
                                color: lightGreen),
                            iconSize: 25,
                            constraints: const BoxConstraints(maxWidth: 25),
                          ),
                        ],
                      ),
                    ) :
                  Center(child: buildRecordingHolder(cubit)),
                ),
                const SizedBox(width: 8),
                ValueListenableBuilder(
                  valueListenable: messageControllerValue,
                  builder: (context, value, state){
                    if (value.toString().trim().isNotEmpty) {
                      return ClipOval(
                        child: Material(
                          color: white, // Button color
                          child: InkWell(
                            onTap: ()async{
                              if (cubit.isImageOnly) {
                              } else {
                                if (messageController.text
                                    .toString()
                                    .trim()
                                    .isEmpty ||
                                    messageController.text.toString().trim() ==
                                        "") {
                                  showToast(
                                      message: "لا يمكن ارسال رسالة فارغة",
                                      length: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 3);
                                  return;
                                }
                                print("User Token : ${widget.userToken}\n");
                                cubit.sendFireStoreMessage(
                                    widget.userID,
                                    widget.chatID,
                                    messageController.text.toString(),
                                    "Text",
                                    false,
                                    widget.userToken,
                                    messageController);
                                messageController.text = "";
                                messageControllerValue.value = "";
                              }
                            },
                            child: SizedBox(
                              height: 45,
                              width: 45,
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
                      );
                    } else {
                      return ValueListenableBuilder(
                        valueListenable: startedRecordValue,
                        builder: (context, value, state){
                          if (value == true) {
                            return InkWell(
                              onTap: ()async {
                                await cubit.stopRecord(widget.userID, widget.chatID);
                              },
                              child: SizedBox(
                                height: 45,
                                width: 45,
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
                            );
                          } else {
                            return InkWell(
                              onTap: ()async{
                                await cubit.recordAudio();
                              },
                              child: SizedBox(
                                height: 45,
                                width: 45,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor:
                                  lightGreen,
                                  child: Icon(
                                    Icons.mic,
                                    size: 24,
                                    color: white,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildRecordingHolder(ConversationCubit cubit){

    return Padding(
      padding: const EdgeInsets.only(bottom: 4,left: 6, right: 6),
      child: InkWell(
        onTap: ()async{
          if(cubit.isRecording){
            await cubit.cancelRecord();
          }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: const [0.1, 0.5, 0.7, 0.9],
              colors: [
                Colors.teal[400]!,
                Colors.teal[600]!,
                Colors.teal[700]!,
                Colors.teal[800]!,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 12,),
                const Flexible(
                  child: Text(
                    "جارى التسجيل اضغط للإلغاء",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8,),
                buildText(cubit),
                const SizedBox(width: 6.0,),
                const Icon(Icons.mic,color: Colors.white,size: 22,),
                const SizedBox(width: 8.0,),
              ],
            ),
          ),
        ),
      ),
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
      style: const TextStyle(color: Colors.white, fontSize: 14.0,),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }
    return numberStr;
  }
}
