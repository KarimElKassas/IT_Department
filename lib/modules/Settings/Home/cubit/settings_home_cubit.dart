import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Login/clerk_login_screen.dart';
import 'package:it_department/modules/Settings/Home/screens/settings_home_screen.dart';
import 'package:it_department/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/local_auth.dart';
import 'settings_home_states.dart';

class SettingsHomeCubit extends Cubit<SettingsHomeStates> {
  SettingsHomeCubit() : super(SettingsHomeInitialState());

  static SettingsHomeCubit get(context) => BlocProvider.of(context);

  bool emptyImage = true;
  String imageUrl = "";
  String myID = "";
  String myName = "";
  String myJob = "";
  String myPhone = "";
  String myImage = "";
  String myCategory = "";
  String myRank = "";
  String myDepartment = "";
  String myPassword = "";
  bool logOutDialogResult = false;

  void getMyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myID = prefs.getString("ClerkID").toString();
    myName = prefs.getString("ClerkName").toString();
    myPassword = prefs.getString("ClerkPassword").toString();
    myJob = prefs.getString("ClerkJob").toString();
    myPhone = prefs.getString("ClerkPhone").toString();
    myImage = prefs.getString("ClerkImage").toString();
    myCategory = prefs.getString("ClerkCategoryName").toString();
    myRank = prefs.getString("ClerkRankName").toString();
    myDepartment = prefs.getString("ClerkManagementName").toString();
    if(prefs.containsKey("AppTheme")){
      currentTheme = prefs.getString("AppTheme").toString();
    }else{
      currentTheme = "light";
    }
    if(prefs.containsKey("AppLanguage")){
      currentLanguage = prefs.getString("AppLanguage").toString();
    }else{
      currentLanguage = "ar";
    }
    if(prefs.containsKey("isFingerPrintEnabled")){
      isFingerPrintEnabled = prefs.getBool("isFingerPrintEnabled")!;
    }else{
      isFingerPrintEnabled = false;
    }
    emit(SettingsHomeGetMyDataState());
  }

  void logOut(BuildContext context)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("ClerkID");
    prefs.remove("ClerkName");
    prefs.remove("ClerkPassword");
    prefs.remove("ClerkNumber");
    prefs.remove("ClerkPhone");
    prefs.remove("ClerkManagementID");
    prefs.remove("ClerkManagementName");
    prefs.remove("ClerkTypeName");
    prefs.remove("ClerkRankName");
    prefs.remove("ClerkCategoryName");
    prefs.remove("ClerkCoreStrengthName");
    prefs.remove("ClerkPresenceName");
    prefs.remove("ClerkJobName");
    prefs.remove("ClerkSubscriptions");
    prefs.remove("ClerkToken");
    finish(context, ClerkLoginScreen());
  }

  void changeLogOutDialogResult(bool result){
    logOutDialogResult = result;
    emit(SettingsHomeChangeLogOutDialogResultState());
  }

  void navigate(BuildContext context, route){
    Navigator.push(
        context,
        ScaleTransition1(
            page: route,
            startDuration: const Duration(milliseconds: 600),
            closeDuration: const Duration(milliseconds: 400),
            type: ScaleTrasitionTypes.center)).then((value){
                 emit(SettingsHomeRefreshDataState());
    });
  }

}