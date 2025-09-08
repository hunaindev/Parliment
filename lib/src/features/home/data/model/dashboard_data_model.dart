import 'package:parliament_app/src/features/home/data/model/children_model.dart';
import 'package:parliament_app/src/features/home/data/model/notification_model.dart';

class DashboardDataModel {
  final List<ChildrenModel> children;
  final List<NotifyModel> notifications; // you can strongly type it later
  final List<dynamic> geofences;
  final List<dynamic> redzone;

  DashboardDataModel(
      {required this.children,
      required this.notifications,
      required this.geofences,
      required this.redzone});

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      children: (json['children'] as List)
          .map((e) => ChildrenModel.fromJson(e))
          .toList(),
      geofences: (json['geofences'] as List),
      redzone: (json['restrictedZones'] as List),
      notifications: (json['notifications'] as List)
          .map((e) => NotifyModel.fromJson(e))
          .toList(),
    );
  }
}
