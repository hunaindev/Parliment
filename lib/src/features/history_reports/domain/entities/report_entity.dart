class ReportEntity {
  final String id;
  final String name;
  final List<String> locations;
  final String title;
  final String body;
  final String sentAt;

  ReportEntity({
    required this.id,
    required this.name,
    required this.locations,
    required this.title,
    required this.body,
    required this.sentAt,
  });
}
