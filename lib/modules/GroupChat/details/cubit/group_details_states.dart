abstract class GroupDetailsStates{}

class GroupDetailsInitialState extends GroupDetailsStates{}

class GroupDetailsGetUsersDataState extends GroupDetailsStates{}

class GroupDetailsChangeDeleteDialogResultState extends GroupDetailsStates{}

class GroupDetailsGetMembersState extends GroupDetailsStates{}

class GroupDetailsFilterMediaState extends GroupDetailsStates{}

class GroupDetailsFilterUsersState extends GroupDetailsStates{}

class GroupDetailsRemoveUserLoadingState extends GroupDetailsStates{}

class GroupDetailsRemoveUserSuccessState extends GroupDetailsStates{}

class GroupDetailsLeaveGroupSuccessState extends GroupDetailsStates{}

class GroupDetailsRemoveAdminLoadingState extends GroupDetailsStates{}

class GroupDetailsRemoveAdminSuccessState extends GroupDetailsStates{}

class GroupDetailsRemoveAdminErrorState extends GroupDetailsStates{
  final String error;

  GroupDetailsRemoveAdminErrorState(this.error);
}

class GroupDetailsAddAdminLoadingState extends GroupDetailsStates{}

class GroupDetailsAddAdminSuccessState extends GroupDetailsStates{}

class GroupDetailsCheckForChatSuccessState extends GroupDetailsStates{}

class GroupDetailsCreateChatLoadingState extends GroupDetailsStates{}

class GroupDetailsCreateChatSuccessState extends GroupDetailsStates{}

class GroupDetailsCheckForChatErrorState extends GroupDetailsStates{
  final String error;

  GroupDetailsCheckForChatErrorState(this.error);
}
class GroupDetailsCreateChatErrorState extends GroupDetailsStates{
  final String error;

  GroupDetailsCreateChatErrorState(this.error);
}
class GroupDetailsAddAdminErrorState extends GroupDetailsStates{
  final String error;

  GroupDetailsAddAdminErrorState(this.error);
}

class GroupDetailsRemoveUserErrorState extends GroupDetailsStates{
  final String error;

  GroupDetailsRemoveUserErrorState(this.error);
}


