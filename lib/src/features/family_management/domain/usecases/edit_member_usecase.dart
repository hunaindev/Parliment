import '../entities/member_entity.dart';
import '../repositories/member_repository.dart';

class EditMemberUseCase {
  final MemberRepository repository;

  EditMemberUseCase(this.repository);

  Future<void> call(String memberId, MemberEntity updatedMember) {
    return repository.editMember(memberId, updatedMember);
  }
}
