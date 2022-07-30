import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:it_department/modules/Login/clerk_login_screen.dart';
import 'package:it_department/modules/onBoarding/cubit/on_boarding_cubit.dart';
import 'package:it_department/modules/onBoarding/cubit/on_boarding_states.dart';
import 'package:it_department/shared/components.dart';
import 'package:it_department/shared/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({Key? key}) : super(key: key);
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => OnBoardingCubit()..initList(firstPage(), secondPage(), thirdPage(context, OnBoardingCubit())),
        child: BlocConsumer<OnBoardingCubit, OnBoardingStates>(
            listener: (context, state){},
            builder: (context, state){

              var cubit = OnBoardingCubit.get(context);

              return Scaffold(
                appBar: AppBar(
                  systemOverlayStyle:  SystemUiOverlayStyle(
                    statusBarColor: veryLightGreen.withOpacity(0.05),
                    statusBarIconBrightness: Brightness.dark,
                    // For Android (dark icons)
                    statusBarBrightness: Brightness.light, // For iOS (dark icons)
                  ),
                  toolbarHeight: 0,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                body: Container(
                  color: veryLightGreen.withOpacity(0.05),
                  child: Column(
                    children: <Widget>
                    [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: NotificationListener<OverscrollIndicatorNotification>(
                            onNotification: (overScroll) {
                              overScroll.disallowIndicator();
                              return true;
                            },
                            child: PageView.builder(
                              physics: const ClampingScrollPhysics(),
                              onPageChanged: (i)
                              {
                                if (i == (cubit.onBoardingList!.length - 1) && !cubit.isLast){
                                    cubit.changeIndex(true);
                                }
                                else if (cubit.isLast) {
                                  cubit.changeIndex(false);
                                }
                              },
                              controller: controller,
                              itemCount: cubit.onBoardingList!.length, itemBuilder: (BuildContext context, int index) { return cubit.onBoardingList![index]; },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SmoothPageIndicator(
                              controller: controller,
                              effect: ScrollingDotsEffect(
                                dotColor: Colors.white,
                                activeDotColor: lightGreen,
                                dotHeight: 12,
                                dotWidth: 12,
                                spacing: 12.0,
                              ),
                              count: cubit.onBoardingList!.length,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
        ),
    );
  }

  Widget firstPage(){
    return Padding(
      padding: const EdgeInsets.only(top: 48, left: 4, right: 4, bottom: 12),
      child: Column(
        children: [
            SvgPicture.asset("assets/images/logoIconOnly.svg", height: 160, width: 160,),
            const SizedBox(height: 24,),
            const AutoSizeText(
            "مشروع مستقبل مصر",
            style: TextStyle(fontFamily: "Questv", fontWeight: FontWeight.w600, wordSpacing: 1, height: 1.8), minFontSize: 24, maxFontSize: 24, maxLines: 15, textDirection: TextDirection.rtl,),
            const SizedBox(height: 12,),
            const Expanded(
              child: AutoSizeText(
                "تحت شعار الإيمان بالله وحب الوطن ، \nمشروع مستقبل مصر هو باكورة مشروع الدلتا الجديدة بمساحة مليون وخمسين ألف فدان من الزراعات الإستراتيجية على إمتداد محور الضبعة الجديد ، بهدف تحقيق إكتفاء ذاتى وسد الفجوة بين الإنتاج والإستيراد",
                style: TextStyle(fontFamily: "Questv", fontWeight: FontWeight.normal, wordSpacing: 1, height: 1.8), minFontSize: 10, maxFontSize: 18, maxLines: 15, textDirection: TextDirection.rtl,),
            )
        ],
      ),
    );
  }
  Widget secondPage(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Column(
        children: [
          const AutoSizeText(
          "مشروع مستقبل مصر",
          style: TextStyle(fontFamily: "Questv", fontWeight: FontWeight.w600, wordSpacing: 1, height: 1.8), minFontSize: 24, maxFontSize: 24, maxLines: 15, textDirection: TextDirection.rtl,),
          const SizedBox(height: 8,),
          const AutoSizeText(
            "بهدف تبسيط التواصل والمحادثات بين أفراد المشروع وبعضهم البعض بطريقة آمنة ومباشرة",
            style: TextStyle(fontFamily: "Questv", fontWeight: FontWeight.normal, wordSpacing: 1, height: 1.8), minFontSize: 10, maxFontSize: 14, maxLines: 15, textDirection: TextDirection.rtl, textAlign: TextAlign.center,),
          Expanded(child: SvgPicture.asset("assets/images/onBoardingTalk.svg")),
        ],
      ),
    );
  }
  Widget thirdPage(BuildContext context, OnBoardingCubit cubit){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Column(
        children: [
          const AutoSizeText(
            "جارى التحميل .....",
            style: TextStyle(fontFamily: "Questv", fontWeight: FontWeight.w600), minFontSize: 12, maxFontSize: 14, maxLines: 1, textDirection: TextDirection.rtl,),
          const SizedBox(height: 4,),
          const AutoSizeText(
            "برجاء الانتظار دقيقة واحدة",
            style: TextStyle(fontFamily: "Questv", fontWeight: FontWeight.normal, wordSpacing: 2), minFontSize: 12, maxFontSize: 14, maxLines: 1, textDirection: TextDirection.rtl, textAlign: TextAlign.center,),
          Expanded(child: SvgPicture.asset("assets/images/logoIconOnly.svg")),
          const SizedBox(height: 24,),
          InkWell(
            onTap: (){
              cubit.setPreference();
              finish(context, ClerkLoginScreen());
            },
            child: Container(
              width: 45.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: lightGreen,
              ),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: const Center(
                child: AutoSizeText(
                  "دخــول",
                  style: TextStyle(fontFamily: "Questv", wordSpacing: 1, color: Colors.white), minFontSize: 16, maxFontSize: 18, maxLines: 1, textDirection: TextDirection.rtl,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
