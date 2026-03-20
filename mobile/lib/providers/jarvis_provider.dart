import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/jarvis_voice.dart';
import '../core/localization.dart';
import '../services/api_service.dart';

enum JarvisStatus { idle, listening, processing, speaking, error }

class JarvisMessage {
  final String text;
  final bool isUser;
  final bool success;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  JarvisMessage({
    required this.text,
    required this.isUser,
    this.success = true,
    this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class JarvisProvider extends ChangeNotifier {
  final JarvisVoiceService _voice = JarvisVoiceService();

  JarvisStatus _status = JarvisStatus.idle;
  final List<JarvisMessage> _messages = [];
  String _partialText = '';
  bool _isOpen = false;
  bool _voiceAvailable = false;
  bool _initialized = false;

  JarvisStatus get status => _status;
  List<JarvisMessage> get messages => _messages;
  String get partialText => _partialText;
  bool get isOpen => _isOpen;
  bool get voiceAvailable => _voiceAvailable;
  bool get isListening => _status == JarvisStatus.listening;
  bool get isProcessing => _status == JarvisStatus.processing;

  /// Map app language to STT/TTS locale
  static String _langToLocale(String lang) {
    return switch (lang) {
      'ru' => 'ru-RU',
      'uk' => 'uk-UA',
      _ => 'en-US',
    };
  }

  /// Initialize voice engines — request permissions first
  Future<void> initialize({String? locale}) async {
    if (_initialized) return;

    // Request microphone + speech permissions
    final micStatus = await Permission.microphone.request();
    final speechStatus = await Permission.speech.request();
    debugPrint('Jarvis: mic=$micStatus, speech=$speechStatus');

    // No forced locale — STT uses device default, recognizes any language
    _voiceAvailable = await _voice.initialize();
    debugPrint('Jarvis: voiceAvailable=$_voiceAvailable');
    _initialized = true;
    notifyListeners();
  }

  /// Update voice locale when language changes
  Future<void> updateLocale(String lang) async {
    await _voice.setLocale(_langToLocale(lang));
  }

  /// Toggle panel open/close
  void togglePanel() {
    _isOpen = !_isOpen;
    notifyListeners();
  }

  void openPanel() {
    _isOpen = true;
    notifyListeners();
  }

  void closePanel() {
    _isOpen = false;
    if (_status == JarvisStatus.listening) {
      _voice.stopListening();
      _status = JarvisStatus.idle;
    }
    notifyListeners();
  }

  /// Start voice listening — uses device system locale automatically
  Future<void> startListening() async {
    if (!_voiceAvailable || _status == JarvisStatus.processing) return;

    _status = JarvisStatus.listening;
    _partialText = '';
    notifyListeners();

    // null locale = device system locale (auto-detect)
    // Backend IntentParser auto-detects RU/UK/EN from text
    await _voice.startListening(
      onResult: (text, isFinal) {
        _partialText = text;
        notifyListeners();

        if (isFinal && text.isNotEmpty) {
          _status = JarvisStatus.idle;
          notifyListeners();
          sendCommand(text, type: 'voice');
        }
      },
    );
  }

  /// Stop voice listening
  Future<void> stopListening() async {
    await _voice.stopListening();
    _status = JarvisStatus.idle;

    // If we have partial text, send it
    if (_partialText.isNotEmpty) {
      final text = _partialText;
      _partialText = '';
      notifyListeners();
      await sendCommand(text, type: 'voice');
    } else {
      notifyListeners();
    }
  }

  /// Send text or voice command to API
  Future<void> sendCommand(String command, {String type = 'text'}) async {
    if (command.trim().isEmpty) return;

    // Auto-adapt STT locale based on what user said
    _voice.adaptToRecognizedText(command);

    // Add user message
    _messages.insert(0, JarvisMessage(text: command, isUser: true));
    _status = JarvisStatus.processing;
    notifyListeners();

    try {
      final result = await ApiService.jarvisCommand(command, type: type);

      final response = result['response'] ?? 'Done.';
      final success = result['success'] ?? false;

      _messages.insert(0, JarvisMessage(
        text: response,
        isUser: false,
        success: success,
        data: result['data'] is Map<String, dynamic> ? result['data'] : null,
      ));

      _status = JarvisStatus.speaking;
      notifyListeners();

      // Speak the response
      await _voice.speak(response);

      _status = JarvisStatus.idle;
      notifyListeners();
    } catch (e) {
      _messages.insert(0, JarvisMessage(
        text: AppStrings.t('jarvis_connection_error'),
        isUser: false,
        success: false,
      ));
      _status = JarvisStatus.error;
      notifyListeners();

      // Reset to idle after a moment
      await Future.delayed(const Duration(seconds: 2));
      _status = JarvisStatus.idle;
      notifyListeners();
    }
  }

  /// Load history from API
  Future<void> loadHistory() async {
    try {
      final result = await ApiService.jarvisHistory();
      final data = result['data'];
      if (data is List) {
        for (final item in data) {
          _messages.add(JarvisMessage(
            text: item['response_text'] ?? '',
            isUser: false,
            success: item['success'] ?? false,
          ));
          _messages.add(JarvisMessage(
            text: item['command_text'] ?? '',
            isUser: true,
          ));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Jarvis: Failed to load history: $e');
    }
  }

  /// Clear chat
  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  /// Stop any ongoing speech
  Future<void> stopSpeaking() async {
    await _voice.stopSpeaking();
    if (_status == JarvisStatus.speaking) {
      _status = JarvisStatus.idle;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _voice.dispose();
    super.dispose();
  }
}
