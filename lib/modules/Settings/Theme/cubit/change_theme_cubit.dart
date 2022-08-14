import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/constants.dart';
import 'change_theme_states.dart';

class ChangeThemeCubit extends Cubit<ChangeThemeStates>{
  ChangeThemeCubit() : super(ChangeThemeInitialState());
  
  static ChangeThemeCubit get(context) => BlocProvider.of(context);
  
  List<String> status = ["داكن", "فاتح"].reversed.toList();

  void getCurrentTheme()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("AppTheme")){
      currentTheme = prefs.getString("AppTheme")!;
    }
    emit(ChangeThemeGetThemeState());
  }
  void changeAppTheme(String newTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentTheme = newTheme;
    prefs.setString("AppTheme", currentTheme);
    emit(ChangeThemeSuccessState());
  }
}
