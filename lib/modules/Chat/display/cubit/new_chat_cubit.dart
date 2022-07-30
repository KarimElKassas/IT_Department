import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:it_department/modules/Chat/conversation/screens/conversation_screen.dart';
import 'package:it_department/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/firebase_clerk_model.dart';
import 'new_chat_states.dart';

class NewChatCubit extends Cubit<NewChatStates>{
  NewChatCubit() : super(NewChatInitialState());

  static NewChatCubit get(context) => BlocProvider.of(context);

  bool isSearching = false;
  String searchText = "";
  String searchQuery = "Search query";
  String groupID = "";
  var searchController = TextEditingController();

  List<ClerkFirebaseModel> clerkList = [];
  List<Object?> clerkSubscriptionsList = [];
  List<ClerkFirebaseModel> filteredClerkList = [];
  List<ClerkFirebaseModel> selectedClerksList = [];
  List<String> selectedClerksIDList = [];
  ClerkFirebaseModel? clerkModel;

  String myID = "";
  String myName = "";
  String myImage = "";
  String myToken = "";

  void isEqual()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Object?> membersList = [prefs.getString("ClerkID").toString(),"20"];
    List<Object?> secondList = ["20",prefs.getString("ClerkID").toString()];
    if(membersList == secondList){
      print("EQUAAAAAAL\n");
    }else{
      print("Not EQUAAAAAAL\n");
    }
  }
  void isChatExist(BuildContext context, String userID, String userName, String userImage, String userToken)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var chatListRef = FirebaseFirestore.instance.collection("ChatList").doc(prefs.getString("ClerkID").toString()).collection("Chats").doc(userID);
    chatListRef.get().then((value){
      if(value.exists){
        Map data = value.data()!;
        finish(context,
            ConversationScreen(userID: userID, chatID: data["ChatID"], userName: userName, userImage: userImage, userToken: userToken, openedFrom: "CreateNew"));
        emit(NewChatCheckForChatSuccessState());
      }else{
        createNewChat(context, userID, userName, userImage, userToken);
      }
    }).catchError((error){
      emit(NewChatCheckForChatErrorState(error.toString()));
    });
  }
  void createNewChat(BuildContext context ,String userID, String userName, String userImage, String userToken)async {
    emit(NewChatCreateChatLoadingState());
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
            ConversationScreen(userID: userID, chatID: currentFullTime, userName: userName, userImage: userImage, userToken: userToken, openedFrom: "CreateNew"));
            emit(NewChatCreateChatSuccessState());
      }).catchError((error){
        emit(NewChatCreateChatErrorState(error.toString()));
      });
    }).catchError((error){
      emit(NewChatCreateChatErrorState(error.toString()));
    });
  }

  Future<void> getUsers() async {
    emit(NewChatLoadingUsersState());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance.collection("Clerks").where("ClerkID", isNotEqualTo: prefs.getString("ClerkID").toString()).snapshots().listen((event) {
      clerkList.clear();
      clerkSubscriptionsList = [];
      filteredClerkList.clear();
      clerkModel = null;
      if(event.docs.isNotEmpty){
        for (var element in event.docs) {
          Map user = element.data();
          user["ClerkSubscriptions"].forEach((group) {
            clerkSubscriptionsList.add(group);
          });
          clerkModel = ClerkFirebaseModel(
              user["ClerkID"],
              user["ClerkName"],
              user["ClerkImage"],
              user["ClerkManagementID"],
              user["ClerkJobName"],
              user["ClerkCategoryName"],
              user["ClerkNumber"],
              user["ClerkAddress"],
              user["ClerkPhone"],
              user["ClerkPassword"],
              user["ClerkState"],
              user["ClerkToken"],
              clerkSubscriptionsList);

          clerkList.add(clerkModel!);
          filteredClerkList = clerkList.toList();
        }
      }
      emit(NewChatGetUsersSuccessState());
    }).onError((error){
      emit((NewChatGetUsersErrorState(error.toString())));
    });
  }

  void startSearch(BuildContext context) {
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));

    isSearching = true;
    emit(NewChatFilterUsersState());
  }

  void updateSearchQuery(String newQuery) {
    searchQuery = newQuery;
    filteredClerkList = clerkList
        .where((user) =>
        user.clerkName.toLowerCase().contains(newQuery.toString()))
        .toList();
    emit(NewChatFilterUsersState());
  }

  void stopSearching() {
    clearSearchQuery();

    isSearching = false;
    emit(NewChatFilterUsersState());
  }

  void clearSearchQuery() {
    searchController.clear();
    updateSearchQuery("");
    emit(NewChatFilterUsersState());
  }

  void searchUser(String value) {
    filteredClerkList = clerkList
        .where(
            (user) => user.clerkName.toLowerCase().contains(value.toString()))
        .toList();
    emit(NewChatFilterUsersState());
  }

}