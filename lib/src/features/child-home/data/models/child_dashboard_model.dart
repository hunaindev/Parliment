import 'package:parliament_app/src/features/child-home/domain/entities/child_dashboard_entity.dart';

class ChildDashboardModel extends ChildDashboardEntity {
  ChildDashboardModel({
    required super.geofences,
    required super.restricted_zones,
  });

  factory ChildDashboardModel.fromJson(Map<String, dynamic> json) {
    return ChildDashboardModel(
      geofences: json['geofences'] ?? [],
      restricted_zones: json['restricted_zone'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'geofences': geofences,
      'restricted_zones': restricted_zones,
    };
  }
}
