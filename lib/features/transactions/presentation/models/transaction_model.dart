import 'package:flutter/material.dart';

// Enum for transaction status
enum TransactionStatus {
  success,
  refunded,
  failed,
}

class Transaction {
  final String id;
  final String serviceName;
  final DateTime date;
  final double amount;
  final bool isCredit;
  final TransactionStatus status;

  Transaction({
    required this.id,
    required this.serviceName,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.status,
  });

  // Helper method to get status color
  Color getStatusColor() {
    switch (status) {
      case TransactionStatus.success:
        return Colors.green;
      case TransactionStatus.refunded:
        return Colors.orange;
      case TransactionStatus.failed:
        return Colors.red;
    }
  }

  // Helper method to get status text
  String getStatusText() {
    return status.toString().split('.').last;
  }
}
