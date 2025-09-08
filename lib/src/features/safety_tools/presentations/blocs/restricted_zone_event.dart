import 'package:parliament_app/src/features/safety_tools/data/models/restricted_zone_model.dart';


abstract class RestrictedZoneEvent {}

class CreateRestrictedZoneEvent extends RestrictedZoneEvent {
  final RestrictedZoneModel restrictedZone;

  CreateRestrictedZoneEvent(this.restrictedZone);
}
