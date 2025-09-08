// lib/features/history_reports/data/repositories/notification_repository_impl.dart

import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../data_sources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    // Because our Model extends our Entity, the list from the data source
    // is already a List<NotificationEntity>. No manual mapping is needed.
    // This is the benefit of the class extension approach.
    final notificationModels = await remoteDataSource.getNotifications();
    return notificationModels;
  }
}