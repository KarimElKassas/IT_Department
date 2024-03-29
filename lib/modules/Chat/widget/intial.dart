import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Chat/conversation/cubit/conversation_cubit.dart';
import 'package:it_department/modules/Chat/conversation/cubit/conversation_states.dart';
import 'package:it_department/modules/Chat/conversation/screens/conversation_screen.dart';
import 'package:it_department/modules/Chat/widget/page_manager.dart';
import 'package:it_department/modules/GroupChat/conversation/cubit/group_conversation_cubit.dart';
import 'package:it_department/shared/components.dart';
import 'package:just_audio/just_audio.dart';

import '../../../shared/constants.dart';

class IntialScreen extends StatefulWidget {
  @override
  State<IntialScreen> createState() => _IntialScreenState();

}

class _IntialScreenState extends State<IntialScreen> {
  late final PageManager _pageManager;
  String urlint = '';
  var messageController = TextEditingController();

  @override
  void initState() {
    _pageManager = PageManager();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _pageManager.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      ConversationCubit()
        ..getFireStoreMessage("3020", "9574"),
      child: BlocConsumer<ConversationCubit, ConversationStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ConversationCubit.get(context);

          return Scaffold(
              appBar: AppBar(
                leadingWidth: 84,
                leading: InkWell(
                  splashColor: Colors.grey,
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_back),
                      SizedBox(
                        width: 5,
                      ),
                      CircleAvatar(
                        radius: 25,
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.blueGrey.shade700,
                title: const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'إدارة النظم',
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              body:
              getEmptyWidget() /*ChatUI(startRecord: startRecord,sendRecord: sendRecord,deleteRecord: deleteRecord,textfield: textField(cubit, "3020", "9574"),allMessagesWidget: allMessagesWidget(), cubit: cubit, receiverID: "", chatID: "", receiverToken: "",),*/
          );
        },
      ),
    );
  }

  Widget voiceNote(GroupConversationCubit cubit, String urls, String totalDuration, Color progressBarColor, Color progressBarSecondColor, Color iconColor, Color fontColor) {
    return BuildCondition(
      condition: urlint == urls,
      builder: (ctx) {
        return VoiceWidget(cubit: cubit, pageManager: _pageManager, progressbarColor: progressBarColor, progressbarSecondColor: progressBarSecondColor, iconColor: iconColor, fontColor: fontColor,);
      },
      fallback: (ctx) {
        return VoiceConstWidget(
          ff: () {
            setState(() {
              _pageManager.stop();
              _pageManager.dispose();
              _pageManager.url = urls;

              _pageManager.audioPlayer.setUrl(urls);
              _pageManager.init();
              urlint = urls;
            });
            _pageManager.progressNotifier.value = ProgressBarState(
              current: Duration.zero,
              buffered: Duration.zero,
              total: Duration.zero,
            );
          },
          totalDuration: totalDuration,
          iconColor: iconColor,
          progressbarColor: progressBarColor,
          progressbarSecondColor: progressBarSecondColor,
          fontColor: fontColor,
        );
      },
    );
  }
}

class VoiceWidget extends StatefulWidget {
  const VoiceWidget({Key? key, required this.pageManager, required this.progressbarColor, required this.iconColor, required this.progressbarSecondColor, required this.fontColor, required this.cubit}) : super(key: key);
  final PageManager pageManager;
  final dynamic cubit;
  final Color progressbarColor, progressbarSecondColor, iconColor, fontColor;
  @override
  _VoiceWidgetState createState() => _VoiceWidgetState();
}

class _VoiceWidgetState extends State<VoiceWidget> {
  @override
  void initState() {
    if(widget.pageManager.audioPlayer.position>const Duration(milliseconds: 1))
    {

    }else{
      widget.pageManager.play( );
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    print('state is ${widget.pageManager.audioPlayer.position } \n \n \n');
    if(widget.pageManager.audioPlayer.position>const Duration(milliseconds: 1))
      {

      }else{
      urlint = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3";
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ValueListenableBuilder<ButtonState>(
              valueListenable: widget.pageManager.buttonNotifier,
              builder: (_, value, __) {
                switch (value) {
                  case ButtonState.loading:
                    return GestureDetector(
                      onHorizontalDragStart: (DragStartDetails details){
                        widget.cubit.startpoint = details.globalPosition.dx;
                      },
                      onHorizontalDragUpdate: (DragUpdateDetails details ){
                        if(details.globalPosition.dx- widget.cubit.startpoint >= 0.0 && widget.cubit.drag){

                          if(details.globalPosition.dx- widget.cubit.startpoint >= widget.cubit.replyLimit){
                            widget.cubit.updateDragPaddingAndBoolValues(0.0, false);
                          }else{
                            widget.cubit.updateDragPaddingValue(details.globalPosition.dx- widget.cubit.startpoint);
                            print("${details.globalPosition.dx- widget.cubit.startpoint}\n");
                          }
                        }
                      },
                      onHorizontalDragEnd: (DragEndDetails details){
                        widget.cubit.updateDragPaddingAndBoolValues(0.0, true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6, right: 2),
                        child: CircularProgressIndicator(
                          color: widget.progressbarColor,
                          strokeWidth: 0.8,
                        ),
                      ),
                    );
                  case ButtonState.paused:
                    return GestureDetector(
                      onHorizontalDragStart: (DragStartDetails details){
                        widget.cubit.startpoint = details.globalPosition.dx;
                      },
                      onHorizontalDragUpdate: (DragUpdateDetails details ){
                        if(details.globalPosition.dx- widget.cubit.startpoint >= 0.0 && widget.cubit.drag){

                          if(details.globalPosition.dx- widget.cubit.startpoint >= widget.cubit.replyLimit){
                            widget.cubit.updateDragPaddingAndBoolValues(0.0, false);
                          }else{
                            widget.cubit.updateDragPaddingValue(details.globalPosition.dx- widget.cubit.startpoint);
                            print("${details.globalPosition.dx- widget.cubit.startpoint}\n");
                          }
                        }
                      },
                      onHorizontalDragEnd: (DragEndDetails details){
                        widget.cubit.updateDragPaddingAndBoolValues(0.0, true);
                      },
                      onTap: widget.pageManager.play,
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: widget.iconColor,
                        size: 42,
                      ),
                    );
                  case ButtonState.playing:
                    return GestureDetector(
                      onHorizontalDragStart: (DragStartDetails details){
                        widget.cubit.startpoint = details.globalPosition.dx;
                      },
                      onHorizontalDragUpdate: (DragUpdateDetails details ){
                        if(details.globalPosition.dx- widget.cubit.startpoint >= 0.0 && widget.cubit.drag){

                          if(details.globalPosition.dx- widget.cubit.startpoint >= widget.cubit.replyLimit){
                            widget.cubit.updateDragPaddingAndBoolValues(0.0, false);
                          }else{
                            widget.cubit.updateDragPaddingValue(details.globalPosition.dx- widget.cubit.startpoint);
                            print("${details.globalPosition.dx- widget.cubit.startpoint}\n");
                          }
                        }
                      },
                      onHorizontalDragEnd: (DragEndDetails details){
                        widget.cubit.updateDragPaddingAndBoolValues(0.0, true);
                      },
                        onTap: widget.pageManager.pause,
                        child: Icon(
                          Icons.pause_rounded,
                          color: widget.iconColor,
                          size: 42,
                        ),
                    );
                }
              },
            ),
          ],
        ),
        Flexible(
          child: ValueListenableBuilder<ProgressBarState>(
            valueListenable: widget.pageManager.progressNotifier,
            builder: (_, value, __ ) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    GestureDetector(
                        onHorizontalDragStart: (DragStartDetails details){
                          widget.cubit.startpoint = details.globalPosition.dx;
                        },
                        onHorizontalDragUpdate: (DragUpdateDetails details ){
                          if(details.globalPosition.dx- widget.cubit.startpoint >= 0.0 && widget.cubit.drag){

                            if(details.globalPosition.dx- widget.cubit.startpoint >= widget.cubit.replyLimit){
                              widget.cubit.updateDragPaddingAndBoolValues(0.0, false);
                            }else{
                              widget.cubit.updateDragPaddingValue(details.globalPosition.dx- widget.cubit.startpoint);
                              print("${details.globalPosition.dx- widget.cubit.startpoint}\n");
                            }
                          }
                        },
                        onHorizontalDragEnd: (DragEndDetails details){
                          widget.cubit.updateDragPaddingAndBoolValues(0.0, true);
                        },
                        child: const SizedBox(height: 16,)
                     ),
                    ProgressBar(
                      progress: value.current,
                      buffered: value.buffered,
                      total: value.total,
                      onSeek: widget.pageManager.seek,
                      baseBarColor: widget.progressbarColor,
                      barHeight: 3,
                      thumbCanPaintOutsideBar: false,
                      thumbRadius: 7,
                      thumbGlowRadius: 15,
                      thumbColor: widget.progressbarSecondColor,
                      progressBarColor: widget.progressbarSecondColor,
                      bufferedBarColor: widget.progressbarSecondColor,
                      timeLabelType: TimeLabelType.totalTime,
                      timeLabelTextStyle:
                      TextStyle(color: widget.fontColor, fontFamily: "Questv", fontSize: 10),
                      timeLabelPadding: 8,
                    ),
                    GestureDetector(
                        onHorizontalDragStart: (DragStartDetails details){
                          widget.cubit.startpoint = details.globalPosition.dx;
                        },
                        onHorizontalDragUpdate: (DragUpdateDetails details ){
                          if(details.globalPosition.dx- widget.cubit.startpoint >= 0.0 && widget.cubit.drag){

                            if(details.globalPosition.dx- widget.cubit.startpoint >= widget.cubit.replyLimit){
                              widget.cubit.updateDragPaddingAndBoolValues(0.0, false);
                            }else{
                              widget.cubit.updateDragPaddingValue(details.globalPosition.dx- widget.cubit.startpoint);
                              print("${details.globalPosition.dx- widget.cubit.startpoint}\n");
                            }
                          }
                        },
                        onHorizontalDragEnd: (DragEndDetails details){
                          widget.cubit.updateDragPaddingAndBoolValues(0.0, true);
                        },
                        child: const SizedBox(height: 2,)
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class VoiceConstWidget extends StatefulWidget {
  VoiceConstWidget({Key? key, required this.ff, required this.totalDuration, required this.progressbarColor, required this.progressbarSecondColor, required this.iconColor, required this.fontColor})
      : super(key: key);
  VoidCallback ff;
  String totalDuration;
  final Color progressbarColor, progressbarSecondColor, iconColor, fontColor;

  @override
  State<VoiceConstWidget> createState() => _VoiceConstWidgetState();
}

class _VoiceConstWidgetState extends State<VoiceConstWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
           Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: widget.ff,
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 42.0,
                  color: widget.iconColor,
                ),
              ),
              const SizedBox(height: 7,)
            ],
          ),
        const SizedBox(width: 8,),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 16, left: 8, right: 12, bottom: 6),
            child: ProgressBar(
              progress: const Duration(seconds: 0),
              buffered: const Duration(seconds: 0),
              total: stringToDuration(widget.totalDuration),
              onSeek: (_) {},
              baseBarColor: widget.progressbarColor,
              barHeight: 4,
              thumbColor: widget.progressbarSecondColor,
              progressBarColor: widget.progressbarSecondColor,
              bufferedBarColor: widget.progressbarSecondColor,
              timeLabelType: TimeLabelType.totalTime,
              timeLabelTextStyle:
              TextStyle(color: widget.fontColor, fontFamily: "Questv", fontSize: 10),
              timeLabelPadding: 2,
            ),
          ),
        ),
      ],
    );
  }
}
