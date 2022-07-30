import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:it_department/models/firebase_clerk_model.dart';
import 'package:it_department/modules/Chat/display/screens/display_chats_screen.dart';
import 'package:it_department/modules/GroupChat/details/cubit/group_details_states.dart';
import 'package:it_department/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../../models/group_chat_model.dart';
import '../../../Chat/conversation/screens/conversation_screen.dart';

class GroupDetailsCubit extends Cubit<GroupDetailsStates>{
  GroupDetailsCubit() : super(GroupDetailsInitialState());

  static GroupDetailsCubit get(context) => BlocProvider.of(context);

  List<String> filteredImagesList = [];
  List<GroupChatModel> filteredFilesList = [];
  List<GroupChatModel> filteredRecordsList = [];
  List<GroupChatModel> filteredMediaList = [];
  List<Map<String, dynamic>> filteredMediaList2 = [];
  List<Object?> membersAndAdminsList = [];
  List<Object?> adminsList = [];
  List<Object?> membersList = [];
  List<ClerkFirebaseModel> membersAndAdminsDisplayList = [];
  List<String> membersAndAdminsDisplayIDList = [];
  List<ClerkFirebaseModel> filteredClerkList = [];
  List<String> membersIDList = [];
  ClerkFirebaseModel? clerkModel;
  int mediaCount = 0;
  String membersCount = "0";
  bool isSearching = false;
  String searchText = "";
  String searchQuery = "Search query";
  String groupID = "";
  String myID = "";
  String myName = "";
  String myImage = "";
  String myToken = "";
  bool deleteDialogResult = false;

  var searchController = TextEditingController();

  void getMyID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myID = prefs.getString("ClerkID").toString();
  }

  void changeDeleteDialogResult(bool result){
    deleteDialogResult = result;
    emit(GroupDetailsChangeDeleteDialogResultState());
  }
  void isChatExist(BuildContext context, String userID, String userName, String userImage, String userToken)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var chatListRef = FirebaseFirestore.instance.collection("ChatList").doc(prefs.getString("ClerkID").toString()).collection("Chats").doc(userID);
    chatListRef.get().then((value){
      if(value.exists){
        Map data = value.data()!;
        finish(context,
            ConversationScreen(userID: userID, chatID: data["ChatID"], userName: userName, userImage: userImage, userToken: userToken, openedFrom: "GroupDetails"));
        emit(GroupDetailsCheckForChatSuccessState());
      }else{
        createNewChat(context, userID, userName, userImage, userToken);
      }
    }).catchError((error){
      emit(GroupDetailsCheckForChatErrorState(error.toString()));
    });
  }
  void createNewChat(BuildContext context ,String userID, String userName, String userImage, String userToken)async {
    emit(GroupDetailsCreateChatLoadingState());
    DateTime now = DateTime.now();
    String currentFullTime = DateFormat("yyyy-MM-dd-HH-mm-ss").format(now);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    myID = prefs.getString("ClerkID").toString();
    myName = prefs.getString("ClerkName").toString();
    myImage = prefs.getString("ClerkImage").toString();
    myToken = prefs.getString("ClerkToken").toString();

    var chatListRef = FirebaseFirestore.instance.collection("ChatList").doc(prefs.getString("ClerkID").toString()).collection("Chats").doc(userID);
    var chatListTwoRef = FirebaseFirestore.instance.collection("ChatList").doc(userID).collection("Chats").doc(prefs.getString("ClerkID").toString());

    Map<String, dynamic> dataMap = HashMap();
    dataMap["ChatID"] = currentFullTime;
    dataMap["LastMessage"] = "";
    dataMap["LastMessageSender"] = "";
    dataMap["LastMessageTime"] = "";
    dataMap["LastMessageType"] = "";
    dataMap["PartnerState"] = "";
    dataMap["ReceiverID"] = userID;
    dataMap["ReceiverImage"] = userImage;
    dataMap["ReceiverName"] = userName;
    dataMap["ReceiverToken"] = userToken;
    dataMap["UnReadMessagesCount"] = "0";
    dataMap["TimeStamp"] = Timestamp.now();

    Map<String, dynamic> dataMapTwo = HashMap();
    dataMapTwo["ChatID"] = currentFullTime;
    dataMapTwo["LastMessage"] = "";
    dataMapTwo["LastMessageSender"] = "";
    dataMapTwo["LastMessageTime"] = "";
    dataMapTwo["LastMessageType"] = "";
    dataMapTwo["PartnerState"] = "";
    dataMapTwo["ReceiverID"] = myID;
    dataMapTwo["ReceiverImage"] = myImage;
    dataMapTwo["ReceiverName"] = myName;
    dataMapTwo["ReceiverToken"] = myToken;
    dataMapTwo["UnReadMessagesCount"] = "0";
    dataMapTwo["TimeStamp"] = Timestamp.now();

    chatListRef.set(dataMap).then((value){
      chatListTwoRef.set(dataMapTwo).then((value){
        finish(context,
            ConversationScreen(userID: userID, chatID: currentFullTime, userName: userName, userImage: userImage, userToken: userToken, openedFrom: "GroupDetails"));
        emit(GroupDetailsCreateChatSuccessState());
      }).catchError((error){
        emit(GroupDetailsCreateChatErrorState(error.toString()));
      });
    }).catchError((error){
      emit(GroupDetailsCreateChatErrorState(error.toString()));
    });
  }
  void removeAdminFromList(BuildContext context ,String groupID, String createdBy, String userID)async{
    emit(GroupDetailsRemoveAdminLoadingState());
    if(createdBy != userID){
      adminsList.remove(userID);
      Map<String, dynamic> dataMap = HashMap();
      dataMap["Admins"] = adminsList;

      FirebaseFirestore.instance.collection("Chats").doc(groupID).update(dataMap).then((value){
        Navigator.of(context).pop();
        emit(GroupDetailsRemoveAdminSuccessState());
      }).catchError((error){
        emit(GroupDetailsRemoveAdminErrorState(error.toString()));
      });
    }else{
      showToast(message: "لا يمكن حذف هذا المسؤول لأنه من أنشا المجموعة", length: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 3);
      Navigator.of(context).pop();
      emit(GroupDetailsRemoveAdminSuccessState());
    }
  }
  void addAdminToList(BuildContext context ,String groupID, String userID)async{
    emit(GroupDetailsAddAdminLoadingState());

    adminsList.add(userID);
    Map<String, dynamic> dataMap = HashMap();
    dataMap["Admins"] = adminsList;

    FirebaseFirestore.instance.collection("Chats").doc(groupID).update(dataMap).then((value){
      Navigator.of(context).pop();
      emit(GroupDetailsAddAdminSuccessState());
    }).catchError((error){
      emit(GroupDetailsAddAdminErrorState(error.toString()));
    });
  }

  void removeUserFromGroup(BuildContext context ,String groupID, String createdBy, String userID)async {
    emit(GroupDetailsRemoveUserLoadingState());
    if(createdBy != userID){
      if(adminsList.contains(userID)){
        adminsList.remove(userID);
      }
      if(membersAndAdminsList.contains(userID)){
        membersAndAdminsList.remove(userID);
      }
      if(membersList.contains(userID)){
        membersList.remove(userID);
      }

      Map<String, dynamic> dataMap = HashMap();
      dataMap["Admins"] = adminsList;
      dataMap["MembersCount"] = membersAndAdminsList.length.toString();
      dataMap["Members"] = membersList;
      dataMap["MembersAndAdmins"] = membersAndAdminsList;

      FirebaseFirestore.instance.collection("Chats").doc(groupID).update(dataMap).then((value){
        Navigator.of(context).pop();
        emit(GroupDetailsRemoveUserSuccessState());
      }).catchError((error){
        emit(GroupDetailsRemoveUserErrorState(error.toString()));
      });
    }else{
      showToast(message: "لا يمكن حذف هذا العضو لأنه من أنشا المجموعة", length: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 3);
      Navigator.of(context).pop();
      emit(GroupDetailsRemoveUserSuccessState());
    }

  }

  void leaveGroup(String groupID, BuildContext context)async {
    emit(GroupDetailsRemoveUserLoadingState());

    if(adminsList.contains(myID)){
      adminsList.remove(myID);
    }
    if(membersAndAdminsList.contains(myID)){
      membersAndAdminsList.remove(myID);
    }
    if(membersList.contains(myID)){
      membersList.remove(myID);
    }

    Map<String, dynamic> dataMap = HashMap();
    dataMap["Admins"] = adminsList;
    dataMap["MembersCount"] = membersAndAdminsList.length.toString();
    dataMap["Members"] = membersList;
    dataMap["MembersAndAdmins"] = membersAndAdminsList;

    FirebaseFirestore.instance.collection("Chats").doc(groupID).update(dataMap).then((value){
      finish(context, DisplayChatsScreen(initialIndex: 1));
      emit(GroupDetailsLeaveGroupSuccessState());
    }).catchError((error){
      emit(GroupDetailsRemoveUserErrorState(error.toString()));
    });
  }

  void navigate(BuildContext context, route){
    Navigator.push(
        context,
        ScaleTransition1(
            page: route,
            startDuration: const Duration(milliseconds: 1000),
            closeDuration: const Duration(milliseconds: 500),
            type: ScaleTrasitionTypes.center));
  }

  void getGroupMembers(String groupID)async {
    FirebaseFirestore.instance.collection("Chats").doc(groupID).snapshots().listen((event) {
      Map<String, dynamic> dataMap = event.data()!;
      membersCount = dataMap["MembersCount"];
      membersAndAdminsList = dataMap["MembersAndAdmins"];
      adminsList = dataMap["Admins"];
      membersList = dataMap["Members"];
      for (var element in membersAndAdminsList) {
        membersAndAdminsDisplayList.clear();
        membersAndAdminsDisplayIDList.clear();
        FirebaseFirestore.instance.collection("Clerks").doc(element!.toString()).snapshots().listen((value){
          if(value.data() != null){
            print(value.data());
            Map data = value.data()!;
            clerkModel = ClerkFirebaseModel(
                data["ClerkID"],
                data["ClerkName"],
                data["ClerkImage"],
                data["ClerkManagementID"],
                data["ClerkJobName"],
                data["ClerkCategoryName"],
                data["ClerkID"],
                data["ClerkAddress"],
                data["ClerkPhone"],
                data["ClerkPassword"],
                data["ClerkState"],
                data["ClerkToken"],
                data["ClerkSubscriptions"]);
            membersAndAdminsDisplayList.add(clerkModel!);
            membersAndAdminsDisplayIDList.add(clerkModel!.clerkID!);
            filteredClerkList = membersAndAdminsDisplayList.toList();
          }
          emit(GroupDetailsGetUsersDataState());
        });
      }
      emit(GroupDetailsGetMembersState());
    });
  }

  void filterMedia(List<GroupChatModel> chatList){
    for (var element in chatList) {
      filteredMediaList.add(element);
      if(element.type == "Image" || element.type =="Image And Text"){
        for (var image in element.chatImagesModel!.messageImagesList) {
          print("inside loop : ${image}\n");
          filteredImagesList.add(image);
          Map<String, dynamic> map = HashMap();
          map["URL"] = image;
          map["Type"] = "Image";
          filteredMediaList2.add(map);
        }
      }
      if(element.type == "file"){
        filteredFilesList.add(element);
        Map<String, dynamic> map = HashMap();
        map["URL"] = element.message;
        map["Type"] = "file";
        filteredMediaList2.add(map);
      }
      if(element.type == "audio"){
        filteredRecordsList.add(element);
        Map<String, dynamic> map = HashMap();
        map["URL"] = element.message;
        map["Type"] = "audio";
        filteredMediaList2.add(map);
      }
    }
    mediaCount = filteredImagesList.length + filteredFilesList.length + filteredRecordsList.length;
    print("SIZE ${mediaCount}\n");
    print("SIZE ${filteredMediaList2.length}\n");
    emit(GroupDetailsFilterMediaState());
  }

  void startSearch(BuildContext context) {
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));

    isSearching = true;
    emit(GroupDetailsFilterUsersState());
  }

  void updateSearchQuery(String newQuery) {
    searchQuery = newQuery;
    filteredClerkList = membersAndAdminsDisplayList
        .where((user) =>
        user.clerkName.toLowerCase().contains(newQuery.toString()))
        .toList();
    emit(GroupDetailsFilterUsersState());
  }

  void stopSearching() {
    clearSearchQuery();

    isSearching = false;
    emit(GroupDetailsFilterUsersState());
  }

  void clearSearchQuery() {
    searchController.clear();
    updateSearchQuery("");
    emit(GroupDetailsFilterUsersState());
  }

  void searchUser(String value) {
    filteredClerkList = membersAndAdminsDisplayList
        .where(
            (user) => user.clerkName.toLowerCase().contains(value.toString()))
        .toList();
    print("${filteredClerkList.length}\n");
    emit(GroupDetailsFilterUsersState());
  }

}