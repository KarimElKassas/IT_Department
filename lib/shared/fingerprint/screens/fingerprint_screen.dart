import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart';
import 'package:it_department/modules/Chat/display/screens/display_chats_screen.dart';
import 'package:it_department/modules/Settings/Home/screens/settings_home_screen.dart';
import 'package:it_department/shared/components.dart';
import 'package:it_department/shared/constants.dart';
import 'package:it_department/shared/fingerprint/cubit/fingerprint_cubit.dart';
import 'package:it_department/shared/fingerprint/cubit/fingerprint_states.dart';
import 'package:sizer/sizer.dart';

class FingerPrintScreen extends StatelessWidget {

  const FingerPrintScreen({Key? key, required this.openedFrom}) : super(key: key);
  final String openedFrom;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FingerPrintCubit()..auth(context),
      child: BlocConsumer<FingerPrintCubit, FingerPrintStates>(
        listener: (context, state){
          if(state is FingerPrintSuccessState){
            Future.delayed(const Duration(milliseconds: 500)).then((value){
              if(openedFrom == "Splash"){
                lastOpenedScreen = "";
                finish(context, DisplayChatsScreen(initialIndex: 0));
              }else if(openedFrom == "Display"){
                lastOpenedScreen = "";
                finish(context, const SettingsHomeScreen());
              }else if(openedFrom == "Main"){
                lastOpenedScreen = "";
                Navigator.pop(context);
              }
            });
          }
        },
        builder: (context, state){

          var cubit = FingerPrintCubit.get(context);

          return WillPopScope(
            onWillPop: (){
              if(openedFrom == "Main"){
                return Future.value(false);
              }else{
                lastOpenedScreen = "";
                cubit.cancelAuthentication(context);
                return Future.value(false);
              }

            },
            child: Scaffold(
              appBar: AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                  // For Android (dark icons)
                  statusBarBrightness: Brightness.light, // For iOS (dark icons)
                ),
                  elevation: 0,
                  toolbarHeight: 0,
                  automaticallyImplyLeading: false,
                  backgroundColor: veryLightGreen.withOpacity(0.1)
              ),
              body: Container(
                color: veryLightGreen.withOpacity(0.1),
                height: 100.h,
                width: 100.w,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      cubit.icon,
                      const SizedBox(height: 12,),
                      AutoSizeText(
                        cubit.title,
                        style: TextStyle(
                            color: lightGreen,
                            fontFamily: "Questv",
                            fontWeight: FontWeight.w600),
                        minFontSize: 18,
                        maxLines: 1,
                        maxFontSize: 20,
                      ),
                      const SizedBox(height: 16,),
                      cubit.refresh ? InkWell(
                          onTap: (){
                            cubit.changeRefreshButton(false);
                            cubit.auth(context);
                          },
                          child: Icon(Icons.refresh_rounded, color: lightGreen, size: 48,)) : getEmptyWidget()
                    ],
                  ),
                ),
              ),
            ),
          );

        },
      ),
    );
  }
}
