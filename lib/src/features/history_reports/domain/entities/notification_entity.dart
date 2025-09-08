// lib/features/history_reports/domain/entities/notification_entity.dart

import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final SenderEntity sender;
  final String title;
  final String body;
  final DateTime sentAt;

  const NotificationEntity({
    required this.id,
    required this.sender,
    required this.title,
    required this.body,
    required this.sentAt,
  });

  @override
  List<Object?> get props => [id, sender, title, body, sentAt];
}

class SenderEntity extends Equatable {
  final String id;
  final String name;

  const SenderEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}