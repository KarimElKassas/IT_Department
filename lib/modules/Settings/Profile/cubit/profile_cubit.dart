import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:it_department/modules/Chat/display/screens/display_chats_screen.dart';
import 'package:it_department/modules/Settings/Profile/cubit/profile_states.dart';
import 'package:it_department/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCubit extends Cubit<ProfileStates>{
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  String imageUrl = "";
  bool emptyImage = true;
  bool changeHappened = false;
  final ImagePicker imagePicker = ImagePicker();

  void selectImage() async {

    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

    imageUrl = image!.path;

    emptyImage = false;

    emit(ProfileChangeImageState());
  }
  void changeHappenValue(){
    changeHappened = true;
    emit(ProfileChangeHappenValueState());
  }
  void initializePasswordController(TextEditingController passController, String initialValue){
    passController.text = initialValue;
    emit(ProfileInitializeControllerState());
  }

  void updateData(String clerkID, String newPassword, BuildContext context)async {
    emit(ProfileLoadingUpdateState());
    Map<String, dynamic> dataMap = HashMap();

    dataMap["ClerkPassword"] = newPassword;

    if(!emptyImage){
      var storageRef = FirebaseStorage.instance.ref("Clerks/$clerkID");
      File imageFile = File(imageUrl);

      var uploadTask = storageRef.putFile(imageFile);
      await uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {
          dataMap["ClerkImage"] = value.toString();

          FirebaseFirestore.instance.collection("Clerks").doc(clerkID).update(dataMap).then((
              realtimeDbValue) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString("ClerkPassword", newPassword);

            prefs.setString("ClerkImage", value.toString());
            showToast(
              message: "تم التعديل بنجاح",
              length: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
            finish(context, DisplayChatsScreen(initialIndex: 0));
            emit(ProfileUpdateSuccessState());
          }).catchError((error){
            showToast(message: "لقد حدث خطأ ما برجاء المحاولة لاحقاً", length: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 3);
            emit(ProfileUpdateErrorState(error.toString()));
          });
        }).catchError((error){
          showToast(message: "لقد حدث خطأ ما برجاء المحاولة لاحقاً", length: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 3);
          emit(ProfileUpdateErrorState(error.toString()));
        });
      }).catchError((error){
        showToast(message: "لقد حدث خطأ ما برجاء المحاولة لاحقاً", length: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 3);
        emit(ProfileUpdateErrorState(error.toString()));
      });
    }else{
      FirebaseFirestore.instance.collection("Clerks").doc(clerkID).update(dataMap).then((
          realtimeDbValue) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("ClerkPassword", newPassword);
        showToast(
          message: "تم التعديل بنجاح",
          length: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
        );
        finish(context, DisplayChatsScreen(initialIndex: 0));
        emit(ProfileUpdateSuccessState());
      }).catchError((error){
        showToast(message: "لقد حدث خطأ ما برجاء المحاولة لاحقاً", length: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 3);
        emit(ProfileUpdateErrorState(error.toString()));
      });
    }



  }
}