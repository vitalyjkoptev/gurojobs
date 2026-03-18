import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Jarvis Voice Service for Mobile
/// Uses speech_to_text + flutter_tts packages
///
/// Add to pubspec.yaml:
///   speech_to_text: ^6.6.0
///   flutter_tts: ^4.0.2
class JarvisVoiceService extends ChangeNotifier {
  final String apiBaseUrl;
  final String authToken;

  // State
  bool isListening = false;
  bool isProcessing = false;
  bool isSpeaking = false;
  String status = 'idle'; // idle, listening, processing, speaking, error
  String lastTranscript = '';
  String lastResponse = '';
  List<Map<String, dynamic>> history = [];

  JarvisVoiceService({
    required this.apiBaseUrl,
    required this.authToken,
  });

  /// Process a text or voice command
  Future<Map<String, dynamic>> processCommand(String command, {String type = 'text'}) async {
    isProcessing = true;
    status = 'processing';
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/api/v1/jarvis/command'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'command': command,
          'type': type,
        }),
      );

      final data = jsonDecode(response.body);

      lastTranscript = command;
      lastResponse = data['response'] ?? 'Done.';

      history.insert(0, {
        'command': command,
        'response': lastResponse,
        'success': data['success'] ?? false,
        'timestamp': DateTime.now().toIso8601String(),
      });

      isProcessing = false;
      status = 'idle';
      notifyListeners();

      return data;
    } catch (e) {
      isProcessing = false;
      status = 'error';
      lastResponse = 'Connection error. Please try again.';
      notifyListeners();

      return {
        'success': false,
        'response': lastResponse,
      };
    }
  }

  /// Fetch command history from API
  Future<void> loadHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/api/v1/jarvis/history'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        history = List<Map<String, dynamic>>.from(data['data'] ?? []);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Jarvis: Failed to load history: $e');
    }
  }

  void clearHistory() {
    history.clear();
    notifyListeners();
  }
}
