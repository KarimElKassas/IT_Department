import 'dart:collection';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:it_department/models/clerk_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../models/firebase_clerk_model.dart';
import '../../../../../network/remote/dio_helper.dart';
import '../../../../../shared/components.dart';
import '../../../Login/clerk_login_screen.dart';
import '../../conversation/screens/group_conversation_screen.dart';
import '../screens/new_group_screen.dart';
import '../screens/select_group_users_screen.dart';
import 'new_group_states.dart';

class NewGroupCubit extends Cubit<NewGroupStates> {
  NewGroupCubit() : super(NewGroupInitialState());

  static NewGroupCubit get(context) => BlocProvider.of(context);

  List<ClerkModel> userList = [];
  List<ClerkModel> filteredUserList = [];
  List<ClerkModel> selectedUsersList = [];
  List<String> selectedUsersIDList = [];
  List<String> groupAdminsList = [];
  ClerkModel? userModel;

  List<ClerkFirebaseModel> clerkList = [];
  List<Object?> clerkSubscriptionsList = [];
  List<ClerkFirebaseModel> filteredClerkList = [];
  List<ClerkFirebaseModel> selectedClerksList = [];
  List<String> selectedClerksIDList = [];
  ClerkFirebaseModel? clerkModel;

  bool isUserSelected = false;
  bool emptyImage = true;
  String imageUrl = "";
  final ImagePicker imagePicker = ImagePicker();
  double? loginLogID;
  bool isSearching = false;
  String searchText = "";
  String searchQuery = "Search query";
  String groupID = "";
  var searchController = TextEditingController();

  void navigateToSelectUsers(BuildContext context) {
    navigateTo(context, SelectGroupUsersScreen());
  }

  Future<void> logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginLogID = prefs.getDouble("Login_Log_ID");
    print("Login Log ID $loginLogID");

    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(now);

    await DioHelper.updateData(url: 'loginlog/PutWithParams', query: {
      'Login_Log_ID': loginLogID!.toInt(),
      'Login_Log_TDate': formattedDate,
    }).then((value) async {
      await prefs.remove("Login_Log_ID");
      await prefs.remove("LoginDate");
      await prefs.remove("Section_User_ID");
      await prefs.remove("Section_ID");
      await prefs.remove("Section_Name");
      await prefs.remove("Section_Forms_Name_List");
      await prefs.remove("User_ID");
      await prefs.remove("User_Name");
      await prefs.remove("User_Password");
      await prefs.remove("ClerkName");
      await prefs.remove("ClerkPhone");
      await prefs.remove("ClerkNumber");
      await prefs.remove("ClerkPassword");
      await prefs.remove("ClerkImage");
      await prefs.remove("ClerkManagementName");
      await prefs.remove("ClerkTypeName");
      await prefs.remove("ClerkRankName");
      await prefs.remove("ClerkCategoryName");
      await prefs.remove("ClerkCoreStrengthName");
      await prefs.remove("ClerkPresenceName");
      await prefs.remove("ClerkJobName");
      await prefs.remove("ClerkToken");

      showToast(
          message: "تم تسجيل الخروج بنجاح",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      navigateAndFinish(context, ClerkLoginScreen());
      emit(NewGroupLogOutUserState());
    }).catchError((error) {
      if (error is DioError) {
        emit(NewGroupLogOutErrorState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(NewGroupLogOutErrorState(error.toString()));
      }
    });
  }

  void navigateToCreateClerksGroup(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = ClerkFirebaseModel.encode(selectedClerksList);
    prefs.setString("selectedClerksModelList", encodedData);

    final String userModelString = prefs.getString('selectedClerksModelList')!;
    final List<ClerkFirebaseModel> clerkModelList =
        ClerkFirebaseModel.decode(userModelString);

    navigateTo(context, NewGroupScreen(selectedUsersList: selectedClerksList));
    print("Navigate Selected Clerks Model List ${selectedClerksList.length}\n");
    print("Clerks Model List Decoded ${clerkModelList.length}\n");
  }

  void navigateToGroupConversation(BuildContext context, String groupID,
      String groupName, String groupImage, String createdBy) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Object?> adminsList = [];
    adminsList.add(prefs.getString("ClerkID"));

    navigateTo(
        context,
        GroupConversationScreen(
          groupID: groupID,
          groupName: groupName,
          groupImage: groupImage,
          createdBy: createdBy,
          adminsList: adminsList,
          membersList: selectedClerksIDList,
          openedFrom: "Create",
        ));
  }

  void changeUserSelect() {
    isUserSelected = !isUserSelected;
    emit(NewGroupChangeUsersSelectState());
  }

  void addClerkToSelect(ClerkFirebaseModel clerkModel) {
    selectedClerksList.add(clerkModel);

    emit(NewGroupAddUsersSelectState());
  }

  void removeUserFromSelect(ClerkFirebaseModel clerkModel) {
    selectedClerksList.remove(clerkModel);
    emit(NewGroupRemoveUsersSelectState());
  }

  Future<void> getUsers() async {
    emit(NewGroupLoadingUsersState());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("${prefs.getString("ClerkID").toString()}\n");
    FirebaseFirestore.instance.collection("Clerks").where("ClerkID", isNotEqualTo: prefs.getString("ClerkID").toString()).snapshots().listen((event) {
      clerkList.clear();
      clerkSubscriptionsList = [];
      filteredClerkList.clear();
      clerkModel = null;
      for (var element in event.docs) {
        Map user = element.data();
        user["ClerkSubscriptions"].forEach((group) {
          clerkSubscriptionsList.add(group);
        });
        if (user["ClerkPhone"] != prefs.getString("ClerkID")) {
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

      //print("Clerks List Length Out : ${filteredClerkList.length}\n");

      emit(NewGroupGetUsersSuccessState());
    });
  }

  void startSearch(BuildContext context) {
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));

    isSearching = true;
    emit(NewGroupFilterUsersState());
  }

  void updateSearchQuery(String newQuery) {
    searchQuery = newQuery;
    filteredClerkList = clerkList
        .where((user) =>
            user.clerkName.toLowerCase().contains(newQuery.toString()))
        .toList();
    emit(NewGroupFilterUsersState());
  }

  void stopSearching() {
    clearSearchQuery();

    isSearching = false;
    emit(NewGroupFilterUsersState());
  }

  void clearSearchQuery() {
    searchController.clear();
    updateSearchQuery("");
    emit(NewGroupFilterUsersState());
  }

  void searchUser(String value) {
    filteredClerkList = clerkList
        .where(
            (user) => user.clerkName.toLowerCase().contains(value.toString()))
        .toList();
    print("${filteredClerkList.length}\n");
    emit(NewGroupFilterUsersState());
  }

  void selectImage() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    imageUrl = image!.path;

    emptyImage = false;

    emit(NewGroupChangeGroupImageState());
  }

  Future<void> createGroupList(BuildContext context, String groupName,
      String groupImage, String membersCount, String currentFullTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    groupID = currentFullTime;
    Map<String, dynamic> chatListMap = HashMap();
    chatListMap['GroupID'] = groupID;
    chatListMap['GroupName'] = groupName;
    chatListMap['GroupImageUrl'] = groupImage;
    chatListMap['MembersCount'] = membersCount;
    chatListMap['GroupLastMessage'] = "";
    chatListMap['GroupLastMessageType'] = "";
    chatListMap['GroupLastMessageTime'] = "";
    chatListMap['GroupLastMessageSenderID'] = "";
    chatListMap['GroupUnReadCount'] = "";
    chatListMap['GroupPartnerState'] = "";
    chatListMap['Admins'] = groupAdminsList;
    chatListMap['Members'] = selectedClerksIDList;
    chatListMap['TimeStamp'] = Timestamp.now();

    FirebaseFirestore.instance
        .collection("GroupList")
        .doc(prefs.getString("ClerkID"))
        .collection("Groups")
        .doc(groupID)
        .set(chatListMap)
        .then((value) {
      for (var value in selectedClerksIDList) {
        FirebaseFirestore.instance
            .collection("GroupList")
            .doc(value)
            .collection("Groups")
            .doc(groupID)
            .set(chatListMap);
      }
    });
  }

  Future<void> createGroup(BuildContext context, String groupName) async {
    emit(NewGroupLoadingCreateGroupState());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String clerkNumber = prefs.getString("ClerkNumber")!;
    final String clerkModelString = prefs.getString('selectedClerksModelList')!;
    final List<ClerkFirebaseModel> clerkModelList =
        ClerkFirebaseModel.decode(clerkModelString);

    selectedClerksIDList.clear();
    groupAdminsList.clear();
    groupAdminsList.add(clerkNumber);

    for (var clerkModel in clerkModelList) {
      selectedClerksIDList.add(clerkModel.clerkID!.toString());
    }

    print("Selected Clerks Model List Decoded ${clerkModelList.length}\n");
    print("Selected Clerks ID List Decoded ${selectedClerksIDList.length}\n");

    FirebaseFirestore db = FirebaseFirestore.instance;
    var groupRef = db.collection("Chats");
    var storageRef = FirebaseStorage.instance.ref("Chats");

    DateTime now = DateTime.now();
    String currentFullTime = DateFormat("yyyy-MM-dd-HH-mm-ss").format(now);

    Map<String, dynamic> dataMap = HashMap();

    dataMap['ChatType'] = "Group";
    dataMap['ChatName'] = groupName;
    dataMap['ChatID'] = currentFullTime;
    dataMap['createdBy'] = clerkNumber;
    dataMap['DateCreated'] = currentFullTime;
    dataMap['TimeStamp'] = Timestamp.now();
    dataMap['Admins'] = groupAdminsList;
    dataMap['Members'] = selectedClerksIDList;
    dataMap['ChatLastMessageSenderID'] = "";
    dataMap['ChatLastMessage'] = "";
    dataMap['ChatLastMessageTime'] = "";
    dataMap['ChatLastMessageType'] = "";
    dataMap['ChatImageUrl'] = "";
    dataMap['ChatUnReadCount'] = "";
    dataMap['ChatPartnerState'] = "";
    dataMap['MembersCount'] = (groupAdminsList + selectedClerksIDList).toString();
    dataMap['MembersAndAdmins'] = (groupAdminsList + selectedClerksIDList).toList();

    groupRef.doc(currentFullTime).set(dataMap).then((value) async {
      String fileName = imageUrl;

      File imageFile = File(fileName);
      var uploadTask = storageRef.child(currentFullTime).putFile(imageFile);
      await uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {
          dataMap['ChatImageUrl'] = value.toString();

          groupRef
              .doc(currentFullTime)
              .update(dataMap)
              .then((realtimeDbValue) async {
            navigateToGroupConversation(
                context, currentFullTime, groupName, value.toString(), clerkNumber);
            createGroupList(context, groupName, value.toString(),
                (selectedClerksIDList.length + 1).toString(), currentFullTime);
            /*clerkSubscriptionsList = [];
            clerkSubscriptionsList.add(currentFullTime);

            for (var element in selectedClerksIDList) {
              Map<int, Object?> map = clerkSubscriptionsList.asMap();
              Map<String, Object?> stringMap = <String, Object?>{};

              map.forEach((key, value) {
                stringMap.putIfAbsent(key.toString(), () => value);
              });

              FirebaseFirestore.instance
                  .collection("Clerks")
                  .doc(element)
                  .get()
                  .then((value) {
                Map data = value.data()!;
                data["ClerkSubscriptions"].forEach((group) {
                  print("GROUP : $group\n");
                  clerkSubscriptionsList.add(group);
                });
              });

              List<String> filtered =
                  LinkedHashSet<String>.from(clerkSubscriptionsList).toList();
              clerkSubscriptionsList.toSet().toList();
              Map<String, dynamic> updateMap = HashMap();
              updateMap["ClerkSubscriptions"] = filtered;

              FirebaseFirestore.instance
                  .collection("Clerks")
                  .doc(element)
                  .update(updateMap);

              for (var element in filtered) {
                await FirebaseMessaging.instance.subscribeToTopic(element);
              }
              print("Clerk List After Set : ${filtered.length}\n");
            }*/

            /*List<String> filtered =
            LinkedHashSet<String>.from(clerkSubscriptionsList).toList();
            for (var element in filtered) {
              FirebaseMessaging.instance.subscribeToTopic(element);
            }*/
            emit(NewGroupCreateGroupSuccessState());
          }).catchError((error) {
            emit(NewGroupCreateGroupErrorState(error.toString()));
          });
        });
      });
    });
  }
}
