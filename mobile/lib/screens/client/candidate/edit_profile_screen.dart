import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import '../../../core/countries.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/api_service.dart';
import '../../../widgets/filter_pickers.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _telegramController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;
  bool _saving = false;
  bool _loaded = false;

  // Filter fields
  String? _commLangPriority;
  List<String> _commLangsAcceptable = [];
  String? _citizenshipCountry;
  bool? _inCitizenshipCountry;
  List<String> _blockedCompanyCountries = [];

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _nameController = TextEditingController(text: auth.userName ?? '');
    _emailController = TextEditingController(text: auth.userEmail ?? '');
    _phoneController = TextEditingController();
    _telegramController = TextEditingController();
    _locationController = TextEditingController();
    _bioController = TextEditingController();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await ApiService.getProfile();
      if (data['success'] == true && data['data'] != null) {
        final d = data['data'];
        final user = d['user'];
        final p = d['profile'];
        if (mounted && p != null) {
          setState(() {
            _phoneController.text = user?['phone'] ?? '';
            _telegramController.text = p['telegram'] ?? '';
            _locationController.text = p['location'] ?? '';
            _bioController.text = p['bio'] ?? '';
            _commLangPriority = p['communication_language_priority'];
            _commLangsAcceptable = List<String>.from(p['communication_languages_acceptable'] ?? []);
            _citizenshipCountry = p['citizenship_country'];
            _inCitizenshipCountry = p['in_citizenship_country'];
            _blockedCompanyCountries = List<String>.from(p['blocked_company_countries'] ?? []);
            _loaded = true;
          });
        }
      }
    } catch (_) {
      if (mounted) setState(() => _loaded = true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _telegramController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final fields = <String, dynamic>{
        'name': _nameController.text,
        'phone': _phoneController.text,
        'telegram': _telegramController.text,
        'location': _locationController.text,
        'bio': _bioController.text,
      };
      if (_commLangPriority != null) fields['communication_language_priority'] = _commLangPriority!;
      if (_citizenshipCountry != null) fields['citizenship_country'] = _citizenshipCountry!;
      if (_inCitizenshipCountry != null) fields['in_citizenship_country'] = _inCitizenshipCountry! ? '1' : '0';

      // Arrays need special form-encoding
      for (int i = 0; i < _commLangsAcceptable.length; i++) {
        fields['communication_languages_acceptable[$i]'] = _commLangsAcceptable[i];
      }
      for (int i = 0; i < _blockedCompanyCountries.length; i++) {
        fields['blocked_company_countries[$i]'] = _blockedCompanyCountries[i];
      }

      await ApiService.updateProfile(fields);
    } catch (_) {}
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.t('profile_updated')), backgroundColor: GuroJobsTheme.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t('edit_profile'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100, height: 100,
                      decoration: const BoxDecoration(color: GuroJobsTheme.primary, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          (_nameController.text.isNotEmpty ? _nameController.text[0] : 'U').toUpperCase(),
                          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo upload coming soon'), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 1))),
                        child: Container(
                          width: 34, height: 34,
                          decoration: BoxDecoration(color: GuroJobsTheme.accent, shape: BoxShape.circle, border: Border.all(color: context.cardBg, width: 2)),
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _field(AppStrings.t('full_name'), _nameController, Icons.person_outline, validator: (v) => (v == null || v.isEmpty) ? AppStrings.t('enter_name') : null),
              _field(AppStrings.t('email_address'), _emailController, Icons.email_outlined, enabled: false),
              _field(AppStrings.t('phone'), _phoneController, Icons.phone_outlined, hint: AppStrings.t('phone_hint')),
              _field(AppStrings.t('telegram'), _telegramController, Icons.send_outlined, hint: AppStrings.t('telegram_hint')),
              _field('Location', _locationController, Icons.location_on_outlined, hint: 'City, Country'),
              _field('About me', _bioController, Icons.info_outline, maxLines: 4, hint: 'Tell employers about yourself...'),

              const SizedBox(height: 20),

              // ── Communication Preferences ──
              _sectionTitle(AppStrings.t('communication_preferences')),
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

              // ── Country Filters ──
              _sectionTitle(AppStrings.t('candidate_filters')),
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

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: _saving
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : Text(AppStrings.t('save_changes'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: GuroJobsTheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary)),
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon, {bool enabled = true, int maxLines = 1, String? hint, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctrl, enabled: enabled, maxLines: maxLines, validator: validator,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20, color: context.textHintC),
              hintText: hint, hintStyle: TextStyle(color: context.textHintC, fontSize: 14),
              filled: true, fillColor: enabled ? context.inputFill : context.surfaceBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
            ),
          ),
        ],
      ),
    );
  }
}
