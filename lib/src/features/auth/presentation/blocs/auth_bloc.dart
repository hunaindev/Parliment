import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:parliament_app/src/features/auth/data/models/user_model.dart';
import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:parliament_app/src/features/auth/domain/usecase/user_usecase.dart';
// import 'package:parliament_app/src/features/auth/presentation/blocs/user_cubit.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LinkChildUseCase linkChildUseCase;
  final LogoutUseCase logoutUseCase;
  final ChooseRoleUseCase chooseRoleUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.linkChildUseCase,
    required this.logoutUseCase,
    required this.chooseRoleUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        final user = await loginUseCase(event.user); // Capture returned user
        print("user reached to auth_bloc $user");
        print("event.source: ${event.source}");

        emit(AuthSuccess(user, source: event.source)); // Pass user to state
        // emit(AuthSuccess());
      } catch (err) {
        print("event.source from err: ${event.source}");

        print("err.toString(): ${err.toString()}");
        emit(AuthError(err.toString(), source: event.source));
      }
    });

    on<SignupEvent>((event, emit) async {
      print("🚀 SignupEvent received in AuthBloc 112");
      emit(SignupLoading());
      try {
        final user = await signupUseCase(event.user);

        emit(AuthSuccess(user, source: event.source)); // ✅ pass source
      } catch (e) {
        print("❌ Signup error in AuthBloc: $e");
        emit(AuthError(e.toString(), source: event.source)); // ✅ pass source
      }
    });

    on<ChooseRoleEvent>((event, emit) async {
      emit(AuthLoading(source: event.source));
      try {
        final user = await chooseRoleUseCase(event.role);
        print("usera after role: ${user}");
        emit(RoleSuccess(user: user, source: event.source)); // ✅ pass source
      } catch (e) {
        print("❌ Role error in AuthBloc: $e");
        emit(AuthError(e.toString(), source: event.source)); // ✅ pass source
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading(source: event.source));
      try {
        await logoutUseCase(event.userId); // Capture returned user
        // print("user reached to auth_bloc $user");
        print("event.source: ${event.source}");

        emit(LogoutSuccess(source: event.source)); // Pass user to state
        // emit(AuthSuccess());
      } catch (err) {
        print("event.source from err: ${event.source}");

        print("err.toString(): ${err.toString()}");
        emit(AuthError(err.toString(), source: event.source));
      }
    });

    on<LinkChildEvent>((event, emit) async {
      emit(AuthLoading(source: event.source));
      try {
        await linkChildUseCase(event.email);

        emit(LinkSuccess(source: event.source)); // ✅ pass source
      } catch (e) {
        print("❌ Child Link error in AuthBloc: $e");
        emit(AuthError(e.toString(), source: event.source)); // ✅ pass source
      }
    });
  }
}
