import 'package:equatable/equatable.dart';
// import '../../../domain/entities/offender_entity.dart';

abstract class ChildDashboardState extends Equatable {
  const ChildDashboardState();

  @override
  List<Object?> get props => [];
}

class ChildDashboardInitial extends ChildDashboardState {}

class ChildDashboardLoading extends ChildDashboardState {}

class ChildDashboardLoaded extends ChildDashboardState {
  final List geofences;
  final List restricted_zones;
  // final bool hasMore;

  const ChildDashboardLoaded({
    required this.geofences,
    required this.restricted_zones,
    // required this.hasMore,
  });

  @override
  List<Object?> get props => [geofences, restricted_zones];
  // List<Object?> get props => [restricted_zone];
}

class ChildDashboardError extends ChildDashboardState {
  final String message;

  const ChildDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
