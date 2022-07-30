import 'package:auto_size_text/auto_size_text.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:it_department/modules/Chat/display/cubit/new_chat_cubit.dart';
import 'package:sizer/sizer.dart';
import '../../../../shared/components.dart';
import '../../../../shared/constants.dart';
import '../cubit/new_chat_states.dart';

class NewChatScreen extends StatelessWidget {
  const NewChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewChatCubit()..isEqual()..getUsers(),
      child: BlocConsumer<NewChatCubit, NewChatStates>(
          listener: (context, state){},
          builder: (context, state){

            var cubit = NewChatCubit.get(context);

            return Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  appBar: AppBar(
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.dark,
                      // For Android (dark icons)
                      statusBarBrightness: Brightness.light, // For iOS (dark icons)
                    ),
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    backgroundColor: veryLightGreen.withOpacity(0.1),
                    title: !cubit.isSearching ? Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AutoSizeText(
                            "محادثة جديدة",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Questv",
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                            minFontSize: 14,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: (){
                              cubit.startSearch(context);
                            },
                            child: const Icon(
                              IconlyBroken.search,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ) : _buildSearchField(context, cubit),
                  ),
                  body: SafeArea(
                    child: Container(
                      color: veryLightGreen.withOpacity(0.1),
                      height: 100.h,
                      child: cubit.filteredClerkList.isNotEmpty ? SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            children: [
                              BuildCondition(
                                condition: state is NewChatLoadingUsersState,
                                builder: (context) => Center(
                                  child: CircularProgressIndicator(
                                    color: orangeColor,
                                    strokeWidth: 0.8,
                                  ),
                                ),
                                fallback: (context) => ListView.separated(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) =>
                                      listItem(context, cubit, state, index),
                                  separatorBuilder: (context, index) =>
                                  const Divider(thickness: 0.8),
                                  itemCount: cubit.filteredClerkList.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ) : const Center(child: AutoSizeText("لا يوجد اعضاء ...", style: TextStyle(fontFamily: "Questv", fontWeight: FontWeight.w600, color: Colors.black,),minFontSize: 16, maxLines: 1,),),
                    ),
                  ),
                )
            );

          },
      ),
    );
  }
  Widget listItem(BuildContext context, NewChatCubit cubit, state, int index) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: InkWell(
          onTap: (){
              cubit.isChatExist(context, cubit.filteredClerkList[index].clerkID!, cubit.filteredClerkList[index].clerkName, cubit.filteredClerkList[index].clerkImage!, cubit.filteredClerkList[index].personToken!);
          },
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(48),
                    border: Border.all(color: Colors.black, width: 0),
                    shape: BoxShape.circle,
                    color: Colors.transparent
                ),
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.height * 0.07,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      //borderRadius: BorderRadius.circular(48),
                        shape: BoxShape.circle,
                        color: Colors.white
                    ),
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.height * 0.07,
                    child: CachedNetworkImage(
                      imageUrl: cubit.filteredClerkList[index].clerkImage!,
                      imageBuilder: (context, imageProvider) => ClipOval(
                        child: FadeInImage(
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                          image: imageProvider,
                          placeholder: const AssetImage(
                              "assets/images/placeholder.jpg"),
                          imageErrorBuilder:
                              (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/error.png',
                              fit: BoxFit.fill,
                              height: 50,
                              width: 50,
                            );
                          },
                        ),
                      ),
                      placeholder: (context, url) => CircularProgressIndicator(color: orangeColor, strokeWidth: 0.8,),
                      errorWidget: (context, url, error) =>
                      const FadeInImage(
                        height: 50,
                        width: 50,
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/error.png"),
                        placeholder:
                        AssetImage("assets/images/placeholder.jpg"),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8,),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      cubit.filteredClerkList[index].clerkName,
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Questv",
                          fontSize: 10,
                          fontWeight: FontWeight.w600),
                      minFontSize: 10,
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    AutoSizeText(
                      cubit.filteredClerkList[index].clerkCategoryName!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: "Questv",
                        fontSize: 10,
                        fontWeight: FontWeight.w200,
                        overflow: TextOverflow.ellipsis,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                      minFontSize: 10,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context ,NewChatCubit cubit) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 9,
            child: TextField(
              controller: cubit.searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "ابحث عن شخص ...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: "Questv",),
              onChanged: (query) => cubit.updateSearchQuery(query),
            ),
          ),
          Expanded(flex: 1, child: _buildActions(context, cubit))
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, NewChatCubit cubit) {
    if (cubit.isSearching) {
      return GestureDetector(
        onTap: (){
          if (cubit.searchController.text.isEmpty) {
            Navigator.pop(context);
            return;
          }
          cubit.clearSearchQuery();
        },
        child: const Icon(Icons.clear, color: Colors.black),
      );
    }
    return getEmptyWidget();
  }
}
