import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/pricing.dart';

/// Manages daily contact reveal credits for employer
class ContactCreditsProvider extends ChangeNotifier {
  final SharedPreferences prefs;

  /// Current employer plan (trial, starter, pro, elite)
  String _plan = 'trial';

  /// How many contacts revealed today
  int _usedToday = 0;

  /// Date key for today (yyyy-MM-dd)
  String get _todayKey => DateTime.now().toIso8601String().substring(0, 10);

  /// Set of unlocked candidate IDs (persisted)
  final Set<String> _unlockedCandidates = {};

  ContactCreditsProvider(this.prefs) {
    _load();
  }

  void _load() {
    _plan = prefs.getString('employer_plan') ?? 'trial';

    // Check if saved date is today — if not, reset counter
    final savedDate = prefs.getString('credits_date') ?? '';
    if (savedDate == _todayKey) {
      _usedToday = prefs.getInt('credits_used') ?? 0;
    } else {
      // New day — reset
      _usedToday = 0;
      prefs.setString('credits_date', _todayKey);
      prefs.setInt('credits_used', 0);
    }

    // Load unlocked candidates
    final unlocked = prefs.getStringList('unlocked_candidates') ?? [];
    _unlockedCandidates.addAll(unlocked);
  }

  // === Getters ===

  String get plan => _plan;
  int get dailyLimit => ContactPricing.limitFor(_plan);
  int get usedToday => _usedToday;
  int get remaining => (dailyLimit - _usedToday).clamp(0, dailyLimit);
  bool get hasCredits => remaining > 0;
  String get planName => ContactPricing.planNames[_plan] ?? 'Trial';

  /// Check if a candidate's contacts are already unlocked
  bool isUnlocked(String candidateId) => _unlockedCandidates.contains(candidateId);

  // === Actions ===

  /// Reveal a candidate's contacts (costs 1 credit)
  bool revealContact(String candidateId) {
    if (_unlockedCandidates.contains(candidateId)) return true; // already unlocked

    // Check if date rolled over
    final savedDate = prefs.getString('credits_date') ?? '';
    if (savedDate != _todayKey) {
      _usedToday = 0;
      prefs.setString('credits_date', _todayKey);
      prefs.setInt('credits_used', 0);
    }

    if (_usedToday >= dailyLimit) return false; // no credits left

    _usedToday++;
    _unlockedCandidates.add(candidateId);

    prefs.setInt('credits_used', _usedToday);
    prefs.setStringList('unlocked_candidates', _unlockedCandidates.toList());

    notifyListeners();
    return true;
  }

  /// Set employer plan
  void setPlan(String plan) {
    _plan = plan;
    prefs.setString('employer_plan', plan);
    notifyListeners();
  }
}
