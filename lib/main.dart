import 'dart:collection';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:it_department/modules/Chat/display/cubit/display_chats_cubit.dart';
import 'package:it_department/modules/Login/clerk_login_screen.dart';
import 'package:it_department/modules/Settings/Home/screens/settings_home_screen.dart';
import 'package:it_department/modules/SplashScreen/splash_screen.dart';
import 'package:it_department/modules/onBoarding/screens/on_boarding_screen.dart';
import 'package:it_department/shared/bloc_observer.dart';
import 'package:it_department/shared/components.dart';
import 'package:it_department/shared/fingerprint/screens/fingerprint_screen.dart';
import 'package:it_department/shared/local_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart' as res;

import 'modules/Chat/conversation/cubit/conversation_cubit.dart';
import 'network/local/cache_helper.dart';
import 'network/remote/dio_helper.dart';
import 'shared/constants.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}\n');
  LocalNotification.showNotification(message);
}

void main()async {

  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  await CacheHelper.init();
  DioHelper.init();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  GlobalKey key = GlobalKey();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {

    return res.Sizer(
      builder: (context, orientation, deviceType){
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => DisplayChatsCubit()..getMyData()..getChats()),
            BlocProvider(create: (context) => ConversationCubit()),
          ],
          child: MaterialApp(
              key: key,
              navigatorKey: navigatorKey,
              title: 'Future Of Egypt',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
              ),
              home: SplashScreen(),
          ),
        );
      },
    );
  }
  ConversationCubit? conversationCubit;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    conversationCubit = ConversationCubit();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotification.showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title??"Notification Title"),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body??"Notification Body")],
                  ),
                ),
              );
            });
      }
    });

    AwesomeNotifications().actionStream.listen((ReceivedAction receivedAction) {
      var payload = receivedAction.payload;
      if(receivedAction.buttonKeyPressed.isNotEmpty){
        if(receivedAction.buttonKeyPressed == "SEEN_BUTTON"){
          print("SEEN BUTTON CLICKED \n");
          if(payload!["senderID"] != null && payload["chatID"] != null){
            conversationCubit!.getChatData(payload["senderID"].toString(), payload["chatID"].toString()).then((value){
              conversationCubit!.sendFireStoreMessage(payload["senderID"].toString(), payload["chatID"].toString(), "HI FROM KILLED APP", "Text", false, "eQee_LpdS4-raEmF4Dlvvz:APA91bGbUJs0-4FoM0p7ctbN6kexrr0BOKgmbQgSgbUPTJfa1iULiIj-5udYJ8a1ACBghJ4wBS05OrckIs2HruyV9iS6V29vcYs1ML99QRS10pJtXONoVV11CFbECzMfHVpor5QEcjO0", null);
            });
          }
        }else if(receivedAction.buttonKeyInput.isNotEmpty){
            if(payload!["senderID"] != null && payload["chatID"] != null){
                conversationCubit!.getChatData(payload["senderID"].toString(), payload["chatID"].toString()).then((value){
                conversationCubit!.sendFireStoreMessage(payload["senderID"].toString(), payload["chatID"].toString(), receivedAction.buttonKeyInput, "Text", false, "eQee_LpdS4-raEmF4Dlvvz:APA91bGbUJs0-4FoM0p7ctbN6kexrr0BOKgmbQgSgbUPTJfa1iULiIj-5udYJ8a1ACBghJ4wBS05OrckIs2HruyV9iS6V29vcYs1ML99QRS10pJtXONoVV11CFbECzMfHVpor5QEcjO0", null);
              });
            }
        }
      }else{
        print("FALSEEEEEEEE\n");
        return;
      }
    });
    getToken();
  }
  void sendFireStoreMessage(String receiverID, String chatID, String message,
      String type, bool isSeen, String userToken, TextEditingController? messageController) async {
    DateTime now = DateTime.now();
    String currentTime = DateFormat("hh:mm a").format(now);
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
    String userID = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    var chatListRef = FirebaseFirestore.instance.collection("ChatList").doc(userID).collection("Chats").doc(receiverID);
    var chatListTwoRef = FirebaseFirestore.instance.collection("ChatList").doc(receiverID).collection("Chats").doc(userID);

    messageControllerValue.value = "";
    messageController?.clear();

    Map<String, dynamic> dataMap = HashMap();
    dataMap['SenderID'] = userID;
    dataMap['ReceiverID'] = "2002135090526";
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
    chatListMap['ReceiverID'] = "2002135090526";
    chatListMap['ReceiverName'] = "عمرو محمد حسن محمد";
    chatListMap['ReceiverImage'] = "https://firebasestorage.googleapis.com/v0/b/it-department-2022.appspot.com/o/Clerks%2F2002135090526?alt=media&token=e4849ad5-8fc0-432b-a431-67177a4fc147";
    chatListMap['ReceiverToken'] = "eQee_LpdS4-raEmF4Dlvvz:APA91bGbUJs0-4FoM0p7ctbN6kexrr0BOKgmbQgSgbUPTJfa1iULiIj-5udYJ8a1ACBghJ4wBS05OrckIs2HruyV9iS6V29vcYs1ML99QRS10pJtXONoVV11CFbECzMfHVpor5QEcjO0";
    chatListMap['LastMessage'] = message;
    chatListMap['LastMessageType'] = type;
    chatListMap['LastMessageTime'] = currentTime;
    chatListMap['LastMessageSender'] = userID;
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
      //sendNotification(message, currentTime, userToken);
      //emit(ConversationSendMessageState());
    });
  }

  String? token;
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    print("TOKEN : $token\n");
  }
  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if(state == AppLifecycleState.resumed){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey("isFingerPrintEnabled")){
        if(prefs.getBool("isFingerPrintEnabled") == true){
          if(lastOpenedScreen != "FingerPrintScreen"){
            print("اخر حاجه مش البصمة\n");
            lastOpenedScreen = "FingerPrintScreen";
            navigateTo(navigatorKey.currentContext, const FingerPrintScreen(openedFrom: "Main"));
          }else{
            print("اخر حاجه البصمة\n");
          }
        }
      }
      print("APP IS RESUMED\n");
    }else if(state == AppLifecycleState.paused){
      print("APP IS PAUSED\n");
    }

  }
}

