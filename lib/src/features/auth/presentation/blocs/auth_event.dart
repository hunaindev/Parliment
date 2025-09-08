part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final UserEntity user;
  final String source; // "login" or "signup"
  LoginEvent(this.user, {this.source = "login"});
}

class SignupEvent extends AuthEvent {
  final UserEntity user;
  final String source; // "login" or "signup"
  SignupEvent(this.user, {this.source = "signup"});
}

class LinkChildEvent extends AuthEvent {
  final String email;
  final String source; // "login" or "signup"
  LinkChildEvent(this.email, {this.source = "link_child"});
}
class LogoutEvent extends AuthEvent {
  final String userId;
  final String source; // "login" or "signup"
  LogoutEvent(this.userId, {this.source = "logout"});
}

class ChooseRoleEvent extends AuthEvent {
  final String role;
  // final UserEntity user;
  final String source;
  ChooseRoleEvent(this.role, {this.source = "chooseRole"});
}
