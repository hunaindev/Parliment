class UserEntity {
  final String? name;
  final String email;
  final String password;
  final String? role;
  final String? image;
  final String? deviceToken;
  final String? userId;
  final String? phone;
  final String? parentEmail;
  final String? lat;
  final String? lng;
  final String? parentDeviceToken;
  final String? parentId;
  final bool? isLinked;
  final bool? isVerify;

  UserEntity({
    this.name,
    required this.email,
    required this.password,
    this.role,
    this.image,
    this.deviceToken,
    this.userId,
    this.phone,
    this.parentEmail,
    this.lng,
    this.lat,
    this.parentDeviceToken,
    this.parentId,
    this.isLinked,
    this.isVerify,
  });
}
