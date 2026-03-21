import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import '../../../providers/lang_provider.dart';
import 'payment_flow_screen.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  int _selectedPlan = -1;
  String? _selectedPayMethod;
  Duration _trialRemaining = const Duration(hours: 72);
  Timer? _timer;
  bool _trialActive = true;

  @override
  void initState() {
    super.initState();
    _loadTrial();
  }

  Future<void> _loadTrial() async {
    final prefs = await SharedPreferences.getInstance();
    final startMs = prefs.getInt('trial_start');
    if (startMs == null) {
      await prefs.setInt('trial_start', DateTime.now().millisecondsSinceEpoch);
      _trialRemaining = const Duration(hours: 72);
    } else {
      final start = DateTime.fromMillisecondsSinceEpoch(startMs);
      final elapsed = DateTime.now().difference(start);
      final remaining = const Duration(hours: 72) - elapsed;
      if (remaining.isNegative) {
        _trialRemaining = Duration.zero;
        _trialActive = false;
      } else {
        _trialRemaining = remaining;
      }
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_trialRemaining.inSeconds > 0) {
        setState(() => _trialRemaining -= const Duration(seconds: 1));
      } else {
        setState(() => _trialActive = false);
        _timer?.cancel();
      }
    });
    if (mounted) setState(() {});
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LangProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t('billing_plans'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _trialBanner(),
            const SizedBox(height: 24),

            Text(AppStrings.t('choose_plan'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 6),
            Text(AppStrings.t('choose_plan_desc'), style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
            const SizedBox(height: 20),

            _planCard(
              index: 0,
              name: 'Basic',
              price: '\$10',
              period: AppStrings.t('per_month'),
              badge: '20 days free',
              features: [
                AppStrings.t('plan_basic_contacts'),
                AppStrings.t('plan_basic_desc'),
              ],
              color: GuroJobsTheme.info,
            ),
            _planCard(
              index: 1,
              name: 'Premium',
              price: '\$35',
              period: AppStrings.t('per_month'),
              badge: AppStrings.t('popular'),
              features: [
                AppStrings.t('plan_premium_contacts'),
                AppStrings.t('plan_premium_team'),
                AppStrings.t('plan_premium_linkedin'),
                AppStrings.t('plan_premium_desc'),
              ],
              color: GuroJobsTheme.primary,
            ),
            _planCard(
              index: 2,
              name: 'VIP',
              price: '\$65',
              period: AppStrings.t('per_month'),
              features: [
                AppStrings.t('plan_vip_contacts'),
                AppStrings.t('plan_vip_team'),
                AppStrings.t('plan_premium_linkedin'),
                AppStrings.t('plan_vip_bot'),
                AppStrings.t('plan_vip_desc'),
              ],
              color: GuroJobsTheme.accent,
            ),

            const SizedBox(height: 30),

            Text(AppStrings.t('payment_method'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 16),

            _payMethodTile('stripe', 'Stripe', Icons.credit_card, AppStrings.t('pay_stripe_desc'), const Color(0xFF635BFF)),
            _payMethodTile('paypal', 'PayPal', Icons.paypal_outlined, AppStrings.t('pay_paypal_desc'), const Color(0xFF003087)),
            _payMethodTile('revolut', 'Revolut', Icons.account_balance, AppStrings.t('pay_revolut_desc'), const Color(0xFF0075EB)),
            _payMethodTile('crypto', AppStrings.t('pay_crypto'), Icons.currency_bitcoin, AppStrings.t('pay_crypto_desc'), const Color(0xFFF7931A)),

            const SizedBox(height: 20),
            Text(AppStrings.t('payment_providers'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
            const SizedBox(height: 12),

            _payMethodTile('trustly', AppStrings.t('pay_trustly'), Icons.account_balance, AppStrings.t('pay_trustly_desc'), const Color(0xFF0EE06E)),
            _payMethodTile('skrill', AppStrings.t('pay_skrill'), Icons.wallet, AppStrings.t('pay_skrill_desc'), const Color(0xFF862165)),
            _payMethodTile('neteller', AppStrings.t('pay_neteller'), Icons.account_balance_wallet, AppStrings.t('pay_neteller_desc'), const Color(0xFF83C43F)),
            _payMethodTile('paysafecard', AppStrings.t('pay_paysafecard'), Icons.confirmation_number, AppStrings.t('pay_paysafecard_desc'), const Color(0xFF0072C6)),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton(
                onPressed: (_selectedPlan >= 0 && _selectedPayMethod != null) ? _subscribe : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: GuroJobsTheme.primary,
                  disabledBackgroundColor: context.dividerC,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  _selectedPlan >= 0 ? AppStrings.t('subscribe_now') : AppStrings.t('select_plan_continue'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${AppStrings.t('free_trial')} ${_formatDuration(_trialRemaining)} ${AppStrings.t('remaining')}'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.access_time, size: 18),
                label: Text('${AppStrings.t('remind_later')} (${_formatDuration(_trialRemaining)} ${AppStrings.t('left')})', style: TextStyle(color: context.textSecondaryC)),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _trialBanner() {
    final progress = _trialRemaining.inSeconds / (72 * 3600);
    final isUrgent = _trialRemaining.inHours < 12;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _trialActive
              ? (isUrgent ? [GuroJobsTheme.error, const Color(0xFFFF8A50)] : [GuroJobsTheme.primary, GuroJobsTheme.primaryLight])
              : [GuroJobsTheme.error, const Color(0xFFB71C1C)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: GuroJobsTheme.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(_trialActive ? Icons.hourglass_bottom : Icons.warning_amber, color: Colors.white, size: 36),
          const SizedBox(height: 10),
          Text(
            _trialActive ? AppStrings.t('trial_active') : AppStrings.t('trial_expired'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            _trialActive ? AppStrings.t('trial_remaining') : AppStrings.t('trial_upgrade'),
            style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.85)),
          ),
          if (_trialActive) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
              child: Text(
                _formatDuration(_trialRemaining),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'monospace', letterSpacing: 3),
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(isUrgent ? GuroJobsTheme.warning : Colors.white),
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _planCard({required int index, required String name, required String price, required String period, required List<String> features, required Color color, String? badge}) {
    final isSelected = _selectedPlan == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : context.dividerC, width: isSelected ? 2 : 1),
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))] : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(index == 0 ? Icons.rocket_launch : (index == 1 ? Icons.workspace_premium : Icons.diamond), color: color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                          if (badge != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
                              child: Text(badge, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                            ),
                          ],
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(price, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
                          Text(period, style: TextStyle(fontSize: 13, color: context.textHintC)),
                        ],
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? color : Colors.transparent,
                    border: Border.all(color: isSelected ? color : context.dividerC, width: 2),
                  ),
                  child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 16, color: color),
                  const SizedBox(width: 8),
                  Expanded(child: Text(f, style: TextStyle(fontSize: 13, color: context.textSecondaryC))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _payMethodTile(String id, String name, IconData icon, String desc, Color color) {
    final isSelected = _selectedPayMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayMethod = id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? color : context.dividerC, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                  Text(desc, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22, height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.transparent,
                border: Border.all(color: isSelected ? color : context.dividerC, width: 2),
              ),
              child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }

  void _subscribe() {
    const planKeys = ['basic', 'premium', 'vip'];
    const planNames = ['Basic', 'Premium', 'VIP'];
    const planPrices = ['\$10', '\$35', '\$65'];
    const planColors = [GuroJobsTheme.info, GuroJobsTheme.primary, GuroJobsTheme.accent];

    Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentFlowScreen(
      planKey: planKeys[_selectedPlan],
      planName: planNames[_selectedPlan],
      planPrice: planPrices[_selectedPlan],
      payMethod: _selectedPayMethod!,
      planColor: planColors[_selectedPlan],
    )));
  }
}
