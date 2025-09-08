class RestrictedZoneEntity {
  final String name;
  final double radius;
  final String location;
  final double lat;
  final double lng;
  final bool? alertOnEntry;
  // final bool? alertOnExit;
  final String assignTo;

  RestrictedZoneEntity(
      {required this.name,
      required this.lat,
      required this.lng,
      required this.radius,
      required this.alertOnEntry,
      required this.location,
    required  this.assignTo,
      });
}
