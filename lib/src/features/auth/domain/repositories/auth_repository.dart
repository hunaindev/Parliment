import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(UserEntity user);
  Future<UserEntity> signup(UserEntity user);
  Future<void> logout(String userId);
  Future linkChild(String email);
  Future<UserEntity> chooseRole(String role);
}
