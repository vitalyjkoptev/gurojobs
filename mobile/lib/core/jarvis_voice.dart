import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

/// Jarvis Voice Service — STT + TTS wrapper
/// Автоматически определяет язык: говори на любом — Jarvis поймёт и ответит.
class JarvisVoiceService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool _isInitialized = false;
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _available = false;
  String _ttsLocale = 'en-US';
  String? _sttLocale; // null = use device default (multi-language)
  List<stt.LocaleName> _availableLocales = [];

  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  bool get isAvailable => _available;

  /// Initialize STT and TTS engines
  Future<bool> initialize({String? locale}) async {
    if (_isInitialized) return _available;

    try {
      _available = await _speech.initialize(
        onError: (error) {
          debugPrint('Jarvis STT error: ${error.errorMsg}');
          _isListening = false;
        },
        onStatus: (status) {
          debugPrint('Jarvis STT status: $status');
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
          }
        },
      );

      // Get all available STT locales
      _availableLocales = await _speech.locales();
      debugPrint('Jarvis STT: ${_availableLocales.length} locales available');

      // Don't force STT locale — null means device default (supports multi-lang)
      _sttLocale = null;

      // TTS setup
      _ttsLocale = locale ?? 'en-US';
      await _tts.setLanguage(_ttsLocale);
      await _tts.setSpeechRate(0.55);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);
      await _tts.setSharedInstance(true);

      // Set male voice
      await _setMaleVoice(_ttsLocale);

      _tts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _isInitialized = true;
      return _available;
    } catch (e) {
      debugPrint('Jarvis init error: $e');
      _available = false;
      return false;
    }
  }

  /// Find and set a male voice for the given locale
  Future<void> _setMaleVoice(String locale) async {
    try {
      final voices = await _tts.getVoices;
      if (voices == null) return;

      final langPrefix = locale.split('-').first.toLowerCase();

      // Filter voices matching locale
      final matching = (voices as List).where((v) {
        final vLocale = (v['locale'] ?? '').toString().toLowerCase().replaceAll('-', '_');
        return vLocale.startsWith(langPrefix);
      }).toList();

      if (matching.isEmpty) return;

      // Prefer male voice
      Map<String, dynamic>? maleVoice;
      for (final v in matching) {
        final name = (v['name'] ?? '').toString().toLowerCase();
        final gender = (v['gender'] ?? '').toString().toLowerCase();
        if (gender == 'male' || name.contains('male') || name.contains('yuri') ||
            name.contains('pavel') || name.contains('maxim') ||
            name.contains('dmitri') || name.contains('daniel') ||
            name.contains('alex') || name.contains('fred') ||
            name.contains('mykola')) {
          maleVoice = Map<String, dynamic>.from(v);
          break;
        }
      }

      // On iOS — use specific male voice identifiers
      if (Platform.isIOS) {
        for (final v in matching) {
          final name = (v['name'] ?? '').toString().toLowerCase();
          if (name.contains('daniel') || name.contains('yuri') ||
              name.contains('alex') || name.contains('fred') ||
              name.contains('mykola')) {
            maleVoice = Map<String, dynamic>.from(v);
            break;
          }
        }
      }

      final voice = maleVoice ?? matching.first;
      await _tts.setVoice({
        'name': voice['name'].toString(),
        'locale': voice['locale'].toString(),
      });
      debugPrint('Jarvis TTS voice: ${voice['name']}');
    } catch (e) {
      debugPrint('Jarvis TTS voice error: $e');
    }
  }

  /// Check if a STT locale is available on device
  bool _hasLocale(String localeId) {
    final prefix = localeId.split('-').first.toLowerCase();
    return _availableLocales.any((l) =>
        l.localeId.toLowerCase().startsWith(prefix));
  }

  /// Start listening — no forced locale, recognizes any language
  Future<void> startListening({
    required Function(String text, bool isFinal) onResult,
  }) async {
    if (!_available || _isListening) return;

    // Stop TTS if speaking
    if (_isSpeaking) await stopSpeaking();

    _isListening = true;
    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
        if (result.finalResult) {
          _isListening = false;
        }
      },
      // null = device default language (multi-language on most devices)
      localeId: _sttLocale,
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 2),
      listenOptions: stt.SpeechListenOptions(
        listenMode: stt.ListenMode.dictation,
        cancelOnError: false,
        partialResults: true,
        autoPunctuation: true,
      ),
    );
  }

  /// Stop listening
  Future<void> stopListening() async {
    if (!_isListening) return;
    _isListening = false;
    await _speech.stop();
  }

  /// Detect language from text (RU/UK/EN)
  static String detectLocaleFromText(String text) {
    if (RegExp(r'[іїєґІЇЄҐ]').hasMatch(text)) return 'uk-UA';
    if (RegExp(r'[а-яА-ЯёЁ]').hasMatch(text)) return 'ru-RU';
    return 'en-US';
  }

  /// After recognizing text, auto-switch STT locale for better accuracy next time
  void adaptToRecognizedText(String text) {
    final detected = detectLocaleFromText(text);
    if (_hasLocale(detected)) {
      _sttLocale = detected;
      debugPrint('Jarvis STT: adapted to $detected');
    }
  }

  /// Speak text using TTS — auto-detects language from text
  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    // Auto-detect language and switch TTS
    final detectedLocale = detectLocaleFromText(text);
    if (detectedLocale != _ttsLocale) {
      _ttsLocale = detectedLocale;
      await _tts.setLanguage(detectedLocale);
      await _setMaleVoice(detectedLocale);
      debugPrint('Jarvis TTS: switched to $detectedLocale');
    }

    _isSpeaking = true;
    await _tts.speak(text);
  }

  /// Stop speaking
  Future<void> stopSpeaking() async {
    _isSpeaking = false;
    await _tts.stop();
  }

  /// Set locale for both STT and TTS
  Future<void> setLocale(String locale) async {
    _sttLocale = locale;
    _ttsLocale = locale;
    await _tts.setLanguage(locale);
    await _setMaleVoice(locale);
  }

  /// Cleanup
  Future<void> dispose() async {
    await stopListening();
    await stopSpeaking();
  }
}
