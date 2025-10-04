import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/user_model.dart';

// Extension to handle color opacity without deprecation warning
extension ColorExtension on Color {
  Color withValues({double? opacity}) {
    return withOpacity(opacity ?? this.opacity);
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class AuthProvider with ChangeNotifier {
  static const String _tokenKey = 'auth_token';
  
  UserModel? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;
  String? _token;
  final StreamController<bool> _authStateController = StreamController<bool>.broadcast();

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;
  String? get token => _token;
  Stream<bool> get authStateChanges => _authStateController.stream;

  final ApiClient _apiClient;
  
  AuthProvider({required ApiClient apiClient}) : _apiClient = apiClient {
    _init();
  }

  Future<void> _init() async {
    await _loadToken();
    if (_token != null) {
      await _loadUser();
    }
  }

  Future<void> _loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString(_tokenKey);
      _isAuthenticated = _token != null;
      _authStateController.add(_isAuthenticated);
    } catch (e) {
      debugPrint('Error loading token: $e');
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      _token = token;
      _isAuthenticated = true;
      _authStateController.add(true);
    } catch (e) {
      debugPrint('Error saving token: $e');
      rethrow;
    }
  }

  Future<void> _clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      _token = null;
      _isAuthenticated = false;
      _authStateController.add(false);
    } catch (e) {
      debugPrint('Error clearing token: $e');
      rethrow;
    }
  }

  // Load user data using the stored token
  Future<void> _loadUser() async {
    if (_token == null) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call to get user data
      // final userData = await _apiClient.get('/user/me');
      // _user = UserModel.fromJson(userData);
      
      // Simulated user data for demo
      _user = UserModel(
        id: 1,
        email: 'user@example.com',
        name: 'Demo User',
        walletBalance: 100.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      _isAuthenticated = true;
      _authStateController.add(true);
    } catch (e) {
      debugPrint('Error loading user: $e');
      await logout();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login with email and password
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw AuthException('Email and password are required');
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // TODO: Replace with actual API call
      /*
      final response = await _apiClient.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      
      final token = response['token'];
      await _saveToken(token);
      await _loadUser();
      */
      
      // Simulated successful login for demo
      await _saveToken('demo_token_${DateTime.now().millisecondsSinceEpoch}');
      await _loadUser();
      
    } catch (e) {
      _error = e.toString();
      await _clearToken();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register a new user
  Future<void> register(String email, String password, String name) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      throw AuthException('All fields are required');
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // TODO: Replace with actual API call
      // Uncomment and use this when API is ready
      /*
      final response = await _apiClient.dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'name': name,
      });

      if (response.statusCode == 201) {
        final data = response.data;
        final token = data['token'];
        final userData = data['user'];

        await _apiClient.setAuthToken(token);
        _user = UserModel.fromJson(userData);
        _isAuthenticated = true;
        _authStateController.add(true);
      } else {
        throw AuthException('Registration failed');
      }
      */
      
      // Simulated successful registration for demo
      await Future.delayed(const Duration(seconds: 1));
      await _saveToken('demo_token_${DateTime.now().millisecondsSinceEpoch}');
      await _loadUser();
      
    } catch (e) {
      _error = e.toString();
      await _clearToken();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout the current user
  Future<void> logout() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      try {
        // Try to invalidate the token if possible
        await _apiClient.dio.post('/auth/logout');
      } catch (e) {
        debugPrint('Warning: Could not invalidate token on server: $e');
        // Continue with local logout even if server logout fails
      }
      
      // Clear local auth state
      await _clearToken();
      _user = null;
      _isAuthenticated = false;
      _authStateController.add(false);
      
    } catch (e) {
      _error = e.toString();
      debugPrint('Error during logout: $_error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Update user data
  Future<void> updateUser(UserModel user) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // TODO: Replace with actual API call
      /*
      final response = await _apiClient.put(
        '/user/me',
        data: user.toJson(),
      );
      
      _user = UserModel.fromJson(response.data);
      */
      
      // Simulated update for demo
      _user = user;
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update wallet balance
  Future<void> updateWalletBalance(double balance) async {
    if (_user == null) return;
    
    try {
      _isLoading = true;
      notifyListeners();
      
      // TODO: Replace with actual API call
      /*
      final response = await _apiClient.put(
        '/user/wallet/balance',
        data: {'balance': balance},
      );
      
      _user = _user!.copyWith(walletBalance: response.data['balance']);
      */
      
      // Simulated update for demo
      _user = _user!.copyWith(walletBalance: balance);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating wallet balance: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authStateController.close();
    super.dispose();
  }
}
