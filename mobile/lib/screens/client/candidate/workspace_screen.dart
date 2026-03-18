import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  final List<Map<String, String>> _notes = [];
  final List<Map<String, String>> _drafts = [];

  // Simulated uploaded CVs (shared state would come from provider in real app)
  final List<_CvEntry> _uploadedCvs = [];

  static const List<String> _categoryOptions = [
    'gambling', 'betting', 'crypto', 'nutra', 'dating', 'ecommerce', 'fintech', 'other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t('workspace')),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.add_circle_outline),
            onSelected: (v) {
              if (v == 'note') _showNewNoteDialog();
              if (v == 'draft') _showNewDraftDialog();
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'note', child: Row(children: [
                const Icon(Icons.sticky_note_2_outlined, size: 18, color: Color(0xFFFFA726)),
                const SizedBox(width: 10),
                Text(AppStrings.t('new_note')),
              ])),
              PopupMenuItem(value: 'draft', child: Row(children: [
                const Icon(Icons.drafts_outlined, size: 18, color: Color(0xFF42A5F5)),
                const SizedBox(width: 10),
                Text(AppStrings.t('new_draft')),
              ])),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Uploaded CVs ──
            if (_uploadedCvs.isNotEmpty) ...[
              _sectionTitle(Icons.description, AppStrings.t('my_cv'), GuroJobsTheme.primary),
              const SizedBox(height: 10),
              ...List.generate(_uploadedCvs.length, (i) => _buildCvCard(i)),
              const SizedBox(height: 24),
            ],

            // ── Notes & Drafts ──
            Row(children: [
              Expanded(child: _WorkspaceCard(
                icon: Icons.sticky_note_2_outlined,
                label: AppStrings.t('notes'),
                desc: AppStrings.t('notes_desc'),
                count: _notes.length,
                color: const Color(0xFFFFA726),
                onTap: _showNotesSheet,
              )),
              const SizedBox(width: 12),
              Expanded(child: _WorkspaceCard(
                icon: Icons.drafts_outlined,
                label: AppStrings.t('drafts'),
                desc: AppStrings.t('drafts_desc'),
                count: _drafts.length,
                color: const Color(0xFF42A5F5),
                onTap: _showDraftsSheet,
              )),
            ]),
            const SizedBox(height: 24),

            // ── Integrations ──
            _sectionTitle(Icons.extension_outlined, AppStrings.t('integrations'), const Color(0xFF7C3AED)),
            const SizedBox(height: 10),
            _IntegrationTile(
              icon: 'N',
              label: AppStrings.t('notion_connect'),
              desc: AppStrings.t('notion_desc'),
              color: const Color(0xFF000000),
              textColor: Colors.white,
              onTap: () => _showComingSoon(),
            ),
            const SizedBox(height: 8),
            _IntegrationTile(
              icon: 'O',
              label: AppStrings.t('obsidian_connect'),
              desc: AppStrings.t('obsidian_desc'),
              color: const Color(0xFF7C3AED),
              textColor: Colors.white,
              onTap: () => _showComingSoon(),
            ),
            const SizedBox(height: 8),
            _IntegrationTile(
              icon: 'G',
              label: AppStrings.t('gdrive_connect'),
              desc: AppStrings.t('gdrive_desc'),
              color: const Color(0xFF4285F4),
              textColor: Colors.white,
              onTap: () => _showComingSoon(),
            ),
            const SizedBox(height: 8),
            _IntegrationTile(
              icon: 'S',
              label: AppStrings.t('gsheets_connect'),
              desc: AppStrings.t('gsheets_desc'),
              color: const Color(0xFF0F9D58),
              textColor: Colors.white,
              onTap: () => _showComingSoon(),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title, Color color) {
    return Row(children: [
      Icon(icon, size: 20, color: color),
      const SizedBox(width: 8),
      Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
    ]);
  }

  // ── CV Card ──
  Widget _buildCvCard(int index) {
    final cv = _uploadedCvs[index];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GuroJobsTheme.success.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.picture_as_pdf, color: GuroJobsTheme.error, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(cv.fileName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC))),
            GestureDetector(
              onTap: () => setState(() => _uploadedCvs.removeAt(index)),
              child: Icon(Icons.close, size: 18, color: context.textHintC),
            ),
          ]),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6, runSpacing: 4,
            children: cv.categories.map((cat) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Text(AppStrings.t(cat), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: GuroJobsTheme.primary)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  // ── Notes Sheet ──
  void _showNotesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: context.cardBg,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            expand: false,
            builder: (_, scrollController) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  Row(children: [
                    const Icon(Icons.sticky_note_2, color: Color(0xFFFFA726), size: 24),
                    const SizedBox(width: 10),
                    Expanded(child: Text(AppStrings.t('notes'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        _showNewNoteDialog();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFFFA726).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.add, color: Color(0xFFFFA726), size: 22),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _notes.isEmpty
                        ? _emptyPlaceholder(Icons.note_alt_outlined, AppStrings.t('no_notes'), AppStrings.t('no_notes_desc'))
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: _notes.length,
                            itemBuilder: (_, i) => Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFA726).withOpacity(0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFFFA726).withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Expanded(child: Text(_notes[i]['title']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                                    GestureDetector(
                                      onTap: () { setState(() => _notes.removeAt(i)); setSheetState(() {}); },
                                      child: Icon(Icons.close, size: 16, color: Colors.grey[400]),
                                    ),
                                  ]),
                                  if (_notes[i]['body']!.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(_notes[i]['body']!, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
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
        });
      },
    );
  }

  // ── Drafts Sheet ──
  void _showDraftsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: context.cardBg,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.3,
            maxChildSize: 0.85,
            expand: false,
            builder: (_, scrollController) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  Row(children: [
                    const Icon(Icons.drafts, color: Color(0xFF42A5F5), size: 24),
                    const SizedBox(width: 10),
                    Expanded(child: Text(AppStrings.t('drafts'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        _showNewDraftDialog();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFF42A5F5).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.add, color: Color(0xFF42A5F5), size: 22),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _drafts.isEmpty
                        ? _emptyPlaceholder(Icons.drafts_outlined, AppStrings.t('no_drafts'), AppStrings.t('no_drafts_desc'))
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: _drafts.length,
                            itemBuilder: (_, i) => Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF42A5F5).withOpacity(0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF42A5F5).withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Expanded(child: Text(_drafts[i]['title']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                                    GestureDetector(
                                      onTap: () { setState(() => _drafts.removeAt(i)); setSheetState(() {}); },
                                      child: Icon(Icons.close, size: 16, color: Colors.grey[400]),
                                    ),
                                  ]),
                                  if (_drafts[i]['body']!.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(_drafts[i]['body']!, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
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
        });
      },
    );
  }

  Widget _emptyPlaceholder(IconData icon, String title, String desc) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[500])),
          const SizedBox(height: 4),
          Text(desc, style: TextStyle(fontSize: 13, color: Colors.grey[400])),
        ],
      ),
    );
  }

  // ── Dialogs ──
  void _showNewNoteDialog() {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppStrings.t('new_note')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: InputDecoration(hintText: AppStrings.t('notes'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 12),
            TextField(controller: bodyCtrl, maxLines: 4, decoration: InputDecoration(hintText: AppStrings.t('note_placeholder'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dCtx), child: Text(AppStrings.t('cancel'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFA726), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                setState(() => _notes.add({'title': titleCtrl.text.trim(), 'body': bodyCtrl.text.trim()}));
              }
              Navigator.pop(dCtx);
            },
            child: Text(AppStrings.t('save'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showNewDraftDialog() {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppStrings.t('new_draft')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: InputDecoration(hintText: AppStrings.t('drafts'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 12),
            TextField(controller: bodyCtrl, maxLines: 4, decoration: InputDecoration(hintText: AppStrings.t('note_placeholder'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dCtx), child: Text(AppStrings.t('cancel'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF42A5F5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                setState(() => _drafts.add({'title': titleCtrl.text.trim(), 'body': bodyCtrl.text.trim()}));
              }
              Navigator.pop(dCtx);
            },
            child: Text(AppStrings.t('save'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.rocket_launch, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(AppStrings.t('coming_soon'), style: const TextStyle(fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: GuroJobsTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ── Helper Widgets ──

class _WorkspaceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const _WorkspaceCard({required this.icon, required this.label, required this.desc, required this.count, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              if (count > 0) Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
                child: Text('$count', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ]),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 4),
            Text(desc, style: TextStyle(fontSize: 11, color: context.textSecondaryC), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _IntegrationTile extends StatelessWidget {
  final String icon;
  final String label;
  final String desc;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _IntegrationTile({required this.icon, required this.label, required this.desc, required this.color, required this.textColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
}

class _CvEntry {
  final String fileName;
  final List<String> categories;
  _CvEntry({required this.fileName, required this.categories});
}
