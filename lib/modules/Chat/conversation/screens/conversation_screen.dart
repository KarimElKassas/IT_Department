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
import 'package:it_department/modules/Chat/profile/screens/chat_profile_screen.dart';
import 'package:it_department/modules/Chat/widget/chat_UI.dart';
import 'package:it_department/modules/Chat/widget/intial.dart';
import 'package:open_file/open_file.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:transition_plus/transition_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/components.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/gallery_item_thumbnail.dart';
import '../../../../shared/gallery_item_wrapper_view.dart';
import '../../display/screens/display_chats_screen.dart';
import 'chat_opened_image_screen.dart';
import '../../widget/page_manager.dart';
import '../cubit/conversation_cubit.dart';
import '../cubit/conversation_states.dart';

class ConversationScreen extends StatefulWidget {
  final String userID;
  final String chatID;
  final String userName;
  final String userImage;
  final String userToken;

   const ConversationScreen(
      {Key? key,
      required this.userID,
      required this.chatID,
      required this.userName,
      required this.userImage,
      required this.userToken,
      })
      : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
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
      create: (context) => ConversationCubit()
        ..getChatData(widget.userID, widget.userName, widget.userImage, widget.userToken, widget.chatID)
        ..createUserImagesDirectory()
        ..createUserDocumentsDirectory()
        ..createUserRecordingsDirectory()
        ..initRecorder()
        ..initPageManager()
        ..getChatInfo(widget.chatID)
        ..getFireStoreMessage(widget.userID, widget.chatID),
      child: BlocConsumer<ConversationCubit, ConversationStates>(
        listener: (context, state) {
          if (state is ConversationDownloadFileErrorState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
          if(state is ConversationSendMessageState){
            messageController.text = "";
          }
        },
        builder: (context, state) {
          var cubit = ConversationCubit.get(context);
          return WillPopScope(
            onWillPop: (){
              finish(context, DisplayChatsScreen(initialIndex: 0));

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
                backgroundColor: veryLightGreen.withOpacity(0.1),
                automaticallyImplyLeading: false,
                flexibleSpace: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              finish(context, DisplayChatsScreen(initialIndex: 0));
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
                            imageUrl: widget.userImage,
                            imageBuilder: (context, imageProvider) => ClipOval(
                              child: FadeInImage(
                                height: 50,
                                width: 50,
                                fit: BoxFit.fill,
                                image: imageProvider,
                                placeholder: const AssetImage(
                                    "assets/images/placeholder.jpg"),
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
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              color: lightGreen,
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
                            child: InkWell(
                              onTap: () {
                                cubit.navigate(context, ChatProfileScreen(
                                    chatID: widget.chatID,
                                    userName: widget.userName,
                                    userImage: widget.userImage,
                                    userNumber: widget.userID,
                                    chatList: cubit.chatListReversed,
                                ));
                              },
                              splashColor: Colors.transparent,
                              child: Text(
                                widget.userName,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Questv",
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
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
                child: ChatUI(
                  startRecord: () {},
                  sendRecord: () {},
                  deleteRecord: () {},
                  allMessagesWidget: allMessagesWidget(cubit, state),
                  textfield:
                  textField(cubit, widget.userID, widget.userToken, widget.userName, widget.userImage, widget.chatID),
                  receiverID: widget.userID,
                  receiverName: widget.userName,
                  receiverImage: widget.userImage,
                  chatID: widget.chatID,
                  receiverToken: widget.userToken,
                  cubit: cubit,
                  messageController: messageController,),),
            ),
          );
        },
      ),
    );
  }

  Widget voiceNote (String urls, String totalDuration){
    return BuildCondition(
      condition: urlint==urls,
      builder: (ctx){

        return VoiceWidget(pageManager: _pageManager)  ;
      },
      fallback: (ctx){
        return  VoiceConstWidget(
          ff: () {
            setState(() {
              _pageManager.stop();
              _pageManager.dispose();
              _pageManager.url=urls;
              _pageManager.audioPlayer.setUrl(urls);
              _pageManager.init();
              urlint = urls ;
            });
            _pageManager.progressNotifier.value = ProgressBarState(
              current: Duration.zero,
              buffered: Duration.zero,
              total:  Duration.zero,
            );
          },
        totalDuration: totalDuration,);
      },
    ) ;
  }

  Widget textField(ConversationCubit cubit, String userID, String userToken, String userName, String userImage, String chatID) {
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
                    cubit.changeUserState("1", userID);
                  } else {
                    print("SECOND CASE\n");
                    cubit.changeUserState("2", userID);
                  }
                },
                onEditingComplete: () {
                  cubit.changeUserState("1", userID);
                },
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              onPressed: () {
                cubit.selectFile(userID, chatID);
              },
              icon: Icon(IconlyBroken.paperUpload, color: lightGreen),
              iconSize: 25,
              constraints: const BoxConstraints(maxWidth: 25),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                cubit.selectImages(context, userID, userToken, userName, userImage, chatID);
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

  Widget allMessagesWidget(ConversationCubit cubit, ConversationStates state) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
              condition: state is ConversationLoadingMessageState,
              fallback: (context) =>
                  NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overScroll) {
                      overScroll.disallowIndicator();
                      return true;
                    },
                    child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
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

  Widget chat(BuildContext context, ConversationCubit cubit, int index,
      ConversationStates state){

    if(cubit.chatListReversed[index].type == "Text"){
      return chatView(context, cubit, index, state);
    }else if (cubit.chatListReversed[index].type == "Image"){
      return galleryImageMessageView(context, cubit, index, state);
    }else if(cubit.chatListReversed[index].type == "Image And Text"){
      return imageAndTextMessageView(context, cubit, index, state);
    }else if (cubit.chatListReversed[index].type == "file"){
      return fileMessageView(cubit, index, state);
    }else{
      return audioConversationManagement2(context, index, cubit);
    }

  }
  Widget chatView(BuildContext context, ConversationCubit cubit, int index,
      ConversationStates state) {
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
                const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
                  height: 8.0,
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

  Widget imageMessageView(BuildContext context, ConversationCubit cubit,
      int index, ConversationStates state) {
    if (cubit.chatListReversed[index].type == "Image") {
      return Align(
        alignment: cubit.chatListReversed[index].senderID == cubit.userID
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  ScaleTransition1(
                      page: ChatOpenedImageScreen(
                        imageUrl: cubit.chatListReversed[index].fileName,
                      ),
                      startDuration: const Duration(milliseconds: 1000),
                      closeDuration: const Duration(milliseconds: 600),
                      type: ScaleTrasitionTypes.bottomRight));
            },
            child: Container(
              width: 60.w,
              height: 30.h,
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
                                  height: 29.h,
                                  imageUrl: cubit.chatListReversed[index]
                                      .chatImagesModel!.messageImagesList[0]
                                      .toString(),
                                  imageBuilder: (context, imageProvider) =>
                                      ClipRRect(
                                    borderRadius: BorderRadius.circular(14.0),
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
                                    image:
                                        AssetImage("assets/images/error.png"),
                                    placeholder: AssetImage(
                                        "assets/images/placeholder.jpg"),
                                  ),
                                ),
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

  Widget imageAndTextMessageView(BuildContext context, ConversationCubit cubit,
      int index, ConversationStates state) {
    if (cubit.chatListReversed[index].type == "Image And Text") {
      return Align(
        alignment: cubit.chatListReversed[index].senderID == cubit.userID
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  ScaleTransition1(
                      page: ChatOpenedImageScreen(
                        imageUrl: cubit.chatListReversed[index].fileName,
                      ),
                      startDuration: const Duration(milliseconds: 1000),
                      closeDuration: const Duration(milliseconds: 600),
                      type: ScaleTrasitionTypes.bottomRight));
            },
            child: Container(
              width: 60.w,
              //height: 30.h,
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
                cubit.chatListReversed[index].senderID !=
                    cubit.userID
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
                          cubit.chatListReversed[index].imagesCount == 1 ?
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
                                height: 29.h,
                                imageUrl: cubit.chatListReversed[index]
                                    .chatImagesModel!.messageImagesList[0]
                                    .toString(),
                                imageBuilder: (context, imageProvider) =>
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14.0),
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
                                  image:
                                  AssetImage("assets/images/error.png"),
                                  placeholder: AssetImage(
                                      "assets/images/placeholder.jpg"),
                                ),
                              ),
                            ),
                          ) : GridView.builder(
                              primary: false,
                              itemCount:
                              cubit.chatListReversed[index].imagesCount > 4
                                  ? 4
                                  : cubit.chatListReversed[index].imagesCount,
                              padding: const EdgeInsets.all(6),
                              semanticChildCount: 1,
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 3,
                              ),
                              shrinkWrap: true,
                              itemBuilder:
                                  (BuildContext context, int imageIndex) {
                                return cubit.chatListReversed[index].imagesCount >
                                    4 &&
                                    imageIndex == 3
                                    ? buildImageNumbers(index, imageIndex, cubit)
                                    : GalleryThumbnail(
                                  galleryItem: cubit
                                      .chatListReversed[index]
                                      .chatImagesModel!
                                      .messageImagesList[imageIndex]!,
                                  onTap: () {
                                    openImageFullScreen(
                                        index, imageIndex, cubit);
                                  },
                                );
                              }) ,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            child: Linkify(
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
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return fileMessageView(cubit, index, state);
    }
  }

  Widget galleryImageMessageView(BuildContext context, ConversationCubit cubit,
      int index, ConversationStates state) {
    if (cubit.chatListReversed[index].type == "Image" &&
        cubit.chatListReversed[index].chatImagesModel != null) {
      if (cubit.chatListReversed[index].imagesCount > 1) {
        return Align(
              alignment: cubit.chatListReversed[index].senderID == cubit.userID
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  // 45% of total width
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
                    color:
                        (cubit.chatListReversed[index].senderID == cubit.userID
                            ? lightGreen.withOpacity(0.75)
                            : white),
                  ),
                  child: cubit.chatListReversed[index].chatImagesModel!
                      .messageImagesList.length ==
                      cubit.chatListReversed[index].imagesCount
                      ? GridView.builder(
                      primary: false,
                      itemCount:
                      cubit.chatListReversed[index].imagesCount > 4
                          ? 4
                          : cubit.chatListReversed[index].imagesCount,
                      padding: const EdgeInsets.all(6),
                      semanticChildCount: 1,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 3,
                      ),
                      shrinkWrap: true,
                      itemBuilder:
                          (BuildContext context, int imageIndex) {
                        return cubit.chatListReversed[index].imagesCount >
                            4 &&
                            imageIndex == 3
                            ? buildImageNumbers(index, imageIndex, cubit)
                            : GalleryThumbnail(
                          galleryItem: cubit
                              .chatListReversed[index]
                              .chatImagesModel!
                              .messageImagesList[imageIndex]!,
                          onTap: () {
                            openImageFullScreen(
                                index, imageIndex, cubit);
                          },
                        );
                      })
                      : SizedBox(
                    height: 10.h,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: white,
                        strokeWidth: 0.8,
                      ),
                    ),
                  )

                ),
              ),
            );
      } else {
        return imageMessageView(context, cubit, index, state);
      }
    } else {
      return fileMessageView(cubit, index, state);
    }
  }

  Widget buildImageNumbers(int index, int imageIndex, ConversationCubit cubit) {
    return Stack(
      alignment: AlignmentDirectional.center,
      //fit: StackFit.expand,
      children: <Widget>[
        GalleryThumbnail(
          galleryItem: cubit.chatListReversed[index].chatImagesModel!
              .messageImagesList[imageIndex]!,
        ),
        Container(
          color: Colors.black.withOpacity(.5),
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
      final int indexOfMessage, int indexOfImage, ConversationCubit cubit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryImageWrapper(
          titleGallery: "",
          galleryItems: cubit.chatListReversed[indexOfMessage].chatImagesModel!
              .messageImagesList,
          backgroundDecoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(4)),
          initialIndex: indexOfImage,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget fileMessageView(
      ConversationCubit cubit, int index, ConversationStates state) {
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
                                      cubit.chatListReversed[index].fileName)) {
                                    OpenFile.open(
                                        "/storage/emulated/0/Download/IT Department/Documents/${cubit.chatListReversed[index].fileName}");
                                  } else {
                                    cubit
                                        .downloadDocumentFile(
                                            widget.userID,
                                            widget.chatID,
                                            cubit.chatListReversed[index]
                                                .fileName)
                                        .then((value) {
                                      OpenFile.open(
                                          "/storage/emulated/0/Download/IT Department/Documents/${cubit.chatListReversed[index].fileName}");
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
                                      cubit.chatListReversed[index].fileName)) {
                                    OpenFile.open(
                                        "/storage/emulated/0/Download/IT Department/Documents/${cubit.chatListReversed[index].fileName}");
                                  } else {
                                    cubit
                                        .downloadDocumentFile(
                                            widget.userID,
                                            widget.chatID,
                                            cubit.chatListReversed[index]
                                                .fileName)
                                        .then((value) {
                                      OpenFile.open(
                                          "/storage/emulated/0/Download/IT Department/Documents/${cubit.chatListReversed[index].fileName}");
                                    });
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
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
                                              padding: const EdgeInsets.only(right: 4.0),
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

  Widget audioConversationManagement(
      BuildContext itemBuilderContext, int index, ConversationCubit cubit) {
    return cubit.chatListReversed[index].type == "audio" ? Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onLongPress: () async {},
            child: Container(
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
                //height: 70.0,
                width: 250.0,
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
                          const SizedBox(
                            width: 4.0,
                          ),
                          GestureDetector(
                            onLongPress: () =>
                                cubit.chatMicrophoneOnLongPressAction(),
                            onTap: () {
                              if (cubit.chatListReversed[index].senderID ==
                                  cubit.userID) {
                                if (cubit.checkForAudioFile(
                                    cubit.chatListReversed[index].fileName)) {
                                  cubit.chatMicrophoneOnTapAction(index,
                                      cubit.chatListReversed[index].fileName);
                                } else {
                                  cubit.downloadAudioFile(
                                      cubit.chatListReversed[index].fileName,
                                      index);
                                }
                              } else {
                                if (cubit.checkForAudioFile(
                                    cubit.chatListReversed[index].fileName)) {
                                  cubit.chatMicrophoneOnTapAction(index,
                                      cubit.chatListReversed[index].fileName);
                                } else {
                                  cubit.downloadAudioFile(
                                      cubit.chatListReversed[index].fileName,
                                      index);
                                }
                              }
                            },
                            child: BuildCondition(
                              condition: (cubit.downloadingRecordName ==
                                      cubit.chatListReversed[index].fileName) ||
                                  (cubit.uploadingRecordName ==
                                      cubit.chatListReversed[index].fileName),
                              builder: (context) => Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                child: CircularProgressIndicator(
                                  color:
                                      cubit.chatListReversed[index].senderID ==
                                              cubit.userID
                                          ? white
                                          : lightGreen.withOpacity(0.75),
                                  strokeWidth: 0.8,
                                ),
                              ),
                              fallback: (context) => Icon(
                                index == cubit.lastAudioPlayingIndex
                                    ? cubit.iconData
                                    : Icons.play_arrow_rounded,
                                color: cubit.chatListReversed[index].senderID ==
                                        cubit.userID
                                    ? white
                                    : lightGreen,
                                size: 40.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 26.0,
                                    ),
                                    child: LinearPercentIndicator(
                                      percent: cubit.justAudioPlayer.duration ==
                                              null
                                          ? 0.0
                                          : cubit.lastAudioPlayingIndex == index
                                              ? cubit.currAudioPlayingTime /
                                                          cubit
                                                              .justAudioPlayer
                                                              .duration!
                                                              .inMicroseconds
                                                              .ceilToDouble() <=
                                                      1.0
                                                  ? cubit.currAudioPlayingTime /
                                                      cubit
                                                          .justAudioPlayer
                                                          .duration!
                                                          .inMicroseconds
                                                          .ceilToDouble()
                                                  : 0.0
                                              : 0,

                                      barRadius: const Radius.circular(8.0),
                                      lineHeight: 4,
                                      backgroundColor: cubit
                                                  .chatListReversed[index]
                                                  .senderID ==
                                              cubit.userID
                                          ? white
                                          : lightGreen.withOpacity(0.75),
                                      progressColor: cubit
                                                  .chatListReversed[index]
                                                  .senderID ==
                                              cubit.userID
                                          ? orangeColor
                                          : orangeColor,

                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 7.0, right: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              cubit.lastAudioPlayingIndex ==
                                                      index
                                                  ? cubit.loadingTime
                                                  : '0:00',
                                              style: TextStyle(
                                                color: cubit
                                                            .chatListReversed[
                                                                index]
                                                            .senderID ==
                                                        cubit.userID
                                                    ? white
                                                    : lightGreen
                                                        .withOpacity(0.75),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              cubit.lastAudioPlayingIndex ==
                                                      index
                                                  ? cubit.totalDuration
                                                  : '',
                                              style: TextStyle(
                                                color: cubit
                                                            .chatListReversed[
                                                                index]
                                                            .senderID ==
                                                        cubit.userID
                                                    ? white
                                                    : lightGreen,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
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
                                imageUrl: widget.userImage,
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
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          const SizedBox(
                            width: 8.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
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
                                    "https://firebasestorage.googleapis.com/v0/b/mostaqbal-masr.appspot.com/o/Clients%2FFuture%20Of%20Egypt.jpg?alt=media&token=9c330dd7-7554-420c-9523-60bf5a5ec71e",
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
                                  image: AssetImage("assets/images/error.png"),
                                  placeholder: AssetImage(
                                      "assets/images/placeholder.jpg"),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onLongPress: () =>
                                cubit.chatMicrophoneOnLongPressAction(),
                            onTap: () {
                              if (cubit.chatListReversed[index].senderID ==
                                  cubit.userID) {
                                if (cubit.checkForAudioFile(
                                    cubit.chatListReversed[index].fileName)) {
                                  cubit.chatMicrophoneOnTapAction(index,
                                      cubit.chatListReversed[index].fileName);
                                } else {
                                  cubit.downloadAudioFile(
                                      cubit.chatListReversed[index].fileName,
                                      index);
                                }
                              } else {
                                if (cubit.checkForAudioFile(
                                    cubit.chatListReversed[index].fileName)) {
                                  cubit.chatMicrophoneOnTapAction(index,
                                      cubit.chatListReversed[index].fileName);
                                } else {
                                  cubit.downloadAudioFile(
                                      cubit.chatListReversed[index].fileName,
                                      index);
                                }
                              }
                            },
                            child: BuildCondition(
                              condition: (cubit.downloadingRecordName ==
                                      cubit.chatListReversed[index].fileName) ||
                                  (cubit.uploadingRecordName ==
                                      cubit.chatListReversed[index].fileName),
                              builder: (context) => Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                child: CircularProgressIndicator(
                                  color:
                                      cubit.chatListReversed[index].senderID ==
                                              cubit.userID
                                          ? white
                                          : lightGreen,
                                  strokeWidth: 0.8,
                                ),
                              ),
                              fallback: (context) => Icon(
                                index == cubit.lastAudioPlayingIndex
                                    ? cubit.iconData
                                    : Icons.play_arrow_rounded,
                                color: cubit.chatListReversed[index].senderID ==
                                        cubit.userID
                                    ? white
                                    : lightGreen,
                                size: 40.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 2.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 26.0,
                                    ),
                                    child: LinearPercentIndicator(
                                      percent: cubit.justAudioPlayer.duration ==
                                              null
                                          ? 0.0
                                          : cubit.lastAudioPlayingIndex == index
                                              ? cubit.currAudioPlayingTime /
                                                          cubit
                                                              .justAudioPlayer
                                                              .duration!
                                                              .inMicroseconds
                                                              .ceilToDouble() <=
                                                      1.0
                                                  ? cubit.currAudioPlayingTime /
                                                      cubit
                                                          .justAudioPlayer
                                                          .duration!
                                                          .inMicroseconds
                                                          .ceilToDouble()
                                                  : 0.0
                                              : 0,
                                      barRadius: const Radius.circular(8.0),
                                      lineHeight: 3.5,
                                      backgroundColor: cubit
                                                  .chatListReversed[index]
                                                  .senderID ==
                                              cubit.userID
                                          ? white
                                          : lightGreen,
                                      progressColor: cubit
                                                  .chatListReversed[index]
                                                  .senderID ==
                                              cubit.userID
                                          ? Colors.blue
                                          : Colors.amber,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, left: 7.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              cubit.lastAudioPlayingIndex ==
                                                      index
                                                  ? cubit.loadingTime
                                                  : '0:00',
                                              style: TextStyle(
                                                color: cubit
                                                            .chatListReversed[
                                                                index]
                                                            .senderID ==
                                                        cubit.userID
                                                    ? Colors.white
                                                        .withOpacity(0.8)
                                                    : lightGreen,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              cubit.lastAudioPlayingIndex ==
                                                      index
                                                  ? cubit.totalDuration
                                                  : '',
                                              style: TextStyle(
                                                color: cubit
                                                            .chatListReversed[
                                                                index]
                                                            .senderID ==
                                                        cubit.userID
                                                    ? Colors.white
                                                        .withOpacity(0.8)
                                                    : lightGreen,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        )
                                      ],
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
        ],
      ),
    ) : getEmptyWidget();
  }
  Widget audioConversationManagement2(
      BuildContext itemBuilderContext, int index, ConversationCubit cubit) {
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
                    child: voiceNote(cubit.chatListReversed[index].message, cubit.chatListReversed[index].recordDuration),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
                        imageUrl: widget.userImage,
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
                  : Row(
                children: [
                  const SizedBox(
                    width: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
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
                        "https://firebasestorage.googleapis.com/v0/b/mostaqbal-masr.appspot.com/o/Clients%2FFuture%20Of%20Egypt.jpg?alt=media&token=9c330dd7-7554-420c-9523-60bf5a5ec71e",
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
                          image: AssetImage("assets/images/error.png"),
                          placeholder: AssetImage(
                              "assets/images/placeholder.jpg"),
                        ),
                      ),
                    ),
                  ),
                  /*GestureDetector(
                    onLongPress: () =>
                        cubit.chatMicrophoneOnLongPressAction(),
                    onTap: () {
                      if (cubit.chatListReversed[index].senderID ==
                          cubit.userID) {
                        if (cubit.checkForAudioFile(
                            cubit.chatListReversed[index].fileName)) {
                          cubit.chatMicrophoneOnTapAction(index,
                              cubit.chatListReversed[index].fileName);
                        } else {
                          cubit.downloadAudioFile(
                              cubit.chatListReversed[index].fileName,
                              index);
                        }
                      } else {
                        if (cubit.checkForAudioFile(
                            cubit.chatListReversed[index].fileName)) {
                          cubit.chatMicrophoneOnTapAction(index,
                              cubit.chatListReversed[index].fileName);
                        } else {
                          cubit.downloadAudioFile(
                              cubit.chatListReversed[index].fileName,
                              index);
                        }
                      }
                    },
                    child: BuildCondition(
                      condition: (cubit.downloadingRecordName ==
                          cubit.chatListReversed[index].fileName) ||
                          (cubit.uploadingRecordName ==
                              cubit.chatListReversed[index].fileName),
                      builder: (context) => Padding(
                        padding:
                        const EdgeInsets.only(left: 4, right: 4),
                        child: CircularProgressIndicator(
                          color:
                          cubit.chatListReversed[index].senderID ==
                              cubit.userID
                              ? white
                              : lightGreen,
                          strokeWidth: 0.8,
                        ),
                      ),
                      fallback: (context) => Icon(
                        index == cubit.lastAudioPlayingIndex
                            ? cubit.iconData
                            : Icons.play_arrow_rounded,
                        color: cubit.chatListReversed[index].senderID ==
                            cubit.userID
                            ? white
                            : lightGreen,
                        size: 40.0,
                      ),
                    ),
                  ),*/
                  voiceNote(
                      cubit.chatListReversed[index].message, cubit.chatListReversed[index].recordDuration,),
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
