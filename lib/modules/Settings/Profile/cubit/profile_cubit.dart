import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_department/modules/Settings/Profile/cubit/profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates>{
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);




}