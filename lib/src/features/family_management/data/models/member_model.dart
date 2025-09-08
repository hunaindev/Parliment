// import '../../domain/entities/user_entity.dart';

import 'package:parliament_app/src/features/family_management/domain/entities/member_entity.dart';

class MemberModel extends MemberEntity {
  MemberModel({
    required super.name,
    required super.phone,
    required super.image,
    super.imagePath,
    super.memberId,
    super.email,
    super.relation,
    super.createdBy,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "phone": phone,
        "memberId": memberId,
        "relation": relation,
        "image": image,
      };

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      name: json["name"] ?? '',
      email: json["email"] ?? '',
      phone: json["phone"] ?? '',
      memberId: json['_id'] ?? '',
      image: json["image"] ?? '',
      relation: json["relation"] ?? '',
    );
  }
}
