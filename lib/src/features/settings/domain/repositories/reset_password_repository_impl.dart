import 'package:parliament_app/src/features/settings/data/data_sources/remote/reset_password_remote_datasource.dart';

abstract class ResetPasswordRepository {
  Future resetPassword({required String password});
}

// lib/src/features/settings/data/repositories/user_repository_impl.dart

class ResetPasswordRepositoryImpl implements ResetPasswordRepository {
  final ResetPasswordRemoteDatasource remoteDataSource;

  ResetPasswordRepositoryImpl(this.remoteDataSource);

  @override
  Future resetPassword({
    required String password,
  }) async {
    print(
        '[UserRepositoryImpl] updateUser called, forwarding to datasource...');
    // This part was already correct.
    return await remoteDataSource.resetPassword(newPassowrd: password);
  }
}
