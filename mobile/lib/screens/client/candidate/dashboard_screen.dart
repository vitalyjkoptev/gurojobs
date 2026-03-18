import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/lang_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../services/api_service.dart';
import 'splash_screen.dart';
import 'edit_profile_screen.dart';
import 'cv_screen.dart';
import 'saved_jobs_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import 'help_screen.dart';
import 'job_detail_screen.dart';
import 'connections_screen.dart';
import 'billing_screen.dart';
import 'chat_screen.dart';
import 'workspace_screen.dart';
import 'resume_builder_screen.dart';
import 'report_dialog.dart';
import 'category_gambling_screen.dart';
import 'category_betting_screen.dart';
import 'category_crypto_screen.dart';
import 'category_nutra_screen.dart';
import 'category_dating_screen.dart';
import 'category_ecommerce_screen.dart';
import 'category_fintech_screen.dart';
import 'category_other_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  String? _selectedCategory;

  void _goToJobsWithCategory(String? category) {
    setState(() {
      _selectedCategory = category;
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LangProvider>();

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeTab(goToJobs: () => _goToJobsWithCategory(null), goToCategory: _goToJobsWithCategory),
          _JobsTab(initialCategory: _selectedCategory, onCategoryCleared: () => _selectedCategory = null),
          _ApplicationsTab(goToJobs: () => setState(() => _currentIndex = 1)),
          const ChatScreen(),
          const _ProfileTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.cardBg,
          boxShadow: [BoxShadow(color: context.shadowMedium, blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: context.cardBg,
          selectedItemColor: GuroJobsTheme.primary,
          unselectedItemColor: context.textHintC,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: [
            BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), activeIcon: const Icon(Icons.home), label: AppStrings.t('home')),
            BottomNavigationBarItem(icon: const Icon(Icons.work_outline), activeIcon: const Icon(Icons.work), label: AppStrings.t('jobs')),
            BottomNavigationBarItem(icon: const Icon(Icons.assignment_outlined), activeIcon: const Icon(Icons.assignment), label: AppStrings.t('applications')),
            BottomNavigationBarItem(icon: const Icon(Icons.chat_bubble_outline), activeIcon: const Icon(Icons.chat_bubble), label: AppStrings.t('chat')),
            BottomNavigationBarItem(icon: const Icon(Icons.person_outline), activeIcon: const Icon(Icons.person), label: AppStrings.t('profile')),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HOME TAB
// ═══════════════════════════════════════════════════════════════
class _HomeTab extends StatelessWidget {
  final VoidCallback goToJobs;
  final ValueChanged<String?> goToCategory;
  const _HomeTab({required this.goToJobs, required this.goToCategory});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Greeting
            Row(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(color: GuroJobsTheme.primary, borderRadius: BorderRadius.circular(14)),
                  child: Center(
                    child: Text(
                      (auth.userName ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppStrings.t('hello')}, ${auth.userName ?? AppStrings.t('candidate')}!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC),
                      ),
                      Text(AppStrings.t('find_dream_job'), style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                  icon: const Icon(Icons.notifications_outlined),
                  color: context.textSecondaryC,
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Search bar
            Container(
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: context.shadowMedium, blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppStrings.t('search_jobs'),
                  hintStyle: TextStyle(color: context.textHintC, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: GuroJobsTheme.primary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Quick stats
            Row(
              children: [
                _StatCard(icon: Icons.work_outline, label: AppStrings.t('jobs_available'), value: '120+', color: GuroJobsTheme.primary),
                const SizedBox(width: 10),
                _StatCard(icon: Icons.send_outlined, label: AppStrings.t('applications'), value: '5', color: GuroJobsTheme.accent),
                const SizedBox(width: 10),
                _StatCard(icon: Icons.visibility_outlined, label: AppStrings.t('profile_views'), value: '12', color: GuroJobsTheme.success),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _StatCard(icon: Icons.bookmark_outline, label: AppStrings.t('saved'), value: '3', color: GuroJobsTheme.warning),
                const SizedBox(width: 10),
                _StatCard(icon: Icons.videocam_outlined, label: AppStrings.t('interviews'), value: '1', color: GuroJobsTheme.info),
                const SizedBox(width: 10),
                _StatCard(icon: Icons.local_offer_outlined, label: AppStrings.t('offers'), value: '0', color: const Color(0xFF9C27B0)),
              ],
            ),
            const SizedBox(height: 28),

            // Categories
            Text(AppStrings.t('popular_categories'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 14),
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _CategoryChip(image: 'assets/images/icon_gambling.png', label: AppStrings.t('gambling'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryGamblingScreen()))),
                  _CategoryChip(image: 'assets/images/icon_betting.png', label: AppStrings.t('betting'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryBettingScreen()))),
                  _CategoryChip(image: 'assets/images/icon_crypto.png', label: AppStrings.t('crypto'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryCryptoScreen()))),
                  _CategoryChip(image: 'assets/images/icon_nutra.png', label: AppStrings.t('nutra'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryNutraScreen()))),
                  _CategoryChip(image: 'assets/images/icon_dating.png', label: AppStrings.t('dating'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryDatingScreen()))),
                  _CategoryChip(image: 'assets/images/icon_ecommerce.png', label: AppStrings.t('ecommerce'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryEcommerceScreen()))),
                  _CategoryChip(image: 'assets/images/icon_fintech.png', label: AppStrings.t('fintech'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryFintechScreen()))),
                  _CategoryChip(image: 'assets/images/icon_other.png', label: AppStrings.t('other'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryOtherScreen()))),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Recent jobs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.t('recent_jobs'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                TextButton(onPressed: goToJobs, child: Text(AppStrings.t('see_all'))),
              ],
            ),
            const SizedBox(height: 8),
            ..._demoJobs.map((job) => _JobCard(job: job)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// JOBS TAB
// ═══════════════════════════════════════════════════════════════
class _JobsTab extends StatefulWidget {
  final String? initialCategory;
  final VoidCallback onCategoryCleared;
  const _JobsTab({this.initialCategory, required this.onCategoryCleared});

  @override
  State<_JobsTab> createState() => _JobsTabState();
}

class _JobsTabState extends State<_JobsTab> {
  String _selectedFilter = 'All';
  String? _activeCategory;

  // Advanced filters state
  RangeValues _salaryRange = const RangeValues(0, 200);
  String? _selectedExperience;
  final Set<String> _selectedWorkSetup = {};
  final Set<String> _selectedVerticals = {};
  String? _selectedEnglish;
  String? _selectedGeo;
  bool _hideWithReplies = false;
  bool _showSalaryRange = false;
  bool _filtersActive = false;
  List<String> _activeTags = [];

  static const List<String> _experienceKeys = [
    'no_experience', 'year_1', 'years_2', 'years_3', 'years_4',
    'years_5', 'years_6', 'years_7', 'years_8', 'years_9', 'years_10_plus',
  ];

  static const List<String> _workSetupKeys = ['remote', 'office', 'hybrid'];

  static const List<String> _verticalKeys = [
    'gambling', 'betting', 'crypto', 'nutra', 'dating', 'ecommerce', 'fintech', 'other',
  ];

  static const List<String> _englishKeys = [
    'no_english', 'beginner', 'pre_intermediate', 'intermediate',
    'upper_intermediate', 'advanced', 'proficient', 'native_speaker',
  ];

  static const List<String> _geoKeys = ['worldwide', 'eu_countries', 'other_countries'];

  void _buildTags() {
    _activeTags = [];
    if (_selectedExperience != null) _activeTags.add(AppStrings.t(_selectedExperience!));
    for (final w in _selectedWorkSetup) _activeTags.add(AppStrings.t(w));
    for (final v in _selectedVerticals) _activeTags.add(AppStrings.t(v));
    if (_selectedEnglish != null) _activeTags.add(AppStrings.t(_selectedEnglish!));
    if (_selectedGeo != null) _activeTags.add(AppStrings.t(_selectedGeo!));
    if (_salaryRange != const RangeValues(0, 200)) _activeTags.add('€${_salaryRange.start.round()}-${_salaryRange.end.round()}K');
    if (_hideWithReplies) _activeTags.add(AppStrings.t('hide_with_replies'));
    if (_showSalaryRange) _activeTags.add(AppStrings.t('show_salary_range'));
  }

  @override
  void didUpdateWidget(covariant _JobsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != null && widget.initialCategory != _activeCategory) {
      setState(() => _activeCategory = widget.initialCategory);
      widget.onCategoryCleared();
    }
  }

  List<Map<String, String>> get _filteredJobs {
    var jobs = _demoJobs;
    if (_activeCategory != null) {
      jobs = jobs.where((j) {
        final title = j['title']!.toLowerCase();
        final cat = _activeCategory!.toLowerCase();
        if (cat == 'gambling') return title.contains('casino') || title.contains('slot') || title.contains('gambl');
        if (cat == 'betting') return title.contains('bet') || title.contains('sport');
        if (cat == 'crypto') return title.contains('crypto') || title.contains('blockchain') || title.contains('web3');
        if (cat == 'nutra') return title.contains('nutra') || title.contains('health');
        if (cat == 'dating') return title.contains('dating') || title.contains('social');
        if (cat == 'e-commerce') return title.contains('ecommerce') || title.contains('commerce') || title.contains('shop');
        if (cat == 'fintech') return title.contains('fintech') || title.contains('payment') || title.contains('finance');
        if (cat == 'other') return true;
        return true;
      }).toList();
    }
    if (_selectedFilter != 'All') {
      jobs = jobs.where((j) {
        if (_selectedFilter == 'Remote') return j['location'] == 'Remote';
        if (_selectedFilter == 'Full-time') return j['type'] == 'Full-time';
        if (_selectedFilter == 'Senior') return j['title']!.contains('Senior');
        if (_selectedFilter == 'Malta') return j['location'] == 'Malta';
        return true;
      }).toList();
    }
    // Advanced filters
    if (_filtersActive) {
      jobs = jobs.where((j) {
        // Salary filter
        final salaryStr = j['salary'] ?? '';
        final salaryNums = RegExp(r'(\d+)').allMatches(salaryStr).map((m) => int.parse(m.group(0)!)).toList();
        if (salaryNums.isNotEmpty) {
          final maxSalary = salaryNums.last;
          if (maxSalary < _salaryRange.start || salaryNums.first > _salaryRange.end) return false;
        }
        // Work setup filter
        if (_selectedWorkSetup.isNotEmpty) {
          final loc = j['location']?.toLowerCase() ?? '';
          bool match = false;
          if (_selectedWorkSetup.contains('remote') && loc == 'remote') match = true;
          if (_selectedWorkSetup.contains('office') && loc != 'remote' && loc != 'hybrid') match = true;
          if (_selectedWorkSetup.contains('hybrid') && loc == 'hybrid') match = true;
          if (!match) return false;
        }
        // Verticals filter
        if (_selectedVerticals.isNotEmpty) {
          final title = j['title']!.toLowerCase();
          bool match = false;
          for (final v in _selectedVerticals) {
            if (v == 'gambling' && (title.contains('casino') || title.contains('slot') || title.contains('gambl'))) match = true;
            if (v == 'betting' && (title.contains('bet') || title.contains('sport'))) match = true;
            if (v == 'crypto' && (title.contains('crypto') || title.contains('blockchain'))) match = true;
            if (v == 'nutra' && (title.contains('nutra') || title.contains('health'))) match = true;
            if (v == 'dating' && (title.contains('dating') || title.contains('social'))) match = true;
            if (v == 'ecommerce' && (title.contains('ecommerce') || title.contains('commerce'))) match = true;
            if (v == 'fintech' && (title.contains('fintech') || title.contains('payment'))) match = true;
            if (v == 'other') match = true;
          }
          if (!match) return false;
        }
        return true;
      }).toList();
    }
    return jobs;
  }

  void _showFilterSheet() {
    RangeValues tempSalary = _salaryRange;
    String? tempExperience = _selectedExperience;
    Set<String> tempWorkSetup = Set.from(_selectedWorkSetup);
    Set<String> tempVerticals = Set.from(_selectedVerticals);
    String? tempEnglish = _selectedEnglish;
    String? tempGeo = _selectedGeo;
    bool tempHideReplies = _hideWithReplies;
    bool tempShowSalary = _showSalaryRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: context.cardBg,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            Widget chipSingle(String key, String? selected, ValueChanged<String?> onTap) {
              final isSelected = selected == key;
              return GestureDetector(
                onTap: () => onTap(isSelected ? null : key),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? GuroJobsTheme.primary : context.surfaceBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? GuroJobsTheme.primary : context.dividerC),
                  ),
                  child: Text(AppStrings.t(key), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : context.textSecondaryC)),
                ),
              );
            }

            Widget chipMulti(String key, Set<String> selected) {
              final isSelected = selected.contains(key);
              return GestureDetector(
                onTap: () => setSheetState(() { if (isSelected) selected.remove(key); else selected.add(key); }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? GuroJobsTheme.primary : context.surfaceBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? GuroJobsTheme.primary : context.dividerC),
                  ),
                  child: Text(AppStrings.t(key), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : context.textSecondaryC)),
                ),
              );
            }

            Widget sectionTitle(String title) => Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC));

            return DraggableScrollableSheet(
              initialChildSize: 0.88,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (_, scrollCtrl) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Column(children: [
                        Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppStrings.t('filters'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                            GestureDetector(
                              onTap: () => setSheetState(() {
                                tempSalary = const RangeValues(0, 200);
                                tempExperience = null;
                                tempWorkSetup.clear();
                                tempVerticals.clear();
                                tempEnglish = null;
                                tempGeo = null;
                                tempHideReplies = false;
                                tempShowSalary = false;
                              }),
                              child: Text(AppStrings.t('reset_filters'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: GuroJobsTheme.primary)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ]),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollCtrl,
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                        children: [
                          // ── 1. SALARY ──
                          sectionTitle(AppStrings.t('salary')),
                          const SizedBox(height: 8),
                          Row(children: [
                            Text('€${tempSalary.start.round()}K', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                            const Spacer(),
                            Text('€${tempSalary.end.round()}K', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                          ]),
                          RangeSlider(
                            values: tempSalary, min: 0, max: 200, divisions: 40,
                            activeColor: GuroJobsTheme.primary,
                            inactiveColor: GuroJobsTheme.primary.withOpacity(0.15),
                            labels: RangeLabels('€${tempSalary.start.round()}K', '€${tempSalary.end.round()}K'),
                            onChanged: (v) => setSheetState(() => tempSalary = v),
                          ),
                          const SizedBox(height: 16),

                          // ── 2. EXPERIENCE ──
                          sectionTitle(AppStrings.t('experience')),
                          const SizedBox(height: 10),
                          Wrap(spacing: 8, runSpacing: 8, children: _experienceKeys.map((k) => chipSingle(k, tempExperience, (v) => setSheetState(() => tempExperience = v))).toList()),
                          const SizedBox(height: 20),

                          // ── 3. WORK SETUP ──
                          sectionTitle(AppStrings.t('work_setup')),
                          const SizedBox(height: 10),
                          Wrap(spacing: 8, runSpacing: 8, children: _workSetupKeys.map((k) => chipMulti(k, tempWorkSetup)).toList()),
                          const SizedBox(height: 20),

                          // ── 4. VERTICALS ──
                          sectionTitle(AppStrings.t('verticals')),
                          const SizedBox(height: 10),
                          Wrap(spacing: 8, runSpacing: 8, children: _verticalKeys.map((k) => chipMulti(k, tempVerticals)).toList()),
                          const SizedBox(height: 20),

                          // ── 5. ENGLISH ──
                          sectionTitle(AppStrings.t('english_level')),
                          const SizedBox(height: 10),
                          Wrap(spacing: 8, runSpacing: 8, children: _englishKeys.map((k) => chipSingle(k, tempEnglish, (v) => setSheetState(() => tempEnglish = v))).toList()),
                          const SizedBox(height: 20),

                          // ── 6. GEO ──
                          sectionTitle(AppStrings.t('geo')),
                          const SizedBox(height: 10),
                          Wrap(spacing: 8, runSpacing: 8, children: _geoKeys.map((k) => chipSingle(k, tempGeo, (v) => setSheetState(() => tempGeo = v))).toList()),
                          const SizedBox(height: 20),

                          // ── 7. CHECKBOXES ──
                          GestureDetector(
                            onTap: () => setSheetState(() => tempHideReplies = !tempHideReplies),
                            child: Row(children: [
                              SizedBox(
                                width: 24, height: 24,
                                child: Checkbox(value: tempHideReplies, onChanged: (v) => setSheetState(() => tempHideReplies = v!),
                                  activeColor: GuroJobsTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text(AppStrings.t('hide_with_replies'), style: TextStyle(fontSize: 13, color: context.textPrimaryC))),
                            ]),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () => setSheetState(() => tempShowSalary = !tempShowSalary),
                            child: Row(children: [
                              SizedBox(
                                width: 24, height: 24,
                                child: Checkbox(value: tempShowSalary, onChanged: (v) => setSheetState(() => tempShowSalary = v!),
                                  activeColor: GuroJobsTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text(AppStrings.t('show_salary_range'), style: TextStyle(fontSize: 13, color: context.textPrimaryC))),
                            ]),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    // Apply button
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(ctx).padding.bottom + 16),
                      child: SizedBox(
                        width: double.infinity, height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _salaryRange = tempSalary;
                              _selectedExperience = tempExperience;
                              _selectedWorkSetup..clear()..addAll(tempWorkSetup);
                              _selectedVerticals..clear()..addAll(tempVerticals);
                              _selectedEnglish = tempEnglish;
                              _selectedGeo = tempGeo;
                              _hideWithReplies = tempHideReplies;
                              _showSalaryRange = tempShowSalary;
                              _filtersActive = tempSalary != const RangeValues(0, 200) ||
                                  tempExperience != null || tempWorkSetup.isNotEmpty ||
                                  tempVerticals.isNotEmpty || tempEnglish != null ||
                                  tempGeo != null || tempHideReplies || tempShowSalary;
                              _buildTags();
                            });
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                          child: Text(AppStrings.t('apply_filters'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filters = [AppStrings.t('all'), AppStrings.t('remote'), AppStrings.t('full_time'), AppStrings.t('senior'), 'Malta'];
    const filterKeys = ['All', 'Remote', 'Full-time', 'Senior', 'Malta'];
    final filtered = _filteredJobs;
    context.watch<LangProvider>();

    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _activeCategory != null ? '$_activeCategory ${AppStrings.t('jobs_suffix')}' : AppStrings.t('find_jobs'),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: context.textPrimaryC),
                      ),
                    ),
                    if (_activeCategory != null)
                      IconButton(
                        icon: Icon(Icons.close, color: context.textHintC),
                        onPressed: () => setState(() => _activeCategory = null),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: context.cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: context.dividerC),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: AppStrings.t('search_by_title'),
                            hintStyle: TextStyle(color: context.textHintC, fontSize: 14),
                            prefixIcon: const Icon(Icons.search, size: 20),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _showFilterSheet,
                      child: Stack(
                        children: [
                          Container(
                            width: 46, height: 46,
                            decoration: BoxDecoration(color: GuroJobsTheme.primary, borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.tune, color: Colors.white, size: 20),
                          ),
                          if (_filtersActive)
                            Positioned(
                              right: 0, top: 0,
                              child: Container(
                                width: 12, height: 12,
                                decoration: BoxDecoration(color: GuroJobsTheme.accent, shape: BoxShape.circle, border: Border.all(color: context.cardBg, width: 1.5)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Active filter tags from sheet + quick filters
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Quick filters
                      ...List.generate(filters.length, (i) {
                        final isSelected = _selectedFilter == filterKeys[i];
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = filterKeys[i]),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected ? GuroJobsTheme.primary : context.cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSelected ? GuroJobsTheme.primary : context.dividerC),
                            ),
                            child: Center(child: Text(filters[i], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : context.textSecondaryC))),
                          ),
                        );
                      }),
                      // Tags from advanced filters
                      ..._activeTags.map((tag) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: GuroJobsTheme.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: GuroJobsTheme.accent.withOpacity(0.4)),
                        ),
                        child: Center(child: Text(tag, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: GuroJobsTheme.accent))),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48, color: context.textHintC),
                        const SizedBox(height: 12),
                        Text(AppStrings.t('no_jobs_found'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textSecondaryC)),
                        const SizedBox(height: 6),
                        Text(AppStrings.t('try_different_filters'), style: TextStyle(fontSize: 13, color: context.textHintC)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => _JobCard(job: filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// APPLICATIONS TAB — ORGANIZER
// ═══════════════════════════════════════════════════════════════

enum _AppStatus { sent, viewed, interview, offer, rejected }

class _Meeting {
  String type; // video, phone, onsite
  DateTime date;
  String time;
  String link;
  _Meeting({required this.type, required this.date, required this.time, this.link = ''});
}

class _AppNote {
  String text;
  DateTime created;
  _AppNote({required this.text, DateTime? created}) : created = created ?? DateTime.now();
}

class _Application {
  final String id;
  final String company;
  final String position;
  final String logo;
  final String salary;
  _AppStatus status;
  final DateTime appliedDate;
  final List<_TimelineEvent> timeline;
  final List<_Meeting> meetings;
  final List<_AppNote> notes;

  _Application({
    required this.id,
    required this.company,
    required this.position,
    required this.logo,
    required this.salary,
    required this.status,
    required this.appliedDate,
    required this.timeline,
    List<_Meeting>? meetings,
    List<_AppNote>? notes,
  })  : meetings = meetings ?? [],
        notes = notes ?? [];
}

class _TimelineEvent {
  final String label;
  final DateTime date;
  final IconData icon;
  final Color color;
  _TimelineEvent({required this.label, required this.date, required this.icon, required this.color});
}

class _ApplicationsTab extends StatefulWidget {
  final VoidCallback goToJobs;
  const _ApplicationsTab({required this.goToJobs});

  @override
  State<_ApplicationsTab> createState() => _ApplicationsTabState();
}

class _ApplicationsTabState extends State<_ApplicationsTab> {
  String _filter = 'all';

  final List<_Application> _apps = [
    _Application(
      id: '1',
      company: 'BetStars Gaming',
      position: 'Senior Flutter Developer',
      logo: 'BS',
      salary: '\$5,000 - \$7,000',
      status: _AppStatus.interview,
      appliedDate: DateTime(2026, 3, 10),
      timeline: [
        _TimelineEvent(label: 'application_sent', date: DateTime(2026, 3, 10), icon: Icons.send, color: GuroJobsTheme.primary),
        _TimelineEvent(label: 'cv_viewed', date: DateTime(2026, 3, 11), icon: Icons.visibility, color: GuroJobsTheme.info),
        _TimelineEvent(label: 'interview_scheduled', date: DateTime(2026, 3, 13), icon: Icons.event, color: GuroJobsTheme.success),
      ],
      meetings: [
        _Meeting(type: 'video', date: DateTime(2026, 3, 17), time: '14:00', link: 'https://meet.google.com/abc'),
      ],
      notes: [
        _AppNote(text: 'HR said team is 15 people, fully remote. Stack: Flutter + Go.', created: DateTime(2026, 3, 11)),
      ],
    ),
    _Application(
      id: '2',
      company: 'CryptoPlay',
      position: 'Product Manager',
      logo: 'CP',
      salary: '\$6,000 - \$9,000',
      status: _AppStatus.viewed,
      appliedDate: DateTime(2026, 3, 12),
      timeline: [
        _TimelineEvent(label: 'application_sent', date: DateTime(2026, 3, 12), icon: Icons.send, color: GuroJobsTheme.primary),
        _TimelineEvent(label: 'cv_viewed', date: DateTime(2026, 3, 14), icon: Icons.visibility, color: GuroJobsTheme.info),
      ],
    ),
    _Application(
      id: '3',
      company: 'NutraWave Ltd',
      position: 'Affiliate Manager',
      logo: 'NW',
      salary: '\$3,500 - \$5,000',
      status: _AppStatus.offer,
      appliedDate: DateTime(2026, 3, 5),
      timeline: [
        _TimelineEvent(label: 'application_sent', date: DateTime(2026, 3, 5), icon: Icons.send, color: GuroJobsTheme.primary),
        _TimelineEvent(label: 'cv_viewed', date: DateTime(2026, 3, 6), icon: Icons.visibility, color: GuroJobsTheme.info),
        _TimelineEvent(label: 'interview_scheduled', date: DateTime(2026, 3, 8), icon: Icons.event, color: GuroJobsTheme.success),
        _TimelineEvent(label: 'offer_received', date: DateTime(2026, 3, 12), icon: Icons.card_giftcard, color: const Color(0xFFD4AF37)),
      ],
      meetings: [
        _Meeting(type: 'onsite', date: DateTime(2026, 3, 8), time: '11:00', link: 'Warsaw, ul. Marszalkowska 1'),
      ],
      notes: [
        _AppNote(text: 'Offer: \$4,500 + bonus. Need to respond by March 20.', created: DateTime(2026, 3, 12)),
      ],
    ),
    _Application(
      id: '4',
      company: 'SpinTech',
      position: 'QA Engineer',
      logo: 'ST',
      salary: '\$2,500 - \$3,500',
      status: _AppStatus.sent,
      appliedDate: DateTime(2026, 3, 14),
      timeline: [
        _TimelineEvent(label: 'application_sent', date: DateTime(2026, 3, 14), icon: Icons.send, color: GuroJobsTheme.primary),
      ],
    ),
    _Application(
      id: '5',
      company: 'DatingBoom',
      position: 'Backend Developer',
      logo: 'DB',
      salary: '\$4,000 - \$6,000',
      status: _AppStatus.rejected,
      appliedDate: DateTime(2026, 3, 1),
      timeline: [
        _TimelineEvent(label: 'application_sent', date: DateTime(2026, 3, 1), icon: Icons.send, color: GuroJobsTheme.primary),
        _TimelineEvent(label: 'cv_viewed', date: DateTime(2026, 3, 3), icon: Icons.visibility, color: GuroJobsTheme.info),
        _TimelineEvent(label: 'rejected_info', date: DateTime(2026, 3, 7), icon: Icons.cancel, color: GuroJobsTheme.error),
      ],
    ),
  ];

  Color _statusColor(_AppStatus s) {
    switch (s) {
      case _AppStatus.sent: return GuroJobsTheme.primary;
      case _AppStatus.viewed: return GuroJobsTheme.info;
      case _AppStatus.interview: return GuroJobsTheme.success;
      case _AppStatus.offer: return const Color(0xFFD4AF37);
      case _AppStatus.rejected: return GuroJobsTheme.error;
    }
  }

  String _statusLabel(_AppStatus s) {
    switch (s) {
      case _AppStatus.sent: return AppStrings.t('status_sent');
      case _AppStatus.viewed: return AppStrings.t('status_viewed');
      case _AppStatus.interview: return AppStrings.t('status_interview');
      case _AppStatus.offer: return AppStrings.t('status_offer');
      case _AppStatus.rejected: return AppStrings.t('status_rejected');
    }
  }

  IconData _statusIcon(_AppStatus s) {
    switch (s) {
      case _AppStatus.sent: return Icons.send;
      case _AppStatus.viewed: return Icons.visibility;
      case _AppStatus.interview: return Icons.event;
      case _AppStatus.offer: return Icons.card_giftcard;
      case _AppStatus.rejected: return Icons.cancel;
    }
  }

  List<_Application> get _filtered {
    if (_filter == 'all') return _apps;
    final s = _AppStatus.values.firstWhere((e) => e.name == _filter);
    return _apps.where((a) => a.status == s).toList();
  }

  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    final interviewCount = _apps.where((a) => a.status == _AppStatus.interview).length;
    final offerCount = _apps.where((a) => a.status == _AppStatus.offer).length;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.t('my_applications'), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                const SizedBox(height: 4),
                Text(AppStrings.t('organizer'), style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Summary cards
          SizedBox(
            height: 72,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _summaryCard(context, AppStrings.t('total'), '${_apps.length}', GuroJobsTheme.primary),
                const SizedBox(width: 10),
                _summaryCard(context, AppStrings.t('interviews'), '$interviewCount', GuroJobsTheme.success),
                const SizedBox(width: 10),
                _summaryCard(context, AppStrings.t('offers'), '$offerCount', const Color(0xFFD4AF37)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Status filter chips
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _filterChip('all', AppStrings.t('all')),
                ..._AppStatus.values.map((s) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _filterChip(s.name, _statusLabel(s)),
                )),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Application list
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_outlined, size: 48, color: context.textHintC),
                        const SizedBox(height: 12),
                        Text(AppStrings.t('no_applications'), style: TextStyle(fontSize: 16, color: context.textSecondaryC)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: widget.goToJobs,
                          icon: const Icon(Icons.search, size: 18),
                          label: Text(AppStrings.t('browse_jobs')),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) => _buildAppCard(ctx, _filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(BuildContext context, String label, String value, Color color) {
    return Container(
      constraints: const BoxConstraints(minWidth: 100),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: context.textSecondaryC)),
        ],
      ),
    );
  }

  Widget _filterChip(String key, String label) {
    final active = _filter == key;
    return GestureDetector(
      onTap: () => setState(() => _filter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? GuroJobsTheme.primary : context.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: active ? GuroJobsTheme.primary : context.dividerC),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: active ? Colors.white : context.textSecondaryC)),
      ),
    );
  }

  Widget _buildAppCard(BuildContext context, _Application app) {
    final color = _statusColor(app.status);
    final hasMeetings = app.meetings.isNotEmpty;

    return GestureDetector(
      onTap: () => _openDetail(app),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: color, width: 4)),
          boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Company avatar
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text(app.logo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color))),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(app.position, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(app.company, style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text(_statusLabel(app.status), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.monetization_on_outlined, size: 14, color: context.textHintC),
                const SizedBox(width: 4),
                Text(app.salary, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
                const Spacer(),
                Icon(Icons.calendar_today, size: 12, color: context.textHintC),
                const SizedBox(width: 4),
                Text(_formatDate(app.appliedDate), style: TextStyle(fontSize: 12, color: context.textHintC)),
              ],
            ),
            if (hasMeetings) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: GuroJobsTheme.success.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.videocam, size: 14, color: GuroJobsTheme.success),
                    const SizedBox(width: 6),
                    Text(
                      '${_formatDate(app.meetings.first.date)} ${app.meetings.first.time}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: GuroJobsTheme.success),
                    ),
                  ],
                ),
              ),
            ],
            if (app.notes.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.sticky_note_2_outlined, size: 13, color: context.textHintC),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(app.notes.last.text, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: context.textHintC)),
                  ),
                ],
              ),
            ],
            // Recruiter info
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.person_outline, size: 13, color: context.textHintC),
                const SizedBox(width: 4),
                Text('HR ${app.company}', style: TextStyle(fontSize: 11, color: context.textHintC)),
                const SizedBox(width: 8),
                Icon(Icons.circle, size: 6, color: GuroJobsTheme.success),
                const SizedBox(width: 4),
                Text('Online ${_formatDate(DateTime.now().subtract(const Duration(hours: 2)))}', style: TextStyle(fontSize: 11, color: context.textHintC)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ────── DETAIL BOTTOM SHEET ──────

  void _openDetail(_Application app) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (ctx, scrollCtrl) => StatefulBuilder(
          builder: (ctx, setSheetState) => Container(
            decoration: BoxDecoration(
              color: context.isDark ? GuroJobsTheme.darkSurface : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2)),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: _statusColor(app.status).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: Text(app.logo, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _statusColor(app.status)))),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(app.position, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                            Text(app.company, style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: _statusColor(app.status).withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                        child: Text(_statusLabel(app.status), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _statusColor(app.status))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Content
                Expanded(
                  child: ListView(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    children: [
                      // ── TIMELINE ──
                      _sectionHeader(AppStrings.t('timeline'), Icons.timeline),
                      const SizedBox(height: 8),
                      ...app.timeline.map((e) => _timelineRow(e)),
                      const SizedBox(height: 20),

                      // ── MEETINGS ──
                      Row(
                        children: [
                          _sectionHeader(AppStrings.t('meetings'), Icons.event),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => _showAddMeeting(app, setSheetState),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.add, size: 14, color: GuroJobsTheme.primary),
                                  const SizedBox(width: 4),
                                  Text(AppStrings.t('add_meeting'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: GuroJobsTheme.primary)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (app.meetings.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(AppStrings.t('no_meetings'), style: TextStyle(fontSize: 13, color: context.textHintC)),
                        )
                      else
                        ...app.meetings.asMap().entries.map((e) => _meetingCard(e.value, e.key, app, setSheetState)),
                      const SizedBox(height: 20),

                      // ── NOTES ──
                      Row(
                        children: [
                          _sectionHeader(AppStrings.t('notes'), Icons.sticky_note_2),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => _showAddNote(app, setSheetState),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.add, size: 14, color: GuroJobsTheme.primary),
                                  const SizedBox(width: 4),
                                  Text(AppStrings.t('add_note'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: GuroJobsTheme.primary)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (app.notes.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(AppStrings.t('no_notes_app'), style: TextStyle(fontSize: 13, color: context.textHintC)),
                        )
                      else
                        ...app.notes.asMap().entries.map((e) => _noteCard(e.value, e.key, app, setSheetState)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: GuroJobsTheme.primary),
        const SizedBox(width: 6),
        Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
      ],
    );
  }

  Widget _timelineRow(_TimelineEvent e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(color: e.color.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(e.icon, size: 14, color: e.color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.t(e.label), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: context.textPrimaryC)),
                Text(_formatDate(e.date), style: TextStyle(fontSize: 11, color: context.textHintC)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _meetingCard(_Meeting m, int index, _Application app, StateSetter setSheetState) {
    final typeIcon = m.type == 'video' ? Icons.videocam : m.type == 'phone' ? Icons.phone : Icons.location_on;
    final typeLabel = m.type == 'video' ? AppStrings.t('meeting_video') : m.type == 'phone' ? AppStrings.t('meeting_phone') : AppStrings.t('meeting_onsite');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.dividerC),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: GuroJobsTheme.success.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(typeIcon, size: 18, color: GuroJobsTheme.success),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(typeLabel, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: context.textPrimaryC)),
                Text('${_formatDate(m.date)} ${m.time}', style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
                if (m.link.isNotEmpty)
                  GestureDetector(
                    onTap: () async {
                      final uri = Uri.tryParse(m.link);
                      if (uri != null && await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                    child: Text(m.link, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: GuroJobsTheme.primary, decoration: TextDecoration.underline)),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setSheetState(() => app.meetings.removeAt(index));
              setState(() {});
            },
            child: Icon(Icons.delete_outline, size: 18, color: GuroJobsTheme.error.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _noteCard(_AppNote n, int index, _Application app, StateSetter setSheetState) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.dividerC),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.sticky_note_2_outlined, size: 16, color: GuroJobsTheme.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(n.text, style: TextStyle(fontSize: 13, color: context.textPrimaryC)),
                const SizedBox(height: 4),
                Text(_formatDate(n.created), style: TextStyle(fontSize: 11, color: context.textHintC)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setSheetState(() => app.notes.removeAt(index));
              setState(() {});
            },
            child: Icon(Icons.close, size: 16, color: context.textHintC),
          ),
        ],
      ),
    );
  }

  // ────── ADD MEETING DIALOG ──────

  void _showAddMeeting(_Application app, StateSetter setSheetState) {
    String type = 'video';
    DateTime date = DateTime.now().add(const Duration(days: 1));
    String time = '10:00';
    final linkCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx2, setDialog) => Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx2).viewInsets.bottom + 20),
          decoration: BoxDecoration(
            color: context.isDark ? GuroJobsTheme.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.t('schedule_meeting'), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
              const SizedBox(height: 16),

              // Type selector
              Text(AppStrings.t('meeting_type'), style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _meetingTypeChip('video', Icons.videocam, AppStrings.t('meeting_video'), type, (v) => setDialog(() => type = v)),
                  const SizedBox(width: 8),
                  _meetingTypeChip('phone', Icons.phone, AppStrings.t('meeting_phone'), type, (v) => setDialog(() => type = v)),
                  const SizedBox(width: 8),
                  _meetingTypeChip('onsite', Icons.location_on, AppStrings.t('meeting_onsite'), type, (v) => setDialog(() => type = v)),
                ],
              ),
              const SizedBox(height: 16),

              // Date & Time
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(context: context, initialDate: date, firstDate: DateTime.now(), lastDate: DateTime(2027));
                        if (picked != null) setDialog(() => date = picked);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(border: Border.all(color: context.dividerC), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: context.textHintC),
                            const SizedBox(width: 8),
                            Text(_formatDate(date), style: TextStyle(fontSize: 14, color: context.textPrimaryC)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final parts = time.split(':');
                        final picked = await showTimePicker(context: context, initialTime: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])));
                        if (picked != null) setDialog(() => time = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(border: Border.all(color: context.dividerC), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, size: 16, color: context.textHintC),
                            const SizedBox(width: 8),
                            Text(time, style: TextStyle(fontSize: 14, color: context.textPrimaryC)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Link
              TextField(
                controller: linkCtrl,
                style: TextStyle(fontSize: 14, color: context.textPrimaryC),
                decoration: InputDecoration(
                  hintText: AppStrings.t('meeting_link'),
                  hintStyle: TextStyle(color: context.textHintC),
                  prefixIcon: Icon(Icons.link, size: 18, color: context.textHintC),
                ),
              ),
              const SizedBox(height: 20),

              // Save
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final meeting = _Meeting(type: type, date: date, time: time, link: linkCtrl.text.trim());
                    app.meetings.add(meeting);
                    setSheetState(() {});
                    setState(() {});
                    Navigator.pop(ctx2);
                  },
                  child: Text(AppStrings.t('save')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _meetingTypeChip(String value, IconData icon, String label, String current, ValueChanged<String> onTap) {
    final active = current == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? GuroJobsTheme.primary.withOpacity(0.1) : context.surfaceBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: active ? GuroJobsTheme.primary : context.dividerC),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: active ? GuroJobsTheme.primary : context.textHintC),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 11, color: active ? GuroJobsTheme.primary : context.textSecondaryC)),
            ],
          ),
        ),
      ),
    );
  }

  // ────── ADD NOTE DIALOG ──────

  void _showAddNote(_Application app, StateSetter setSheetState) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        decoration: BoxDecoration(
          color: context.isDark ? GuroJobsTheme.darkCard : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.t('add_note'), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 14),
            TextField(
              controller: ctrl,
              maxLines: 4,
              autofocus: true,
              style: TextStyle(fontSize: 14, color: context.textPrimaryC),
              decoration: InputDecoration(
                hintText: AppStrings.t('note_hint'),
                hintStyle: TextStyle(color: context.textHintC),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (ctrl.text.trim().isNotEmpty) {
                    app.notes.add(_AppNote(text: ctrl.text.trim()));
                    setSheetState(() {});
                    setState(() {});
                  }
                  Navigator.pop(context);
                },
                child: Text(AppStrings.t('save')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PROFILE TAB
// ═══════════════════════════════════════════════════════════════
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lang = context.watch<LangProvider>();

    String roleLabel(String? role) {
      switch (role) {
        case 'employer': return AppStrings.t('employer');
        case 'admin': return AppStrings.t('admin');
        default: return AppStrings.t('candidate');
      }
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                color: GuroJobsTheme.primary, shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: GuroJobsTheme.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Center(
                child: Text((auth.userName ?? 'U')[0].toUpperCase(), style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            Text(auth.userName ?? AppStrings.t('candidate'), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 4),
            Text(auth.userEmail ?? '', style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: GuroJobsTheme.success.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(roleLabel(auth.userRole), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: GuroJobsTheme.success)),
            ),
            const SizedBox(height: 30),

            // Profile completion
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: GuroJobsTheme.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: GuroJobsTheme.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: GuroJobsTheme.warning, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.t('complete_profile'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                          const SizedBox(height: 2),
                          Text(AppStrings.t('complete_profile_desc'), style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: context.textHintC),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Language selector
            _ProfileMenuItem(
              icon: Icons.language,
              label: AppStrings.t('language'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${AppStrings.languageFlags[lang.currentLang]} ${AppStrings.languageNames[lang.currentLang]}',
                    style: TextStyle(fontSize: 13, color: context.textSecondaryC),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: context.textHintC, size: 20),
                ],
              ),
              onTap: () => _showLanguagePicker(context, lang),
            ),

            // Dark mode toggle
            Builder(builder: (context) {
              final themeProv = context.watch<ThemeProvider>();
              return _ProfileMenuItem(
                icon: themeProv.isDark ? Icons.dark_mode : Icons.light_mode,
                label: AppStrings.t('dark_mode'),
                trailing: Switch(
                  value: themeProv.isDark,
                  onChanged: (_) => themeProv.toggle(),
                  activeColor: GuroJobsTheme.primary,
                ),
                onTap: () => themeProv.toggle(),
              );
            }),

            _ProfileMenuItem(icon: Icons.person_outline, label: AppStrings.t('edit_profile'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()))),
            _ProfileMenuItem(icon: Icons.description_outlined, label: AppStrings.t('my_cv'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CvScreen()))),
            _ProfileMenuItem(icon: Icons.link, label: AppStrings.t('connections'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConnectionsScreen()))),
            _ProfileMenuItem(icon: Icons.description_outlined, label: AppStrings.t('emp_subscription'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BillingScreen()))),
            _ProfileMenuItem(icon: Icons.bookmark_outline, label: AppStrings.t('saved_jobs'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedJobsScreen()))),
            _ProfileMenuItem(icon: Icons.notifications_outlined, label: AppStrings.t('notifications'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()))),
            _ProfileMenuItem(icon: Icons.settings_outlined, label: AppStrings.t('settings'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
            _ProfileMenuItem(icon: Icons.help_outline, label: AppStrings.t('help_support'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen()))),

            const SizedBox(height: 20),
            _ProfileMenuItem(
              icon: Icons.logout, label: AppStrings.t('logout'), color: GuroJobsTheme.error,
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(AppStrings.t('logout')),
                    content: Text(AppStrings.t('logout_confirm')),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppStrings.t('cancel'))),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(AppStrings.t('logout'), style: const TextStyle(color: GuroJobsTheme.error))),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const SplashScreen()), (route) => false);
                  }
                }
              },
            ),

            const SizedBox(height: 24),

            // Community join
            GestureDetector(
              onTap: () async {
                final uri = Uri.parse('https://t.me/GuroJobs');
                if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF0088CC), Color(0xFF00AAEE)]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: const Color(0xFF0088CC).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.group_outlined, color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.t('join_community'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                        Text(AppStrings.t('join_community_desc'), style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
                      ],
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text('GURO JOBS v1.0.0', style: TextStyle(fontSize: 12, color: context.textHintC)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static void _showNotesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          final List<Map<String, String>> notes = [];
          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            expand: false,
            builder: (_, scrollController) => Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.sticky_note_2, color: Color(0xFFFFA726), size: 24),
                      const SizedBox(width: 10),
                      Expanded(child: Text(AppStrings.t('notes'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
                      GestureDetector(
                        onTap: () {
                          final titleCtrl = TextEditingController();
                          final bodyCtrl = TextEditingController();
                          showDialog(
                            context: ctx,
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
                                      setSheetState(() => notes.add({'title': titleCtrl.text.trim(), 'body': bodyCtrl.text.trim()}));
                                    }
                                    Navigator.pop(dCtx);
                                  },
                                  child: Text(AppStrings.t('save'), style: const TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: const Color(0xFFFFA726).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.add, color: Color(0xFFFFA726), size: 22),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: notes.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.note_alt_outlined, size: 64, color: Colors.grey[300]),
                                const SizedBox(height: 12),
                                Text(AppStrings.t('no_notes'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[500])),
                                const SizedBox(height: 4),
                                Text(AppStrings.t('no_notes_desc'), style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: notes.length,
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
                                  Text(notes[i]['title']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                  if (notes[i]['body']!.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(notes[i]['body']!, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
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

  static void _showDraftsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          expand: false,
          builder: (_, scrollController) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.drafts, color: Color(0xFF42A5F5), size: 24),
                    const SizedBox(width: 10),
                    Expanded(child: Text(AppStrings.t('drafts'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.drafts_outlined, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text(AppStrings.t('no_drafts'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[500])),
                        const SizedBox(height: 4),
                        Text(AppStrings.t('no_drafts_desc'), style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.rocket_launch, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(AppStrings.t('coming_soon'), style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        backgroundColor: GuroJobsTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void _showLanguagePicker(BuildContext context, LangProvider lang) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text(AppStrings.t('language'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              ...AppStrings.languageNames.entries.map((entry) {
                final isSelected = lang.currentLang == entry.key;
                return ListTile(
                  leading: Text(AppStrings.languageFlags[entry.key] ?? '', style: const TextStyle(fontSize: 24)),
                  title: Text(entry.value, style: TextStyle(fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400)),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: GuroJobsTheme.primary) : null,
                  onTap: () { lang.setLang(entry.key); Navigator.pop(ctx); },
                );
              }),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// WIDGETS
// ═══════════════════════════════════════════════════════════════
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 2),
            Text(label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: context.textSecondaryC)),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const _CategoryChip({required this.image, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: 50, height: 50, color: const Color(0xFF015EA7)),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
          ],
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final Map<String, String> job;

  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(job['company']![0], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job['title']!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                      Text(job['company']!, style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
                    ],
                  ),
                ),
                Icon(Icons.bookmark_border, color: context.textHintC, size: 22),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _JobTag(label: job['location']!, icon: Icons.location_on_outlined),
                const SizedBox(width: 8),
                _JobTag(label: job['type']!, icon: Icons.schedule),
                const Spacer(),
                Text(job['salary']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _JobTag extends StatelessWidget {
  final String label;
  final IconData icon;

  const _JobTag({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: context.surfaceBg, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: context.textHintC),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: context.textSecondaryC)),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Widget? trailing;

  const _ProfileMenuItem({required this.icon, required this.label, required this.onTap, this.color, this.trailing});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Icon(icon, color: color ?? context.textSecondaryC, size: 22),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color ?? context.textPrimaryC))),
            trailing ?? Icon(Icons.chevron_right, color: color ?? context.textHintC, size: 20),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;
  final Color color;
  final VoidCallback onTap;

  const _WorkspaceCard({required this.icon, required this.label, required this.desc, required this.color, required this.onTap});

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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 24),
            ),
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
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text(icon, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textColor))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                  Text(desc, style: TextStyle(fontSize: 11, color: context.textSecondaryC)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: GuroJobsTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(AppStrings.t('coming_soon'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: GuroJobsTheme.primary)),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DEMO DATA
// ═══════════════════════════════════════════════════════════════
final List<Map<String, String>> _demoJobs = [
  {'title': 'Senior Casino Game Developer', 'company': 'Evolution Gaming', 'location': 'Malta', 'type': 'Full-time', 'salary': '€65-85K'},
  {'title': 'Sports Betting Product Manager', 'company': 'Betsson Group', 'location': 'Remote', 'type': 'Full-time', 'salary': '€55-70K'},
  {'title': 'iGaming Compliance Officer', 'company': 'LeoVegas', 'location': 'Gibraltar', 'type': 'Full-time', 'salary': '€50-65K'},
  {'title': 'eSports Marketing Manager', 'company': 'Pinnacle', 'location': 'Curacao', 'type': 'Full-time', 'salary': '€45-60K'},
  {'title': 'Slot Game Designer (UI/UX)', 'company': 'Pragmatic Play', 'location': 'Malta', 'type': 'Full-time', 'salary': '€40-55K'},
];
