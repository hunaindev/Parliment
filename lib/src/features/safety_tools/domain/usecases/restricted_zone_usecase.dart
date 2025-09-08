import 'package:parliament_app/src/features/safety_tools/data/models/restricted_zone_model.dart';
import 'package:parliament_app/src/features/safety_tools/domain/repositories/restricted_zone_repository.dart';

class CreateRestrictedZoneUseCase {
  final RestrictedZoneRepository repository;

  CreateRestrictedZoneUseCase(this.repository);

  Future<void> call(RestrictedZoneModel restrictedZone) async {
    await repository.createRestrictedZone(restrictedZone);
  }
}
