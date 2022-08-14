import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:it_department/modules/GroupChat/details/screens/group_details_screen.dart';
import 'package:just_audio/just_audio.dart' as j;
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../../models/chat_model.dart';
import '../../../../models/group_chat_model.dart';
import '../../../../models/group_model.dart';
import '../../../../shared/components.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/gallery_item_model.dart';
import '../../../Chat/widget/page_manager.dart';
import '../screens/group_selected_images_screen.dart';
import 'group_conversation_states.dart';

class GroupConversationCubit extends Cubit<GroupConversationStates> {
  GroupConversationCubit() : super(GroupConversationInitialState());

  static GroupConversationCubit get(context) => BlocProvider.of(context);

  //********* RECORD UI ***********
  double opacity = 1.0;
  double dX = 0.0;
  double dY = 0.0;
  double recordButtonSize = 50;
  double limit = 150;
  bool recording = false;
  Color recordButtonMicColor = Colors.white;
  bool movable = false;
  bool lockedRecord = false;
  //*******************************

  String groupName = "";
  String groupID = "";
  String userID = "";
  String userName = "";
  String userPhone = "";
  String userPassword = "";
  String userNumber = "";
  String userManagementName = "";
  String userRankName = "";
  String userTypeName = "";
  String userCategoryName = "";
  String userJobName = "";
  String userCoreStrengthName = "";
  String userPresenceName = "";
  String userImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/mostaqbal-masr.appspot.com/o/Users%2Flogo.jpg?alt=media";
  String userToken = "";
  String imageUrl = "";
  String fileUrl = "";
  String downloadingFileName = "";
  String downloadingRecordName = "";
  String uploadingFileName = "";
  String uploadingRecordName = "";
  String uploadingImageName = "";
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
  Timer? timer;
  Timer? ampTimer;
  Amplitude? amplitude;
  Stream<QuerySnapshot>? documentStream;
  var audioRecorder = Record();
  final ImagePicker imagePicker = ImagePicker();
  List<XFile?>? messageImages = [];
  List<File?>? messageImagesFilesList = [];
  List<dynamic> messageImagesStringList = ["emptyList"];
  GalleryModel? galleryItemModel;
  List<GalleryModel> galleryItemModelList = [];
  List<dynamic>? imageFileList = [];
  String chatID = "";
  String receiverID = "";
  String receiverName = "";
  String receiverImage = "";
  String receiverToken = "";
  PageManager? pageManager;
  bool gotMembers = false;
  GroupModel? groupModel;
  GroupChatModel? chatModel;
  List<GroupModel> groupList = [];
  List<GroupChatModel> chatList = [];
  List<GroupChatModel> chatListReversed = [];
  List<GroupChatModel> chatListTempReversed = [];
  List<Object?> groupMembersList = [];
  List<Object?> groupMembersNameList = [];
  List<Object?> groupAdminsList = [];
  List<Object?> groupAdminsNameList = [];
  List<XFile?> emptyList = [];
  List<GalleryModel> galleryItems = <GalleryModel>[];
  GroupChatImagesModel? chatImagesModel;
  List<GroupChatImagesModel> chatImagesList = [];

  //***********************************************
  String draggableRecord = "" ;
  double padding = 0.0 ;
  double startpoint = 0.01 ;
  bool drag = true;
  double replyLimit = 200;

  //***********************************************
  void setDraggableRecord(String messageID){
    draggableRecord = messageID;
    emit(GroupConversationUpdateDraggableRecordState());
  }
  void updateDragPaddingAndBoolValues(double newPadding, bool newDragValue){
    padding = newPadding;
    drag = newDragValue;
    emit(GroupConversationUpdatePaddingAndDragState());
  }
  void updateDragPaddingValue(double newPadding){
    padding = newPadding;
    emit(GroupConversationUpdatePaddingState());
  }

  void initPageManager(){
    pageManager = PageManager();
  }
  changeOpacity() {
    if(lockedRecord){
      Future.delayed(const Duration(milliseconds: 1500), () {
        opacity = opacity == 0.0 ? 1.0 : 0.0;
        changeOpacity();
      });
      emit(GroupConversationChangeOpacity());
    }
  }
  void sendRecord() {
    recording = false;
    lockedRecord = false;
    stopRecord(groupID);
    emit(GroupConversationEndRecord());
  }

  void deleteRecord() {
    recording = false;
    lockedRecord = false;
    timer?.cancel();
    emit(GroupConversationEndRecord());
  }

  onLongPressStart(details) {
    startRecord();
  }
  onLongPressUpdating(LongPressMoveUpdateDetails details) {
    if (recording && details.offsetFromOrigin.dx <= 0 && dY <= 7) {
      if (movable && details.offsetFromOrigin.dx > -limit) {
        dX = details.offsetFromOrigin.dx * -1;
        dY = 0;
        emit(GroupConversationChangeButtonPosition());
      } else {
        deleteRecord();
        recordButtonSize = 50;
        recordButtonMicColor = Colors.white;
        recording = false;
        dX = 0;
        dY = 0;
        movable = false;
        emit(GroupConversationChangeButtonPosition());
      }
    }
    if (recording && details.offsetFromOrigin.dy <= 0 && dX <= 7) {
      if (movable && details.offsetFromOrigin.dy > -limit) {
        dY = details.offsetFromOrigin.dy * -1;
        dX = 0;
        emit(GroupConversationChangeButtonPosition());
      } else {
        lockedRecord = true;
        recordButtonSize = 50;
        recordButtonMicColor = Colors.white;
        dX = 0;
        dY = 0;
        movable = false;
        emit(GroupConversationChangeButtonPosition());
      }
    }
  }

  onLongPressEnd(details) {
    if (!lockedRecord && dY < (limit - (recordButtonSize / 2))) {
      if (dX >= (limit - (recordButtonSize / 2))) {
        deleteRecord();
        recording = false;
        emit(GroupConversationEndRecord());
      } else if (recording) {
        sendRecord();
        recording = false;
        emit(GroupConversationEndRecord());
      }
    } else {
      lockedRecord = true;
      emit(GroupConversationEndRecord());
    }
    movable = false;
    recordButtonSize = 50;
    recordButtonMicColor = Colors.white;
    dX = 0;
    dY = 0;
    emit(GroupConversationEndRecord());
  }
  void navigateToDetails(BuildContext context,String groupID,  String groupName, String groupImage, String createdBy, List<Object?> membersList, List<Object?> adminsList, List<GroupChatModel> chatList){
    Navigator.push(
        context,
        ScaleTransition1(
            page: GroupDetailsScreen(groupID: groupID, groupName: groupName , groupImage: groupImage, createdBy: createdBy, membersList: membersList, adminsList: adminsList, chatList: chatList,),
            startDuration: const Duration(milliseconds: 1000),
            closeDuration: const Duration(milliseconds: 400),
            type: ScaleTrasitionTypes.center));
  }

  void getUserData(String groupName, String groupID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.groupName = groupName;
    this.groupID = groupID;
    userID = prefs.getString("ClerkID")!;
    userName = prefs.getString("ClerkName")!;
    userPhone = prefs.getString("ClerkPhone")!;
    userNumber = prefs.getString("ClerkNumber")!;
    userPassword = prefs.getString("ClerkPassword")!;
    userManagementName = prefs.getString("ClerkManagementName")!;
    userTypeName = prefs.getString("ClerkTypeName")!;
    userRankName = prefs.getString("ClerkRankName")!;
    userCategoryName = prefs.getString("ClerkCategoryName")!;
    userCoreStrengthName = prefs.getString("ClerkCoreStrengthName")!;
    userPresenceName = prefs.getString("ClerkPresenceName")!;
    userJobName = prefs.getString("ClerkJobName")!;
    userToken = prefs.getString("ClerkToken")!;
    userImageUrl = prefs.getString("ClerkImage")!;
  }

  void changeUserState(String state) async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    database
        .reference()
        .child("Clerks")
        .child(userID)
        .child("ClerkState")
        .set(state)
        .then((value) {
      emit(GroupConversationChangeUserTypeState());
    });
  }

  void sendNotification(
      String message, String notificationID, String groupID,String senderName) async {
    var serverKey =
        'AAAAnuydfc0:APA91bF3jkS5-JWRVnTk3mEBnj2WI70EYJ1zC7Q7TAI6GWlCPTd37SiEkhuRZMa8Uhu9HTZQi1oiCEQ2iKQgxljSyLtWTAxN4HoB3pyfTuyNQLjXtf58s99nAEivs2L6NzEL0laSykTK';

    for (var element in groupMembersList){ 
      
      if(element.toString() != userID){
        
        var token = await FirebaseDatabase.instance.reference().child("Clerks").child(element.toString()).child("ClerkToken").get();
        print("Token : ${token.value.toString()}\n");
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': message,
                'title': senderName
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': Random().nextInt(100),
                'status': 'done'
              },
              'to': token.value.toString(),
            },
          ),
        );
      }
    }
  }

  void sendFireStoreMessage(String groupID, String message,
      String type, bool isSeen, TextEditingController messageController) async {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);


    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    var chatListRef = FirebaseFirestore.instance.collection("GroupList").doc(userID).collection("Groups").doc(groupID);
   // var chatListTwoRef = FirebaseFirestore.instance.collection("GroupList").doc(receiverID).collection("Chats").doc(userID);

    messageControllerValue.value = "";
    messageController.clear();

    Map<String, dynamic> dataMap = HashMap();
    dataMap['SenderID'] = userID;
    dataMap['SenderName'] = userName;
    dataMap['SenderImage'] = userImageUrl;
    dataMap['GroupID'] = groupID;
    dataMap['Message'] = message;
    dataMap['type'] = type;
    dataMap["isSeen"] = isSeen;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = ["emptyList"];
    dataMap["fileName"] = "";
    dataMap["hasImages"] = false;
    dataMap["createdAt"] = Timestamp.now();
    dataMap["imagesCount"] = 0;
    dataMap["recordDuration"] = "0";
    dataMap["fileSize"] = "0 KB";

    Map<String, dynamic> chatListMap = HashMap();
    chatListMap['ChatLastMessage'] = message;
    chatListMap['ChatLastMessageType'] = type;
    chatListMap['ChatLastMessageTime'] = currentTime;
    chatListMap['ChatLastMessageSenderID'] = userID;chatListMap['ChatLastMessageSenderName'] = userName;
    chatListMap["TimeStamp"] = Timestamp.now();


    FirebaseFirestore.instance
        .collection("Chats")
        .doc(groupID)
        .collection("Messages")
        .doc(currentFullTime)
        .set(dataMap)
        .then((value) async {

      sendNotification(message, currentTime, groupID, userName);
      FirebaseFirestore.instance
      .collection("Chats")
      .doc(groupID)
      .update(chatListMap);
      emit(GroupConversationSendMessageState());
    });
  }
  void selectImages(
      BuildContext context, String groupID) async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    imageFileList = [];

    if (selectedImages!.isNotEmpty) {
      for (var element in selectedImages) {
        imageFileList!.add(element.path);
      }
      messageImagesStaticList = imageFileList!;
      navigateTo(
          context, GroupSelectedImagesScreen(
        chatImages: imageFileList,
        groupID: groupID,
        groupName: groupName,
      ));
      emit(GroupConversationSelectImagesState());
    }
  }

  void selectFile(String groupID) async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);

      if (result != null) {
        sendFireStoreFileMessage(groupID, false, result);
      } else {
        // User canceled the picker
      }
      emit(GroupConversationSelectFilesState());
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      emit(GroupConversationPermissionDeniedState());
    }
  }

  Future<void> sendFireStoreFileMessage(String groupID,
      bool isSeen, FilePickerResult file) async {
    emit(GroupConversationUploadingFileState(file.files.first.name));

    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    var storageRef = FirebaseStorage.instance.ref("Chats").child(groupID).child("Documents");
    var ref = FirebaseFirestore.instance.collection("Chats").doc(groupID).collection("Messages");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    Map<String, dynamic> dataMap = HashMap();
    dataMap['SenderID'] = userID;
    dataMap['SenderName'] = userName;
    dataMap['SenderImage'] = userImageUrl;
    dataMap['GroupID'] = groupID;
    dataMap['Message'] = "";
    dataMap['type'] = "file";
    dataMap["isSeen"] = isSeen;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = ["emptyList"];
    dataMap["fileName"] = file.files.first.name;
    dataMap["hasImages"] = false;
    dataMap["createdAt"] = Timestamp.now();
    dataMap["imagesCount"] = 0;
    dataMap["recordDuration"] = "0";


    Map<String, dynamic> chatListMap = HashMap();
    chatListMap['ChatLastMessage'] = file.files.first.name;
    chatListMap['ChatLastMessageType'] = "file";
    chatListMap['ChatLastMessageTime'] = currentTime;
    chatListMap['ChatLastMessageSenderID'] = userID;chatListMap['ChatLastMessageSenderName'] = userName;
    chatListMap["TimeStamp"] = Timestamp.now();

    if(file.files.first.size > 1000000){
      dataMap["fileSize"] = "${(file.files.first.size * 0.000001).toStringAsFixed(2)} MB";
    }else {
      dataMap["fileSize"] = "${(file.files.first.size * 0.001).toStringAsFixed(2)} KB";
    }

    ref.doc(currentFullTime).set(dataMap).then((value) async {
      uploadingFileName = currentFullTime;
      String fileName = file.files.first.path.toString();

      File imageFile = File(fileName);

      var uploadTask = storageRef.child(file.files.first.name).putFile(imageFile);
      await uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {

          dataMap['Message'] = value.toString();

          ref.doc(currentFullTime).update(dataMap).then((value){
            FirebaseFirestore.instance
                .collection("Chats")
                .doc(groupID)
                .update(chatListMap);
            uploadingFileName = "";
            emit(GroupConversationSendFilesSuccessState());
          }).catchError((error){
            print("UPLOAD ERROR : $error\n");
            uploadingFileName = "";
            emit(GroupConversationSendFilesErrorState(error.toString()));
          });
        }).catchError((error) {
          print("UPLOAD ERROR : $error\n");
          uploadingFileName = "";
          emit(GroupConversationSendFilesErrorState(error.toString()));
        });
      }).catchError((error) {
        print("UPLOAD ERROR : $error\n");
        uploadingFileName = "";
        emit(GroupConversationSendFilesErrorState(error.toString()));
      });
    }).catchError((error) {
      print("UPLOAD ERROR : $error\n");
      uploadingFileName = "";
      emit(GroupConversationSendFilesErrorState(error.toString()));
    });
  }

  Future<void> uploadMultipleImagesFireStore(BuildContext context, String message, String groupID, String messageType) async{
    emit(GroupConversationUploadingImagesState(message));
    DateTime now = DateTime.now();
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
    String currentTime = DateFormat("hh:mm a").format(now);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    var storageRef = FirebaseStorage.instance.ref("Chats").child(groupID).child("Images").child(currentFullTime);
    var ref = FirebaseFirestore.instance.collection("Chats").doc(groupID).collection("Messages").doc(currentFullTime);

    List<String> urlsList = [];

    Map<String, dynamic> dataMap = HashMap();
    dataMap['SenderID'] = userID;
    dataMap['SenderName'] = userName;
    dataMap['SenderImage'] = userImageUrl;
    dataMap['GroupID'] = groupID;
    dataMap['Message'] = message;
    dataMap['type'] = messageType;
    dataMap["isSeen"] = false;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = ["emptyList"];
    dataMap["fileName"] = "";
    dataMap["hasImages"] = true;
    dataMap["createdAt"] = Timestamp.now();
    dataMap["imagesCount"] = messageImagesStaticList!.length;
    dataMap["recordDuration"] = "0";
    dataMap["fileSize"] = "0 KB";


    for (int i = 0; i < messageImagesStaticList!.length; i++) {
      ref.set(dataMap).then((value) async {
        uploadingImageName = currentFullTime;
        String fileName = messageImagesStaticList![i].toString();
        uploadingImagesMessageID = currentFullTime;
        imagesUploaded = false;

        File imageFile = File(fileName);

        var uploadTask = storageRef.child(fileName).putFile(imageFile);
        await uploadTask.then((p0) {
          p0.ref.getDownloadURL().then((value) {
            urlsList.add(value.toString());

            dataMap["messageImages"] = urlsList;
            dataMap['fileName'] = urlsList[0].toString();

            ref.update(dataMap).then((value){
              messageImagesStaticList = [];
              uploadingImageName = "";

              Map<String, dynamic> chatListMap = HashMap();
              chatListMap['ChatLastMessage'] = message;
              chatListMap['ChatLastMessageType'] = messageType;
              chatListMap['ChatLastMessageTime'] = currentTime;
              chatListMap['ChatLastMessageSenderID'] = userID;chatListMap['ChatLastMessageSenderName'] = userName;
              chatListMap["TimeStamp"] = Timestamp.now();

              FirebaseFirestore.instance
                  .collection("Chats")
                  .doc(groupID)
                  .update(chatListMap);
              emit(GroupConversationSendImagesSuccessState());
            }).catchError((error){
              print("UPLOAD ERROR : $error\n");
              uploadingImageName = "";
              emit(GroupConversationSendImagesErrorState(error.toString()));
            });
          }).catchError((error) {
            print("UPLOAD ERROR : $error\n");
            uploadingImageName = "";
            emit(GroupConversationSendImagesErrorState(error.toString()));
          });
        }).catchError((error) {
          print("UPLOAD ERROR : $error\n");
          uploadingImageName = "";
          emit(GroupConversationSendImagesErrorState(error.toString()));
        });
      }).catchError((error) {
        print("UPLOAD ERROR : $error\n");
        uploadingImageName = "";
        emit(GroupConversationSendImagesErrorState(error.toString()));
      });
    }
  }
  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }
    return numberStr;
  }

  Future<void> sendAudioMessage(
      String groupID, String type, bool isSeen, File file) async {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    var storageRef = FirebaseStorage.instance.ref("Chats").child(groupID).child("Records").child(audioPathStore);
    var ref = FirebaseFirestore.instance.collection("Chats").doc(groupID).collection("Messages");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    File audioFile = File(file.path.toString());
    final String minutes = _formatNumber(recordDuration ~/ 60);
    final String seconds = _formatNumber(recordDuration % 60);

    Map<String, dynamic> dataMap = HashMap();
    dataMap['SenderID'] = userID;
    dataMap['SenderName'] = userName;
    dataMap['SenderImage'] = userImageUrl;
    dataMap['GroupID'] = groupID;
    dataMap['Message'] = "";
    dataMap['type'] = "audio";
    dataMap["isSeen"] = false;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = ["emptyList"];
    dataMap["fileName"] = audioPathStore;
    dataMap["hasImages"] = false;
    dataMap["createdAt"] = Timestamp.now();
    dataMap["imagesCount"] = 0;
    dataMap["recordDuration"] = "$minutes : $seconds";

    if(audioFile.lengthSync() > 1000000){
      dataMap["fileSize"] = "${(audioFile.lengthSync() * 0.000001).toStringAsFixed(2)} MB";
    }else {
      dataMap["fileSize"] = "${(audioFile.lengthSync() * 0.001).toStringAsFixed(2)} KB";
    }
    Map<String, dynamic> chatListMap = HashMap();
    chatListMap['ChatLastMessage'] = "ملف صوتى";
    chatListMap['ChatLastMessageType'] = "audio";
    chatListMap['ChatLastMessageTime'] = currentTime;
    chatListMap['ChatLastMessageSenderID'] = userID;
    chatListMap['ChatLastMessageSenderName'] = userName;
    chatListMap["TimeStamp"] = Timestamp.now();

    ref.doc(currentFullTime).set(dataMap).then((value) async {
      uploadingRecordName = currentFullTime;

      var uploadTask = storageRef.putFile(audioFile);
      await uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {

          dataMap['Message'] = value.toString();

          ref.doc(currentFullTime).update(dataMap).then((value)async {
            uploadingRecordName = "";
            FirebaseFirestore.instance
                .collection("Chats")
                .doc(groupID)
                .update(chatListMap);
            emit(GroupConversationSendFilesSuccessState());
          }).catchError((error){
            print("UPLOAD ERROR : $error\n");
            uploadingRecordName = "";
            emit(GroupConversationSendFilesErrorState(error.toString()));
          });
        }).catchError((error) {
          print("UPLOAD ERROR : $error\n");
          uploadingRecordName = "";
          emit(GroupConversationSendFilesErrorState(error.toString()));
        });
      }).catchError((error) {
        print("UPLOAD ERROR : $error\n");
        uploadingRecordName = "";
        emit(GroupConversationSendFilesErrorState(error.toString()));
      });
    }).catchError((error) {
      print("UPLOAD ERROR : $error\n");
      uploadingRecordName = "";
      emit(GroupConversationSendFilesErrorState(error.toString()));
    });
  }

  Future<void> getGroupMembers(String groupID) async {
    emit(GroupConversationLoadingMembersState());

    gotMembers = false;
    FirebaseFirestore.instance
        .collection('Chats')
        .doc(groupID)
        .get()
        .then((event) async {
      groupList.clear();
      groupMembersList = [];
      groupModel = null;

      if (event.data() != null) {
        Map data = event.data()!;
        if (data.isNotEmpty) {
          print('Members Data : ${data["Members"]}\n');
          groupMembersList = data["Members"];
        }
        groupMembersNameList = [];

        for (var element in data["Members"])  {
          await FirebaseFirestore.instance
              .collection('Clerks')
              .doc(element.toString())
              .get().then((value) {
               Map data = value.data()!;
            groupMembersNameList.add(data["ClerkName"].toString());
          });
        }
      }
      gotMembers = true;
      print("MEMBERS COUNT : ${groupMembersList.length}\n");
      emit(GroupConversationGetGroupMembersSuccessState());
    });
    FirebaseFirestore.instance
        .collection('Chats')
        .doc(groupID)
        .get()
        .then((event) async {
      groupList.clear();
      groupAdminsList = [];
      groupModel = null;

      if (event.data() != null) {
        Map data = event.data()!;
        if (data.isNotEmpty) {
          print('Admins Data : ${data["Admins"]}\n');
          groupAdminsList = data["Admins"];
        }
        groupAdminsNameList = [];

        for (var element in data["Admins"])  {
          await FirebaseFirestore.instance
              .collection('Clerks')
              .doc(element.toString())
              .get().then((value) {
            Map data = value.data()!;
            groupAdminsNameList.add(data["ClerkName"].toString());
          });
        }
      }
      gotMembers = true;
      emit(GroupConversationGetGroupMembersSuccessState());
    });
  }

  void getFireStoreMessage(String groupID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    FirebaseFirestore.instance
        .collection("Chats")
        .doc(groupID)
        .collection("Messages")
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((event) async {
      chatList.clear();
      chatImagesList.clear();
      chatListReversed.clear();
      messageImages!.clear();
      messageImagesStringList.clear();
      chatModel = null;
      chatImagesModel = null;
      galleryItemModel = null;

      for (var element in event.docs) {
        Map data = element.data();
        chatImagesModel = GroupChatImagesModel(data["messageFullTime"], (data["messageImages"] as List));
        chatImagesList.add(chatImagesModel!);

        chatModel = GroupChatModel(
            data["SenderName"],
            data["SenderImage"],
            data["GroupID"],
            data["SenderID"],
            data["Message"],
            data["messageTime"],
            data["messageFullTime"],
            data["createdAt"],
            data["type"],
            data["imagesCount"],
            data["recordDuration"],
            data["fileSize"],
            data["fileName"],
            data["isSeen"],
            data["hasImages"],
            messageImagesStringList,
            chatImagesModel);

        chatList.add(chatModel!);
        chatListReversed = chatList.reversed.toList();
        emit(GroupConversationGetMessageSuccessState());
      }
    });
  }

  Future<void> downloadDocumentFile(
      String fileName, String groupName, String groupID) async {
    emit(GroupConversationLoadingDownloadFileState(fileName));
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
        emit(GroupConversationDownloadFileSuccessState());
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
      emit(GroupConversationPermissionDeniedState());
    }
  }

  Future<void> downloadAudioFile(
      String fileName,String senderName,String groupName, String groupID, int index) async {
    emit(GroupConversationLoadingDownloadFileState(fileName));
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
        emit(GroupConversationDownloadFileSuccessState());
        chatMicrophoneOnTapAction(index, fileName);
      } on FirebaseException catch (e) {
        downloadingRecordName = "";
        emit(GroupConversationDownloadFileErrorState(e.message.toString()));
      }
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingRecordName = "";
      emit(GroupConversationPermissionDeniedState());
    }
  }

  Future<void> downloadImageFile(
      String fileName, String senderID,String senderName, String groupName, String groupID) async {
    emit(GroupConversationLoadingDownloadFileState(fileName));
    downloadingFileName = fileName;

    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      File downloadToFile =
          File('$path/IT Department/$groupName/Images/$fileName');
      try {
        await FirebaseStorage.instance
            .ref('Chats/$groupID/Images/$fileName')
            .writeToFile(downloadToFile);
        downloadingFileName = "";
        emit(GroupConversationDownloadFileSuccessState());
      } on FirebaseException catch (e) {
        downloadingFileName = "";
        emit(GroupConversationDownloadFileErrorState(e.message.toString()));
      }
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingFileName = "";
      emit(GroupConversationPermissionDeniedState());
    }
  }

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

  bool checkForImageFile(String fileName, String groupName) {
    bool isFileExist = File(
        "/storage/emulated/0/Download/IT Department/$groupName/Images/$fileName")
        .existsSync();

    if(!isFileExist){
      downloadImageFile(fileName, userID, userName, groupName, groupID);
    }

    return isFileExist;
  }

  Future<void> createUserDocumentsDirectory() async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory recordingsDirectory =
          Directory('$externalDoc/IT Department/$groupName/Documents/');

      if (await recordingsDirectory.exists()) {
        //if folder already exists return path

        emit(GroupConversationCreateDirectoryState());
      } else {
        //if folder not exists create folder and then return its path
        await recordingsDirectory.create(recursive: true);

        emit(GroupConversationCreateDirectoryState());
      }
    } else {
      emit(GroupConversationPermissionDeniedState());
    }
  }

  Future<void> createUserRecordingsDirectory() async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory recordingsDirectory =
          Directory('$externalDoc/IT Department/$groupName/Records/');

      if (await recordingsDirectory.exists()) {
        //if folder already exists return path

        emit(GroupConversationCreateDirectoryState());
      } else {
        //if folder not exists create folder and then return its path
        await recordingsDirectory.create(recursive: true);

        emit(GroupConversationCreateDirectoryState());
      }
    } else {
      emit(GroupConversationPermissionDeniedState());
    }
  }

  Future<void> createUserImagesDirectory() async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory imagesDirectory =
          Directory('$externalDoc/IT Department/$groupName/Images/');

      if (await imagesDirectory.exists()) {
        //if folder already exists return path

        emit(GroupConversationCreateDirectoryState());
      } else {
        //if folder not exists create folder and then return its path
        await imagesDirectory.create(recursive: true);

        emit(GroupConversationCreateDirectoryState());
      }
    } else {
      emit(GroupConversationPermissionDeniedState());
    }
  }

  void startRecord()async {
    lockedRecord = false;
    movable = true;
    recordButtonSize = 80;
    recordButtonMicColor = Colors.white;
    recording = true;
    var status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      audioRecorder = Record();
      String currentFullTime = DateFormat("yyyy-MM-dd-HH-mm-ss").format(DateTime.now());
      String extension = ".m4a";
      await createUserRecordingsDirectory();
      audioPath = "/storage/emulated/0/Download/IT Department/$groupName/Records/${currentFullTime.trim().toString()}-audio$extension";
      audioPathStore = "${currentFullTime.trim().toString()}-audio$extension";
      await audioRecorder.start(
          path: audioPath,
          bitRate: 16000,
          samplingRate: 16000,
          encoder: AudioEncoder.AAC);
      bool recording = await audioRecorder.isRecording();
      isRecording = recording;
      recordDuration = 0;
      startedRecordValue.value = true;
      startTimer();
      emit(GroupConversationStartRecordSuccessState());
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      emit(GroupConversationPermissionDeniedState());
    }
  }

  Future recordAudio() async {
    var status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      audioRecorder = Record();
      String currentFullTime = DateFormat("yyyy-MM-dd-HH-mm-ss").format(DateTime.now());
      String extension = ".m4a";
      await createUserRecordingsDirectory();
      audioPath = "/storage/emulated/0/Download/IT Department/$groupName/Records/${currentFullTime.trim().toString()}-audio$extension";
      audioPathStore = "${currentFullTime.trim().toString()}-audio$extension";
      await audioRecorder.start(
          path: audioPath,
          bitRate: 16000,
          samplingRate: 16000,
          encoder: AudioEncoder.AAC);
      bool recording = await audioRecorder.isRecording();
      isRecording = recording;
      recordDuration = 0;
      startedRecordValue.value = true;
      startTimer();
      emit(GroupConversationStartRecordSuccessState());
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      emit(GroupConversationPermissionDeniedState());
    }
  }

  Future stopRecord(String groupID) async {
    timer?.cancel();
    ampTimer?.cancel();
    isRecording = false;
    startedRecordValue.value = false;
    await audioRecorder.stop();
    await sendAudioMessage(groupID, "Audio", false, File(audioPath));
    audioPath = "";
    audioPathStore = "";
    emit(GroupConversationStopRecordSuccessState());
  }

  Future cancelRecord() async {
    timer?.cancel();
    ampTimer?.cancel();
    isRecording = false;
    startedRecordValue.value = false;
    await audioRecorder.stop();
    File(audioPath).deleteSync();
    audioPath = "";
    audioPathStore = "";
    emit(GroupConversationCancelRecordSuccessState());
  }

  Future toggleRecording(String groupID) async {
    if (!isRecording) {
      await recordAudio();
    } else {
      await stopRecord(groupID);
    }
    emit(GroupConversationToggleRecordSuccessState());
  }

  void changeRecordingState() async {
    isRecording = false;
    startedRecordValue.value = false;
    emit(GroupConversationChangeRecordingState());
  }

  void startTimer() {
    timer?.cancel();
    ampTimer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      recordDuration++;
      emit(GroupConversationIncreaseTimerSuccessState());
    });
  }

  void initRecorder() async {
    isRecording = false;
    emit(GroupConversationInitializeRecordSuccessState());
  }

  void chatMicrophoneOnTapAction(int index, String fileName) async {
    try {
      justAudioPlayer.positionStream.listen((event) {
        currAudioPlayingTime = event.inMicroseconds.ceilToDouble();
        loadingTime =
        '${event.inMinutes} : ${event.inSeconds > 59 ? event.inSeconds % 60 : event.inSeconds}';
        emit(GroupConversationChangeRecordPositionState());
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
      emit(GroupConversationPlayRecordSuccessState());
    } catch (e) {
      print('Audio Playing Error');
      showToast(
          message: 'May be Audio File Not Found',
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
    }
  }

  void chatMicrophoneOnLongPressAction() async {
    if (justAudioPlayer.playing) {
      await justAudioPlayer.stop();

      print('Audio Play Completed');
      justAudioPlayer.stop();
      loadingTime = '0:00';
      iconData = Icons.play_arrow_rounded;
      lastAudioPlayingIndex = -1;
    }
    emit(GroupConversationStopRecordSuccessState());
  }
}
