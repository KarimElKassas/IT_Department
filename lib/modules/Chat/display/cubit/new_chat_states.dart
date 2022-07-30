abstract class NewChatStates{}

class NewChatInitialState extends NewChatStates{}

class NewChatFilterUsersState extends NewChatStates{}

class NewChatCheckForChatLoadingState extends NewChatStates{}

class NewChatCreateChatLoadingState extends NewChatStates{}

class NewChatCheckForChatSuccessState extends NewChatStates{}

class NewChatCreateChatSuccessState extends NewChatStates{}

class NewChatCheckForChatErrorState extends NewChatStates{
  final String error;

  NewChatCheckForChatErrorState(this.error);
}
class NewChatCreateChatErrorState extends NewChatStates{
  final String error;

  NewChatCreateChatErrorState(this.error);
}

class NewChatLoadingUsersState extends NewChatStates{}

class NewChatGetUsersSuccessState extends NewChatStates{}

class NewChatGetUsersErrorState extends NewChatStates{
  final String error;

  NewChatGetUsersErrorState(this.error);
}