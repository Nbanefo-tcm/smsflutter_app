import 'package:flutter/material.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightMode = theme.brightness == Brightness.light;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: isLightMode ? Colors.white : const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: Text(
          'Transaction Details',
          style: TextStyle(
            color: isLightMode ? Colors.black87 : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: isLightMode ? Colors.white : Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isLightMode ? Colors.black87 : Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Amount
            Center(
              child: Column(
                children: [
                  Text(
                    transaction['amount'],
                    style: textTheme.headlineMedium?.copyWith(
                      color: _getStatusColor(transaction['status']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusChip(transaction['status'].toString().split('.').last),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Transaction Details Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isLightMode ? Colors.grey[100] : const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow(context, 'Service', transaction['serviceName']),
                  Divider(
                    color: isLightMode ? Colors.grey[300] : const Color(0xFF333333),
                    height: 32,
                    thickness: 1,
                  ),
                  _buildDetailRow(context, 'Transaction ID', transaction['id']),
                  Divider(
                    color: isLightMode ? Colors.grey[300] : const Color(0xFF333333),
                    height: 32,
                    thickness: 1,
                  ),
                  _buildDetailRow(context, 'Date & Time', transaction['dateTime']),
                  Divider(
                    color: isLightMode ? Colors.grey[300] : const Color(0xFF333333),
                    height: 32,
                    thickness: 1,
                  ),
                  _buildDetailRow(
                    context,
                    'Status',
                    transaction['status'].toString().split('.').last,
                    valueColor: _getStatusColor(transaction['status']),
                  ),
                  Divider(
                    color: isLightMode ? Colors.grey[300] : const Color(0xFF333333),
                    height: 32,
                    thickness: 1,
                  ),
                  _buildDetailRow(context, 'Reference', transaction['reference'] ?? 'N/A'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            if (transaction['status'] == TransactionStatus.failed)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement retry payment
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Retry Payment'),
                ),
              ),
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: Implement share receipt
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: isLightMode ? Colors.black87 : Colors.white,
                  side: BorderSide(
                    color: isLightMode ? Colors.grey[300]! : const Color(0xFF333333),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Share Receipt'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {Color? valueColor}) {
    final theme = Theme.of(context);
    final isLightMode = theme.brightness == Brightness.light;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isLightMode ? Colors.grey[600] : Colors.grey[400],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? (isLightMode ? Colors.black87 : Colors.white),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final statusColor = _getStatusColor(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(dynamic status) {
    final statusStr = status.toString().split('.').last.toLowerCase();
    switch (statusStr) {
      case 'success':
        return Colors.green;
      case 'refunded':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

enum TransactionStatus {
  success,
  refunded,
  failed,
}
