import 'dart:collection';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it_department/modules/GroupChat/details/cubit/group_media_details_states.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../models/group_chat_model.dart';
import '../../../../shared/components.dart';

class GroupMediaDetailsCubit extends Cubit<GroupMediaDetailsStates>{
  GroupMediaDetailsCubit() : super(GroupMediaDetailsInitialState());

  static GroupMediaDetailsCubit get(context) => BlocProvider.of(context);

  String downloadingFileName = "";
  List<Map<String, dynamic>> filteredImagesList = [];
  List<GroupChatModel> filteredFilesList = [];
  List<GroupChatModel> filteredRecordsList = [];
  List<GroupChatModel> filteredMediaList = [];
  List<Map<String, dynamic>> filteredMediaList2 = [];
  int mediaCount = 0;

  bool checkForDocumentFile(String fileName, String groupName) {
    bool isFileExist = File(
        "/storage/emulated/0/Download/IT Department/$groupName/Documents/$fileName")
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