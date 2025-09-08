import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/features/settings/domain/usercases/delete_account_usecase.dart';
// import 'package:parliament_app/src/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/link_code_state.dart';
// import 'package:parliament_app/src/features/settings/presentations/blocs/link_code_state.dart';

class DeleteAccountCubit extends Cubit<LinkState> {
  final DeleteAccountUsecase deleteAccountUsecase;

  DeleteAccountCubit({
    required this.deleteAccountUsecase,
  }) : super(LinkInitial());

  Future<void> deleteAccount(String password) async {
    emit(LinkLoading());
    try {
      await deleteAccountUsecase(password);
      emit(LinkSuccess(source: "Account deleted successfully"));
    } catch (e) {
      emit(LinkError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
