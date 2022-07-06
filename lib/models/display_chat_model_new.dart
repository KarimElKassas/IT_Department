class DisplayGroupsModel {

  String groupID = "";
  String groupName = "";
  String groupImage = "";
  String membersCount = "";
  String lastMessage = "";
  String lastMessageType = "";
  String lastMessageTime = "";
  String lastMessageSender = "";
  String unreadMessagesCount = "";
  String partnerState = "";
  List<Object?> membersList = [];
  List<Object?> adminsList = [];

  DisplayGroupsModel(this.groupID, this.groupName, this.groupImage, this.membersCount, this.lastMessage, this.lastMessageTime, this.lastMessageType, this.lastMessageSender, this.unreadMessagesCount, this.partnerState, this.membersList, this.adminsList);

}
