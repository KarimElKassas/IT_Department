import 'dart:io';

import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it_department/shared/constants.dart';

import '../../../models/clerk_model.dart';
import '../../../shared/components.dart';
import '../cubit/clerk_register_cubit.dart';
import '../cubit/clerk_register_states.dart';

class ClerkConfirmRegistrationScreen extends StatefulWidget {
  final ClerkModel clerkModel;

  const ClerkConfirmRegistrationScreen({Key? key, required this.clerkModel})
      : super(key: key);

  @override
  State<ClerkConfirmRegistrationScreen> createState() =>
      _ClerkConfirmRegistrationScreenState();
}

class _ClerkConfirmRegistrationScreenState
    extends State<ClerkConfirmRegistrationScreen> {
  var clerkPasswordController = TextEditingController();
  var clerkConfirmPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClerkRegisterCubit(),
      child: BlocConsumer<ClerkRegisterCubit, ClerkRegisterStates>(
        listener: (context, state) {
          if (state is ClerkRegisterGetClerksErrorState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
          if (state is ClerkRegisterNoClerkFoundState) {
            showToast(
                message:
                    "لا يوجد موظف مسجل بهذا الرقم\n برجاء التوجه الى شئون العاملين اولاً",
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
          if (state is ClerkRegisterErrorState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
          if (state is ClerkRegisterLoadingUploadClerksState) {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    const BlurryProgressDialog(title: "جارى انشاء الحساب"));
          }
        },
        builder: (context, state) {
          var cubit = ClerkRegisterCubit.get(context);

          return Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: confirmationView(cubit, state),
              ),
            )),
          );
        },
      ),
    );
  }

  Widget clerkView(ClerkRegisterCubit cubit) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 18.0,
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                cubit.selectImage();
              },
              child: Stack(
                alignment: Alignment.bottomLeft,
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircleAvatar(
                      radius: 160,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: BuildCondition(
                          condition: cubit.emptyImage == true,
                          builder: (context) => CircleAvatar(
                            child: const Icon(
                              Icons.add_photo_alternate,
                              color: Colors.white,
                              size: 76,
                            ),
                            backgroundColor: Colors.teal.shade700,
                            maxRadius: 160,
                          ),
                          fallback: (context) => SizedBox(
                            width: 160,
                            height: 160,
                            child: Image.file(
                              File(cubit.imageUrl),
                              //fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      backgroundColor: Colors.grey.shade50,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 26.0,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 12.0),
            child: Text(
              "اسم الموظف :",
              style: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextFormField(
            textDirection: TextDirection.rtl,
            keyboardType: TextInputType.text,
            cursorColor: Colors.teal,
            readOnly: true,
            style: TextStyle(
                color: Colors.teal[700],
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintText: widget.clerkModel.clerkName,
              hintStyle: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
              hintTextDirection: TextDirection.rtl,
              prefixIcon: Icon(
                IconlyBold.profile,
                color: Colors.teal[700],
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "رقم الهاتف :",
              style: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextFormField(
            textDirection: TextDirection.rtl,
            keyboardType: TextInputType.text,
            cursorColor: Colors.teal,
            readOnly: true,
            style: TextStyle(
                color: Colors.teal[700],
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintText: widget.clerkModel.personPhone,
              hintStyle: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 16.0,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold),
              hintTextDirection: TextDirection.rtl,
              prefixIcon: Icon(
                IconlyBold.call,
                color: Colors.teal[700],
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "كلمة المرور :",
              style: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextFormField(
            controller: clerkPasswordController,
            textDirection: TextDirection.rtl,
            keyboardType: TextInputType.visiblePassword,
            obscureText: cubit.isPassword,
            cursorColor: Colors.teal,
            textInputAction: TextInputAction.next,
            style: TextStyle(
                color: Colors.teal[700],
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
            validator: (String? value) {
              if (value!.isEmpty) {
                return "يجب ادخال كلمة المرور";
              } else if (value.length < 6) {
                return "كلمة المرور يجب ان تكون اكبر من 6 حروف او ارقام";
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelStyle: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 14.0,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintText: "كلمة المرور",
              hintStyle: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
              hintTextDirection: TextDirection.rtl,
              prefixIcon: Icon(
                IconlyBold.password,
                color: Colors.teal[700],
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  cubit.changePasswordVisibility();
                },
                icon: Icon(
                  cubit.isPassword
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: Colors.teal[700],
                ),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "تأكيد كلمة المرور :",
              style: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextFormField(
            controller: clerkConfirmPasswordController,
            textDirection: TextDirection.rtl,
            keyboardType: TextInputType.text,
            cursorColor: Colors.teal,
            obscureText: cubit.isConfirmPassword,
            textInputAction: TextInputAction.done,
            style: TextStyle(
                color: Colors.teal[700],
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
            validator: (String? value) {
              if (value!.isEmpty) {
                return "يجب ادخال تأكيد كلمة المرور";
              } else if (value.length < 6) {
                return "تأكيد كلمة المرور يجب ان تكون اكبر من 6 حروف او ارقام";
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelStyle: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 14.0,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              hintText: "تأكيد كلمة المرور",
              hintStyle: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
              hintTextDirection: TextDirection.rtl,
              prefixIcon: Icon(
                IconlyBold.password,
                color: Colors.teal[700],
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  cubit.changeConfirmPasswordVisibility();
                },
                icon: Icon(
                  cubit.isConfirmPassword
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: Colors.teal[700],
                ),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Widget confirmationView(ClerkRegisterCubit cubit, ClerkRegisterStates state) {
    return Stack(alignment: Alignment.topCenter, children: [
      Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            color: darkGreen,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.65,
            color: white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: darkGreen,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.04,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        color: white,
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/images/logo_side.svg',
                            alignment: Alignment.center,
                            //width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: Align(
          alignment: Alignment.topCenter,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(32),
            child: Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(32),
              ),
              width: MediaQuery.of(context).size.width * 0.85,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          cubit.selectImage();
                        },
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width *
                                          0.4,
                                  maxHeight:
                                      MediaQuery.of(context).size.height *
                                          0.15),
                              child: BuildCondition(
                                condition: cubit.emptyImage == true,
                                builder: (context) => SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height: MediaQuery.of(context).size.height * 0.15,
                                  child: CircleAvatar(
                                    child: const Icon(
                                      Icons.add_photo_alternate,
                                      color: Colors.white,
                                      size: 65,
                                    ),
                                    backgroundColor: darkGreen,
                                    maxRadius: 120,
                                  ),
                                ),
                                fallback: (context) => ClipOval(
                                  child: Container(
                                    height: 160,
                                    width: 120,
                                    color: Colors.transparent,
                                    child: Image.file(
                                      File(cubit.imageUrl),
                                      width: 120.0,
                                      height: 160.0,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.06
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: TextFormField(
                        textDirection: TextDirection.rtl,
                        keyboardType: TextInputType.text,
                        cursorColor: darkGreen,
                        textAlignVertical: TextAlignVertical.bottom,
                        readOnly: true,
                        style: TextStyle(
                            color: darkGreen,
                            fontSize: 12,
                            fontFamily: "Questv",
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: darkGreen, width: 0.8),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(32.0))),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                          labelText: "اسم الموظف :",
                          labelStyle: TextStyle(
                              color: darkGreen,
                              fontSize: 12,
                              fontFamily: "Questv",
                              fontWeight: FontWeight.bold),
                          floatingLabelStyle: TextStyle(
                              color: darkGreen,
                              fontSize: 12,
                              fontFamily: "Questv",
                              fontWeight: FontWeight.bold),
                          hintText: widget.clerkModel.clerkName,
                          hintStyle: TextStyle(
                              color: darkGreen,
                              fontSize: 12,
                              fontFamily: "Questv",
                              fontWeight: FontWeight.bold),
                          hintTextDirection: TextDirection.rtl,
                          prefixIcon: Icon(
                            IconlyBroken.profile,
                            color: darkGreen,
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: darkGreen, width: 0.8),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: darkGreen, width: 0.8),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: darkGreen, width: 0.8),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(32.0)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.06
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: TextFormField(
                        textDirection: TextDirection.rtl,
                        keyboardType: TextInputType.text,
                        cursorColor: darkGreen,
                        textAlignVertical: TextAlignVertical.bottom,
                        readOnly: true,
                        style: TextStyle(
                            color: darkGreen,
                            fontSize: 12,
                            fontFamily: "Questv",
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: darkGreen, width: 0.8),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(32.0))),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                          labelText: "رقم التليفون :",
                          labelStyle: TextStyle(
                              color: darkGreen,
                              fontSize: 12,
                              fontFamily: "Questv",
                              fontWeight: FontWeight.bold),
                          floatingLabelStyle: TextStyle(
                              color: darkGreen,
                              fontSize: 12,
                              fontFamily: "Questv",
                              fontWeight: FontWeight.bold),
                          hintText: widget.clerkModel.personPhone,
                          hintStyle: TextStyle(
                              color: darkGreen,
                              fontSize: 12,
                              fontFamily: "Questv",
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold),
                          hintTextDirection: TextDirection.rtl,
                          prefixIcon: Icon(
                            IconlyBroken.call,
                            color: darkGreen,
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: darkGreen, width: 0.8),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: darkGreen, width: 0.8),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: darkGreen, width: 0.8),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(32.0)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.06
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: TextFormField(
                        controller: clerkPasswordController,
                        textDirection: TextDirection.rtl,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: cubit.isPassword,
                        cursorColor: darkGreen,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                            color: darkGreen,
                            fontSize: 12,
                            fontFamily: "Questv",
                            fontWeight: FontWeight.bold),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "يجب ادخال كلمة المرور";
                          } else if (value.length < 6) {
                            return "كلمة المرور يجب ان تكون اكبر من 6 حروف او ارقام";
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: white,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: darkGreen, width: 0.8),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(32.0))),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                          labelText: "كلمة المرور :",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                              color: darkGreen,
                              fontSize: 12,
                              fontFamily: "Questv",
                              fontWeight: FontWeight.bold),
                          floatingLabelStyle: TextStyle(
                              color: darkGreen,
                              fontSize: 12,
                              fontFamily: "Questv",
                              fontWeight: FontWeight.bold),
                          hintStyle: TextStyle(
                              color: darkGreen,
                              fontSize: 12,
                              fontFamily: "Questv",
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold),
                          hintTextDirection: TextDirection.rtl,
                          prefixIcon: Icon(
                            IconlyBroken.password,
                            color: darkGreen,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              cubit.changePasswordVisibility();
                            },
                            icon: Icon(
                              cubit.isPassword
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: darkGreen,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: darkGreen, width: 0.8),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: darkGreen, width: 0.8),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: darkGreen, width: 0.8),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(32.0)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: darkGreen, width: 0.8),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(32.0)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: darkGreen, width: 0.8),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(32.0)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24,),
                    Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.06
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: TextFormField(
                        controller: clerkConfirmPasswordController,
                        textDirection: TextDirection.rtl,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: cubit.isConfirmPassword,
                        cursorColor: darkGreen,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                            color: darkGreen,
                            fontSize: 12,
                            fontFamily: "Questv",
                            fontWeight: FontWeight.bold),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "يجب ادخال كلمة المرور";
                          } else if (value.length < 6) {
                            return "كلمة المرور يجب ان تكون اكبر من 6 حروف او ارقام";
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: white,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: darkGreen, width: 0.8),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(32.0))),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                          labelText: "تأكيد كلمة المرور :",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                              color: darkGreen,
                              fontSize: 12,
                              fontFamily: "Questv",
                              fontWeight: FontWeight.bold),
                          floatingLabelStyle: TextStyle(
                              color: darkGreen,
                              fontSize: 12,
                              fontFamily: "Questv",
                              fontWeight: FontWeight.bold),
                          hintStyle: TextStyle(
                              color: darkGreen,
                              fontSize: 12,
                              fontFamily: "Questv",
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold),
                          hintTextDirection: TextDirection.rtl,
                          prefixIcon: Icon(
                            IconlyBroken.password,
                            color: darkGreen,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              cubit.changeConfirmPasswordVisibility();
                            },
                            icon: Icon(
                              cubit.isConfirmPassword
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: darkGreen,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: darkGreen, width: 0.8),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: darkGreen, width: 0.8),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: darkGreen, width: 0.8),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(32.0)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: darkGreen, width: 0.8),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(32.0)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: darkGreen, width: 0.8),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(32.0)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    InkWell(
                      onTap: () {

                        if (clerkPasswordController.text.toString().isEmpty) {
                          showToast(
                              message: "يجب ادخال كلمة المرور",
                              length: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3);
                          return;
                        }
                        if (clerkPasswordController.text.toString().length < 6) {
                          showToast(
                              message: "كلمة المرور يجب ان تكون اكبر من 6 حروف او ارقام",
                              length: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3);
                          return;
                        }
                        if(clerkPasswordController.text.toString() != clerkConfirmPasswordController.text.toString()){
                          showToast(
                              message: "كلمتا السر يجب ان تكونا متطابقتين",
                              length: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3);
                          return;
                        }
                          cubit.uploadUserFirebase(
                              context,
                              widget.clerkModel.clerkID!,
                              widget.clerkModel.clerkName!,
                              widget.clerkModel.personNumber!,
                              widget.clerkModel.personPhone!,
                              clerkPasswordController.text.toString(),
                              widget.clerkModel.personAddress??"",
                              widget.clerkModel.managementName!,
                              widget.clerkModel.managementID!,
                              widget.clerkModel.managementName!,
                              widget.clerkModel.personTypeName!,
                              widget.clerkModel.rankName!,
                              widget.clerkModel.categoryName!,
                              widget.clerkModel.jobName!,
                              widget.clerkModel.presenceName!,
                              widget.clerkModel.coreStrengthName!);
                      },
                      child: state is! ClerkRegisterLoadingUploadClerksState ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: darkGreen,
                        ),
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: white,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: (Icon(
                                    IconlyBold.arrowRight3,
                                    color: darkGreen,
                                    size:
                                        MediaQuery.of(context).size.width *
                                            0.08,
                                  )),
                                ),
                                height: MediaQuery.of(context).size.height,
                                width:
                                    MediaQuery.of(context).size.width * 0.1,
                              ),
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            Text(
                              "انشاء حساب",
                              style: TextStyle(
                                  color: white,
                                  fontFamily: "Questv",
                                  fontSize: 14),
                            ),
                            const SizedBox(
                              width: 32,
                            ),
                          ],
                        ),
                      ) : Center(child: CircularProgressIndicator(color: darkGreen, strokeWidth: 0.8,),),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
