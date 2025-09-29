class AppConstants {
  // App Info
  static const String appName = 'MSMmax';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.msmmax.com';
  static const String apiVersion = 'v1';
  
  // WebSocket Configuration
  static const String wsUrl = 'wss://ws.msmmax.com';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String walletBalanceKey = 'wallet_balance';
  
  // SMS Configuration
  static const int smsRetentionHours = 72;
  static const int maxSmsPerNumber = 100;
  
  // Wallet Configuration
  static const double minTopUpAmount = 5.0;
  static const double maxTopUpAmount = 1000.0;
  
  // Number Rental Configuration
  static const int minRentalMinutes = 5;
  static const int maxRentalDays = 7;
  
  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const int animationDuration = 300;
}
