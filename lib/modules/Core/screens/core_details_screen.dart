import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Core/cubit/core_details_cubit.dart';
import 'package:it_department/modules/Core/cubit/core_details_states.dart';

import '../../../shared/constants.dart';

class CoreDetailsScreen extends StatelessWidget {
  const CoreDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoreDetailsCubit(),
      child: BlocConsumer<CoreDetailsCubit, CoreDetailsStates>(
        listener: (context, state){},
        builder: (context, state){
          var cubit = CoreDetailsCubit.get(context);

          return SafeArea(
            child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32)),
                      color: lightGreen,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 32,),
                        Container(
                          decoration: BoxDecoration(
                            //borderRadius: BorderRadius.circular(48),
                              border: Border.all(color: const Color(0xffF6F0ED), width: 4),
                              shape: BoxShape.circle,
                              color: lightGreen
                          ),
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.height * 0.2,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              decoration: BoxDecoration(
                                //borderRadius: BorderRadius.circular(48),
                                  shape: BoxShape.circle,
                                  color: darkGreen
                              ),
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.height * 0.2,
                              child: CachedNetworkImage(
                                imageUrl: "https://firebasestorage.googleapis.com/v0/b/it-department-2022.appspot.com/o/Clerks%2F30202170105156?alt=media",
                                imageBuilder: (context,
                                    imageProvider) =>
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(96),
                                      child: FadeInImage(
                                        height: MediaQuery.of(context).size.height * 0.2,
                                        width: MediaQuery.of(context).size.height * 0.2,
                                        //height: double.infinity,
                                        //width: double.infinity,
                                        fit: BoxFit.fill,
                                        image: imageProvider,
                                        placeholder: const AssetImage(
                                            "assets/images/placeholder.jpg"),
                                        imageErrorBuilder:
                                            (context, error,
                                            stackTrace) {
                                          return Image.asset(
                                            'assets/images/error.png',
                                            fit: BoxFit.fill,
                                            height: MediaQuery.of(context).size.height * 0.2,
                                            width: MediaQuery.of(context).size.height * 0.2,
                                          );
                                        },
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                    FadeInImage(
                                      height: MediaQuery.of(context).size.height * 0.2,
                                      width: MediaQuery.of(context).size.height * 0.2,
                                      fit: BoxFit.fill,
                                      image: const AssetImage(
                                          "assets/images/placeholder.jpg"),
                                      placeholder: const AssetImage(
                                          "assets/images/placeholder.jpg"),
                                    ),
                                errorWidget:
                                    (context, url, error) =>
                                    FadeInImage(
                                      height: MediaQuery.of(context).size.height * 0.2,
                                      width: MediaQuery.of(context).size.height * 0.2,
                                      fit: BoxFit.fill,
                                      image: const AssetImage(
                                          "assets/images/error.png"),
                                      placeholder: const AssetImage(
                                          "assets/images/placeholder.jpg"),
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32,),
                      ],
                    ),
                  ),
                ),
            ),
          );
        },
      ));
  }
}
/**/