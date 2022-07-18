import 'dart:collection';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/models/display_chat_model_new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../../models/chat_model.dart';
import '../../../../models/display_chat_model.dart';
import '../../../../models/display_chat_model_new.dart';
import '../../../../models/firebase_clerk_model.dart';
import '../../conversation/screens/conversation_screen.dart';
import 'display_chats_states.dart';

class DisplayChatsCubit extends Cubit<DisplayChatsStates> {
  DisplayChatsCubit() : super(DisplayChatsInitialState());

  static DisplayChatsCubit get(context) => BlocProvider.of(context);

  DisplayChatModel? displayChatModel;
  DisplayGroupsModel? displayGroupModel;
  ClerkFirebaseModel? clerkModel;
  ChatModel? chatModel;

  List<ClerkFirebaseModel> clerkList = [];
  List<ClerkFirebaseModel> filteredClerkList = [];
  List<DisplayChatModel> chatList = [];
  List<DisplayGroupsModel> groupList = [];
  List<DisplayChatModel> filteredChatList = [];
  List<DisplayGroupsModel> filteredGroupList = [];
  List<ChatModel> messagesList = [];

  String lastMessage = "";
  String lastMessageTime = "";
  String lastMessageText = "";
  String lastMessageTimeText = "";
  String chatID = "";
  String groupID = "";

  bool isSearching = false;
  String searchText = "";
  String searchQuery = "Search query";
  String myID = "";
  String myName = "";
  String myImage = "";
  var searchController = TextEditingController();

  void getMyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    myID = prefs.getString("ClerkID").toString();
    myName = prefs.getString("ClerkName").toString();
    myImage = prefs.getString("ClerkImage").toString();

  }
  void goToConversation(BuildContext context, route) async {
    Navigator.push(
        context,
        ScaleTransition1(
            page: route,
            startDuration: const Duration(milliseconds: 1500),
            closeDuration: const Duration(milliseconds: 800),
            type: ScaleTrasitionTypes.bottomRight));
  }

  Future<void> getChats() async {
    emit(DisplayChatsLoadingChatsState());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection("Chats")
        .where("ChatType", isEqualTo: "Group")
        .where("MembersAndAdmins", arrayContains: prefs.getString("ClerkID").toString())
        .orderBy("TimeStamp", descending: true)
        .snapshots()
        .listen((event) async {
      groupList.clear();
      filteredGroupList.clear();
      for (var element in event.docs) {
        if (element.exists) {
          Map data = element.data();
          print("MEMBERS COUNT IS -> ${data["MembersCount"]}\n");
          print("Group INFOOOOOOO ::: $data\n");
          displayGroupModel = DisplayGroupsModel(
              data["ChatID"],
              data["ChatName"],
              data["ChatImageUrl"],
              data["MembersCount"],
              data["ChatLastMessage"],
              data["ChatLastMessageTime"],
              data["ChatLastMessageType"],
              data["ChatLastMessageSenderID"],
              data["ChatLastMessageSenderName"],
              data["ChatUnReadCount"],
              data["ChatPartnerState"],
              data["Members"],
              data["Admins"],
              data["MembersAndAdmins"],
          );
          groupList.add(displayGroupModel!);
          filteredGroupList = groupList.toList();
        }
      }
      print("FILTERED GROUP LIST LENGTH : ${filteredGroupList.length}\n");
      emit(DisplayChatsGetChatsState());
    });

    FirebaseFirestore.instance
        .collection("Chats")
        .where("ChatType", isEqualTo: "Single")
        .where("Members", arrayContains: prefs.getString("ClerkID").toString())
        .orderBy("TimeStamp", descending: true)
        .snapshots()
        .listen((event) async {
      chatList.clear();
      clerkList.clear();
      filteredClerkList.clear();
      filteredChatList.clear();
      for (var element in event.docs) {
        if (element.exists) {
          Map data = element.data();
          print("DATA ::: $data\n");
          displayChatModel = DisplayChatModel(
              data["ReceiverID"].toString(),
              data["ReceiverName"].toString(),
              data["ReceiverImage"].toString(),
              data["ReceiverToken"].toString(),
              data["ChatID"].toString(),
              data["LastMessage"].toString(),
              data["LastMessageTime"].toString(),
              data["LastMessageType"].toString(),
              data["LastMessageSenderID"].toString(),
              data["LastMessageSenderName"].toString(),
              data["UnReadMessagesCount"].toString(),
              data["PartnerState"].toString(),
              data["Members"],
          );
          await FirebaseFirestore.instance
              .collection("Clerks")
              .doc(data["ReceiverID"])
              .get()
              .then((value) {
            if (value.exists) {
              Map clerk = value.data()!;
              print("Clerk DATA : $clerk\n");
              print("Clerk State : ${data["PartnerState"].toString()}\n");
              clerkModel = ClerkFirebaseModel(
                  clerk["ClerkID"],
                  clerk["ClerkName"],
                  clerk["ClerkImage"],
                  clerk["ClerkManagementID"].toString(),
                  clerk["ClerkJobName"],
                  clerk["ClerkCategoryName"],
                  clerk["ClerkNumber"],
                  clerk["ClerkAddress"],
                  clerk["ClerkPhone"],
                  clerk["ClerkPassword"],
                  clerk["ClerkState"],
                  clerk["ClerkToken"],
                  clerk["clerkSubscriptions"]);
              clerkList.add(clerkModel!);
              filteredClerkList = clerkList.toList();
            }
          });
          chatList.add(displayChatModel!);
          filteredChatList = chatList.toList();
        }
      }
      print("Chat List Length : ${chatList.length}\n");
      print("User List Length : ${clerkList.length}\n");
      emit(DisplayChatsGetChatsState());
    });
  }

  void startSearch(BuildContext context) {
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));

    isSearching = true;
    emit(DisplayChatsFilterChatsState());
  }

  void updateSearchQuery(String newQuery, int index) {
    searchQuery = newQuery;
    if (index == 0) {
      filteredChatList = chatList
          .where((user) =>
              user.userName.toLowerCase().contains(newQuery.toString()))
          .toList();
    } else {
      filteredGroupList = groupList
          .where((chat) =>
              chat.groupName.toLowerCase().contains(newQuery.toString()))
          .toList();
    }
    emit(DisplayChatsFilterChatsState());
  }

  void stopSearching() {
    clearSearchQuery();

    isSearching = false;
    emit(DisplayChatsFilterChatsState());
  }

  void clearSearchQuery() {
    searchController.clear();
    updateSearchQuery("", 0);
    emit(DisplayChatsFilterChatsState());
  }

  void searchChat(String value) {
    filteredChatList = chatList
        .where((user) => user.userName.toLowerCase().contains(value.toString()))
        .toList();
    print("${filteredChatList.length}\n");
    emit(DisplayChatsFilterChatsState());
  }

  void navigate(BuildContext context, route) {
    Navigator.push(
        context,
        ScaleTransition1(
            page: route,
            startDuration: const Duration(milliseconds: 1500),
            closeDuration: const Duration(milliseconds: 800),
            type: ScaleTrasitionTypes.center));
  }
}
