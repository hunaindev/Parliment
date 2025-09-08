import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUpdating extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;

  ProfileLoaded(this.user);
}

class ProfileUpdated extends ProfileState {
  final UserEntity user;

  ProfileUpdated(this.user);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
