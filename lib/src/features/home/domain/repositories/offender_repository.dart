import '../entities/offender_entity.dart';

abstract class OffenderRepository {
  Future<List<OffenderEntity>> fetchOffenders({
    required double lat,
    required double lng,
    required int page,
    required int pageSize,
  });
}
