import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/features/family_management/domain/usecases/get_member_usecase.dart';
// import '../../domain/entities/member_entity.dart';
import '../../domain/usecases/edit_member_usecase.dart';
// import '../../domain/usecases/get_members_usecase.dart';
import '../../domain/usecases/add_member_usecase.dart';
import '../../domain/usecases/delete_member_usecase.dart';
import 'member_event.dart';
import 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final GetMembersUseCase getMembersUseCase;
  final AddMemberUseCase addMemberUseCase;
  final DeleteMemberUseCase deleteMemberUseCase;
  final EditMemberUseCase editMemberUseCase;

  MemberBloc({
    required this.getMembersUseCase,
    required this.addMemberUseCase,
    required this.deleteMemberUseCase,
    required this.editMemberUseCase,
  }) : super(MemberInitial()) {
    on<LoadMembers>((event, emit) async {
      emit(MemberLoading());
      try {
        final members = await getMembersUseCase();
        emit(MemberLoaded(members));
      } catch (e) {
        emit(MemberError(e.toString()));
      }
    });

    on<AddMember>((event, emit) async {
      try {
        await addMemberUseCase(event.member);
        add(LoadMembers());
      } catch (e) {
        emit(MemberError("Failed to add member: $e"));
      }
    });

    on<DeleteMember>((event, emit) async {
      try {
        await deleteMemberUseCase(event.memberId);
        add(LoadMembers());
      } catch (e) {
        emit(MemberError("Failed to delete member: $e"));
      }
    });

    on<EditMember>((event, emit) async {
      try {
        await editMemberUseCase(event.memberId, event.updatedMember);
        add(LoadMembers());
      } catch (e) {
        emit(MemberError("Failed to edit member: $e"));
      }
    });
  }
}
