import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.email,
    required super.password,
    super.role,
    super.name,
    super.image,
    super.deviceToken,
    super.phone,
    super.parentEmail,
    super.lat,
    super.lng,
    super.parentDeviceToken,
    super.userId,
    super.parentId,
    super.isLinked,
    super.isVerify,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "role": role,
        "name": name,
        "image": image,
        "deviceToken": deviceToken,
        "phone": phone,
        "parentEmail": parentEmail,
        "lng": lng,
        "lat": lat,
        "userId": userId,
        "parentDeviceToken": parentDeviceToken,
        "parentId": parentId,
        "isLinked": isLinked,
        "isVerify": isVerify,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json["email"] ?? '',
      password: json["password"] ?? '',
      role: json["role"] ?? '',
      name: json["name"] ?? '',
      image: json["image"] ?? '',
      deviceToken: json["deviceToken"] ?? '',
      phone: json["phone"] ?? '',
      parentEmail: json['parentEmail'] ?? '',
      lat: json['lat'] ?? '',
      lng: json['lng'] ?? '',
      userId: json['_id'] ?? json['userId'] ?? '',
      parentDeviceToken: json['parentDeviceToken'] ?? '',
      parentId: json['parentId'] ?? '',
      isLinked: json['isLinked'] ?? false,
      isVerify: json['isVerify'] ?? false,
    );
  }
}
