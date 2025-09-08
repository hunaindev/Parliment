import 'package:equatable/equatable.dart';
import '../../../domain/entities/offender_entity.dart';

abstract class OffenderState extends Equatable {
  const OffenderState();

  @override
  List<Object?> get props => [];
}

class OffenderInitial extends OffenderState {}

class OffenderLoading extends OffenderState {}

class OffenderLoaded extends OffenderState {
  final List<OffenderEntity> offenders;
  final bool hasMore;

  const OffenderLoaded({
    required this.offenders,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [offenders, hasMore];
}

class OffenderError extends OffenderState {
  final String message;

  const OffenderError(this.message);

  @override
  List<Object?> get props => [message];
}
