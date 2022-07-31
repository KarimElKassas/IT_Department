import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Settings/Profile/cubit/profile_cubit.dart';
import 'package:it_department/modules/Settings/Profile/cubit/profile_states.dart';

import '../../../../shared/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key, required this.userID, required this.userName, required this.userImage, required this.userPhone, required this.userDepartment, required this.userCategory, required this.userRank, required this.userPassword, required this.userJob}) : super(key: key);

  final String userID, userName, userImage, userPhone, userDepartment, userCategory, userRank, userPassword, userJob;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ProfileCubit.get(context);

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
                backgroundColor: white,
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
                                  "الملف الشخصى",
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
            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: veryLightGreen.withOpacity(0.06),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(55)
                        )
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 22, top: 8, right: 16, left: 16),
                      child: FadeIn(
                        duration: const Duration(milliseconds: 600),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: InkWell(
                            onTap: (){

                            },
                            child: Row(
                              children: [
                                userImage == "" ? Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 96,
                                      width: 96,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(width: 2, color: lightGreen)
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                      color: Colors.white,
                                      child: Icon(Icons.add_photo_alternate_outlined,  color: lightGreen, size: 36,),
                                    ),
                                  ],
                                ) : Container(
                                  decoration: BoxDecoration(
                                    //borderRadius: BorderRadius.circular(48),
                                      border: Border.all(color: lightGreen, width: 1),
                                      shape: BoxShape.circle,
                                      color: Colors.transparent),
                                  height: 96,
                                  width: 96,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        //borderRadius: BorderRadius.circular(48),
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      height: 96,
                                      width: 96,
                                      child: CachedNetworkImage(
                                        imageUrl: userImage,
                                        imageBuilder: (context, imageProvider) => ClipOval(
                                          child: FadeInImage(
                                            height: 96,
                                            width: 96,
                                            fit: BoxFit.fill,
                                            image: imageProvider,
                                            placeholder: const AssetImage(
                                                "assets/images/placeholder.jpg"),
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/images/error.png',
                                                fit: BoxFit.fill,
                                                height: 96,
                                                width: 96,
                                              );
                                            },
                                          ),
                                        ),
                                        placeholder: (context, url) => CircularProgressIndicator(color: orangeColor, strokeWidth: 0.8,),
                                        errorWidget: (context, url, error) =>
                                        const FadeInImage(
                                          height: 96,
                                          width: 96,
                                          fit: BoxFit.fill,
                                          image: AssetImage("assets/images/error.png"),
                                          placeholder:
                                          AssetImage("assets/images/placeholder.jpg"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      userName,
                                      style: TextStyle(
                                          color: lightGreen,
                                          fontFamily: "Questv",
                                          fontWeight: FontWeight.w600),
                                      minFontSize: 12,
                                      maxLines: 1,
                                      maxFontSize: 16,
                                    ),
                                    const SizedBox(height: 2,),
                                    AutoSizeText(
                                      userPhone,
                                      style: TextStyle(
                                          color: lightGreen,
                                          fontFamily: "Questv",
                                          letterSpacing: 2),
                                      minFontSize: 12,
                                      maxLines: 1,
                                      maxFontSize: 16,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 15),
                      decoration: BoxDecoration(
                        color: veryLightGreen.withOpacity(0.08),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          label('الحساب الشخصى', () {}, ""),
                          label('مظهر التطبيق', () { }, 'فاتح'),
                          label('اللغة', () { }, 'العربية'),
                          label('بصمة الاصبع', () { }, 'مُفعلة'),
                          label('مساعدة', () { }, ''),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: veryLightGreen.withOpacity(0.05)
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Container(),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft:Radius.circular(40),
                                bottomLeft:Radius.circular(40),
                              )
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FadeIn(
                              delay: const Duration(milliseconds: 400),
                              duration: const Duration(milliseconds: 600),
                              child: TextButton(
                                onPressed: (){},
                                style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => veryLightGreen.withOpacity(0.08))),
                                child: Text("تسجيل الخروج", style: TextStyle(color: lightGreen, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: "Questv"),),),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 10),
                  height: 70,
                  decoration: const BoxDecoration(
                      color: Colors.white
                  ) ,
                  child: Container(
                    decoration: BoxDecoration(
                        color: veryLightGreen.withOpacity(0.08),
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(25))
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
  Widget label(String name,VoidCallback onclick, String? state){
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 12, bottom: 8, top: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: InkWell(
          onTap: (){
            onclick();
          },
          child: Row(
            children: [
              Text(name, style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: "Questv"),),
              const Spacer(),
              Row(
                children: [
                  Text(state??"", style: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: "Questv"),),
                  const SizedBox(width: 4,),
                  Icon(Icons.arrow_forward_ios_rounded, color: lightGreen, size: 18,)
                ],
              )
            ],
          ),
        ),
      ),
    ) ;
  }
}
