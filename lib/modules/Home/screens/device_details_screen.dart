import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:it_department/models/land_plot_model.dart';
import 'package:it_department/modules/Home/cubit/device_details_cubit.dart';
import 'package:it_department/shared/components.dart';
import 'package:it_department/shared/constants.dart';

import '../cubit/device_details_states.dart';

class DeviceDetailsScreen extends StatelessWidget {
  const DeviceDetailsScreen({Key? key, required this.currentDeviceType, required this.currentDeviceTowersCount, required this.currentDeviceTotalSpace, required this.currentDeviceTotalNotValidSpace, required this.currentDeviceCategory, required this.currentDevicePlanesCount, required this.currentDeviceTotalNotValidSpaceReason, required this.currentDeviceTotalValidSpace, required this.currentColumn, required this.currentDevice, required this.currentPiece, required this.currentDeviceCompanyName, required this.currentDeviceDepth, required this.currentDeviceUWater, required this.currentDeviceSalinity, required this.currentDeviceWaterColumns, required this.currentDeviceDrainingWater, required this.currentDevicePumpCompany, required this.currentDevicePumpCapacity, required this.currentDevicePumpPhases, required this.currentDeviceDateDischarge, required this.deviceHistoryList}) : super(key: key);
  final String currentDeviceType;
  final String currentDeviceTowersCount;
  final String currentDeviceTotalSpace;
  final String currentDeviceTotalValidSpace;
  final String currentDeviceTotalNotValidSpace;
  final String currentDeviceTotalNotValidSpaceReason;
  final String currentDevicePlanesCount;
  final String currentDeviceCategory;
  final String currentColumn;
  final String currentPiece;
  final String currentDevice;
  final String currentDeviceCompanyName;
  final String currentDeviceUWater;
  final String currentDeviceWaterColumns;
  final String currentDeviceDepth;
  final String currentDeviceSalinity;
  final String currentDeviceDrainingWater;
  final String currentDevicePumpCompany;
  final String currentDevicePumpCapacity;
  final String currentDevicePumpPhases;
  final String currentDeviceDateDischarge;
  final List<LandPlotDeviceHistoryModel> deviceHistoryList;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceDetailsCubit(),
      child: BlocConsumer<DeviceDetailsCubit, DeviceDetailsStates>(
        listener: (context, state){},
        builder: (context, state){

          var cubit = DeviceDetailsCubit.get(context);

          return SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: darkGreen,
                body: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FadeInDown(
                          duration: const Duration(milliseconds: 800),
                          child: Column(
                            children: [
                              AutoSizeText("بيانات جهاز", style: TextStyle(color: white,fontSize: 20, fontFamily: "Questv"), maxLines: 2, minFontSize: 12,),
                              const SizedBox(height: 4,),
                              AutoSizeText("$currentColumn / $currentPiece / $currentDevice", style: TextStyle(color: orangeColor, fontSize: 20, fontFamily: "Questv"), maxLines: 2, minFontSize: 12,),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48,),
                        FadeInUp( duration: const Duration(milliseconds: 1000), child: deviceMainDetailsItem(context, cubit)),
                        const SizedBox(height: 12,),
                        FadeInUp( duration: const Duration(milliseconds: 1600), child: deviceWellDetailsItem(context, cubit)),
                        const SizedBox(height: 12,),
                        FadeInUp( duration: const Duration(milliseconds: 1800), child: devicePumpDetailsItem(context, cubit)),
                        const SizedBox(height: 12,),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1800),
                          child: deviceHistoryDetailsItem(context, cubit),
                        ),
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
  Widget deviceMainDetailsItem(BuildContext context, DeviceDetailsCubit cubit){
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: InkWell(
              onTap: (){
                cubit.changeShowMainData();
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText("البيانات الأساسية", style: TextStyle(color: darkGreen, fontFamily: "Hamed", fontWeight: FontWeight.bold, fontSize: 24,), minFontSize: 8, maxLines: 2, ),
                  const Spacer(),
                  Icon(
                    cubit.showMainData ? IconlyBroken.arrowUp2 : IconlyBroken.arrowDown2,
                    color: lightGreen,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
             key: const Key("MainData"),
             child: cubit.showMainData ? Padding(
               padding: const EdgeInsets.all(4.0),
               child: Container(
                 decoration: BoxDecoration(
                     borderRadius: const BorderRadius.all(Radius.circular(8)),
                     border: Border.all(
                         color: lightGreen, width: 2
                     ),
                     color: lightGreen
                 ),
                 child: Row(
                   mainAxisSize: MainAxisSize.max,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Expanded(
                       flex: 2,
                       child: Column(
                         mainAxisSize: MainAxisSize.min,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             decoration: BoxDecoration(
                               borderRadius: const BorderRadius.only(topRight: Radius.circular(8)),
                               color: lightGrey,
                             ),
                             child: const Padding(
                               padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText("الـنـوع", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),minFontSize: 8, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                           const SizedBox(height: 1,),
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             color: lightGrey,
                             child: const Padding(
                               padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText("عدد أبراج", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                           const SizedBox(height: 1,),
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             color: lightGrey,
                             child: const Padding(
                               padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText("مساحة كلية", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                           const SizedBox(height: 1,),
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             color: lightGrey,
                             child: const Padding(
                               padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText("مساحة غير صالحة للزراعة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                           const SizedBox(height: 1,),
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             color: lightGrey,
                             child: const Padding(
                               padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText("فئة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                           const SizedBox(height: 1,),
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             color: lightGrey,
                             child: const Padding(
                               padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText("عدد طايرة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                           const SizedBox(height: 1,),
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             color: lightGrey,
                             child: const Padding(
                               padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText("مساحة صالحة للزراعة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                           const SizedBox(height: 1,),
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             decoration: BoxDecoration(
                               borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8)),
                               color: lightGrey,
                             ),
                             child: const Padding(
                               padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText("سبب عدم الصلاحية", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                         ],
                       ),
                     ),
                     const SizedBox(width: 1,),
                     Expanded(
                       flex: 3,
                       child: Column(
                         mainAxisSize: MainAxisSize.min,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             decoration: BoxDecoration(
                               color: white,
                               borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
                             ),
                             child: Padding(
                               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText(currentDeviceType, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),minFontSize: 12, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                           const SizedBox(height: 1,),
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             color: white,
                             child: Padding(
                               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText(currentDeviceTowersCount, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                           const SizedBox(height: 1,),
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             color: white,
                             child: Padding(
                               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText(currentDeviceTotalSpace, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),minFontSize: 12, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                           const SizedBox(height: 1,),
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             color: white,
                             child: Padding(
                               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText(currentDeviceTotalNotValidSpace, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                           const SizedBox(height: 1,),
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             color: white,
                             child: Padding(
                               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText(currentDeviceCategory, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                           const SizedBox(height: 1,),
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             color: white,
                             child:  Padding(
                               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText(currentDevicePlanesCount, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                           const SizedBox(height: 1,),
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             color: white,
                             child: Padding(
                               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText(currentDeviceTotalValidSpace, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                           const SizedBox(height: 1,),
                           Container(
                             width: double.infinity,
                             height: MediaQuery.of(context).size.height * 0.05,
                             decoration: BoxDecoration(
                               borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8)),
                               color: white,
                             ),
                             child: Padding(
                               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                               child: Center(child: AutoSizeText(currentDeviceTotalNotValidSpaceReason, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ],
                 ),
               ),
             ) : getEmptyWidget(),
          ),
        ],
      ),
    );
  }

  Widget deviceWellDetailsItem(BuildContext context, DeviceDetailsCubit cubit){
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: InkWell(
              onTap: (){
                cubit.changeShowWellData();
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText("بيانات البئر", style: TextStyle(color: darkGreen, fontFamily: "Hamed", fontWeight: FontWeight.bold, fontSize: 24,), minFontSize: 8, maxLines: 2, ),
                  const Spacer(),
                  Icon(
                    cubit.showWellData ? IconlyBroken.arrowUp2 : IconlyBroken.arrowDown2,
                    color: lightGreen,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            key: const Key("WellData"),
            child: cubit.showWellData ? Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                        color: lightGreen, width: 2
                    ),
                    color: lightGreen
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(8)),
                              color: lightGrey,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText("الشركة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),minFontSize: 8, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            color: lightGrey,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText("وش", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            color: lightGrey,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText("التصرف", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            color: lightGrey,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText("عمق", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            color: lightGrey,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText("عمود", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8)),
                              color: lightGrey,
                            ),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText("الملوحة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 1,),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText(currentDeviceCompanyName, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),minFontSize: 12, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            color: white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText(currentDeviceUWater, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            color: white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText(currentDeviceDrainingWater, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),minFontSize: 12, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            color: white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText(currentDeviceDepth, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            color: white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText(currentDeviceWaterColumns, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8)),
                              color: white,
                            ),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child:  Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText(currentDeviceSalinity, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ) : getEmptyWidget(),
          ),
        ],
      ),
    );
  }

  Widget devicePumpDetailsItem(BuildContext context, DeviceDetailsCubit cubit){
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: InkWell(
              onTap: (){
                cubit.changeShowPumpData();
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText("بيانات الطلمبة", style: TextStyle(color: darkGreen, fontFamily: "Hamed", fontWeight: FontWeight.bold, fontSize: 24,), minFontSize: 8, maxLines: 2, ),
                  const Spacer(),
                  Icon(
                    cubit.showPumpData ? IconlyBroken.arrowUp2 : IconlyBroken.arrowDown2,
                    color: lightGreen,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            key: const Key("PumpData"),
            child: cubit.showPumpData ? Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                        color: lightGreen, width: 2
                    ),
                    color: lightGreen
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(8)),
                              color: lightGrey,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText("الشركة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),minFontSize: 8, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            color: lightGrey,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText("قدرة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            color: lightGrey,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText("مراحل", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8)),
                              color: lightGrey,
                            ),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText("تاريخ النزول", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 1,),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText(currentDevicePumpCompany, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),minFontSize: 12, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            color: white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText(currentDevicePumpCapacity, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            color: white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText(currentDevicePumpPhases, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),minFontSize: 12, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8)),
                              color: white,
                            ),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child:  Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Center(child: AutoSizeText(currentDeviceDateDischarge, style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ) : getEmptyWidget(),
          ),
        ],
      ),
    );
  }

  Widget deviceHistoryDetailsItem(BuildContext context, DeviceDetailsCubit cubit){
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: InkWell(
              onTap: (){
                cubit.changeShowHistoryData();
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText("تفاصيل إيجار / زراعات الجهاز", style: TextStyle(color: darkGreen, fontFamily: "Hamed", fontWeight: FontWeight.bold, fontSize: 24,), minFontSize: 8, maxLines: 2, ),
                  const Spacer(),
                  Icon(
                    cubit.showHistoryData ? IconlyBroken.arrowUp2 : IconlyBroken.arrowDown2,
                    color: lightGreen,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: deviceHistoryList.length,
              itemBuilder: (context, index) =>
                  deviceHistoryDetailsSubItem(context, cubit, index))
        ],
      ),
    );
  }
  Widget deviceHistoryDetailsSubItem(BuildContext context, DeviceDetailsCubit cubit, int index){
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      key: const Key("HistoryData"),
      child: cubit.showHistoryData ? Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                  color: lightGreen, width: 2
              ),
              color: lightGreen
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(8)),
                        color: lightGrey,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: Center(child: AutoSizeText("النوع", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),minFontSize: 8, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                      ),
                    ),
                    const SizedBox(height: 1,),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      color: lightGrey,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: Center(child: AutoSizeText("المستأجر - القطاع الزراعى", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                      ),
                    ),
                    const SizedBox(height: 1,),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      color: lightGrey,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: Center(child: AutoSizeText("المساحة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                      ),
                    ),
                    const SizedBox(height: 1,),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      color: lightGrey,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: Center(child: AutoSizeText("من تاريخ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                      ),
                    ),
                    const SizedBox(height: 1,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8)),
                        color: lightGrey,
                      ),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: Center(child: AutoSizeText("إلى تاريخ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 1,),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: Center(child: AutoSizeText(deviceHistoryList[index].type??"-", style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),minFontSize: 8, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                      ),
                    ),
                    const SizedBox(height: 1,),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      color: white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: Center(child: AutoSizeText(deviceHistoryList[index].name??"-", style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                      ),
                    ),
                    const SizedBox(height: 1,),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      color: white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: Center(child: AutoSizeText(deviceHistoryList[index].space??"-", style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),minFontSize: 8, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                      ),
                    ),
                    const SizedBox(height: 1,),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      color: white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: Center(child: AutoSizeText(deviceHistoryList[index].from??"-", style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),minFontSize: 8, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                      ),
                    ),
                    const SizedBox(height: 1,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8)),
                        color: white,
                      ),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child:  Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: Center(child: AutoSizeText(deviceHistoryList[index].to??"-", style: TextStyle(color: lightGreen, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 8, overflow: TextOverflow.ellipsis,)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ) : getEmptyWidget(),
    );
  }
}
