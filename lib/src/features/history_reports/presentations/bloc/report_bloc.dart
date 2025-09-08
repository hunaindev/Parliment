import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository repository;

  ReportBloc(this.repository) : super(ReportInitial()) {
    on<FetchReports>((event, emit) async {
      emit(ReportLoading());
      try {
        // final reports = await repository.getReports();
        // emit(ReportLoaded(reports));
      } catch (_) {
        emit(ReportError("Failed to fetch reports"));
      }
    });
  }
}
