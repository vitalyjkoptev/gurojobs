import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import '../../../core/countries.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/filter_pickers.dart';
import 'dashboard_screen.dart';
import 'splash_screen.dart';
import '../../employer/employer_dashboard.dart';
import '../../boss/admin_dashboard.dart';

class RegisterScreen extends StatefulWidget {
  final bool initialLogin;
  final String? forceRole; // 'admin' for admin-only login
  const RegisterScreen({super.key, this.initialLogin = false, this.forceRole});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  late bool _isLogin = widget.initialLogin || widget.forceRole != null;
  bool get _isAdminLogin => widget.forceRole == 'admin';
  bool _isForgotPassword = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _telegramController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String _selectedRole = 'candidate';

  // ── Filter fields ──
  String? _commLangPriority;
  List<String> _commLangsAcceptable = [];
  // Candidate
  String? _citizenshipCountry;
  bool? _inCitizenshipCountry;
  List<String> _blockedCompanyCountries = [];
  // Employer
  List<String> _mainOfficeCountries = [];
  List<String> _blockedCandidateCitizenships = [];
  String _candidateLocationPref = 'all';

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();
    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _nameController.dispose(); _emailController.dispose(); _passwordController.dispose();
    _confirmPasswordController.dispose(); _phoneController.dispose(); _telegramController.dispose();
    _animController.dispose(); super.dispose();
  }

  void _toggleMode() { setState(() { _isLogin = !_isLogin; _isForgotPassword = false; }); _formKey.currentState?.reset(); }
  void _showForgotPassword() => setState(() { _isForgotPassword = true; _isLogin = true; });
  void _backFromForgot() => setState(() => _isForgotPassword = false);

  void _goBack() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
    );
  }

  Future<void> _submitForgotPassword() async {
    if (_emailController.text.trim().isEmpty) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.forgotPassword(email: _emailController.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? AppStrings.t('reset_sent') : (auth.errorMessage ?? AppStrings.t('connection_error'))),
          backgroundColor: success ? GuroJobsTheme.success : GuroJobsTheme.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      );
      if (success) setState(() => _isForgotPassword = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    bool success;
    if (_isLogin) {
      success = await auth.login(email: _emailController.text.trim(), password: _passwordController.text);
    } else {
      success = await auth.register(
        name: _nameController.text.trim(), email: _emailController.text.trim(),
        password: _passwordController.text, passwordConfirmation: _confirmPasswordController.text,
        role: _selectedRole, phone: _phoneController.text.trim(), telegramUsername: _telegramController.text.trim(),
        commLangPriority: _commLangPriority,
        commLangsAcceptable: _commLangsAcceptable,
        citizenshipCountry: _citizenshipCountry,
        inCitizenshipCountry: _inCitizenshipCountry,
        blockedCompanyCountries: _blockedCompanyCountries,
        mainOfficeCountries: _mainOfficeCountries,
        blockedCandidateCitizenships: _blockedCandidateCitizenships,
        candidateLocationPref: _candidateLocationPref,
      );
    }
    if (success && mounted) {
      // Admin login guard: if forceRole is admin but user role isn't admin — reject
      if (_isAdminLogin && auth.userRole != 'admin') {
        await auth.logout();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.t('admin_only_error')),
              backgroundColor: GuroJobsTheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
        return;
      }

      final screen = auth.userRole == 'admin'
          ? const AdminDashboardScreen()
          : auth.userRole == 'employer'
          ? const EmployerDashboardScreen()
          : const DashboardScreen();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => screen));
    } else if (mounted && auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage!), backgroundColor: GuroJobsTheme.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      );
    }
  }

  Color get _accentColor => GuroJobsTheme.primary;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (_isForgotPassword) {
      return Scaffold(
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(children: [
                const SizedBox(height: 60),
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(color: _accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(18)),
                  child: Icon(Icons.lock_reset, color: _accentColor, size: 36),
                ),
                const SizedBox(height: 20),
                Text(AppStrings.t('forgot_password_title'), style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                const SizedBox(height: 8),
                Text(AppStrings.t('forgot_password_desc'), textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
                const SizedBox(height: 36),
                _buildLabel(AppStrings.t('email_address')),
                const SizedBox(height: 6),
                TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: _inputDecoration(hint: AppStrings.t('email_hint'), icon: Icons.email_outlined)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton(
                    onPressed: auth.isLoading ? null : _submitForgotPassword,
                    style: ElevatedButton.styleFrom(backgroundColor: _accentColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: auth.isLoading
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : Text(AppStrings.t('send_reset_link'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _backFromForgot,
                  child: Text('← ${AppStrings.t('back_to_login')}', style: TextStyle(fontSize: 14, color: _accentColor, fontWeight: FontWeight.w600)),
                ),
              ]),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: _goBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.surfaceBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.arrow_back_ios_new, size: 18, color: context.textSecondaryC),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Center(
                  child: Column(children: [
                    Container(
                      width: 70, height: 70,
                      decoration: BoxDecoration(
                        color: GuroJobsTheme.primary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: _isAdminLogin
                            ? const Icon(Icons.admin_panel_settings, size: 36, color: Colors.white)
                            : const Text('G', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: Colors.white, height: 1)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _isAdminLogin
                          ? AppStrings.t('admin_panel')
                          : (_isLogin ? AppStrings.t('welcome_back') : AppStrings.t('create_account')),
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: context.textPrimaryC),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isAdminLogin
                          ? AppStrings.t('admin_login_desc')
                          : (_isLogin ? AppStrings.t('sign_in_subtitle') : AppStrings.t('register_subtitle')),
                      style: TextStyle(fontSize: 14, color: context.textSecondaryC),
                    ),
                  ]),
                ),
                const SizedBox(height: 28),

                // Toggle tabs (hidden for admin)
                if (!_isAdminLogin)
                  Container(
                    decoration: BoxDecoration(color: context.surfaceBg, borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(4),
                    child: Row(children: [
                      _buildTab(AppStrings.t('register'), !_isLogin, () { if (_isLogin) _toggleMode(); }),
                      _buildTab(AppStrings.t('sign_in'), _isLogin, () { if (!_isLogin) _toggleMode(); }),
                    ]),
                  ),
                const SizedBox(height: 24),

                // Role selector (only for register mode, hidden for admin)
                if (!_isLogin && !_isAdminLogin) ...[
                  Text(AppStrings.t('select_role'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                  const SizedBox(height: 10),
                  Row(children: [
                    _buildRoleChip('candidate', AppStrings.t('candidate'), Icons.person_outline),
                    const SizedBox(width: 8),
                    _buildRoleChip('employer', AppStrings.t('employer'), Icons.business_outlined),
                  ]),
                  const SizedBox(height: 20),
                ],

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_isLogin) ...[
                        _buildLabel(AppStrings.t('full_name')), const SizedBox(height: 6),
                        TextFormField(controller: _nameController, textCapitalization: TextCapitalization.words,
                          decoration: _inputDecoration(hint: AppStrings.t('name_hint'), icon: Icons.person_outline),
                          validator: (v) { if (!_isLogin && (v == null || v.trim().isEmpty)) return AppStrings.t('enter_name'); return null; }),
                        const SizedBox(height: 14),
                      ],
                      _buildLabel(AppStrings.t('email_address')), const SizedBox(height: 6),
                      TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress, autocorrect: false,
                        decoration: _inputDecoration(hint: AppStrings.t('email_hint'), icon: Icons.email_outlined),
                        validator: (v) { if (v == null || v.trim().isEmpty) return AppStrings.t('enter_email'); if (!v.contains('@') || !v.contains('.')) return AppStrings.t('valid_email'); return null; }),
                      const SizedBox(height: 14),
                      _buildLabel(AppStrings.t('password')), const SizedBox(height: 6),
                      TextFormField(controller: _passwordController, obscureText: _obscurePassword,
                        decoration: _inputDecoration(hint: AppStrings.t('password_hint'), icon: Icons.lock_outline,
                          suffix: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: context.textHintC, size: 20), onPressed: () => setState(() => _obscurePassword = !_obscurePassword))),
                        validator: (v) { if (v == null || v.isEmpty) return AppStrings.t('enter_password'); if (v.length < 8) return AppStrings.t('password_min'); return null; }),
                      if (_isLogin) ...[
                        const SizedBox(height: 8),
                        Align(alignment: Alignment.centerRight, child: GestureDetector(onTap: _showForgotPassword,
                          child: Text(AppStrings.t('forgot_password'), style: TextStyle(fontSize: 13, color: _accentColor, fontWeight: FontWeight.w600)))),
                      ],
                      const SizedBox(height: 14),
                      if (!_isLogin) ...[
                        _buildLabel(AppStrings.t('confirm_password')), const SizedBox(height: 6),
                        TextFormField(controller: _confirmPasswordController, obscureText: _obscureConfirm,
                          decoration: _inputDecoration(hint: AppStrings.t('confirm_hint'), icon: Icons.lock_outline,
                            suffix: IconButton(icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: context.textHintC, size: 20), onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm))),
                          validator: (v) { if (!_isLogin && v != _passwordController.text) return AppStrings.t('passwords_mismatch'); return null; }),
                        const SizedBox(height: 14),
                        _buildLabel('${AppStrings.t('phone')} (optional)'), const SizedBox(height: 6),
                        TextFormField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: _inputDecoration(hint: AppStrings.t('phone_hint'), icon: Icons.phone_outlined)),
                        const SizedBox(height: 14),
                        _buildLabel('${AppStrings.t('telegram')} (optional)'), const SizedBox(height: 6),
                        TextFormField(controller: _telegramController, decoration: _inputDecoration(hint: AppStrings.t('telegram_hint'), icon: Icons.send_outlined)),
                        const SizedBox(height: 20),

                        // ── Communication Language Filters ──
                        _buildSectionTitle(AppStrings.t('communication_preferences')),
                        const SizedBox(height: 12),

                        SingleSelectPicker(
                          label: AppStrings.t('priority_language'),
                          value: _commLangPriority,
                          items: RefCountries.languageNames(),
                          hint: AppStrings.t('select_language'),
                          icon: Icons.language,
                          onChanged: (v) => setState(() => _commLangPriority = v),
                        ),
                        const SizedBox(height: 14),

                        MultiSelectChipsPicker(
                          label: AppStrings.t('acceptable_languages'),
                          selected: _commLangsAcceptable,
                          items: RefCountries.languageNames(),
                          hint: AppStrings.t('select_languages_hint'),
                          icon: Icons.translate,
                          maxSelect: 3,
                          onChanged: (v) => setState(() => _commLangsAcceptable = v),
                        ),
                        const SizedBox(height: 20),

                        // ── Role-specific filters ──
                        if (_selectedRole == 'candidate') ..._buildCandidateFilters(),
                        if (_selectedRole == 'employer') ..._buildEmployerFilters(),

                        const SizedBox(height: 14),
                      ],
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity, height: 52,
                        child: ElevatedButton(
                          onPressed: auth.isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: _accentColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          child: auth.isLoading
                              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                              : Text(_isLogin ? AppStrings.t('sign_in') : AppStrings.t('create_account'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),

                // Toggle link (hidden for admin)
                if (!_isAdminLogin) ...[
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(child: Divider(color: context.dividerC)),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(AppStrings.t('or'), style: TextStyle(fontSize: 13, color: context.textHintC))),
                    Expanded(child: Divider(color: context.dividerC)),
                  ]),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: _toggleMode,
                      child: RichText(
                        text: TextSpan(style: const TextStyle(fontSize: 14), children: [
                          TextSpan(text: _isLogin ? AppStrings.t('no_account') : AppStrings.t('have_account'), style: TextStyle(color: context.textSecondaryC)),
                          TextSpan(text: _isLogin ? AppStrings.t('register') : AppStrings.t('sign_in'), style: TextStyle(color: _accentColor, fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Candidate-specific filter fields ──
  List<Widget> _buildCandidateFilters() {
    return [
      _buildSectionTitle(AppStrings.t('candidate_filters')),
      const SizedBox(height: 12),

      SingleSelectPicker(
        label: AppStrings.t('citizenship_country'),
        value: _citizenshipCountry,
        items: RefCountries.countryNames(),
        hint: AppStrings.t('select_country'),
        icon: Icons.flag_outlined,
        onChanged: (v) => setState(() => _citizenshipCountry = v),
      ),
      const SizedBox(height: 14),

      YesNoToggle(
        label: AppStrings.t('in_citizenship_country'),
        value: _inCitizenshipCountry,
        onChanged: (v) => setState(() => _inCitizenshipCountry = v),
      ),
      const SizedBox(height: 14),

      MultiSelectChipsPicker(
        label: AppStrings.t('blocked_company_countries'),
        selected: _blockedCompanyCountries,
        items: RefCountries.countryNames(),
        hint: AppStrings.t('blocked_countries_hint'),
        icon: Icons.block,
        maxSelect: 20,
        onChanged: (v) => setState(() => _blockedCompanyCountries = v),
      ),
    ];
  }

  // ── Employer-specific filter fields ──
  List<Widget> _buildEmployerFilters() {
    return [
      _buildSectionTitle(AppStrings.t('employer_filters')),
      const SizedBox(height: 12),

      MultiSelectChipsPicker(
        label: AppStrings.t('main_office_countries'),
        selected: _mainOfficeCountries,
        items: RefCountries.countryNames(),
        hint: AppStrings.t('select_countries'),
        icon: Icons.business,
        maxSelect: 10,
        onChanged: (v) => setState(() => _mainOfficeCountries = v),
      ),
      const SizedBox(height: 14),

      MultiSelectChipsPicker(
        label: AppStrings.t('blocked_candidate_citizenships'),
        selected: _blockedCandidateCitizenships,
        items: RefCountries.countryNames(),
        hint: AppStrings.t('blocked_citizenships_hint'),
        icon: Icons.person_off_outlined,
        maxSelect: 20,
        onChanged: (v) => setState(() => _blockedCandidateCitizenships = v),
      ),
      const SizedBox(height: 14),

      _buildLabel(AppStrings.t('candidate_location_pref')),
      const SizedBox(height: 8),
      Row(children: [
        _buildPrefChip('all', AppStrings.t('all_candidates')),
        const SizedBox(width: 8),
        _buildPrefChip('outside', AppStrings.t('outside_citizenship')),
      ]),
    ];
  }

  Widget _buildPrefChip(String value, String label) {
    final selected = _candidateLocationPref == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _candidateLocationPref = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: selected ? GuroJobsTheme.primary : context.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? GuroJobsTheme.primary : context.dividerC, width: selected ? 2 : 1),
          ),
          child: Center(child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : context.textSecondaryC))),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: _accentColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _accentColor)),
    );
  }

  Widget _buildTab(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? context.cardBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected ? [BoxShadow(color: context.shadowMedium, blurRadius: 4, offset: const Offset(0, 1))] : null,
          ),
          child: Center(child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: selected ? _accentColor : context.textHintC))),
        ),
      ),
    );
  }

  Widget _buildRoleChip(String role, String label, IconData icon) {
    final selected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? GuroJobsTheme.primary : context.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? GuroJobsTheme.primary : context.dividerC, width: selected ? 2 : 1),
            boxShadow: selected ? [BoxShadow(color: GuroJobsTheme.primary.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))] : null,
          ),
          child: Column(children: [
            Icon(icon, size: 22, color: selected ? Colors.white : context.textHintC),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : context.textSecondaryC)),
          ]),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC));

  InputDecoration _inputDecoration({required String hint, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint, prefixIcon: Icon(icon, size: 20, color: context.textHintC), suffixIcon: suffix,
      hintStyle: TextStyle(color: context.textHintC, fontSize: 14),
      filled: true, fillColor: context.inputFill,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _accentColor, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: GuroJobsTheme.error)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
