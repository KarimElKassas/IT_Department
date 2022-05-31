import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:it_department/models/land_plot_model.dart';
import 'package:it_department/modules/Home/cubit/home_states.dart';
import 'package:it_department/shared/components.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../network/remote/dio_helper.dart';
import '../../../shared/dropdown/drop_list_model.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  LandPlotModel? landPlotModel;
  LandPlotDeviceHistoryModel? landPlotDeviceHistoryModel;
  List<LandPlotModel> landPlotsList = [];
  List<LandPlotDeviceHistoryModel> landPlotDeviceHistoryList = [];
  List<LandPlotModel> landPlotColumnsList = [];
  List<LandPlotModel> landPlotPiecesList = [];
  List<LandPlotModel> landPlotDevicesList = [];
  List<OptionItem> landPlotOptionList = [];
  List<OptionItem> landPlotColumnsOptionList = [];
  List<OptionItem> landPlotPiecesOptionList = [];
  List<OptionItem> landPlotDevicesOptionList = [];

  OptionItem landPlotOptionItemSelected = OptionItem(id: 0, title: "المشروع");
  OptionItem landPlotColumnsOptionItemSelected = OptionItem(id: 0, title: "العمود");
  OptionItem landPlotPiecesOptionItemSelected = OptionItem(id: 0, title: "القطعة");
  OptionItem landPlotDevicesOptionItemSelected = OptionItem(id: 0, title: "الجهاز");
  DropListModel? landPlotDropListModel;
  DropListModel? landPlotColumnsDropListModel;
  DropListModel? landPlotPiecesDropListModel;
  DropListModel? landPlotDevicesDropListModel;
  bool gotLandPlots = false;
  bool gotLandPlotColumns = false;
  bool gotLandPlotPieces = false;
  bool gotLandPlotDevices = false;
  bool gotLandPlotDevicesHistory = false;
  bool zeroLandPlots = true;
  bool zeroColumns = true;
  bool zeroPieces = true;
  bool zeroDevices = true;
  bool showDetails = false;

  String currentDeviceType = "";
  String currentDeviceTowersCount = "";
  String currentDeviceTotalSpace = "";
  String currentDeviceTotalValidSpace = "";
  String currentDeviceTotalNotValidSpace = "";
  String currentDeviceTotalNotValidSpaceReason = "";
  String currentDevicePlanesCount = "";
  String currentDeviceCategory = "";
  String currentDeviceCompanyName = "";
  String currentDeviceUWater = "";
  String currentDeviceDepth = "";
  String currentDeviceWaterColumns = "";
  String currentDeviceSalinity = "";
  String currentDeviceDrainingWater = "";
  String currentDevicePumpCompany = "";
  String currentDevicePumpCapacity = "";
  String currentDevicePumpPhases = "";
  String currentDeviceDateDischarge = "";

  static String formatDate(DateTime date){

    initializeDateFormatting('ar');
    Intl.defaultLocale = 'ar';
    final DateFormat formatter = DateFormat().add_yMMMd();
    final String formatted = formatter.format(date);

    return formatted;
  }

  Future<void> getLandPlots() async {
    emit(HomeLoadingLandState());
    landPlotsList = [];
    landPlotColumnsOptionItemSelected = OptionItem(id: 0, title: "العمود");
    landPlotPiecesOptionItemSelected = OptionItem(id: 0, title: "القطعة");
    landPlotDevicesOptionItemSelected = OptionItem(id: 0, title: "الجهاز");
    gotLandPlots = false;
    gotLandPlotColumns = false;
    gotLandPlotPieces = false;
    gotLandPlotDevices = false;
    await DioHelper.getData(
        url: 'landPlot/LandPlotGetWithLevel',
        query: {'Land_Plot_Level': 1}).then((value) async {
          if(value.statusMessage != "No LandPlot Found"){
            await value.data.forEach((landPlot) {
              landPlotModel = LandPlotModel(
                  landPlot["Land_Plot_ID"],
                  landPlot["Land_Plot_Name"],
                  landPlot["Land_Plot_FK"],
                  landPlot["Land_Plot_Level"],
                  landPlot["Implementing_Company"],
                  landPlot["Depth"],
                  landPlot["U_Water"],
                  landPlot["Water_Column"],
                  landPlot["Draining_Water"],
                  landPlot["Salinity"],
                  landPlot["Pump_Capacity"],
                  landPlot["Phases_Pump"],
                  landPlot["Company_Pumps"],
                  landPlot["Date_Discharge"],
                  landPlot["Device_Type"],
                  landPlot["Device_Towers"],
                  landPlot["Device_Planes"],
                  landPlot["Device_Space_Total"],
                  landPlot["Maintenance_Agent"],
                  landPlot["Device_Category"],
                  landPlot["Land_Plot_Rec_Modifay"],
                  landPlot["Device_Space_Valid"],
                  landPlot["Device_Space_NotValid"],
                  landPlot["Device_Space_NotValid_Reason"],
                  landPlot["Land_Plot_Notes"],
                  landPlot["Land_Plot_Latitude"],
                  landPlot["Land_Plot__Longitude"]);
              landPlotsList.add(landPlotModel!);
              landPlotOptionList.add(OptionItem(
                  id: landPlot["Land_Plot_ID"], title: landPlot["Land_Plot_Name"]));
            });
            landPlotDropListModel = DropListModel(landPlotOptionList);
            zeroLandPlots = false;
            gotLandPlots = true;
          }else{
            zeroLandPlots = true;
            gotLandPlots = false;
          }

      emit(HomeGetLandSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        zeroLandPlots = true;
        gotLandPlots = false;
        emit(HomeGetLandErrorState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        zeroLandPlots = true;
        gotLandPlots = false;
        print(error.toString());
        emit(HomeGetLandErrorState(error.toString()));
      }
    });
  }
  Future<void> getLandPlotColumns(int landPlotID) async {
    emit(HomeLoadingLandColumnsState());
    landPlotColumnsList = [];
    landPlotColumnsDropListModel?.listOptionItems.clear();
    landPlotColumnsDropListModel = null;
    gotLandPlotColumns = false;
    gotLandPlotPieces = false;
    gotLandPlotDevices = false;

    await DioHelper.getData(
        url: 'landPlot/LandPlotGetWithLevelAndFK',
        query: {
          'Land_Plot_Level': 2,
          'Land_Plot_FK': landPlotID
        }).then((value) async {
          if(value.statusMessage != "No LandPlot Found"){
            await value.data.forEach((landPlot) {
              landPlotModel = LandPlotModel(
                  landPlot["Land_Plot_ID"],
                  landPlot["Land_Plot_Name"],
                  landPlot["Land_Plot_FK"],
                  landPlot["Land_Plot_Level"],
                  landPlot["Implementing_Company"],
                  landPlot["Depth"],
                  landPlot["U_Water"],
                  landPlot["Water_Column"],
                  landPlot["Draining_Water"],
                  landPlot["Salinity"],
                  landPlot["Pump_Capacity"],
                  landPlot["Phases_Pump"],
                  landPlot["Company_Pumps"],
                  landPlot["Date_Discharge"],
                  landPlot["Device_Type"],
                  landPlot["Device_Towers"],
                  landPlot["Device_Planes"],
                  landPlot["Device_Space_Total"],
                  landPlot["Maintenance_Agent"],
                  landPlot["Device_Category"],
                  landPlot["Land_Plot_Rec_Modifay"],
                  landPlot["Device_Space_Valid"],
                  landPlot["Device_Space_NotValid"],
                  landPlot["Device_Space_NotValid_Reason"],
                  landPlot["Land_Plot_Notes"],
                  landPlot["Land_Plot_Latitude"],
                  landPlot["Land_Plot__Longitude"]);
              landPlotColumnsList.add(landPlotModel!);
              landPlotColumnsOptionList.add(OptionItem(
                  id: landPlot["Land_Plot_ID"], title: landPlot["Land_Plot_Name"]));
            });
            landPlotColumnsDropListModel = DropListModel(landPlotColumnsOptionList);
            zeroColumns = false;
            gotLandPlotColumns = true;
          }else{
            zeroColumns = true;
            gotLandPlotColumns = false;
          }

      emit(HomeGetLandColumnsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        gotLandPlotColumns = false;
        gotLandPlotPieces = false;
        gotLandPlotDevices = false;
        zeroColumns = true;
        emit(HomeGetLandColumnsErrorState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        gotLandPlotColumns = false;
        gotLandPlotPieces = false;
        gotLandPlotDevices = false;
        zeroColumns = true;

        emit(HomeGetLandColumnsErrorState(error.toString()));
      }
    });
  }
  Future<void> getLandPlotPieces(int landPlotColumnID) async {
    emit(HomeLoadingLandColumnsState());
    landPlotPiecesList = [];
    landPlotPiecesDropListModel?.listOptionItems.clear();
    landPlotPiecesDropListModel = null;
    gotLandPlotPieces = false;
    gotLandPlotDevices = false;
    await DioHelper.getData(
        url: 'landPlot/LandPlotGetWithLevelAndFK',
        query: {
          'Land_Plot_Level': 3,
          'Land_Plot_FK': landPlotColumnID
        }).then((value) async {
          if(value.statusMessage != "No LandPlot Found"){
            await value.data.forEach((landPlot) {
              landPlotModel = LandPlotModel(
                  landPlot["Land_Plot_ID"],
                  landPlot["Land_Plot_Name"],
                  landPlot["Land_Plot_FK"],
                  landPlot["Land_Plot_Level"],
                  landPlot["Implementing_Company"],
                  landPlot["Depth"],
                  landPlot["U_Water"],
                  landPlot["Water_Column"],
                  landPlot["Draining_Water"],
                  landPlot["Salinity"],
                  landPlot["Pump_Capacity"],
                  landPlot["Phases_Pump"],
                  landPlot["Company_Pumps"],
                  landPlot["Date_Discharge"],
                  landPlot["Device_Type"],
                  landPlot["Device_Towers"],
                  landPlot["Device_Planes"],
                  landPlot["Device_Space_Total"],
                  landPlot["Maintenance_Agent"],
                  landPlot["Device_Category"],
                  landPlot["Land_Plot_Rec_Modifay"],
                  landPlot["Device_Space_Valid"],
                  landPlot["Device_Space_NotValid"],
                  landPlot["Device_Space_NotValid_Reason"],
                  landPlot["Land_Plot_Notes"],
                  landPlot["Land_Plot_Latitude"],
                  landPlot["Land_Plot__Longitude"]);
              landPlotPiecesList.add(landPlotModel!);
              landPlotPiecesOptionList.add(OptionItem(
                  id: landPlot["Land_Plot_ID"], title: landPlot["Land_Plot_Name"]));
            });
            landPlotPiecesDropListModel = DropListModel(landPlotPiecesOptionList);
            zeroPieces = false;
            gotLandPlotPieces = true;
          }else{
            zeroPieces = true;
            gotLandPlotPieces = false;
          }

      emit(HomeGetLandPiecesSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        gotLandPlotPieces = false;
        gotLandPlotDevices = false;
        zeroPieces = true;
        emit(HomeGetLandPiecesErrorState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        gotLandPlotPieces = false;
        gotLandPlotDevices = false;
        zeroPieces = true;
        print(error.toString());
        emit(HomeGetLandPiecesErrorState(error.toString()));
      }
    });
  }
  Future<void> getLandPlotDevices(int landPlotPieceID) async {
    emit(HomeLoadingLandColumnsState());
    landPlotDevicesList = [];
    landPlotDevicesDropListModel?.listOptionItems.clear();
    landPlotDevicesDropListModel = null;
    gotLandPlotDevices = false;
    zeroDevices = true;
    await DioHelper.getData(
        url: 'landPlot/LandPlotGetWithLevelAndFK',
        query: {
          'Land_Plot_Level': 4,
          'Land_Plot_FK': landPlotPieceID
        }).then((value) async {
          if(value.statusMessage != "No LandPlot Found"){
            await value.data.forEach((landPlot) {
              landPlotModel = LandPlotModel(
                  landPlot["Land_Plot_ID"],
                  landPlot["Land_Plot_Name"].toString(),
                  landPlot["Land_Plot_FK"],
                  landPlot["Land_Plot_Level"],
                  landPlot["Implementing_Company"],
                  landPlot["Depth"].toString(),
                  landPlot["U_Water"].toString(),
                  landPlot["Water_Column"].toString(),
                  landPlot["Draining_Water"].toString(),
                  landPlot["Salinity"].toString(),
                  landPlot["Pump_Capacity"].toString(),
                  landPlot["Phases_Pump"].toString(),
                  landPlot["Company_Pumps"],
                  landPlot["Date_Discharge"].toString(),
                  landPlot["Device_Type"].toString(),
                  landPlot["Device_Towers"].toString(),
                  landPlot["Device_Planes"].toString(),
                  landPlot["Device_Space_Total"].toString(),
                  landPlot["Maintenance_Agent"],
                  landPlot["Device_Category"].toString(),
                  landPlot["Land_Plot_Rec_Modifay"].toString(),
                  landPlot["Device_Space_Valid"].toString(),
                  landPlot["Device_Space_NotValid"].toString(),
                  landPlot["Device_Space_NotValid_Reason"].toString(),
                  landPlot["Land_Plot_Notes"].toString(),
                  landPlot["Land_Plot_Latitude"].toString(),
                  landPlot["Land_Plot__Longitude"].toString());
              landPlotDevicesList.add(landPlotModel!);
              landPlotDevicesOptionList.add(OptionItem(id: landPlot["Land_Plot_ID"], title: landPlot["Land_Plot_Name"]));
            });
            landPlotDevicesDropListModel = DropListModel(landPlotDevicesOptionList);
            zeroDevices = false;
            gotLandPlotDevices = true;
          }else{
            zeroDevices = true;
            gotLandPlotDevices = false;
          }
          emit(HomeGetLandDevicesSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        gotLandPlotDevices = false;
        zeroDevices = true;
        emit(HomeGetLandDevicesErrorState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        gotLandPlotDevices = false;
        zeroDevices = true;
        emit(HomeGetLandDevicesErrorState(error.toString()));
      }
    });
  }
  Future<void> getLandPlotDeviceHistory(int landPlotDeviceID) async {
    emit(HomeLoadingLandColumnsState());
    landPlotDeviceHistoryList = [];
    await DioHelper.getData(
        url: 'landPlotDeviceHistory/LandPlotDeviceHistoryGetWithID',
        query: {
          'Land_Plot_ID': landPlotDeviceID
        }).then((value) async {
          if(value.statusMessage != "No LandPlot Device History Found"){
            await value.data.forEach((landPlot) {
              landPlotDeviceHistoryModel = LandPlotDeviceHistoryModel(
                  landPlot["Type_Named_Name"].toString(),
                  landPlot["Named"].toString(),
                  landPlot["Device_Space"].toString(),
                  landPlot["F_Date"].toString() != "null" ? formatDate(DateTime.parse(landPlot["F_Date"].toString())) : "-",
                  landPlot["T_Date"].toString() != "null" ? formatDate(DateTime.parse(landPlot["T_Date"].toString())) : "-");
              landPlotDeviceHistoryList.add(landPlotDeviceHistoryModel!);
            });
            gotLandPlotDevicesHistory = true;
          }else{
            gotLandPlotDevicesHistory = false;
          }
          emit(HomeGetLandDevicesSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        gotLandPlotDevices = false;
        zeroDevices = true;
        emit(HomeGetLandDevicesErrorState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        gotLandPlotDevices = false;
        zeroDevices = true;
        print(error.toString());
        emit(HomeGetLandDevicesErrorState(error.toString()));
      }
    });
  }
  Future<void> getDeviceMainData(int landPlotDeviceID) async {
    landPlotDevicesList.where((element) => element.landPlotID! == landPlotDeviceID).forEach((element) {
      currentDeviceCategory = element.deviceCategory! !="null"? element.deviceCategory! : "-";
      currentDevicePlanesCount = element.devicePlanes! !="null"?element.devicePlanes! :"-";
      currentDeviceTotalNotValidSpace = element.deviceSpaceNotValid! != "null"? element.deviceSpaceNotValid! :"-";
      currentDeviceTotalNotValidSpaceReason = element.deviceSpaceNotValidReason! !="null"? element.deviceSpaceNotValidReason! :"-";
      currentDeviceTotalValidSpace = element.deviceSpaceValid! !="null"? element.deviceSpaceValid! :"-";
      currentDeviceTowersCount = element.deviceTowers! !="null"? element.deviceTowers! : "-";
      currentDeviceTotalSpace = element.deviceSpaceTotal! !="null" ? element.deviceSpaceTotal! : "-";
    });
    await DioHelper.getData(
        url: 'landPlots/LandPlotsGetWithID',
        query: {
          'Land_Plot_ID': landPlotDeviceID,
        }).then((value) async {
      if(value.statusMessage != "No LandPlots Found"){
        value.data.forEach((landPlot){
          currentDeviceType = landPlot["DeviceTypeName"].toString() !="null" ? landPlot["DeviceTypeName"].toString() : "-";
          currentDeviceCompanyName = landPlot["Implementing_Company_Name"].toString() !="null" ? landPlot["Implementing_Company_Name"].toString() : "-";
          currentDeviceUWater = landPlot["U_Water"].toString() !="null" ? landPlot["U_Water"].toString() : "-";
          currentDeviceWaterColumns = landPlot["Water_Column"].toString() !="null" ? landPlot["Water_Column"].toString() : "-";
          currentDeviceDepth = landPlot["Depth"].toString() !="null" ? landPlot["Depth"].toString() : "-";
          currentDeviceSalinity = landPlot["Salinity"].toString() !="null" ? landPlot["Salinity"].toString() : "-";
          currentDeviceDrainingWater = landPlot["Draining_Water"].toString() !="null" ? landPlot["Draining_Water"].toString() : "-";
          currentDevicePumpCompany = landPlot["Company_Pumps"].toString() !="null" ? landPlot["Company_Pumps"].toString() : "-";
          currentDevicePumpCapacity = landPlot["Pump_Capacity"].toString() !="null" ? landPlot["Pump_Capacity"].toString() : "-";
          currentDevicePumpPhases = landPlot["Phases_Pump"].toString() !="null" ? landPlot["Phases_Pump"].toString() : "-";
          currentDeviceDateDischarge = landPlot["Date_Discharge"].toString() !="null" ? formatDate(DateTime.parse(landPlot["Date_Discharge"].toString())) : "-";
        });
      }else{
        currentDeviceType = "-";
        currentDeviceCompanyName= "-";
        currentDeviceUWater= "-";
        currentDeviceWaterColumns= "-";
        currentDeviceDepth= "-";
        currentDeviceSalinity= "-";
        currentDeviceDrainingWater= "-";
        currentDevicePumpCompany= "-";
        currentDevicePumpCapacity= "-";
        currentDevicePumpPhases= "-";
        currentDeviceDateDischarge= "-";
      }
      getLandPlotDeviceHistory(landPlotDeviceID);
      emit(HomeGetLandDevicesSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        gotLandPlotDevices = false;
        zeroDevices = true;
        emit(HomeGetLandDevicesErrorState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        gotLandPlotDevices = false;
        zeroDevices = true;
        emit(HomeGetLandDevicesErrorState(error.toString()));
      }
    });
    emit(HomeGetDeviceDetailsSuccessState());
  }

  void changeLandPlotIndex(OptionItem optionItem)async {
    landPlotOptionItemSelected = optionItem;
    landPlotColumnsOptionItemSelected = OptionItem(id: 0, title: "العمود");
    landPlotPiecesOptionItemSelected = OptionItem(id: 0, title: "القطعة");
    landPlotDevicesOptionItemSelected = OptionItem(id: 0, title: "الجهاز");
    showDetails = false;
    print("CURRENT LAND PLOT ID IS ${landPlotOptionItemSelected.id}\n");
    print("CURRENT LAND PLOT NAME IS ${landPlotOptionItemSelected.title}\n");
    await getLandPlotColumns(landPlotOptionItemSelected.id);
    landPlotColumnsDropListModel?.listOptionItems.forEach((element) {
      print("Column : ${element.title}\n");
    });
    emit(HomeChangeLandPlotIndexState());
  }
  void changeLandPlotColumnsIndex(OptionItem optionItem)async {
    landPlotColumnsOptionItemSelected = optionItem;
    landPlotPiecesOptionItemSelected = OptionItem(id: 0, title: "القطعة");
    landPlotDevicesOptionItemSelected = OptionItem(id: 0, title: "الجهاز");
    showDetails = false;
    print("CURRENT Column ID IS ${landPlotColumnsOptionItemSelected.id}\n");
    print("CURRENT Column NAME IS ${landPlotColumnsOptionItemSelected.title}\n");
    await getLandPlotPieces(landPlotColumnsOptionItemSelected.id);
    landPlotPiecesDropListModel?.listOptionItems.forEach((element) {
      print("Piece : ${element.title}\n");
    });
    emit(HomeChangeLandPlotColumnsIndexState());
  }
  void changeLandPlotPiecesIndex(OptionItem optionItem)async {
    landPlotPiecesOptionItemSelected = optionItem;
    landPlotDevicesOptionItemSelected = OptionItem(id: 0, title: "الجهاز");
    zeroDevices = true;
    showDetails = false;
    print("CURRENT Piece ID IS ${landPlotPiecesOptionItemSelected.id}\n");
    print("CURRENT Piece NAME IS ${landPlotPiecesOptionItemSelected.title}\n");
    await getLandPlotDevices(landPlotPiecesOptionItemSelected.id);
    landPlotDevicesDropListModel?.listOptionItems.forEach((element) {
      print("Device : ${element.title}\n");
    });
    emit(HomeChangeLandPlotPiecesIndexState());
  }
  void changeLandPlotDevicesIndex(OptionItem optionItem) {
    landPlotDevicesOptionItemSelected = optionItem;
    print("CURRENT Device ID IS ${landPlotDevicesOptionItemSelected.id}\n");
    print("CURRENT Device NAME IS ${landPlotDevicesOptionItemSelected.title}\n");
    getDeviceMainData(landPlotDevicesOptionItemSelected.id);
    emit(HomeChangeLandPlotDevicesIndexState());
  }
  void changeShowDetails(){
    showDetails = !showDetails;
    emit(HomeChangeShowDetailsState());
  }

  void navigate(BuildContext context, route){
    Navigator.push(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
  }
}
