class ChildOffenderModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? photoUrl;
  final String? age;
  final String? height;
  final String? weight;
  final String? address;

  ChildOffenderModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.photoUrl,
    this.age,
    this.height,
    this.weight,
    this.address,
  });

  factory ChildOffenderModel.fromJson(Map<String, dynamic> json) {
    final locationString = json['location'] as String?;
    double lat = 0.0;
    double lng = 0.0;
    
    if (locationString != null && locationString.contains(',')) {
      final parts = locationString.split(',');
      if (parts.length == 2) {
        lat = double.tryParse(parts[0]) ?? 0.0;
        lng = double.tryParse(parts[1]) ?? 0.0;
      }
    }
    
    final uniqueId = json['photo_url'] as String? ?? json['name'] as String? ?? DateTime.now().toIso8601String();

    return ChildOffenderModel(
      id: uniqueId,
      name: json['name'] ?? 'Unknown Name',
      latitude: lat,
      longitude: lng,
      photoUrl: json['photo_url'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
      address: json['address'],
    );
  }
}