import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:parliament_app/src/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:parliament_app/src/features/settings/domain/usercases/reset_password_usecase.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/link_code_state.dart';
// import 'package:parliament_app/src/features/settings/presentations/blocs/link_code_state.dart';

class ResetPasswordCubit extends Cubit<LinkState> {
  final ResetPasswordUsecase resetPasswordUsecase;

  ResetPasswordCubit({
    required this.resetPasswordUsecase,
  }) : super(LinkInitial());

  Future<void> resetPassword(String password) async {
    emit(LinkLoading());
    try {
      await resetPasswordUsecase(password);
      emit(LinkSuccess(source: "Password updated successfully"));
    } catch (e) {
      emit(LinkError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
