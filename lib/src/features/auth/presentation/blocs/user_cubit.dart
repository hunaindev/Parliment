// user_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';

class UserCubit extends Cubit<UserEntity?> {
  UserCubit() : super(null);

  void setUser(UserEntity user) => emit(user);
  void clearUser() => emit(null);
}
