abstract class HomeStates{}
class HomeInitialState extends HomeStates{}
class HomeChangeShowDetailsState extends HomeStates{}
class HomeChangeLandPlotIndexState extends HomeStates{}
class HomeChangeLandPlotColumnsIndexState extends HomeStates{}
class HomeChangeLandPlotPiecesIndexState extends HomeStates{}
class HomeChangeLandPlotDevicesIndexState extends HomeStates{}
class HomeLoadingLandState extends HomeStates{}
class HomeLoadingLandColumnsState extends HomeStates{}
class HomeLoadingLandPiecesState extends HomeStates{}
class HomeLoadingLandDevicesState extends HomeStates{}
class HomeGetDeviceDetailsSuccessState extends HomeStates{}
class HomeGetLandSuccessState extends HomeStates{}
class HomeGetLandColumnsSuccessState extends HomeStates{}
class HomeGetLandPiecesSuccessState extends HomeStates{}
class HomeGetLandDevicesSuccessState extends HomeStates{}
class HomeGetLandErrorState extends HomeStates{
  final String error;

  HomeGetLandErrorState(this.error);
}
class HomeGetLandColumnsErrorState extends HomeStates{
  final String error;

  HomeGetLandColumnsErrorState(this.error);
}
class HomeGetLandPiecesErrorState extends HomeStates{
  final String error;

  HomeGetLandPiecesErrorState(this.error);
}
class HomeGetLandDevicesErrorState extends HomeStates{
  final String error;

  HomeGetLandDevicesErrorState(this.error);
}