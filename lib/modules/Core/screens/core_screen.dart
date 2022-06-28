import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Core/cubit/core_cubit.dart';
import 'package:it_department/modules/Core/cubit/core_states.dart';
import 'package:it_department/shared/components.dart';
import 'package:it_department/shared/constants.dart';
import 'package:sizer/sizer.dart' as res;

import '../../Chat/conversation/screens/conversation_screen.dart';

class CoreScreen extends StatelessWidget {
  const CoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoreCubit()..getFilteredClerks(),
      child: BlocConsumer<CoreCubit, CoreStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CoreCubit.get(context);

          return SafeArea(
            child: Scaffold(
              backgroundColor: white,
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: FadeInDown(
                          duration: const Duration(milliseconds: 800),
                          child: Stack(
                            children: [
                              Container(
                                color: lightGreen,
                                height: 0.2.h,
                                width: double.infinity,
                              ),
                              Container(
                                color: white,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                                  child: AutoSizeText(
                                    "قوة إدارة الرقمنة",
                                    style: TextStyle(
                                        color: lightGreen,
                                        backgroundColor: white,
                                        fontSize: 18.sp,
                                        fontFamily: "Questv"),
                                    maxLines: 1,
                                    minFontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      if (cubit.gotClerks) Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: FadeInUp(
                                duration: const Duration(milliseconds: 1800),
                                child: ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cubit.clerksModelList.length,
                                    itemBuilder: (context, index) =>
                                        clerkItem(context, cubit, index)),
                              ),
                      ) else getEmptyWidget(),
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

  Widget clerkItem(BuildContext context,CoreCubit cubit, int index){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: InkWell(
        onTap: ()async {
          await cubit.createChatList(context, cubit.clerksModelList[index].personNumber!);
          print("CLICK ID : ${cubit.chatID}\n");
          /*final page = ConversationScreen(userID: cubit.clerksModelList[index].personNumber!, chatID: cubit.chatID, userName: cubit.clerksModelList[index].clerkName!, userImage: cubit.clerksModelList[index].clerkImage!, userToken: cubit.clerksModelList[index].token!);
          cubit.goToConversation(context, page);*/
        },
        child: Container(
          decoration: BoxDecoration(
            color: lightGreen,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5,
                    color: white,
                  ),
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                  color: white,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                  child: CachedNetworkImage(
                    imageUrl: cubit.clerksModelList[index].clerkImage ?? cubit.publicImage,
                    imageBuilder: (context,
                        imageProvider) =>
                        ClipRRect(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                          child: FadeInImage(
                            height: 12.h,
                            width: 22.w,
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
                                height: 12.h,
                                width: 22.w,
                              );
                            },
                          ),
                        ),
                    placeholder: (context, url) =>
                    FadeInImage(
                      height: 12.h,
                      width: 22.w,
                      fit: BoxFit.fill,
                      image: const AssetImage(
                          "assets/images/placeholder.jpg"),
                      placeholder: const AssetImage(
                          "assets/images/placeholder.jpg"),
                    ),
                    errorWidget:
                        (context, url, error) =>
                    FadeInImage(
                      height: 12.h,
                      width: 22.w,
                      fit: BoxFit.fill,
                      image: const AssetImage(
                          "assets/images/error.png"),
                      placeholder: const AssetImage(
                          "assets/images/placeholder.jpg"),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w,),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cubit.clerksModelList[index].clerkName ?? "",
                      style: TextStyle(
                          color: white,
                          fontFamily: "Questv",
                          fontSize: 10.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Text(cubit.clerksModelList[index].rankName ?? "",
                      style: TextStyle(
                          color: white,
                          fontFamily: "Questv",
                          fontSize: 10.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Text(cubit.clerksModelList[index].jobName ?? "",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Questv",
                          fontSize: 10.sp),
                      //minFontSize: 10,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
