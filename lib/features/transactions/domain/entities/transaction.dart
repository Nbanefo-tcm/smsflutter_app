import 'package:flutter/material.dart';

enum TransactionStatus {
  success,
  refunded,
  failed,
}

class Transaction {
  final String id;
  final String serviceName;
  final String dateTime;
  final String amount;
  final TransactionStatus status;
  final IconData icon;
  final String? reference;

  const Transaction({
    required this.id,
    required this.serviceName,
    required this.dateTime,
    required this.amount,
    required this.status,
    required this.icon,
    this.reference,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'dateTime': dateTime,
      'amount': amount,
      'status': status.toString(),
      'reference': reference,
    };
  }

  // Create from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      dateTime: json['dateTime'] ?? '',
      amount: json['amount'] ?? '',
      status: _statusFromString(json['status'] ?? ''),
      icon: _getIconForStatus(_statusFromString(json['status'] ?? '')),
      reference: json['reference'],
    );
  }

  static TransactionStatus _statusFromString(String status) {
    switch (status) {
      case 'TransactionStatus.refunded':
        return TransactionStatus.refunded;
      case 'TransactionStatus.failed':
        return TransactionStatus.failed;
      case 'TransactionStatus.success':
      default:
        return TransactionStatus.success;
    }
  }

  static IconData _getIconForStatus(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.success:
        return Icons.check_circle_outline;
      case TransactionStatus.refunded:
        return Icons.refresh;
      case TransactionStatus.failed:
        return Icons.error_outline;
    }
  }
}
