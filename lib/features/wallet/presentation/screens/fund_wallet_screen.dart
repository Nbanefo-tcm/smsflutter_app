import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/profile_avatar_button.dart';

class FundWalletScreen extends StatefulWidget {
  const FundWalletScreen({super.key});

  @override
  State<FundWalletScreen> createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends State<FundWalletScreen> {
  String selectedTab = 'All';
  String selectedPaymentMethod = 'Paystack';
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'Paystack',
      'icon': FontAwesomeIcons.creditCard,
      'type': 'Card/Bank Transfer',
      'color': const Color(0xFF00B2FF),
      'fee': '1.4% + ₦50',
      'processingTime': 'Instant',
    },
    {
      'name': 'Flutterwave',
      'icon': FontAwesomeIcons.moneyBillWave,
      'type': 'Card/Bank Transfer',
      'color': const Color(0xFFFF9A00),
      'fee': '1.4% + ₦50',
      'processingTime': 'Instant',
    },
    {
      'name': 'Squad',
      'icon': FontAwesomeIcons.moneyCheckDollar,
      'type': 'Card/Bank Transfer',
      'color': const Color(0xFF6F42C1),
      'fee': '1.5%',
      'processingTime': '1-2 hours',
    },
    {
      'name': 'Cryptomus',
      'icon': FontAwesomeIcons.bitcoin,
      'type': 'Crypto',
      'color': const Color(0xFF00C853),
      'fee': '0.8%',
      'processingTime': '3-5 confirmations',
    },
  ];

  final List<Map<String, dynamic>> recentTransactions = [
    {
      'id': 'TX-001',
      'amount': 5000.00,
      'status': 'Completed',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'method': 'Paystack',
      'type': 'Credit',
    },
    {
      'id': 'TX-002',
      'amount': 2500.00,
      'status': 'Pending',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'method': 'Cryptomus',
      'type': 'Credit',
    },
    {
      'id': 'TX-003',
      'amount': 1000.00,
      'status': 'Failed',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'method': 'Flutterwave',
      'type': 'Credit',
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _selectPaymentMethod(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });
  }

  void _handleProceedToPay() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        _showPaymentSuccessDialog();
      });
    }
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: Text(
          'Your wallet has been credited with \$${_amountController.text} via $selectedPaymentMethod',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final filteredMethods = paymentMethods.where((method) {
      if (selectedTab == 'All') return true;
      if (selectedTab == 'Crypto') return method['type'] == 'Crypto';
      if (selectedTab == 'Card') return method['type'] == 'Card/Bank Transfer';
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Fund Wallet',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: textTheme.titleLarge?.color,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [
          ProfileAvatarButton(showBadge: true, iconColor: Colors.black, backgroundColor: Colors.white),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payment Tabs
              Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    _buildTabButton('All', Icons.payments_outlined),
                    _buildTabButton('Crypto', Icons.currency_bitcoin_rounded),
                    _buildTabButton('Card', Icons.credit_card_rounded),
                  ],
                ),
              ),
              
              SizedBox(height: 24.h),
              
              // Amount Input
              Text(
                'Enter Amount (USD)',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: textTheme.titleMedium?.color,
                ),
              ),
              
              SizedBox(height: 8.h),
              
              // Amount Input with Validation
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value) ?? 0;
                  if (amount <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  if (amount > 10000) {
                    return 'Maximum amount is \$10,000';
                  }
                  return null;
                },
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: textTheme.bodyLarge?.color,
                ),
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: TextStyle(
                    color: theme.hintColor.withOpacity(0.5),
                    fontSize: 18.sp,
                  ),
                  prefix: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Text(
                      '\$',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: theme.dividerColor,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: theme.dividerColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: colorScheme.error,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 18.h,
                  ),
                  suffixIcon: Container(
                    margin: EdgeInsets.all(8.w),
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        'USD',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  errorStyle: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.error,
                  ),
                ),
              ),
              
              SizedBox(height: 24.h),
              
              // Payment Method Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Payment Method',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: textTheme.titleMedium?.color,
                    ),
                  ),
                  Text(
                    '${filteredMethods.length} options',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12.h),
              
              // Payment Methods Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 2.5,
                ),
                itemCount: filteredMethods.length,
                itemBuilder: (context, index) {
                  final method = filteredMethods[index];
                  return _buildPaymentMethodCard(
                    context,
                    title: method['name'],
                    icon: method['icon'],
                    color: method['color'],
                    fee: method['fee'],
                    processingTime: method['processingTime'],
                    isSelected: selectedPaymentMethod == method['name'],
                    onTap: () => _selectPaymentMethod(method['name']),
                  );
                },
              ),
              
              SizedBox(height: 24.h),
              
              // Proceed to Pay Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleProceedToPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Proceed to Pay',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              SizedBox(height: 32.h),
              
              // Recent Transactions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: textTheme.titleMedium?.color,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to full transactions screen
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12.h),
              
              // Transactions List
              if (recentTransactions.isNotEmpty) ...[
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTransactions.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final transaction = recentTransactions[index];
                    return _buildTransactionItem(context, transaction);
                  },
                ),
              ] else ...[
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 48.sp,
                        color: theme.hintColor.withOpacity(0.5),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'No recent transactions',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, IconData icon) {
    final isSelected = selectedTab == label;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedTab = label),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.sp,
                color: isSelected ? Colors.white : Theme.of(context).hintColor,
              ),
              SizedBox(width: 4.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String fee,
    required String processingTime,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? color
                : theme.dividerColor,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Fee: $fee',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: theme.hintColor,
                    ),
                  ),
                  Text(
                    'Process: $processingTime',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    Map<String, dynamic> transaction,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCredit = transaction['type'] == 'Credit';
    final isCompleted = transaction['status'] == 'Completed';
    final isPending = transaction['status'] == 'Pending';
    
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isCredit
                  ? colorScheme.primary.withOpacity(0.1)
                  : colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: isCredit ? colorScheme.primary : colorScheme.error,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transaction['method']} • ${transaction['id']}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.hintColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  DateFormat('MMM d, y • h:mm a').format(transaction['date']),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: theme.hintColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : '-'}\$${transaction['amount'].toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isCredit ? colorScheme.primary : colorScheme.error,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withOpacity(0.1)
                      : isPending
                          ? Colors.orange.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  transaction['status'],
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: isCompleted
                        ? Colors.green
                        : isPending
                            ? Colors.orange
                            : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Extension to format date
final DateFormat _dateFormat = DateFormat('MMM d, y • h:mm a');

extension DateTimeExtension on DateTime {
  String get formatted => _dateFormat.format(this);
}
