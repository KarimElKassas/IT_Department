class DisplayGroupsModel {

  String groupID = "";
  String groupName = "";
  String groupImage = "";
  String membersCount = "";
  String lastMessage = "";
  String lastMessageType = "";
  String lastMessageTime = "";
  String lastMessageSenderID = "";
  String lastMessageSenderName = "";
  String unreadMessagesCount = "";
  String partnerState = "";
  List<Object?> membersList = [];
  List<Object?> adminsList = [];
  List<Object?> membersAndAdminsList = [];

  DisplayGroupsModel(this.groupID, this.groupName, this.groupImage, this.membersCount, this.lastMessage, this.lastMessageTime, this.lastMessageType, this.lastMessageSenderID, this.lastMessageSenderName, this.unreadMessagesCount, this.partnerState, this.membersList, this.adminsList, this.membersAndAdminsList);

}
