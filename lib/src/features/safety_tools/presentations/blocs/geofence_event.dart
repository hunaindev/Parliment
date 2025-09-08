import '../../domain/entities/geofence_entity.dart';

abstract class GeofenceEvent {}

class CreateGeofenceEvent extends GeofenceEvent {
  final GeofenceEntity geofence;

  CreateGeofenceEvent(this.geofence);
}
