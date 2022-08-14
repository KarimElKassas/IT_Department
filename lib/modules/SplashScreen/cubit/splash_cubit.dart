import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Chat/display/screens/display_chats_screen.dart';
import 'package:it_department/modules/Home/screens/home_screen.dart';
import 'package:it_department/modules/SplashScreen/cubit/splash_states.dart';
import 'package:it_department/modules/onBoarding/screens/on_boarding_screen.dart';
import 'package:it_department/shared/constants.dart';
import 'package:it_department/shared/fingerprint/screens/fingerprint_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../../network/remote/dio_helper.dart';
import '../../../shared/components.dart';
import '../../Login/clerk_login_screen.dart';

class SplashCubit extends Cubit<SplashStates> {
  SplashCubit() : super(SplashInitialState());

  static SplashCubit get(context) => BlocProvider.of(context);

  String? managerID;

  Future<void> navigate(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("FirstTime") || prefs.getBool("FirstTime") == true){
      finish(context, OnBoardingScreen());

    }else if(prefs.getString("ClerkID") != null){

      if(prefs.containsKey("FingerTime")){

        int currentTimeInMillis = DateTime.now().millisecondsSinceEpoch;
        int lastFingerTime = prefs.getInt("FingerTime")!;
        print("DIFFERENCE : ${currentTimeInMillis - lastFingerTime}\n");
        if(currentTimeInMillis - lastFingerTime > 60000){
          print("DIFFERENCE IN : ${currentTimeInMillis - lastFingerTime}\n");
          lastOpenedScreen = "FingerPrintScreen";
          finish(context, const FingerPrintScreen(openedFrom: "Splash",));
        }else{
          finish(context, DisplayChatsScreen(initialIndex: 0));
        }
      }else{
        await getDepartmentManager(prefs.getString("ClerkManagementID")!.toString());
        finish(context, (managerID != prefs.getString("ClerkNumber")!.toString()) ? DisplayChatsScreen(initialIndex: 0) : DisplayChatsScreen(initialIndex: 0));
      }
    }else{
      finish(context, ClerkLoginScreen());
    }
    emit(SplashSuccessNavigateState());
  }

  Future<void> getDepartmentManager(String departmentID) async{
    await DioHelper.getData(
        url: 'departments/GetDepartmentWithID',
        query: {'DEPTID' : departmentID}).then((value){
      managerID = value.data[0]["DEPTLeaderID"].toString();
      emit(SplashGetDepartmentManagerSuccessState());
    }).catchError((error){
      emit(SplashGetDepartmentManagerErrorState(error.toString()));
    });
  }

  Future<void> createMediaFolder() async {

    await FirebaseMessaging.instance.subscribeToTopic("2022-02-20-22-26-32");

    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory mediaDirectory =
          Directory('$externalDoc/Future Of Egypt Media/');

      if (mediaDirectory.existsSync()) {
        emit(SplashSuccessCreateDirectoryState());
      } else {
        await mediaDirectory.create(recursive: true);
        emit(SplashSuccessCreateDirectoryState());
      }

      final Directory documentsDirectory = Directory('/storage/emulated/0/Download/Future Of Egypt Media/Documents/');

      if (documentsDirectory.existsSync()) {
        emit(SplashSuccessCreateDirectoryState());
      } else {
        await documentsDirectory.create(recursive: true);
        emit(SplashSuccessCreateDirectoryState());
      }

      final Directory recordingsDirectory = Directory('/storage/emulated/0/Download/Future Of Egypt Media/Records/');

      if (recordingsDirectory.existsSync()) {
        emit(SplashSuccessCreateDirectoryState());
      } else {
        await recordingsDirectory.create(recursive: true);
        emit(SplashSuccessCreateDirectoryState());
      }

      final Directory imagesDirectory = Directory('/storage/emulated/0/Download/Future Of Egypt Media/Images/');

      if (await imagesDirectory.exists()) {
        emit(SplashSuccessCreateDirectoryState());
      } else {
        await imagesDirectory.create(recursive: true);
        emit(SplashSuccessCreateDirectoryState());
      }
    } else {
      emit(SplashSuccessPermissionDeniedState());
    }
  }
}
