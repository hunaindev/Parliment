import 'package:parliament_app/src/features/home/domain/entities/children_entity.dart';

class ChildrenModel extends ChildrenEntity {
  ChildrenModel({
    required super.name,
    required super.id,
    super.image,
  });

  factory ChildrenModel.fromJson(Map<String, dynamic> json) {
    String safeString(dynamic value) =>
        value is String ? value : value?.toString() ?? '';

    return ChildrenModel(
      name: safeString(json['name']),
      id: safeString(json['_id']),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'image': image,
    };
  }
}
