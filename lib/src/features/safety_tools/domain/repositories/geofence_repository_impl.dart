import 'package:parliament_app/src/features/safety_tools/data/data_sources/geofence_remote_datasource.dart';
import 'package:parliament_app/src/features/safety_tools/data/models/geofence_model.dart';

import '../../domain/entities/geofence_entity.dart';
import '../../domain/repositories/geofence_repository.dart';

class GeofenceRepositoryImpl implements GeofenceRepository {
  final GeofenceRemoteDataSource remoteDataSource;

  GeofenceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createGeofence(GeofenceEntity geofence) async {
    final model = GeofenceModel(
      name: geofence.name,
      lat: geofence.lat,
      lng: geofence.lng,
      radius: geofence.radius,
      childId: geofence.childId,
      alertOnEntry: geofence.alertOnEntry,
      alertOnExit: geofence.alertOnExit,
    );
    await remoteDataSource.createGeofence(model);
  }
}
