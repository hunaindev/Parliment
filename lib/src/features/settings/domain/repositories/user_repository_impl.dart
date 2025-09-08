// lib/src/features/settings/data/repositories/user_repository_impl.dart

import 'package:image_picker/image_picker.dart';
import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:parliament_app/src/features/settings/data/data_sources/remote/profile_remote_datasource.dart';
import 'package:parliament_app/src/features/settings/domain/repositories/profile_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ProfileRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> getUser() async {
    // FIX: Implement this method instead of throwing an error.
    // It calls the corresponding method on your data source.
    print('[UserRepositoryImpl] getUser called');
    return await remoteDataSource.getUser();
  }

  @override
  Future<UserEntity> updateUser({
    required String name,
    required String email,
    required String phone,
    String? imagePath,
    XFile? imageFile,
  }) async {
    print('[UserRepositoryImpl] updateUser called, forwarding to datasource...');
    // This part was already correct.
    return await remoteDataSource.updateUserProfile(
      name: name,
      email: email,
      phone: phone,
      imagePath: imagePath,
      imageFile: imageFile,
    );
  }
}