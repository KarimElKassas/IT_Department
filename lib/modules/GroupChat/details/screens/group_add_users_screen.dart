import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it_department/modules/GroupChat/details/cubit/group_add_users_cubit.dart';
import 'package:it_department/modules/GroupChat/details/cubit/group_add_users_states.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/components.dart';
import '../../../../shared/constants.dart';

class GroupAddUsersScreen extends StatelessWidget {
  const GroupAddUsersScreen({Key? key, required this.groupMembersList, required this.groupMembersAndAdminsList, required this.groupID}) : super(key: key);
  final List<String> groupMembersList;
  final List<String> groupMembersAndAdminsList;
  final String groupID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => GroupAddUsersCubit()..getUsers(groupMembersAndAdminsList),
        child: BlocConsumer<GroupAddUsersCubit, GroupAddUsersStates>(
            listener: (context, state){},
            builder: (context, state){

              var cubit = GroupAddUsersCubit.get(context);

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
                              "اضافة اعضاء",
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
                    floatingActionButton: FadeInUp(
                      duration: const Duration(seconds: 1),
                      child: FloatingActionButton(
                        onPressed: () async {
                          if (cubit.selectedClerksList.isNotEmpty) {
                            cubit.addUserToGroup(context, groupMembersList, groupMembersAndAdminsList, groupID);
                          } else {
                            showToast(
                                message: "يجب اختيار شخص واحد على الاقل",
                                length: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 3);
                          }
                        },
                        child: const Icon(
                          IconlyBroken.arrowLeft,
                          color: Colors.white,
                        ),
                        backgroundColor: lightGreen,
                        elevation: 15.0,
                      ),
                    ),
                    floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
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
                                cubit.selectedClerksList.isNotEmpty ? AnimatedOpacity(
                                  opacity: cubit.selectedClerksList.isNotEmpty ? 1 : 0,
                                  duration: const Duration(milliseconds: 500),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 1500),
                                    constraints: BoxConstraints(maxHeight: 15.h),
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) =>
                                          selectedListItem(context, cubit, state, index),
                                      separatorBuilder: (context, index) =>
                                      const SizedBox(width: 0.8),
                                      itemCount: cubit.selectedClerksList.length,
                                    ),
                                  ),
                                ) : getEmptyWidget(),
                                BuildCondition(
                                  condition: state is GroupAddUsersLoadingGetUsersState,
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
                        ) : const Center(child: AutoSizeText("لا يوجد اعضاء للإضافة ...", style: TextStyle(fontFamily: "Questv", fontWeight: FontWeight.w600, color: Colors.black,),minFontSize: 16, maxLines: 1,),),
                      ),
                    ),
                  )
              );
            },
        )
    );
  }
  Widget selectedListItem(BuildContext context, GroupAddUsersCubit cubit, state, int index) {
    return SlideInLeft(
      duration: const Duration(milliseconds: 300),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: (){
              cubit.removeUserFromSelect(cubit.selectedClerksList[index]);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
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
                            imageUrl: cubit.selectedClerksList[index].clerkImage!,
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
                    Positioned(
                      bottom: -8,
                      child: FadeIn(
                        duration: const Duration(milliseconds: 300),
                        child: const CircleAvatar(
                          child: Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 12,
                          ),
                          backgroundColor: Colors.grey,
                          maxRadius: 12,
                        ),
                      ),
                    ),
                  ],
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                ),
                const SizedBox(height: 10,),
                AutoSizeText(
                  cubit.selectedClerksList[index].clerkName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Questv",
                      fontSize: 8,
                      fontWeight: FontWeight.w600),
                  minFontSize: 8,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4,),
                const Divider(thickness: 0.8,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listItem(BuildContext context, GroupAddUsersCubit cubit, state, int index) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: InkWell(
          onTap: (){
            if (cubit.selectedClerksList
                .contains(cubit.filteredClerkList[index])) {
              cubit.removeUserFromSelect(cubit.filteredClerkList[index]);
            } else {
              cubit.addClerkToSelect(cubit.filteredClerkList[index]);
            }

          },
          child: Row(
            children: [
              Stack(
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
                  if (cubit.selectedClerksList
                      .contains(cubit.filteredClerkList[index]))
                    Positioned(
                      bottom: -5,
                      child: FadeIn(
                        duration: const Duration(milliseconds: 300),
                        child: CircleAvatar(
                          child: const Icon(
                            Icons.done_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                          backgroundColor: lightGreen,
                          maxRadius: 12,
                        ),
                      ),
                    ) else getEmptyWidget(),
                ],
                alignment: Alignment.bottomLeft,
                clipBehavior: Clip.none,
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

  Widget _buildSearchField(BuildContext context ,GroupAddUsersCubit cubit) {
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

  Widget _buildActions(BuildContext context, GroupAddUsersCubit cubit) {
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
