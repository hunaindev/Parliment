import '../entities/geofence_entity.dart';
import '../repositories/geofence_repository.dart';

class CreateGeofenceUseCase {
  final GeofenceRepository repository;

  CreateGeofenceUseCase(this.repository);

  Future<void> call(GeofenceEntity geofence) async {
    await repository.createGeofence(geofence);
  }
}
