import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:galleryimage/gallery_Item_model.dart';
import 'package:it_department/modules/Chat/widget/group_chat_UI.dart';
import 'package:open_file/open_file.dart';
import 'package:sizer/sizer.dart';
import 'package:transition_plus/transition_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/components.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/gallery_item_thumbnail.dart';
import '../../../../shared/gallery_item_wrapper_view.dart';
import '../../../Chat/conversation/screens/chat_opened_image_screen.dart';
import '../../../Chat/display/screens/display_chats_screen.dart';
import '../../../Chat/widget/intial.dart';
import '../../../Chat/widget/page_manager.dart';
import '../cubit/group_conversation_cubit.dart';
import '../cubit/group_conversation_states.dart';

class GroupConversationScreen extends StatefulWidget {
  final String groupID;
  final String groupName;
  final String groupImage;
  final String createdBy;
  final List<Object?> adminsList;
  final List<Object?> membersList;
  final String openedFrom;

  const GroupConversationScreen(
      {Key? key,
      required this.groupID,
      required this.groupName,
      required this.groupImage,
      required this.createdBy,
      required this.adminsList,
      required this.membersList,
      required this.openedFrom})
      : super(key: key);

  @override
  State<GroupConversationScreen> createState() =>
      _GroupConversationScreenState();
}

class _GroupConversationScreenState extends State<GroupConversationScreen> {
  List<GalleryItemModel> galleryItems = <GalleryItemModel>[];
  var messageController = TextEditingController();
  late final PageManager _pageManager;

  @override
  void initState() {
    _pageManager = PageManager();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _pageManager.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupConversationCubit()
        ..getUserData(widget.groupName, widget.groupID)
        ..createUserDocumentsDirectory()
        ..createUserRecordingsDirectory()
        ..createUserImagesDirectory()
        ..initRecorder()
        ..getGroupMembers(widget.groupID)
        ..getFireStoreMessage(widget.groupID),
      child: BlocConsumer<GroupConversationCubit, GroupConversationStates>(
        listener: (context, state) {
          if (state is GroupConversationSendMessageErrorState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
          if (state is GroupConversationDownloadFileErrorState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
        },
        builder: (context, state) {
          var cubit = GroupConversationCubit.get(context);

          return WillPopScope(
            onWillPop: () {
              if (widget.openedFrom == "Display") {
                Navigator.pop(context);
              } else {
                finish(context, DisplayChatsScreen(initialIndex: 1));
              }
              return Future.value();
            },
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
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              if (widget.openedFrom == "Display") {
                                Navigator.pop(context);
                              } else {
                                finish(context,
                                    DisplayChatsScreen(initialIndex: 1));
                              }
                            },
                            icon: Transform.scale(
                              scale: 1,
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                          CachedNetworkImage(
                            imageUrl: widget.groupImage,
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
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              color: orangeColor,
                              strokeWidth: 0.8,
                            ),
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
                          const SizedBox(
                            width: 18,
                          ),
                          Flexible(
                            //flex: 3,
                            child: InkWell(
                              onTap: () {
                                cubit.navigateToDetails(
                                    context,
                                    widget.groupID,
                                    widget.groupName,
                                    widget.groupImage,
                                    widget.createdBy,
                                    widget.membersList,
                                    widget.adminsList,
                                    cubit.chatListReversed);
                              },
                              splashColor: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    widget.groupName,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Questv",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 2.0,
                                  ),
                                  Flexible(
                                    child: cubit.gotMembers
                                        ? ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: cubit
                                                .groupMembersNameList.length,
                                            itemBuilder: (context, index) =>
                                                membersNameView(
                                                    cubit, state, index))
                                        : const Text(
                                            "اضغط هنا لتفاصيل الجروب",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 8,
                                                fontFamily: "Questv",
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: Container(
                color: veryLightGreen.withOpacity(0.1),
                child: GroupChatUI(
                  startRecord: () {},
                  sendRecord: () {},
                  deleteRecord: () {},
                  allMessagesWidget: allMessagesWidget(cubit, state),
                  textfield: textField(cubit, widget.groupID),
                  groupID: widget.groupID,
                  groupName: widget.groupName,
                  cubit: cubit,
                  messageController: messageController,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget voiceNote(String urls, String totalDuration, Color progressBarColor,
      Color progressBarSecondColor, Color iconColor, Color fontColor) {
    return BuildCondition(
      condition: urlint == urls,
      builder: (ctx) {
        return VoiceWidget(
          pageManager: _pageManager,
          progressbarColor: progressBarColor,
          progressbarSecondColor: progressBarSecondColor,
          iconColor: iconColor,
          fontColor: fontColor,
        );
      },
      fallback: (ctx) {
        return VoiceConstWidget(
          ff: () {
            setState(() {
              _pageManager.stop();
              _pageManager.dispose();
              _pageManager.url = urls;
              _pageManager.audioPlayer.setUrl(urls);
              _pageManager.init();
              urlint = urls;
            });
            _pageManager.progressNotifier.value = ProgressBarState(
              current: Duration.zero,
              buffered: Duration.zero,
              total: Duration.zero,
            );
          },
          totalDuration: totalDuration,
          progressbarColor: progressBarColor,
          progressbarSecondColor: progressBarSecondColor,
          iconColor: iconColor,
          fontColor: fontColor,
        );
      },
    );
  }

  Widget textField(GroupConversationCubit cubit, String groupID) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 24),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: messageController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                    color: lightGreen, fontFamily: "Questv", fontSize: 14),
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: "رسالتك ... ",
                  hintStyle: TextStyle(
                      color: lightGreen, fontFamily: "Questv", fontSize: 14),
                  hintTextDirection: TextDirection.rtl,
                  border: InputBorder.none,
                ),
                onChanged: (String value) {
                  messageControllerValue.value = value.toString();

                  if (value.isEmpty || value.characters.isEmpty) {
                    print("FIRST CASE\n");
                    cubit.changeUserState("1");
                  } else {
                    print("SECOND CASE\n");
                    cubit.changeUserState("2");
                  }
                },
                onEditingComplete: () {
                  cubit.changeUserState("1");
                },
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              onPressed: () {
                cubit.selectFile(widget.groupID);
              },
              icon: Icon(IconlyBroken.paperUpload, color: lightGreen),
              iconSize: 25,
              constraints: const BoxConstraints(maxWidth: 25),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                cubit.selectImages(context, groupID);
              },
              icon: Icon(IconlyBroken.camera, color: lightGreen),
              iconSize: 25,
              constraints: const BoxConstraints(maxWidth: 25),
            ),
          ],
        ),
      ),
    );
  }

  Widget allMessagesWidget(
      GroupConversationCubit cubit, GroupConversationStates state) {
    return Stack(
      children: [
        SizedBox(
          height: 100.h,
          width: 100.w,
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              child: SvgPicture.asset(
                'assets/images/chat_logo.svg',
                alignment: Alignment.center,
                //width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 56),
          child: BuildCondition(
              condition: state is GroupConversationLoadingMessageState,
              fallback: (context) =>
                  NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overScroll) {
                      overScroll.disallowIndicator();
                      return true;
                    },
                    child: ListView.builder(
                        //physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: cubit.chatListReversed.length,
                        itemBuilder: (context, index) =>
                            chat(context, cubit, index, state)),
                  ),
              builder: (context) => Center(
                    child: CircularProgressIndicator(
                      color: lightGreen,
                    ),
                  )),
        )
      ],
    );
  }

  Widget membersNameView(
      GroupConversationCubit cubit, GroupConversationStates state, int index) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        "${cubit.groupMembersNameList[index].toString()} , ",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 10,
            fontFamily: "Questv",
            fontWeight: FontWeight.w600,
            color: Colors.grey),
      ),
    );
  }

  Widget chat(BuildContext context, GroupConversationCubit cubit, int index,
      GroupConversationStates state) {
    if (cubit.chatListReversed[index].type == "Text") {
      return chatView(context, cubit, index, state);
    } else if (cubit.chatListReversed[index].type == "Image") {
      return galleryImageMessageView(context, cubit, index, state);
    } else if (cubit.chatListReversed[index].type == "Image And Text") {
      return imageAndTextMessageView(context, cubit, index, state);
    } else if (cubit.chatListReversed[index].type == "file") {
      return fileMessageView(cubit, index, state);
    } else {
      return audioConversationManagement2(context, index, cubit);
    }
  }

  Widget chatView(BuildContext context, GroupConversationCubit cubit, int index,
      GroupConversationStates state) {
    if (cubit.chatListReversed[index].type == "Text") {
      return Container(
        color: Colors.transparent,
        padding: cubit.chatListReversed[index].senderID == cubit.userID
            ? const EdgeInsets.only(top: 10, bottom: 10, left: 16)
            : const EdgeInsets.only(top: 10, bottom: 10, right: 16),
        child: Align(
          alignment: (cubit.chatListReversed[index].senderID == cubit.userID
              ? Alignment.topRight
              : Alignment.topLeft),
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  cubit.chatListReversed[index].senderID == cubit.userID
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(14.0),
                          bottomLeft: Radius.circular(14.0),
                          bottomRight: Radius.circular(14.0),
                        )
                      : const BorderRadius.only(
                          topRight: Radius.circular(14.0),
                          bottomLeft: Radius.circular(14.0),
                          bottomRight: Radius.circular(14.0),
                        ),
              color: (cubit.chatListReversed[index].senderID == cubit.userID
                  ? lightGreen.withOpacity(0.75)
                  : white),
            ),
            padding:
                const EdgeInsets.only(top: 6, bottom: 4, right: 12, left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                cubit.chatListReversed[index].senderID != cubit.userID
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          cubit.chatListReversed[index].senderName,
                          style: const TextStyle(
                            fontFamily: "Questv",
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      )
                    : getEmptyWidget(),
                Linkify(
                  onOpen: (link) async {
                    if (await canLaunchUrl(Uri.parse(link.url))) {
                      await launchUrl(Uri.parse(link.url));
                    } else {
                      throw 'Could not launch $link';
                    }
                  },
                  text: cubit.chatListReversed[index].message.toString(),
                  style: TextStyle(
                    color:
                        cubit.chatListReversed[index].senderID == cubit.userID
                            ? Colors.white
                            : Colors.black,
                    fontFamily: "Questv",
                    fontSize: 11.0,
                    overflow: TextOverflow.ellipsis,
                  ),
                  linkStyle: TextStyle(
                    color: Colors.cyanAccent.shade700,
                    fontFamily: "Questv",
                    fontSize: 11.0,
                    overflow: TextOverflow.ellipsis,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  cubit.chatListReversed[index].messageTime,
                  style: TextStyle(
                    fontFamily: "Questv",
                    fontSize: 10,
                    color:
                        cubit.chatListReversed[index].senderID == cubit.userID
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return galleryImageMessageView(context, cubit, index, state);
    }
  }

  Widget imageMessageView(BuildContext context, GroupConversationCubit cubit,
      int index, GroupConversationStates state) {
    if (cubit.chatListReversed[index].type == "Image") {
      return Align(
        alignment: cubit.chatListReversed[index].senderID == cubit.userID
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () {
              openImageFullScreen(context, [cubit.chatListReversed[index].fileName], 0);
            },
            child: Container(
              width: 60.w,
              constraints: BoxConstraints(maxHeight: 36.h, minHeight: 30.h),
              decoration: BoxDecoration(
                  borderRadius:
                      cubit.chatListReversed[index].senderID == cubit.userID
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(14.0),
                              bottomLeft: Radius.circular(14.0),
                              bottomRight: Radius.circular(14.0),
                            )
                          : const BorderRadius.only(
                              topRight: Radius.circular(14.0),
                              bottomLeft: Radius.circular(14.0),
                              bottomRight: Radius.circular(14.0),
                            ),
                  color: (cubit.chatListReversed[index].senderID == cubit.userID
                      ? lightGreen.withOpacity(0.75)
                      : white)),
              child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: cubit.chatListReversed[index].chatImagesModel!
                              .messageImagesList.length !=
                          cubit.chatListReversed[index].imagesCount
                      ? SizedBox(
                          height: 30.h,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: lightGreen,
                            strokeWidth: 0.8,
                          )),
                        )
                      : Column(
                          crossAxisAlignment:
                              cubit.chatListReversed[index].senderID !=
                                      cubit.userID
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            cubit.chatListReversed[index].senderID !=
                                    cubit.userID
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 2.0, top: 4, left: 4, right: 6),
                                    child: Text(
                                      cubit.chatListReversed[index].senderName,
                                      style: const TextStyle(
                                        fontFamily: "Questv",
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                : getEmptyWidget(),
                            Expanded(
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(14.0),
                                          topRight: Radius.circular(14.0),
                                          bottomLeft: Radius.circular(14.0),
                                          bottomRight: Radius.circular(14.0)),
                                      child: CachedNetworkImage(
                                        width: double.infinity,
                                        imageUrl: cubit
                                            .chatListReversed[index]
                                            .chatImagesModel!
                                            .messageImagesList[0]
                                            .toString(),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(14.0),
                                          child: FadeInImage(
                                            fit: BoxFit.cover,
                                            image: imageProvider,
                                            placeholder: const AssetImage(
                                                "assets/images/placeholder.jpg"),
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/images/error.png',
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(
                                          color: lightGreen,
                                          strokeWidth: 0.8,
                                        )),
                                        errorWidget: (context, url, error) =>
                                            const FadeInImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              "assets/images/error.png"),
                                          placeholder: AssetImage(
                                              "assets/images/placeholder.jpg"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 2,
                                    right: 5,
                                    child: Text(
                                      cubit.chatListReversed[index].messageTime,
                                      style: TextStyle(
                                        fontFamily: "Questv",
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ],
                                alignment: Alignment.bottomRight,
                              ),
                            ),
                          ],
                        )),
            ),
          ),
        ),
      );
    } else {
      return imageAndTextMessageView(context, cubit, index, state);
    }
  }

  Widget imageAndTextMessageView(BuildContext context,
      GroupConversationCubit cubit, int index, GroupConversationStates state) {
    if (cubit.chatListReversed[index].type == "Image And Text") {
      return Align(
        alignment: cubit.chatListReversed[index].senderID == cubit.userID
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            width: 60.w,
            decoration: BoxDecoration(
                borderRadius:
                    cubit.chatListReversed[index].senderID == cubit.userID
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(14.0),
                            bottomLeft: Radius.circular(14.0),
                            bottomRight: Radius.circular(14.0),
                          )
                        : const BorderRadius.only(
                            topRight: Radius.circular(14.0),
                            bottomLeft: Radius.circular(14.0),
                            bottomRight: Radius.circular(14.0),
                          ),
                color: (cubit.chatListReversed[index].senderID == cubit.userID
                    ? lightGreen.withOpacity(0.75)
                    : white)),
            child: Column(
              crossAxisAlignment:
                  cubit.chatListReversed[index].senderID != cubit.userID
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: cubit.chatListReversed[index].chatImagesModel!
                                .messageImagesList.length !=
                            cubit.chatListReversed[index].imagesCount
                        ? SizedBox(
                            height: 30.h,
                            child: Center(
                                child: CircularProgressIndicator(
                              color: lightGreen,
                              strokeWidth: 0.8,
                            )),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              cubit.chatListReversed[index].senderID !=
                                      cubit.userID
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 4.0,
                                          top: 2,
                                          left: 4,
                                          right: 4),
                                      child: Text(
                                        cubit
                                            .chatListReversed[index].senderName,
                                        style: const TextStyle(
                                          fontFamily: "Questv",
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  : getEmptyWidget(),
                              cubit.chatListReversed[index].imagesCount == 1
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            ScaleTransition1(
                                                page: ChatOpenedImageScreen(
                                                  imageUrl: cubit
                                                      .chatListReversed[index]
                                                      .fileName,
                                                ),
                                                startDuration: const Duration(
                                                    milliseconds: 1000),
                                                closeDuration: const Duration(
                                                    milliseconds: 600),
                                                type: ScaleTrasitionTypes
                                                    .center));
                                      },
                                      child: ClipRRect(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(14.0),
                                          child: CachedNetworkImage(
                                            width: double.infinity,
                                            height: 29.h,
                                            imageUrl: cubit
                                                .chatListReversed[index]
                                                .chatImagesModel!
                                                .messageImagesList[0]
                                                .toString(),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(14.0),
                                                topRight: Radius.circular(14.0),
                                              ),
                                              child: FadeInImage(
                                                fit: BoxFit.cover,
                                                image: imageProvider,
                                                placeholder: const AssetImage(
                                                    "assets/images/placeholder.jpg"),
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/error.png',
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Center(
                                                    child:
                                                        CircularProgressIndicator(
                                              color: lightGreen,
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
                                        ),
                                      ),
                                    )
                                  : GridView.builder(
                                      primary: false,
                                      itemCount: cubit.chatListReversed[index]
                                                  .imagesCount >
                                              4
                                          ? 4
                                          : cubit.chatListReversed[index]
                                              .imagesCount,
                                      padding: const EdgeInsets.all(6),
                                      semanticChildCount: 1,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 3,
                                      ),
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context,
                                          int imageIndex) {
                                        return cubit.chatListReversed[index]
                                                        .imagesCount >
                                                    4 &&
                                                imageIndex == 3
                                            ? buildImageNumbers(
                                                index, imageIndex, cubit)
                                            : GalleryThumbnail(
                                                galleryItem: cubit
                                                        .chatListReversed[index]
                                                        .chatImagesModel!
                                                        .messageImagesList[
                                                    imageIndex]!,
                                                onTap: () {
                                                  openImageFullScreen(context, cubit
                                                      .chatListReversed[index]
                                                      .chatImagesModel!
                                                      .messageImagesList, imageIndex);
                                                },
                                              );
                                      }),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                child: Linkify(
                                  onOpen: (link) async {
                                    if (await canLaunchUrl(
                                        Uri.parse(link.url))) {
                                      await launchUrl(Uri.parse(link.url));
                                    } else {
                                      throw 'Could not launch $link';
                                    }
                                  },
                                  text: cubit.chatListReversed[index].message
                                      .toString(),
                                  style: TextStyle(
                                    color: cubit.chatListReversed[index]
                                                .senderID ==
                                            cubit.userID
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: "Questv",
                                    fontSize: 11.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  linkStyle: TextStyle(
                                    color: Colors.cyanAccent.shade700,
                                    fontFamily: "Questv",
                                    fontSize: 11.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                child: Text(
                                  cubit.chatListReversed[index].messageTime,
                                  style: TextStyle(
                                    fontFamily: "Questv",
                                    fontSize: 10,
                                    color: cubit.chatListReversed[index]
                                                .senderID ==
                                            cubit.userID
                                        ? white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          )),
              ],
            ),
          ),
        ),
      );
    } else {
      return fileMessageView(cubit, index, state);
    }
  }

  Widget galleryImageMessageView(BuildContext context,
      GroupConversationCubit cubit, int index, GroupConversationStates state) {
    if (cubit.chatListReversed[index].type == "Image" &&
        cubit.chatListReversed[index].chatImagesModel != null) {
      if (cubit.chatListReversed[index].imagesCount > 1) {
        return Align(
          alignment: cubit.chatListReversed[index].senderID == cubit.userID
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
                width: 60.w,
                //height: 300,
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  borderRadius:
                      cubit.chatListReversed[index].senderID == cubit.userID
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(14.0),
                              bottomLeft: Radius.circular(14.0),
                              bottomRight: Radius.circular(14.0),
                            )
                          : const BorderRadius.only(
                              topRight: Radius.circular(14.0),
                              bottomLeft: Radius.circular(14.0),
                              bottomRight: Radius.circular(14.0),
                            ),
                  color: (cubit.chatListReversed[index].senderID == cubit.userID
                      ? lightGreen.withOpacity(0.75)
                      : white),
                ),
                child: cubit.chatListReversed[index].chatImagesModel!
                            .messageImagesList.length ==
                        cubit.chatListReversed[index].imagesCount
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          cubit.chatListReversed[index].senderID != cubit.userID
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 2.0, top: 4, left: 4, right: 8),
                                  child: Text(
                                    cubit.chatListReversed[index].senderName,
                                    style: const TextStyle(
                                      fontFamily: "Questv",
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              : getEmptyWidget(),
                          Stack(
                            children: [
                              GridView.builder(
                                  primary: false,
                                  itemCount: cubit.chatListReversed[index]
                                              .imagesCount >
                                          4
                                      ? 4
                                      : cubit
                                          .chatListReversed[index].imagesCount,
                                  semanticChildCount: 1,
                                  padding: const EdgeInsets.all(6),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 2,
                                    crossAxisSpacing: 2,
                                  ),
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int imageIndex) {
                                    return cubit.chatListReversed[index]
                                                    .imagesCount >
                                                4 &&
                                            imageIndex == 3
                                        ? buildImageNumbers(
                                            index, imageIndex, cubit)
                                        : GalleryThumbnail(
                                            galleryItem: cubit
                                                .chatListReversed[index]
                                                .chatImagesModel!
                                                .messageImagesList[imageIndex]!,
                                            onTap: () {
                                              openImageFullScreen(context, cubit
                                                  .chatListReversed[index]
                                                  .chatImagesModel!
                                                  .messageImagesList, imageIndex);
                                            },
                                          );
                                  }),
                              Positioned(
                                bottom: 5,
                                right: 8,
                                child: Text(
                                  cubit.chatListReversed[index].messageTime,
                                  style: TextStyle(
                                    fontFamily: "Questv",
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 30.h,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: white,
                            strokeWidth: 0.8,
                          ),
                        ),
                      )),
          ),
        );
      } else {
        return imageMessageView(context, cubit, index, state);
      }
    } else {
      return fileMessageView(cubit, index, state);
    }
  }

  Widget buildImageNumbers(
      int index, int imageIndex, GroupConversationCubit cubit) {
    return Stack(
      alignment: AlignmentDirectional.center,
      //fit: StackFit.expand,
      children: <Widget>[
        GalleryThumbnail(
          galleryItem: cubit.chatListReversed[index].chatImagesModel!
              .messageImagesList[imageIndex]!,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(.5),
              borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Text(
              "+ ${cubit.chatListReversed[index].imagesCount - imageIndex}",
              style: TextStyle(color: white, fontSize: 35),
            ),
          ),
        ),
      ],
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

  Widget fileMessageView(
      GroupConversationCubit cubit, int index, GroupConversationStates state) {
    return cubit.chatListReversed[index].type == "file"
        ? Align(
            alignment: cubit.chatListReversed[index].senderID == cubit.userID
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.65, // 45% of total width
                //height: 60,
                decoration: BoxDecoration(
                  borderRadius:
                      cubit.chatListReversed[index].senderID == cubit.userID
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(14.0),
                              bottomLeft: Radius.circular(14.0),
                              bottomRight: Radius.circular(14.0),
                            )
                          : const BorderRadius.only(
                              topRight: Radius.circular(14.0),
                              bottomLeft: Radius.circular(14.0),
                              bottomRight: Radius.circular(14.0),
                            ),
                  color: cubit.chatListReversed[index].senderID == cubit.userID
                      ? lightGreen.withOpacity(0.75)
                      : white,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: cubit.chatListReversed[index].senderID ==
                                cubit.userID
                            ? InkWell(
                                onTap: () {
                                  if (cubit.checkForDocumentFile(
                                      cubit.chatListReversed[index].fileName,
                                      widget.groupName)) {
                                    OpenFile.open(
                                        "/storage/emulated/0/Download/IT Department/${widget.groupName}/Documents/${cubit.chatListReversed[index].fileName}");
                                  } else {
                                    cubit
                                        .downloadDocumentFile(
                                            cubit.chatListReversed[index]
                                                .fileName,
                                            widget.groupName,
                                            widget.groupID)
                                        .then((value) {
                                      OpenFile.open(
                                          "/storage/emulated/0/Download/IT Department/${widget.groupName}/Documents/${cubit.chatListReversed[index].fileName}");
                                    });
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 2, right: 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          BuildCondition(
                                            condition: (cubit
                                                        .downloadingFileName ==
                                                    cubit
                                                        .chatListReversed[index]
                                                        .fileName) ||
                                                (cubit.uploadingFileName ==
                                                    cubit
                                                        .chatListReversed[index]
                                                        .fileName),
                                            fallback: (context) => Icon(
                                              IconlyBroken.document,
                                              color:
                                                  cubit.chatListReversed[index]
                                                              .senderID ==
                                                          cubit.userID
                                                      ? white.withOpacity(0.9)
                                                      : Colors.black,
                                            ),
                                            builder: (context) =>
                                                CircularProgressIndicator(
                                              color:
                                                  cubit.chatListReversed[index]
                                                              .senderID ==
                                                          cubit.userID
                                                      ? white
                                                      : Colors.black,
                                              strokeWidth: 0.8,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              cubit.chatListReversed[index]
                                                  .fileName,
                                              style: TextStyle(
                                                color: cubit
                                                            .chatListReversed[
                                                                index]
                                                            .senderID ==
                                                        cubit.userID
                                                    ? white
                                                    : Colors.black,
                                                fontFamily: "Questv",
                                                fontSize: 11,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          cubit
                                              .chatListReversed[index].fileSize,
                                          style: TextStyle(
                                            fontFamily: "Questv",
                                            fontSize: 10,
                                            color: cubit.chatListReversed[index]
                                                        .senderID ==
                                                    cubit.userID
                                                ? white
                                                : Colors.black,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          cubit.chatListReversed[index]
                                              .messageTime
                                              .toString(),
                                          style: TextStyle(
                                            fontFamily: "Questv",
                                            fontSize: 10,
                                            color: cubit.chatListReversed[index]
                                                        .senderID ==
                                                    cubit.userID
                                                ? white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  if (cubit.checkForDocumentFile(
                                      cubit.chatListReversed[index].fileName,
                                      widget.groupName)) {
                                    OpenFile.open(
                                        "/storage/emulated/0/Download/IT Department/${widget.groupName}/Documents/${cubit.chatListReversed[index].fileName}");
                                  } else {
                                    cubit
                                        .downloadDocumentFile(
                                      cubit.chatListReversed[index].fileName,
                                      widget.groupName,
                                      widget.groupID,
                                    )
                                        .then((value) {
                                      OpenFile.open(
                                          "/storage/emulated/0/Download/IT Department/${widget.groupName}/Documents/${cubit.chatListReversed[index].fileName}");
                                    });
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        cubit
                                            .chatListReversed[index].senderName,
                                        style: const TextStyle(
                                          fontFamily: "Questv",
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          BuildCondition(
                                            condition: (cubit
                                                        .downloadingFileName ==
                                                    cubit
                                                        .chatListReversed[index]
                                                        .fileName) ||
                                                (cubit.uploadingFileName ==
                                                    cubit
                                                        .chatListReversed[index]
                                                        .fileName),
                                            fallback: (context) => Icon(
                                              IconlyBroken.document,
                                              color:
                                                  cubit.chatListReversed[index]
                                                              .senderID ==
                                                          cubit.userID
                                                      ? white
                                                      : Colors.black,
                                            ),
                                            builder: (context) =>
                                                CircularProgressIndicator(
                                              color:
                                                  cubit.chatListReversed[index]
                                                              .senderID ==
                                                          cubit.userID
                                                      ? white
                                                      : Colors.black,
                                              strokeWidth: 0.8,
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4.0),
                                              child: Text(
                                                cubit.chatListReversed[index]
                                                    .fileName,
                                                style: TextStyle(
                                                  color: cubit
                                                              .chatListReversed[
                                                                  index]
                                                              .senderID ==
                                                          cubit.userID
                                                      ? white
                                                      : Colors.black,
                                                  fontFamily: "Questv",
                                                  fontSize: 11,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          cubit
                                              .chatListReversed[index].fileSize,
                                          style: TextStyle(
                                            fontFamily: "Questv",
                                            fontSize: 10,
                                            color: cubit.chatListReversed[index]
                                                        .senderID ==
                                                    cubit.userID
                                                ? white
                                                : Colors.black,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          cubit.chatListReversed[index]
                                              .messageTime
                                              .toString(),
                                          style: TextStyle(
                                            fontFamily: "Questv",
                                            fontSize: 10,
                                            color: cubit.chatListReversed[index]
                                                        .senderID ==
                                                    cubit.userID
                                                ? white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    )),
              ),
            ),
          )
        : audioConversationManagement2(context, index, cubit);
  }

  Widget audioConversationManagement2(BuildContext itemBuilderContext,
      int index, GroupConversationCubit cubit) {
    print("USER IDDDDD ${cubit.userID}\n");
    if (cubit.chatListReversed[index].type == "audio") {
      return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: cubit.chatListReversed[index].senderID == cubit.userID
                  ? EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 8,
                      top: 5.0,
                    )
                  : EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 8,
                      top: 5.0,
                    ),
              alignment: cubit.chatListReversed[index].senderID == cubit.userID
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.zero,
                width: 75.w,
                decoration: BoxDecoration(
                  color: cubit.chatListReversed[index].senderID == cubit.userID
                      ? lightGreen.withOpacity(0.75)
                      : white,
                  borderRadius:
                      cubit.chatListReversed[index].senderID == cubit.userID
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(14.0),
                              bottomLeft: Radius.circular(14.0),
                              bottomRight: Radius.circular(14.0),
                            )
                          : const BorderRadius.only(
                              topRight: Radius.circular(14.0),
                              bottomLeft: Radius.circular(14.0),
                              bottomRight: Radius.circular(14.0),
                            ),
                ),
                child: cubit.chatListReversed[index].senderID == cubit.userID
                    ? Row(
                        children: [
                          Expanded(
                            child: voiceNote(
                                cubit.chatListReversed[index].message,
                                cubit.chatListReversed[index].recordDuration,
                                white,
                                orangeColor,
                                white,
                                white),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            child: CircleAvatar(
                              radius: 23.0,
                              backgroundColor:
                                  cubit.chatListReversed[index].senderID ==
                                          cubit.userID
                                      ? const Color.fromRGBO(60, 80, 100, 1)
                                      : const Color.fromRGBO(102, 102, 255, 1),
                              backgroundImage: const ExactAssetImage(
                                "assets/images/me.jpg",
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    cubit.chatListReversed[index].senderImage,
                                imageBuilder: (context, imageProvider) =>
                                    ClipOval(
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
                                placeholder: (context, url) => Container(
                                  width: 50,
                                  height: 50,
                                  color: lightGreen,
                                ),
                                errorWidget: (context, url, error) =>
                                    const FadeInImage(
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.fill,
                                  image: AssetImage("assets/images/error.png"),
                                  placeholder: AssetImage(
                                      "assets/images/placeholder.jpg"),
                                ),
                              ),
                            ),
                          ), // user image
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4, right: 10, left: 10),
                            child: Row(
                              children: [
                                Text(
                                  cubit
                                      .chatListReversed[index].messageTime,
                                  style: const TextStyle(
                                    fontFamily: "Questv",
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  cubit
                                      .chatListReversed[index].senderName,
                                  style: const TextStyle(
                                    fontFamily: "Questv",
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: voiceNote(
                                    cubit.chatListReversed[index].message,
                                    cubit
                                        .chatListReversed[index].recordDuration,
                                    lightGreen,
                                    orangeColor,
                                    lightGreen,
                                    lightGreen),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: CircleAvatar(
                                  radius: 23.0,
                                  backgroundColor: cubit.chatListReversed[index]
                                              .senderID ==
                                          cubit.userID
                                      ? const Color.fromRGBO(60, 80, 100, 1)
                                      : const Color.fromRGBO(102, 102, 255, 1),
                                  backgroundImage: const ExactAssetImage(
                                    "assets/images/me.jpg",
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: cubit
                                        .chatListReversed[index].senderImage,
                                    imageBuilder: (context, imageProvider) =>
                                        ClipOval(
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
                                    placeholder: (context, url) => Container(
                                      width: 50,
                                      height: 50,
                                      color: white,
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
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      );
    } else {
      return getEmptyWidget();
    }
  }
}
