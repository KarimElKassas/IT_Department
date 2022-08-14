import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it_department/modules/Settings/Profile/cubit/profile_cubit.dart';
import 'package:it_department/modules/Settings/Profile/cubit/profile_states.dart';
import 'package:it_department/shared/components.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/gallery_item_wrapper_view.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen(
      {Key? key,
      required this.userID,
      required this.userName,
      required this.userImage,
      required this.userPhone,
      required this.userDepartment,
      required this.userCategory,
      required this.userRank,
      required this.userPassword,
      required this.userJob})
      : super(key: key);

  final String userID,
      userName,
      userImage,
      userPhone,
      userDepartment,
      userCategory,
      userRank,
      userPassword,
      userJob;
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()
        ..initializePasswordController(passwordController, userPassword),
      child: BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {
          if(state is ProfileLoadingUpdateState){
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext blurryContext) =>  WillPopScope(
                  onWillPop: () => Future.value(false),
                  child: BlurryProgressDialog(
                    title: "جارى التعديل",
                    titleStyle: TextStyle(color: lightGreen, fontFamily: "Questv", fontWeight: FontWeight.w600),
                    titleMaxLines: 2,
                    titleMaxSize: 14,
                    titleMinSize: 12,
                    blurValue: 0.5,
                  ),
                ));
          }
        },
        builder: (context, state) {
          var cubit = ProfileCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: veryLightGreen.withOpacity(0.08),
              flexibleSpace: SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if(cubit.changeHappened || !cubit.emptyImage){
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext mContext) => WillPopScope(
                                  onWillPop: () => Future.value(false),
                                  child: BlurryDialog(
                                    "تنبيه !",
                                    "هل تريد تجاهل التعديلات ؟",
                                        () {
                                      Navigator.of(mContext).pop();
                                      Navigator.of(context).pop();
                                    },
                                        () {
                                      Navigator.of(mContext).pop();
                                    },
                                    titleTextStyle: TextStyle(
                                        fontFamily: "Questv",
                                        fontWeight: FontWeight.w600,
                                        color: lightGreen),
                                    contentTextStyle: TextStyle(
                                        fontFamily: "Questv", color: lightGreen),
                                    okTextStyle: TextStyle(
                                        fontFamily: "Questv",
                                        fontWeight: FontWeight.w600,
                                        color: lightGreen),
                                    noTextStyle: TextStyle(
                                        fontFamily: "Questv",
                                        fontWeight: FontWeight.w600,
                                        color: lightGreen),
                                    blurValue: 0.3,
                                    contentTextMaxLines: 2,
                                    contentTextMinSize: 10,
                                    contentTextMaxSize: 12,
                                    titleTextMaxSize: 14,
                                    titleTextMinSize: 12,
                                    noTextMaxSize: 12,
                                    noTextMinSize: 10,
                                    okTextMaxSize: 12,
                                    okTextMinSize: 10,
                                  ),
                                ),
                              );
                            }else{
                              Navigator.pop(context);
                            }
                          },
                          icon: Transform.scale(
                            scale: 1,
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: lightGreen,
                              size: 28,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "الملف الشخصى",
                              style: TextStyle(
                                  color: lightGreen,
                                  letterSpacing: 1.5,
                                  fontFamily: "Questv",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            //cubit.startSearch(context);
                          },
                          icon: Icon(
                            Icons.menu_open_rounded,
                            color: lightGreen,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: WillPopScope(
              onWillPop: (){
                if(cubit.changeHappened || !cubit.emptyImage){
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext mContext) => WillPopScope(
                      onWillPop: () => Future.value(false),
                      child: BlurryDialog(
                            "تنبيه !",
                            "هل تريد تجاهل التعديلات ؟",
                            () {
                          Navigator.of(mContext).pop();
                          Navigator.of(context).pop();
                        },
                            () {
                          Navigator.of(mContext).pop();
                        },
                        titleTextStyle: TextStyle(
                            fontFamily: "Questv",
                            fontWeight: FontWeight.w600,
                            color: lightGreen),
                        contentTextStyle: TextStyle(
                            fontFamily: "Questv", color: lightGreen),
                        okTextStyle: TextStyle(
                            fontFamily: "Questv",
                            fontWeight: FontWeight.w600,
                            color: lightGreen),
                        noTextStyle: TextStyle(
                            fontFamily: "Questv",
                            fontWeight: FontWeight.w600,
                            color: lightGreen),
                        blurValue: 0.3,
                        contentTextMaxLines: 2,
                        contentTextMinSize: 10,
                        contentTextMaxSize: 12,
                        titleTextMaxSize: 14,
                        titleTextMinSize: 12,
                        noTextMaxSize: 12,
                        noTextMinSize: 10,
                        okTextMaxSize: 12,
                        okTextMinSize: 10,
                      ),
                    ),
                  );
                }else{
                  Navigator.pop(context);
                }
                return Future.value();
              },
              child: Container(
                color: veryLightGreen.withOpacity(0.08),
                height: 100.h,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    color: Colors.transparent,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  bottom: 36, top: 24, right: 16, left: 16),
                              child: FadeIn(
                                duration: const Duration(milliseconds: 600),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: userImage == ""
                                      ? InkWell(
                                          onTap: () {
                                            showImageBottomSheet(context, cubit);
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                height: 140,
                                                width: 140,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        width: 2,
                                                        color: lightGreen)),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 16),
                                                color: Colors.transparent,
                                                child: Icon(
                                                  Icons
                                                      .add_photo_alternate_outlined,
                                                  color: lightGreen,
                                                  size: 42,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            showImageBottomSheet(context, cubit);
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    //borderRadius: BorderRadius.circular(48),
                                                    border: Border.all(
                                                        color: lightGreen,
                                                        width: 1),
                                                    shape: BoxShape.circle,
                                                    color: Colors.transparent),
                                                height: 140,
                                                width: 140,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                        //borderRadius: BorderRadius.circular(48),
                                                        shape: BoxShape.circle,
                                                        color: Colors.white),
                                                    height: 140,
                                                    width: 140,
                                                    child: cubit.emptyImage
                                                        ? CachedNetworkImage(
                                                            imageUrl: userImage,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                ClipOval(
                                                              child: FadeInImage(
                                                                height: 140,
                                                                width: 140,
                                                                fit: BoxFit.fill,
                                                                image:
                                                                    imageProvider,
                                                                placeholder:
                                                                    const AssetImage(
                                                                        "assets/images/placeholder.jpg"),
                                                                imageErrorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Image
                                                                      .asset(
                                                                    'assets/images/error.png',
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    height: 140,
                                                                    width: 140,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            placeholder: (context,
                                                                    url) =>
                                                                CircularProgressIndicator(
                                                              color: orangeColor,
                                                              strokeWidth: 0.8,
                                                            ),
                                                            errorWidget: (context,
                                                                    url, error) =>
                                                                const FadeInImage(
                                                              height: 140,
                                                              width: 140,
                                                              fit: BoxFit.fill,
                                                              image: AssetImage(
                                                                  "assets/images/error.png"),
                                                              placeholder: AssetImage(
                                                                  "assets/images/placeholder.jpg"),
                                                            ),
                                                          )
                                                        : FittedBox(
                                                            fit: BoxFit.fill,
                                                            child: ClipOval(
                                                              child: Image.file(
                                                                  File(cubit
                                                                      .imageUrl)),
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                  bottom: -4,
                                                  left: 5,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: white),
                                                      padding:
                                                          const EdgeInsets.all(8),
                                                      child: Icon(
                                                        IconlyBroken.edit,
                                                        color: lightGreen,
                                                        size: 24,
                                                      ))),
                                            ],
                                            alignment: Alignment.bottomLeft,
                                            clipBehavior: Clip.none,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 4.0, bottom: 6),
                            child: Text(
                              "الأسم بالكامل",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Questv"),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 8, right: 12, bottom: 8, top: 8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            width: 100.w,
                            child: Text(
                              userName,
                              style: TextStyle(
                                  color: lightGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Questv"),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 4.0, bottom: 6),
                            child: Text(
                              "رقم الهاتف",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Questv"),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 8, right: 12, bottom: 8, top: 8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            width: 100.w,
                            child: Text(
                              userPhone,
                              style: TextStyle(
                                  color: lightGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Questv",
                                  letterSpacing: 2),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          InkWell(
                            onTap: () {
                              var oldValue = passwordController.text.toString();
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext mContext) => WillPopScope(
                                  onWillPop: () => Future.value(false),
                                  child: TextFieldDialog(
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 8,),
                                        TextFormField(
                                          controller: passwordController,
                                          textDirection: TextDirection.rtl,
                                          keyboardType: TextInputType.text,
                                          cursorColor: lightGreen,
                                          style: TextStyle(
                                              color: lightGreen,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Questv"),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: lightGreen, width: 1.0),
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(8.0))),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            labelText: "تغيير كلمة المرور",
                                            floatingLabelStyle: TextStyle(
                                                color: lightGreen,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Questv"
                                            ),
                                            hintText: "كلمة المرور",
                                            hintStyle: TextStyle(
                                                color: lightGreen,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Questv"),
                                            hintTextDirection: TextDirection.rtl,
                                            prefixIcon: Icon(
                                              IconlyBold.profile,
                                              color: lightGreen,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: lightGreen, width: 1.0),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: lightGreen, width: 1.0),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: lightGreen, width: 1.0),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    () {
                                      if(passwordController.text.toString().isEmpty){
                                        showToast(message: "كلمة المرور لا يمكن ان تكون فارغة", length: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 3);
                                      }else if(passwordController.text.toString().length < 6){
                                        showToast(message: "كلمة المرور لا يمكن ان تكون اقل من 6 حروف او ارقام", length: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 3);
                                      }else{
                                        if(oldValue != passwordController.text.toString()){
                                          cubit.changeHappenValue();
                                        }
                                        Navigator.of(mContext).pop();
                                      }
                                    },
                                    () {
                                      cubit.initializePasswordController(passwordController, oldValue);
                                      Navigator.of(mContext).pop();
                                    },
                                    titleTextStyle: TextStyle(
                                        fontFamily: "Questv",
                                        fontWeight: FontWeight.w600,
                                        color: lightGreen),
                                    contentTextStyle: TextStyle(
                                        fontFamily: "Questv", color: lightGreen),
                                    okTextStyle: TextStyle(
                                        fontFamily: "Questv",
                                        fontWeight: FontWeight.w600,
                                        color: lightGreen),
                                    noTextStyle: TextStyle(
                                        fontFamily: "Questv",
                                        fontWeight: FontWeight.w600,
                                        color: lightGreen),
                                    blurValue: 0.3,
                                    contentTextMaxLines: 2,
                                    contentTextMinSize: 10,
                                    contentTextMaxSize: 12,
                                    titleTextMaxSize: 14,
                                    titleTextMinSize: 12,
                                    noTextMaxSize: 12,
                                    noTextMinSize: 10,
                                    okTextMaxSize: 12,
                                    okTextMinSize: 10,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0, bottom: 6),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "كلمة المرور",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Questv"),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Icon(
                                        IconlyBroken.editSquare,
                                        color: lightGreen,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 12, bottom: 8, top: 8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  width: 100.w,
                                  child: Text(
                                    passwordController.text,
                                    style: TextStyle(
                                        color: lightGreen,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Questv"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 4.0, bottom: 6),
                            child: Text(
                              "الفئة",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Questv"),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 8, right: 12, bottom: 8, top: 8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            width: 100.w,
                            child: Text(
                              userCategory,
                              style: TextStyle(
                                  color: lightGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Questv"),
                            ),
                          ),
                          userCategory != "مدنيين"
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(right: 4.0, bottom: 6),
                                      child: Text(
                                        "الرتبة",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Questv"),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 12, bottom: 8, top: 8),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(8)),
                                      ),
                                      width: 100.w,
                                      child: Text(
                                        userRank,
                                        style: TextStyle(
                                            color: lightGreen,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Questv"),
                                      ),
                                    ),
                                  ],
                                )
                              : getEmptyWidget(),
                          const SizedBox(
                            height: 18,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 4.0, bottom: 6),
                            child: Text(
                              "الوظيفة",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Questv"),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 8, right: 12, bottom: 8, top: 8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            width: 100.w,
                            child: Text(
                              userJob == "null" ? "بدون وظيفة" : userJob,
                              style: TextStyle(
                                  color: lightGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Questv"),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 4.0, bottom: 6),
                            child: Text(
                              "الإدارة التابع لها",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Questv"),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 8, right: 12, bottom: 8, top: 8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            width: 100.w,
                            child: Text(
                              userDepartment,
                              style: TextStyle(
                                  color: lightGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Questv"),
                            ),
                          ),
                          const SizedBox(
                            height: 48,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: FadeIn(
                              duration: const Duration(milliseconds: 600),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: InkWell(
                                  onTap: () {
                                    if(cubit.changeHappened || !cubit.emptyImage){
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext mContext) => WillPopScope(
                                          onWillPop: () => Future.value(false),
                                          child: BlurryDialog(
                                            "تنبيه !",
                                            "هل انت متأكد من التعديلات ؟",
                                                () {
                                                  Navigator.pop(mContext);
                                              cubit.updateData(userID, passwordController.text.toString(), context);
                                            },
                                                () {
                                              Navigator.of(mContext).pop();
                                            },
                                            titleTextStyle: TextStyle(
                                                fontFamily: "Questv",
                                                fontWeight: FontWeight.w600,
                                                color: lightGreen),
                                            contentTextStyle: TextStyle(
                                                fontFamily: "Questv", color: lightGreen),
                                            okTextStyle: TextStyle(
                                                fontFamily: "Questv",
                                                fontWeight: FontWeight.w600,
                                                color: lightGreen),
                                            noTextStyle: TextStyle(
                                                fontFamily: "Questv",
                                                fontWeight: FontWeight.w600,
                                                color: lightGreen),
                                            blurValue: 0.3,
                                            contentTextMaxLines: 2,
                                            contentTextMinSize: 10,
                                            contentTextMaxSize: 12,
                                            titleTextMaxSize: 14,
                                            titleTextMinSize: 12,
                                            noTextMaxSize: 12,
                                            noTextMinSize: 10,
                                            okTextMaxSize: 12,
                                            okTextMinSize: 10,
                                          ),
                                        ),
                                      );
                                    }else{
                                      showToast(message: "لم تقم بتعديل كلمة المرور او الصورة الشخصية", length: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 3);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      color: lightGreen,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 4),
                                    width: 30.w,
                                    child: Center(
                                      child: AutoSizeText(
                                        "تـعـديـل",
                                        style: TextStyle(
                                            color: white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Questv",
                                            letterSpacing: 1),
                                        maxFontSize: 22,
                                        maxLines: 1,
                                        minFontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget label(String name, VoidCallback onclick, String? state) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: "Questv"),
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 8, right: 12, bottom: 8, top: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            width: 100.w,
            margin: const EdgeInsets.only(top: 18),
            child: InkWell(
              onTap: () {
                onclick();
              },
            ),
          ),
        ],
      ),
    );
  }

  void showImageBottomSheet(BuildContext context, ProfileCubit cubit) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (sheetContext) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              color: veryLightGreen.withOpacity(0.08),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                constraints: const BoxConstraints(minHeight: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        openImageFullScreen(context, [userImage], cubit, 0);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1, color: lightGreen)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                color: Colors.transparent,
                                child: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: lightGreen,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const AutoSizeText(
                            "عرض الصورة",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Questv",
                              fontWeight: FontWeight.w600,
                            ),
                            textDirection: TextDirection.rtl,
                            minFontSize: 10,
                            maxLines: 1,
                            maxFontSize: 12,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    InkWell(
                      onTap: () {
                        cubit.selectImage();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1, color: lightGreen)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                color: Colors.transparent,
                                child: Icon(
                                  IconlyBroken.editSquare,
                                  color: lightGreen,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const AutoSizeText(
                            "تغيير الصورة",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Questv",
                              fontWeight: FontWeight.w600,
                            ),
                            textDirection: TextDirection.rtl,
                            minFontSize: 10,
                            maxLines: 1,
                            maxFontSize: 12,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showPasswordBottomSheet(BuildContext context, ProfileCubit cubit) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isScrollControlled: true,
        builder: (sheetContext) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              color: veryLightGreen.withOpacity(0.08),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                constraints: const BoxConstraints(minHeight: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      initialValue: userPassword,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: "كلمة المرور",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(
                        color: lightGreen,
                        fontSize: 14.0,
                        fontFamily: "Questv",
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void openImageFullScreen(BuildContext context, List<dynamic> imagesList,
      ProfileCubit cubit, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryImageWrapper(
          isFile: !cubit.emptyImage,
          fileUrl: !cubit.emptyImage ? cubit.imageUrl : "",
          titleGallery: "",
          galleryItems: imagesList,
          backgroundDecoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(4)),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
