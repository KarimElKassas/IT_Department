import 'dart:collection';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it_department/modules/GroupChat/details/cubit/group_media_details_states.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../../../models/group_chat_model.dart';
import '../../../../shared/components.dart';

class GroupMediaDetailsCubit extends Cubit<GroupMediaDetailsStates>{
  GroupMediaDetailsCubit() : super(GroupMediaDetailsInitialState());

  static GroupMediaDetailsCubit get(context) => BlocProvider.of(context);

  String downloadingFileName = "";
  String downloadingRecordName = "";
  List<Map<String, dynamic>> filteredImagesList = [];
  List<GroupChatModel> filteredFilesList = [];
  List<GroupChatModel> filteredRecordsList = [];
  List<GroupChatModel> filteredMediaList = [];
  List<Map<String, dynamic>> filteredMediaList2 = [];
  int mediaCount = 0;
  String totalDuration = '0:00';
  String loadingTime = '0:00';
  String audioPath = "";
  String pathToAudio = "";
  String audioPathStore = "";
  bool isRecording = false;
  bool isPaused = false;
  bool emptyImage = true;
  int recordDuration = 0;
  int lastAudioPlayingIndex = 0;
  double audioPlayingSpeed = 1.0;
  late double currAudioPlayingTime;
  final AudioPlayer justAudioPlayer = AudioPlayer();
  final Record record = Record();
  IconData iconData = Icons.play_arrow_rounded;

  bool checkForDocumentFile(String fileName, String groupName) {
    bool isFileExist = File(
        "/storage/emulated/0/Download/IT Department/$groupName/Documents/$fileName")
        .existsSync();
    return isFileExist;
  }
  bool checkForAudioFile(String fileName, String groupName) {
    bool isFileExist = File(
        "/storage/emulated/0/Download/IT Department/$groupName/Records/$fileName")
        .existsSync();
    return isFileExist;
  }

  Future<void> downloadDocumentFile(
      String fileName, String groupName, String groupID) async {
    emit(GroupMediaDetailsLoadingDownloadFileState());
    downloadingFileName = fileName;

    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      File downloadToFile =
      File('$path/IT Department/$groupName/Documents/$fileName');
      //try {
      await FirebaseStorage.instance
          .ref("Chats")
          .child(groupID)
          .child("Documents")
          .child(fileName)
          .writeToFile(downloadToFile);
      downloadingFileName = "";
      emit(GroupMediaDetailsDownloadFileSuccessState());
      /*} on FirebaseException catch (e) {
        downloadingFileName = "";
        emit(GroupConversationDownloadFileErrorState(e.message.toString()));
      }*/
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingFileName = "";
      emit(GroupMediaDetailsDownloadFilePermissionDeniedState());
    }
  }

  Future<void> downloadAudioFile(
      String fileName,String senderName,String groupName, String groupID, int index) async {
    emit(GroupMediaDetailsLoadingDownloadFileState());
    downloadingRecordName = fileName;

    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      File downloadToFile =
      File('$path/IT Department/$groupName/Records/$fileName');
      try {
        await FirebaseStorage.instance
            .ref('Chats/$groupID/Records/$fileName')
            .writeToFile(downloadToFile);
        downloadingRecordName = "";
        emit(GroupMediaDetailsDownloadFileSuccessState());
        chatMicrophoneOnTapAction(index, groupName, fileName);
      } on FirebaseException catch (e) {
        downloadingRecordName = "";
        emit(GroupMediaDetailsDownloadFileErrorState(e.message.toString()));
      }
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingRecordName = "";
      emit(GroupMediaDetailsDownloadFilePermissionDeniedState());
    }
  }
  void chatMicrophoneOnTapAction(int index, String groupName, String fileName) async {
    try {
      justAudioPlayer.positionStream.listen((event) {
        currAudioPlayingTime = event.inMicroseconds.ceilToDouble();
        loadingTime =
        '${event.inMinutes} : ${event.inSeconds > 59 ? event.inSeconds % 60 : event.inSeconds}';
        emit(GroupMediaDetailsChangeRecordPositionState());
      });

      justAudioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          justAudioPlayer.stop();
          loadingTime = '0:00';
          iconData = Icons.play_arrow_rounded;
        }
      });

      if (lastAudioPlayingIndex != index) {
        await justAudioPlayer.setFilePath(
            '/storage/emulated/0/Download/IT Department/$groupName/Records/$fileName');

        lastAudioPlayingIndex = index;
        totalDuration =
        '${justAudioPlayer.duration!.inMinutes} : ${justAudioPlayer.duration!.inSeconds > 59 ? justAudioPlayer.duration!.inSeconds % 60 : justAudioPlayer.duration!.inSeconds}';
        iconData = Icons.pause_rounded;
        audioPlayingSpeed = 1.0;
        justAudioPlayer.setSpeed(audioPlayingSpeed);

        await justAudioPlayer.play();
      } else {
        print(justAudioPlayer.processingState);
        if (justAudioPlayer.processingState == ProcessingState.idle) {
          await justAudioPlayer.setFilePath(
              '/storage/emulated/0/Download/IT Department/$groupName/Records/$fileName');

          lastAudioPlayingIndex = index;
          totalDuration =
          '${justAudioPlayer.duration!.inMinutes} : ${justAudioPlayer.duration!.inSeconds}';
          iconData = Icons.pause_rounded;

          await justAudioPlayer.play();
        } else if (justAudioPlayer.playing) {
          iconData = Icons.play_arrow_rounded;

          await justAudioPlayer.pause();
        } else if (justAudioPlayer.processingState == ProcessingState.ready) {
          iconData = Icons.pause;

          await justAudioPlayer.play();
        } else if (justAudioPlayer.processingState ==
            ProcessingState.completed) {}
      }
      emit(GroupMediaDetailsPlayRecordSuccessState());
    } catch (e) {
      print('Audio Playing Error');
      showToast(
          message: 'May be Audio File Not Found',
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
    }
  }

  void filterMedia(List<GroupChatModel> chatList){
    for (var element in chatList) {
      filteredMediaList.add(element);
      if(element.type == "Image" || element.type =="Image And Text"){
        for (var image in element.chatImagesModel!.messageImagesList) {
          print("inside loop : ${image}\n");
          Map<String, dynamic> map = HashMap();
          map["URL"] = image;
          map["Type"] = "Image";
          map["SenderName"] = element.senderName;
          map["MessageTime"] = element.messageTime;
          filteredMediaList2.add(map);
        }
      }
      if(element.type == "file"){
        filteredFilesList.add(element);
        Map<String, dynamic> map = HashMap();
        map["URL"] = element.message;
        map["Type"] = "file";
        map["SenderName"] = element.senderName;
        map["MessageTime"] = element.messageTime;
        filteredMediaList2.add(map);
      }
      if(element.type == "audio"){
        filteredRecordsList.add(element);
        Map<String, dynamic> map = HashMap();
        map["URL"] = element.message;
        map["Type"] = "audio";
        map["SenderName"] = element.senderName;
        map["MessageTime"] = element.messageTime;
        filteredMediaList2.add(map);
      }

      for(var item in filteredMediaList2){
        if(item["Type"] == "Image"){
          filteredImagesList.add(item);
        }
      }

    }
    mediaCount = filteredImagesList.length + filteredFilesList.length + filteredRecordsList.length;
    print("SIZE ${mediaCount}\n");
    print("SIZE ${filteredMediaList2.length}\n");
    emit(GroupMediaDetailsFilterMediaState());
  }

}