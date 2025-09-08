import 'package:parliament_app/src/features/safety_tools/data/data_sources/restricted_zone_remote_datasource.dart';
import 'package:parliament_app/src/features/safety_tools/data/models/restricted_zone_model.dart';
import 'package:parliament_app/src/features/safety_tools/domain/entities/restricted_zone_entity.dart';
import 'package:parliament_app/src/features/safety_tools/domain/repositories/restricted_zone_repository.dart';


class RestrictedZoneRepositoryImpl implements RestrictedZoneRepository {
  final RestrictedZoneRemoteDatasource remoteDataSource;

  RestrictedZoneRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createRestrictedZone(
      RestrictedZoneEntity restricted_zone) async {
    final model = RestrictedZoneModel(
      name: restricted_zone.name,
      lat: restricted_zone.lat,
      lng: restricted_zone.lng,
      location: restricted_zone.location,
      radius: restricted_zone.radius,
      assignTo: restricted_zone.assignTo,
      alertOnEntry: restricted_zone.alertOnEntry,
      // alertOnExit: geofence.alertOnExit,
    );
    await remoteDataSource.createRestrictedZone(model);
  }
}
