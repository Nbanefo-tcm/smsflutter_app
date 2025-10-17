import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';

class TransactionsProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  
  List<Transaction> get transactions => _transactions;
  
  // Get the most recent transactions (sorted by date, newest first)
  List<Transaction> getRecentTransactions({int limit = 2}) {
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    return _transactions.take(limit).toList();
  }

  // Add a new transaction
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  // Initialize with sample data (you can remove this in production)
  void initializeWithSampleData() {
    _transactions = [
      Transaction(
        id: '1',
        serviceName: 'Funds Added',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        amount: 50.00,
        isCredit: true,
        status: TransactionStatus.success,
      ),
      Transaction(
        id: '2',
        serviceName: 'Number Rental',
        date: DateTime.now().subtract(const Duration(days: 1)),
        amount: 5.99,
        isCredit: false,
        status: TransactionStatus.success,
      ),
      // Add more sample transactions as needed
    ];
    notifyListeners();
  }
}
