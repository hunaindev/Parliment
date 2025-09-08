import 'package:image_picker/image_picker.dart';
import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUser();
  Future<UserEntity> updateUser({
    required String name,
    required String email,
    required String phone,
    String? imagePath, // Local file path
    XFile? imageFile,
  });
}
