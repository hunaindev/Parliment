import '../entities/member_entity.dart';

abstract class MemberRepository {
  Future<List<MemberEntity>> getMembers();
  Future<void> addMember(MemberEntity member);
  // Future<void> editMember(MemberEntity member);
  Future<void> deleteMember(String memberId);

  /// 🔥 Add this:
  Future<void> editMember(String memberId, MemberEntity updatedMember);
}
