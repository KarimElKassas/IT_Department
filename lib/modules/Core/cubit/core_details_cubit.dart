import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Core/cubit/core_states.dart';

import '../../../models/clerk_model.dart';
import '../../../network/remote/dio_helper.dart';
import 'core_details_states.dart';

class CoreDetailsCubit extends Cubit<CoreDetailsStates>{
  CoreDetailsCubit() : super(CoreDetailsInitialState());

  static CoreDetailsCubit get(context) => BlocProvider.of(context);


}