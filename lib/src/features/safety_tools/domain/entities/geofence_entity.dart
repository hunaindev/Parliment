class GeofenceEntity {
  final String name;
  final double lat;
  final double lng;
  final double radius;
  final bool? alertOnEntry;
  final bool? alertOnExit;
  final String? childId;

  GeofenceEntity(
      {required this.name,
      required this.lat,
      required this.lng,
      required this.radius,
      required this.alertOnEntry,
      required this.alertOnExit,
      this.childId});
}
