import 'package:parliament_app/src/features/child-home/data/models/child_dashboard_model.dart';

abstract class ChildDashboardRepository {
  Future<ChildDashboardModel> fetchDasboard({
    required String userId,
  });
}
