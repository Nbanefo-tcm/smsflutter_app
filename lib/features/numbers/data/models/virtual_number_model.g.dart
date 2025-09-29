// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'virtual_number_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VirtualNumberModel _$VirtualNumberModelFromJson(Map<String, dynamic> json) =>
    VirtualNumberModel(
      id: (json['id'] as num).toInt(),
      number: json['number'] as String,
      countryCode: json['countryCode'] as String,
      countryName: json['countryName'] as String,
      provider: json['provider'] as String,
      status: json['status'] as String,
      price: (json['price'] as num).toDouble(),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$VirtualNumberModelToJson(VirtualNumberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'countryCode': instance.countryCode,
      'countryName': instance.countryName,
      'provider': instance.provider,
      'status': instance.status,
      'price': instance.price,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
