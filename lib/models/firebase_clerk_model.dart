import 'dart:convert';

class ClerkFirebaseModel{

  String? clerkID;
  String  clerkName = "";
  String? clerkImage;
  String? clerkManagementID;
  String? clerkJobName;
  String? clerkCategoryName;
  String? personNumber;
  String? personAddress;
  String? personPhone;
  String? personPassword;
  String? personState;
  String? personToken;
  List<Object?>? clerkSubscriptions;

  ClerkFirebaseModel(
      this.clerkID,
      this.clerkName,
      this.clerkImage,
      this.clerkManagementID,
      this.clerkJobName,
      this.clerkCategoryName,
      this.personNumber,
      this.personAddress,
      this.personPhone,
      this.personPassword,
      this.personState,
      this.personToken,
      this.clerkSubscriptions);


  factory ClerkFirebaseModel.fromJson(Map<String, dynamic> jsonData) {
    return ClerkFirebaseModel(
        jsonData['ClerkID'],
        jsonData['ClerkName'],
        jsonData['ClerkImage'],
        jsonData['ClerkManagementID'],
        jsonData['ClerkJobName'],
        jsonData['ClerkCategoryName'],
        jsonData['PersonNumber'],
        jsonData['PersonAddress'],
        jsonData['PersonPhone'],
        jsonData['PersonPassword'],
        jsonData['PersonState'],
        jsonData['PersonToken'],
        jsonData['ClerkSubscriptions'],
    );
  }

  static Map<String, dynamic> toMap(ClerkFirebaseModel clerkModel) => {
    'ClerkID': clerkModel.clerkID,
    'ClerkName': clerkModel.clerkName,
    'ClerkImage': clerkModel.clerkImage,
    'ClerkManagementID': clerkModel.clerkManagementID,
    'ClerkJobName': clerkModel.clerkJobName,
    'ClerkCategoryName': clerkModel.clerkCategoryName,
    'ClerkPhone': clerkModel.personPhone,
    'ClerkNumber': clerkModel.personNumber,
    'ClerkAddress': clerkModel.personAddress,
    'ClerkPassword': clerkModel.personPassword,
    'ClerkState': clerkModel.personState,
    'ClerkToken': clerkModel.personToken,
    'ClerkSubscriptions': clerkModel.clerkSubscriptions,
  };

  static String encode(List<ClerkFirebaseModel> clerks) => json.encode(
    clerks
        .map<Map<String, dynamic>>((clerk) => ClerkFirebaseModel.toMap(clerk))
        .toList(),
  );

  static List<ClerkFirebaseModel> decode(String clerks) =>
      (json.decode(clerks) as List<dynamic>)
          .map<ClerkFirebaseModel>((item) => ClerkFirebaseModel.fromJson(item))
          .toList();

}