import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/shared/fingerprint/cubit/fingerprint_cubit.dart';
import 'package:it_department/shared/fingerprint/cubit/fingerprint_setting_cubit.dart';
import 'package:it_department/shared/fingerprint/cubit/fingerprint_setting_states.dart';
import 'package:it_department/shared/fingerprint/cubit/fingerprint_states.dart';
import 'package:sizer/sizer.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../radio_button/custom_radio_button_builder.dart';
import '../../radio_button/custom_radio_group.dart';

class FingerPrintSettingScreen extends StatelessWidget {
  const FingerPrintSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FingerPrintSettingCubit()..getFingerPrintValue(),
      child: BlocConsumer<FingerPrintSettingCubit, FingerPrintSettingStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = FingerPrintSettingCubit.get(context);

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
                              "بصمة الأصبع",
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
                        InkWell(
                          onTap: (){
                            cubit.changeFingerPrintValue(!isFingerPrintEnabled);
                            if(isFingerPrintEnabled){
                              showFingerPrintBottomSheet(context, cubit);
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText("الفتح بإستخدام بصمة الاصبع :",
                                    style: TextStyle(color: lightGreen, fontFamily: "Questv", fontWeight: FontWeight.w600), minFontSize: 14, maxLines: 1, maxFontSize: 18,),
                                    const SizedBox(height: 4,),
                                    AutoSizeText("عند تمكينها ، ستحتاج إلى استخدام بصمة الإصبع لفتح التطبيق .",
                                      style: TextStyle(overflow: TextOverflow.ellipsis, color: lightGreen, fontFamily: "Questv"), textAlign: TextAlign.start, minFontSize: 10, maxFontSize: 12, maxLines: 3, overflow: TextOverflow.ellipsis,)
                                  ],
                                ),
                              ),
                              const Spacer(),
                              CustomSwitch(
                                value: isFingerPrintEnabled,
                                onChanged: (bool val){
                                    cubit.changeFingerPrintValue(val);
                                    if(isFingerPrintEnabled){
                                      showFingerPrintBottomSheet(context, cubit);
                                    }
                                },
                              ),
                            ],
                          ),
                        ),
                        Divider(thickness: 0.4, color: lightGreen,),
                        const SizedBox(height: 8,),
/*                        cubit.isFingerPrintEnabled ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText("قفل تلقائى",
                              style: TextStyle(color: lightGreen, fontFamily: "Questv", fontWeight: FontWeight.w600), minFontSize: 14, maxLines: 1, maxFontSize: 18,),
                            const SizedBox(height: 8,),
                            MyRadioGroup<String>.builder(
                              groupValue: cubit.fingerPrintLockTime,
                              onChanged: (value){
                                cubit.changeFingerPrintLockTimeValue(value!);
                              },
                              items: cubit.status,
                              itemBuilder: (item) => MyRadioButtonBuilder(
                                item,
                              ),
                              activeColor: lightGreen,
                              textStyle: TextStyle(color: lightGreen, fontFamily: "Questv",),
                              spaceBetween: 35,
                            ),
                          ],
                        ) : getEmptyWidget(),*/
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
  void showFingerPrintBottomSheet(BuildContext context, FingerPrintSettingCubit settingCubit){
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (sheetContext){
          return BlocProvider(
            create: (context) => FingerPrintCubit()..auth(context),
            child: BlocConsumer<FingerPrintCubit, FingerPrintStates>(
              listener: (context, state){
                if(state is FingerPrintSuccessState){
                  Future.delayed(const Duration(milliseconds: 300)).then((value){
                    Navigator.pop(sheetContext);
                  });
                }
              },
              builder: (context, state){

                var cubit = FingerPrintCubit.get(context);

                return WillPopScope(
                  onWillPop: (){
                    cubit.cancelAuthentication(context);
                    settingCubit.changeFingerPrintValue(false);
                    return Future.value();
                  },
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      color: veryLightGreen.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 84.0, top: 36),
                            child: Column(
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
                                    child: Icon(Icons.refresh_rounded, color: lightGreen, size: 48,)) : getEmptyWidget(),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: TextButton(
                              onPressed: (){
                                    cubit.cancelAuthentication(context);
                                    settingCubit.changeFingerPrintValue(false);
                              },
                              style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => veryLightGreen.withOpacity(0.08))),
                              child: Text("الغاء", style: TextStyle(color: lightGreen, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: "Questv"),),),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
    );
  }
}
