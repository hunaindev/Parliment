import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

// Initial fetch (or refresh)
class FetchDasboard extends DashboardEvent {
  // final double lat;
  final String parentId;

  const FetchDasboard({required this.parentId}) : super();

  @override
  List<Object?> get props => [parentId];
}
