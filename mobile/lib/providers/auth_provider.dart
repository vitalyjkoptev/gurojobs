import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final SharedPreferences prefs;

  bool _isLoggedIn = false;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  String? _userName;
  String? _userEmail;
  String? _userRole;
  String? _errorMessage;

  AuthProvider(this.prefs) {
    _agreedToTerms = prefs.getBool('agreed_to_terms') ?? false;
    _checkLoginStatus();
  }

  bool get isLoggedIn => _isLoggedIn;
  bool get agreedToTerms => _agreedToTerms;
  bool get isLoading => _isLoading;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userRole => _userRole;
  String? get errorMessage => _errorMessage;

  Future<void> _checkLoginStatus() async {
    final token = await ApiService.getToken();
    _isLoggedIn = token != null;
    if (_isLoggedIn) {
      _userName = prefs.getString('user_name');
      _userEmail = prefs.getString('user_email');
      _userRole = prefs.getString('user_role');
    }
    notifyListeners();
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
    // Filter fields
    String? commLangPriority,
    List<String>? commLangsAcceptable,
    String? citizenshipCountry,
    bool? inCitizenshipCountry,
    List<String>? blockedCompanyCountries,
    List<String>? mainOfficeCountries,
    List<String>? blockedCandidateCitizenships,
    String? candidateLocationPref,
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
        commLangPriority: commLangPriority,
        commLangsAcceptable: commLangsAcceptable,
        citizenshipCountry: citizenshipCountry,
        inCitizenshipCountry: inCitizenshipCountry,
        blockedCompanyCountries: blockedCompanyCountries,
        mainOfficeCountries: mainOfficeCountries,
        blockedCandidateCitizenships: blockedCandidateCitizenships,
        candidateLocationPref: candidateLocationPref,
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

  /// Demo accounts — always work offline, in browser, without server
  static const _demoAccounts = {
    'admin@gurojobs.com': {'password': 'Admin2026GJ', 'name': 'Admin', 'role': 'admin'},
    'employer@gurojobs.com': {'password': 'Employer2026GJ', 'name': 'Demo Employer', 'role': 'employer'},
    'candidate@gurojobs.com': {'password': 'Candidate2026GJ', 'name': 'Demo Candidate', 'role': 'candidate'},
  };

  Future<bool> _demoLogin(String email, String password) async {
    final demo = _demoAccounts[email.toLowerCase().trim()];
    if (demo != null && demo['password'] == password) {
      await ApiService.saveToken('demo_token_${demo['role']}');
      _userName = demo['name'];
      _userEmail = email;
      _userRole = demo['role'];
      await prefs.setString('user_name', _userName!);
      await prefs.setString('user_email', email);
      await prefs.setString('user_role', _userRole!);
      _isLoggedIn = true;
      return true;
    }
    return false;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // 1. Try real API
    try {
      final response = await ApiService.login(email: email, password: password);
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
      }
    } catch (_) {
      // Server unreachable — fall through to demo
    }

    // 2. Fallback: demo accounts (offline / no server)
    if (await _demoLogin(email, password)) {
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _errorMessage = 'Invalid email or password';
    _isLoading = false;
    notifyListeners();
    return false;
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
    _isLoggedIn = false;
    _userName = null;
    _userEmail = null;
    _userRole = null;
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_role');
    notifyListeners();
  }
}
