import '../../domain/entities/report_entity.dart';

class ReportModel extends ReportEntity {
  final String title;
  final String body;
  final String sentAt;
  final Sender sender;

  ReportModel({
    required String id,
    required String name,
    required List<String> locations,
    required this.title,
    required this.body,
    required this.sentAt,
    required this.sender,
  }) : super(
          id: id,
          name: name,
          locations: locations,
          title: title,
          body: body,
          sentAt: sentAt,
        );

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    final senderJson = json['senderId'] ?? {};
    final name = senderJson['name'] ?? '';
    final sentAt = json['sentAt'] ?? '';

    return ReportModel(
      id: json['_id'] ?? '',
      name: name,
      locations: [
        '$name | ${_formatSentAt(sentAt)}',
      ],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      sentAt: sentAt,
      sender: Sender.fromJson(senderJson),
    );
  }
  static String _formatSentAt(String sentAt) {
    try {
      final date = DateTime.parse(sentAt);
      return '${date.toLocal()}'; // Or use intl package to format nicely
    } catch (_) {
      return sentAt;
    }
  }

  @override
  String toString() {
    return 'ReportModel(name: $name, title: $title, body: $body, sentAt: $sentAt, locations: $locations)';
  }
}

class Sender {
  final String id;
  final String name;
  final String email;

  Sender({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
