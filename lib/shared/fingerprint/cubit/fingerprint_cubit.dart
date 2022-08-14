import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart';
import 'package:it_department/modules/Chat/display/screens/display_chats_screen.dart';
import 'package:it_department/shared/components.dart';
import 'package:it_department/shared/constants.dart';
import 'package:it_department/shared/fingerprint/cubit/fingerprint_states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../local_auth.dart';

class FingerPrintCubit extends Cubit<FingerPrintStates>{
  FingerPrintCubit() : super(FingerPrintInitialState());

  static FingerPrintCubit get(context) => BlocProvider.of(context);

  Icon icon = const Icon(Icons.fingerprint_rounded, color: Colors.grey, size: 72,);
  String title = "بصمة الأصبع مطلوبة للدخول";
  bool refresh = false;

  void changeRefreshButton(bool refreshNewValue){
    refresh = refreshNewValue;
    emit(FingerPrintChangeRefreshState());
  }
  void auth(BuildContext context)async {
    final isAuthenticated = await LocalAuthApi.authenticate();
    refresh = false;
    if(isAuthenticated){

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int fingerTime = DateTime.now().millisecondsSinceEpoch;
      prefs.setInt("FingerTime", fingerTime);

      icon = Icon(Icons.check_circle_outline_rounded, color: lightGreen, size: 72,);
      title = "تم التعرف على بصمة الاصبع";
      emit(FingerPrintSuccessState());
    }else{
      icon = const Icon(Icons.error_outline_rounded, color: Colors.red, size: 72,);
      title = "لم يتم التعرف على بصمة الاصبع";
      refresh = true;
      emit(FingerPrintErrorState("لم يتم التعرف على البصمة"));
    }
  }

  void cancelAuthentication(BuildContext context) {
    LocalAuthentication.stopAuthentication();
    Navigator.pop(context);
    //finish(context, DisplayChatsScreen(initialIndex: 0));
    emit(FingerPrintCancelState());
  }
}