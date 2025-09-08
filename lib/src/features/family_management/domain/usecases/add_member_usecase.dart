import '../entities/member_entity.dart';
import '../repositories/member_repository.dart';

class AddMemberUseCase {
  final MemberRepository repository;

  AddMemberUseCase(this.repository);

  Future<void> call(MemberEntity member) => repository.addMember(member);
}
