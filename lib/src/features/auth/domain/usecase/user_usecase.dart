import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:parliament_app/src/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call(UserEntity user) async {
    return await repository.login(user); // Return user
  }
}

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<UserEntity> call(UserEntity user) async {
    print("ddddddd");
    return await repository.signup(user); // Return user
  }
}

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call(String userId) async {
    return await repository.logout(userId); // Return user
  }
}

class LinkChildUseCase {
  final AuthRepository repository;

  LinkChildUseCase(this.repository);

  Future<void> call(String email) async {
    return await repository.linkChild(email); // Return user
  }
}

class ChooseRoleUseCase {
  final AuthRepository repository;

  ChooseRoleUseCase(this.repository);

  Future<UserEntity> call(String role) async {
    return await repository.chooseRole(role); // Return user
  }
}
