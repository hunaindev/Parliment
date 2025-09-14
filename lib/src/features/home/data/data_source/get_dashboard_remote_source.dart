// import 'package:parliament_app/src/features/home/data/model/offender_model.dart';

import 'package:parliament_app/src/features/home/data/model/dashboard_data_model.dart';

abstract class GetDashboardRemoteSource {
  Future<DashboardDataModel> fetchDasboard({
    required String parentId,
  });
  Future<void> refreshToken({
    required String userId,
  });
}
