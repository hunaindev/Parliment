import 'package:parliament_app/src/features/child-home/data/models/child_dashboard_model.dart';
import 'package:parliament_app/src/features/child-home/data/remote_data_source/get_children_dashboard_remote_data_source.dart';
import 'package:parliament_app/src/features/child-home/domain/repositories/child_dashboard_repository.dart';

class ChildDashboardRepositoryImpl implements ChildDashboardRepository {
  final GetChildrenDashboardRemoteDataSource remoteDataSource;

  ChildDashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<ChildDashboardModel> fetchDasboard({
    required String userId,
  }) async {
    final model = await remoteDataSource.fetchDasboard(userId: userId);

    return ChildDashboardModel(
      geofences: model.geofences,
      restricted_zones: model.restricted_zones,
    );
  }
}
