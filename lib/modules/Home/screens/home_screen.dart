import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/svg.dart';
import 'package:it_department/modules/Home/cubit/home_cubit.dart';
import 'package:it_department/modules/Home/cubit/home_states.dart';
import 'package:it_department/modules/Home/screens/device_details_screen.dart';
import 'package:it_department/shared/components.dart';
import 'package:it_department/shared/constants.dart';

import '../../../shared/dropdown/select_drop_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getLandPlots(),
      child: BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = HomeCubit.get(context);

            return SafeArea(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  backgroundColor: darkGreen,
                  body: Builder(builder: (context) {
                    return Container(
                      constraints: const BoxConstraints.expand(),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 10,
                            child: Container(
                              //alignment: Alignment.topCenter,
                              constraints: const BoxConstraints.expand(),
                              child: SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 32),
                                    if (cubit.gotLandPlots)
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: FadeInUp(
                                          duration:
                                              const Duration(seconds: 1),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "اختر جهاز لعرض تفاصيله",
                                                  style: TextStyle(
                                                      color: white,
                                                      fontFamily: "Questv",
                                                      fontSize: 18),
                                                ),
                                                const SizedBox(
                                                  height: 18,
                                                ),
                                                SelectDropList(
                                                    cubit
                                                        .landPlotOptionItemSelected,
                                                    cubit
                                                        .landPlotDropListModel,
                                                    (optionItem) {
                                                  cubit.changeLandPlotIndex(
                                                      optionItem);
                                                }, null),
                                                const SizedBox(
                                                  height: 18,
                                                ),
                                                cubit.gotLandPlotColumns
                                                    ? SelectDropList(
                                                        cubit
                                                            .landPlotColumnsOptionItemSelected,
                                                        cubit
                                                            .landPlotColumnsDropListModel,
                                                        (optionItem) {
                                                        cubit
                                                            .changeLandPlotColumnsIndex(
                                                                optionItem);
                                                      }, null)
                                                    : getEmptyWidget(),
                                                const SizedBox(
                                                  height: 18,
                                                ),
                                                cubit.gotLandPlotPieces
                                                    ? SelectDropList(
                                                        cubit
                                                            .landPlotPiecesOptionItemSelected,
                                                        cubit
                                                            .landPlotPiecesDropListModel,
                                                        (optionItem) {
                                                        cubit
                                                            .changeLandPlotPiecesIndex(
                                                                optionItem);
                                                      }, null)
                                                    : getEmptyWidget(),
                                                const SizedBox(
                                                  height: 18,
                                                ),
                                                cubit.gotLandPlotDevices
                                                    ? SelectDropList(
                                                        cubit
                                                            .landPlotDevicesOptionItemSelected,
                                                        cubit
                                                            .landPlotDevicesDropListModel,
                                                        (optionItem) {
                                                        cubit
                                                            .changeLandPlotDevicesIndex(
                                                                optionItem);
                                                      }, null)
                                                    : getEmptyWidget(),
                                                const SizedBox(
                                                  height: 18,
                                                ),
                                                if (cubit
                                                        .landPlotDevicesOptionItemSelected
                                                        .id !=
                                                    0)
                                                  Align(
                                                    alignment: Alignment
                                                        .bottomCenter,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                                  .only(
                                                              bottom: 36),
                                                      child: InkWell(
                                                        onTap: () {
                                                          cubit.navigate(
                                                              context,
                                                              DeviceDetailsScreen(
                                                                currentDeviceType:
                                                                    cubit
                                                                        .currentDeviceType,
                                                                currentDeviceTowersCount:
                                                                    cubit
                                                                        .currentDeviceTowersCount,
                                                                currentDeviceTotalSpace:
                                                                    cubit
                                                                        .currentDeviceTotalSpace,
                                                                currentDeviceTotalNotValidSpace:
                                                                    cubit
                                                                        .currentDeviceTotalNotValidSpace,
                                                                currentDeviceCategory:
                                                                    cubit
                                                                        .currentDeviceCategory,
                                                                currentDevicePlanesCount:
                                                                    cubit
                                                                        .currentDevicePlanesCount,
                                                                currentDeviceTotalNotValidSpaceReason:
                                                                    cubit
                                                                        .currentDeviceTotalNotValidSpaceReason,
                                                                currentDeviceTotalValidSpace:
                                                                    cubit
                                                                        .currentDeviceTotalValidSpace,
                                                                currentColumn:
                                                                    cubit
                                                                        .landPlotColumnsOptionItemSelected
                                                                        .title,
                                                                currentDevice:
                                                                    cubit
                                                                        .landPlotDevicesOptionItemSelected
                                                                        .title,
                                                                currentPiece: cubit
                                                                    .landPlotPiecesOptionItemSelected
                                                                    .title,
                                                                currentDeviceCompanyName:
                                                                    cubit
                                                                        .currentDeviceCompanyName,
                                                                currentDeviceDepth:
                                                                    cubit
                                                                        .currentDeviceDepth,
                                                                currentDeviceUWater:
                                                                    cubit
                                                                        .currentDeviceUWater,
                                                                currentDeviceSalinity:
                                                                    cubit
                                                                        .currentDeviceSalinity,
                                                                currentDeviceWaterColumns:
                                                                    cubit
                                                                        .currentDeviceWaterColumns,
                                                                currentDeviceDrainingWater:
                                                                    cubit
                                                                        .currentDeviceDrainingWater,
                                                                currentDevicePumpCompany:
                                                                    cubit
                                                                        .currentDevicePumpCompany,
                                                                currentDevicePumpCapacity:
                                                                    cubit
                                                                        .currentDevicePumpCapacity,
                                                                currentDevicePumpPhases:
                                                                    cubit
                                                                        .currentDevicePumpPhases,
                                                                currentDeviceDateDischarge:
                                                                    cubit
                                                                        .currentDeviceDateDischarge,
                                                                deviceHistoryList:
                                                                    cubit
                                                                        .landPlotDeviceHistoryList,
                                                              ));
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            color: white,
                                                          ),
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.05,
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        2.0),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8),
                                                                    color:
                                                                        darkGreen,
                                                                  ),
                                                                  child:
                                                                      Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        (Icon(
                                                                      !cubit.showDetails
                                                                          ? IconlyBold.search
                                                                          : IconlyBold.closeSquare,
                                                                      color:
                                                                          white,
                                                                      size: MediaQuery.of(context).size.width *
                                                                          0.08,
                                                                    )),
                                                                  ),
                                                                  height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height,
                                                                  width: MediaQuery.of(context)
                                                                          .size
                                                                          .width *
                                                                      0.1,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 24,
                                                              ),
                                                              AutoSizeText(
                                                                !cubit.showDetails
                                                                    ? "عرض بيانات الجهاز"
                                                                    : "اخفاء بيانات الجهاز",
                                                                style: TextStyle(
                                                                    color:
                                                                        darkGreen,
                                                                    fontFamily:
                                                                        "Hamed",
                                                                    fontSize:
                                                                        18),
                                                                maxLines: 1,
                                                                minFontSize:
                                                                    12,
                                                              ),
                                                              const SizedBox(
                                                                width: 32,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                else
                                                  getEmptyWidget(),
                                                if (cubit.showDetails)
                                                  FadeInUp(
                                                      duration:
                                                          const Duration(
                                                              milliseconds:
                                                                  1500),
                                                      child:
                                                          deviceDetailsItem(
                                                              context,
                                                              cubit,
                                                              state))
                                                else
                                                  getEmptyWidget(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      getEmptyWidget(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color: white,
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 24),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      color: darkGreen,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                          'assets/images/logo_side_white.svg',
                                          alignment: Alignment.center,
                                          //width: MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))
                        ],
                      ),
                    );
                  }),
                ),
              ),
            );
          }),
    );
  }

  Widget deviceDetailsItem(
      BuildContext context, HomeCubit cubit, HomeStates state) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: orangeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.only(topRight: Radius.circular(8)),
                    color: Colors.grey[350],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      "الـنـوع",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w800),
                      minFontSize: 12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      "عدد أبراج",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      "مساحة كلية",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      "مساحة غير صالحة للزراعة",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      "فئة",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      "عدد طايرة",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      "مساحة صالحة للزراعة",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(8)),
                    color: Colors.grey[350],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      "سبب عدم الصلاحية",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 1,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(8)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      cubit.currentDeviceType,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w800),
                      minFontSize: 12,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      cubit.currentDeviceTowersCount,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      cubit.currentDeviceTotalSpace,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w800),
                      minFontSize: 12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      cubit.currentDeviceTotalNotValidSpace,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      cubit.currentDeviceCategory,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      cubit.currentDevicePlanesCount,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      cubit.currentDeviceTotalValidSpace,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.only(bottomLeft: Radius.circular(8)),
                    color: white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Center(
                        child: AutoSizeText(
                      cubit.currentDeviceTotalNotValidSpaceReason,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
