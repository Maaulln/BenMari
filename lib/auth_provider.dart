import 'package:flutter/material.dart';

/// Authentication provider for managing login state and user data
class AuthProvider extends ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _user;
  String? _role;
  bool _isLoading = false;
  String? _error;

  // Getters
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  String? get role => _role;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null;

  /// Set authentication data after successful login
  void setAuthData({
    required String token,
    required Map<String, dynamic> user,
    required String role,
  }) {
    _token = token;
    _user = user;
    _role = role;
    _error = null;
    notifyListeners();
  }

  /// Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  /// Clear auth data on logout
  void logout() {
    _token = null;
    _user = null;
    _role = null;
    _error = null;
    notifyListeners();
  }

  /// Get user ID
  String? getUserId() {
    return _user?['id'] as String?;
  }

  /// Get user name
  String? getUserName() {
    return _user?['name'] as String?;
  }

  /// Get user email
  String? getUserEmail() {
    return _user?['email'] as String?;
  }

  /// Check if user is admin
  bool isAdmin() => _role == 'admin';

  /// Check if user is doctor
  bool isDoctor() => _role == 'dokter';

  /// Check if user is patient
  bool isPatient() => _role == 'pasien';
}
