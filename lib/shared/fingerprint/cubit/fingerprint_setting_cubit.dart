import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/shared/fingerprint/cubit/fingerprint_setting_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class FingerPrintSettingCubit extends Cubit<FingerPrintSettingStates>{
  FingerPrintSettingCubit() : super(FingerPrintSettingInitialState());

  static FingerPrintSettingCubit get(context) => BlocProvider.of(context);

  int stackIndex = 0;
  String fingerPrintLockTime = "بعد 1 دقيقة";

  List<String> status = ["قفل دورياً", "بعد 1 دقيقة", "بعد 30 دقيقة"];

  void getFingerPrintValue()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("isFingerPrintEnabled")){
      isFingerPrintEnabled = false;
    }else{
      isFingerPrintEnabled = prefs.getBool("isFingerPrintEnabled")!;
      fingerPrintLockTime = prefs.getString("FingerPrintLockTime")!;
      print("FINGER TIME $fingerPrintLockTime\n");
    }
    emit(FingerPrintSettingGetFingerValueState());
  }
  void changeFingerPrintValue(bool newValue)async {
    isFingerPrintEnabled = newValue;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isFingerPrintEnabled", isFingerPrintEnabled);

    print("ENABLED VALUE : $isFingerPrintEnabled\n");
    emit(FingerPrintSettingChangeFingerValueState());
  }
  void changeFingerPrintLockTimeValue(String newValue)async {
    fingerPrintLockTime = newValue;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("FingerPrintLockTime", fingerPrintLockTime);
    print("FINGER TIME CHANGED TO $fingerPrintLockTime\n");
    emit(FingerPrintSettingChangeFingerLockTimeState());
  }
}