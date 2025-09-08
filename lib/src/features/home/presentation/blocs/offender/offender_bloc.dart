import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/features/home/domain/repositories/offender_repository.dart';
import '../../../domain/entities/offender_entity.dart';
// import '../../../../../core/services/offender_service.dart';
import 'offender_event.dart';
import 'offender_state.dart';

class OffenderBloc extends Bloc<OffenderEvent, OffenderState> {
  final OffenderRepository repository;

  List<OffenderEntity> _allOffenders = [];
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMore = true;
  String _currentQuery = '';
  double _lat = 0.0;
  double _lng = 0.0;

  OffenderBloc({required this.repository}) : super(OffenderInitial()) {
    on<FetchOffenders>(_onFetch);
    on<LoadMoreOffenders>(_onLoadMore);
    on<SearchOffenders>(_onSearch);
  }

  Future<void> _onFetch(
      FetchOffenders event, Emitter<OffenderState> emit) async {
    try {
      emit(OffenderLoading());
      _currentPage = 1;
      _lat = event.lat;
      _lng = event.lng;
      _currentQuery = '';
      final offenders = await repository.fetchOffenders(
        lat: event.lat,
        lng: event.lng,
        page: _currentPage,
        pageSize: _pageSize,
      );
      _allOffenders = offenders;
      _hasMore = offenders.length == _pageSize;
      emit(OffenderLoaded(offenders: _allOffenders, hasMore: _hasMore));
    } catch (e) {
      emit(OffenderError(e.toString()));
    }
  }

  Future<void> _onLoadMore(
      LoadMoreOffenders event, Emitter<OffenderState> emit) async {
    if (!_hasMore || state is OffenderLoading) return;

    try {
      _currentPage++;
      final offenders = await repository.fetchOffenders(
        lat: _lat,
        lng: _lng,
        page: _currentPage,
        pageSize: _pageSize,
      );
      _allOffenders.addAll(offenders);
      _hasMore = offenders.length == _pageSize;
      emit(OffenderLoaded(offenders: _allOffenders, hasMore: _hasMore));
    } catch (e) {
      emit(OffenderError(e.toString()));
    }
  }

  void _onSearch(SearchOffenders event, Emitter<OffenderState> emit) {
    _currentQuery = event.query.trim().toLowerCase();
    final filtered = _allOffenders.where((offender) {
      return offender.name.toLowerCase().contains(_currentQuery) ||
          offender.address.toLowerCase().contains(_currentQuery) ||
          offender.courtRecord.toLowerCase().contains(_currentQuery);
    }).toList();
    emit(OffenderLoaded(offenders: filtered, hasMore: _hasMore));
  }
}
