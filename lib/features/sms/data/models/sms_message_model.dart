import 'package:json_annotation/json_annotation.dart';

part 'sms_message_model.g.dart';

@JsonSerializable()
class SmsMessageModel {
  final int id;
  final int rentalId;
  final String sender;
  final String message;
  final DateTime receivedAt;
  final bool isRead;
  final String? service; // WhatsApp, Telegram, etc.

  SmsMessageModel({
    required this.id,
    required this.rentalId,
    required this.sender,
    required this.message,
    required this.receivedAt,
    required this.isRead,
    this.service,
  });

  factory SmsMessageModel.fromJson(Map<String, dynamic> json) => 
      _$SmsMessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$SmsMessageModelToJson(this);

  SmsMessageModel copyWith({
    int? id,
    int? rentalId,
    String? sender,
    String? message,
    DateTime? receivedAt,
    bool? isRead,
    String? service,
  }) {
    return SmsMessageModel(
      id: id ?? this.id,
      rentalId: rentalId ?? this.rentalId,
      sender: sender ?? this.sender,
      message: message ?? this.message,
      receivedAt: receivedAt ?? this.receivedAt,
      isRead: isRead ?? this.isRead,
      service: service ?? this.service,
    );
  }

  // Extract verification code from message
  String? get verificationCode {
    final regex = RegExp(r'\b\d{4,8}\b');
    final match = regex.firstMatch(message);
    return match?.group(0);
  }

  // Check if message contains verification code
  bool get hasVerificationCode => verificationCode != null;

  // Get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(receivedAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
