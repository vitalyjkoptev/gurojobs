import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../services/api_service.dart';

class ResumeBuilderScreen extends StatefulWidget {
  const ResumeBuilderScreen({super.key});

  @override
  State<ResumeBuilderScreen> createState() => _ResumeBuilderScreenState();
}

class _ResumeBuilderScreenState extends State<ResumeBuilderScreen> {
  bool _loading = true;
  Map<String, dynamic> _resume = {};
  String _selectedTemplate = 'classic';
  String? _resumeUpdatedAt;

  // Personal
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _summaryCtrl = TextEditingController();

  // Skills
  final _skillCtrl = TextEditingController();
  List<String> _skills = [];

  // Experience
  List<Map<String, dynamic>> _experience = [];

  // Education
  List<Map<String, dynamic>> _education = [];

  // Links
  final _linkedinCtrl = TextEditingController();
  final _githubCtrl = TextEditingController();
  final _portfolioCtrl = TextEditingController();
  final _telegramCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResume();
  }

  Future<void> _loadResume() async {
    try {
      final res = await ApiService.getResume();
      if (res['success'] == true && res['data'] != null) {
        final data = res['data'];
        final r = data['resume'] ?? {};
        setState(() {
          _resume = r;
          _resumeUpdatedAt = data['resume_updated_at'];
          _selectedTemplate = r['template'] ?? 'classic';
          final p = r['personal'] ?? {};
          _nameCtrl.text = p['full_name'] ?? '';
          _emailCtrl.text = p['email'] ?? '';
          _phoneCtrl.text = p['phone'] ?? '';
          _locationCtrl.text = p['location'] ?? '';
          _summaryCtrl.text = p['summary'] ?? '';
          _skills = List<String>.from(r['skills'] ?? []);
          _experience = List<Map<String, dynamic>>.from(
            (r['experience'] ?? []).map((e) => Map<String, dynamic>.from(e)),
          );
          _education = List<Map<String, dynamic>>.from(
            (r['education'] ?? []).map((e) => Map<String, dynamic>.from(e)),
          );
          final links = r['links'] ?? {};
          _linkedinCtrl.text = links['linkedin'] ?? '';
          _githubCtrl.text = links['github'] ?? '';
          _portfolioCtrl.text = links['portfolio'] ?? '';
          _telegramCtrl.text = links['telegram'] ?? '';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveResume() async {
    setState(() => _loading = true);
    try {
      final data = {
        'personal': {
          'full_name': _nameCtrl.text,
          'email': _emailCtrl.text,
          'phone': _phoneCtrl.text,
          'location': _locationCtrl.text,
          'summary': _summaryCtrl.text,
        },
        'skills': _skills,
        'experience': _experience,
        'education': _education,
        'links': {
          'linkedin': _linkedinCtrl.text,
          'github': _githubCtrl.text,
          'portfolio': _portfolioCtrl.text,
          'telegram': _telegramCtrl.text,
        },
        'template': _selectedTemplate,
      };
      final res = await ApiService.updateResume(data);
      if (res['success'] == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resume saved'), backgroundColor: Colors.green),
        );
        _resumeUpdatedAt = res['data']?['resume_updated_at'];
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _locationCtrl.dispose(); _summaryCtrl.dispose(); _skillCtrl.dispose();
    _linkedinCtrl.dispose(); _githubCtrl.dispose();
    _portfolioCtrl.dispose(); _telegramCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Builder'),
        backgroundColor: GuroJobsTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Preview PDF',
            onPressed: () => _showPreview(context),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _loading ? null : _saveResume,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Template selector
                  _sectionTitle('Template'),
                  const SizedBox(height: 8),
                  Row(
                    children: ['classic', 'modern', 'minimal'].map((t) {
                      final sel = t == _selectedTemplate;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(t[0].toUpperCase() + t.substring(1)),
                            selected: sel,
                            selectedColor: GuroJobsTheme.primary,
                            labelStyle: TextStyle(color: sel ? Colors.white : null),
                            onSelected: (_) => setState(() => _selectedTemplate = t),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (_resumeUpdatedAt != null) ...[
                    const SizedBox(height: 8),
                    Text('Last updated: ${_resumeUpdatedAt!.substring(0, 10)}',
                        style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
                  ],
                  const SizedBox(height: 20),

                  // Personal
                  _sectionTitle('Personal Info'),
                  const SizedBox(height: 8),
                  _field(_nameCtrl, 'Full Name', Icons.person),
                  _field(_emailCtrl, 'Email', Icons.email),
                  _field(_phoneCtrl, 'Phone', Icons.phone),
                  _field(_locationCtrl, 'Location', Icons.location_on),
                  _field(_summaryCtrl, 'Professional Summary', Icons.description, maxLines: 4),
                  const SizedBox(height: 20),

                  // Skills
                  _sectionTitle('Skills'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6, runSpacing: 6,
                    children: _skills.map((s) => Chip(
                      label: Text(s, style: const TextStyle(fontSize: 13)),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => setState(() => _skills.remove(s)),
                      backgroundColor: GuroJobsTheme.primary.withOpacity(0.1),
                    )).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _field(_skillCtrl, 'Add skill...', Icons.add)),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.add_circle, color: GuroJobsTheme.primary),
                        onPressed: () {
                          if (_skillCtrl.text.isNotEmpty) {
                            setState(() => _skills.add(_skillCtrl.text.trim()));
                            _skillCtrl.clear();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Experience
                  _sectionTitle('Experience'),
                  const SizedBox(height: 8),
                  ..._experience.asMap().entries.map((e) => _experienceCard(e.key, e.value)),
                  TextButton.icon(
                    onPressed: () => setState(() => _experience.add({
                      'company': '', 'position': '', 'start_date': '', 'end_date': '', 'current': false, 'description': '',
                    })),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Experience'),
                  ),
                  const SizedBox(height: 20),

                  // Education
                  _sectionTitle('Education'),
                  const SizedBox(height: 8),
                  ..._education.asMap().entries.map((e) => _educationCard(e.key, e.value)),
                  TextButton.icon(
                    onPressed: () => setState(() => _education.add({
                      'institution': '', 'degree': '', 'field': '', 'start_year': '', 'end_year': '',
                    })),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Education'),
                  ),
                  const SizedBox(height: 20),

                  // Links
                  _sectionTitle('Links'),
                  const SizedBox(height: 8),
                  _field(_linkedinCtrl, 'LinkedIn', Icons.link),
                  _field(_githubCtrl, 'GitHub', Icons.code),
                  _field(_portfolioCtrl, 'Portfolio', Icons.web),
                  _field(_telegramCtrl, 'Telegram', Icons.send),
                  const SizedBox(height: 24),

                  // Save
                  SizedBox(
                    width: double.infinity, height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _loading ? null : _saveResume,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Resume', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GuroJobsTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _sectionTitle(String title) => Text(
    title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC),
  );

  Widget _field(TextEditingController ctrl, String label, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          filled: true, fillColor: context.cardBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
        ),
      ),
    );
  }

  Widget _experienceCard(int idx, Map<String, dynamic> exp) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text('Experience ${idx + 1}', style: const TextStyle(fontWeight: FontWeight.w600))),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => setState(() => _experience.removeAt(idx))),
              ],
            ),
            _expField(idx, 'position', 'Position'),
            _expField(idx, 'company', 'Company'),
            Row(children: [
              Expanded(child: _expField(idx, 'start_date', 'Start')),
              const SizedBox(width: 8),
              Expanded(child: _expField(idx, 'end_date', 'End')),
            ]),
            _expField(idx, 'description', 'Description', maxLines: 2),
          ],
        ),
      ),
    );
  }

  Widget _expField(int idx, String key, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        initialValue: _experience[idx][key]?.toString() ?? '',
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (v) => _experience[idx][key] = v,
      ),
    );
  }

  Widget _educationCard(int idx, Map<String, dynamic> edu) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text('Education ${idx + 1}', style: const TextStyle(fontWeight: FontWeight.w600))),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => setState(() => _education.removeAt(idx))),
              ],
            ),
            _eduField(idx, 'institution', 'Institution'),
            _eduField(idx, 'degree', 'Degree'),
            _eduField(idx, 'field', 'Field of Study'),
            Row(children: [
              Expanded(child: _eduField(idx, 'start_year', 'Start Year')),
              const SizedBox(width: 8),
              Expanded(child: _eduField(idx, 'end_year', 'End Year')),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _eduField(int idx, String key, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        initialValue: _education[idx][key]?.toString() ?? '',
        decoration: InputDecoration(labelText: label, isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (v) => _education[idx][key] = v,
      ),
    );
  }

  void _showPreview(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const Text('Resume Preview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_nameCtrl.text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: GuroJobsTheme.primary)),
                      const SizedBox(height: 4),
                      Text([_emailCtrl.text, _phoneCtrl.text, _locationCtrl.text].where((s) => s.isNotEmpty).join(' | '),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      if (_summaryCtrl.text.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(_summaryCtrl.text, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                      ],
                      if (_skills.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text('SKILLS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary, letterSpacing: 1)),
                        const SizedBox(height: 6),
                        Wrap(spacing: 6, runSpacing: 4, children: _skills.map((s) =>
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                            child: Text(s, style: TextStyle(fontSize: 11, color: GuroJobsTheme.primary)),
                          ),
                        ).toList()),
                      ],
                      if (_experience.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text('EXPERIENCE', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary, letterSpacing: 1)),
                        ..._experience.map((e) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(e['position'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text('${e['company'] ?? ''} | ${e['start_date'] ?? ''} — ${e['current'] == true ? 'Present' : e['end_date'] ?? ''}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            if ((e['description'] ?? '').isNotEmpty)
                              Text(e['description'], style: const TextStyle(fontSize: 12)),
                          ]),
                        )),
                      ],
                      if (_education.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text('EDUCATION', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary, letterSpacing: 1)),
                        ..._education.map((e) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('${e['degree'] ?? ''} — ${e['field'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text('${e['institution'] ?? ''} | ${e['start_year'] ?? ''}–${e['end_year'] ?? ''}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ]),
                        )),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
