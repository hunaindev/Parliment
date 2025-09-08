import 'package:parliament_app/src/features/settings/data/data_sources/remote/delete_account_remote_datasource.dart';

abstract class DeleteAccountRepository {
  Future deleteAccount({required String password});
}

// lib/src/features/settings/data/repositories/user_repository_impl.dart

class DeleteAccountRepositoryImpl implements DeleteAccountRepository {
  final DeleteAccountRemoteDatasource remoteDataSource;

  DeleteAccountRepositoryImpl(this.remoteDataSource);

  @override
  Future deleteAccount({
    required String password,
  }) async {
    print(
        '[DeleteAccountRepositoryImpl] updateUser called, forwarding to datasource...');
    // This part was already correct.
    return await remoteDataSource.deleteAccount(password: password);
  }
}
