class NotifyModel {
  final String id;
  final String title;
  final String body;
  final String sentAt;
  final Sender sender;
  final String receiverId;

  NotifyModel({
    required this.id,
    required this.title,
    required this.body,
    required this.sentAt,
    required this.sender,
    required this.receiverId,
  });

  factory NotifyModel.fromJson(Map<String, dynamic> json) {
    String safeString(dynamic value) =>
        value is String ? value : value?.toString() ?? '';

    return NotifyModel(
      id: safeString(json['_id']),
      title: safeString(json['title']),
      body: safeString(json['body']),
      sentAt: safeString(json['sentAt']),
      sender: Sender.fromJson(json['senderId']),
      receiverId: safeString(json['recieverId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'body': body,
      'sentAt': sentAt,
      'senderId': sender.toJson(),
      'recieverId': receiverId,
    };
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
    String safeString(dynamic value) =>
        value is String ? value : value?.toString() ?? '';

    return Sender(
      id: safeString(json['_id']),
      name: safeString(json['name']),
      email: safeString(json['email']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }
}
