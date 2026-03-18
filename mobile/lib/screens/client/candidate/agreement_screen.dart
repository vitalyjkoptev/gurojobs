import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../providers/auth_provider.dart';
import 'register_screen.dart';

class AgreementScreen extends StatefulWidget {
  const AgreementScreen({super.key});

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> with SingleTickerProviderStateMixin {
  bool _scrolledToBottom = false;
  bool _accepted = false;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forward();
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _scrollController.addListener(() {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent - 50) {
        if (!_scrolledToBottom) setState(() => _scrolledToBottom = true);
      }
    });
  }

  @override
  void dispose() { _scrollController.dispose(); _fadeController.dispose(); super.dispose(); }

  void _acceptAndContinue() async {
    await context.read<AuthProvider>().acceptTerms();
    if (mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.shield_outlined, color: GuroJobsTheme.primary, size: 32),
                ),
                const SizedBox(height: 16),
                Text('Terms & Privacy', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                const SizedBox(height: 8),
                Text('Please read and accept our terms before continuing', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
              ]),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.dividerC)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SingleChildScrollView(
                    controller: _scrollController, padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(context, '1. Terms of Service', ['By using GURO JOBS, you agree to these Terms of Service. GURO JOBS provides an online platform connecting iGaming professionals with employers.', 'You must be at least 18 years old to use this service. You are responsible for maintaining the confidentiality of your account.', 'You agree not to use the platform for any unlawful purpose or in violation of any applicable regulations.']),
                        _buildSection(context, '2. User Accounts', ['You must provide accurate and complete information when creating an account.', 'You are solely responsible for any activity that occurs under your account.', 'GURO JOBS reserves the right to suspend or terminate accounts that violate these terms.']),
                        _buildSection(context, '3. Privacy Policy', ['We collect personal information including your name, email, professional experience, and job preferences.', 'Your data is used to match you with relevant job opportunities and improve our services.', 'We do not sell your personal data to third parties.', 'Your CV and profile information may be visible to employers when you apply for positions.']),
                        _buildSection(context, '4. Data Protection', ['We implement industry-standard security measures to protect your data.', 'Data is stored on secure servers within the European Union in compliance with GDPR.', 'You have the right to access, modify, or delete your personal data at any time.']),
                        _buildSection(context, '5. Cookies & Analytics', ['We use cookies and analytics to improve user experience.', 'You can manage cookie preferences in your device settings.']),
                        const SizedBox(height: 10),
                        Center(child: Text('Last updated: March 2026', style: TextStyle(fontSize: 12, color: context.textHintC))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                if (!_scrolledToBottom)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.arrow_downward, size: 14, color: context.textHintC),
                      const SizedBox(width: 6),
                      Text('Scroll down to read all terms', style: TextStyle(fontSize: 12, color: context.textHintC)),
                    ]),
                  ),
                GestureDetector(
                  onTap: _scrolledToBottom ? () => setState(() => _accepted = !_accepted) : null,
                  child: Row(children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200), width: 24, height: 24,
                      decoration: BoxDecoration(
                        color: _accepted ? GuroJobsTheme.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _accepted ? GuroJobsTheme.primary : (_scrolledToBottom ? context.textHintC : context.dividerC), width: 2),
                      ),
                      child: _accepted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text('I have read and agree to the Terms of Service and Privacy Policy', style: TextStyle(fontSize: 13, color: _scrolledToBottom ? context.textPrimaryC : context.textHintC, fontWeight: FontWeight.w500))),
                  ]),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton(
                    onPressed: _accepted ? _acceptAndContinue : null,
                    style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, disabledBackgroundColor: context.dividerC, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text('Accept & Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<String> paragraphs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(height: 8),
          ...paragraphs.map((p) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(p, style: TextStyle(fontSize: 14, color: context.textSecondaryC, height: 1.5)))),
        ],
      ),
    );
  }
}
