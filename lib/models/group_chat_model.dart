import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../shared/gallery_item_model.dart';

class GroupChatModel {
  String senderName = "";
  String senderImage = "";
  String groupID = "";
  String senderID = "";
  String message = "";
  String messageTime = "";
  String messageFullTime = "";
  Timestamp? createdAt;
  String type = "";
  int imagesCount = 0;
  String recordDuration = "0";
  String fileSize = "0 KB";
  String fileName = "";
  bool isSeen = false;
  bool hasImages = false;
  List<dynamic> imagesList = ["emptyList"];
  GroupChatImagesModel? chatImagesModel;

  GroupChatModel(
      this.senderName,
      this.senderImage,
      this.groupID,
      this.senderID,
      this.message,
      this.messageTime,
      this.messageFullTime,
      this.createdAt,
      this.type,
      this.imagesCount,
      this.recordDuration,
      this.fileSize,
      this.fileName,
      this.isSeen,
      this.hasImages,
      this.imagesList,
      this.chatImagesModel);
}
class GroupChatImagesModel{
  String messageFullTime = "";
  List<dynamic> messageImagesList = [];

  GroupChatImagesModel(this.messageFullTime, this.messageImagesList);
}