import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/onBoarding/cubit/on_boarding_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingCubit extends Cubit<OnBoardingStates>{
  OnBoardingCubit() : super(OnBoardingInitialState());

  static OnBoardingCubit get(context) => BlocProvider.of(context);

  bool isLast = false;
  List<Widget>? onBoardingList;

  void initList(Widget firstPage, Widget secondPage, Widget thirdPage){
    onBoardingList = [
      firstPage,
      secondPage,
      thirdPage
    ];
    emit(OnBoardingInitializeListState());
  }

  void changeIndex(bool isLast){
    this.isLast = isLast;
    emit(OnBoardingChangePageState());
  }

  void setPreference()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("FirstTime", false);
    emit(OnBoardingSetPreferenceState());
  }
}