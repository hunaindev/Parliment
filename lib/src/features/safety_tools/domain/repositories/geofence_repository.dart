import '../entities/geofence_entity.dart';

abstract class GeofenceRepository {
  Future<void> createGeofence(GeofenceEntity geofence);
}
