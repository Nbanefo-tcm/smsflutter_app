import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/widgets/profile_avatar_button.dart';

class FundWalletScreen extends StatefulWidget {
  const FundWalletScreen({super.key});

  @override
  State<FundWalletScreen> createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends State<FundWalletScreen> {
  String selectedTab = 'Crypto';
  String selectedPaymentMethod = 'Paystack';
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'Paystack',
      'icon': FontAwesomeIcons.creditCard,
      'type': 'Card/Bank Transfer',
      'color': const Color(0xFF00B2FF),
    },
    {
      'name': 'Flutterwave',
      'icon': FontAwesomeIcons.moneyBillWave,
      'type': 'Card/Bank Transfer',
      'color': const Color(0xFFFF9A00),
    },
    {
      'name': 'Squad',
      'icon': FontAwesomeIcons.moneyCheckDollar,
      'type': 'Card/Bank Transfer',
      'color': const Color(0xFF6F42C1),
    },
    {
      'name': 'Cryptomus',
      'icon': FontAwesomeIcons.bitcoin,
      'type': 'Crypto',
      'color': const Color(0xFF00C853),
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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
          ProfileAvatarButton(size: 34),
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
              
              // Payment Method Selection
              Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: textTheme.titleMedium?.color,
                ),
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
                    isSelected: selectedPaymentMethod == method['name'],
                    onTap: () => _selectPaymentMethod(method['name']),
                  );
                },
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
              
              SizedBox(height: 12.h),
              
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: textTheme.bodyLarge?.color,
                ),
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: TextStyle(
                    color: theme.hintColor.withOpacity(0.5),
                  ),
                  prefix: Text(
                    '\$',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: textTheme.bodyLarge?.color,
                    ),
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Text(
                      'USD',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: theme.hintColor,
                      ),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 32.h),
              
              // Proceed to Payment Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _proceedToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Proceed to Payment',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // Note Section
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: colorScheme.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        selectedPaymentMethod == 'Cryptomus'
                            ? 'Please ensure that you send the exact amount in the selected cryptocurrency to the provided wallet address. The conversion rate is locked for 15 minutes.'
                            : 'You will be redirected to the selected payment gateway to complete your transaction securely.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: textTheme.bodyMedium?.color,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isSelected = selectedTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = title;
            // Reset selected payment method when changing tabs
            final availableMethods = paymentMethods.where((method) => 
              title == 'All' || 
              (title == 'Crypto' && method['type'] == 'Crypto') ||
              (title == 'Card' && method['type'] == 'Card/Bank Transfer')
            ).toList();
            
            if (!availableMethods.any((m) => m['name'] == selectedPaymentMethod)) {
              selectedPaymentMethod = availableMethods.isNotEmpty 
                  ? availableMethods.first['name'] 
                  : '';
            }
          });
        },
        child: Container(
          margin: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.sp,
                color: isSelected ? colorScheme.onPrimary : theme.hintColor,
              ),
              if (title != 'All') SizedBox(width: 4.w),
              if (title != 'All') Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : textTheme.bodyMedium?.color?.withOpacity(0.7),
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
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? color : Theme.of(context).dividerColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: color,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 14.sp,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _selectPaymentMethod(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });
  }

  void _proceedToPayment() {
    if (_formKey.currentState?.validate() ?? false) {
      if (selectedPaymentMethod == 'Cryptomus') {
        // Show crypto payment dialog
        _showCryptoPaymentDialog();
      } else {
        // For other payment methods, show processing dialog
        _showProcessingDialog();
      }
    }
  }

  void _showCryptoPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Pay with $selectedPaymentMethod',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send ${_amountController.text} USD worth of $selectedPaymentMethod to the following address:',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SelectableText(
                '3FZbgi29cpjq2GjdwV8eyHuJJnkLtktZc5',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Amount in $selectedPaymentMethod:',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              _calculateCryptoAmount(),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Text(
              'Scan QR Code:',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Icon(
                  Icons.qr_code,
                  size: 120.w,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Note: The conversion rate is locked for 15 minutes. Please complete the payment within this time.',
              style: TextStyle(
                fontSize: 10.sp,
                color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment address copied to clipboard'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
            child: Text('Copy Address', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  void _showProcessingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
            ),
            SizedBox(height: 16.h),
            Text(
              'Redirecting to $selectedPaymentMethod...',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        _showPaymentSuccessDialog();
      }
    });
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.primary,
          size: 48.sp,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Your wallet has been credited with \$${_amountController.text}',
              style: TextStyle(fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: Text('Done', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  String _calculateCryptoAmount() {
    // This is a mock calculation - in a real app, you would use current exchange rates
    final amount = double.tryParse(_amountController.text) ?? 0;
    double cryptoAmount = 0;
    
    switch (selectedPaymentMethod) {
      case 'Cryptomus':
        cryptoAmount = amount / 50000; // Example rate for Bitcoin
        return '$cryptoAmount BTC';
      default:
        return '\$$amount';
    }
  }
}
