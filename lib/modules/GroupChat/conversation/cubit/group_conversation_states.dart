abstract class GroupConversationStates{}

class GroupConversationInitialState extends GroupConversationStates{}

class GroupConversationChangeUserTypeState extends GroupConversationStates{}

class GroupConversationUpdatePaddingState extends GroupConversationStates{}

class GroupConversationUpdatePaddingAndDragState extends GroupConversationStates{}

class GroupConversationUpdateDraggableRecordState extends GroupConversationStates{}

class GroupConversationChangeOpacity extends GroupConversationStates{}
class GroupConversationChangeButtonPosition extends GroupConversationStates{}
class GroupConversationEndRecord extends GroupConversationStates{}
class GroupConversationSendImagesSuccessState extends GroupConversationStates{}

class GroupConversationSendImagesErrorState extends GroupConversationStates{
  final String error;

  GroupConversationSendImagesErrorState(this.error);
}
class GroupConversationUploadingImagesState extends GroupConversationStates{
  final String imageName;

  GroupConversationUploadingImagesState(this.imageName);
}
class GroupConversationUploadingRecordState extends GroupConversationStates{
  final String recordName;

  GroupConversationUploadingRecordState(this.recordName);
}
class GroupConversationUploadImagesSuccessState extends GroupConversationStates{}

class GroupConversationUploadingImageErrorState extends GroupConversationStates{
  final String error;

  GroupConversationUploadingImageErrorState(this.error);
}

class GroupConversationUploadingFileState extends GroupConversationStates{
  final String fileName;

  GroupConversationUploadingFileState(this.fileName);
}

class GroupConversationSendFilesSuccessState extends GroupConversationStates{}
class GroupConversationSendFilesErrorState extends GroupConversationStates{
  final String error;

  GroupConversationSendFilesErrorState(this.error);
}
class GroupConversationSendMessageState extends GroupConversationStates{}

class GroupConversationPermissionDeniedState extends GroupConversationStates{}

class GroupConversationSelectImagesState extends GroupConversationStates{}

class GroupConversationIncreaseTimerSuccessState extends GroupConversationStates{}

class GroupConversationCreateDirectoryState extends GroupConversationStates{}

class GroupConversationAmpTimerSuccessState extends GroupConversationStates{}

class GroupConversationStartRecordSuccessState extends GroupConversationStates{}

class GroupConversationStopRecordSuccessState extends GroupConversationStates{}

class GroupConversationChangeRecordingState extends GroupConversationStates{}

class GroupConversationPlayStreamState extends GroupConversationStates{}

class GroupConversationListenStreamState extends GroupConversationStates{}

class GroupConversationCancelRecordSuccessState extends GroupConversationStates{}

class GroupConversationChangePlayerStateSuccessState extends GroupConversationStates{}

class GroupConversationChangeRecordPositionState extends GroupConversationStates{}

class GroupConversationToggleRecordSuccessState extends GroupConversationStates{}

class GroupConversationInitializeRecordSuccessState extends GroupConversationStates{}

class GroupConversationPlayRecordSuccessState extends GroupConversationStates{}

class GroupConversationEndRecordSuccessState extends GroupConversationStates{}

class GroupConversationSelectFilesState extends GroupConversationStates{}

class GroupConversationLoadingMessageState extends GroupConversationStates{}

class GroupConversationLoadingMembersState extends GroupConversationStates{}

class GroupConversationGetGroupMembersSuccessState extends GroupConversationStates{}

class GroupConversationGetMessageSuccessState extends GroupConversationStates{}

class GroupConversationDownloadFileSuccessState extends GroupConversationStates{}

class GroupConversationLoadingDownloadFileState extends GroupConversationStates{

  final String fileName;

  GroupConversationLoadingDownloadFileState(this.fileName);
}

class GroupConversationSendMessageErrorState extends GroupConversationStates{

  final String error;

  GroupConversationSendMessageErrorState(this.error);

}
class GroupConversationGetMessageErrorState extends GroupConversationStates{

  final String error;

  GroupConversationGetMessageErrorState(this.error);

}
class GroupConversationDownloadFileErrorState extends GroupConversationStates{

  final String error;

  GroupConversationDownloadFileErrorState(this.error);

}