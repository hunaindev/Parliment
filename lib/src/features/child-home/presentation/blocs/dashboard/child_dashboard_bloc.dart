import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/features/child-home/domain/repositories/child_dashboard_repository.dart';
import 'package:parliament_app/src/features/child-home/presentation/blocs/dashboard/child_dashboard_event.dart';
import 'package:parliament_app/src/features/child-home/presentation/blocs/dashboard/child_dashboard_state.dart';
import 'package:location/location.dart' as loc;

class ChildDashboardBloc
    extends Bloc<ChildDashboardEvent, ChildDashboardState> {
  final ChildDashboardRepository repository;

  List _geofences = [];
  List _restrictedZones = [];

  List get geofences => _geofences;
  List get restrictedZones => _restrictedZones;

  double _lat = 0.0;
  double _lng = 0.0;

  double get currentLat => _lat;
  double get currentLng => _lng;

  ChildDashboardBloc({required this.repository})
      : super(ChildDashboardInitial()) {
    on<FetchChildDasboard>(_onFetch);
  }

  Future<void> _onFetch(
    FetchChildDasboard event,
    Emitter<ChildDashboardState> emit,
  ) async {
    final loc.Location location = loc.Location();
    print("🔍 FetchChildDasboard triggered with userId: ${event.userId}");

    try {
      emit(ChildDashboardLoading());

      final response = await repository.fetchDasboard(userId: event.userId);

      _geofences = response.geofences;
      _restrictedZones = response.restricted_zones;

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) throw Exception("Location services are disabled.");
      }

      loc.PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          throw Exception("Location permission denied.");
        }
      }

      final loc.LocationData locationData = await location.getLocation();
      _lat = locationData.latitude ?? 0.0;
      _lng = locationData.longitude ?? 0.0;

      emit(ChildDashboardLoaded(
        geofences: _geofences,
        restricted_zones: _restrictedZones,
      ));
    } catch (e) {
      emit(ChildDashboardError(e.toString()));
    }
  }
}
