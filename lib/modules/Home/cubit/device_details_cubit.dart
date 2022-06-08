import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Home/cubit/device_details_states.dart';
import 'package:it_department/modules/Home/cubit/home_states.dart';
import 'package:transition_plus/transition_plus.dart';

class DeviceDetailsCubit extends Cubit<DeviceDetailsStates> {
  DeviceDetailsCubit() : super(DeviceDetailsInitialState());

  static DeviceDetailsCubit get(context) => BlocProvider.of(context);

  bool showMainData = false;
  bool showWellData = false;
  bool showPumpData = false;
  bool showHistoryData = false;

  void changeShowMainData(){
    showMainData = !showMainData;
    emit(DeviceDetailsChangeMainDataState());
  }
  void changeShowWellData(){
    showWellData = !showWellData;
    emit(DeviceDetailsChangeWellDataState());
  }
  void changeShowPumpData(){
    showPumpData = !showPumpData;
    emit(DeviceDetailsChangePumpDataState());
  }
  void changeShowHistoryData(){
    showHistoryData = !showHistoryData;
    emit(DeviceDetailsChangeHistoryDataState());
  }

  void navigate(BuildContext context, route){
    Navigator.push(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
  }
}
