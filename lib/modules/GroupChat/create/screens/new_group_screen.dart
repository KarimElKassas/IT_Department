import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it_department/shared/constants.dart';
import 'package:sizer/sizer.dart';

import '../../../../models/firebase_clerk_model.dart';
import '../../../../shared/components.dart';
import '../cubit/new_group_cubit.dart';
import '../cubit/new_group_states.dart';

class NewGroupScreen extends StatefulWidget {

  final List<ClerkFirebaseModel> selectedUsersList;

  const NewGroupScreen({Key? key, required this.selectedUsersList}) : super(key: key);

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  var groupNameController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewGroupCubit()..getUsers(),
      child: BlocConsumer<NewGroupCubit, NewGroupStates>(
        listener: (context, state) {

          if(state is NewGroupCreateGroupSuccessState){
            showToast(message: "تم انشاء الجروب بنجاح", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
          }
          if(state is NewGroupCreateGroupErrorState){
            showToast(message: state.error, length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
          }
        },
        builder: (context, state) {
          var cubit = NewGroupCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                  // For Android (dark icons)
                  statusBarBrightness: Brightness.light, // For iOS (dark icons)
                ),
                elevation: 0,
                backgroundColor: veryLightGreen.withOpacity(0.1),
                automaticallyImplyLeading: false,
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      InkWell(onTap: (){Navigator.pop(context);}, child: const Icon(Icons.arrow_back_rounded, color: Colors.black,)),
                      const SizedBox(width: 12,),
                      const AutoSizeText(
                        "•  اضافة بيانات المجموعة",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Questv",
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        minFontSize: 14,
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FadeInUp(
                duration: const Duration(seconds: 1),
                child: BuildCondition(
                  condition: state is NewGroupLoadingCreateGroupState,
                  builder: (context) => const CircularProgressIndicator(color: Colors.teal, strokeWidth: 0.8,),
                  fallback: (context) => FloatingActionButton(
                    onPressed: () {
                      if(formKey.currentState!.validate()){
                        if(!cubit.emptyImage){
                          cubit.createGroup(context,groupNameController.text.toString());
                        }else{
                          showToast(message: "يجب اختيار صورة الجروب", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
                        }
                      }
                    },
                    child: const Icon(
                      Icons.done_rounded,
                      color: Colors.white,
                    ),
                    backgroundColor: lightGreen,
                    elevation: 15.0,
                  ),
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
              body: Container(
                height: 100.h,
                color: veryLightGreen.withOpacity(0.1),
                child: Form(
                  key: formKey,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SafeArea(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0, top: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: (){
                                        cubit.selectImage();
                                      },
                                      child: SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: CircleAvatar(
                                          radius: 20,
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(32.0),
                                                topRight: Radius.circular(32.0),
                                                bottomLeft: Radius.circular(32.0),
                                                bottomRight: Radius.circular(32.0)),
                                            child: BuildCondition(
                                              condition: cubit.emptyImage == true,
                                              builder: (context) => CircleAvatar(
                                                child: const Icon(
                                                  IconlyBroken.image2,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                backgroundColor: Colors.grey.shade500,
                                                maxRadius: 60,
                                              ),
                                              fallback: (context) => SizedBox(
                                                width: 60,
                                                height: 60,
                                                child: Image.file(
                                                  File(cubit.imageUrl),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      textDirection: TextDirection.rtl,
                                      controller: groupNameController,
                                      keyboardType: TextInputType.text,
                                      maxLines: 1,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'يجب ادخال اسم الجروب';
                                        }
                                      },
                                      autofocus: false,
                                      style: const TextStyle(color: Colors.black, fontFamily: "Questv", fontSize: 14),
                                      decoration: InputDecoration(
                                        focusedBorder:  UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: lightGreen, width: 1.0),
                                        ),
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                        labelText: 'اسم الجروب',
                                        labelStyle: TextStyle(color: Colors.grey.shade500, fontFamily: "Questv", fontSize: 14),
                                        alignLabelWithHint: true,
                                        hintTextDirection: TextDirection.rtl,
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: lightGreen, width: 1.0),
                                        ),
                                        disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: lightGreen, width: 1.0),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: lightGreen, width: 1.0),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: AutoSizeText(
                                "•  اعضاء المجموعة :",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Questv",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                minFontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            BuildCondition(
                              condition: state is NewGroupLoadingUsersState,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 0.8,
                                ),
                              ),
                              fallback: (context) => ListView.separated(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) =>
                                    listItem(context, cubit, state, index),
                                separatorBuilder: (context, index) =>
                                const Divider(thickness: 0.8),
                                itemCount: widget.selectedUsersList.length,
                              ),
                            ),
                          ],
                        ),
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

  Widget listItem(BuildContext context, NewGroupCubit cubit, state, int index) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                //borderRadius: BorderRadius.circular(48),
                  border: Border.all(color: Colors.black, width: 0),
                  shape: BoxShape.circle,
                  color: Colors.transparent
              ),
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.height * 0.07,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: const BoxDecoration(
                    //borderRadius: BorderRadius.circular(48),
                      shape: BoxShape.circle,
                      color: Colors.white
                  ),
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.height * 0.07,
                  child: CachedNetworkImage(
                    imageUrl: widget.selectedUsersList[index].clerkImage!,
                    imageBuilder: (context,
                        imageProvider) =>
                        ClipRRect(
                          borderRadius: BorderRadius.circular(96),
                          child: FadeInImage(
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: MediaQuery.of(context).size.height * 0.07,
                            //height: double.infinity,
                            //width: double.infinity,
                            fit: BoxFit.fill,
                            image: imageProvider,
                            placeholder: const AssetImage(
                                "assets/images/placeholder.jpg"),
                            imageErrorBuilder:
                                (context, error,
                                stackTrace) {
                              return Image.asset(
                                'assets/images/error.png',
                                fit: BoxFit.fill,
                                height: MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.height * 0.07,
                              );
                            },
                          ),
                        ),
                    placeholder: (context, url) =>
                        FadeInImage(
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.height * 0.07,
                          fit: BoxFit.fill,
                          image: const AssetImage(
                              "assets/images/placeholder.jpg"),
                          placeholder: const AssetImage(
                              "assets/images/placeholder.jpg"),
                        ),
                    errorWidget:
                        (context, url, error) =>
                        FadeInImage(
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.height * 0.07,
                          fit: BoxFit.fill,
                          image: const AssetImage(
                              "assets/images/error.png"),
                          placeholder: const AssetImage(
                              "assets/images/placeholder.jpg"),
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    widget.selectedUsersList[index].clerkName,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Questv",
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                    minFontSize: 10,
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  AutoSizeText(
                    widget.selectedUsersList[index].clerkCategoryName!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontFamily: "Questv",
                      fontSize: 10,
                      fontWeight: FontWeight.w200,
                      overflow: TextOverflow.ellipsis,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    minFontSize: 10,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
