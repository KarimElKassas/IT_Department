import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:it_department/modules/Chat/profile/cubit/chat_profile_cubit.dart';
import 'package:it_department/modules/Chat/profile/cubit/chat_profile_states.dart';
import 'package:it_department/shared/constants.dart';
import 'package:sizer/sizer.dart';

import '../../../../models/chat_model.dart';
import '../../../../shared/components.dart';
import 'dart:math' as math; // import this

class ChatProfileScreen extends StatelessWidget {
  const ChatProfileScreen({
    Key? key,
    required this.userName,
    required this.userImage,
    required this.userPhone,
    required this.userNumber,
    required this.userRank,
    required this.userCategory,
    required this.userDepartment,
    required this.userJob,
    required this.chatList,
  }) : super(key: key);

  final String userName, userImage, userPhone, userNumber, userRank, userCategory, userDepartment, userJob;
  final List<ChatModel> chatList;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatProfileCubit()..filterMedia(chatList),
      child: BlocConsumer<ChatProfileCubit, ChatProfileStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ChatProfileCubit.get(context);

          return Scaffold(
            backgroundColor: lightGreen,
            body: SafeArea(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(
                              onTap: (){

                              },
                              child: Transform.scale(
                                scale: 1,
                                child: Icon(
                                  Icons.arrow_back,
                                  color: white,
                                  size: 32,
                                ),
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: (){

                              },
                              child: Icon(
                                Icons.bug_report,
                                color: white,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12)),
                                color: white
                              ),
                              width: 90.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 50,),
                                  Text(userName, style: TextStyle(color: lightGreen, fontFamily: "Questv", fontSize: 16, fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 6,),
                                  Text(userPhone, style: TextStyle(color: lightGreen, fontFamily: "Questv", fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 3),),
                                  const SizedBox(height: 6,),
                                  Text("$userRank  •  $userDepartment  •  $userJob", style: TextStyle(color: lightGreen, fontFamily: "Questv", fontSize: 14, fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 6,),
                                ],
                              ),
                            ),
                          ),
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
                                                          imageUrl: userImage,
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
                                                  imageUrl: userImage,
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
                              height: 25.w,
                              width: 25.w,
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    //borderRadius: BorderRadius.circular(48),
                                      shape: BoxShape.circle,
                                      color: Colors.white
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  width: MediaQuery.of(context).size.height * 0.07,
                                  child: CachedNetworkImage(
                                    imageUrl: userImage,
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
                        ],
                      ),
                      const SizedBox(height: 4,),
                      InkWell(
                        onTap: () {
                          //cubit.goToMediaGroup(context, widget.groupName);
                        },
                        child: Container(
                          width: 90.w,
                          color: white,
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 7, right: 5, bottom: 6, top: 6),
                                child: InkWell(
                                    onTap: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Text(
                                            'الصور , التسجيلات الصوتيه , الملفات',
                                            style: TextStyle(
                                                color: lightGreen,
                                                fontFamily: "Questv",
                                                fontSize: 12),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${cubit.mediaCount} >',
                                          style: TextStyle(
                                              color: lightGreen,
                                              fontFamily: "Questv",
                                              fontSize: 12),
                                        ),
                                      ],
                                    )),
                              ),
                              SizedBox(
                                height: 110,
                                child: ListView.builder(
                                    physics:
                                    const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: cubit.filteredImagesList.length,
                                    itemBuilder: (ctx, index) {
                                      return Container(
                                        margin:
                                        const EdgeInsets.all(2),
                                        decoration:
                                        const BoxDecoration(
                                          borderRadius:
                                          BorderRadius.all(
                                              Radius.circular(
                                                  8.0)),
                                        ),
                                        width: 100,
                                        //height: 50,
                                        child: CachedNetworkImage(
                                          imageUrl: cubit.filteredImagesList[index].toString(),
                                          imageBuilder: (context,
                                              imageProvider) =>
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    8.0),
                                                child: FadeInImage(
                                                  fit: BoxFit.cover,
                                                  image: imageProvider,
                                                  placeholder:
                                                  const AssetImage(
                                                      "assets/images/placeholder.jpg"),
                                                  imageErrorBuilder:
                                                      (context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                      'assets/images/error.png',
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                              ),
                                          placeholder: (context,
                                              url) =>
                                          const Center(
                                              child:
                                              CircularProgressIndicator(
                                                color: Colors.teal,
                                                strokeWidth: 0.8,
                                              )),
                                          errorWidget:
                                              (context, url, error) =>
                                          const FadeInImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                "assets/images/error.png"),
                                            placeholder: AssetImage(
                                                "assets/images/placeholder.jpg"),
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
