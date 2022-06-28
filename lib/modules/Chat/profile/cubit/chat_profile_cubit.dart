import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Chat/profile/cubit/chat_profile_states.dart';

import '../../../../models/chat_model.dart';

class ChatProfileCubit extends Cubit<ChatProfileStates>{
  ChatProfileCubit() : super(ChatProfileInitialState());

  static ChatProfileCubit get(context) => BlocProvider.of(context);

  List<String> filteredImagesList = [];
  List<ChatModel> filteredFilesList = [];
  List<ChatModel> filteredRecordsList = [];
  int mediaCount = 0;

  void filterMedia(List<ChatModel> chatList){
   for (var element in chatList) {
      if(element.type == "Image"){
        for (var element in element.chatImagesModel!.messageImagesList) {
          filteredImagesList.add(element);
        }
      }
      if(element.type == "file"){
        filteredFilesList.add(element);
      }
      if(element.type == "audio"){
        filteredRecordsList.add(element);
      }
   }
   mediaCount = filteredImagesList.length + filteredFilesList.length + filteredRecordsList.length;
   emit(ChatProfileFilterMediaState());
  }
}