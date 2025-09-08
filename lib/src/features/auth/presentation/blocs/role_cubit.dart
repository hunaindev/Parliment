import 'package:flutter_bloc/flutter_bloc.dart';

class RoleCubit extends Cubit<String?> {
  RoleCubit() : super(null);

  chooseRole(role) {
    print("role in state $role");
    emit(role);
  }
}
