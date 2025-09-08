part of 'auth_bloc.dart';

abstract class AuthState {
  final String? source;
  const AuthState({this.source});
}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class SignupLoading extends AuthState {}

class AuthLoading extends AuthState {
  AuthLoading({String? source}) : super(source: source);
}

class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess(this.user, {String? source}) : super(source: source);
}

class LogoutSuccess extends AuthState {
  // final String userId;
  LogoutSuccess({String? source}) : super(source: source);
}

class LinkSuccess extends AuthState {
  // final UserEntity user;
  LinkSuccess({String? source}) : super(source: source);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message, {String? source}) : super(source: source);
}

class RoleSuccess extends AuthState {
  final UserEntity user;
  // RoleSuccess({String? source}) : super(source: source);
  RoleSuccess({required this.user, String? source}) : super(source: source);
}
