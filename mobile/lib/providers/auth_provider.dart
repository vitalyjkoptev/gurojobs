import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final SharedPreferences prefs;

  /// Bump this when shipping a release that should force-clear stale auth
  /// state on existing installs (e.g. when fixing an identity-leak bug).
  /// Stored installs with a lower value will go through _hardLogout once.
  static const int _authStorageVersion = 2;

  bool _isLoggedIn = false;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  String? _userName;
  String? _userEmail;
  String? _userRole;
  String? _errorMessage;

  AuthProvider(this.prefs) {
    _agreedToTerms = prefs.getBool('agreed_to_terms') ?? false;
    _bootstrap();
  }

  bool get isLoggedIn => _isLoggedIn;
  bool get agreedToTerms => _agreedToTerms;
  bool get isLoading => _isLoading;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userRole => _userRole;
  String? get errorMessage => _errorMessage;

  /// One-shot bootstrap on construction:
  ///   1. version-gated wipe if upgrading from a release that might have
  ///      leaked another user's session through Android auto-backup;
  ///   2. validate any surviving token against /me — drop it if rejected;
  ///   3. on success, force prefs to mirror server data so a stale
  ///      restored "user_name" can't outlive the actual session.
  Future<void> _bootstrap() async {
    final storedVersion = prefs.getInt('auth_storage_version') ?? 0;
    if (storedVersion < _authStorageVersion) {
      await _hardLogout(notify: false);
      await prefs.setInt('auth_storage_version', _authStorageVersion);
    }

    await _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await ApiService.getToken();
    if (token == null) {
      _isLoggedIn = false;
      _userName = _userEmail = _userRole = null;
      notifyListeners();
      return;
    }

    // Show cache immediately so the UI doesn't flicker through a logged-out
    // state on every cold start.
    _isLoggedIn = true;
    _userName = prefs.getString('user_name');
    _userEmail = prefs.getString('user_email');
    _userRole = prefs.getString('user_role');
    notifyListeners();

    // Then verify the token actually belongs to a current user. If the
    // server rejects it, wipe everything — cached prefs from a previous
    // identity must not be allowed to outlive their token.
    try {
      final me = await ApiService.getMe();
      final user = me['user'] as Map<String, dynamic>?;
      if (user == null) {
        await _hardLogout();
        return;
      }
      _userName = (user['name'] as String?) ?? _userName;
      _userEmail = (user['email'] as String?) ?? _userEmail;
      _userRole = (user['role'] as String?) ?? _userRole ?? 'candidate';
      await prefs.setString('user_name', _userName ?? '');
      await prefs.setString('user_email', _userEmail ?? '');
      await prefs.setString('user_role', _userRole ?? 'candidate');
      notifyListeners();
    } on UnauthorizedException {
      await _hardLogout();
    } catch (_) {
      // Network error — keep the cached identity, do not change login state.
    }
  }

  /// Pull-to-refresh / post-update hook: re-fetch /me and overwrite local
  /// prefs from the server. Safe to call from a Dashboard's RefreshIndicator.
  Future<void> refreshProfile() async {
    if (!_isLoggedIn) return;
    try {
      final me = await ApiService.getMe();
      final user = me['user'] as Map<String, dynamic>?;
      if (user == null) {
        await _hardLogout();
        return;
      }
      _userName = user['name'] as String?;
      _userEmail = user['email'] as String?;
      _userRole = (user['role'] as String?) ?? 'candidate';
      await prefs.setString('user_name', _userName ?? '');
      await prefs.setString('user_email', _userEmail ?? '');
      await prefs.setString('user_role', _userRole ?? 'candidate');
      notifyListeners();
    } on UnauthorizedException {
      await _hardLogout();
    } catch (_) {
      // ignore transient network errors
    }
  }

  /// Wipe every trace of the current identity — secure-storage token AND
  /// SharedPreferences mirrors. Used on 401, on bootstrap version bumps,
  /// and as the building block of public logout().
  Future<void> _hardLogout({bool notify = true}) async {
    await ApiService.clearToken();
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_role');
    _isLoggedIn = false;
    _userName = _userEmail = _userRole = null;
    if (notify) notifyListeners();
  }

  Future<void> acceptTerms() async {
    _agreedToTerms = true;
    await prefs.setBool('agreed_to_terms', true);
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
    String? phone,
    String? telegramUsername,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
        phone: phone,
        telegramUsername: telegramUsername,
      );

      if (response['token'] != null) {
        await ApiService.saveToken(response['token']);
        _userName = name;
        _userEmail = email;
        _userRole = role;
        await prefs.setString('user_name', name);
        await prefs.setString('user_email', email);
        await prefs.setString('user_role', role);
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Connection error. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.login(
        email: email,
        password: password,
      );

      if (response['token'] != null) {
        await ApiService.saveToken(response['token']);
        final user = response['user'];
        _userName = user?['name'] ?? email;
        _userEmail = email;
        _userRole = user?['role'] ?? 'candidate';
        await prefs.setString('user_name', _userName!);
        await prefs.setString('user_email', email);
        await prefs.setString('user_role', _userRole!);
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Invalid credentials';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Connection error. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.forgotPassword(email: email);
      _isLoading = false;
      if (response['success'] == true) {
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Error sending reset link';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Connection error. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await ApiService.logout();
    } catch (_) {}
    await _hardLogout();
  }
}
