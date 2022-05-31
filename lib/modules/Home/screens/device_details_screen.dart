import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:it_department/models/land_plot_model.dart';
import 'package:it_department/shared/constants.dart';

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
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: darkGreen,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Column(
                      children: [
                        AutoSizeText("بيانات جهاز", style: TextStyle(color: white,fontSize: 20, fontFamily: "Questv"), maxLines: 1, minFontSize: 12,),
                        const SizedBox(height: 4,),
                        AutoSizeText("$currentColumn / $currentPiece / $currentDevice", style: TextStyle(color: orangeColor, fontSize: 20, fontFamily: "Questv"), maxLines: 1, minFontSize: 12,),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36,),
                  FadeInRight( duration: const Duration(milliseconds: 800), child: AutoSizeText("البيانات الأساسية :", style: TextStyle(color: white,fontSize: 18, fontFamily: "Questv"), maxLines: 1, minFontSize: 12,)),
                  const SizedBox(height: 12,),
                  FadeInUp( duration: const Duration(milliseconds: 1000), child: deviceMainDetailsItem(context)),
                  const SizedBox(height: 12,),
                  FadeInRight( duration: const Duration(milliseconds: 1200), child: AutoSizeText("بيانات البئر :", style: TextStyle(color: white,fontSize: 18, fontFamily: "Questv"), maxLines: 1, minFontSize: 12,)),
                  const SizedBox(height: 12,),
                  FadeInUp( duration: const Duration(milliseconds: 1600), child: deviceWellDetailsItem(context)),
                  const SizedBox(height: 12,),
                  FadeInRight( duration: const Duration(milliseconds: 1800), child: AutoSizeText("بيانات الطلمبة :", style: TextStyle(color: white,fontSize: 18, fontFamily: "Questv"), maxLines: 1, minFontSize: 12,)),
                  const SizedBox(height: 12,),
                  FadeInUp( duration: const Duration(milliseconds: 1800), child: devicePumpDetailsItem(context)),
                  const SizedBox(height: 12,),
                  FadeInRight( duration: const Duration(milliseconds: 1800), child: AutoSizeText("تفاصيل إيجار / زراعات الجهاز", style: TextStyle(color: white,fontSize: 18, fontFamily: "Questv"), maxLines: 1, minFontSize: 12,)),
                  const SizedBox(height: 12,),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1800),
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: deviceHistoryList.length,
                        itemBuilder: (context, index) =>
                            deviceHistoryDetailsItem(context, index)),
                  ),
                  //FadeInUp( duration: const Duration(milliseconds: 1800), child: deviceHistoryDetailsItem(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget deviceMainDetailsItem(BuildContext context){
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
                    color: Colors.grey[350],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("الـنـوع", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16),minFontSize: 10, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("عدد أبراج", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("مساحة كلية", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("مساحة غير صالحة للزراعة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("فئة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("عدد طايرة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("مساحة صالحة للزراعة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8)),
                    color: Colors.grey[350],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("سبب عدم الصلاحية", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
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
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDeviceType, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16),minFontSize: 12, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDeviceTowersCount, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDeviceTotalSpace, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16),minFontSize: 12, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDeviceTotalNotValidSpace, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDeviceCategory, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDevicePlanesCount, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDeviceTotalValidSpace, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
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
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDeviceTotalNotValidSpaceReason, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800,),maxLines: 1, minFontSize: 12, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget deviceWellDetailsItem(BuildContext context){
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
                    color: Colors.grey[350],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("الشركة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16),minFontSize: 10, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("وش", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("التصرف", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("عمق", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("عمود", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8)),
                      color: Colors.grey[350],
                    ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("الملوحة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
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
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDeviceCompanyName, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16),minFontSize: 10, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDeviceUWater, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDeviceDrainingWater, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16),minFontSize: 10, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDeviceDepth, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDeviceWaterColumns, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
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
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDeviceSalinity, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget devicePumpDetailsItem(BuildContext context){
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
                    color: Colors.grey[350],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("الشركة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16),minFontSize: 10, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("قدرة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("مراحل", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8)),
                      color: Colors.grey[350],
                    ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText("تاريخ النزول", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
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
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDevicePumpCompany, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16),minFontSize: 10, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDevicePumpCapacity, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDevicePumpPhases, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16),minFontSize: 10, maxLines: 1, overflow: TextOverflow.ellipsis,)),
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
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Center(child: AutoSizeText(currentDeviceDateDischarge, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget deviceHistoryDetailsItem(BuildContext context, int index){
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
                    color: Colors.grey[350],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                    child: Center(child: AutoSizeText("النوع", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),minFontSize: 10, maxLines: 2, overflow: TextOverflow.ellipsis,textAlign: TextAlign.center)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                    child: Center(child: AutoSizeText("المستأجر - \n القطاع الزراعى", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 16,),maxLines: 2, minFontSize: 10, textAlign: TextAlign.center,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                    child: Center(child: AutoSizeText("المساحة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[350],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                    child: Center(child: AutoSizeText("من تاريخ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8)),
                    color: Colors.grey[350],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                    child: Center(child: AutoSizeText("إلى تاريخ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 1, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
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
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Center(child: AutoSizeText(deviceHistoryList[index].type??"-", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),minFontSize: 10, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Center(child: AutoSizeText(deviceHistoryList[index].name??"-", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Center(child: AutoSizeText(deviceHistoryList[index].space??"-", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                const SizedBox(height: 1,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: white,
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Center(child: AutoSizeText(deviceHistoryList[index].from??"-", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12),minFontSize: 10, maxLines: 2, overflow: TextOverflow.ellipsis,)),
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
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Center(child: AutoSizeText(deviceHistoryList[index].to??"-", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Questv", fontSize: 12,),maxLines: 2, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
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
