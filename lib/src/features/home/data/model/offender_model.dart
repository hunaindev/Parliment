import '../../domain/entities/offender_entity.dart';

class OffenderModel extends OffenderEntity {
  OffenderModel({
    required super.name,
    required super.address,
    required super.city,
    required super.state,
    required super.zipCode,
    required super.location,
    required super.gender,
    required super.age,
    required super.eyeColor,
    required super.hairColor,
    required super.height,
    required super.weight,
    required super.marksScarsTattoos,
    required super.courtRecord,
    required super.photoUrl,
    required super.image,
    required super.updateDatetime,
  });

  factory OffenderModel.fromJson(Map<String, dynamic> json) {
    String safeString(dynamic value) =>
        value is String ? value : value?.toString() ?? '';

    return OffenderModel(
      name: safeString(json['name']),
      address: safeString(json['address']),
      city: safeString(json['city']),
      state: safeString(json['state']),
      zipCode: safeString(json['zip_code']),
      location: safeString(json['location']),
      gender: safeString(json['gender']),
      age: safeString(json['age']),
      eyeColor: safeString(json['eye_color']),
      hairColor: safeString(json['hair_color']),
      height: safeString(json['height']),
      weight: safeString(json['weight']),
      marksScarsTattoos: safeString(json['marks_scars_tattoos']),
      courtRecord: safeString(json['court_record']),
      photoUrl: safeString(json['photo_url']),
      image: safeString(json['photo_url']),
      updateDatetime: safeString(json['update_datetime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'location': location,
      'gender': gender,
      'age': age,
      'eye_color': eyeColor,
      'hair_color': hairColor,
      'height': height,
      'weight': weight,
      'marks_scars_tattoos': marksScarsTattoos,
      'court_record': courtRecord,
      'photo_url': photoUrl,
      'update_datetime': updateDatetime,
    };
  }
}
