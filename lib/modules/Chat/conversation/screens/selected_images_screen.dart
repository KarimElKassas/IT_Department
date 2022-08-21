import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/components.dart';
import '../../../../shared/constants.dart';
import '../cubit/conversation_cubit.dart';
import '../cubit/conversation_states.dart';
import '../cubit/selected_images_states.dart';

class SelectedImagesScreen extends StatefulWidget {
  final List<dynamic>? chatImages;
  final String receiverID;
  final String receiverToken;
  final String receiverName;
  final String receiverImage;
  final String chatID;
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final int? initialIndex;
  final PageController pageController;
  final Axis scrollDirection;
  final String? titleGallery;
  //final String groupID;
  SelectedImagesScreen({Key? key,
    required this.chatImages,
    required this.receiverID,
    required this.receiverToken,
    required this.receiverName,
    required this.receiverImage,
    required this.chatID,
    this.loadingBuilder,
    this.titleGallery,
    this.backgroundDecoration,
    this.initialIndex,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex ?? 0) ,super(key: key);

  @override
  State<SelectedImagesScreen> createState() => _SelectedImagesScreenState();
}

class _SelectedImagesScreenState extends State<SelectedImagesScreen> {
  final minScale = PhotoViewComputedScale.contained * 0.8;
  final maxScale = PhotoViewComputedScale.covered * 8;
  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.chatImages);
    print("${widget.chatImages!.length}\n");
    return BlocProvider(
      create: (context) => ConversationCubit()..getChatData(widget.receiverID, widget.chatID),
      child: BlocConsumer<ConversationCubit, ConversationStates>(
        listener: (context, state){},
        builder: (context, state){

          var cubit = ConversationCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.black,
                statusBarIconBrightness: Brightness.light,
                // For Android (dark icons)
                statusBarBrightness:
                Brightness.dark, // For iOS (dark icons)
              ),
              backgroundColor: Colors.black,
              elevation: 0.0,
              toolbarHeight: 0,
            ),
            backgroundColor: Colors.black,
            body: Center(
                child: Container(
                  //decoration: widget.backgroundDecoration,
                  constraints: BoxConstraints.expand(
                    height: MediaQuery.of(context).size.height,
                  ),
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      Expanded(
                        child: PhotoViewGallery.builder(
                          scrollPhysics: const BouncingScrollPhysics(),
                          builder: _buildImage,
                          itemCount: widget.chatImages!.length,
                          loadingBuilder: widget.loadingBuilder,
                          backgroundDecoration: widget.backgroundDecoration,
                          pageController: widget.pageController,
                          scrollDirection: widget.scrollDirection,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 10,
                                child: textField(cubit, widget.receiverID, widget.receiverToken, widget.chatID)),
                            Expanded(
                              flex: 2,
                              child: ClipOval(
                                child: Material(
                                  color: Colors.transparent, // Button color
                                  child: InkWell(
                                    onTap: ()async {
                                      await cubit.uploadMultipleImagesFireStore(
                                          context,
                                          messageController.text.isEmpty? "صورة" : messageController.text.toString(),
                                          widget.receiverID,
                                          widget.chatID,
                                          messageController.text.isEmpty ? "Image" : "Image And Text"
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                      width: cubit.recordButtonSize,
                                      height: cubit.recordButtonSize,
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor:
                                        lightGreen,
                                        child: Icon(
                                          IconlyBold.send,
                                          size: 24,
                                          color: white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
  Widget textField(ConversationCubit cubit, String userID, String userToken, String chatID) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextFormField(
                controller: messageController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                    color: lightGreen, fontFamily: "Questv", fontSize: 14),
                maxLines: 2,
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

          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildImage(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions.customChild(
      child: FadeInImage(
        fit: BoxFit.fitWidth,
        image: FileImage(File(widget.chatImages![index].toString())),
        placeholder:
        const AssetImage("assets/images/black_back.png"),
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/images/error.png',
              fit: BoxFit.fill);
        },
      ),
      initialScale: PhotoViewComputedScale.contained,
      minScale: minScale,
      maxScale: maxScale,
      heroAttributes: PhotoViewHeroAttributes(tag: widget.chatImages![index].toString()),
    );
  }

}

