import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/models/firebase_clerk_model.dart';
import 'package:it_department/modules/GroupChat/details/cubit/group_details_states.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../../models/group_chat_model.dart';

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
  var searchController = TextEditingController();

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