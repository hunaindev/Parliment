import 'package:parliament_app/src/features/home/data/model/offender_model.dart';

abstract class OffenderRemoteDataSource {
  Future<List<OffenderModel>> fetchOffenders({
    required double lat,
    required double lng,
    required int page,
    required int pageSize,
  });
}
