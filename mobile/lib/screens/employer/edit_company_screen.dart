import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/localization.dart';
import '../../core/countries.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/filter_pickers.dart';

class EditCompanyScreen extends StatefulWidget {
  const EditCompanyScreen({super.key});

  @override
  State<EditCompanyScreen> createState() => _EditCompanyScreenState();
}

class _EditCompanyScreenState extends State<EditCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _telegramCtrl = TextEditingController();
  bool _saving = false;

  // Filter fields
  String? _commLangPriority;
  List<String> _commLangsAcceptable = [];
  List<String> _mainOfficeCountries = [];
  List<String> _blockedCandidateCitizenships = [];
  String _candidateLocationPref = 'all';

  @override
  void initState() {
    super.initState();
    _loadCompany();
  }

  Future<void> _loadCompany() async {
    try {
      final token = await ApiService.getToken();
      if (token == null) return;
      final data = await ApiService.getEmployerCompany();
      if (data['success'] == true && data['data'] != null) {
        final d = data['data'];
        final company = d['company'];
        if (mounted && company != null) {
          setState(() {
            _companyNameCtrl.text = company['name'] ?? '';
            _descriptionCtrl.text = company['description'] ?? '';
            _websiteCtrl.text = company['website'] ?? '';
            _locationCtrl.text = company['location'] ?? '';
            _telegramCtrl.text = company['telegram'] ?? '';
            _commLangPriority = company['communication_language_priority'];
            _commLangsAcceptable = List<String>.from(company['communication_languages_acceptable'] ?? []);
            _mainOfficeCountries = List<String>.from(company['main_office_countries'] ?? []);
            _blockedCandidateCitizenships = List<String>.from(company['blocked_candidate_citizenships'] ?? []);
            _candidateLocationPref = company['candidate_location_pref'] ?? 'all';
          });
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _companyNameCtrl.dispose();
    _descriptionCtrl.dispose();
    _websiteCtrl.dispose();
    _locationCtrl.dispose();
    _telegramCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final fields = <String, dynamic>{
        'company_name': _companyNameCtrl.text,
        'description': _descriptionCtrl.text,
        'website': _websiteCtrl.text,
        'location': _locationCtrl.text,
        'telegram': _telegramCtrl.text,
        'candidate_location_pref': _candidateLocationPref,
      };
      if (_commLangPriority != null) fields['communication_language_priority'] = _commLangPriority!;
      for (int i = 0; i < _commLangsAcceptable.length; i++) {
        fields['communication_languages_acceptable[$i]'] = _commLangsAcceptable[i];
      }
      for (int i = 0; i < _mainOfficeCountries.length; i++) {
        fields['main_office_countries[$i]'] = _mainOfficeCountries[i];
      }
      for (int i = 0; i < _blockedCandidateCitizenships.length; i++) {
        fields['blocked_candidate_citizenships[$i]'] = _blockedCandidateCitizenships[i];
      }

      await ApiService.updateEmployerCompany(fields);
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
      appBar: AppBar(title: const Text('Company Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field('Company Name', _companyNameCtrl, Icons.business, validator: (v) => (v == null || v.isEmpty) ? 'Enter company name' : null),
              _field('Description', _descriptionCtrl, Icons.description_outlined, maxLines: 3, hint: 'About your company...'),
              _field('Website', _websiteCtrl, Icons.language, hint: 'https://...'),
              _field('Telegram', _telegramCtrl, Icons.send, hint: '@company_username'),
              _field('Location', _locationCtrl, Icons.location_on_outlined, hint: 'Malta, Cyprus...'),

              const SizedBox(height: 20),

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

              _sectionTitle(AppStrings.t('employer_filters')),
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

              Text(AppStrings.t('candidate_location_pref'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
              const SizedBox(height: 8),
              Row(children: [
                _prefChip('all', AppStrings.t('all_candidates')),
                const SizedBox(width: 8),
                _prefChip('outside', AppStrings.t('outside_citizenship')),
              ]),

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

  Widget _prefChip(String value, String label) {
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

  Widget _field(String label, TextEditingController ctrl, IconData icon, {int maxLines = 1, String? hint, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctrl, maxLines: maxLines, validator: validator,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20, color: context.textHintC),
              hintText: hint, hintStyle: TextStyle(color: context.textHintC, fontSize: 14),
              filled: true, fillColor: context.inputFill,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
            ),
          ),
        ],
      ),
    );
  }
}
