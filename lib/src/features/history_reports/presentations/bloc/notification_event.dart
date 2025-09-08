// notification_event.dart
import 'package:equatable/equatable.dart';
import 'package:parliament_app/src/features/history_reports/domain/entities/notification_entity.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object> get props => [];
}
class FetchNotifications extends NotificationEvent {}


abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object> get props => [];
}
class NotificationInitial extends NotificationState {}
class NotificationLoading extends NotificationState {}
class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications; // Use the entity
  const NotificationLoaded(this.notifications);
  @override
  List<Object> get props => [notifications];
}
class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
  @override
  List<Object> get props => [message];
}