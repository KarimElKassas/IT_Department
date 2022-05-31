import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Core/cubit/core_cubit.dart';
import 'package:it_department/modules/Core/cubit/core_states.dart';
import 'package:it_department/shared/components.dart';
import 'package:it_department/shared/constants.dart';

class CoreScreen extends StatelessWidget {
  const CoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoreCubit()..getFilteredClerks(),
      child: BlocConsumer<CoreCubit, CoreStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CoreCubit.get(context);

          return SafeArea(
            child: Scaffold(
              backgroundColor: darkGreen,
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInDown(
                          duration: const Duration(milliseconds: 800),
                          child: Center(
                              child: AutoSizeText(
                            "قوة إدارة الرقمنة",
                            style: TextStyle(
                                color: orangeColor,
                                fontSize: 20,
                                fontFamily: "Questv"),
                            maxLines: 1,
                            minFontSize: 12,
                          )),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        cubit.gotClerks
                            ? FadeInUp(
                                duration: const Duration(milliseconds: 1800),
                                child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cubit.clerksModelList.length,
                                    itemBuilder: (context, index) =>
                                        clerkListItem(context, cubit, index)),
                              )
                            : getEmptyWidget(),
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

  Widget clerkListItem( BuildContext context,CoreCubit cubit, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.3,
              width: MediaQuery.of(context).size.width * 0.3,
              child: CircularProfileAvatar(
                cubit.clerksModelList[index].clerkImage ?? cubit.publicImage,
                radius: 100,
                backgroundColor: darkGreen,
                borderWidth: 1,
                borderColor: orangeColor,
                elevation: 10.0,
                cacheImage: true,
                imageFit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(cubit.clerksModelList[index].clerkName ?? "",
                    style: TextStyle(
                        color: orangeColor,
                        fontFamily: "Questv",
                        fontSize: 12),
                    minFontSize: 10,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start),
                const SizedBox(
                  height: 4,
                ),
                AutoSizeText(cubit.clerksModelList[index].rankName ?? "",
                    style: TextStyle(
                        color: orangeColor,
                        fontFamily: "Questv",
                        fontSize: 12),
                    minFontSize: 10,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start),
                const SizedBox(
                  height: 4,
                ),
                AutoSizeText(cubit.clerksModelList[index].jobName ?? "",
                    style: TextStyle(
                        color: orangeColor,
                        fontFamily: "Questv",
                        fontSize: 12),
                    minFontSize: 10,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start),
              ],
            ),
          )
        ],
      ),
    );
  }

}
