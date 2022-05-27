import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:it_department/modules/SplashScreen/splash_screen.dart';
import 'package:it_department/shared/bloc_observer.dart';

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
    return MaterialApp(
      title: 'IT Department',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
      home: const SplashScreen(),
    );
  }
}
