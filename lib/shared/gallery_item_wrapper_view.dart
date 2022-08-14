import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


// to view image in full screen
class GalleryImageWrapper extends StatefulWidget {
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final int? initialIndex;
  final PageController pageController;
  final List<dynamic> galleryItems;
  final List<Map<String, dynamic>>? customList;
  final Axis scrollDirection;
  final String? titleGallery;
  final AppBar? appBar;
  final String? fileUrl;
  final bool isFile;

  GalleryImageWrapper({Key? key,
    this.appBar,
    this.loadingBuilder,
    this.titleGallery,
    this.fileUrl,
    this.backgroundDecoration,
    this.initialIndex,
    required this.galleryItems,
    required this.isFile,
    this.customList,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex ?? 0), super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GalleryImageWrapperState();
  }
}

class _GalleryImageWrapperState extends State<GalleryImageWrapper> {
  final minScale = PhotoViewComputedScale.contained * 0.8;
  final maxScale = PhotoViewComputedScale.covered * 8;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar??AppBar(
        title: Text(""),
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          // For Android (dark icons)
          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: widget.backgroundDecoration,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: PhotoViewGallery.builder(
            enableRotation: true,
            scrollPhysics: const BouncingScrollPhysics(),
            builder: _buildImage,
            itemCount: widget.customList != null ? widget.customList!.length : widget.galleryItems.length,
            loadingBuilder: widget.loadingBuilder,
            backgroundDecoration: widget.backgroundDecoration,
            pageController: widget.pageController,
            scrollDirection: widget.scrollDirection,
          ),
        ),
      ),
    );
  }

// build image with zooming
  PhotoViewGalleryPageOptions _buildImage(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions.customChild(
      child: !widget.isFile ? CachedNetworkImage(
        imageUrl: widget.customList != null ? widget.customList![index]["URL"]!.toString() : widget.galleryItems[index]!.toString(),
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator(color: Colors.teal, strokeWidth: 0.8,)),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ) : FittedBox(
        //fit: BoxFit.fill,
        child: Image.file(File(widget.fileUrl!)),
      ),
      initialScale: PhotoViewComputedScale.contained,
      minScale: minScale,
      maxScale: maxScale,
      heroAttributes: PhotoViewHeroAttributes(tag: widget.customList != null ? widget.customList![index]["URL"]!.toString() : widget.galleryItems[index]!.toString()),
    );
  }
}