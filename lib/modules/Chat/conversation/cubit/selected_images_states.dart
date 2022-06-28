abstract class SelectedImagesStates{}

class SelectedImagesInitialState extends SelectedImagesStates{}

class SelectedImagesUploadingState extends SelectedImagesStates{}

class SelectedImagesUploadSuccessState extends SelectedImagesStates{}

class SelectedImagesUploadErrorState extends SelectedImagesStates{

  final String error;

  SelectedImagesUploadErrorState(this.error);

}