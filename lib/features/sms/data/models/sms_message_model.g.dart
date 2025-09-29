// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmsMessageModel _$SmsMessageModelFromJson(Map<String, dynamic> json) =>
    SmsMessageModel(
      id: (json['id'] as num).toInt(),
      rentalId: (json['rentalId'] as num).toInt(),
      sender: json['sender'] as String,
      message: json['message'] as String,
      receivedAt: DateTime.parse(json['receivedAt'] as String),
      isRead: json['isRead'] as bool,
      service: json['service'] as String?,
    );

Map<String, dynamic> _$SmsMessageModelToJson(SmsMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rentalId': instance.rentalId,
      'sender': instance.sender,
      'message': instance.message,
      'receivedAt': instance.receivedAt.toIso8601String(),
      'isRead': instance.isRead,
      'service': instance.service,
    };
