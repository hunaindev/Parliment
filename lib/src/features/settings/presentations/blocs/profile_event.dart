// lib/src/features/settings/presentations/blocs/profile_event.dart

import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent {}

class LoadUserProfile extends ProfileEvent {}

class UpdateUserProfile extends ProfileEvent {
  final String name;
  final String email;
  final String phone;
  final String? imagePath;
  final XFile? imageFile;

  UpdateUserProfile({
    required this.name,
    required this.email,
    required this.phone,
    this.imagePath,
    this.imageFile,
  });
}