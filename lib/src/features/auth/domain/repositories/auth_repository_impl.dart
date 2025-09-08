import 'package:parliament_app/src/features/auth/data/data_sources/user_remote_datasource.dart';
import 'package:parliament_app/src/features/auth/data/models/user_model.dart';
import 'package:parliament_app/src/features/auth/domain/repositories/auth_repository.dart';

import '../../domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login(UserEntity user) {
    return remoteDataSource.login(UserModel(
      email: user.email,
      password: user.password,
      deviceToken: user.deviceToken,
    ));
  }

  @override
  Future<UserEntity> signup(UserEntity user) {
    return remoteDataSource.signup(UserModel(
      email: user.email,
      password: user.password,
      name: user.name,
      parentEmail: user.parentEmail,
      role: user.role,
      deviceToken: user.deviceToken,
      lat: user.lat,
      lng: user.lng,
      // parentEmail: user.parentEmail,
    ));
  }

  @override
  Future<UserEntity> chooseRole(String role) {
    return remoteDataSource.chooseRole(role);
  }

  @override
  Future<void> logout(String userId) async {
    await remoteDataSource.logout(userId);
  }

  @override
  Future linkChild(String email) {
    return remoteDataSource.linkChild(email);
  }
}
