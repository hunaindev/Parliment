import 'package:parliament_app/src/features/settings/domain/repositories/delete_account_repository_impl.dart';

class DeleteAccountUsecase {
  final DeleteAccountRepository repository;

  DeleteAccountUsecase(this.repository);

  Future call(String password) async {
    return await repository.deleteAccount(password: password);
  }
}
