import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
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
import 'package:it_department/modules/Chat/widget/page_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/chat_model.dart';
import '../../../../shared/components.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/gallery_item_model.dart';
import '../screens/selected_images_screen.dart';
import 'conversation_states.dart';

class ConversationCubit extends Cubit<ConversationStates> {
  ConversationCubit() : super(ConversationInitialState());

  static ConversationCubit get(context) => BlocProvider.of(context);

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

  String userID = "";
  String userName = "";
  String userPhone = "";
  String userPassword = "";
  String userDocType = "";
  String userDocNumber = "";
  String userCity = "";
  String userRegion = "";
  String userImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/mostaqbal-masr.appspot.com/o/Users%2Flogo.jpg?alt=media";
  String userToken = "";
  bool isImageOnly = false;
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
  ChatModel? chatModel;
  ChatImagesModel? chatImagesModel;
  List<ChatImagesModel> chatImagesList = [];
  List<ChatModel> chatList = [];
  List<ChatModel> chatListReversed = [];
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

  void initPageManager(){
  pageManager = PageManager();
  }

  void getChatData(String userID, String userName, String userImage, String userToken, String chat){
    receiverID = userID;
    receiverName = userName;
    receiverImage = userImage;
    receiverToken = userToken;
    chatID = chat;
  }

  changeOpacity() {
    if(lockedRecord){
      Future.delayed(const Duration(milliseconds: 1500), () {
        opacity = opacity == 0.0 ? 1.0 : 0.0;
        changeOpacity();
      });
      emit(ConversationChangeOpacity());
    }
  }

  void sendRecord() {
    recording = false;
    lockedRecord = false;
    stopRecord(receiverID, chatID);
    emit(ConversationEndRecord());
  }

  void deleteRecord() {
    recording = false;
    lockedRecord = false;
    timer?.cancel();
    emit(ConversationEndRecord());
  }

  onLongPressStart(details) {
    startRecord();
  }
  onLongPressUpdating(LongPressMoveUpdateDetails details) {
    if (recording && details.offsetFromOrigin.dx <= 0 && dY <= 7) {
      if (movable && details.offsetFromOrigin.dx > -limit) {
          dX = details.offsetFromOrigin.dx * -1;
          dY = 0;
          emit(ConversationChangeButtonPosition());
      } else {
        deleteRecord();
          recordButtonSize = 50;
          recordButtonMicColor = Colors.white;
          recording = false;
          dX = 0;
          dY = 0;
          movable = false;
        emit(ConversationChangeButtonPosition());
      }
    }
    if (recording && details.offsetFromOrigin.dy <= 0 && dX <= 7) {
      if (movable && details.offsetFromOrigin.dy > -limit) {
          dY = details.offsetFromOrigin.dy * -1;
          dX = 0;
          emit(ConversationChangeButtonPosition());
      } else {
          lockedRecord = true;
          recordButtonSize = 50;
          recordButtonMicColor = Colors.white;
          dX = 0;
          dY = 0;
          movable = false;
          emit(ConversationChangeButtonPosition());
      }
    }
  }

  onLongPressEnd(details) {
    if (!lockedRecord && dY < (limit - (recordButtonSize / 2))) {
      if (dX >= (limit - (recordButtonSize / 2))) {
        deleteRecord();
        recording = false;
        emit(ConversationEndRecord());
      } else if (recording) {
        sendRecord();
          recording = false;
        emit(ConversationEndRecord());
      }
    } else {
        lockedRecord = true;
        emit(ConversationEndRecord());
    }
      movable = false;
      recordButtonSize = 50;
      recordButtonMicColor = Colors.white;
      dX = 0;
      dY = 0;
      emit(ConversationEndRecord());
  }

  void navigate(BuildContext context, route) {
    navigateTo(context, route);
  }

  void sendNotification(
      String message, String notificationID, String receiverToken) async {
    var serverKey =
        'AAAAnuydfc0:APA91bF3jkS5-JWRVnTk3mEBnj2WI70EYJ1zC7Q7TAI6GWlCPTd37SiEkhuRZMa8Uhu9HTZQi1oiCEQ2iKQgxljSyLtWTAxN4HoB3pyfTuyNQLjXtf58s99nAEivs2L6NzEL0laSykTK';

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
            'title': 'لديك رسالة جديدة'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': Random().nextInt(100),
            'status': 'done'
          },
          'to': receiverToken,
        },
      ),
    );
  }

  void sendFireStoreMessage(String receiverID, String chatID, String message,
      String type, bool isSeen, String userToken, TextEditingController messageController) async {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    var chatListRef = FirebaseFirestore.instance.collection("ChatList").doc(userID).collection("Chats").doc(receiverID);
    var chatListTwoRef = FirebaseFirestore.instance.collection("ChatList").doc(receiverID).collection("Chats").doc(userID);

    messageControllerValue.value = "";
    messageController.clear();

    Map<String, dynamic> dataMap = HashMap();
    dataMap['SenderID'] = prefs.getString('ClerkID');
    dataMap['ReceiverID'] = receiverID;
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
    chatListMap['ReceiverID'] = receiverID;
    chatListMap['ReceiverName'] = receiverName;
    chatListMap['ReceiverImage'] = receiverImage;
    chatListMap['ReceiverToken'] = receiverToken;
    chatListMap['LastMessage'] = message;
    chatListMap['LastMessageType'] = type;
    chatListMap['LastMessageTime'] = currentTime;
    chatListMap['LastMessageSender'] = prefs.getString('ClerkID');
    chatListMap["TimeStamp"] = Timestamp.now();

    FirebaseFirestore.instance
        .collection("Chats")
        .doc(chatID)
        .collection("Messages")
        .doc(currentFullTime)
        .set(dataMap)
        .then((value) async {
      chatListRef.update(chatListMap);
      chatListTwoRef.update(chatListMap);
      sendNotification(message, currentTime, userToken);
      emit(ConversationSendMessageState());
    });
  }

  Future<void> sendFireStoreFileMessage(String receiverID,
      bool isSeen, FilePickerResult file, String chatID) async {
    emit(ConversationUploadingFileState(file.files.first.name));

    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    var storageRef = FirebaseStorage.instance.ref("Chats").child(chatID).child("Documents");
    var ref = FirebaseFirestore.instance.collection("Chats").doc(chatID).collection("Messages");
    var chatListRef = FirebaseFirestore.instance.collection("ChatList").doc(userID).collection("Chats").doc(receiverID);
    var chatListTwoRef = FirebaseFirestore.instance.collection("ChatList").doc(receiverID).collection("Chats").doc(userID);

    Map<String, dynamic> dataMap = HashMap();
    dataMap['SenderID'] = prefs.getString('ClerkID');
    dataMap['ReceiverID'] = receiverID;
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

    if(file.files.first.size > 1000000){
      dataMap["fileSize"] = "${(file.files.first.size * 0.000001).toStringAsFixed(2)} MB";
    }else {
      dataMap["fileSize"] = "${(file.files.first.size * 0.001).toStringAsFixed(2)} KB";
    }

    Map<String, dynamic> chatListMap = HashMap();
    chatListMap['ReceiverID'] = receiverID;
    chatListMap['ReceiverName'] = receiverName;
    chatListMap['ReceiverImage'] = receiverImage;
    chatListMap['ReceiverToken'] = receiverToken;
    chatListMap['LastMessage'] = file.files.last;
    chatListMap['LastMessageType'] = "file";
    chatListMap['LastMessageTime'] = currentTime;
    chatListMap['LastMessageSender'] = userID;
    chatListMap["TimeStamp"] = Timestamp.now();

      ref.doc(currentFullTime).set(dataMap).then((value) async {
        uploadingFileName = currentFullTime;
        String fileName = file.files.first.path.toString();

        File imageFile = File(fileName);

        var uploadTask = storageRef.child(file.files.first.name).putFile(imageFile);
        await uploadTask.then((p0) {
          p0.ref.getDownloadURL().then((value) {

            dataMap['Message'] = value.toString();

            ref.doc(currentFullTime).update(dataMap).then((value){
              chatListRef.update(chatListMap);
              chatListTwoRef.update(chatListMap);
              uploadingFileName = "";
              emit(ConversationSendFilesSuccessState());
            }).catchError((error){
              print("UPLOAD ERROR : $error\n");
              uploadingFileName = "";
              emit(ConversationSendFilesErrorState(error.toString()));
            });
          }).catchError((error) {
            print("UPLOAD ERROR : $error\n");
            uploadingFileName = "";
            emit(ConversationSendFilesErrorState(error.toString()));
          });
        }).catchError((error) {
          print("UPLOAD ERROR : $error\n");
          uploadingFileName = "";
          emit(ConversationSendFilesErrorState(error.toString()));
        });
      }).catchError((error) {
        print("UPLOAD ERROR : $error\n");
        uploadingFileName = "";
        emit(ConversationSendFilesErrorState(error.toString()));
      });
  }

  Future<void> uploadMultipleImagesFireStore(BuildContext context, String message, String receiverID, String chatID, String messageType) async{
    emit(ConversationUploadingImagesState());
    DateTime now = DateTime.now();
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
    String currentTime = DateFormat("hh:mm a").format(now);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    var storageRef = FirebaseStorage.instance.ref("Chats").child(chatID).child(currentFullTime);
    var ref = FirebaseFirestore.instance.collection("Chats").doc(chatID).collection("Messages").doc(currentFullTime);
    var chatListRef = FirebaseFirestore.instance.collection("ChatList").doc(userID).collection("Chats").doc(receiverID);
    var chatListTwoRef = FirebaseFirestore.instance.collection("ChatList").doc(receiverID).collection("Chats").doc(userID);

    List<String> urlsList = [];

    Map<String, Object> dataMap = HashMap();

    dataMap['Message'] = message;
    dataMap['ReceiverID'] = receiverID;
    dataMap['SenderID'] = userID;
    dataMap['fileName'] = "";
    dataMap["isSeen"] = false;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = ["emptyList"];
    dataMap["type"] = messageType;
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
              chatListMap['ReceiverID'] = receiverID;
              chatListMap['ReceiverName'] = receiverName;
              chatListMap['ReceiverImage'] = receiverImage;
              chatListMap['ReceiverToken'] = receiverToken;
              chatListMap['LastMessage'] = message;
              chatListMap['LastMessageType'] = messageType;
              chatListMap['LastMessageTime'] = currentTime;
              chatListMap['LastMessageSender'] = prefs.getString('ClerkID');
              chatListMap["TimeStamp"] = Timestamp.now();

              chatListRef.update(chatListMap);
              chatListTwoRef.update(chatListMap);
              emit(ConversationSendImagesSuccessState());
            }).catchError((error){
              print("UPLOAD ERROR : $error\n");
              uploadingImageName = "";
              emit(ConversationSendImagesErrorState(error.toString()));
            });
          }).catchError((error) {
            print("UPLOAD ERROR : $error\n");
            uploadingImageName = "";
            emit(ConversationSendImagesErrorState(error.toString()));
          });
        }).catchError((error) {
          print("UPLOAD ERROR : $error\n");
          uploadingImageName = "";
          emit(ConversationSendImagesErrorState(error.toString()));
        });
      }).catchError((error) {
        print("UPLOAD ERROR : $error\n");
        uploadingImageName = "";
        emit(ConversationSendImagesErrorState(error.toString()));
      });
    }
  }

  void getChatInfo(String chatID) async {

    FirebaseFirestore.instance
        .collection("Chats")
        .doc(chatID)
        .snapshots()
        .listen((event) {

          print("Chat INFO : ${event.data()}\n");
    });

  }

  void getFireStoreMessage(String receiverID, String chatID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    FirebaseFirestore.instance
        .collection("Chats")
        .doc(chatID)
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
          chatImagesModel = ChatImagesModel(data["messageFullTime"], (data["messageImages"] as List));
          chatImagesList.add(chatImagesModel!);

          chatModel = ChatModel.full(
              data["SenderID"],
              data["ReceiverID"],
              data["Message"],
              data["messageTime"],
              data["messageFullTime"],
              data["createdAt"],
              data["type"],
              data["imagesCount"],
              data["fileSize"],
              data["recordDuration"],
              data["isSeen"],
              data["fileName"],
              data["hasImages"],
              messageImagesStringList,
              chatImagesModel
          );
          chatList.add(chatModel!);
          chatListReversed = chatList.reversed.toList();
          emit(ConversationGetMessageSuccessState());
        }
    });
  }

  void changeUserState(String currentState, String receiverID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> dataMap = HashMap();
    dataMap["PartnerState"] = currentState;
    FirebaseFirestore.instance
        .collection("ChatList")
        .doc(prefs.getString("ClerkID"))
        .collection("Chats")
        .doc(receiverID)
        .update(dataMap);
    emit(ConversationChangeUserState());
  }

  void selectImages(
      BuildContext context, String receiverID, String receiverToken,String receiverName, String receiverImage, String chatID) async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    imageFileList = [];

    if (selectedImages!.isNotEmpty) {
      for (var element in selectedImages) {
        imageFileList!.add(element.path);
      }
      messageImagesStaticList = imageFileList!;
      navigateTo(
          context,
          SelectedImagesScreen(
            chatImages: imageFileList,
            receiverID: receiverID,
            receiverToken: receiverToken,
            receiverName: receiverName,
            receiverImage: receiverImage,
            chatID: chatID,
          ));
      emit(ConversationSelectImagesState());
    }
  }

  void selectFile(String receiverID, String chatID) async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);

      if (result != null) {
        sendFireStoreFileMessage(receiverID, false, result, chatID);
      } else {
        // User canceled the picker
      }

      emit(ConversationSelectFilesState());
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      emit(ConversationPermissionDeniedState());
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
      String receiverID, String chatID, String type, bool isSeen, File file) async {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    var storageRef = FirebaseStorage.instance.ref("Chats").child(chatID).child("Records").child(audioPathStore);
    var ref = FirebaseFirestore.instance.collection("Chats").doc(chatID).collection("Messages");
    var chatListRef = FirebaseFirestore.instance.collection("ChatList").doc(userID).collection("Chats").doc(receiverID);
    var chatListTwoRef = FirebaseFirestore.instance.collection("ChatList").doc(receiverID).collection("Chats").doc(userID);


    File audioFile = File(file.path.toString());
    final String minutes = _formatNumber(recordDuration ~/ 60);
    final String seconds = _formatNumber(recordDuration % 60);

    Map<String, dynamic> dataMap = HashMap();
    dataMap['SenderID'] = prefs.getString('ClerkID');
    dataMap['ReceiverID'] = receiverID;
    dataMap['Message'] = "";
    dataMap['type'] = "audio";
    dataMap["isSeen"] = isSeen;
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
    chatListMap['ReceiverID'] = receiverID;
    chatListMap['ReceiverName'] = receiverName;
    chatListMap['ReceiverImage'] = receiverImage;
    chatListMap['ReceiverToken'] = receiverToken;
    chatListMap['LastMessage'] = "ملف صوتى";
    chatListMap['LastMessageType'] = "audio";
    chatListMap['LastMessageTime'] = currentTime;
    chatListMap['LastMessageSender'] = prefs.getString('ClerkID');
    chatListMap["TimeStamp"] = Timestamp.now();

    ref.doc(currentFullTime).set(dataMap).then((value) async {
      uploadingRecordName = currentFullTime;

      var uploadTask = storageRef.putFile(audioFile);
      await uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {

          dataMap['Message'] = value.toString();

          ref.doc(currentFullTime).update(dataMap).then((value)async {
            uploadingRecordName = "";
            chatListRef.update(chatListMap);
            chatListTwoRef.update(chatListMap);
            emit(ConversationSendFilesSuccessState());
          }).catchError((error){
            print("UPLOAD ERROR : $error\n");
            uploadingRecordName = "";
            emit(ConversationSendFilesErrorState(error.toString()));
          });
        }).catchError((error) {
          print("UPLOAD ERROR : $error\n");
          uploadingRecordName = "";
          emit(ConversationSendFilesErrorState(error.toString()));
        });
      }).catchError((error) {
        print("UPLOAD ERROR : $error\n");
        uploadingRecordName = "";
        emit(ConversationSendFilesErrorState(error.toString()));
      });
    }).catchError((error) {
      print("UPLOAD ERROR : $error\n");
      uploadingRecordName = "";
      emit(ConversationSendFilesErrorState(error.toString()));
    });
  }

  Future<void> downloadDocumentFile(String receiverID,String chatID, String fileName) async {
    emit(ConversationLoadingDownloadFileState(fileName));
    downloadingFileName = fileName;

    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      File downloadToFile =
          File('$path/IT Department/Documents/$fileName');

      try {
      await FirebaseStorage.instance
          .ref('Chats')
          .child(chatID)
          .child("Documents")
          .child(fileName)
          .writeToFile(downloadToFile)
          .then((p0) {
        downloadingFileName = "";
        emit(ConversationDownloadFileSuccessState());
      }).catchError((error) {
        downloadingFileName = "";
        emit(ConversationDownloadFileErrorState(error.toString()));
      });
       } on FirebaseException catch (e) {
       downloadingFileName = "";
       emit(ConversationDownloadFileErrorState(e.message.toString()));
      }
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingFileName = "";
      emit(ConversationPermissionDeniedState());
    }
  }

  Future<void> downloadAudioFile(String fileName, int index) async {
    emit(ConversationLoadingDownloadFileState(fileName));
    downloadingRecordName = fileName;

    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      File downloadToFile = File(
          '/storage/emulated/0/Download/IT Department/Records/$fileName');
      print("FILE NAME : $fileName\n");
      try {
        await FirebaseStorage.instance
            .ref('Chats/$chatID/Records/$fileName')
            .writeToFile(downloadToFile);
        downloadingRecordName = "";
        emit(ConversationDownloadFileSuccessState());

        chatMicrophoneOnTapAction(index, fileName);
      } on FirebaseException catch (e) {
        downloadingRecordName = "";
        print(e.message.toString());
        emit(ConversationDownloadFileErrorState(e.message.toString()));
      }
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingRecordName = "";
      emit(ConversationPermissionDeniedState());
    }
  }

  Future<void> downloadImageFile(String fileName) async {
    emit(ConversationLoadingDownloadFileState(fileName));
    downloadingFileName = fileName;

    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      File downloadToFile =
          File('$path/Future Of Egypt Media/Images/$fileName');
      try {
        await FirebaseStorage.instance
            .ref('Messages/$userID/Future Of Egypt/$fileName')
            .writeToFile(downloadToFile);
        downloadingFileName = "";
        emit(ConversationDownloadFileSuccessState());
      } on FirebaseException catch (e) {
        downloadingFileName = "";
        emit(ConversationDownloadFileErrorState(e.message.toString()));
      }
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      downloadingFileName = "";
      emit(ConversationPermissionDeniedState());
    }
  }

  bool checkForDocumentFile(String fileName) {
    bool isFileExist = File(
            "/storage/emulated/0/Download/IT Department/Documents/$fileName")
        .existsSync();
    return isFileExist;
  }

  bool checkForAudioFile(String fileName) {
    bool isFileExist = File(
            "/storage/emulated/0/Download/IT Department/Records/$fileName")
        .existsSync();
    return isFileExist;
  }

  bool checkForImageFile(String fileName) {
    bool isFileExist = File(
            "/storage/emulated/0/Download/Future Of Egypt Media/Images/$fileName")
        .existsSync();

    if (!isFileExist) {
      downloadImageFile(fileName);
    }

    return isFileExist;
  }

  Future<void> createUserDocumentsDirectory() async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory recordingsDirectory =
          Directory('$externalDoc/IT Department/Documents/');

      if (await recordingsDirectory.exists()) {
        //if folder already exists return path

        emit(ConversationCreateDirectoryState());
      } else {
        //if folder not exists create folder and then return its path
        await recordingsDirectory.create(recursive: true);

        emit(ConversationCreateDirectoryState());
      }
    } else {
      emit(ConversationPermissionDeniedState());
    }
  }

  Future<void> createUserRecordingsDirectory() async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory recordingsDirectory =
          Directory('$externalDoc/IT Department/Records/');

      if (await recordingsDirectory.exists()) {
        //if folder already exists return path

        emit(ConversationCreateDirectoryState());
      } else {
        //if folder not exists create folder and then return its path
        await recordingsDirectory.create(recursive: true);

        emit(ConversationCreateDirectoryState());
      }
    } else {
      emit(ConversationPermissionDeniedState());
    }
  }

  Future<void> createUserImagesDirectory() async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory imagesDirectory =
          Directory('$externalDoc/Future Of Egypt Media/Images/');

      if (await imagesDirectory.exists()) {
        //if folder already exists return path

        emit(ConversationCreateDirectoryState());
      } else {
        //if folder not exists create folder and then return its path
        await imagesDirectory.create(recursive: true);

        emit(ConversationCreateDirectoryState());
      }
    } else {
      emit(ConversationPermissionDeniedState());
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
      audioPath = "/storage/emulated/0/Download/IT Department/Records/${currentFullTime.trim().toString()}-audio$extension";
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
      emit(ConversationStartRecordSuccessState());
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      emit(ConversationPermissionDeniedState());
    }
  }

  Future recordAudio() async {
    var status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      audioRecorder = Record();
      String currentFullTime = DateFormat("yyyy-MM-dd-HH-mm-ss").format(DateTime.now());
      String extension = ".m4a";
      await createUserRecordingsDirectory();
      audioPath = "/storage/emulated/0/Download/IT Department/Records/${currentFullTime.trim().toString()}-audio$extension";
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
      emit(ConversationStartRecordSuccessState());
    } else {
      showToast(
          message: "يجب الموافقة على الاذن اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      emit(ConversationPermissionDeniedState());
    }
  }

  Future stopRecord(String receiverID, String chatID) async {
    timer?.cancel();
    ampTimer?.cancel();
    isRecording = false;
    startedRecordValue.value = false;
    await audioRecorder.stop();
    await sendAudioMessage(receiverID, chatID, "Audio", false, File(audioPath));
    audioPath = "";
    audioPathStore = "";
    emit(ConversationStopRecordSuccessState());
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
    emit(ConversationCancelRecordSuccessState());
  }

  Future toggleRecording(String receiverID, String chatID) async {
    if (!isRecording) {
      await recordAudio();
    } else {
      await stopRecord(receiverID, chatID);
    }
    emit(ConversationToggleRecordSuccessState());
  }

  void changeRecordingState() async {
    isRecording = false;
    startedRecordValue.value = false;
    emit(ConversationChangeRecordingState());
  }

  void startTimer() {
    timer?.cancel();
    ampTimer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      recordDuration++;
      emit(ConversationIncreaseTimerSuccessState());
    });

    /*ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      amplitude = await audioRecorder.getAmplitude();
      emit(ConversationAmpTimerSuccessState());
    });*/
  }

  void initRecorder() async {
    isRecording = false;
    emit(ConversationInitializeRecordSuccessState());
  }

  void chatMicrophoneOnTapAction(int index, String fileName) async {
    try {
      justAudioPlayer.positionStream.listen((event) {
        currAudioPlayingTime = event.inMicroseconds.ceilToDouble();
        loadingTime =
            '${event.inMinutes} : ${event.inSeconds > 59 ? event.inSeconds % 60 : event.inSeconds}';
        emit(ConversationChangeRecordPositionState());
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
            '/storage/emulated/0/Download/Future Of Egypt Media/Records/$fileName');

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
              '/storage/emulated/0/Download/Future Of Egypt Media/Records/$fileName');

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
      emit(ConversationPlayRecordSuccessState());
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
    emit(ConversationStopRecordSuccessState());
  }
}
