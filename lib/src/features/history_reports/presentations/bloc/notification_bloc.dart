// lib/features/history_reports/presentations/bloc/notification_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/notification_repository.dart'; // Depend on the abstraction
import 'notification_event.dart';
// import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository; // Use the abstract repository

  NotificationBloc(this.repository) : super(NotificationInitial()) {
    on<FetchNotifications>((event, emit) async {
      emit(NotificationLoading());
      try {
        // The repository now correctly returns List<NotificationEntity>
        final notifications = await repository.getNotifications();
        emit(NotificationLoaded(notifications));
      } catch (e) {
        emit(NotificationError("Failed to fetch notifications: ${e.toString()}"));
      }
    });
  }
}