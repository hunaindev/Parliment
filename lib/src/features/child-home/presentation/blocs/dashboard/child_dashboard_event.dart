import 'package:equatable/equatable.dart';

abstract class ChildDashboardEvent extends Equatable {
  const ChildDashboardEvent();

  @override
  List<Object?> get props => [];
}

// Initial fetch (or refresh)
class FetchChildDasboard extends ChildDashboardEvent {
  // final double lat;
  final String userId;

  const FetchChildDasboard({required this.userId}) : super();

  @override
  List<Object?> get props => [userId];
}
