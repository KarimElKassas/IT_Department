import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it_department/modules/Chat/conversation/screens/conversation_screen.dart';
import 'package:it_department/modules/GroupChat/conversation/screens/group_conversation_screen.dart';
import 'package:it_department/modules/Home/screens/home_screen.dart';
import 'package:it_department/shared/components.dart';
import 'package:it_department/shared/constants.dart';
import 'package:sizer/sizer.dart';

import '../../../GroupChat/create/screens/select_group_users_screen.dart';
import '../cubit/display_chats_cubit.dart';
import '../cubit/display_chats_states.dart';

class DisplayChatsScreen extends StatelessWidget {
  DisplayChatsScreen({Key? key, required this.initialIndex}) : super(key: key);
  int initialIndex;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DisplayChatsCubit()..getChats(),
      child: BlocConsumer<DisplayChatsCubit, DisplayChatsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = DisplayChatsCubit.get(context);

          return WillPopScope(
            onWillPop: (){
              finish(context, const HomeScreen());

              return Future.value();
            },
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: DefaultTabController(
                initialIndex: initialIndex,
                  length: 2,
                  child: Container(
                    height: 100.h,
                    color: veryLightGreen.withOpacity(0.1),
                    child: Scaffold(
                      appBar: AppBar(
                          systemOverlayStyle: const SystemUiOverlayStyle(
                            statusBarColor: Colors.transparent,
                            statusBarIconBrightness: Brightness.dark,
                            // For Android (dark icons)
                            statusBarBrightness:
                                Brightness.light, // For iOS (dark icons)
                          ),
                          elevation: 0.0,
                          automaticallyImplyLeading: false,
                          backgroundColor: veryLightGreen.withOpacity(0.1),
                          title: !cubit.isSearching ? Directionality(
                            textDirection: TextDirection.rtl,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AutoSizeText(
                                  "مشروع مستقبل مصر",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Questv",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                  minFontSize: 14,
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: (){
                                    cubit.startSearch(context);
                                  },
                                  child: const Icon(
                                    IconlyBroken.search,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ) : Builder(
                            builder: (context) {
                              return _buildSearchField(cubit, context);
                            }
                          ),
                          bottom: const TabBar(
                            physics: BouncingScrollPhysics(),
                            indicatorColor: Colors.black,
                            indicatorWeight: 0.8,
                            tabs: [
                              Tab(
                                child: Text('المحادثات',
                                  style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: "Questv"),),
                              ),
                              Tab(
                                child: Text('المجموعات', style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: "Questv"),),
                              ),
                            ],
                          ),
                      ),
                        floatingActionButton: FadeInUp(
                          duration: const Duration(seconds: 1),
                          child: Builder(
                            builder: (context) {
                              return FloatingActionButton(
                                onPressed: () {
                                    if(DefaultTabController.of(context)!.index == 0){
                                      showToast(message: "جاية ف السكة يا حمادة ...", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
                                    }else{
                                      cubit.navigate(context, const SelectGroupUsersScreen());
                                    }
                                },
                                child: const Icon(
                                  Icons.chat_rounded,
                                  color: Colors.white,
                                ),
                                backgroundColor: lightGreen,
                                elevation: 15.0,
                              );
                            }
                          ),
                        ),
                      body: Container(
                        color: veryLightGreen.withOpacity(0.1),
                        child: TabBarView(
                            children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                            child: BuildCondition(
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
                                separatorBuilder: (context, index) => const Divider(
                                  thickness: 0.4,
                                  color: Colors.grey,
                                ),
                                itemCount: cubit.filteredChatList.length,
                              ),
                            ),
                          ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                                child: BuildCondition(
                                  condition: state is DisplayChatsLoadingChatsState,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 0.8,
                                    ),
                                  ),
                                  fallback: (context) => ListView.separated(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, listIndex) =>
                                        groupListItem(context, cubit, state, listIndex),
                                    separatorBuilder: (context, index) => const Divider(
                                      thickness: 0.4,
                                      color: Colors.grey,
                                    ),
                                    itemCount: cubit.filteredGroupList.length,
                                  ),
                                ),
                              ),
                        ]),
                      ),
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchField(DisplayChatsCubit cubit, BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 9,
            child: TextField(
              controller: cubit.searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "ابحث عن محادثة ...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: "Questv",),
              onChanged: (query) => cubit.updateSearchQuery(query, DefaultTabController.of(context)!.index),
            ),
          ),
          Expanded(flex: 1, child: _buildActions(cubit, context))
        ],
      ),
    );
  }

  Widget _buildActions(DisplayChatsCubit cubit, BuildContext context) {
    if (cubit.isSearching) {
      return GestureDetector(
        onTap: (){
          if (cubit.searchController.text.isEmpty) {
            Navigator.pop(context);
            return;
          }
          cubit.clearSearchQuery();
        },
        child: const Icon(Icons.clear, color: Colors.black),
      );
    }
    return getEmptyWidget();
  }

  Widget listItem(BuildContext context, DisplayChatsCubit cubit,
      DisplayChatsStates states, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: InkWell(
        onTap: () {
          cubit.navigate(context,
              ConversationScreen(
                  userID: cubit.filteredChatList[index].userID,
                  chatID: cubit.filteredChatList[index].chatID,
                  userName: cubit.filteredChatList[index].userName,
                  userImage: cubit.filteredChatList[index].userImage,
                  userToken: cubit.filteredChatList[index].userToken,
                  openedFrom: "Display",
              ));
          /*cubit.getUserData(context, cubit.filteredChatList[index].userID,
              cubit.filteredChatList[index].chatID);*/
        },
        child: Row(
          children: [
            InkWell(
              onTap: () {
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
                                            imageUrl: cubit
                                                .filteredChatList[index]
                                                .userImage,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              child: FadeInImage(
                                                height: double.infinity,
                                                width: double.infinity,
                                                fit: BoxFit.fill,
                                                image: imageProvider,
                                                placeholder: const AssetImage(
                                                    "assets/images/placeholder.jpg"),
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/error.png',
                                                    fit: BoxFit.fill,
                                                    height: double.infinity,
                                                    width: double.infinity,
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
                                    imageUrl:
                                        cubit.filteredChatList[index].userImage,
                                    imageBuilder: (context, imageProvider) =>
                                        ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
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
                                      image:
                                          AssetImage("assets/images/error.png"),
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
                    border: Border.all(color: lightGreen, width: 1),
                    shape: BoxShape.circle,
                    color: Colors.transparent),
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.height * 0.07,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        //borderRadius: BorderRadius.circular(48),
                        shape: BoxShape.circle,
                        color: Colors.white),
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.height * 0.07,
                    child: CachedNetworkImage(
                      imageUrl: cubit.filteredChatList[index].userImage,
                      imageBuilder: (context, imageProvider) => ClipOval(
                        child: FadeInImage(
                          height: 50,
                          width: 50,
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
                      placeholder: (context, url) => CircularProgressIndicator(color: orangeColor, strokeWidth: 0.8,),
                      errorWidget: (context, url, error) =>
                      const FadeInImage(
                        height: 50,
                        width: 50,
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/error.png"),
                        placeholder:
                        AssetImage("assets/images/placeholder.jpg"),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
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
                  cubit.filteredChatList[index].lastMessageType == "Text"
                      ? AutoSizeText(
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
                        )
                      : getEmptyWidget(),
                  cubit.filteredChatList[index].lastMessageType == "Image" ||
                          cubit.filteredChatList[index].lastMessageType ==
                              "Image And Text" ||
                          cubit.filteredChatList[index].lastMessageType ==
                              "file" ||
                          cubit.filteredChatList[index].lastMessageType ==
                              "audio"
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              cubit.filteredChatList[index].lastMessageType ==
                                          "Image" ||
                                      cubit.filteredChatList[index]
                                              .lastMessageType ==
                                          "Image And Text"
                                  ? IconlyBroken.image
                                  : cubit.filteredChatList[index]
                                              .lastMessageType ==
                                          "file"
                                      ? IconlyBroken.document
                                      : Icons.mic,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
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
                        )
                      : getEmptyWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget groupListItem(BuildContext context, DisplayChatsCubit cubit,
      DisplayChatsStates states, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: InkWell(
        onTap: () {
          cubit.navigate(context,
              GroupConversationScreen(
                  groupID: cubit.filteredGroupList[index].groupID,
                  groupName: cubit.filteredGroupList[index].groupName,
                  groupImage: cubit.filteredGroupList[index].groupImage,
                  adminsList: cubit.filteredGroupList[index].adminsList,
                  membersList: cubit.filteredGroupList[index].membersList,
                  openedFrom: "Display",
              ));
        },
        child: Row(
          children: [
            InkWell(
              onTap: () {
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
                                            imageUrl: cubit
                                                .filteredGroupList[index]
                                                .groupImage,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(0.0),
                                                  child: FadeInImage(
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    fit: BoxFit.fill,
                                                    image: imageProvider,
                                                    placeholder: const AssetImage(
                                                        "assets/images/placeholder.jpg"),
                                                    imageErrorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                        'assets/images/error.png',
                                                        fit: BoxFit.fill,
                                                        height: double.infinity,
                                                        width: double.infinity,
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
                                    imageUrl:
                                    cubit.filteredGroupList[index].groupImage,
                                    imageBuilder: (context, imageProvider) =>
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12.0),
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
                                      image:
                                      AssetImage("assets/images/error.png"),
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
                    border: Border.all(color: lightGreen, width: 1),
                    shape: BoxShape.circle,
                    color: Colors.transparent),
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.height * 0.07,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      //borderRadius: BorderRadius.circular(48),
                        shape: BoxShape.circle,
                        color: Colors.white),
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.height * 0.07,
                    child: CachedNetworkImage(
                      imageUrl: cubit.filteredGroupList[index].groupImage,
                      imageBuilder: (context, imageProvider) => ClipOval(
                        child: FadeInImage(
                          height: 50,
                          width: 50,
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
                      placeholder: (context, url) => CircularProgressIndicator(color: orangeColor, strokeWidth: 0.8,),
                      errorWidget: (context, url, error) =>
                      const FadeInImage(
                        height: 50,
                        width: 50,
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/error.png"),
                        placeholder:
                        AssetImage("assets/images/placeholder.jpg"),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AutoSizeText(
                        cubit.filteredGroupList[index].groupName,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Questv",
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                        minFontSize: 10,
                      ),
                      const Spacer(),
                      AutoSizeText(
                        cubit.filteredGroupList[index].lastMessageTime,
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
                  cubit.filteredGroupList[index].lastMessageType == "Text"
                      ? AutoSizeText(
                    cubit.filteredGroupList[index].lastMessage,
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
                  )
                      : getEmptyWidget(),
                  cubit.filteredGroupList[index].lastMessageType == "Image" ||
                      cubit.filteredGroupList[index].lastMessageType ==
                          "Image And Text" ||
                      cubit.filteredGroupList[index].lastMessageType ==
                          "file" ||
                      cubit.filteredGroupList[index].lastMessageType ==
                          "audio"
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        cubit.filteredGroupList[index].lastMessageType ==
                            "Image" ||
                            cubit.filteredGroupList[index]
                                .lastMessageType ==
                                "Image And Text"
                            ? IconlyBroken.image
                            : cubit.filteredGroupList[index]
                            .lastMessageType ==
                            "file"
                            ? IconlyBroken.document
                            : Icons.mic,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      SizedBox(
                        width: 60.w,
                        child: AutoSizeText(
                          cubit.filteredGroupList[index].lastMessage,
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
                  )
                      : getEmptyWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
