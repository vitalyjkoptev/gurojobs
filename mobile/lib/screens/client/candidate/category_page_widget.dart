import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import 'job_detail_screen.dart';

/// Shared widget for all 8 category info pages.
/// Shows: header → description → stats → roles → skills → jobs list → Guro School banner
class CategoryPageScreen extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String description;
  final List<String> roles;
  final List<String> skills;
  final List<Map<String, String>> stats;
  final List<Map<String, String>> jobs;

  const CategoryPageScreen({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.description,
    required this.roles,
    required this.skills,
    required this.stats,
    required this.jobs,
  });

  @override
  State<CategoryPageScreen> createState() => _CategoryPageScreenState();
}

class _CategoryPageScreenState extends State<CategoryPageScreen> {
  String _filter = 'All';
  final _searchCtrl = TextEditingController();

  List<Map<String, String>> get _filtered {
    var list = widget.jobs;
    final q = _searchCtrl.text.toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((j) => j['title']!.toLowerCase().contains(q) || j['company']!.toLowerCase().contains(q)).toList();
    }
    if (_filter == 'Remote') list = list.where((j) => j['location'] == 'Remote').toList();
    if (_filter == 'Full-time') list = list.where((j) => j['type'] == 'Full-time').toList();
    if (_filter == 'Senior') list = list.where((j) => j['title']!.contains('Senior')).toList();
    return list;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final filtered = _filtered;
    final filters = ['All', 'Remote', 'Full-time', 'Senior'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: widget.color,
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [widget.color, widget.color.withOpacity(0.7)])),
                child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const SizedBox(height: 36),
                  Icon(widget.icon, size: 44, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(widget.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
                ])),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Description
                _Card(isDark: isDark, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _sectionHeader(Icons.info_outline, AppStrings.t('what_is_it'), context),
                  const SizedBox(height: 10),
                  Text(widget.description, style: TextStyle(fontSize: 14, height: 1.55, color: context.textPrimaryC)),
                ])),
                const SizedBox(height: 12),

                // Stats
                _Card(isDark: isDark, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _sectionHeader(Icons.trending_up, AppStrings.t('industry_stats'), context),
                  const SizedBox(height: 12),
                  Row(children: widget.stats.map((s) => Expanded(child: Column(children: [
                    Text(s['value']!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: widget.color)),
                    const SizedBox(height: 4),
                    Text(s['label']!, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: context.textSecondaryC)),
                  ]))).toList()),
                ])),
                const SizedBox(height: 12),

                // Roles
                _Card(isDark: isDark, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _sectionHeader(Icons.work_outline, AppStrings.t('key_roles'), context),
                  const SizedBox(height: 10),
                  ...widget.roles.map((r) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(children: [
                      Container(width: 6, height: 6, decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(r, style: TextStyle(fontSize: 14, color: context.textPrimaryC))),
                    ]),
                  )),
                ])),
                const SizedBox(height: 12),

                // Skills
                _Card(isDark: isDark, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _sectionHeader(Icons.school_outlined, AppStrings.t('skills_needed'), context),
                  const SizedBox(height: 10),
                  Wrap(spacing: 8, runSpacing: 8, children: widget.skills.map((s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: widget.color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: widget.color.withOpacity(0.3))),
                    child: Text(s, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: widget.color)),
                  )).toList()),
                ])),
                const SizedBox(height: 22),

                // ── JOBS SECTION ──
                Text('${widget.title} ${AppStrings.t('jobs')}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                const SizedBox(height: 12),

                // Search
                Container(
                  height: 44,
                  decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.dividerC)),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: AppStrings.t('search_by_title'),
                      hintStyle: TextStyle(color: context.textHintC, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Filters
                SizedBox(
                  height: 34,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: filters.map((f) {
                      final sel = _filter == f;
                      return GestureDetector(
                        onTap: () => setState(() => _filter = f),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: sel ? widget.color : context.cardBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: sel ? widget.color : context.dividerC),
                          ),
                          child: Center(child: Text(f == 'All' ? AppStrings.t('all') : f, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: sel ? Colors.white : context.textSecondaryC))),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),

                // Job cards
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Center(child: Column(children: [
                      Icon(Icons.search_off, size: 40, color: context.textHintC),
                      const SizedBox(height: 8),
                      Text(AppStrings.t('no_jobs_found'), style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
                    ])),
                  )
                else
                  ...filtered.map((job) => _jobCard(context, job)),

                const SizedBox(height: 20),

                // Guro School banner
                _guroSchoolBanner(context),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String text, BuildContext context) => Row(children: [
    Icon(icon, size: 20, color: widget.color), const SizedBox(width: 8),
    Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
  ]);

  Widget _jobCard(BuildContext context, Map<String, String> job) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => JobDetailScreen(job: job))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: widget.color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text(job['company']![0], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: widget.color))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(job['title']!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
              Text(job['company']!, style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
            ])),
            Icon(Icons.bookmark_border, color: context.textHintC, size: 22),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            _tag(Icons.location_on_outlined, job['location']!, context),
            const SizedBox(width: 8),
            _tag(Icons.schedule, job['type']!, context),
            const Spacer(),
            Text(job['salary']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: widget.color)),
          ]),
        ]),
      ),
    );
  }

  Widget _tag(IconData icon, String label, BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: context.surfaceBg, borderRadius: BorderRadius.circular(6)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: context.textHintC), const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 11, color: context.textSecondaryC)),
    ]),
  );

  Widget _guroSchoolBanner(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [GuroJobsTheme.primary, GuroJobsTheme.primaryLight]),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: GuroJobsTheme.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
    ),
    child: Column(children: [
      const Icon(Icons.school, size: 36, color: Colors.white),
      const SizedBox(height: 10),
      Text(AppStrings.t('want_to_learn'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
      const SizedBox(height: 6),
      Text(AppStrings.t('guro_school_desc'), textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9), height: 1.4)),
      const SizedBox(height: 14),
      SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: () async {
          final u = Uri.parse('https://guro.school/');
          if (await canLaunchUrl(u)) await launchUrl(u, mode: LaunchMode.externalApplication);
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: GuroJobsTheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.open_in_new, size: 16), const SizedBox(width: 8),
          Text(AppStrings.t('go_to_guro_school'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        ]),
      )),
    ]),
  );
}

class _Card extends StatelessWidget {
  final bool isDark;
  final Widget child;
  const _Card({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: isDark ? GuroJobsTheme.darkCard : Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: isDark ? Colors.black26 : Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: child,
  );
}
