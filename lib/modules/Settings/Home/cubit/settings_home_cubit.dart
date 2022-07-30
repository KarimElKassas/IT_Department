import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Login/clerk_login_screen.dart';
import 'package:it_department/modules/Settings/Home/screens/settings_home_screen.dart';
import 'package:it_department/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool logOutDialogResult = false;

  void getMyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    myID = prefs.getString("ClerkID").toString();
    myName = prefs.getString("ClerkName").toString();
    myJob = prefs.getString("ClerkJob").toString();
    myPhone = prefs.getString("ClerkPhone").toString();
    myImage = prefs.getString("ClerkImage").toString();
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

}