import 'package:parliament_app/src/features/family_management/data/data_sources/member_remote_data_source.dart';
import 'package:parliament_app/src/features/family_management/data/models/member_model.dart';

import '../../domain/entities/member_entity.dart';
import '../../domain/repositories/member_repository.dart';
// import '../datasources/member_remote_data_source.dart';
// import '../models/member_model.dart';

class MemberRepositoryImpl implements MemberRepository {
  final MemberRemoteDataSource remoteDataSource;

  MemberRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MemberEntity>> getMembers() {
    return remoteDataSource.getMembers();
  }

  @override
  Future<void> addMember(MemberEntity member) {
    final model = MemberModel(
      name: member.name,
      phone: member.phone,
      image: member.image,
      email: member.email,
      relation: member.relation,
      createdBy: member.createdBy,
    );
    return remoteDataSource.addMember(model);
  }

  @override
  Future<void> editMember(String memberId, MemberEntity updatedMember) {
    final model = MemberModel(
      name: updatedMember.name,
      phone: updatedMember.phone,
      image: updatedMember.image,
      imagePath: updatedMember.imagePath,
      email: updatedMember.email,
      relation: updatedMember.relation,
      createdBy: updatedMember.createdBy,
    );

    return remoteDataSource.editMember(memberId, model);
  }

  @override
  Future<void> deleteMember(String memberId) {
    return remoteDataSource.deleteMember(memberId);
  }
}
