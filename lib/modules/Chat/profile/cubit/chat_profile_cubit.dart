import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Chat/profile/cubit/chat_profile_states.dart';
import 'package:it_department/modules/Chat/profile/screens/chat_profile_screen.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../../models/chat_model.dart';

class ChatProfileCubit extends Cubit<ChatProfileStates>{
  ChatProfileCubit() : super(ChatProfileInitialState());

  static ChatProfileCubit get(context) => BlocProvider.of(context);

  List<String> filteredImagesList = [];
  List<ChatModel> filteredFilesList = [];
  List<ChatModel> filteredRecordsList = [];
  int mediaCount = 0;
  String userName = "";
  String userImage = "";
  String userJob = "";
  String userCategory = "";
  String userDepartment = "";
  String userPhone = "";
  String userNumber = "";
  String userRank = "";
  List<ChatModel> chatList = [];

  void filterMedia(List<ChatModel> chatList){
   for (var element in chatList) {
      if(element.type == "Image"){
        for (var element in element.chatImagesModel!.messageImagesList) {
          filteredImagesList.add(element);
        }
      }
      if(element.type == "file"){
        filteredFilesList.add(element);
      }
      if(element.type == "audio"){
        filteredRecordsList.add(element);
      }
   }
   mediaCount = filteredImagesList.length + filteredFilesList.length + filteredRecordsList.length;
   emit(ChatProfileFilterMediaState());
  }
  Future<void> getUserData(
      BuildContext context, String userID, String chatID) async {
    emit(ChatProfileLoadingUserDataState());

    FirebaseFirestore.instance
        .collection("Clerks")
        .doc(userID)
        .get()
        .then((value) async {
      if (value.exists) {
        Map data = value.data()!;
        print("USER NAME : ${data["ClerkName"]} \n");
        userName= data["ClerkName"];
        userImage= data["ClerkImage"];
        userJob= data["ClerkJobName"];
        userCategory= data["ClerkCategoryName"];
        userDepartment= data["ClerkManagementName"];
        userPhone= data["ClerkPhone"];
        userNumber= data["ClerkNumber"];
        userRank= data["ClerkRankName"];

      } else {
        print("USER DOESN'T EXIST \n");
      }
      emit(ChatProfileGetUserDataState());
    });
  }

}