import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/svg.dart';
import 'package:it_department/shared/components.dart';
import 'package:it_department/shared/constants.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

import 'package:transition_plus/transition_plus.dart';

import '../../conversation/screens/conversation_screen.dart';
import '../cubit/display_chats_cubit.dart';
import '../cubit/display_chats_states.dart';


class DisplayChatsScreen extends StatelessWidget {
  const DisplayChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DisplayChatsCubit()..getChats(),
      child: BlocConsumer<DisplayChatsCubit, DisplayChatsStates>(
        listener: (context, state){},
        builder: (context, state){

          var cubit = DisplayChatsCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: lightGreen,
                statusBarIconBrightness: Brightness.dark,
                // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: 0.0,
              toolbarHeight: 0.0,
              backgroundColor: Colors.transparent,
            ),
            body: Container(
              color: lightGreen.withOpacity(0.1),
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                            gradient: LinearGradient(
                              colors: [
                                lightGreen,
                                veryLightGreen
                              ],
                              begin: const Alignment(-2, 0.0),
                              end: const Alignment(1.0, 0.0),
                              // colors: [],
                              // stops: [],
                              transform: const GradientRotation(math.pi / 4),
                              //stops: [0,1],
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      height: MediaQuery.of(context).size.height * 0.05,
                                      child: SvgPicture.asset(
                                        'assets/images/logo_side.svg',
                                        alignment: Alignment.center,
                                        //width: MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                  ),
                                  margin: const EdgeInsets.only(bottom: 16),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(36),
                                      color: Colors.black.withOpacity(0.25)
                                  ),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *0.04,
                                    child: TextFormField(
                                      textDirection: TextDirection.rtl,
                                      //controller: idController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.search,
                                      maxLines: 1,
                                      autovalidateMode: AutovalidateMode.disabled,
                                      autofocus: false,
                                      onChanged: (String value) {
                                        cubit.searchChat(value);
                                      },
                                      cursorColor: white,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'يجب ادخال الرقم القومى / العسكرى !';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (value){
                                        //cubit.getClerks(value);
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          IconlyBroken.search,
                                          color: white,
                                        ),
                                        suffixIcon: Icon(
                                          IconlyBroken.arrowLeft2,
                                          color: white,
                                        ),
                                        counterText: "",
                                        contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                        filled: false,
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32)),
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        disabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32)),
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        errorBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32)),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            )
                                        ),
                                        floatingLabelStyle:
                                        TextStyle(color: lightGreen),
                                        hintText: '',
                                        hintStyle: TextStyle(
                                            fontSize: 12,
                                            color: white,
                                            fontFamily: "Questv",
                                            fontWeight: FontWeight.w500),

                                        fillColor: Colors.black.withOpacity(0.25),
                                        //alignLabelWithHint: true,
                                        errorStyle: TextStyle(
                                            fontSize: 16,
                                            color: orangeColor,
                                            fontFamily: "Questv",
                                            fontWeight: FontWeight.w500),
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                        hintTextDirection: TextDirection.rtl,
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(32),
                                          ),
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: white,
                                          fontFamily: "Questv",
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis),
                                      textAlignVertical: TextAlignVertical.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8,),
                        BuildCondition(
                          condition: state is DisplayChatsLoadingChatsState,
                          builder: (context) => Center(
                            child: CircularProgressIndicator(
                              color: lightGreen,
                              strokeWidth: 0.8,
                            ),
                          ),
                          fallback: (context) => ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) =>
                                listItem(context, cubit, state, index),
                            separatorBuilder: (context, index) =>
                            const Divider(thickness: 0.4,color: Colors.grey,),
                            itemCount: cubit.filteredChatList.length,
                          ),
                        )
                      ],
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

  Widget listItem(BuildContext context ,DisplayChatsCubit cubit , DisplayChatsStates states, int index){

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, ),
      child: InkWell(
        onTap: (){
          cubit.getUserData(context, cubit.filteredChatList[index].userID, cubit.filteredChatList[index].chatID);
        },
        child: Row(
          children: [
            InkWell(
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return SlideInUp(
                          duration: const Duration(milliseconds: 500),
                          child: Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return CachedNetworkImage(
                                            imageUrl: cubit.filteredChatList[index].userImage,
                                            imageBuilder: (context,
                                                imageProvider) =>
                                                ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      0.0),
                                                  child: FadeInImage(
                                                    height: double.infinity,
                                                    width: double.infinity,
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
                                                        height:
                                                        double.infinity,
                                                        width:
                                                        double.infinity,
                                                      );
                                                    },
                                                  ),
                                                ),
                                            placeholder: (context, url) =>
                                            const FadeInImage(
                                              height: double.infinity,
                                              width: double.infinity,
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  "assets/images/placeholder.jpg"),
                                              placeholder: AssetImage(
                                                  "assets/images/placeholder.jpg"),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                            const FadeInImage(
                                              height: double.infinity,
                                              width: double.infinity,
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  "assets/images/error.png"),
                                              placeholder: AssetImage(
                                                  "assets/images/placeholder.jpg"),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: cubit.filteredChatList[index].userImage,
                                    imageBuilder:
                                        (context, imageProvider) =>
                                        ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(12.0),
                                          child: FadeInImage(
                                            height: 400,
                                            width: double.infinity,
                                            fit: BoxFit.fill,
                                            image: imageProvider,
                                            placeholder: const AssetImage(
                                                "assets/images/placeholder.jpg"),
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/images/error.png',
                                                fit: BoxFit.fill,
                                                height: 50,
                                                width: 50,
                                              );
                                            },
                                          ),
                                        ),
                                    placeholder: (context, url) =>
                                    const FadeInImage(
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          "assets/images/placeholder.jpg"),
                                      placeholder: AssetImage(
                                          "assets/images/placeholder.jpg"),
                                    ),
                                    errorWidget: (context, url, error) =>
                                    const FadeInImage(
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          "assets/images/error.png"),
                                      placeholder: AssetImage(
                                          "assets/images/placeholder.jpg"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(48),
                    border: Border.all(color: lightGreen, width: 2),
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
                      imageUrl: cubit.filteredChatList[index].userImage,
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
            ),
            const SizedBox(width: 8,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AutoSizeText(
                        cubit.filteredChatList[index].userName,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Questv",
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                        minFontSize: 10,
                      ),
                      const Spacer(),
                      AutoSizeText(
                        cubit.filteredChatList[index].lastMessageTime,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Questv",
                          fontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textDirection: TextDirection.ltr,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  cubit.filteredChatList[index].lastMessageType == "Text" ? AutoSizeText(
                    cubit.filteredChatList[index].lastMessage,
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
                  ) : getEmptyWidget(),
                  cubit.filteredChatList[index].lastMessageType == "Image" || cubit.filteredChatList[index].lastMessageType == "Image And Text" || cubit.filteredChatList[index].lastMessageType == "file" || cubit.filteredChatList[index].lastMessageType == "audio" ?
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        cubit.filteredChatList[index].lastMessageType == "Image" || cubit.filteredChatList[index].lastMessageType == "Image And Text" ? IconlyBroken.image : cubit.filteredChatList[index].lastMessageType == "file" ? IconlyBroken.document : Icons.mic,
                        color: Colors.grey,),
                      const SizedBox(width: 4,),
                      SizedBox(
                        width: 60.w,
                        child: AutoSizeText(
                          cubit.filteredChatList[index].lastMessage,
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
                      ),
                    ],
                  ) : getEmptyWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
