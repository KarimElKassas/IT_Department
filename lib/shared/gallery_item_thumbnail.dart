import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GalleryThumbnail extends StatelessWidget {
  const GalleryThumbnail({Key? key, required this.galleryItem, this.onTap})
      : super(key: key);

  final String galleryItem;

  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: galleryItem,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: galleryItem.replaceAll("[", "").replaceAll("]", ""),
            //height: 100.0,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator(color: Colors.teal, strokeWidth: 0.8,)),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}