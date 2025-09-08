import 'package:parliament_app/src/features/safety_tools/domain/entities/restricted_zone_entity.dart';

abstract class RestrictedZoneRepository {
  Future<void> createRestrictedZone(RestrictedZoneEntity restricted_zone);
}
