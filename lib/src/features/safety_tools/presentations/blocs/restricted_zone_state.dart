abstract class RestrictedZoneState {}

class RestrictedZoneInitial extends RestrictedZoneState {}

class RestrictedZoneLoading extends RestrictedZoneState {}

class RestrictedZoneSuccess extends RestrictedZoneState {}

class RestrictedZoneError extends RestrictedZoneState {
  final String message;

  RestrictedZoneError(this.message);
}
