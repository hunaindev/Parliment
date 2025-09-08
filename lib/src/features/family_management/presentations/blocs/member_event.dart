import '../../domain/entities/member_entity.dart';

abstract class MemberEvent {}

class LoadMembers extends MemberEvent {}

class AddMember extends MemberEvent {
  final MemberEntity member;

  AddMember(this.member);
}

class DeleteMember extends MemberEvent {
  final String memberId;

  DeleteMember(this.memberId);
}

/// 🔥 New Event
class EditMember extends MemberEvent {
  final String memberId;
  final MemberEntity updatedMember;

  EditMember({required this.memberId, required this.updatedMember});
}
