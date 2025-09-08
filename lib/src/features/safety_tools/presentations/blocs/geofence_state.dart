abstract class GeofenceState {}

class GeofenceInitial extends GeofenceState {}

class GeofenceLoading extends GeofenceState {}

class GeofenceSuccess extends GeofenceState {}

class GeofenceErrorState extends GeofenceState {
  final String message;

  GeofenceErrorState(this.message);
}
