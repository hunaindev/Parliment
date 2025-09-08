import 'package:parliament_app/src/features/settings/domain/repositories/reset_password_repository_impl.dart';

class ResetPasswordUsecase {
  final ResetPasswordRepository repository;

  ResetPasswordUsecase(this.repository);

  Future call(String password) async {
    return await repository.resetPassword(password: password);
  }
}
