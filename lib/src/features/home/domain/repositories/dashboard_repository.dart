import 'package:parliament_app/src/features/home/data/model/dashboard_data_model.dart';

abstract class DashboardRepository {
  Future<DashboardDataModel> fetchDasboard({
    required String parentId,
  });
}
