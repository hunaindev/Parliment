// presentation/bloc/link_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:parliament_app/src/core/services/parent_firestore_service.dart';
// import 'package:parliament_app/src/features/auth/presentation/blocs/user_cubit.dart';
// import 'package:parliament_app/src/features/home/presentation/blocs/location/location_cubit.dart';
import 'package:parliament_app/src/features/settings/domain/usercases/link_code_usecase.dart';
import 'package:parliament_app/src/features/settings/domain/usercases/verify_code_usecase.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/link_code_state.dart';
// import 'package:parliament_app/src/features/link/domain/usecases/generate_code_usecase.dart';
// import 'package:parliament_app/src/features/link/domain/usecases/verify_code_usecase.dart';
// import 'link_state.dart';

class LinkCubit extends Cubit<LinkState> {
  final GenerateCodeUseCase generateCodeUseCase;
  final VerifyCodeUseCase verifyCodeUseCase;

  LinkCubit({
    required this.generateCodeUseCase,
    required this.verifyCodeUseCase,
  }) : super(LinkInitial());

  Future<void> generateCode() async {
    emit(LinkLoading());
    try {
      final code = await generateCodeUseCase();
      emit(CodeGenerated(code));
    } catch (e) {
      print("e.toString(): ${e.toString()}");
      emit(LinkError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> verifyCode(String code) async {
    emit(LinkLoading());
    try {
      print(code);
      final success = await verifyCodeUseCase(code);
      if (success) {
        emit(CodeVerified());
      } else {
        emit(LinkError('Invalid code'));
      }
    } catch (e) {
      print("e.toString(): ${e.toString()}");
      emit(LinkError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
