import 'package:equatable/equatable.dart';

abstract class OffenderEvent extends Equatable {
  const OffenderEvent();

  @override
  List<Object?> get props => [];
}

// Initial fetch (or refresh)
class FetchOffenders extends OffenderEvent {
  final double lat;
  final double lng;

  const FetchOffenders({required this.lat, required this.lng});
}

// Fetch next page for infinite scroll
class LoadMoreOffenders extends OffenderEvent {}

// Apply search filter
class SearchOffenders extends OffenderEvent {
  final String query;

  const SearchOffenders(this.query);

  @override
  List<Object?> get props => [query];
}
