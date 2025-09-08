import 'package:parliament_app/src/features/safety_tools/domain/entities/restricted_zone_entity.dart';

class RestrictedZoneModel extends RestrictedZoneEntity {
  RestrictedZoneModel({
    required super.name,
    required super.lat,
    required super.lng,
    required super.radius,
    // required super.childId,
    required super.alertOnEntry,
    required super.assignTo,
    required super.location,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        // "center": {"lat": lat, "lng": lng},
        "latitude": lat,
        "longitude": lng,
        "radius": radius,
        "assignTo": assignTo,
        "alertOnEntry": alertOnEntry,
        "location": location,
      };
}
