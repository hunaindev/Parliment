// lib/features/history_reports/data/models/notification_model.dart

import 'package:parliament_app/src/features/history_reports/domain/entities/notification_entity.dart';

// Renamed from ReportModel/NotificationModel for clarity
class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required SenderModel super.sender, // Use the SenderModel here
    required super.title,
    required super.body,
    required super.sentAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["_id"],
    sender: SenderModel.fromJson(json["senderId"]),
    title: json["title"],
    body: json["body"],
    sentAt: DateTime.parse(json["sentAt"]),
  );
}

class SenderModel extends SenderEntity {
  final String email; // Model can have extra fields not in the entity

  const SenderModel({
    required super.id,
    required super.name,
    required this.email,
  });

  factory SenderModel.fromJson(Map<String, dynamic> json) => SenderModel(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
  );
}