import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Core/cubit/core_states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../models/clerk_model.dart';
import '../../../network/remote/dio_helper.dart';

class CoreCubit extends Cubit<CoreStates>{
  CoreCubit() : super(CoreInitialState());

  static CoreCubit get(context) => BlocProvider.of(context);

  bool gotClerks = false;
  bool zeroClerks = false;
  String publicImage = "https://firebasestorage.googleapis.com/v0/b/mostaqbal-masr.appspot.com/o/Public%2Fbusiness_man_blue.png?alt=media";

  ClerkModel? clerkModel;
  List<ClerkModel> clerksModelList = [];
  List<ClerkModel> filteredClerksModelList = [];
  String chatID = "";

  Future<void> getFilteredClerks()async {
    gotClerks = false;
    emit(CoreLoadingClerksState());
    Future.delayed(const Duration(milliseconds: 500)).then((value)async{
      clerksModelList = [];
      await DioHelper.getData(
          url: 'userInfo/GetAllUserInfo',
          query: {
            'PR_Management_ID': 1028
          }).then((value) {
        if(value.statusMessage != "No Person Form Row Found") {
          if (value.data != null) {
            value.data.forEach((clerk) async {
              print("Name ${clerk["PR_Persons_Name"]}\n");
              print("Status ${clerk["TrueOrFalse"] == 0 ? "لائق" : "غير لائق"}\n");
              var userID = clerk["PR_Persons_Number"].toString();
              var userName = clerk["PR_Persons_Name"].toString();
              var userNumber = clerk["PR_Persons_Number"].toString();
              var userAddress = clerk["PR_Persons_Address"].toString();
              var userPhone = clerk["PR_Persons_MobilNum1"].toString();
              var userManagementID = clerk["PR_Management_ID"].toString();
              var userManagementName = clerk["PR_Management_Name"].toString();
              var userTypeID = clerk["Person_Type_ID"].toString();
              var userTypeName = clerk["Person_Type_Name"].toString();
              var userRankID = clerk["PR_Rank_ID"].toString();
              var userRankName = clerk["PR_Rank_Name"].toString();
              var userCategoryRank = clerk["CategoryRank"].toString();
              var userCategoryID = clerk["PR_Category_ID"].toString();
              var userCategoryName = clerk["PR_Category_Name"].toString();
              var userCoreStrengthID = clerk["PR_CoreStrength_ID"].toString();
              var userCoreStrengthName = clerk["PR_CoreStrength_Name"].toString();
              var userPresenceID = clerk["PR_Presence_ID"].toString();
              var userPresenceName = clerk["PR_Presence_Name"].toString();
              var userJobID = clerk["PR_Jobs_ID"].toString();
              var userJobName = clerk["PR_Jobs_Name"].toString();
              var userStatus = clerk["TrueOrFalse"].toString();
              var onFirebase = clerk["OnFirebase"].toString();
              var userImage = clerk["User_Image"].toString();
              var userToken = "";

              print("Clerk ON Firebase State : $onFirebase ------ ID : $userNumber\n");
              print("Clerk Name : $userName ---- is Empty : ${userImage.toString() == "null"}");
              print("Clerk Image : $userImage\n");
              //print("Clerk Name : $userName ----- Clerk Job Name : $userJobName \n");
              FirebaseFirestore.instance.collection("Clerks").doc(userNumber).get().then((value){
                if(value.exists){
                  Map data = value.data()!;
                  userToken = data["ClerkToken"];
                }
              });
              clerkModel = ClerkModel(
                  userID,
                  userName,
                  onFirebase == "true" ? userImage : publicImage,
                  userNumber,
                  userAddress,
                  userPhone,
                  userTypeID.toString(),
                  userTypeName,
                  userCategoryID,
                  userCategoryName,
                  userCategoryRank,
                  userRankID,
                  userRankName,
                  userManagementID,
                  userManagementName,
                  userJobID,
                  userJobName == "بدون" ? "بدون وظيفة" : userJobName,
                  userCoreStrengthID,
                  userCoreStrengthName,
                  userPresenceID,
                  userPresenceName,
                  userStatus == "0" ? "لائق" : "غير لائق",
                  onFirebase,
                  userToken
              );
              clerksModelList.add(clerkModel!);
              filteredClerksModelList = clerksModelList;
            });
            zeroClerks = false;
            gotClerks = true;
            emit(CoreGetClerksSuccessState());

          }
        }else{
          gotClerks = true;
          zeroClerks = true;
          emit(CoreGetClerksSuccessState());
        }
      }).catchError((error) {
        if (error is DioError) {
          print("Dio ERROR : ${error.toString()}\n");
          emit(CoreGetClerksErrorState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
        } else {
          emit(CoreGetClerksErrorState(error.toString()));
          print("ERROR : ${error.toString()}\n");
        }
      });
    });
  }

  Future<void> createChatList(BuildContext context, String receiverID)async {
    emit(CoreDetailsLoadingCreateChatState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance.collection("ChatList").doc(prefs.getString("ClerkID")).collection("Chats").doc(receiverID).get().then((value){
      if(value.exists){
        Map data = value.data()!;
        chatID = data["ChatID"];
      }else{
        chatID = Random().nextInt(10000).toString();
        Map<String, dynamic> chatListMap = HashMap();
        chatListMap['ReceiverID'] = receiverID;
        chatListMap['ChatID'] = chatID;
        chatListMap['LastMessage'] = "";
        chatListMap['LastMessageType'] = "";
        chatListMap['LastMessageTime'] = "";
        chatListMap['LastMessageSender'] = "";
        FirebaseFirestore.instance.collection("ChatList").doc(prefs.getString("ClerkID")).collection("Chats").doc(receiverID).set(chatListMap).then((value){
          FirebaseFirestore.instance.collection("ChatList").doc(receiverID).collection("Chats").doc(prefs.getString("ClerkID")).set(chatListMap).then((value){
            print("CHAT ID IN CORE CLERK DETAILS CUBIT : $chatID\n");
          });
        });
      }
    });
    emit(CoreDetailsCreateChatSuccessState());
  }
  void goToConversation(BuildContext context, route)async {
    Navigator.push(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
  }

}