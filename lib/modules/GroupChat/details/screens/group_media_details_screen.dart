import 'package:auto_size_text/auto_size_text.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/models/group_chat_model.dart';
import 'package:it_department/modules/GroupChat/details/cubit/group_media_details_states.dart';
import 'package:open_file/open_file.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/gallery_item_wrapper_view.dart';
import '../../../Chat/widget/intial.dart';
import '../../../Chat/widget/page_manager.dart';
import '../cubit/group_media_details_cubit.dart';

class GroupMediaDetailsScreen extends StatefulWidget {
  const GroupMediaDetailsScreen(
      {Key? key,
      required this.initialIndex,
      required this.groupName,
      required this.groupID,
      required this.imagesList,
      required this.filesList,
      required this.recordsList})
      : super(key: key);
  final int initialIndex;
  final String groupName;
  final String groupID;
  final List<String> imagesList;
  final List<GroupChatModel> filesList;
  final List<GroupChatModel> recordsList;

  @override
  State<GroupMediaDetailsScreen> createState() =>
      _GroupMediaDetailsScreenState();
}

class _GroupMediaDetailsScreenState extends State<GroupMediaDetailsScreen> {
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
      create: (context) => GroupMediaDetailsCubit(),
      child: BlocConsumer<GroupMediaDetailsCubit, GroupMediaDetailsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = GroupMediaDetailsCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: DefaultTabController(
              initialIndex: widget.initialIndex,
              length: 3,
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
                    title: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.black,
                              )),
                          const SizedBox(
                            width: 12,
                          ),
                          AutoSizeText(
                            "وسائط جروب  ${widget.groupName}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Questv",
                              fontSize: 14,
                            ),
                            minFontSize: 14,
                          ),
                        ],
                      ),
                    ),
                    bottom: const TabBar(
                      physics: BouncingScrollPhysics(),
                      indicatorColor: Colors.black,
                      indicatorWeight: 0.8,
                      tabs: [
                        Tab(
                          child: AutoSizeText(
                            'الصور',
                            style: TextStyle(
                                color: Colors.black, fontFamily: "Questv"),
                            minFontSize: 8,
                            maxLines: 1,
                            maxFontSize: 10,
                          ),
                        ),
                        Tab(
                          child: AutoSizeText(
                            'الملفات',
                            style: TextStyle(
                                color: Colors.black, fontFamily: "Questv"),
                            minFontSize: 8,
                            maxLines: 1,
                            maxFontSize: 10,
                          ),
                        ),
                        Tab(
                          child: AutoSizeText(
                            'التسجيلات الصوتية',
                            style: TextStyle(
                                color: Colors.black, fontFamily: "Questv"),
                            minFontSize: 8,
                            maxLines: 1,
                            maxFontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: Container(
                    color: veryLightGreen.withOpacity(0.1),
                    child: TabBarView(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(),
                        child: GridView.builder(
                          itemCount: widget.imagesList.length,
                          semanticChildCount: 0,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 0,
                          ),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) =>
                              imagesGridItem(context, index),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 12),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, listIndex) =>
                              filesListItem(context, cubit, listIndex),
                          separatorBuilder: (context, index) => const Divider(
                            thickness: 0.4,
                            color: Colors.grey,
                          ),
                          itemCount: widget.filesList.length,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 12),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, listIndex) =>
                              audiosListItem(context, cubit, listIndex),
                          separatorBuilder: (context, index) => const Divider(
                            thickness: 0.4,
                            color: Colors.grey,
                          ),
                          itemCount: widget.recordsList.length,
                        ),
                      )
                    ]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget imagesGridItem(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        openImageFullScreen(context, index);
      },
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(0.0),
            ),
            color: lightGreen),
        padding: const EdgeInsets.all(0.5),
        width: 100,
        //height: 50,
        child: CachedNetworkImage(
          imageUrl: widget.imagesList[index].toString(),
          imageBuilder: (context, imageProvider) => ClipRRect(
            borderRadius: BorderRadius.circular(0.0),
            child: FadeInImage(
              fit: BoxFit.cover,
              image: imageProvider,
              placeholder: const AssetImage("assets/images/placeholder.jpg"),
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
        ),
      ),
    );
  }

  Widget voiceNote(GroupMediaDetailsCubit cubit, String urls, String totalDuration, Color progressBarColor,
      Color progressBarSecondColor, Color iconColor, Color fontColor) {
    return BuildCondition(
      condition: urlint == urls,
      builder: (ctx) {
        return VoiceWidget(
          cubit: cubit,
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

  Widget filesListItem(
      BuildContext context, GroupMediaDetailsCubit cubit, int index) {
    return InkWell(
      onTap: () {
        if (cubit.checkForDocumentFile(
            widget.filesList[index].fileName, widget.groupName)) {
          OpenFile.open(
              "/storage/emulated/0/Download/IT Department/${widget.groupName}/Documents/${widget.filesList[index].fileName}");
        } else {
          cubit
              .downloadDocumentFile(widget.filesList[index].fileName,
                  widget.groupName, widget.groupID)
              .then((value) {
            OpenFile.open(
                "/storage/emulated/0/Download/IT Department/${widget.groupName}/Documents/${widget.filesList[index].fileName}");
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(0.0),
          ),
        ),
        width: 100.w,
        //height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "${widget.filesList[index].senderName}  •••  ${widget.filesList[index].messageTime}",
                    style: TextStyle(
                        color: orangeColor,
                        fontFamily: "Questv",
                        fontWeight: FontWeight.w600),
                    minFontSize: 8,
                    maxLines: 2,
                    maxFontSize: 10,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  AutoSizeText(
                    widget.filesList[index].fileName,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Questv",
                        fontWeight: FontWeight.w600),
                    minFontSize: 8,
                    maxLines: 2,
                    maxFontSize: 10,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: lightGreen),
              height: 50,
              width: 20.w,
              child: const Icon(
                Icons.file_copy,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget audiosListItem(
      BuildContext context, GroupMediaDetailsCubit cubit, int index) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(0.0),
        ),
      ),
      width: 100.w,
      //height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            "${widget.recordsList[index].senderName}  •••  ${widget.recordsList[index].messageTime}",
            style: TextStyle(
                color: orangeColor,
                fontFamily: "Questv",
                fontWeight: FontWeight.w600),
            minFontSize: 8,
            maxLines: 2,
            maxFontSize: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: lightGreen),
                height: 50,
                width: 20.w,
                child: const Icon(
                  Icons.audiotrack_rounded,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: voiceNote(
                      cubit,
                      widget.recordsList[index].message,
                      widget.recordsList[index].recordDuration,
                      lightGreen,
                      orangeColor,
                      lightGreen,
                      lightGreen),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void openImageFullScreen(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryImageWrapper(
          isFile: false,
          titleGallery: "",
          galleryItems: widget.imagesList,
          backgroundDecoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(4)),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
