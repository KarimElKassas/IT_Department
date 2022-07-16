import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it_department/modules/Home/screens/home_screen.dart';
import 'package:it_department/modules/Manager/screens/manager_home_screen.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../../network/remote/dio_helper.dart';
import '../../../../shared/components.dart';
import 'clerk_login_states.dart';

class ClerkLoginCubit extends Cubit<ClerkLoginStates>{
  ClerkLoginCubit() : super(ClerkLoginInitialState());

  static ClerkLoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffix = Icons.visibility_rounded;

  String? managerID;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded;

    emit(ClerkLoginChangePassVisibility());
  }
  void signManual(BuildContext context)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("ClerkID", "3020");
    await prefs.setString("ClerkName", "كريم محمد السيد إسماعيل");
    await prefs.setString("ClerkPassword", "123456");
    await prefs.setString("ClerkNumber", "3020");
    await prefs.setString("ClerkPhone", "01017268676");
    await prefs.setString("ClerkManagementID", "1028");
    await prefs.setString("ClerkManagementName", "إدارة الرقمنة");
    await prefs.setString("ClerkTypeName", "مدنيين");
    await prefs.setString("ClerkRankName", "مدنى");
    await prefs.setString("ClerkCategoryName", "مدنيين");
    await prefs.setString("ClerkCoreStrengthName","الضبعة");
    await prefs.setString("ClerkPresenceName", "الضبعة");
    await prefs.setString("ClerkJobName", "مبرمج");
    await prefs.setStringList("ClerkSubscriptions", []);
    var token = await FirebaseMessaging.instance.getToken();

    Map<String, dynamic> dataMap = HashMap();
    dataMap["ClerkToken"] = token;
    await FirebaseFirestore.instance.collection("Clerks").doc("3020").update(dataMap);
    await prefs.setString("ClerkToken", token??"");

    finish(context, const HomeScreen());
    emit(ClerkLoginSuccessState());
  }
  void signInUser(BuildContext context, String personNumber, String userPassword) async {
    emit(ClerkLoginLoadingSignIn());

    var connectivityResult = await (Connectivity().checkConnectivity());

    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.none)) {
      showToast(
        message: "برجاءالاتصال بشبكة المشروع اولاً",
        length: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
      );
      emit(ClerkLoginNoInternetState());
    } else if (connectivityResult == ConnectivityResult.wifi) {
      final info = NetworkInfo();

      info.getWifiIP().then((deviceIP) async {
        if (deviceIP!.contains("172.16.1.") || deviceIP.contains("١٧٢")) {

          await DioHelper.getData(
              url: 'userInfo/GetUserInfoWithParams',
              query: {'PR_Person_Number': personNumber, 'User_Password': userPassword})
              .then((value) async {
            print(value.statusMessage.toString());

            if (value.statusMessage == "No Person Form Row Found") {
              showToast(
                  message: "لا يوجد مستخدم بهذه البيانات",
                  length: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3);

              emit(ClerkLoginNoUserState());
            } else {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var userID = value.data[0]["PR_Persons_Number"].toString();
              var userName = value.data[0]["PR_Persons_Name"].toString();
              var userPassword = value.data[0]["User_Password"].toString();
              var userNumber = value.data[0]["PR_Persons_Number"].toString();
              var userPhone = value.data[0]["PR_Persons_MobilNum1"].toString();
              var userManagementID = value.data[0]["PR_Management_ID"].toString();
              var userManagementName = value.data[0]["PR_Management_Name"].toString();
              var userTypeName = value.data[0]["Person_Type_Name"].toString();
              var userRankName = value.data[0]["PR_Rank_Name"].toString();
              var userCategoryName = value.data[0]["PR_Category_Name"].toString();
              var userCoreStrengthName = value.data[0]["PR_CoreStrength_Name"].toString();
              var userPresenceName = value.data[0]["PR_Presence_Name"].toString();
              var userJobName = value.data[0]["PR_Jobs_Name"].toString();

              FirebaseFirestore.instance.collection("Clerks").doc(userNumber).get().then((value) async {
                  if(value.exists){
                    FirebaseFirestore.instance.collection("Clerks").doc(userNumber).get().then((value)async{
                      Map data = value.data()!;
                      await prefs.setString("ClerkImage", data["ClerkImage"].toString());
                    });

                    await prefs.setString("ClerkID", userID);
                    await prefs.setString("ClerkName", userName);
                    await prefs.setString("ClerkPassword", userPassword);
                    await prefs.setString("ClerkNumber", userNumber);
                    await prefs.setString("ClerkPhone", userPhone);
                    await prefs.setString("ClerkManagementID", userManagementID);
                    await prefs.setString("ClerkManagementName", userManagementName);
                    await prefs.setString("ClerkTypeName", userTypeName);
                    await prefs.setString("ClerkRankName", userRankName);
                    await prefs.setString("ClerkCategoryName", userCategoryName);
                    await prefs.setString("ClerkCoreStrengthName",userCoreStrengthName);
                    await prefs.setString("ClerkPresenceName", userPresenceName);
                    await prefs.setString("ClerkJobName", userJobName);
                    await prefs.setStringList("ClerkSubscriptions", []);
                    var token = await FirebaseMessaging.instance.getToken();

                    Map<String, dynamic> dataMap = HashMap();
                    dataMap["ClerkToken"] = token;
                    await FirebaseFirestore.instance.collection("Clerks").doc(userNumber).update(dataMap);
                    await prefs.setString("ClerkToken", token??"");

                    showToast(
                        message: "اهلا بيك \n $userName",
                        length: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 3);

                    await getDepartmentManager(userManagementID);
                    finish(context, (managerID != userNumber) ? const HomeScreen() : const ManagerHomeScreen());
                    emit(ClerkLoginSuccessState());
                  }else{
                    showToast(
                        message: "برجاء انشاء حساب اولاً",
                        length: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 3);
                  }
                  emit(ClerkLoginSuccessState());
              });
            }
          }).catchError((error) {
            if (error.type == DioErrorType.response) {
              showToast(
                  message: "لا يوجد مستخدم بهذه البيانات",
                  length: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3);
              emit(ClerkLoginNoUserState());
            } else {
              emit(ClerkLoginErrorState(error.toString()));
            }
          });
        } else {
          showToast(
              message: "برجاء الاتصال بشبكة المشروع اولاً",
              length: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3);
          emit(ClerkLoginNoInternetState());
        }
      });
    }
  }
  Future<void> getDepartmentManager(String departmentID) async{
    await DioHelper.getData(
        url: 'departments/GetDepartmentWithID',
        query: {'DEPTID' : departmentID}).then((value){
      managerID = value.data[0]["DEPTLeaderID"].toString();
      emit(ClerkLoginGetDepartmentManagerSuccessState());
    }).catchError((error){
      emit(ClerkLoginGetDepartmentManagerErrorState(error.toString()));
    });
  }

  void finish(BuildContext context, route){
    Navigator.pushReplacement(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
  }
  void navigate(BuildContext context, route){
    Navigator.push(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
  }
}