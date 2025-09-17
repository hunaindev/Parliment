// import 'package:parliament_app/src/features/home/data/model/offender_model.dart';

import 'package:parliament_app/src/features/child-home/data/models/child_dashboard_model.dart';

abstract class GetChildrenDashboardRemoteDataSource {
  Future<ChildDashboardModel> fetchDasboard({required String userId});
  Future<void> refreshToken({required String userId});
}
