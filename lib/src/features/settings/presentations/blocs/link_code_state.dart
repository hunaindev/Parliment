// presentation/bloc/link_state.dart

import 'package:equatable/equatable.dart';

abstract class LinkState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LinkInitial extends LinkState {}

class LinkLoading extends LinkState {}

class CodeGenerated extends LinkState {
  final String code;
  CodeGenerated(this.code);

  @override
  List<Object?> get props => [code];
}

class CodeVerified extends LinkState {}

class LinkError extends LinkState {
  final String message;
  LinkError(this.message);

  @override
  List<Object?> get props => [message];
}


class LinkSuccess extends LinkState {
  final String? source;

  LinkSuccess({this.source}); // ✅ named parameter
}
