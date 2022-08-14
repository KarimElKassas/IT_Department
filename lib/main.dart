import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it_department/modules/Chat/display/cubit/display_chats_cubit.dart';
import 'package:it_department/modules/Login/clerk_login_screen.dart';
import 'package:it_department/modules/SplashScreen/splash_screen.dart';
import 'package:it_department/modules/onBoarding/screens/on_boarding_screen.dart';
import 'package:it_department/shared/bloc_observer.dart';
import 'package:it_department/shared/components.dart';
import 'package:it_department/shared/fingerprint/screens/fingerprint_screen.dart';
import 'package:it_department/shared/local_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart' as res;

import 'network/local/cache_helper.dart';
import 'network/remote/dio_helper.dart';
import 'shared/constants.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}\n');
}

void main()async {

  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  await CacheHelper.init();
  DioHelper.init();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await LocalNotification.flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(LocalNotification.channel);

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
  late BuildContext mContext;
  GlobalKey key = GlobalKey();
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    mContext = context;

    return res.Sizer(
      builder: (context, orientation, deviceType){
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => DisplayChatsCubit()..getMyData()..getChats()),
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

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        /*AwesomeNotifications().createNotification(
            content: NotificationContent( //with asset image
              id: 1234,
              channelKey: 'image',
              title: notification.title,
              body: notification.body,
              bigPicture: notification.,
              notificationLayout: NotificationLayout.BigPicture,
              displayOnForeground: true,

            )
        );*/
        print("notification details : ${notification.body}\n");

        LocalNotification.flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                LocalNotification.channel.id,
                LocalNotification.channel.name,
                channelDescription: LocalNotification.channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
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
    getToken();
  }
  String? token;
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    print("TOKEN : $token\n");
  }

  @override
  void dispose() {
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

