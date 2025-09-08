import 'package:parliament_app/src/features/safety_tools/domain/entities/geofence_entity.dart';

class GeofenceModel extends GeofenceEntity {
  GeofenceModel({
    required super.name,
    required super.lat,
    required super.lng,
    required super.radius,
    required super.childId,
    required super.alertOnEntry,
    required super.alertOnExit,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "center": {"lat": lat, "lng": lng},
        "radius": radius,
        "childId": childId,
        "alertOnEntry": alertOnEntry,
        "alertOnExit": alertOnExit,
      };
}
