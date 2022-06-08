abstract class ConversationStates{}

class ConversationInitialState extends ConversationStates{}

class ConversationChangeUserState extends ConversationStates{}

class ConversationSendMessageState extends ConversationStates{}

class ConversationSelectImagesState extends ConversationStates{}

class ConversationUploadingImagesState extends ConversationStates{}

class ConversationSendImagesSuccessState extends ConversationStates{}

class ConversationSendImagesErrorState extends ConversationStates{
  final String error;

  ConversationSendImagesErrorState(this.error);
}

class ConversationSelectFilesState extends ConversationStates{}

class ConversationSendFilesSuccessState extends ConversationStates{}

class ConversationSendFilesErrorState extends ConversationStates{
  final String error;

  ConversationSendFilesErrorState(this.error);
}

class ConversationLoadingMessageState extends ConversationStates{}

class ConversationChangeRecordingState extends ConversationStates{}

class ConversationUploadingRecordState extends ConversationStates{
  final String recordName;

  ConversationUploadingRecordState(this.recordName);
}
class ConversationUploadingFileState extends ConversationStates{
  final String fileName;

  ConversationUploadingFileState(this.fileName);
}

class ConversationGetMessageSuccessState extends ConversationStates{}

class ConversationCreateDirectoryState extends ConversationStates{}

class ConversationStartRecordSuccessState extends ConversationStates{}

class ConversationIncreaseTimerSuccessState extends ConversationStates{}

class ConversationAmpTimerSuccessState extends ConversationStates{}

class ConversationStopRecordSuccessState extends ConversationStates{}

class ConversationCancelRecordSuccessState extends ConversationStates{}

class ConversationToggleRecordSuccessState extends ConversationStates{}

class ConversationInitializeRecordSuccessState extends ConversationStates{}

class ConversationChangeRecordPositionState extends ConversationStates{}

class ConversationPlayRecordSuccessState extends ConversationStates{}

class ConversationPermissionDeniedState extends ConversationStates{}

class ConversationDownloadFileSuccessState extends ConversationStates{}

class ConversationLoadingDownloadFileState extends ConversationStates{

  final String fileName;

  ConversationLoadingDownloadFileState(this.fileName);
}
class ConversationSendMessageErrorState extends ConversationStates{

  final String error;

  ConversationSendMessageErrorState(this.error);

}
class ConversationGetMessageErrorState extends ConversationStates{

  final String error;

  ConversationGetMessageErrorState(this.error);

}
class ConversationDownloadFileErrorState extends ConversationStates{

  final String error;

  ConversationDownloadFileErrorState(this.error);

}