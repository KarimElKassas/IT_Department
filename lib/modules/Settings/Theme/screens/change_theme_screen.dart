import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/radio_button/custom_radio_button_builder.dart';
import '../../../../shared/radio_button/custom_radio_group.dart';
import '../cubit/change_theme_cubit.dart';
import '../cubit/change_theme_states.dart';

class ChangeThemeSettingScreen extends StatelessWidget {
  const ChangeThemeSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangeThemeCubit()..getCurrentTheme(),
      child: BlocConsumer<ChangeThemeCubit, ChangeThemeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ChangeThemeCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: veryLightGreen.withOpacity(0.08),
              flexibleSpace: SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Transform.scale(
                            scale: 1,
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: lightGreen,
                              size: 28,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "الإعدادات",
                              style: TextStyle(
                                  color: lightGreen,
                                  letterSpacing: 1.5,
                                  fontFamily: "Questv",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            //cubit.startSearch(context);
                          },
                          icon: Icon(
                            Icons.menu_open_rounded,
                            color: lightGreen,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                color: veryLightGreen.withOpacity(0.08),
                height: 100.h,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText("مظهر التطبيق :",
                                    style: TextStyle(color: lightGreen, fontFamily: "Questv", fontWeight: FontWeight.w600), minFontSize: 14, maxLines: 1, maxFontSize: 18,),
                                  const SizedBox(height: 4,),
                                  AutoSizeText("قم باختيار مظهر التطبيق  ( فاتح / داكن )",
                                    style: TextStyle(overflow: TextOverflow.ellipsis, color: lightGreen, fontFamily: "Questv"), textAlign: TextAlign.start, minFontSize: 10, maxFontSize: 12, maxLines: 3, overflow: TextOverflow.ellipsis,)
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(thickness: 0.4, color: lightGreen,),
                        const SizedBox(height: 8,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const SizedBox(height: 8,),
                            MyRadioGroup<String>.builder(
                              groupValue: currentTheme == "dark" ? "داكن" : "فاتح",
                              onChanged: (value){
                                if(value == "داكن"){
                                  cubit.changeAppTheme("dark");
                                }else{
                                  cubit.changeAppTheme("light");
                                }
                              },
                              items: cubit.status,
                              itemBuilder: (item) => MyRadioButtonBuilder(
                                item,
                              ),
                              activeColor: lightGreen,
                              textStyle: TextStyle(color: lightGreen, fontFamily: "Questv",),
                              spaceBetween: 45,
                            ),
                          ],
                        )
                      ],
                    ),
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
