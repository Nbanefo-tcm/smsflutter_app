import 'package:flutter/foundation.dart';
import '../../data/models/sms_message_model.dart';

class SmsProvider with ChangeNotifier {
  List<SmsMessageModel> _messages = [];
  List<SmsMessageModel> _filteredMessages = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedService;
  DateTime? _selectedDate;

  // Getters
  List<SmsMessageModel> get messages => _filteredMessages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedService => _selectedService;
  DateTime? get selectedDate => _selectedDate;
  int get unreadCount => _messages.where((msg) => !msg.isRead).length;
  int get totalMessages => _messages.length;

  // Available services for filtering
  List<String> get availableServices {
    final services = _messages
        .where((msg) => msg.service != null)
        .map((msg) => msg.service!)
        .toSet()
        .toList();
    services.sort();
    return services;
  }

  SmsProvider() {
    _loadDemoMessages();
  }

  // Load demo messages for development
  void _loadDemoMessages() {
    _messages = [
      SmsMessageModel(
        id: 1,
        rentalId: 101,
        sender: 'WhatsApp',
        message: 'Your WhatsApp code is 123456. Don\'t share this code with others.',
        receivedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
        service: 'WhatsApp',
      ),
      SmsMessageModel(
        id: 2,
        rentalId: 101,
        sender: 'Telegram',
        message: 'Telegram code: 789012\n\nYou can also tap on this link to log in:\nhttps://t.me/login/789012',
        receivedAt: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
        service: 'Telegram',
      ),
      SmsMessageModel(
        id: 3,
        rentalId: 102,
        sender: 'Google',
        message: 'G-345678 is your Google verification code.',
        receivedAt: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
        service: 'Google',
      ),
      SmsMessageModel(
        id: 4,
        rentalId: 101,
        sender: 'Instagram',
        message: 'Use 456789 to verify your Instagram account.',
        receivedAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: false,
        service: 'Instagram',
      ),
      SmsMessageModel(
        id: 5,
        rentalId: 103,
        sender: 'Facebook',
        message: 'Your Facebook confirmation code is 987654',
        receivedAt: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        service: 'Facebook',
      ),
      SmsMessageModel(
        id: 6,
        rentalId: 102,
        sender: 'Twitter',
        message: 'Your Twitter verification code is 111222.',
        receivedAt: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
        service: 'Twitter',
      ),
      SmsMessageModel(
        id: 7,
        rentalId: 101,
        sender: 'Discord',
        message: 'Your Discord verification code is 333444',
        receivedAt: DateTime.now().subtract(const Duration(days: 5)),
        isRead: false,
        service: 'Discord',
      ),
      SmsMessageModel(
        id: 8,
        rentalId: 104,
        sender: 'Unknown',
        message: 'Welcome! Your verification code is 555666. Please use it within 10 minutes.',
        receivedAt: DateTime.now().subtract(const Duration(days: 7)),
        isRead: true,
      ),
    ];
    _applyFilters();
  }

  // Load messages from API
  Future<void> loadMessages() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In real implementation, this would be:
      // final messages = await _apiClient.getMessages();
      // _messages = messages;
      
      _loadDemoMessages(); // Remove this when API is ready
    } catch (e) {
      _error = 'Failed to load messages: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh messages
  Future<void> refreshMessages() async {
    await loadMessages();
  }

  // Search messages
  void searchMessages(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Filter by service
  void filterByService(String? service) {
    _selectedService = service;
    _applyFilters();
    notifyListeners();
  }

  // Filter by date
  void filterByDate(DateTime? date) {
    _selectedDate = date;
    _applyFilters();
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedService = null;
    _selectedDate = null;
    _applyFilters();
    notifyListeners();
  }

  // Apply filters to messages
  void _applyFilters() {
    _filteredMessages = _messages.where((message) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!message.message.toLowerCase().contains(query) &&
            !message.sender.toLowerCase().contains(query) &&
            !(message.service?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }

      // Service filter
      if (_selectedService != null && message.service != _selectedService) {
        return false;
      }

      // Date filter (same day)
      if (_selectedDate != null) {
        final messageDate = DateTime(
          message.receivedAt.year,
          message.receivedAt.month,
          message.receivedAt.day,
        );
        final filterDate = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
        );
        if (!messageDate.isAtSameMomentAs(filterDate)) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort by received date (newest first)
    _filteredMessages.sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
  }

  // Mark message as read
  void markAsRead(int messageId) {
    final index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(isRead: true);
      _applyFilters();
      notifyListeners();
    }
  }

  // Mark all messages as read
  void markAllAsRead() {
    _messages = _messages.map((msg) => msg.copyWith(isRead: true)).toList();
    _applyFilters();
    notifyListeners();
  }

  // Delete message
  void deleteMessage(int messageId) {
    _messages.removeWhere((msg) => msg.id == messageId);
    _applyFilters();
    notifyListeners();
  }

  // Get message by ID
  SmsMessageModel? getMessageById(int id) {
    try {
      return _messages.firstWhere((msg) => msg.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get messages by rental ID
  List<SmsMessageModel> getMessagesByRentalId(int rentalId) {
    return _messages.where((msg) => msg.rentalId == rentalId).toList();
  }
}
