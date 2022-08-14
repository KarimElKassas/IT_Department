abstract class ProfileStates{}

class ProfileInitialState extends ProfileStates{}

class ProfileInitializeControllerState extends ProfileStates{}

class ProfileChangeImageState extends ProfileStates{}

class ProfileChangeHappenValueState extends ProfileStates{}

class ProfileLoadingUpdateState extends ProfileStates{}

class ProfileUpdateSuccessState extends ProfileStates{}

class ProfileUpdateErrorState extends ProfileStates{
  final String error;

  ProfileUpdateErrorState(this.error);
}