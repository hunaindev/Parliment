import '../repositories/member_repository.dart';

class DeleteMemberUseCase {
  final MemberRepository repository;

  DeleteMemberUseCase(this.repository);

  Future<void> call(String memberId) => repository.deleteMember(memberId);
}
