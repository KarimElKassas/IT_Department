import 'dart:collection';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/GroupChat/conversation/screens/group_conversation_screen.dart';
import 'package:it_department/modules/GroupChat/details/cubit/group_add_users_states.dart';
import 'package:it_department/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/firebase_clerk_model.dart';

class GroupAddUsersCubit extends Cubit<GroupAddUsersStates>{
  GroupAddUsersCubit() : super(GroupAddUsersInitialState());

  static GroupAddUsersCubit get(context) => BlocProvider.of(context);

  bool isSearching = false;
  String searchText = "";
  String searchQuery = "Search query";
  String groupID = "";
  var searchController = TextEditingController();
  bool isUserSelected = false;

  List<ClerkFirebaseModel> clerkList = [];
  List<Object?> clerkSubscriptionsList = [];
  List<ClerkFirebaseModel> filteredClerkList = [];
  List<ClerkFirebaseModel> selectedClerksList = [];
  List<String> selectedClerksIDList = [];
  ClerkFirebaseModel? clerkModel;

  void changeUserSelect() {
    isUserSelected = !isUserSelected;
    emit(GroupAddUsersChangeSelectState());
  }

  void addClerkToSelect(ClerkFirebaseModel clerkModel) {
    selectedClerksList.add(clerkModel);
    selectedClerksIDList.add(clerkModel.clerkID!);
    emit(GroupAddUsersChangeSelectState());
  }

  void removeUserFromSelect(ClerkFirebaseModel clerkModel) {
    selectedClerksList.remove(clerkModel);
    selectedClerksIDList.remove(clerkModel.clerkID!);
    emit(GroupAddUsersChangeSelectState());
  }

  Future<void> getUsers(List<String> groupMembersList) async {
    emit(GroupAddUsersLoadingGetUsersState());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("${prefs.getString("ClerkID").toString()}\n");
    FirebaseFirestore.instance.collection("Clerks").where("ClerkID", whereNotIn: groupMembersList).snapshots().listen((event) {
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
          print("Clerks List Length : ${filteredClerkList.length}\n");
        }
      }
      emit(GroupAddUsersGetUsersSuccessState());
    });
  }

  void addUserToGroup(BuildContext context, List<String> membersIDList,List<String> membersAndAdminsIDList, String groupID)async{
    emit(GroupAddUsersLoadingAddUsersState());
    print("SELECTED LENGTH ${selectedClerksIDList.length}\n");
    for(var user in selectedClerksIDList){
      membersIDList.add(user);
      membersAndAdminsIDList.add(user);
      print("Selected ID LIST $user\n");
    }

    Map<String, dynamic> dataMap = HashMap();
    dataMap["Members"] = membersIDList;
    dataMap["MembersAndAdmins"] = membersAndAdminsIDList;
    dataMap["MembersCount"] = membersAndAdminsIDList.length.toString();

    FirebaseFirestore.instance.collection("Chats").doc(groupID).update(dataMap).then((value){
      Navigator.pop(context);
      emit(GroupAddUsersAddUsersSuccessState());
    }).catchError((error){
      emit(GroupAddUsersAddUsersErrorState(error.toString()));
    });
  }
  void startSearch(BuildContext context) {
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));

    isSearching = true;
    emit(GroupAddUsersFilterUsersState());
  }

  void updateSearchQuery(String newQuery) {
    searchQuery = newQuery;
    filteredClerkList = clerkList
        .where((user) =>
        user.clerkName.toLowerCase().contains(newQuery.toString()))
        .toList();
    emit(GroupAddUsersFilterUsersState());
  }

  void stopSearching() {
    clearSearchQuery();

    isSearching = false;
    emit(GroupAddUsersFilterUsersState());
  }

  void clearSearchQuery() {
    searchController.clear();
    updateSearchQuery("");
    emit(GroupAddUsersFilterUsersState());
  }

  void searchUser(String value) {
    filteredClerkList = clerkList
        .where(
            (user) => user.clerkName.toLowerCase().contains(value.toString()))
        .toList();
    print("${filteredClerkList.length}\n");
    emit(GroupAddUsersFilterUsersState());
  }
}