// lib/features/history_reports/domain/repositories/notification_repository.dart

import 'package:parliament_app/src/features/history_reports/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications();
}