import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/features/settings/domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  // Use the name 'userRepository' for clarity and consistency
  final UserRepository userRepository;

  // Use the consistent name in the constructor
  ProfileBloc(this.userRepository) : super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoad);
    on<UpdateUserProfile>(_onUpdate);
  }

  void _onLoad(LoadUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      // This will now work because we will fix the repository implementation next
      final user = await userRepository.getUser();
      print("get user api called");
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError("Failed to load user: ${e.toString()}"));
    }
  }

  void _onUpdate(UpdateUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    emit(ProfileUpdating()); // 🔁 Emit updating state

    try {
      print(
          '[ProfileBloc] Update event received. Calling repository... ${event}');

      final updatedUser = await userRepository.updateUser(
          name: event.name,
          email: event.email,
          phone: event.phone,
          imagePath: event.imagePath,
          imageFile: event.imageFile);

      // print("updatedUser: ${updatedUser}");
      // print("updatedUser data: ${updatedUser.name}");
      // print("updatedUser.image in profile bloc: ${updatedUser.image}");

      emit(ProfileUpdated(updatedUser));
      print('[ProfileBloc] Profile updated successfully.');
    } catch (e) {
      print('[ProfileBloc] Error during update: ${e.toString()}');
      // A cleaner way is to cast it.
      String errorMessage = (e is Exception)
          ? e.toString().replaceFirst('Exception: ', '')
          : "An unknown error occurred";
      emit(ProfileError(errorMessage));
    }
  }
}
