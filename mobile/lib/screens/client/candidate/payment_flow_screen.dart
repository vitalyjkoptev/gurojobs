import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import '../../../core/pricing.dart';
import '../../../providers/contact_credits_provider.dart';
import '../../../providers/lang_provider.dart';

/// Full payment flow:
/// 1. PaymentConfirmScreen — order summary, confirm
/// 2. PaymentInputScreen — enter payment details (depends on method)
/// 3. PaymentProcessingScreen — animated processing
/// 4. PaymentSuccessScreen — success + plan description

// ═══════════════════════════════════════════════════════════════
// ENTRY POINT — called from billing_screen
// ═══════════════════════════════════════════════════════════════

class PaymentFlowScreen extends StatelessWidget {
  final String planKey;   // basic, premium, vip
  final String planName;
  final String planPrice;
  final String payMethod; // card, crypto, trustly, skrill, neteller, paysafecard
  final Color planColor;

  const PaymentFlowScreen({
    super.key,
    required this.planKey,
    required this.planName,
    required this.planPrice,
    required this.payMethod,
    required this.planColor,
  });

  @override
  Widget build(BuildContext context) {
    context.watch<LangProvider>();
    return _PaymentConfirmScreen(
      planKey: planKey,
      planName: planName,
      planPrice: planPrice,
      payMethod: payMethod,
      planColor: planColor,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STEP 1 — ORDER CONFIRMATION
// ═══════════════════════════════════════════════════════════════

class _PaymentConfirmScreen extends StatelessWidget {
  final String planKey, planName, planPrice, payMethod;
  final Color planColor;

  const _PaymentConfirmScreen({
    required this.planKey, required this.planName,
    required this.planPrice, required this.payMethod, required this.planColor,
  });

  String _payMethodLabel(String m) {
    switch (m) {
      case 'stripe': return 'Stripe';
      case 'paypal': return 'PayPal';
      case 'revolut': return 'Revolut';
      case 'card': return 'Visa / Mastercard';
      case 'crypto': return 'Crypto (USDT/USDC)';
      case 'trustly': return 'Trustly';
      case 'skrill': return 'Skrill';
      case 'neteller': return 'Neteller';
      case 'paysafecard': return 'Paysafecard';
      default: return m;
    }
  }

  IconData _payMethodIcon(String m) {
    switch (m) {
      case 'stripe': return Icons.credit_card;
      case 'paypal': return Icons.paypal_outlined;
      case 'revolut': return Icons.account_balance;
      case 'card': return Icons.credit_card;
      case 'crypto': return Icons.currency_bitcoin;
      case 'trustly': return Icons.account_balance;
      case 'skrill': return Icons.wallet;
      case 'neteller': return Icons.account_balance_wallet;
      case 'paysafecard': return Icons.confirmation_number;
      default: return Icons.payment;
    }
  }

  @override
  Widget build(BuildContext context) {
    final features = _planFeatures(planKey);

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t('confirm_order'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [planColor, planColor.withValues(alpha: 0.7)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(children: [
                Icon(planKey == 'vip' ? Icons.diamond : (planKey == 'premium' ? Icons.workspace_premium : Icons.rocket_launch), color: Colors.white, size: 40),
                const SizedBox(height: 10),
                Text(planName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 4),
                Text('$planPrice${AppStrings.t('per_month')}', style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.9))),
              ]),
            ),
            const SizedBox(height: 24),

            // What you get
            Text(AppStrings.t('what_you_get'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 12),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                Icon(Icons.check_circle, size: 20, color: planColor),
                const SizedBox(width: 10),
                Expanded(child: Text(f, style: TextStyle(fontSize: 14, color: context.textPrimaryC))),
              ]),
            )),
            const SizedBox(height: 24),

            // Payment method
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.surfaceBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.dividerC),
              ),
              child: Row(children: [
                Icon(_payMethodIcon(payMethod), size: 28, color: planColor),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(AppStrings.t('payment_method'), style: TextStyle(fontSize: 12, color: context.textHintC)),
                  Text(_payMethodLabel(payMethod), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                ])),
                Text(planPrice, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: planColor)),
              ]),
            ),
            const SizedBox(height: 30),

            // Continue button
            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _PaymentInputScreen(
                  planKey: planKey, planName: planName, planPrice: planPrice,
                  payMethod: payMethod, planColor: planColor,
                ))),
                style: ElevatedButton.styleFrom(
                  backgroundColor: planColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(AppStrings.t('continue_to_payment'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STEP 2 — PAYMENT INPUT (different per method)
// ═══════════════════════════════════════════════════════════════

class _PaymentInputScreen extends StatefulWidget {
  final String planKey, planName, planPrice, payMethod;
  final Color planColor;

  const _PaymentInputScreen({
    required this.planKey, required this.planName,
    required this.planPrice, required this.payMethod, required this.planColor,
  });

  @override
  State<_PaymentInputScreen> createState() => _PaymentInputScreenState();
}

class _PaymentInputScreenState extends State<_PaymentInputScreen> {
  final _formKey = GlobalKey<FormState>();
  // Card fields
  final _cardNumberCtrl = TextEditingController();
  final _cardExpiryCtrl = TextEditingController();
  final _cardCvvCtrl = TextEditingController();
  final _cardNameCtrl = TextEditingController();
  // E-wallet fields
  final _emailCtrl = TextEditingController();
  // Paysafecard
  final _pinCtrl = TextEditingController();
  // Crypto
  String _selectedCrypto = 'USDT (TRC-20)';

  @override
  void dispose() {
    _cardNumberCtrl.dispose(); _cardExpiryCtrl.dispose();
    _cardCvvCtrl.dispose(); _cardNameCtrl.dispose();
    _emailCtrl.dispose(); _pinCtrl.dispose();
    super.dispose();
  }

  void _pay() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => _PaymentProcessingScreen(
      planKey: widget.planKey, planName: widget.planName,
      planPrice: widget.planPrice, payMethod: widget.payMethod,
      planColor: widget.planColor,
    )));
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LangProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(_screenTitle())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.planColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(AppStrings.t('amount_to_pay'), style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
                  Text(widget.planPrice, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: widget.planColor)),
                ]),
              ),
              const SizedBox(height: 24),

              // Payment form based on method
              ..._buildPaymentForm(),

              const SizedBox(height: 30),

              // Pay button
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton.icon(
                  onPressed: _pay,
                  icon: Icon(_payIcon(), size: 20),
                  label: Text('${AppStrings.t('pay')} ${widget.planPrice}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.planColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // Security note
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.lock_outline, size: 14, color: context.textHintC),
                const SizedBox(width: 6),
                Text(AppStrings.t('secure_payment'), style: TextStyle(fontSize: 12, color: context.textHintC)),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  String _screenTitle() {
    switch (widget.payMethod) {
      case 'stripe': return 'Stripe Checkout';
      case 'paypal': return 'PayPal';
      case 'revolut': return 'Revolut Pay';
      case 'card': return AppStrings.t('pay_card');
      case 'crypto': return AppStrings.t('pay_crypto');
      case 'trustly': return 'Trustly';
      case 'skrill': return 'Skrill';
      case 'neteller': return 'Neteller';
      case 'paysafecard': return 'Paysafecard';
      default: return AppStrings.t('payment_method');
    }
  }

  IconData _payIcon() {
    switch (widget.payMethod) {
      case 'card': return Icons.credit_card;
      case 'crypto': return Icons.currency_bitcoin;
      default: return Icons.payment;
    }
  }

  List<Widget> _buildPaymentForm() {
    switch (widget.payMethod) {
      case 'stripe': return _stripeForm();
      case 'paypal': return _redirectForm('PayPal', AppStrings.t('redirect_paypal'), Icons.paypal_outlined);
      case 'revolut': return _redirectForm('Revolut', AppStrings.t('redirect_revolut'), Icons.account_balance);
      case 'card': return _cardForm();
      case 'crypto': return _cryptoForm();
      case 'trustly': return _bankForm('Trustly');
      case 'skrill': return _walletForm('Skrill');
      case 'neteller': return _walletForm('Neteller');
      case 'paysafecard': return _paysafecardForm();
      default: return _cardForm();
    }
  }

  List<Widget> _cardForm() => [
    Text(AppStrings.t('card_details'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
    const SizedBox(height: 14),
    _input(_cardNameCtrl, AppStrings.t('cardholder_name'), Icons.person_outline, validator: _reqd),
    _input(_cardNumberCtrl, AppStrings.t('card_number'), Icons.credit_card,
      keyboardType: TextInputType.number,
      formatters: [FilteringTextInputFormatter.digitsOnly, _CardNumberFormatter()],
      validator: (v) => (v == null || v.replaceAll(' ', '').length < 16) ? AppStrings.t('invalid_card') : null),
    Row(children: [
      Expanded(child: _input(_cardExpiryCtrl, 'MM/YY', Icons.calendar_today_outlined,
        keyboardType: TextInputType.number,
        formatters: [FilteringTextInputFormatter.digitsOnly, _ExpiryFormatter()],
        validator: (v) => (v == null || v.length < 5) ? AppStrings.t('invalid_expiry') : null)),
      const SizedBox(width: 14),
      Expanded(child: _input(_cardCvvCtrl, 'CVV', Icons.lock_outline,
        keyboardType: TextInputType.number, obscure: true,
        formatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
        validator: (v) => (v == null || v.length < 3) ? AppStrings.t('invalid_cvv') : null)),
    ]),
  ];

  List<Widget> _stripeForm() => [
    Text('Stripe Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
    const SizedBox(height: 14),
    _input(_cardNameCtrl, AppStrings.t('cardholder_name'), Icons.person_outline, validator: _reqd),
    _input(_cardNumberCtrl, AppStrings.t('card_number'), Icons.credit_card,
      keyboardType: TextInputType.number,
      formatters: [FilteringTextInputFormatter.digitsOnly, _CardNumberFormatter()],
      validator: (v) => (v == null || v.replaceAll(' ', '').length < 16) ? AppStrings.t('invalid_card') : null),
    Row(children: [
      Expanded(child: _input(_cardExpiryCtrl, 'MM/YY', Icons.calendar_today_outlined,
        keyboardType: TextInputType.number,
        formatters: [FilteringTextInputFormatter.digitsOnly, _ExpiryFormatter()],
        validator: (v) => (v == null || v.length < 5) ? AppStrings.t('invalid_expiry') : null)),
      const SizedBox(width: 14),
      Expanded(child: _input(_cardCvvCtrl, 'CVC', Icons.lock_outline,
        keyboardType: TextInputType.number, obscure: true,
        formatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
        validator: (v) => (v == null || v.length < 3) ? AppStrings.t('invalid_cvv') : null)),
    ]),
    Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF0EFFF), borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        const Icon(Icons.verified_user, size: 16, color: Color(0xFF635BFF)),
        const SizedBox(width: 8),
        Expanded(child: Text(AppStrings.t('stripe_secure'), style: const TextStyle(fontSize: 12, color: Color(0xFF635BFF)))),
      ]),
    ),
  ];

  List<Widget> _redirectForm(String provider, String desc, IconData icon) => [
    Text(provider, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
    const SizedBox(height: 14),
    Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: context.surfaceBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.dividerC)),
      child: Column(children: [
        Icon(icon, size: 56, color: widget.planColor),
        const SizedBox(height: 16),
        Text(desc, style: TextStyle(fontSize: 14, color: context.textSecondaryC, height: 1.5), textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: widget.planColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Text(widget.planPrice, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: widget.planColor)),
        ),
      ]),
    ),
  ];

  List<Widget> _cryptoForm() => [
    Text(AppStrings.t('select_crypto'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
    const SizedBox(height: 14),
    ...['USDT (TRC-20)', 'USDT (ERC-20)', 'USDC (ERC-20)', 'BTC', 'ETH'].map((c) {
      final selected = _selectedCrypto == c;
      return GestureDetector(
        onTap: () => setState(() => _selectedCrypto = c),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? widget.planColor : context.dividerC, width: selected ? 2 : 1),
          ),
          child: Row(children: [
            Icon(Icons.currency_bitcoin, size: 20, color: selected ? widget.planColor : context.textHintC),
            const SizedBox(width: 12),
            Text(c, style: TextStyle(fontSize: 15, fontWeight: selected ? FontWeight.w600 : FontWeight.w400, color: context.textPrimaryC)),
            const Spacer(),
            if (selected) Icon(Icons.check_circle, size: 20, color: widget.planColor),
          ]),
        ),
      );
    }),
    const SizedBox(height: 16),
    Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(Icons.info_outline, size: 18, color: Colors.orange[700]),
        const SizedBox(width: 10),
        Expanded(child: Text(AppStrings.t('crypto_note'), style: TextStyle(fontSize: 12, color: Colors.orange[800]))),
      ]),
    ),
  ];

  List<Widget> _bankForm(String provider) => [
    Text('$provider ${AppStrings.t('login')}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
    const SizedBox(height: 14),
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: context.surfaceBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.dividerC)),
      child: Column(children: [
        Icon(Icons.account_balance, size: 48, color: widget.planColor),
        const SizedBox(height: 12),
        Text(AppStrings.t('redirect_bank'), style: TextStyle(fontSize: 14, color: context.textSecondaryC, height: 1.5), textAlign: TextAlign.center),
      ]),
    ),
  ];

  List<Widget> _walletForm(String provider) => [
    Text('$provider ${AppStrings.t('account')}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
    const SizedBox(height: 14),
    _input(_emailCtrl, '$provider Email', Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: _reqd),
  ];

  List<Widget> _paysafecardForm() => [
    Text('Paysafecard PIN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
    const SizedBox(height: 14),
    _input(_pinCtrl, AppStrings.t('enter_pin'), Icons.confirmation_number,
      keyboardType: TextInputType.number,
      formatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
      validator: (v) => (v == null || v.length < 16) ? AppStrings.t('invalid_pin') : null),
    const SizedBox(height: 12),
    Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(Icons.info_outline, size: 18, color: Colors.blue[700]),
        const SizedBox(width: 10),
        Expanded(child: Text(AppStrings.t('paysafecard_note'), style: TextStyle(fontSize: 12, color: Colors.blue[800]))),
      ]),
    ),
  ];

  Widget _input(TextEditingController ctrl, String hint, IconData icon, {
    TextInputType? keyboardType, bool obscure = false,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        obscureText: obscure,
        inputFormatters: formatters,
        validator: validator,
        style: TextStyle(fontSize: 15, color: context.textPrimaryC),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: context.textHintC),
          prefixIcon: Icon(icon, size: 20, color: context.textHintC),
          filled: true, fillColor: context.inputFill,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: widget.planColor, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: GuroJobsTheme.error)),
        ),
      ),
    );
  }

  String? _reqd(String? v) => (v == null || v.trim().isEmpty) ? AppStrings.t('field_required') : null;
}

// ═══════════════════════════════════════════════════════════════
// STEP 3 — PROCESSING
// ═══════════════════════════════════════════════════════════════

class _PaymentProcessingScreen extends StatefulWidget {
  final String planKey, planName, planPrice, payMethod;
  final Color planColor;

  const _PaymentProcessingScreen({
    required this.planKey, required this.planName,
    required this.planPrice, required this.payMethod, required this.planColor,
  });

  @override
  State<_PaymentProcessingScreen> createState() => _PaymentProcessingState();
}

class _PaymentProcessingState extends State<_PaymentProcessingScreen> with TickerProviderStateMixin {
  int _step = 0;

  List<String> get _steps {
    switch (widget.payMethod) {
      case 'stripe':
        return [AppStrings.t('step_stripe_connect'), AppStrings.t('step_verifying_card'), AppStrings.t('step_processing_payment'), AppStrings.t('step_confirming')];
      case 'paypal':
        return [AppStrings.t('step_paypal_connect'), AppStrings.t('step_authorizing'), AppStrings.t('step_processing_payment'), AppStrings.t('step_confirming')];
      case 'revolut':
        return [AppStrings.t('step_revolut_connect'), AppStrings.t('step_authorizing'), AppStrings.t('step_processing_payment'), AppStrings.t('step_confirming')];
      case 'card':
        return [AppStrings.t('step_verifying_card'), AppStrings.t('step_contacting_bank'), AppStrings.t('step_processing_payment'), AppStrings.t('step_confirming')];
      case 'crypto':
        return [AppStrings.t('step_generating_address'), AppStrings.t('step_waiting_confirmation'), AppStrings.t('step_confirming')];
      case 'trustly':
        return [AppStrings.t('step_connecting_bank'), AppStrings.t('step_authorizing'), AppStrings.t('step_processing_payment'), AppStrings.t('step_confirming')];
      case 'paysafecard':
        return [AppStrings.t('step_verifying_pin'), AppStrings.t('step_processing_payment'), AppStrings.t('step_confirming')];
      default: // skrill, neteller
        return [AppStrings.t('step_connecting_wallet'), AppStrings.t('step_processing_payment'), AppStrings.t('step_confirming')];
    }
  }

  @override
  void initState() {
    super.initState();
    _runSteps();
  }

  Future<void> _runSteps() async {
    final steps = _steps;
    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(Duration(milliseconds: i == steps.length - 1 ? 800 : 1200));
      if (!mounted) return;
      setState(() => _step = i + 1);
    }
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => _PaymentSuccessScreen(
      planKey: widget.planKey, planName: widget.planName,
      planPrice: widget.planPrice, payMethod: widget.payMethod,
      planColor: widget.planColor,
    )));
  }

  @override
  Widget build(BuildContext context) {
    final steps = _steps;
    final progress = _step / steps.length;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80, height: 80,
                  child: CircularProgressIndicator(
                    value: _step >= steps.length ? 1.0 : null,
                    strokeWidth: 4,
                    color: widget.planColor,
                  ),
                ),
                const SizedBox(height: 30),
                Text(AppStrings.t('processing_payment'), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                const SizedBox(height: 8),
                Text(AppStrings.t('do_not_close'), style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
                const SizedBox(height: 30),
                // Steps
                ...List.generate(steps.length, (i) {
                  final done = _step > i;
                  final current = _step == i;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(children: [
                      done
                        ? Icon(Icons.check_circle, size: 22, color: GuroJobsTheme.success)
                        : current
                          ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: widget.planColor))
                          : Icon(Icons.radio_button_unchecked, size: 22, color: context.dividerC),
                      const SizedBox(width: 12),
                      Text(steps[i], style: TextStyle(
                        fontSize: 14,
                        color: done ? GuroJobsTheme.success : (current ? context.textPrimaryC : context.textHintC),
                        fontWeight: current ? FontWeight.w600 : FontWeight.w400,
                      )),
                    ]),
                  );
                }),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: context.dividerC,
                    valueColor: AlwaysStoppedAnimation<Color>(widget.planColor),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STEP 4 — SUCCESS + PLAN DESCRIPTION
// ═══════════════════════════════════════════════════════════════

class _PaymentSuccessScreen extends StatelessWidget {
  final String planKey, planName, planPrice, payMethod;
  final Color planColor;

  const _PaymentSuccessScreen({
    required this.planKey, required this.planName,
    required this.planPrice, required this.payMethod, required this.planColor,
  });

  @override
  Widget build(BuildContext context) {
    context.watch<LangProvider>();
    final features = _planFeatures(planKey);

    // Activate plan in credits provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactCreditsProvider>().setPlan(planKey);
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 30),

                // Success animation
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: GuroJobsTheme.success.withValues(alpha: 0.12),
                  ),
                  child: const Icon(Icons.check_circle, size: 60, color: GuroJobsTheme.success),
                ),
                const SizedBox(height: 20),
                Text(AppStrings.t('payment_successful'), style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: context.textPrimaryC)),
                const SizedBox(height: 8),
                Text(AppStrings.t('welcome_to_plan').replaceAll('{plan}', planName), style: TextStyle(fontSize: 15, color: context.textSecondaryC), textAlign: TextAlign.center),
                const SizedBox(height: 30),

                // Receipt card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Column(children: [
                    _receiptRow(context, AppStrings.t('plan'), planName),
                    _receiptRow(context, AppStrings.t('amount_paid'), planPrice),
                    _receiptRow(context, AppStrings.t('payment_method'), _payMethodLabel(payMethod)),
                    _receiptRow(context, AppStrings.t('billing_period'), AppStrings.t('monthly')),
                    _receiptRow(context, AppStrings.t('next_payment'), _nextPaymentDate()),
                    const SizedBox(height: 10),
                    Divider(color: context.dividerC),
                    const SizedBox(height: 10),
                    Row(children: [
                      Icon(Icons.receipt_long, size: 16, color: context.textHintC),
                      const SizedBox(width: 8),
                      Text(AppStrings.t('receipt_sent'), style: TextStyle(fontSize: 12, color: context.textHintC)),
                    ]),
                  ]),
                ),
                const SizedBox(height: 24),

                // Plan benefits
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [planColor, planColor.withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Icon(Icons.star, color: Colors.white, size: 22),
                      const SizedBox(width: 8),
                      Text(AppStrings.t('your_benefits'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                    ]),
                    const SizedBox(height: 16),
                    ...features.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Icon(Icons.check, size: 18, color: Colors.white),
                        const SizedBox(width: 10),
                        Expanded(child: Text(f, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.95)))),
                      ]),
                    )),
                  ]),
                ),
                const SizedBox(height: 30),

                // Done button
                SizedBox(
                  width: double.infinity, height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Pop all payment screens back to billing or dashboard
                      Navigator.of(context).popUntil((route) => route.isFirst || route.settings.name == '/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: planColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(AppStrings.t('start_using'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
      ]),
    );
  }

  String _payMethodLabel(String m) {
    switch (m) {
      case 'stripe': return 'Stripe';
      case 'paypal': return 'PayPal';
      case 'revolut': return 'Revolut';
      case 'card': return 'Visa / Mastercard';
      case 'crypto': return 'Crypto';
      case 'trustly': return 'Trustly';
      case 'skrill': return 'Skrill';
      case 'neteller': return 'Neteller';
      case 'paysafecard': return 'Paysafecard';
      default: return m;
    }
  }

  String _nextPaymentDate() {
    final next = DateTime.now().add(const Duration(days: 30));
    return '${next.day.toString().padLeft(2, '0')}.${next.month.toString().padLeft(2, '0')}.${next.year}';
  }
}

// ═══════════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════════

List<String> _planFeatures(String planKey) {
  switch (planKey) {
    case 'basic': return [
      AppStrings.t('plan_basic_contacts'),
      AppStrings.t('plan_basic_desc'),
      AppStrings.t('feat_email_alerts'),
      '20 ${AppStrings.t("days")} free trial',
    ];
    case 'premium': return [
      AppStrings.t('plan_premium_contacts'),
      AppStrings.t('plan_premium_team'),
      AppStrings.t('plan_premium_linkedin'),
      AppStrings.t('plan_premium_desc'),
      AppStrings.t('feat_priority_search'),
      AppStrings.t('feat_cv_analytics'),
    ];
    case 'vip': return [
      AppStrings.t('plan_vip_contacts'),
      AppStrings.t('plan_vip_team'),
      AppStrings.t('plan_premium_linkedin'),
      AppStrings.t('plan_vip_bot'),
      AppStrings.t('plan_vip_desc'),
      AppStrings.t('feat_priority_search'),
      'API access',
    ];
    default: return [];
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) buffer.write(' ');
    }
    return TextEditingValue(text: buffer.toString(), selection: TextSelection.collapsed(offset: buffer.length));
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll('/', '');
    if (text.length > 4) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length > 2) buffer.write('/');
    }
    return TextEditingValue(text: buffer.toString(), selection: TextSelection.collapsed(offset: buffer.length));
  }
}
