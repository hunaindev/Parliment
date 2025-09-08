class MemberEntity {
  final String name;
  final String phone;
  final String image;
  final String? imagePath;
  final String? memberId;
  final String? relation;
  final String? createdBy;
  final String? email;
  // final String? deviceToken;
  // final String? userId;
  // final String? phone;

  MemberEntity(
      {required this.name,
      required this.phone,
      required this.image,
      this.imagePath,
      this.memberId,
      this.relation,
      this.createdBy,
      this.email});
}
