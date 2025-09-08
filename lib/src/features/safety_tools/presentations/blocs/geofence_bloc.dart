import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/features/safety_tools/domain/usecases/create_geofence_usecase.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/blocs/geofence_event.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/blocs/geofence_state.dart';

// part 'geofence_event.dart';
// part 'geofence_state.dart';

class GeofenceBloc extends Bloc<GeofenceEvent, GeofenceState> {
  final CreateGeofenceUseCase createGeofenceUseCase;

  GeofenceBloc({required this.createGeofenceUseCase})
      : super(GeofenceInitial()) {
    on<CreateGeofenceEvent>((event, emit) async {
      emit(GeofenceLoading());
      try {
        await createGeofenceUseCase(event.geofence);
        emit(GeofenceSuccess());
      } catch (e) {
        print("error: ${e.toString()}");
        emit(GeofenceErrorState(e.toString()));
      }
    });
  }
}
