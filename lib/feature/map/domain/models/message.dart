enum MessageStatus { sending, sent, delivered, read, failed }

class Message {
  final String id;
  final String text;
  final bool isFromUser;
  final DateTime timestamp;
  final MessageStatus status;
  final String? attachmentUrl;
  final String? attachmentType;

  Message({
    required this.id,
    required this.text,
    required this.isFromUser,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.attachmentUrl,
    this.attachmentType,
  });

  Message copyWith({
    String? id,
    String? text,
    bool? isFromUser,
    DateTime? timestamp,
    MessageStatus? status,
    String? attachmentUrl,
    String? attachmentType,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      isFromUser: isFromUser ?? this.isFromUser,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      attachmentType: attachmentType ?? this.attachmentType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isFromUser': isFromUser,
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString(),
      'attachmentUrl': attachmentUrl,
      'attachmentType': attachmentType,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      text: json['text'],
      isFromUser: json['isFromUser'],
      timestamp: DateTime.parse(json['timestamp']),
      status: MessageStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      attachmentUrl: json['attachmentUrl'],
      attachmentType: json['attachmentType'],
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, text: $text, isFromUser: $isFromUser, timestamp: $timestamp, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}