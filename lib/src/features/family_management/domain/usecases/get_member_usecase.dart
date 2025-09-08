import '../entities/member_entity.dart';
import '../repositories/member_repository.dart';

class GetMembersUseCase {
  final MemberRepository repository;

  GetMembersUseCase(this.repository);

  Future<List<MemberEntity>> call() => repository.getMembers();
}
