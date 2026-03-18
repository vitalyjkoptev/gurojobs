import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import '../../../providers/auth_provider.dart';
import 'agreement_screen.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';
import '../../employer/employer_dashboard.dart';
import '../../boss/admin_dashboard.dart';

/// Admin login is via separate route: /admin (see main.dart)

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // 1. Logo (GURO JOBS) — fade in + slight scale
  late AnimationController _logoController;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;

  // 2. Subtitle — fade in + slide up
  late AnimationController _subtitleController;
  late Animation<double> _subtitleOpacity;
  late Animation<double> _subtitleSlide;

  // 3. Category icons — fade in + slide up
  late AnimationController _iconsController;
  late Animation<double> _iconsOpacity;
  late Animation<double> _iconsSlide;

  // 4. Button — fade in + slide up
  late AnimationController _buttonController;
  late Animation<double> _buttonOpacity;
  late Animation<double> _buttonSlide;

  bool _showButton = false;

  @override
  void initState() {
    super.initState();

    // 1. Logo
    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    // 2. Subtitle
    _subtitleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _subtitleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _subtitleController, curve: Curves.easeIn),
    );
    _subtitleSlide = Tween<double>(begin: 18, end: 0).animate(
      CurvedAnimation(parent: _subtitleController, curve: Curves.easeOutCubic),
    );

    // 3. Icons
    _iconsController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _iconsOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _iconsController, curve: Curves.easeIn),
    );
    _iconsSlide = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(parent: _iconsController, curve: Curves.easeOutCubic),
    );

    // 4. Button
    _buttonController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeIn),
    );
    _buttonSlide = Tween<double>(begin: 24, end: 0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimations());
  }

  Future<void> _startAnimations() async {
    final auth = context.read<AuthProvider>();

    if (auth.isLoggedIn) {
      // Quick splash for logged-in users
      await Future.delayed(const Duration(milliseconds: 300));
      _logoController.forward();
      await Future.delayed(const Duration(milliseconds: 600));
      _subtitleController.forward();
      await Future.delayed(const Duration(milliseconds: 500));
      _iconsController.forward();
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        final screen = auth.userRole == 'admin'
            ? const AdminDashboardScreen()
            : auth.userRole == 'employer'
            ? const EmployerDashboardScreen()
            : const DashboardScreen();
        _navigateTo(screen);
      }
      return;
    }

    // Full animation for new users
    await Future.delayed(const Duration(milliseconds: 400));
    _logoController.forward();                          // 1. GURO JOBS
    await Future.delayed(const Duration(milliseconds: 700));
    _subtitleController.forward();                      // 2. Slogan
    await Future.delayed(const Duration(milliseconds: 600));
    _iconsController.forward();                         // 3. Categories
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      setState(() => _showButton = true);
      _buttonController.forward();                      // 4. Buttons
    }
  }

  void _onCandidateEmployer() {
    final auth = context.read<AuthProvider>();
    if (!auth.agreedToTerms) {
      _navigateTo(const AgreementScreen());
    } else {
      _navigateTo(const RegisterScreen());
    }
  }

  void _onCandidateEmployerSignIn() {
    final auth = context.read<AuthProvider>();
    auth.acceptTerms();
    _navigateTo(const RegisterScreen(initialLogin: true));
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _subtitleController.dispose();
    _iconsController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Widget _buildVerticalIcon(String assetPath) {
    return Container(
      width: 72, height: 72,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Image.asset(assetPath, fit: BoxFit.contain),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF014A85), Color(0xFF015EA7), Color(0xFF0277BD)],
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -80, right: -60,
              child: Container(width: 250, height: 250, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05))),
            ),
            Positioned(
              bottom: -100, left: -80,
              child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05))),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  // ===== 1. GURO JOBS =====
                  AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, _) {
                        return Transform.scale(
                          scale: _logoScale.value,
                          child: Opacity(
                            opacity: _logoOpacity.value,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('GURO', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 4)),
                                SizedBox(width: 14),
                                Text('JOBS', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 4)),
                              ],
                            ),
                          ),
                        );
                      },
                  ),

                  const SizedBox(height: 20),

                  // ===== 2. SLOGAN =====
                  AnimatedBuilder(
                    animation: _subtitleController,
                    builder: (context, _) {
                      return Transform.translate(
                        offset: Offset(0, _subtitleSlide.value),
                        child: Opacity(
                          opacity: _subtitleOpacity.value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              AppStrings.t('igaming_platform'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.7),
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 36),

                  // ===== 3. CATEGORY ICONS =====
                  AnimatedBuilder(
                    animation: _iconsController,
                    builder: (context, _) {
                      return Transform.translate(
                        offset: Offset(0, _iconsSlide.value),
                        child: Opacity(
                          opacity: _iconsOpacity.value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildVerticalIcon('assets/images/icon_gambling.png'),
                              _buildVerticalIcon('assets/images/icon_crypto.png'),
                              _buildVerticalIcon('assets/images/icon_fintech.png'),
                              _buildVerticalIcon('assets/images/icon_nutra.png'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 2),

                  // ===== 4. BUTTONS — Two entry paths =====
                  if (_showButton)
                    AnimatedBuilder(
                      animation: _buttonController,
                      builder: (context, _) {
                        return Transform.translate(
                          offset: Offset(0, _buttonSlide.value),
                          child: Opacity(
                            opacity: _buttonOpacity.value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Column(
                                children: [
                                  // --- Main: Candidate / Employer ---
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton.icon(
                                      onPressed: _onCandidateEmployer,
                                      icon: const Icon(Icons.work_outline, size: 22),
                                      label: Text(
                                        AppStrings.t('find_job_or_hire'),
                                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: GuroJobsTheme.primary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        elevation: 4,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: _onCandidateEmployerSignIn,
                                    child: Text(
                                      AppStrings.t('already_have_account'),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
