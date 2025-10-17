import 'package:flutter/material.dart';

enum TransactionStatus {
  success,
  refunded,
  failed,
}

class Transaction {
  final String id;
  final String serviceName;
  final String amount;
  final String dateTime;
  final TransactionStatus status;
  final IconData icon;

  const Transaction({
    required this.id,
    required this.serviceName,
    required this.amount,
    required this.dateTime,
    required this.status,
    required this.icon,
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
