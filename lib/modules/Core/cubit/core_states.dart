abstract class CoreStates{}

class CoreInitialState extends CoreStates{}

class CoreDetailsLoadingCreateChatState extends CoreStates{}

class CoreDetailsCreateChatSuccessState extends CoreStates{}

class CoreLoadingClerksState extends CoreStates{}

class CoreGetClerksSuccessState extends CoreStates{}

class CoreGetClerksErrorState extends CoreStates{
  final String error;
  CoreGetClerksErrorState(this.error);
}