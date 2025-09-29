import 'package:json_annotation/json_annotation.dart';

part 'virtual_number_model.g.dart';

@JsonSerializable()
class VirtualNumberModel {
  final int id;
  final String number;
  final String countryCode;
  final String countryName;
  final String provider;
  final String status;
  final double price;
  final DateTime? expiresAt;
  final DateTime createdAt;

  VirtualNumberModel({
    required this.id,
    required this.number,
    required this.countryCode,
    required this.countryName,
    required this.provider,
    required this.status,
    required this.price,
    this.expiresAt,
    required this.createdAt,
  });

  factory VirtualNumberModel.fromJson(Map<String, dynamic> json) => 
      _$VirtualNumberModelFromJson(json);
  Map<String, dynamic> toJson() => _$VirtualNumberModelToJson(this);

  bool get isAvailable => status == 'available';
  bool get isRented => status == 'rented';
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  
  String get formattedNumber {
    // Format number with country code
    return '+$countryCode $number';
  }
  
  String get flagEmoji {
    // Convert country code to flag emoji
    final codeUnits = countryCode.toUpperCase().codeUnits;
    return String.fromCharCodes(
      codeUnits.map((code) => 0x1F1E6 + (code - 0x41)),
    );
  }
}
