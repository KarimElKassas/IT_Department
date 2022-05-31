import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it_department/modules/registration/widgets/clerk_data_view.dart';
import 'package:it_department/shared/constants.dart';

import '../../../shared/components.dart';
import '../../Login/clerk_login_screen.dart';
import '../cubit/clerk_register_cubit.dart';
import '../cubit/clerk_register_states.dart';
import 'clerk_confirm_registration_screen.dart';

class ClerkRegistrationScreen extends StatefulWidget {
  const ClerkRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<ClerkRegistrationScreen> createState() =>
      _ClerkRegistrationScreenState();
}

class _ClerkRegistrationScreenState extends State<ClerkRegistrationScreen> {
  var idController = TextEditingController();
  String searchText = "";

  TextEditingController searchQueryController = TextEditingController();
  bool isSearching = false;
  String searchQuery = "Search query";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClerkRegisterCubit(),
      child: BlocConsumer<ClerkRegisterCubit, ClerkRegisterStates>(
        listener: (context, state) {
          if (state is ClerkRegisterGetClerksErrorState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
          if (state is ClerkRegisterNoClerkFoundState) {
            showToast(
                message:
                    "لا يوجد موظف مسجل بهذا الرقم\n برجاء التوجه الى شئون العاملين اولاً",
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
          if (state is ClerkRegisterSuccessState) {
            navigateAndFinish(context, ClerkLoginScreen());
          }
        },
        builder: (context, state) {
          var cubit = ClerkRegisterCubit.get(context);

          return WillPopScope(
            onWillPop: (){
              if(cubit.clerkList.isNotEmpty){
                cubit.clearList();
              }else{
                if(Navigator.canPop(context)){
                  Navigator.pop(context);
                }else{
                  SystemNavigator.pop();
                }
              }
              return Future.value();
            },
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: cubit.clerkList.isEmpty ? const Color(0xff005c22) : Colors.white,
                  body: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: cubit.clerkList.isEmpty ? Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 48, right: 12, left: 12),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(36),
                                      color: Colors.black.withOpacity(0.25)
                                    ),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height *0.05,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                              child: InkWell(
                                                onTap: (){
                                                  cubit.getClerks(idController.text.toString());
                                                },
                                                child: Container(
                                                  height: MediaQuery.of(context).size.height *0.05,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(36),
                                                    color: Colors.white,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                                                    child: Row(
                                                      children: const [
                                                        Icon(IconlyBroken.arrowRight2, color: Color(0xff005c22),),
                                                        SizedBox(width: 4,),
                                                        Text("إبـحـث",style: TextStyle(color: Color(0xff005c22), fontSize: 20, fontFamily: "Hamed", letterSpacing: 1.5),),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          Expanded(
                                            flex: 2,
                                            child: SizedBox(
                                              height: MediaQuery.of(context).size.height *0.05,
                                              child: TextFormField(
                                                textDirection: TextDirection.rtl,
                                                controller: idController,
                                                keyboardType: TextInputType.number,
                                                textInputAction: TextInputAction.search,
                                                maxLines: 1,
                                                maxLength: 14,
                                                autovalidateMode: AutovalidateMode.disabled,
                                                autofocus: false,
                                                validator: (String? value) {
                                                  if (value!.isEmpty) {
                                                    return 'يجب ادخال الرقم القومى / العسكرى !';
                                                  }
                                                  return null;
                                                },
                                                onFieldSubmitted: (value){
                                                  cubit.getClerks(value);
                                                },
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                  contentPadding:
                                                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                                  filled: false,
                                                  focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(32)),
                                                      borderSide: BorderSide(
                                                        width: 0,
                                                        style: BorderStyle.none,
                                                      ),
                                                  ),
                                                  disabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(32)),
                                                      borderSide: BorderSide(
                                                        width: 0,
                                                        style: BorderStyle.none,
                                                      ),
                                                  ),
                                                  errorBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(32)),
                                                    borderSide: BorderSide(
                                                      width: 0,
                                                      style: BorderStyle.none,
                                                    )
                                                  ),
                                                  floatingLabelStyle:
                                                  TextStyle(color: Colors.teal[700]),
                                                  hintText: 'بحث بالرقم القومى / العسكرى',
                                                  hintStyle: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontFamily: "Questv",
                                                      fontWeight: FontWeight.w500),

                                                    fillColor: Colors.black.withOpacity(0.25),
                                                    //alignLabelWithHint: true,
                                                    errorStyle: const TextStyle(
                                                        fontSize: 16,
                                                        color: Color(0xffBF9A35),
                                                        fontFamily: "Questv",
                                                        fontWeight: FontWeight.w500),
                                                    floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                    hintTextDirection: TextDirection.rtl,
                                                    border: const OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(32),
                                                        ),
                                                      borderSide: BorderSide(
                                                      width: 0,
                                                      style: BorderStyle.none,
                                                    ),
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontFamily: "Questv",
                                                      fontWeight: FontWeight.w500,
                                                      overflow: TextOverflow.ellipsis),
                                                  textAlignVertical: TextAlignVertical.center,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8),
                                              child: Container(
                                                height: MediaQuery.of(context).size.height *0.05,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(36),
                                                ),
                                                child: Icon(IconlyBroken.search, color: Colors.white,),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: state is ClerkRegisterLoadingClerksState ? Center(child: CircularProgressIndicator(color: orangeColor, strokeWidth: 2,)) : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/illustration.svg',
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width,
                                      ),
                                      const Text("ابحث عن الحساب الخاص بك \n بالرقم القومى / العسكرى", style: TextStyle(color: Colors.white, fontFamily: "Questv", fontWeight: FontWeight.bold, fontSize: 20, wordSpacing: 2.0), textAlign: TextAlign.center,),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: SvgPicture.asset(
                                    'assets/images/white_logo.svg',
                                    alignment: Alignment.center,
                                    //width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              )
                            ],
                          ) : ClerkDataWidget(clerkName: cubit.clerkModel!.clerkName!, clerkPhone: cubit.clerkModel!.personPhone!, clerkManagement: cubit.clerkModel!.managementName!, clerkRank: cubit.clerkModel!.rankName!, clerkCategory: cubit.clerkModel!.personTypeName!, clerkJob: cubit.clerkModel!.jobName!, isCivil: cubit.isCivil, clerkModel: cubit.clerkModel!,),
                        )
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
