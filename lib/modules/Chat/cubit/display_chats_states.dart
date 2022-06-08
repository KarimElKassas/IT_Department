abstract class DisplayChatsStates{}

class DisplayChatsInitialState extends DisplayChatsStates{}

class DisplayChatsFilterChatsState extends DisplayChatsStates{}

class DisplayChatsLoadingCreateChatState extends DisplayChatsStates{}

class DisplayChatsCreateChatSuccessState extends DisplayChatsStates{}

class DisplayChatsLoadingChatsState extends DisplayChatsStates{}

class DisplayChatsGetMessagesSuccessState extends DisplayChatsStates{}

class DisplayChatsGetChatsState extends DisplayChatsStates{}

class DisplayChatsGetChatsErrorState extends DisplayChatsStates{

  final String error;

  DisplayChatsGetChatsErrorState(this.error);

}