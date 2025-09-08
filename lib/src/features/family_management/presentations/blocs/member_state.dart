import '../../domain/entities/member_entity.dart';

abstract class MemberState {}

class MemberInitial extends MemberState {}

class MemberLoading extends MemberState {}

class MemberLoaded extends MemberState {
  final List<MemberEntity> members;
  MemberLoaded(this.members);
}

class MemberError extends MemberState {
  final String message;
  MemberError(this.message);
}
