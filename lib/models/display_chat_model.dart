class DisplayChatModel {

  String userID = "";
  String userName = "";
  String userImage = "";
  String userToken = "";
  String chatID = "";
  String lastMessage = "";
  String lastMessageType = "";
  String lastMessageTime = "";
  String lastMessageSenderID = "";
  String lastMessageSenderName = "";
  String unreadMessagesCount = "";
  String partnerState = "";
  List<Object?> membersList = [];

  DisplayChatModel(this.userID, this.userName, this.userImage, this.userToken, this.chatID, this.lastMessage, this.lastMessageTime, this.lastMessageType, this.lastMessageSenderID, this.lastMessageSenderName, this.unreadMessagesCount, this.partnerState, this.membersList);

}
