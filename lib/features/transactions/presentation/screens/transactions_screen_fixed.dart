import 'package:flutter/material.dart';

// Enum for transaction status
enum TransactionStatus {
  success,
  refunded,
  failed,
}

// Class for transaction data
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

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final List<Transaction> _transactions = const [
    Transaction(
      id: 'TXN-12345',
      serviceName: 'Airtime Purchase',
      amount: '₦1,500',
      dateTime: 'Today, 2:30 PM',
      status: TransactionStatus.success,
      icon: Icons.phone_android,
    ),
    Transaction(
      id: 'TXN-12346',
      serviceName: 'Data Bundle',
      amount: '₦2,500',
      dateTime: 'Yesterday, 4:15 PM',
      status: TransactionStatus.success,
      icon: Icons.data_usage,
    ),
    Transaction(
      id: 'TXN-12347',
      serviceName: 'Electricity Bill',
      amount: '₦5,000',
      dateTime: 'Oct 5, 10:30 AM',
      status: TransactionStatus.failed,
      icon: Icons.bolt,
    ),
  ];

  final List<String> _selectedFilters = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  Future<void> _refreshTransactions() async {
    setState(() => _isLoading = true);
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Filter Transactions',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Status filter
            Text('Status', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: TransactionStatus.values.map((status) {
                final isSelected = _selectedFilters.contains(status.toString());
                return FilterChip(
                  label: Text(
                    status.toString().split('.').last.toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedFilters.add(status.toString());
                      } else {
                        _selectedFilters.remove(status.toString());
                      }
                    });
                  },
                  backgroundColor: Theme.of(context).brightness == Brightness.light 
                      ? Colors.grey[200] 
                      : Colors.grey[800],
                  selectedColor: Theme.of(context).primaryColor,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => _selectedFilters.clear());
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  List<Transaction> get _filteredTransactions {
    if (_selectedFilters.isEmpty) return _transactions;
    return _transactions.where((txn) => 
      _selectedFilters.contains(txn.status.toString())
    ).toList();
  }

  // These methods are now part of the Transaction class

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightMode = theme.brightness == Brightness.light;
    
    return Scaffold(
      backgroundColor: isLightMode ? Colors.white : theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Transactions',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isLightMode ? Colors.black87 : Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: isLightMode ? Colors.white : theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isLightMode ? Colors.black87 : Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 22),
            color: isLightMode ? Colors.black54 : Colors.white70,
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, size: 22),
            color: isLightMode ? Colors.black54 : Colors.white70,
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTransactions,
        color: theme.primaryColor,
        backgroundColor: theme.scaffoldBackgroundColor,
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
            : _transactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: theme.hintColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions yet',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTransactions.length,
                    itemBuilder: (context, index) {
                      return _buildTransactionItem(_filteredTransactions[index]);
                    },
                  ),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final theme = Theme.of(context);
    final isLightMode = theme.brightness == Brightness.light;
    final textColor = isLightMode ? Colors.grey[600] : Colors.grey[400];
    final statusColor = transaction.getStatusColor();
    final statusText = transaction.getStatusText();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetailsScreen(transaction: transaction),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(26), // Equivalent to 0.1 opacity
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  transaction.icon,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.serviceName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isLightMode ? Colors.black87 : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.dateTime,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction.amount,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isLightMode ? Colors.black87 : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(26), // Equivalent to 0.1 opacity
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionDetailsScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(context, 'Transaction ID', transaction.id),
            const SizedBox(height: 16),
            _buildDetailRow(context, 'Service', transaction.serviceName),
            const SizedBox(height: 8),
            _buildDetailRow(context, 'Amount', transaction.amount),
            const SizedBox(height: 8),
            _buildDetailRow(context, 'Date & Time', transaction.dateTime),
            const SizedBox(height: 8),
            _buildDetailRow(
              context,
              'Status',
              transaction.getStatusText(),
              valueColor: transaction.getStatusColor(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    final isLightMode = theme.brightness == Brightness.light;
    final textColor = isLightMode ? Colors.grey[600] : Colors.grey[400];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: valueColor ?? (isLightMode 
                  ? Colors.black87
                  : Colors.white),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

