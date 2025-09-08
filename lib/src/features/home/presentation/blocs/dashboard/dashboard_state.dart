import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List children;
  final List geofences;
  final List redZone;
  final LatLng currentLocation; // ✅ add geofences here

  const DashboardLoaded(
      {required this.children,
      required this.geofences,
      required this.redZone,
      required this.currentLocation});

  @override
  List<Object?> get props => [children, geofences, currentLocation, redZone];
}

class OffenderError extends DashboardState {
  final String message;

  const OffenderError(this.message);

  @override
  List<Object?> get props => [message];
}

class DashboardRefreshing extends DashboardState {
  final List children;
  final List geofences;
  final List redZone;
  final List notifications;

  DashboardRefreshing({
    required this.children,
    required this.geofences,
    required this.redZone,
    required this.notifications,
  });
}
