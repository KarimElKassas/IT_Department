import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Core/cubit/core_cubit.dart';
import 'package:it_department/modules/Core/cubit/core_states.dart';
import 'package:it_department/shared/components.dart';
import 'package:it_department/shared/constants.dart';

import '../../Chat/screens/conversation_screen.dart';

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
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: FadeInDown(
                          duration: const Duration(milliseconds: 800),
                          child: Stack(
                            children: [
                              Container(
                                color: lightGreen,
                                height: MediaQuery.of(context).size.height * 0.008,
                                width: double.infinity,
                              ),
                              Container(
                                color: white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: AutoSizeText(
                                    "قوة إدارة الرقمنة",
                                    style: TextStyle(
                                        color: lightGreen,
                                        backgroundColor: white,
                                        fontSize: 24,
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
                      const SizedBox(
                        height: 18,
                      ),
                      if (cubit.gotClerks) Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: FadeInUp(
                                duration: const Duration(milliseconds: 1800),
                                child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: InkWell(
        onTap: ()async {
          await cubit.createChatList(context, cubit.clerksModelList[index].personNumber!);
          print("CLICK ID : ${cubit.chatID}\n");
          cubit.goToConversation(context, ConversationScreen(userID: cubit.clerksModelList[index].personNumber!, chatID: cubit.chatID, userName: cubit.clerksModelList[index].clerkName!, userImage: cubit.clerksModelList[index].clerkImage!, userToken: cubit.clerksModelList[index].token!));
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
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.22,
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
                                height: MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 0.22,
                              );
                            },
                          ),
                        ),
                    placeholder: (context, url) =>
                    FadeInImage(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.22,
                      fit: BoxFit.fill,
                      image: const AssetImage(
                          "assets/images/placeholder.jpg"),
                      placeholder: const AssetImage(
                          "assets/images/placeholder.jpg"),
                    ),
                    errorWidget:
                        (context, url, error) =>
                    FadeInImage(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.2,
                      fit: BoxFit.fill,
                      image: const AssetImage(
                          "assets/images/error.png"),
                      placeholder: const AssetImage(
                          "assets/images/placeholder.jpg"),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8,),
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
                          fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(cubit.clerksModelList[index].rankName ?? "",
                      style: TextStyle(
                          color: white,
                          fontFamily: "Questv",
                          fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(cubit.clerksModelList[index].jobName ?? "",
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Questv",
                          fontSize: 12),
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
