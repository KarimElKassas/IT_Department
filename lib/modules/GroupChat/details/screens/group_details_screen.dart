import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it_department/modules/GroupChat/details/cubit/group_details_cubit.dart';
import 'package:it_department/modules/GroupChat/details/cubit/group_details_states.dart';
import 'package:it_department/shared/components.dart';
import 'package:it_department/shared/constants.dart';
import 'package:sizer/sizer.dart';

import '../../../../models/group_chat_model.dart';
import '../../../../shared/gallery_item_wrapper_view.dart';
import '../../../Chat/display/screens/display_chats_screen.dart';
import 'group_add_users_screen.dart';
import 'group_media_details_screen.dart';

class GroupDetailsScreen extends StatelessWidget {
  final String groupID, groupName, groupImage, createdBy;
  final List<Object?> membersList, adminsList;
  final List<GroupChatModel> chatList;

  const GroupDetailsScreen(
      {Key? key,
      required this.groupID,
      required this.groupName,
      required this.groupImage,
      required this.createdBy,
      required this.membersList,
      required this.adminsList,
      required this.chatList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupDetailsCubit()
        ..getMyID()
        ..getGroupMembers(groupID)
        ..filterMedia(chatList),
      child: BlocConsumer<GroupDetailsCubit, GroupDetailsStates>(
        listener: (context, state) {

          if(state is GroupDetailsRemoveUserLoadingState || state is GroupDetailsRemoveAdminLoadingState){
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext blurryContext) =>  WillPopScope(
                  onWillPop: () => Future.value(false),
                  child: BlurryProgressDialog(
                    title: "جارى الحذف",
                    titleStyle: TextStyle(color: lightGreen, fontFamily: "Questv", fontWeight: FontWeight.w600),
                    titleMaxLines: 2,
                    titleMaxSize: 14,
                    titleMinSize: 12,
                    blurValue: 0.5,
                  ),
                ));
          }
          if(state is GroupDetailsAddAdminLoadingState){
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext blurryContext) =>  WillPopScope(
                  onWillPop: () => Future.value(false),
                  child: BlurryProgressDialog(
                    title: "جارى الإضافة",
                    titleStyle: TextStyle(color: lightGreen, fontFamily: "Questv", fontWeight: FontWeight.w600),
                    titleMaxLines: 2,
                    titleMaxSize: 14,
                    titleMinSize: 12,
                    blurValue: 0.5,
                  ),
                ));
          }

          if(state is GroupDetailsRemoveUserErrorState){
            Navigator.of(context).pop();
            showToast(message: state.error, length: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 3);
          }
          if(state is GroupDetailsRemoveAdminErrorState){
            Navigator.of(context).pop();
            showToast(message: state.error, length: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 3);
          }
          if(state is GroupDetailsAddAdminErrorState){
            Navigator.of(context).pop();
            showToast(message: state.error, length: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 3);
          }
          if(state is GroupDetailsLeaveGroupSuccessState){
            finish(context, DisplayChatsScreen(initialIndex: 1));
          }
          if(state is GroupDetailsRemoveUserSuccessState || state is GroupDetailsRemoveAdminSuccessState || state is GroupDetailsAddAdminSuccessState){
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          var cubit = GroupDetailsCubit.get(context);

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
                automaticallyImplyLeading: false,
                backgroundColor: veryLightGreen.withOpacity(0.1),
                flexibleSpace: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    child: !cubit.isSearching
                        ? Directionality(
                            textDirection: TextDirection.rtl,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
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
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    cubit.startSearch(context);
                                  },
                                  icon: Icon(
                                    IconlyBroken.search,
                                    color: lightGreen,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : buildSearchField(context, cubit),
                  ),
                ),
              ),
              body: Container(
                color: veryLightGreen.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoSizeText(
                                  groupName,
                                  style: TextStyle(
                                    color: lightGreen,
                                    fontFamily: "Questv",
                                    fontWeight: FontWeight.w600,
                                  ),
                                  minFontSize: 16,
                                  maxLines: 2,
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                AutoSizeText(
                                  "مجموعة . ${cubit.membersCount}  اعضاء ",
                                  style: TextStyle(
                                    color: lightGreen,
                                    fontFamily: "Questv",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8,),
                          InkWell(
                            onTap: () {
                              openImageFullScreen(context, [groupImage], 0);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: white, width: 1),
                                  shape: BoxShape.circle),
                              padding: const EdgeInsets.all(2),
                              child: CachedNetworkImage(
                                imageUrl: groupImage,
                                imageBuilder: (context, imageProvider) =>
                                    ClipOval(
                                  child: FadeInImage(
                                    height: 74,
                                    width: 74,
                                    fit: BoxFit.fill,
                                    image: imageProvider,
                                    placeholder: const AssetImage(
                                        "assets/images/placeholder.jpg"),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/error.png',
                                        fit: BoxFit.fill,
                                        height: 74,
                                        width: 74,
                                      );
                                    },
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(
                                  color: orangeColor,
                                  strokeWidth: 0.8,
                                ),
                                errorWidget: (context, url, error) =>
                                    const FadeInImage(
                                  height: 74,
                                  width: 74,
                                  fit: BoxFit.fill,
                                  image: AssetImage("assets/images/error.png"),
                                  placeholder: AssetImage(
                                      "assets/images/placeholder.jpg"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: Container(
                        width: 100.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(48),
                              topRight: Radius.circular(48)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                cubit.mediaCount != 0
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: AutoSizeText(
                                              "الصور , الملفات , التسجيلات الصوتية : ",
                                              style: TextStyle(
                                                color: lightGreen,
                                                fontFamily: "Questv",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              minFontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          GridView.builder(
                                            primary: false,
                                            itemCount: cubit.filteredMediaList2
                                                        .length >
                                                    6
                                                ? 6
                                                : cubit
                                                    .filteredMediaList2.length,
                                            padding: const EdgeInsets.all(6),
                                            semanticChildCount: 1,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              mainAxisSpacing: 5,
                                              crossAxisSpacing: 5,
                                            ),
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                    int index) =>
                                                gridItem(context, cubit, index),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                        ],
                                      )
                                    : getEmptyWidget(),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: AutoSizeText(
                                        "${cubit.membersCount} اعضاء",
                                        style: TextStyle(
                                          color: lightGreen,
                                          fontFamily: "Questv",
                                          fontSize: 14,
                                          wordSpacing: 2,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        minFontSize: 14,
                                      ),
                                    ),
                                    const Spacer(),
                                    cubit.adminsList.contains(cubit.myID)
                                        ? InkWell(
                                            onTap: () {
                                              cubit.navigate(
                                                  context,
                                                  GroupAddUsersScreen(
                                                    groupMembersList:
                                                        cubit.membersIDList,
                                                    groupMembersAndAdminsList: cubit
                                                        .membersAndAdminsDisplayIDList,
                                                    groupID: groupID,
                                                  ));
                                            },
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(48),
                                                  color: white,
                                                  border: Border.all(
                                                      color: lightGreen)),
                                              child: Icon(
                                                Icons.add_circle,
                                                color: lightGreen,
                                                size: 20,
                                              ),
                                            ),
                                          )
                                        : getEmptyWidget(),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, listIndex) =>
                                      groupListItem(context, cubit, listIndex),
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                    thickness: 0.4,
                                    color: Colors.grey,
                                  ),
                                  itemCount: cubit.filteredClerkList.length,
                                ),
                                Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(24),
                                            topLeft: Radius.circular(24)),
                                        color: veryLightGreen.withOpacity(0.1)),
                                    margin: const EdgeInsets.only(top: 64),
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 24, right: 8, left: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: InkWell(
                                              onTap: () {
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (BuildContext
                                                    mContext) =>
                                                        WillPopScope(
                                                          onWillPop: () => Future.value(false),
                                                          child: BlurryDialog(
                                                            "تنبيه !",
                                                            "هل تريد الخروج من المجموعة ؟",
                                                                () {
                                                              cubit.changeDeleteDialogResult(true);
                                                              Navigator.of(mContext).pop();
                                                            },
                                                                (){
                                                              cubit.changeDeleteDialogResult(false);
                                                              Navigator.of(mContext).pop();
                                                            },
                                                            titleTextStyle:
                                                            TextStyle(
                                                                fontFamily:
                                                                "Questv",
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                                color:
                                                                lightGreen),
                                                            contentTextStyle:
                                                            TextStyle(
                                                                fontFamily:
                                                                "Questv",
                                                                color:
                                                                lightGreen),
                                                            okTextStyle: TextStyle(
                                                                fontFamily:
                                                                "Questv",
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                color: lightGreen),
                                                            noTextStyle: TextStyle(
                                                                fontFamily:
                                                                "Questv",
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                color: lightGreen),
                                                            blurValue: 0.5,
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
                                                        )).then((value){
                                                  if(cubit.deleteDialogResult){
                                                    cubit.leaveGroup(groupID, context);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                //width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(48),
                                                  color: white,
                                                ),
                                                child: Icon(
                                                  Icons.exit_to_app_rounded,
                                                  color: lightGreen,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ), //Leave Group
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: InkWell(
                                              onTap: () {},
                                              child: Container(
                                                //width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(48),
                                                  color: white,
                                                ),
                                                child: Icon(
                                                  Icons.not_interested,
                                                  color: lightGreen,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: InkWell(
                                              onTap: () {},
                                              child: Container(
                                                //width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(48),
                                                  color: white,
                                                ),
                                                child: Icon(
                                                  Icons.lock_rounded,
                                                  color: lightGreen,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: InkWell(
                                              onTap: () {},
                                              child: Container(
                                                //width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(48),
                                                  color: white,
                                                ),
                                                child: Icon(
                                                  Icons.audiotrack_rounded,
                                                  color: lightGreen,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: InkWell(
                                              onTap: () {},
                                              child: Container(
                                                //width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(48),
                                                  color: white,
                                                ),
                                                child: Icon(
                                                  Icons.notifications_rounded,
                                                  color: lightGreen,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void openImageFullScreen(
      BuildContext context, List<dynamic> imagesList, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryImageWrapper(
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

  Widget groupListItem(
      BuildContext context, GroupDetailsCubit cubit, int index) {
    print("Admin List $adminsList\n");

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
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
                                  openImageFullScreen(
                                      context,
                                      [
                                        cubit
                                            .filteredClerkList[index].clerkImage
                                            .toString()
                                      ],
                                      0);
                                },
                                child: CachedNetworkImage(
                                  imageUrl: cubit
                                      .filteredClerkList[index].clerkImage
                                      .toString(),
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
                    imageUrl:
                        cubit.filteredClerkList[index].clerkImage.toString(),
                    imageBuilder: (context, imageProvider) => ClipOval(
                      child: FadeInImage(
                        height: 50,
                        width: 50,
                        fit: BoxFit.fill,
                        image: imageProvider,
                        placeholder:
                            const AssetImage("assets/images/placeholder.jpg"),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/error.png',
                            fit: BoxFit.fill,
                            height: 50,
                            width: 50,
                          );
                        },
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(
                      color: orangeColor,
                      strokeWidth: 0.8,
                    ),
                    errorWidget: (context, url, error) => const FadeInImage(
                      height: 50,
                      width: 50,
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/error.png"),
                      placeholder: AssetImage("assets/images/placeholder.jpg"),
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
            child: InkWell(
              onTap: (){
                showSettingsBottomSheet(context, cubit, index);
              },
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                          cubit.filteredClerkList[index].clerkName.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Questv",
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w600),
                          minFontSize: 8,
                          maxFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      AutoSizeText(
                        cubit.filteredClerkList[index].personPhone.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Questv",
                          overflow: TextOverflow.ellipsis,
                        ),
                        textDirection: TextDirection.ltr,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 8,
                        maxFontSize: 10,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const Spacer(),
                  cubit.adminsList.contains(
                          cubit.filteredClerkList[index].clerkID!.toString())
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              color: white,
                              border: Border.all(color: lightGreen)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          child: Center(
                            child: AutoSizeText(
                              "مسؤول",
                              style: TextStyle(
                                  fontFamily: "Questv",
                                  fontSize: 10,
                                  color: lightGreen),
                              minFontSize: 8,
                            ),
                          ))
                      : getEmptyWidget(),
                  const SizedBox(width: 2,),
                  cubit.adminsList.contains(cubit.myID)
                      ? InkWell(
                          onTap: () {
                            showSettingsBottomSheet(context, cubit, index);
                          },
                          child: const Icon(
                            Icons.more_vert_rounded,
                            color: Colors.black,
                          ),
                  ) : getEmptyWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSettingsBottomSheet(BuildContext context, GroupDetailsCubit cubit, int index){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (sheetContext){
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              color: veryLightGreen.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: (){
                      cubit.isChatExist(context, cubit.filteredClerkList[index].clerkID!, cubit.filteredClerkList[index].clerkName, cubit.filteredClerkList[index].clerkImage!, cubit.filteredClerkList[index].personToken!);
                    },
                    child: Container(
                      constraints: const BoxConstraints(
                          minHeight: 50
                      ),
                      child: Row(
                        children: [
                          const Icon(IconlyBroken.message, color: Colors.black,),
                          const SizedBox(width: 12,),
                          AutoSizeText(
                            "محادثة : ${cubit.filteredClerkList[index].clerkName}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Questv",
                              fontWeight: FontWeight.w600,
                            ),
                            textDirection: TextDirection.rtl,
                            minFontSize: 10,
                            maxLines: 1,
                            maxFontSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(thickness: 0.4, color: Colors.grey,),
                  InkWell(
                    onTap: (){
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext
                        mContext) =>
                            WillPopScope(
                              onWillPop: () => Future.value(false),
                              child: BlurryDialog(
                                "تنبيه !",
                                cubit.adminsList.contains(cubit.filteredClerkList[index].clerkID!) ? "هل تريد حذف ${cubit.filteredClerkList[index].clerkName} من قائمة المسؤولين ؟" : "هل تريد اضافة ${cubit.filteredClerkList[index].clerkName} الى قائمة المسؤولين ؟",
                                    () {
                                  cubit.changeDeleteDialogResult(true);
                                  Navigator.of(mContext).pop();
                                  cubit.adminsList.contains(cubit.filteredClerkList[index].clerkID!) ? cubit.removeAdminFromList(context, groupID, createdBy, cubit.filteredClerkList[index].clerkID!) : cubit.addAdminToList(context, groupID, cubit.filteredClerkList[index].clerkID!);
                                },
                                    (){
                                  cubit.changeDeleteDialogResult(false);
                                  Navigator.of(mContext).pop();
                                },
                                titleTextStyle:
                                TextStyle(
                                    fontFamily:
                                    "Questv",
                                    fontWeight:
                                    FontWeight
                                        .w600,
                                    color:
                                    lightGreen),
                                contentTextStyle:
                                TextStyle(
                                    fontFamily:
                                    "Questv",
                                    color:
                                    lightGreen),
                                okTextStyle: TextStyle(
                                    fontFamily:
                                    "Questv",
                                    fontWeight:
                                    FontWeight.w600,
                                    color: lightGreen),
                                noTextStyle: TextStyle(
                                    fontFamily:
                                    "Questv",
                                    fontWeight:
                                    FontWeight.w600,
                                    color: lightGreen),
                                blurValue: 0.5,
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
                    child: Container(
                      constraints: const BoxConstraints(
                          minHeight: 50
                      ),
                      child: Row(
                        children: [
                          const Icon(IconlyBroken.edit, color: Colors.black,),
                          const SizedBox(width: 12,),
                          AutoSizeText(
                            cubit.adminsList.contains(cubit.filteredClerkList[index].clerkID!) ? "إزالة من المسؤولين" : "تعيين كمسؤول",
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Questv",
                              fontWeight: FontWeight.w600,
                            ),
                            textDirection: TextDirection.rtl,
                            minFontSize: 10,
                            maxLines: 1,
                            maxFontSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(thickness: 0.4, color: Colors.grey,),
                  InkWell(
                    onTap: (){
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext mContext) =>
                            WillPopScope(
                              onWillPop: () => Future.value(false),
                              child: BlurryDialog(
                                "تنبيه !",
                                "هل تريد حذف ${cubit.filteredClerkList[index].clerkName} من المجموعة ؟",
                                    () {
                                  cubit.changeDeleteDialogResult(true);
                                  Navigator.of(mContext).pop();
                                  cubit.removeUserFromGroup(context, groupID, createdBy, cubit.filteredClerkList[index].clerkID!);
                                },
                                    (){
                                  cubit.changeDeleteDialogResult(false);
                                  Navigator.of(mContext).pop();
                                },
                                titleTextStyle:
                                TextStyle(
                                    fontFamily:
                                    "Questv",
                                    fontWeight:
                                    FontWeight
                                        .w600,
                                    color:
                                    lightGreen),
                                contentTextStyle:
                                TextStyle(
                                    fontFamily:
                                    "Questv",
                                    color:
                                    lightGreen),
                                okTextStyle: TextStyle(
                                    fontFamily:
                                    "Questv",
                                    fontWeight:
                                    FontWeight.w600,
                                    color: lightGreen),
                                noTextStyle: TextStyle(
                                    fontFamily:
                                    "Questv",
                                    fontWeight:
                                    FontWeight.w600,
                                    color: lightGreen),
                                blurValue: 0.5,
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
                    child: Container(
                      constraints: const BoxConstraints(
                          minHeight: 50
                      ),
                      child: Row(
                        children: const [
                          Icon(IconlyBroken.delete, color: Colors.black,),
                          SizedBox(width: 12,),
                          AutoSizeText(
                            "حذف من المجموعة",
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
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  Widget gridItem(BuildContext context, GroupDetailsCubit cubit, int index) {
    return InkWell(
      onTap: () {
        cubit.navigate(
            context,
            GroupMediaDetailsScreen(
              initialIndex: cubit.filteredMediaList2[index]["Type"] == "Image"
                  ? 0
                  : (cubit.filteredMediaList2[index]["Type"] == "file" ? 1 : 2),
              groupName: groupName,
              groupID: groupID,
              imagesList: cubit.filteredImagesList,
              filesList: cubit.filteredFilesList,
              recordsList: cubit.filteredRecordsList,
            ));
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            color: lightGreen),
        padding: const EdgeInsets.all(0.5),
        width: 100,
        //height: 50,
        child: cubit.filteredMediaList2[index]["Type"] == "Image"
            ? CachedNetworkImage(
                imageUrl: cubit.filteredMediaList2[index]["URL"].toString(),
                imageBuilder: (context, imageProvider) => ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                    placeholder:
                        const AssetImage("assets/images/placeholder.jpg"),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/error.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                  color: Colors.teal,
                  strokeWidth: 0.8,
                )),
                errorWidget: (context, url, error) => const FadeInImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/error.png"),
                  placeholder: AssetImage("assets/images/placeholder.jpg"),
                ),
              )
            : (cubit.filteredMediaList2[index]["Type"] == "file"
                ? const Icon(
                    Icons.file_copy,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.audiotrack_rounded,
                    color: Colors.white,
                  )),
      ),
    );
  }

  Widget buildSearchField(BuildContext context, GroupDetailsCubit cubit) {
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
                hintText: "ابحث عن شخص ...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontFamily: "Questv",
              ),
              onChanged: (query) => cubit.updateSearchQuery(query),
            ),
          ),
          Expanded(flex: 1, child: _buildActions(context, cubit))
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, GroupDetailsCubit cubit) {
    if (cubit.isSearching) {
      return GestureDetector(
        onTap: () {
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
}
