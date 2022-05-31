import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:it_department/models/clerk_model.dart';
import 'package:it_department/modules/registration/screens/clerk_confirm_registration_screen.dart';
import 'package:it_department/shared/components.dart';
import 'package:it_department/shared/constants.dart';
import 'package:transition_plus/transition_plus.dart';

class ClerkDataWidget extends StatelessWidget {
  ClerkDataWidget({Key? key, required this.clerkName, required this.clerkPhone, required this.clerkManagement, required this.clerkRank, required this.clerkCategory, required this.clerkJob, required this.isCivil, required this.clerkModel}) : super(key: key);
  final String clerkName, clerkPhone, clerkManagement, clerkRank, clerkCategory, clerkJob;
  bool isCivil;
  final ClerkModel clerkModel;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: darkGreen,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12, left: 12),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SvgPicture.asset(
                          'assets/images/logo_side.svg',
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.25,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        decoration: BoxDecoration(
                          border: Border.all(color: orangeColor, width: 1),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(48), bottomLeft: Radius.circular(48)),
                          color: white,
                        ),
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: item(context),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 36),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, ScaleTransition1(page: ClerkConfirmRegistrationScreen(clerkModel: clerkModel), startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
                          },
                          child: Container(
                            //width: MediaQuery.of(context).size.width * 0.50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: white,
                            ),
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: darkGreen,
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: (
                                            Icon(IconlyBold.arrowRight3, color: white,size: MediaQuery.of(context).size.width * 0.08,)
                                        ),
                                      ),
                                      height: MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width * 0.1,
                                    ),
                                  ),
                                const SizedBox(width: 24,),
                                Text("انشاء حساب", style: TextStyle(color: darkGreen, fontFamily: "Hamed", fontSize: 18),),
                                const SizedBox(width: 32,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget item(BuildContext context){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.18),
          child: Text("اسم الموظف", style: TextStyle(color: orangeColor, fontSize: 18, fontFamily: "Hamed"),),
        ),
        const SizedBox(height: 12,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                IconlyBold.profile,
                color: teal700,
              ),
            ),
            Expanded(
              child: TextFormField(
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.number,
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  filled: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  floatingLabelStyle:
                  TextStyle(color: Colors.teal[700]),
                  hintText: clerkName,
                  hintStyle: TextStyle(
                      fontSize: 18,
                      color: teal700,
                      fontFamily: "Hamed",
                      fontWeight: FontWeight.w500),
                  fillColor: Colors.white,
                  //alignLabelWithHint: true,
                  errorStyle: TextStyle(
                      fontSize: 16,
                      color: orangeColor,
                      fontFamily: "Hamed",
                      fontWeight: FontWeight.w500),
                  floatingLabelBehavior:
                  FloatingLabelBehavior.never,
                  hintTextDirection: TextDirection.rtl,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(16))),
                ),
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.teal,
                    fontFamily: "Hamed",
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12,),
        Padding(
          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.18),
          child: Text("رقم الهاتف", style: TextStyle(color: orangeColor, fontSize: 18, fontFamily: "Hamed"),),
        ),
        const SizedBox(height: 12,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                IconlyBold.calling,
                color: teal700,
              ),
            ),
            Expanded(
              child: TextFormField(
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.number,
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  filled: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  floatingLabelStyle:
                  TextStyle(color: Colors.teal[700]),
                  hintText: clerkPhone,
                  hintStyle: TextStyle(
                      fontSize: 18,
                      color: teal700,
                      fontFamily: "Hamed",
                      fontWeight: FontWeight.w500),
                  fillColor: Colors.white,
                  //alignLabelWithHint: true,
                  errorStyle: TextStyle(
                      fontSize: 16,
                      color: orangeColor,
                      fontFamily: "Hamed",
                      fontWeight: FontWeight.w500),
                  floatingLabelBehavior:
                  FloatingLabelBehavior.never,
                  hintTextDirection: TextDirection.rtl,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(16))),
                ),
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.teal,
                    fontFamily: "Hamed",
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12,),
        Padding(
          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.18),
          child: Text("الإدارة التابع لها", style: TextStyle(color: orangeColor, fontSize: 18, fontFamily: "Hamed"),),
        ),
        const SizedBox(height: 12,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                IconlyBold.home,
                color: teal700,
              ),
            ),
            Expanded(
              child: TextFormField(
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.number,
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  filled: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  floatingLabelStyle:
                  TextStyle(color: Colors.teal[700]),
                  hintText: clerkManagement,
                  hintStyle: TextStyle(
                      fontSize: 18,
                      color: teal700,
                      fontFamily: "Hamed",
                      fontWeight: FontWeight.w500),
                  fillColor: Colors.white,
                  //alignLabelWithHint: true,
                  errorStyle: TextStyle(
                      fontSize: 16,
                      color: orangeColor,
                      fontFamily: "Hamed",
                      fontWeight: FontWeight.w500),
                  floatingLabelBehavior:
                  FloatingLabelBehavior.never,
                  hintTextDirection: TextDirection.rtl,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(16))),
                ),
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.teal,
                    fontFamily: "Hamed",
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12,),
        Padding(
          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.18),
          child: Text("الدرجة", style: TextStyle(color: orangeColor, fontSize: 18, fontFamily: "Hamed"),),
        ),
        const SizedBox(height: 12,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                IconlyBold.work,
                color: teal700,
              ),
            ),
            Expanded(
              child: TextFormField(
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.number,
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  filled: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  floatingLabelStyle:
                  TextStyle(color: Colors.teal[700]),
                  hintText: clerkCategory,
                  hintStyle: TextStyle(
                      fontSize: 18,
                      color: teal700,
                      fontFamily: "Hamed",
                      fontWeight: FontWeight.w500),
                  fillColor: Colors.white,
                  //alignLabelWithHint: true,
                  errorStyle: TextStyle(
                      fontSize: 16,
                      color: orangeColor,
                      fontFamily: "Hamed",
                      fontWeight: FontWeight.w500),
                  floatingLabelBehavior:
                  FloatingLabelBehavior.never,
                  hintTextDirection: TextDirection.rtl,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(16))),
                ),
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.teal,
                    fontFamily: "Hamed",
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        SizedBox(height: !isCivil ? 12 : 0,),
        !isCivil ? Padding(
          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.18),
          child: Text("الرتبة", style: TextStyle(color: orangeColor, fontSize: 18, fontFamily: "Hamed"),),
        ) : getEmptyWidget(),
        SizedBox(height: !isCivil ? 12 : 0,),
        !isCivil ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.local_police,
                color: teal700,
              ),
            ),
            Expanded(
              child: TextFormField(
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.number,
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  filled: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  floatingLabelStyle:
                  TextStyle(color: Colors.teal[700]),
                  hintText: clerkRank,
                  hintStyle: TextStyle(
                      fontSize: 18,
                      color: teal700,
                      fontFamily: "Hamed",
                      fontWeight: FontWeight.w500),
                  fillColor: Colors.white,
                  //alignLabelWithHint: true,
                  errorStyle: TextStyle(
                      fontSize: 16,
                      color: orangeColor,
                      fontFamily: "Hamed",
                      fontWeight: FontWeight.w500),
                  floatingLabelBehavior:
                  FloatingLabelBehavior.never,
                  hintTextDirection: TextDirection.rtl,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(16))),
                ),
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.teal,
                    fontFamily: "Hamed",
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ) : getEmptyWidget(),
        const SizedBox(height: 12,),
        Padding(
          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.18),
          child: Text("الوظيفة", style: TextStyle(color: orangeColor, fontSize: 18, fontFamily: "Hamed"),),
        ),
        const SizedBox(height: 12,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.local_police,
                color: teal700,
              ),
            ),
            Expanded(
              child: TextFormField(
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.number,
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  filled: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  floatingLabelStyle:
                  TextStyle(color: Colors.teal[700]),
                  hintText: clerkJob,
                  hintStyle: TextStyle(
                      fontSize: 18,
                      color: teal700,
                      fontFamily: "Hamed",
                      fontWeight: FontWeight.w500),
                  fillColor: Colors.white,
                  //alignLabelWithHint: true,
                  errorStyle: TextStyle(
                      fontSize: 16,
                      color: orangeColor,
                      fontFamily: "Hamed",
                      fontWeight: FontWeight.w500),
                  floatingLabelBehavior:
                  FloatingLabelBehavior.never,
                  hintTextDirection: TextDirection.rtl,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(16))),
                ),
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.teal,
                    fontFamily: "Hamed",
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12,),
      ],
    );
  }
}
