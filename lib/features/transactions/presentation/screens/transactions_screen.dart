import 'package:flutter/material.dart';

// Define TransactionStatus enum at the top level
enum TransactionStatus {
  success,
  refunded,
  failed,
}

// Define Transaction class at the top level
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
}

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final ScrollController _scrollController = ScrollController();
  List<TransactionStatus> _selectedFilters = [];
  bool _isLoading = false;
  final String _searchQuery = '';

  // Get filtered transactions based on selected filters
  List<Transaction> get _filteredTransactions {
    if (_selectedFilters.isEmpty) return _transactions;
    return _transactions.where((transaction) => _selectedFilters.contains(transaction.status)).toList();
  }
  
  // Sample transaction data
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

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);
  }

  Future<void> _refreshTransactions() async {
    await _loadTransactions();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Filter Transactions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildFilterOption('Success', TransactionStatus.success),
          const SizedBox(height: 16),
          _buildFilterOption('Failed', TransactionStatus.failed),
          const SizedBox(height: 16),
          _buildFilterOption('Refunded', TransactionStatus.refunded),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _selectedFilters = []);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF333333)),
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
                    backgroundColor: const Color(0xFF00B876),
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
    );
  }

  Widget _buildFilterOption(String label, TransactionStatus status) {
    final isSelected = _selectedFilters.contains(status);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedFilters.remove(status);
            } else {
              _selectedFilters.add(status);
            }
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF00B876) : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF00B876) : Colors.grey[700]!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text('Transactions'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _TransactionSearchDelegate(_transactions),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTransactions,
        color: const Color(0xFF00B876),
        backgroundColor: const Color(0xFF1A1A1A),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF00B876)))
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
    final statusColor = _getStatusColor(transaction.status);
    final statusText = _getStatusText(transaction.status);
    
    return Card(
      color: const Color(0xFF1A1A1A),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[800]!,
          width: 1,
        ),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  transaction.icon,
                  color: statusColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.serviceName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.dateTime,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
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

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.success:
        return const Color(0xFF00B876);
      case TransactionStatus.refunded:
        return Colors.blue;
      case TransactionStatus.failed:
        return const Color(0xFFFF6B6B);
    }
  }

  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.success:
        return 'Success';
      case TransactionStatus.refunded:
        return 'Refunded';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }
}

class TransactionDetailsScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(transaction.status);
    final statusText = _getStatusText(transaction.status);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text('Transaction Details'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            // Transaction Summary Card
            Card(
              color: const Color(0xFF1A1A1A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: statusColor.withOpacity(0.1),
                      child: Icon(
                        transaction.icon,
                        size: 30,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      transaction.amount,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      transaction.serviceName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        statusText.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Transaction Details
            const Text(
              'Transaction Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Transaction ID', transaction.id),
            _buildDetailRow('Date & Time', transaction.dateTime),
            _buildDetailRow('Service', transaction.serviceName),
            _buildDetailRow('Amount', transaction.amount),
            _buildDetailRow(
              'Status',
              statusText,
              valueColor: statusColor,
            ),
            const SizedBox(height: 32),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Handle download receipt
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey[800]!),
                      ),
                    ),
                    icon: const Icon(Icons.receipt_long, color: Color(0xFF00B876)),
                    label: const Text('Download Receipt'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.success:
        return const Color(0xFF00B876);
      case TransactionStatus.refunded:
        return Colors.blue;
      case TransactionStatus.failed:
        return const Color(0xFFFF6B6B);
    }
  }
  
  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.success:
        return 'Success';
      case TransactionStatus.refunded:
        return 'Refunded';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }
}

class _TransactionSearchDelegate extends SearchDelegate<Transaction?> {
  final List<Transaction> transactions;

  _TransactionSearchDelegate(this.transactions);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = query.isEmpty
        ? transactions
        : transactions
            .where((txn) =>
                txn.serviceName.toLowerCase().contains(query.toLowerCase()) ||
                txn.amount.toLowerCase().contains(query.toLowerCase()) ||
                txn.id.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final txn = results[index];
        final statusColor = _getStatusColor(txn.status);
        
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: statusColor.withOpacity(0.1),
            child: Icon(txn.icon, color: statusColor),
          ),
          title: Text(txn.serviceName, style: const TextStyle(color: Colors.white)),
          subtitle: Text(txn.amount, style: TextStyle(color: Colors.grey[400])),
          trailing: Text(
            _getStatusText(txn.status),
            style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
          ),
          onTap: () {
            close(context, txn);
          },
        );
      },
    );
  }
  
  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.success:
        return const Color(0xFF00B876);
      case TransactionStatus.refunded:
        return Colors.blue;
      case TransactionStatus.failed:
        return const Color(0xFFFF6B6B);
    }
  }
  
  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.success:
        return 'Success';
      case TransactionStatus.refunded:
        return 'Refunded';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }
}
