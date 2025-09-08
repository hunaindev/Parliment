import 'package:parliament_app/src/features/home/data/data_source/get_dashboard_remote_source.dart';
import 'package:parliament_app/src/features/home/data/model/dashboard_data_model.dart';
// import 'package:parliament_app/src/features/home/domain/entities/offender_entity.dart';
import 'package:parliament_app/src/features/home/domain/repositories/dashboard_repository.dart';
// import 'package:parliament_app/src/features/home/domain/repositories/offender_repository.dart';
// import '../data_source/offender_remote_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final GetDashboardRemoteSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<DashboardDataModel> fetchDasboard({
    required String parentId,
  }) async {
    final models = await remoteDataSource.fetchDasboard(
      parentId: parentId,
    );

    return models;
  }
}
