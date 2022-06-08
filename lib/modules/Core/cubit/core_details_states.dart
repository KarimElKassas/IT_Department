abstract class CoreDetailsStates{}

class CoreDetailsInitialState extends CoreDetailsStates{}

class CoreDetailsLoadingClerksState extends CoreDetailsStates{}

class CoreDetailsGetClerksSuccessState extends CoreDetailsStates{}

class CoreDetailsGetClerksErrorState extends CoreDetailsStates{
  final String error;
  CoreDetailsGetClerksErrorState(this.error);
}