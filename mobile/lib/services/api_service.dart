import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  /// Always production for web & release, local only for mobile debug
  static final String baseUrl = 'https://gurojobs.com/api/v1';
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }

  /// Headers for GET requests and token-authenticated requests
  static Map<String, String> _headers({String? token, bool isForm = false}) {
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    if (isForm) {
      headers['Content-Type'] = 'application/x-www-form-urlencoded';
    }
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// POST with form-encoded body (server parses this reliably)
  static Future<http.Response> _postForm(
    String url,
    Map<String, String> fields, {
    String? token,
  }) {
    return http.post(
      Uri.parse(url),
      headers: _headers(token: token, isForm: true),
      body: fields,
    ).timeout(const Duration(seconds: 8));
  }

  /// PUT with form-encoded body
  static Future<http.Response> _putForm(
    String url,
    Map<String, String> fields, {
    String? token,
  }) {
    // Laravel needs _method=PUT for form-encoded
    fields['_method'] = 'PUT';
    return http.post(
      Uri.parse(url),
      headers: _headers(token: token, isForm: true),
      body: fields,
    );
  }

  // ── Auth ──────────────────────────────────────────────
  static Future<Map<String, dynamic>> register({
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
    final fields = <String, String>{
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'role': role,
    };
    if (phone != null && phone.isNotEmpty) fields['phone'] = phone;
    if (telegramUsername != null && telegramUsername.isNotEmpty) {
      fields['telegram_username'] = telegramUsername;
    }
    // Filter fields — form-encoded arrays
    if (commLangPriority != null && commLangPriority.isNotEmpty) {
      fields['communication_language_priority'] = commLangPriority;
    }
    if (commLangsAcceptable != null && commLangsAcceptable.isNotEmpty) {
      for (int i = 0; i < commLangsAcceptable.length; i++) {
        fields['communication_languages_acceptable[$i]'] = commLangsAcceptable[i];
      }
    }
    if (citizenshipCountry != null && citizenshipCountry.isNotEmpty) {
      fields['citizenship_country'] = citizenshipCountry;
    }
    if (inCitizenshipCountry != null) {
      fields['in_citizenship_country'] = inCitizenshipCountry ? '1' : '0';
    }
    if (blockedCompanyCountries != null && blockedCompanyCountries.isNotEmpty) {
      for (int i = 0; i < blockedCompanyCountries.length; i++) {
        fields['blocked_company_countries[$i]'] = blockedCompanyCountries[i];
      }
    }
    if (mainOfficeCountries != null && mainOfficeCountries.isNotEmpty) {
      for (int i = 0; i < mainOfficeCountries.length; i++) {
        fields['main_office_countries[$i]'] = mainOfficeCountries[i];
      }
    }
    if (blockedCandidateCitizenships != null && blockedCandidateCitizenships.isNotEmpty) {
      for (int i = 0; i < blockedCandidateCitizenships.length; i++) {
        fields['blocked_candidate_citizenships[$i]'] = blockedCandidateCitizenships[i];
      }
    }
    if (candidateLocationPref != null && candidateLocationPref.isNotEmpty) {
      fields['candidate_location_pref'] = candidateLocationPref;
    }

    final response = await _postForm('$baseUrl/register', fields);
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _postForm('$baseUrl/login', {
      'email': email,
      'password': password,
    });
    try {
      return jsonDecode(response.body);
    } catch (_) {
      // Server returned non-JSON (HTML error page, 502, etc.)
      throw Exception('Non-JSON response: ${response.statusCode}');
    }
  }

  static Future<void> logout() async {
    final token = await getToken();
    await _postForm('$baseUrl/logout', {}, token: token);
    await clearToken();
  }

  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final response = await _postForm('$baseUrl/forgot-password', {
      'email': email,
    });
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getMe() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: _headers(token: token),
    );
    return jsonDecode(response.body);
  }

  // ── Employer Company ─────────────────────────────────
  static Future<Map<String, dynamic>> getEmployerCompany() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/employer/company'),
      headers: _headers(token: token),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateEmployerCompany(Map<String, dynamic> data) async {
    final token = await getToken();
    final fields = data.map((k, v) => MapEntry(k, v?.toString() ?? ''));
    final response = await _putForm(
      '$baseUrl/employer/company',
      fields,
      token: token,
    );
    return jsonDecode(response.body);
  }

  // ── Profile ─────────────────────────────────────────
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/candidate/profile'),
      headers: _headers(token: token),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final token = await getToken();
    final fields = data.map((k, v) => MapEntry(k, v?.toString() ?? ''));
    final response = await _putForm(
      '$baseUrl/candidate/profile',
      fields,
      token: token,
    );
    return jsonDecode(response.body);
  }

  // ── Jobs ────────────────────────────────────────────
  static Future<Map<String, dynamic>> getJobs({int page = 1, String? query, String? filter}) async {
    final token = await getToken();
    var url = '$baseUrl/jobs?page=$page';
    if (query != null && query.isNotEmpty) url += '&q=$query';
    if (filter != null && filter.isNotEmpty) url += '&filter=$filter';
    final response = await http.get(
      Uri.parse(url),
      headers: _headers(token: token),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getJobDetail(String slug) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/$slug'),
      headers: _headers(token: token),
    );
    return jsonDecode(response.body);
  }

  // ── Applications ────────────────────────────────────
  static Future<Map<String, dynamic>> applyForJob(int jobId) async {
    final token = await getToken();
    final response = await _postForm(
      '$baseUrl/candidate/apply/$jobId',
      {},
      token: token,
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getApplications() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/candidate/applications'),
      headers: _headers(token: token),
    );
    return jsonDecode(response.body);
  }

  // ── Categories ──────────────────────────────────────
  static Future<Map<String, dynamic>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/categories'),
      headers: _headers(),
    );
    return jsonDecode(response.body);
  }

  // ── Resume ─────────────────────────────────────────
  static Future<Map<String, dynamic>> getResume() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/candidate/resume'),
      headers: _headers(token: token),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateResume(Map<String, dynamic> data) async {
    final token = await getToken();
    final fields = <String, String>{'_method': 'PUT'};
    data.forEach((k, v) {
      if (v is List) {
        for (int i = 0; i < v.length; i++) {
          if (v[i] is Map) {
            (v[i] as Map).forEach((mk, mv) {
              fields['$k[$i][$mk]'] = mv?.toString() ?? '';
            });
          } else {
            fields['$k[$i]'] = v[i].toString();
          }
        }
      } else if (v is Map) {
        v.forEach((mk, mv) => fields['$k[$mk]'] = mv?.toString() ?? '');
      } else {
        fields[k] = v?.toString() ?? '';
      }
    });
    final response = await http.post(
      Uri.parse('$baseUrl/candidate/resume'),
      headers: _headers(token: token, isForm: true),
      body: fields,
    );
    return jsonDecode(response.body);
  }

  static String getResumePdfUrl() => '$baseUrl/candidate/resume/pdf';
  static String getResumePreviewUrl() => '$baseUrl/candidate/resume/preview';

  // ── Application Notes ──────────────────────────────
  static Future<Map<String, dynamic>> updateApplicationNotes(int appId, String notes) async {
    final token = await getToken();
    final response = await _putForm(
      '$baseUrl/candidate/applications/$appId/notes',
      {'candidate_notes': notes},
      token: token,
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteApplicationNotes(int appId) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/candidate/applications/$appId/notes'),
      headers: _headers(token: token),
    );
    return jsonDecode(response.body);
  }

  // ── Messages ───────────────────────────────────────
  static Future<Map<String, dynamic>> getConversations() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/messages/conversations'),
      headers: _headers(token: token),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getThread(int userId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/messages/$userId'),
      headers: _headers(token: token),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> sendMessage(int receiverId, String body) async {
    final token = await getToken();
    final response = await _postForm(
      '$baseUrl/messages',
      {'receiver_id': receiverId.toString(), 'body': body},
      token: token,
    );
    return jsonDecode(response.body);
  }

  // ── Reports ────────────────────────────────────────
  static Future<Map<String, dynamic>> submitReport({
    required String type,
    required int id,
    required String reason,
    String? description,
  }) async {
    final token = await getToken();
    final fields = <String, String>{
      'reportable_type': type,
      'reportable_id': id.toString(),
      'reason': reason,
    };
    if (description != null) fields['description'] = description;
    final response = await _postForm('$baseUrl/reports', fields, token: token);
    return jsonDecode(response.body);
  }

  // ── Paywall ────────────────────────────────────────
  static Future<Map<String, dynamic>> getPaywallStatus() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/paywall/status'),
      headers: _headers(token: token),
    );
    return jsonDecode(response.body);
  }

  // ── Employer/Candidate Public Profiles ─────────────
  static Future<Map<String, dynamic>> getEmployerProfile(int id) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/employers/$id'),
      headers: _headers(token: token),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getCandidatePublicProfile(int id) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/candidates/$id'),
      headers: _headers(token: token),
    );
    return jsonDecode(response.body);
  }

  // ── Jarvis AI ───────────────────────────────────────
  static Future<Map<String, dynamic>> jarvisCommand(String command, {String type = 'text'}) async {
    final token = await getToken();
    final response = await _postForm(
      '$baseUrl/jarvis/command',
      {'command': command, 'type': type},
      token: token,
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> jarvisHistory({int limit = 50}) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/jarvis/history?limit=$limit'),
      headers: _headers(token: token),
    );
    return jsonDecode(response.body);
  }
}
