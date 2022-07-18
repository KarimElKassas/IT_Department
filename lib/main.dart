import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Chat/display/cubit/display_chats_cubit.dart';
import 'package:it_department/modules/Login/clerk_login_screen.dart';
import 'package:it_department/modules/SplashScreen/splash_screen.dart';
import 'package:it_department/shared/bloc_observer.dart';
import 'package:sizer/sizer.dart' as res;

import 'network/local/cache_helper.dart';
import 'network/remote/dio_helper.dart';

void main()async {

  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  await CacheHelper.init();
  DioHelper.init();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return res.Sizer(
      builder: (context, orientation, deviceType){
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => DisplayChatsCubit()..getMyData()..getChats()),
          ],
          child: MaterialApp(
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
}

class ResponsiveApp {
  static MediaQueryData? _mediaQueryData;

  MediaQueryData get mq => _mediaQueryData!;

  static void setMq(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
  }
}