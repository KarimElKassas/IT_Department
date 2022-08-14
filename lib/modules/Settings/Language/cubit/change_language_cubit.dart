import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Settings/Language/cubit/change_language_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/constants.dart';

class ChangeLanguageCubit extends Cubit<ChangeLanguageStates>{
  ChangeLanguageCubit() : super(ChangeLanguageInitialState());
  
  static ChangeLanguageCubit get(context) => BlocProvider.of(context);
  
  List<String> status = ["الإنجليزية", "العربية"].reversed.toList();

  void getCurrentLanguage()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("AppLanguage")){
      currentLanguage = prefs.getString("AppLanguage")!;
    }
    emit(ChangeLanguageGetLanguageState());
  }
  void changeAppLanguage(String newLanguage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentLanguage = newLanguage;
    prefs.setString("AppLanguage", currentLanguage);
    emit(ChangeLanguageSuccessState());
  }
}
