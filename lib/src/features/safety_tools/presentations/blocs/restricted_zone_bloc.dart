import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/features/safety_tools/domain/usecases/restricted_zone_usecase.dart';
// import 'package:parliament_app/src/features/safety_tools/domain/usecases/create_restricted_zone_usecase.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/blocs/restricted_zone_event.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/blocs/restricted_zone_state.dart';

class RestrictedZoneBloc extends Bloc<RestrictedZoneEvent, RestrictedZoneState> {
  final CreateRestrictedZoneUseCase createRestrictedZoneUseCase;

  RestrictedZoneBloc({required this.createRestrictedZoneUseCase})
      : super(RestrictedZoneInitial()) {
    on<CreateRestrictedZoneEvent>((event, emit) async {
      emit(RestrictedZoneLoading());
      try {
        await createRestrictedZoneUseCase(event.restrictedZone);
        emit(RestrictedZoneSuccess());
      } catch (e) {
        print("error: ${e.toString()}");
        emit(RestrictedZoneError(e.toString()));
      }
    });
  }
}
