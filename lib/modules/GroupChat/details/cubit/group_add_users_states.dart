abstract class GroupAddUsersStates{}

class GroupAddUsersInitialState extends GroupAddUsersStates{}

class GroupAddUsersChangeSelectState extends GroupAddUsersStates{}

class GroupAddUsersFilterUsersState extends GroupAddUsersStates{}

class GroupAddUsersLoadingGetUsersState extends GroupAddUsersStates{}

class GroupAddUsersLoadingAddUsersState extends GroupAddUsersStates{}

class GroupAddUsersGetUsersSuccessState extends GroupAddUsersStates{}

class GroupAddUsersAddUsersSuccessState extends GroupAddUsersStates{}

class GroupAddUsersAddUsersErrorState extends GroupAddUsersStates{
  final String error;

  GroupAddUsersAddUsersErrorState(this.error);
}
class GroupAddUsersGetUsersErrorState extends GroupAddUsersStates{
  final String error;

  GroupAddUsersGetUsersErrorState(this.error);
}