import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import '../../../providers/auth_provider.dart';
import 'resume_builder_screen.dart';

class CvScreen extends StatefulWidget {
  const CvScreen({super.key});

  @override
  State<CvScreen> createState() => _CvScreenState();
}

class _CvScreenState extends State<CvScreen> {
  final List<_CvEntry> _cvList = [];
  bool _uploading = false;

  static const List<String> _categoryOptions = [
    'gambling', 'betting', 'crypto', 'nutra', 'dating', 'ecommerce', 'fintech', 'other',
  ];

  Future<void> _uploadCv() async {
    final categories = await _showCategoryPicker();
    if (categories == null || categories.isEmpty) return;

    setState(() => _uploading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _uploading = false;
        _cvList.add(_CvEntry(
          fileName: 'CV_${DateTime.now().millisecondsSinceEpoch ~/ 1000}.pdf',
          categories: categories,
          uploadedAt: DateTime.now(),
        ));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.t('cv_uploaded')),
          backgroundColor: GuroJobsTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Future<List<String>?> _showCategoryPicker() async {
    final selected = <String>{};
    return showModalBottomSheet<List<String>>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: context.cardBg,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  Text(AppStrings.t('select_cv_categories'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                  const SizedBox(height: 6),
                  Text(AppStrings.t('select_cv_categories_desc'), textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: _categoryOptions.map((key) {
                      final isSelected = selected.contains(key);
                      return GestureDetector(
                        onTap: () => setSheetState(() { if (isSelected) selected.remove(key); else selected.add(key); }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? GuroJobsTheme.primary : context.surfaceBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? GuroJobsTheme.primary : context.dividerC),
                          ),
                          child: Text(AppStrings.t(key), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : context.textSecondaryC)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, height: 50,
                    child: ElevatedButton(
                      onPressed: selected.isEmpty ? null : () => Navigator.pop(ctx, selected.toList()),
                      style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0,
                        disabledBackgroundColor: GuroJobsTheme.primary.withOpacity(0.3)),
                      child: Text(AppStrings.t('upload_cv'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _removeCv(int index) {
    setState(() => _cvList.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.t('cv_removed')), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t('my_cv')),
        actions: [
          IconButton(
            onPressed: _uploading ? null : _uploadCv,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: AppStrings.t('upload_cv'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_cvList.isEmpty)
              _buildEmptyUpload()
            else ...[
              Row(children: [
                Icon(Icons.description, size: 20, color: context.textSecondaryC),
                const SizedBox(width: 8),
                Text('${_cvList.length} ${AppStrings.t('cv_slots')}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textSecondaryC)),
              ]),
              const SizedBox(height: 16),
              ...List.generate(_cvList.length, (i) => _buildCvCard(i)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _uploading ? null : _uploadCv,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: GuroJobsTheme.primary.withOpacity(0.3), width: 1.5),
                    color: GuroJobsTheme.primary.withOpacity(0.04),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline, size: 20, color: GuroJobsTheme.primary.withOpacity(0.6)),
                      const SizedBox(width: 8),
                      Text(AppStrings.t('upload_another_cv'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: GuroJobsTheme.primary.withOpacity(0.8))),
                    ],
                  ),
                ),
              ),
              // ── Integrations ──
              const SizedBox(height: 24),
              Row(children: [
                Icon(Icons.extension_outlined, size: 20, color: const Color(0xFF7C3AED)),
                const SizedBox(width: 8),
                Text(AppStrings.t('integrations'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
              ]),
              const SizedBox(height: 10),
              _buildIntegrationTile('N', AppStrings.t('notion_connect'), AppStrings.t('notion_desc'), const Color(0xFF000000), Colors.white),
              const SizedBox(height: 8),
              _buildIntegrationTile('O', AppStrings.t('obsidian_connect'), AppStrings.t('obsidian_desc'), const Color(0xFF7C3AED), Colors.white),
              const SizedBox(height: 8),
              _buildIntegrationTile('G', AppStrings.t('gdrive_connect'), AppStrings.t('gdrive_desc'), const Color(0xFF4285F4), Colors.white),
              const SizedBox(height: 8),
              _buildIntegrationTile('S', AppStrings.t('gsheets_connect'), AppStrings.t('gsheets_desc'), const Color(0xFF0F9D58), Colors.white),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ── Integration Tile ──
  Widget _buildIntegrationTile(String icon, String label, String desc, Color color, Color textColor) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          const Icon(Icons.rocket_launch, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(AppStrings.t('coming_soon'), style: const TextStyle(fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: GuroJobsTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      )),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(icon, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textColor))),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
              Text(desc, style: TextStyle(fontSize: 11, color: context.textSecondaryC)),
            ],
          )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(AppStrings.t('coming_soon'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: GuroJobsTheme.primary)),
          ),
        ]),
      ),
    );
  }

  // ── Empty Upload State ──
  Widget _buildEmptyUpload() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: context.cardBg, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.dividerC),
        boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), shape: BoxShape.circle),
          child: const Icon(Icons.cloud_upload_outlined, size: 40, color: GuroJobsTheme.primary),
        ),
        const SizedBox(height: 20),
        Text(AppStrings.t('upload_cv'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
        const SizedBox(height: 8),
        Text(AppStrings.t('upload_cv_desc'), textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
        const SizedBox(height: 4),
        Text(AppStrings.t('upload_cv_formats'), style: TextStyle(fontSize: 12, color: context.textHintC)),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity, height: 52,
          child: ElevatedButton.icon(
            onPressed: _uploading ? null : _uploadCv,
            icon: _uploading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.upload_file),
            label: Text(_uploading ? AppStrings.t('uploading') : AppStrings.t('choose_file')),
            style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: Divider(color: context.dividerC)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(AppStrings.t('or'), style: TextStyle(fontSize: 13, color: context.textHintC)),
            ),
            Expanded(child: Divider(color: context.dividerC)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity, height: 52,
          child: OutlinedButton.icon(
            onPressed: _openCvBuilder,
            icon: const Icon(Icons.edit_document, size: 20),
            label: Text(AppStrings.t('create_cv')),
            style: OutlinedButton.styleFrom(
              foregroundColor: GuroJobsTheme.primary,
              side: const BorderSide(color: GuroJobsTheme.primary, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(AppStrings.t('create_cv_desc'), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: context.textHintC)),
      ]),
    );
  }

  // ── CV Card ──
  Widget _buildCvCard(int index) {
    final cv = _cvList[index];
    return GestureDetector(
      onTap: () => _openCvPreview(cv),
      child: Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GuroJobsTheme.success.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.picture_as_pdf, color: GuroJobsTheme.error, size: 22),
            const SizedBox(width: 10),
            Expanded(child: Text(cv.fileName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC))),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: context.textHintC, size: 20),
              onSelected: (v) {
                if (v == 'edit') _editCv(index);
                if (v == 'replace') _uploadCv();
                if (v == 'remove') _removeCv(index);
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 18, color: context.textSecondaryC), const SizedBox(width: 8), const Text('Edit')])),
                PopupMenuItem(value: 'replace', child: Row(children: [Icon(Icons.swap_horiz, size: 18, color: context.textSecondaryC), const SizedBox(width: 8), Text(AppStrings.t('replace'))])),
                PopupMenuItem(value: 'remove', child: Row(children: [const Icon(Icons.delete_outline, size: 18, color: GuroJobsTheme.error), const SizedBox(width: 8), Text(AppStrings.t('remove'), style: const TextStyle(color: GuroJobsTheme.error))])),
              ],
            ),
          ]),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6, runSpacing: 6,
            children: cv.categories.map((cat) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Text(AppStrings.t(cat), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: GuroJobsTheme.primary)),
            )).toList(),
          ),
          const SizedBox(height: 8),
          Text('${AppStrings.t('uploaded')} ${_formatDate(cv.uploadedAt)}', style: TextStyle(fontSize: 11, color: context.textHintC)),
        ],
      ),
    ));
  }

  void _editCv(int index) {
    final cv = _cvList[index];
    final nameCtrl = TextEditingController(text: cv.fileName);
    final selectedCats = <String>{...cv.categories};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: context.cardBg,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text('Edit CV', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
              const SizedBox(height: 20),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'File name',
                  prefixIcon: const Icon(Icons.description_outlined, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(AppStrings.t('select_cv_categories'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: _categoryOptions.map((key) {
                  final isSelected = selectedCats.contains(key);
                  return GestureDetector(
                    onTap: () => setSheetState(() { if (isSelected) selectedCats.remove(key); else selectedCats.add(key); }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? GuroJobsTheme.primary : context.surfaceBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? GuroJobsTheme.primary : context.dividerC),
                      ),
                      child: Text(AppStrings.t(key), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : context.textSecondaryC)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: selectedCats.isEmpty ? null : () {
                    setState(() {
                      cv.fileName = nameCtrl.text.trim().isEmpty ? cv.fileName : nameCtrl.text.trim();
                      cv.categories = selectedCats.toList();
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('CV updated!'),
                      backgroundColor: GuroJobsTheme.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0,
                    disabledBackgroundColor: GuroJobsTheme.primary.withOpacity(0.3)),
                  child: Text(AppStrings.t('save'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCvPreview(_CvEntry cv) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: context.cardBg,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, sc) => Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                const Icon(Icons.picture_as_pdf, color: GuroJobsTheme.error, size: 28),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cv.fileName, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                    const SizedBox(height: 2),
                    Text('${AppStrings.t('uploaded')} ${_formatDate(cv.uploadedAt)}', style: TextStyle(fontSize: 12, color: context.textHintC)),
                  ],
                )),
                IconButton(onPressed: () => Navigator.pop(ctx), icon: Icon(Icons.close, color: context.textHintC)),
              ]),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 6, runSpacing: 6,
                children: cv.categories.map((cat) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(AppStrings.t(cat), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: GuroJobsTheme.primary)),
                )).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: context.dividerC, height: 1),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.description_outlined, size: 80, color: context.textHintC.withOpacity(0.4)),
                    const SizedBox(height: 16),
                    Text(cv.fileName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                    const SizedBox(height: 8),
                    Text('PDF Document', style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _uploadCv();
                    },
                    icon: const Icon(Icons.swap_horiz, size: 18),
                    label: Text(AppStrings.t('replace')),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: context.dividerC),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      final idx = _cvList.indexOf(cv);
                      if (idx >= 0) _editCv(idx);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GuroJobsTheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  // ── CV Builder ──

  void _openCvBuilder() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ResumeBuilderScreen()));
  }

  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}

class _CvEntry {
  String fileName;
  List<String> categories;
  final DateTime uploadedAt;
  _CvEntry({required this.fileName, required this.categories, required this.uploadedAt});
}

// ═══════════════════════════════════════════════════════════════
// CV BUILDER SCREEN
// ═══════════════════════════════════════════════════════════════

class _ExpEntry {
  final TextEditingController company = TextEditingController();
  final TextEditingController position = TextEditingController();
  final TextEditingController period = TextEditingController();
  final TextEditingController description = TextEditingController();
}

class _EduEntry {
  final TextEditingController institution = TextEditingController();
  final TextEditingController degree = TextEditingController();
  final TextEditingController period = TextEditingController();
}

class _MessengerEntry {
  final String name;
  final TextEditingController controller;
  _MessengerEntry({required this.name, required this.controller});
}

class _MessengerMeta {
  final IconData icon;
  final Color color;
  const _MessengerMeta(this.icon, this.color);
}

class _CvBuilderScreen extends StatefulWidget {
  final ValueChanged<_CvEntry> onCreated;
  const _CvBuilderScreen({required this.onCreated});

  @override
  State<_CvBuilderScreen> createState() => _CvBuilderScreenState();
}

class _CvBuilderScreenState extends State<_CvBuilderScreen> {
  final _positionCtrl = TextEditingController();
  final _aboutCtrl = TextEditingController();
  final _skillCtrl = TextEditingController();
  final _salaryCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _customCountryCtrl = TextEditingController();

  // Messengers
  final List<_MessengerEntry> _messengers = [
    _MessengerEntry(name: 'Telegram', controller: TextEditingController()),
    _MessengerEntry(name: 'WhatsApp', controller: TextEditingController()),
  ];

  final List<String> _skills = [];
  final Set<String> _selectedVerticals = {};
  String _experience = '';
  String _workSetup = '';
  String _englishLevel = '';
  String _geo = '';
  final List<_ExpEntry> _experiences = [];
  final List<_EduEntry> _educations = [];

  static const _verticals = ['gambling', 'betting', 'crypto', 'nutra', 'dating', 'ecommerce', 'fintech', 'other'];
  static const _expLevels = ['no_experience', 'year_1', 'years_2', 'years_3', 'years_5', 'years_10_plus'];
  static const _workSetups = ['remote', 'office', 'hybrid'];
  static const _engLevels = ['no_english', 'beginner', 'intermediate', 'upper_intermediate', 'advanced', 'native_speaker'];
  static const _geoOptions = ['worldwide', 'eu_countries', 'other_countries'];

  void _addSkill() {
    final s = _skillCtrl.text.trim();
    if (s.isNotEmpty && !_skills.contains(s)) {
      setState(() => _skills.add(s));
      _skillCtrl.clear();
    }
  }

  void _generate() {
    if (_positionCtrl.text.trim().isEmpty || _selectedVerticals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppStrings.t('section_required')),
        backgroundColor: GuroJobsTheme.warning,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    final entry = _CvEntry(
      fileName: '${_positionCtrl.text.trim().replaceAll(' ', '_')}_CV.pdf',
      categories: _selectedVerticals.toList(),
      uploadedAt: DateTime.now(),
    );
    widget.onCreated(entry);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t('cv_builder'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Desired Position ──
            _sectionLabel(AppStrings.t('desired_position'), Icons.work_outline),
            const SizedBox(height: 8),
            _textField(_positionCtrl, AppStrings.t('desired_position_hint')),
            const SizedBox(height: 24),

            // ── Verticals ──
            _sectionLabel(AppStrings.t('verticals'), Icons.category_outlined),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _verticals.map((v) => _chipSelect(
                AppStrings.t(v), _selectedVerticals.contains(v),
                () => setState(() { if (_selectedVerticals.contains(v)) _selectedVerticals.remove(v); else _selectedVerticals.add(v); }),
              )).toList(),
            ),
            const SizedBox(height: 24),

            // ── About Me ──
            _sectionLabel(AppStrings.t('about_me'), Icons.person_outline),
            const SizedBox(height: 8),
            _textField(_aboutCtrl, AppStrings.t('about_me_hint'), maxLines: 4),
            const SizedBox(height: 24),

            // ── Skills ──
            _sectionLabel(AppStrings.t('skills'), Icons.psychology_outlined),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _textField(_skillCtrl, AppStrings.t('skills_hint'), onSubmit: (_) => _addSkill())),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _addSkill,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(color: GuroJobsTheme.primary, borderRadius: BorderRadius.circular(10)),
                    child: Text(AppStrings.t('add_skill'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
            if (_skills.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6, runSpacing: 6,
                children: _skills.asMap().entries.map((e) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(e.value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: GuroJobsTheme.primary)),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => setState(() => _skills.removeAt(e.key)),
                        child: const Icon(Icons.close, size: 14, color: GuroJobsTheme.primary),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ],
            const SizedBox(height: 24),

            // ── Experience Level ──
            _sectionLabel(AppStrings.t('experience'), Icons.trending_up),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _expLevels.map((l) => _chipSelect(
                AppStrings.t(l), _experience == l, () => setState(() => _experience = l),
              )).toList(),
            ),
            const SizedBox(height: 24),

            // ── Work Experience Entries ──
            _sectionLabel(AppStrings.t('work_experience'), Icons.business_center_outlined),
            const SizedBox(height: 8),
            ..._experiences.asMap().entries.map((e) => _buildExpCard(e.key)),
            GestureDetector(
              onTap: () => setState(() => _experiences.add(_ExpEntry())),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: GuroJobsTheme.primary.withOpacity(0.3)),
                  color: GuroJobsTheme.primary.withOpacity(0.04),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, size: 18, color: GuroJobsTheme.primary),
                    const SizedBox(width: 6),
                    Text(AppStrings.t('add_experience'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: GuroJobsTheme.primary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Education ──
            _sectionLabel(AppStrings.t('education'), Icons.school_outlined),
            const SizedBox(height: 8),
            ..._educations.asMap().entries.map((e) => _buildEduCard(e.key)),
            GestureDetector(
              onTap: () => setState(() => _educations.add(_EduEntry())),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: GuroJobsTheme.primary.withOpacity(0.3)),
                  color: GuroJobsTheme.primary.withOpacity(0.04),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, size: 18, color: GuroJobsTheme.primary),
                    const SizedBox(width: 6),
                    Text(AppStrings.t('add_education'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: GuroJobsTheme.primary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Work Setup ──
            _sectionLabel(AppStrings.t('work_setup'), Icons.laptop_mac_outlined),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _workSetups.map((w) => _chipSelect(
                AppStrings.t(w), _workSetup == w, () => setState(() => _workSetup = w),
              )).toList(),
            ),
            const SizedBox(height: 24),

            // ── English Level ──
            _sectionLabel(AppStrings.t('english_level'), Icons.language),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _engLevels.map((l) => _chipSelect(
                AppStrings.t(l), _englishLevel == l, () => setState(() => _englishLevel = l),
              )).toList(),
            ),
            const SizedBox(height: 24),

            // ── Salary & Geo ──
            Row(
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel(AppStrings.t('salary_expectation'), Icons.monetization_on_outlined),
                    const SizedBox(height: 8),
                    _textField(_salaryCtrl, AppStrings.t('salary_hint')),
                  ],
                )),
              ],
            ),
            const SizedBox(height: 24),

            _sectionLabel(AppStrings.t('preferred_geo'), Icons.public),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _geoOptions.map((g) => _chipSelect(
                AppStrings.t(g), _geo == g, () => setState(() => _geo = g),
              )).toList(),
            ),
            if (_geo == 'other_countries') ...[
              const SizedBox(height: 10),
              _textField(_customCountryCtrl, AppStrings.t('country_hint'), prefixIcon: Icons.flag_outlined),
            ],
            const SizedBox(height: 24),

            // ── Contact Info ──
            _sectionLabel(AppStrings.t('contact_info'), Icons.contact_phone_outlined),
            const SizedBox(height: 8),
            _textField(_phoneCtrl, AppStrings.t('phone_hint'), prefixIcon: Icons.phone),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: GuroJobsTheme.info.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const Icon(Icons.email_outlined, size: 18, color: GuroJobsTheme.info),
                  const SizedBox(width: 10),
                  Text(auth.userEmail ?? 'email', style: TextStyle(fontSize: 14, color: context.textPrimaryC)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Messengers
            Row(
              children: [
                Icon(Icons.chat_bubble_outline, size: 18, color: GuroJobsTheme.primary),
                const SizedBox(width: 8),
                Text(AppStrings.t('messengers'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                const Spacer(),
                GestureDetector(
                  onTap: _addMessenger,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 16, color: GuroJobsTheme.primary),
                        SizedBox(width: 4),
                        Icon(Icons.messenger_outline, size: 14, color: GuroJobsTheme.primary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ..._messengers.asMap().entries.map((e) => _buildMessengerRow(e.key)),
            const SizedBox(height: 32),

            // ── Generate ──
            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton.icon(
                onPressed: _generate,
                icon: const Icon(Icons.auto_awesome, size: 20),
                label: Text(AppStrings.t('generate_cv'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: GuroJobsTheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ── Messenger helpers ──

  static final Map<String, _MessengerMeta> _messengerIcons = {
    'telegram': _MessengerMeta(Icons.send, const Color(0xFF26A5E4)),
    'whatsapp': _MessengerMeta(Icons.chat, const Color(0xFF25D366)),
    'viber': _MessengerMeta(Icons.phone_in_talk, const Color(0xFF7360F2)),
    'signal': _MessengerMeta(Icons.security, const Color(0xFF3A76F0)),
    'discord': _MessengerMeta(Icons.headset_mic, const Color(0xFF5865F2)),
    'skype': _MessengerMeta(Icons.video_call, const Color(0xFF00AFF0)),
    'wechat': _MessengerMeta(Icons.message, const Color(0xFF07C160)),
    'line': _MessengerMeta(Icons.chat_bubble, const Color(0xFF00B900)),
    'slack': _MessengerMeta(Icons.tag, const Color(0xFF4A154B)),
    'messenger': _MessengerMeta(Icons.messenger_outline, const Color(0xFF006AFF)),
    'imessage': _MessengerMeta(Icons.textsms, const Color(0xFF34C759)),
    'kakaotalk': _MessengerMeta(Icons.chat_bubble_outline, const Color(0xFFFAE100)),
  };

  static _MessengerMeta _getMessengerMeta(String name) {
    final key = name.toLowerCase().replaceAll(' ', '');
    for (final entry in _messengerIcons.entries) {
      if (key.contains(entry.key)) return entry.value;
    }
    return _MessengerMeta(Icons.chat_outlined, GuroJobsTheme.textHint);
  }

  Widget _buildMessengerRow(int index) {
    final m = _messengers[index];
    final meta = _getMessengerMeta(m.name);
    final isDefault = index < 2; // Telegram & WhatsApp are defaults

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: meta.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(meta.icon, size: 18, color: meta.color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: m.controller,
              style: TextStyle(fontSize: 14, color: context.textPrimaryC),
              decoration: InputDecoration(
                hintText: m.name,
                hintStyle: TextStyle(color: context.textHintC),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.dividerC)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.dividerC)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: meta.color, width: 1.5)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                isDense: true,
              ),
            ),
          ),
          if (!isDefault) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => setState(() => _messengers.removeAt(index)),
              child: Icon(Icons.close, size: 18, color: GuroJobsTheme.error.withOpacity(0.6)),
            ),
          ],
        ],
      ),
    );
  }

  void _addMessenger() {
    final nameCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDialog) {
          final preview = nameCtrl.text.trim();
          final meta = preview.isNotEmpty ? _getMessengerMeta(preview) : _MessengerMeta(Icons.chat_outlined, context.textHintC);

          return Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
            decoration: BoxDecoration(
              color: context.isDark ? GuroJobsTheme.darkCard : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.t('add_messenger'), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: meta.color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                      child: Icon(meta.icon, size: 22, color: meta.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: nameCtrl,
                        autofocus: true,
                        onChanged: (_) => setDialog(() {}),
                        style: TextStyle(fontSize: 14, color: context.textPrimaryC),
                        decoration: InputDecoration(
                          hintText: AppStrings.t('messenger_name_hint'),
                          hintStyle: TextStyle(color: context.textHintC),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Quick suggestions
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: ['Viber', 'Signal', 'Discord', 'Skype', 'WeChat', 'Line'].map((name) {
                    final sMeta = _getMessengerMeta(name);
                    return GestureDetector(
                      onTap: () {
                        nameCtrl.text = name;
                        setDialog(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: sMeta.color.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: sMeta.color.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(sMeta.icon, size: 14, color: sMeta.color),
                            const SizedBox(width: 4),
                            Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: sMeta.color)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: nameCtrl.text.trim().isEmpty ? null : () {
                      setState(() => _messengers.add(_MessengerEntry(name: nameCtrl.text.trim(), controller: TextEditingController())));
                      Navigator.pop(ctx);
                    },
                    child: Text(AppStrings.t('save')),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: GuroJobsTheme.primary),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
      ],
    );
  }

  Widget _textField(TextEditingController ctrl, String hint, {int maxLines = 1, IconData? prefixIcon, ValueChanged<String>? onSubmit}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      onSubmitted: onSubmit,
      style: TextStyle(fontSize: 14, color: context.textPrimaryC),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: context.textHintC),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18, color: context.textHintC) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.dividerC)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.dividerC)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: GuroJobsTheme.primary, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _chipSelect(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? GuroJobsTheme.primary : context.surfaceBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? GuroJobsTheme.primary : context.dividerC),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: active ? Colors.white : context.textSecondaryC)),
      ),
    );
  }

  Widget _buildExpCard(int index) {
    final exp = _experiences[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.dividerC),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('${AppStrings.t('work_experience')} ${index + 1}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC))),
              GestureDetector(
                onTap: () => setState(() => _experiences.removeAt(index)),
                child: Icon(Icons.delete_outline, size: 18, color: GuroJobsTheme.error.withOpacity(0.7)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _textField(exp.company, AppStrings.t('company_name'), prefixIcon: Icons.business),
          const SizedBox(height: 8),
          _textField(exp.position, AppStrings.t('position_title'), prefixIcon: Icons.badge_outlined),
          const SizedBox(height: 8),
          _textField(exp.period, AppStrings.t('period_hint'), prefixIcon: Icons.date_range),
          const SizedBox(height: 8),
          _textField(exp.description, AppStrings.t('description_hint'), maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildEduCard(int index) {
    final edu = _educations[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.dividerC),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('${AppStrings.t('education')} ${index + 1}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC))),
              GestureDetector(
                onTap: () => setState(() => _educations.removeAt(index)),
                child: Icon(Icons.delete_outline, size: 18, color: GuroJobsTheme.error.withOpacity(0.7)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _textField(edu.institution, AppStrings.t('institution'), prefixIcon: Icons.school_outlined),
          const SizedBox(height: 8),
          _textField(edu.degree, AppStrings.t('degree'), prefixIcon: Icons.menu_book),
          const SizedBox(height: 8),
          _textField(edu.period, AppStrings.t('period_hint'), prefixIcon: Icons.date_range),
        ],
      ),
    );
  }
}
