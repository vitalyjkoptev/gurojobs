import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/localization.dart';
import '../../core/pricing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/contact_credits_provider.dart';
import '../../providers/lang_provider.dart';
import '../../providers/theme_provider.dart';
import '../client/candidate/notifications_screen.dart';
import '../client/candidate/settings_screen.dart';
import '../client/candidate/help_screen.dart';
import '../client/candidate/billing_screen.dart';
import '../client/candidate/chat_screen.dart';
import '../client/candidate/splash_screen.dart';
import '../client/candidate/category_gambling_screen.dart';
import '../client/candidate/category_betting_screen.dart';
import '../client/candidate/category_crypto_screen.dart';
import '../client/candidate/category_nutra_screen.dart';
import '../client/candidate/category_dating_screen.dart';
import '../client/candidate/category_ecommerce_screen.dart';
import '../client/candidate/category_fintech_screen.dart';
import '../client/candidate/category_other_screen.dart';

class EmployerDashboardScreen extends StatefulWidget {
  const EmployerDashboardScreen({super.key});

  @override
  State<EmployerDashboardScreen> createState() => _EmployerDashboardScreenState();
}

class _EmployerDashboardScreenState extends State<EmployerDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    context.watch<LangProvider>();

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _EmpHomeTab(goToJobs: () => setState(() => _currentIndex = 1), goToCandidates: () => setState(() => _currentIndex = 2)),
          _EmpJobsTab(goToCandidates: () => setState(() => _currentIndex = 2)),
          const _EmpCandidatesTab(),
          const ChatScreen(),
          const _EmpProfileTab(),
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
            BottomNavigationBarItem(icon: const Icon(Icons.dashboard_outlined), activeIcon: const Icon(Icons.dashboard), label: AppStrings.t('home')),
            BottomNavigationBarItem(icon: const Icon(Icons.work_outline), activeIcon: const Icon(Icons.work), label: AppStrings.t('emp_my_jobs')),
            BottomNavigationBarItem(icon: const Icon(Icons.people_outline), activeIcon: const Icon(Icons.people), label: AppStrings.t('emp_candidates')),
            BottomNavigationBarItem(icon: const Icon(Icons.chat_bubble_outline), activeIcon: const Icon(Icons.chat_bubble), label: AppStrings.t('chat')),
            BottomNavigationBarItem(icon: const Icon(Icons.business_outlined), activeIcon: const Icon(Icons.business), label: AppStrings.t('emp_company')),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// EMPLOYER HOME TAB
// ═══════════════════════════════════════════════════════════════
class _EmpHomeTab extends StatelessWidget {
  final VoidCallback goToJobs;
  final VoidCallback goToCandidates;
  const _EmpHomeTab({required this.goToJobs, required this.goToCandidates});

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
                  decoration: BoxDecoration(
                    color: GuroJobsTheme.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      (auth.userName ?? 'E')[0].toUpperCase(),
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
                        '${AppStrings.t('hello')}, ${auth.userName ?? AppStrings.t('employer')}!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC),
                      ),
                      Text(AppStrings.t('emp_welcome'), style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
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
            const SizedBox(height: 24),

            // Quick stats row 1
            Row(
              children: [
                _EmpStatCard(icon: Icons.work_outline, label: AppStrings.t('emp_active_jobs'), value: '4', color: GuroJobsTheme.primary),
                const SizedBox(width: 10),
                _EmpStatCard(icon: Icons.people_outline, label: AppStrings.t('emp_total_apps'), value: '23', color: GuroJobsTheme.accent),
                const SizedBox(width: 10),
                _EmpStatCard(icon: Icons.fiber_new_outlined, label: AppStrings.t('emp_new_today'), value: '5', color: GuroJobsTheme.success),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _EmpStatCard(icon: Icons.visibility_outlined, label: AppStrings.t('emp_job_views'), value: '187', color: GuroJobsTheme.info),
                const SizedBox(width: 10),
                _EmpStatCard(icon: Icons.videocam_outlined, label: AppStrings.t('interviews'), value: '3', color: GuroJobsTheme.warning),
                const SizedBox(width: 10),
                _EmpStatCard(icon: Icons.check_circle_outline, label: AppStrings.t('emp_hired'), value: '1', color: const Color(0xFF9C27B0)),
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
                  _EmpCategoryChip(image: 'assets/images/icon_gambling.png', label: AppStrings.t('gambling'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryGamblingScreen()))),
                  _EmpCategoryChip(image: 'assets/images/icon_betting.png', label: AppStrings.t('betting'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryBettingScreen()))),
                  _EmpCategoryChip(image: 'assets/images/icon_crypto.png', label: AppStrings.t('crypto'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryCryptoScreen()))),
                  _EmpCategoryChip(image: 'assets/images/icon_nutra.png', label: AppStrings.t('nutra'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryNutraScreen()))),
                  _EmpCategoryChip(image: 'assets/images/icon_dating.png', label: AppStrings.t('dating'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryDatingScreen()))),
                  _EmpCategoryChip(image: 'assets/images/icon_ecommerce.png', label: AppStrings.t('ecommerce'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryEcommerceScreen()))),
                  _EmpCategoryChip(image: 'assets/images/icon_fintech.png', label: AppStrings.t('fintech'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryFintechScreen()))),
                  _EmpCategoryChip(image: 'assets/images/icon_other.png', label: AppStrings.t('other'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryOtherScreen()))),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Quick actions
            Text(AppStrings.t('emp_quick_actions'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _QuickAction(
                    icon: Icons.add_circle_outline,
                    label: AppStrings.t('emp_post_job'),
                    color: GuroJobsTheme.primary,
                    onTap: goToJobs,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.search,
                    label: AppStrings.t('emp_search_talent'),
                    color: GuroJobsTheme.accent,
                    onTap: goToCandidates,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Recent applications
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.t('emp_recent_apps'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                TextButton(onPressed: goToCandidates, child: Text(AppStrings.t('see_all'))),
              ],
            ),
            const SizedBox(height: 8),
            ..._recentApps.map((app) => _ApplicationCard(app: app)),

            const SizedBox(height: 28),

            // Active jobs preview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.t('emp_active_jobs'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                TextButton(onPressed: goToJobs, child: Text(AppStrings.t('see_all'))),
              ],
            ),
            const SizedBox(height: 8),
            ..._demoEmployerJobs.take(3).map((j) => _EmployerJobCard(job: j)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// EMPLOYER JOBS TAB
// ═══════════════════════════════════════════════════════════════
class _EmpJobsTab extends StatefulWidget {
  final VoidCallback goToCandidates;
  const _EmpJobsTab({required this.goToCandidates});

  @override
  State<_EmpJobsTab> createState() => _EmpJobsTabState();
}

class _EmpJobsTabState extends State<_EmpJobsTab> {
  String _filter = 'all';

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'all') return _demoEmployerJobs;
    return _demoEmployerJobs.where((j) => j['status'] == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.t('emp_my_jobs'), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                ElevatedButton.icon(
                  onPressed: () => _showCreateJob(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(AppStrings.t('emp_post_job')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GuroJobsTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Filters
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _FilterChip(label: AppStrings.t('all'), selected: _filter == 'all', onTap: () => setState(() => _filter = 'all')),
                _FilterChip(label: AppStrings.t('emp_status_active'), selected: _filter == 'active', onTap: () => setState(() => _filter = 'active')),
                _FilterChip(label: AppStrings.t('emp_status_paused'), selected: _filter == 'paused', onTap: () => setState(() => _filter = 'paused')),
                _FilterChip(label: AppStrings.t('emp_status_closed'), selected: _filter == 'closed', onTap: () => setState(() => _filter = 'closed')),
                _FilterChip(label: AppStrings.t('emp_status_draft'), selected: _filter == 'draft', onTap: () => setState(() => _filter = 'draft')),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Jobs list
          Expanded(
            child: _filtered.isEmpty
                ? Center(child: Text(AppStrings.t('emp_no_jobs'), style: TextStyle(color: context.textHintC)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _EmployerJobCard(
                      job: _filtered[i],
                      onTap: () => _showJobDetail(context, _filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showCreateJob(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateJobSheet(),
    );
  }

  void _showJobDetail(BuildContext context, Map<String, dynamic> job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _JobDetailSheet(job: job, goToCandidates: widget.goToCandidates),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// EMPLOYER CANDIDATES TAB
// ═══════════════════════════════════════════════════════════════
class _EmpCandidatesTab extends StatefulWidget {
  const _EmpCandidatesTab();

  @override
  State<_EmpCandidatesTab> createState() => _EmpCandidatesTabState();
}

class _EmpCandidatesTabState extends State<_EmpCandidatesTab> {
  String _statusFilter = 'all';
  String? _jobFilter;

  List<Map<String, dynamic>> get _filtered {
    var list = _demoCandidates;
    if (_statusFilter != 'all') list = list.where((c) => c['status'] == _statusFilter).toList();
    if (_jobFilter != null) list = list.where((c) => c['job'] == _jobFilter).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Text(AppStrings.t('emp_candidates'), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text('${_demoCandidates.length}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Job filter dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.dividerC),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: _jobFilter,
                  isExpanded: true,
                  hint: Text(AppStrings.t('emp_all_positions'), style: TextStyle(color: context.textSecondaryC)),
                  icon: Icon(Icons.keyboard_arrow_down, color: context.textSecondaryC),
                  items: [
                    DropdownMenuItem(value: null, child: Text(AppStrings.t('emp_all_positions'))),
                    ..._demoEmployerJobs.map((j) => DropdownMenuItem(value: j['title'] as String, child: Text(j['title'] as String, overflow: TextOverflow.ellipsis))),
                  ],
                  onChanged: (v) => setState(() => _jobFilter = v),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Status filters
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _FilterChip(label: AppStrings.t('all'), selected: _statusFilter == 'all', onTap: () => setState(() => _statusFilter = 'all')),
                _FilterChip(label: AppStrings.t('emp_cand_new'), selected: _statusFilter == 'new', onTap: () => setState(() => _statusFilter = 'new'), dotColor: GuroJobsTheme.info),
                _FilterChip(label: AppStrings.t('emp_cand_reviewed'), selected: _statusFilter == 'reviewed', onTap: () => setState(() => _statusFilter = 'reviewed'), dotColor: GuroJobsTheme.warning),
                _FilterChip(label: AppStrings.t('emp_cand_interview'), selected: _statusFilter == 'interview', onTap: () => setState(() => _statusFilter = 'interview'), dotColor: GuroJobsTheme.accent),
                _FilterChip(label: AppStrings.t('emp_cand_hired'), selected: _statusFilter == 'hired', onTap: () => setState(() => _statusFilter = 'hired'), dotColor: GuroJobsTheme.success),
                _FilterChip(label: AppStrings.t('emp_cand_rejected'), selected: _statusFilter == 'rejected', onTap: () => setState(() => _statusFilter = 'rejected'), dotColor: GuroJobsTheme.error),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Candidates list
          Expanded(
            child: _filtered.isEmpty
                ? Center(child: Text(AppStrings.t('emp_no_candidates'), style: TextStyle(color: context.textHintC)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _CandidateCard(
                      candidate: _filtered[i],
                      onTap: () => _showCandidateDetail(context, _filtered[i]),
                      onStatusChanged: (status) {
                        setState(() => _filtered[i]['status'] = status);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showCandidateDetail(BuildContext context, Map<String, dynamic> candidate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CandidateDetailSheet(candidate: candidate, onStatusChanged: (s) => setState(() => candidate['status'] = s)),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// EMPLOYER PROFILE TAB
// ═══════════════════════════════════════════════════════════════
class _EmpProfileTab extends StatelessWidget {
  const _EmpProfileTab();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lang = context.watch<LangProvider>();
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Company avatar
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: GuroJobsTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.business, size: 40, color: GuroJobsTheme.primary),
            ),
            const SizedBox(height: 14),
            Text(auth.userName ?? 'Company', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            Text(auth.userEmail ?? '', style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(AppStrings.t('employer'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: GuroJobsTheme.primary)),
            ),
            const SizedBox(height: 28),

            // Stats summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ProfileStat(value: '4', label: AppStrings.t('emp_my_jobs')),
                  Container(width: 1, height: 30, color: context.dividerC),
                  _ProfileStat(value: '23', label: AppStrings.t('emp_candidates')),
                  Container(width: 1, height: 30, color: context.dividerC),
                  _ProfileStat(value: '1', label: AppStrings.t('emp_hired')),
                ],
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

            // Menu
            _ProfileMenuItem(icon: Icons.business_outlined, label: AppStrings.t('emp_company_profile'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _CompanyProfileScreen()))),
            _ProfileMenuItem(icon: Icons.description_outlined, label: AppStrings.t('emp_subscription'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BillingScreen()))),
            _ProfileMenuItem(icon: Icons.notifications_outlined, label: AppStrings.t('notifications'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()))),
            _ProfileMenuItem(icon: Icons.settings_outlined, label: AppStrings.t('settings'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
            _ProfileMenuItem(icon: Icons.help_outline, label: AppStrings.t('help'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen()))),
            const SizedBox(height: 12),
            _ProfileMenuItem(icon: Icons.logout, label: AppStrings.t('logout'), color: GuroJobsTheme.error, onTap: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const SplashScreen()), (_) => false);
            }),
          ],
        ),
      ),
    );
  }

  static void _showLanguagePicker(BuildContext context, LangProvider lang) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: context.cardBg,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
// SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════

class _EmpCategoryChip extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback? onTap;
  const _EmpCategoryChip({required this.image, required this.label, this.onTap});

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
        child: Center(
          child: Image.asset(image, width: 80, height: 80, color: const Color(0xFF015EA7)),
        ),
      ),
    );
  }
}

class _EmpStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _EmpStatCard({required this.icon, required this.label, required this.value, required this.color});

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
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
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

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? dotColor;

  const _FilterChip({required this.label, required this.selected, required this.onTap, this.dotColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? GuroJobsTheme.primary : context.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? GuroJobsTheme.primary : context.dividerC),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dotColor != null) ...[
              Container(width: 8, height: 8, decoration: BoxDecoration(color: selected ? Colors.white : dotColor, shape: BoxShape.circle)),
              const SizedBox(width: 6),
            ],
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: selected ? Colors.white : context.textPrimaryC)),
          ],
        ),
      ),
    );
  }
}

class _EmployerJobCard extends StatefulWidget {
  final Map<String, dynamic> job;
  final VoidCallback? onTap;

  const _EmployerJobCard({required this.job, this.onTap});

  @override
  State<_EmployerJobCard> createState() => _EmployerJobCardState();
}

class _EmployerJobCardState extends State<_EmployerJobCard> {
  bool _showNotes = false;
  late TextEditingController _noteCtrl;
  String get _jobKey => widget.job['title'] as String;

  @override
  void initState() {
    super.initState();
    _noteCtrl = TextEditingController(text: _jobNotes[_jobKey] ?? '');
  }
  @override
  void dispose() { _noteCtrl.dispose(); super.dispose(); }

  Color _statusColor(String status) {
    switch (status) {
      case 'active': return GuroJobsTheme.success;
      case 'paused': return GuroJobsTheme.warning;
      case 'closed': return GuroJobsTheme.error;
      case 'draft': return GuroJobsTheme.textHint;
      default: return GuroJobsTheme.info;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'active': return AppStrings.t('emp_status_active');
      case 'paused': return AppStrings.t('emp_status_paused');
      case 'closed': return AppStrings.t('emp_status_closed');
      case 'draft': return AppStrings.t('emp_status_draft');
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final status = job['status'] as String;
    final sc = _statusColor(status);
    final hasNote = (_jobNotes[_jobKey] ?? '').isNotEmpty;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: sc, width: 3)),
          boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: Text(job['title'] as String, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: sc.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                child: Text(_statusLabel(status), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: sc)),
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Icon(Icons.location_on_outlined, size: 14, color: context.textHintC),
              const SizedBox(width: 4),
              Text(job['location'] as String, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
              const SizedBox(width: 16),
              Icon(Icons.schedule, size: 14, color: context.textHintC),
              const SizedBox(width: 4),
              Text(job['type'] as String, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.people_outline, size: 14, color: GuroJobsTheme.primary),
                  const SizedBox(width: 4),
                  Text('${job['apps']} ${AppStrings.t('applications').toLowerCase()}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: GuroJobsTheme.primary)),
                ]),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: context.surfaceBg, borderRadius: BorderRadius.circular(6)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.visibility_outlined, size: 14, color: context.textHintC),
                  const SizedBox(width: 4),
                  Text('${job['views']}', style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
                ]),
              ),
              const Spacer(),
              Text(job['salary'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary)),
            ]),

            // Notes toggle
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _showNotes = !_showNotes),
              child: Row(children: [
                Icon(Icons.note_alt_outlined, size: 14, color: hasNote ? GuroJobsTheme.primary : context.textHintC),
                const SizedBox(width: 4),
                Text(
                  hasNote ? (_jobNotes[_jobKey]!.length > 40 ? '${_jobNotes[_jobKey]!.substring(0, 40)}...' : _jobNotes[_jobKey]!) : 'Add note...',
                  style: TextStyle(fontSize: 12, fontStyle: hasNote ? FontStyle.normal : FontStyle.italic, color: hasNote ? context.textSecondaryC : context.textHintC),
                ),
                const Spacer(),
                Icon(_showNotes ? Icons.expand_less : Icons.expand_more, size: 18, color: context.textHintC),
              ]),
            ),

            // Notes field
            if (_showNotes) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _noteCtrl,
                maxLines: 3,
                style: TextStyle(fontSize: 13, color: context.textPrimaryC),
                decoration: InputDecoration(
                  hintText: 'Private notes about this job...',
                  hintStyle: TextStyle(fontSize: 13, color: context.textHintC),
                  filled: true,
                  fillColor: context.surfaceBg,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.dividerC)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.dividerC)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: GuroJobsTheme.primary)),
                ),
                onChanged: (v) => _jobNotes[_jobKey] = v,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final Map<String, dynamic> app;
  const _ApplicationCard({required this.app});

  Color _statusColor(String status) {
    switch (status) {
      case 'new': return GuroJobsTheme.info;
      case 'reviewed': return GuroJobsTheme.warning;
      case 'interview': return GuroJobsTheme.accent;
      case 'hired': return GuroJobsTheme.success;
      case 'rejected': return GuroJobsTheme.error;
      default: return GuroJobsTheme.textHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sc = _statusColor(app['status'] as String);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 6, offset: const Offset(0, 1))],
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: sc.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text((app['name'] as String)[0], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: sc))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(app['name'] as String, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                Text(app['job'] as String, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
              ],
            ),
          ),
          Container(
            width: 10, height: 10,
            decoration: BoxDecoration(color: sc, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  final Map<String, dynamic> candidate;
  final VoidCallback onTap;
  final ValueChanged<String> onStatusChanged;

  const _CandidateCard({required this.candidate, required this.onTap, required this.onStatusChanged});

  Color _statusColor(String status) {
    switch (status) {
      case 'new': return GuroJobsTheme.info;
      case 'reviewed': return GuroJobsTheme.warning;
      case 'interview': return GuroJobsTheme.accent;
      case 'hired': return GuroJobsTheme.success;
      case 'rejected': return GuroJobsTheme.error;
      default: return GuroJobsTheme.textHint;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'new': return AppStrings.t('emp_cand_new');
      case 'reviewed': return AppStrings.t('emp_cand_reviewed');
      case 'interview': return AppStrings.t('emp_cand_interview');
      case 'hired': return AppStrings.t('emp_cand_hired');
      case 'rejected': return AppStrings.t('emp_cand_rejected');
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = candidate['status'] as String;
    final sc = _statusColor(status);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: sc, width: 3)),
          boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: sc.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text((candidate['name'] as String)[0], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: sc))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(candidate['name'] as String, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                      Text(candidate['position'] as String, style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: sc.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                  child: Text(_statusLabel(status), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: sc)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.work_outline, size: 14, color: context.textHintC),
                const SizedBox(width: 4),
                Text(candidate['job'] as String, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                if (candidate['experience'] != null) ...[
                  Icon(Icons.timeline, size: 14, color: context.textHintC),
                  const SizedBox(width: 4),
                  Text(candidate['experience'] as String, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
                  const SizedBox(width: 16),
                ],
                if (candidate['salary'] != null) ...[
                  const Icon(Icons.payments_outlined, size: 14, color: GuroJobsTheme.primary),
                  const SizedBox(width: 4),
                  Text(candidate['salary'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: GuroJobsTheme.primary)),
                ],
                const Spacer(),
                Text(candidate['date'] as String, style: TextStyle(fontSize: 11, color: context.textHintC)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DETAIL SHEETS
// ═══════════════════════════════════════════════════════════════

class _CandidateDetailSheet extends StatefulWidget {
  final Map<String, dynamic> candidate;
  final ValueChanged<String> onStatusChanged;

  const _CandidateDetailSheet({required this.candidate, required this.onStatusChanged});

  @override
  State<_CandidateDetailSheet> createState() => _CandidateDetailSheetState();
}

class _CandidateDetailSheetState extends State<_CandidateDetailSheet> {
  Map<String, dynamic> get candidate => widget.candidate;
  late TextEditingController _noteCtrl;

  @override
  void initState() {
    super.initState();
    _noteCtrl = TextEditingController(text: _candidateNotes[candidate['name']] ?? '');
  }
  @override
  void dispose() { _noteCtrl.dispose(); super.dispose(); }

  void _revealContact(ContactCreditsProvider credits) {
    final candidateId = candidate['name'] as String;

    if (credits.isUnlocked(candidateId)) return; // already unlocked

    if (!credits.hasCredits) {
      // No credits left — show upgrade dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(children: [
            const Icon(Icons.block, color: GuroJobsTheme.error, size: 22),
            const SizedBox(width: 8),
            Expanded(child: Text(AppStrings.t('no_credits_left'), style: const TextStyle(fontSize: 17))),
          ]),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(AppStrings.t('no_credits_desc'),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: GuroJobsTheme.error.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('0 / ${credits.dailyLimit}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: GuroJobsTheme.error)),
                const SizedBox(width: 8),
                Text(AppStrings.t('daily_limit'), style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ]),
            ),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(AppStrings.t('cancel'), style: TextStyle(color: Colors.grey[600]))),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const BillingScreen()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: Text(AppStrings.t('upgrade_plan')),
            ),
          ],
        ),
      );
      return;
    }

    // Has credits — confirm reveal
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          const Icon(Icons.lock_open, color: GuroJobsTheme.primary, size: 22),
          const SizedBox(width: 8),
          Expanded(child: Text(AppStrings.t('reveal_contact'), style: const TextStyle(fontSize: 17))),
        ]),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(AppStrings.t('reveal_contact_confirm'),
            style: TextStyle(fontSize: 14, color: Colors.grey[600]), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(AppStrings.t('reveal_contact_cost'),
            style: TextStyle(fontSize: 13, color: Colors.grey[500]), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: GuroJobsTheme.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.confirmation_number_outlined, color: GuroJobsTheme.primary, size: 20),
              const SizedBox(width: 8),
              Text('${credits.remaining}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: GuroJobsTheme.primary)),
              const SizedBox(width: 6),
              Text(AppStrings.t('credits_remaining'), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ]),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppStrings.t('cancel'), style: TextStyle(color: Colors.grey[600]))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final ok = credits.revealContact(candidateId);
              if (ok) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(AppStrings.t('contact_revealed')),
                  backgroundColor: GuroJobsTheme.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Text(AppStrings.t('reveal_contact')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = candidate['status'] as String;
    final credits = context.watch<ContactCreditsProvider>();
    final candidateId = candidate['name'] as String;
    final isRevealed = credits.isUnlocked(candidateId);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: controller,
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),

            // Candidate header
            Row(children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(color: GuroJobsTheme.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                child: Center(child: Text((candidate['name'] as String)[0], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary))),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(candidate['name'] as String, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                Text(candidate['position'] as String, style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
              ])),
            ]),
            const SizedBox(height: 20),

            // Public info (no contacts!)
            _DetailRow(icon: Icons.work_outline, label: AppStrings.t('emp_applied_for'), value: candidate['job'] as String),
            if (candidate['experience'] != null) _DetailRow(icon: Icons.timeline, label: AppStrings.t('experience'), value: candidate['experience'] as String),
            if (candidate['salary'] != null) _DetailRow(icon: Icons.payments_outlined, label: AppStrings.t('salary_expectation'), value: candidate['salary'] as String),
            if (candidate['location'] != null) _DetailRow(icon: Icons.location_on_outlined, label: AppStrings.t('location'), value: candidate['location'] as String),
            _DetailRow(icon: Icons.calendar_today_outlined, label: AppStrings.t('applied'), value: candidate['date'] as String),
            const SizedBox(height: 20),

            // Skills
            if (candidate['skills'] != null) ...[
              Text(AppStrings.t('skills'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: (candidate['skills'] as List<String>).map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                  child: Text(s, style: const TextStyle(fontSize: 12, color: GuroJobsTheme.primary)),
                )).toList(),
              ),
              const SizedBox(height: 20),
            ],

            // ═══ CONTACTS SECTION ═══
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.surfaceBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isRevealed ? GuroJobsTheme.success.withValues(alpha: 0.3) : context.dividerC),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(isRevealed ? Icons.contact_phone : Icons.lock_outline, size: 18, color: isRevealed ? GuroJobsTheme.success : context.textPrimaryC),
                  const SizedBox(width: 8),
                  Text(AppStrings.t('contacts'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                  const Spacer(),
                  if (!isRevealed)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: GuroJobsTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('${credits.remaining}/${credits.dailyLimit}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: GuroJobsTheme.primary)),
                    ),
                ]),
                const SizedBox(height: 14),

                if (isRevealed) ...[
                  // REVEALED — show all contacts
                  if (candidate['email'] != null)
                    _RevealedContactRow(icon: Icons.email_outlined, label: AppStrings.t('contact_email'), value: candidate['email'] as String),
                  if (candidate['telegram'] != null)
                    _RevealedContactRow(icon: Icons.send, label: AppStrings.t('contact_telegram'), value: candidate['telegram'] as String),
                  if (candidate['phone'] != null)
                    _RevealedContactRow(icon: Icons.phone_outlined, label: AppStrings.t('contact_phone'), value: candidate['phone'] as String? ?? '—'),
                  // LinkedIn — only Premium/VIP
                  if (candidate['linkedin'] != null)
                    ContactPricing.hasLinkedin(credits.plan)
                      ? _RevealedContactRow(icon: Icons.business_center, label: 'LinkedIn', value: candidate['linkedin'] as String)
                      : _LockedFeatureRow(icon: Icons.business_center, label: 'LinkedIn', badge: 'Premium'),
                ] else ...[
                  // HIDDEN — blurred placeholders
                  _HiddenContactRow(icon: Icons.email_outlined, label: AppStrings.t('contact_email')),
                  const SizedBox(height: 8),
                  _HiddenContactRow(icon: Icons.send, label: AppStrings.t('contact_telegram')),
                  const SizedBox(height: 8),
                  _HiddenContactRow(icon: Icons.phone_outlined, label: AppStrings.t('contact_phone')),
                  const SizedBox(height: 8),
                  _LockedFeatureRow(icon: Icons.business_center, label: 'LinkedIn', badge: 'Premium'),
                  const SizedBox(height: 14),

                  // Reveal button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _revealContact(credits),
                      icon: const Icon(Icons.lock_open, size: 18),
                      label: Text('${AppStrings.t('reveal_contact')}  (-1 ${AppStrings.t('daily_limit').toLowerCase()})'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GuroJobsTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ]),
            ),
            const SizedBox(height: 20),

            // Private notes
            Text('Notes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
            const SizedBox(height: 8),
            TextField(
              controller: _noteCtrl,
              maxLines: 3,
              style: TextStyle(fontSize: 13, color: context.textPrimaryC),
              decoration: InputDecoration(
                hintText: 'Private notes about this candidate...',
                hintStyle: TextStyle(fontSize: 13, color: context.textHintC),
                filled: true,
                fillColor: context.surfaceBg,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.dividerC)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.dividerC)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: GuroJobsTheme.primary)),
              ),
              onChanged: (v) => _candidateNotes[candidate['name'] as String] = v,
            ),
            const SizedBox(height: 20),

            // Status actions
            Text(AppStrings.t('emp_change_status'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [
              _StatusButton(label: AppStrings.t('emp_cand_reviewed'), color: GuroJobsTheme.warning, selected: status == 'reviewed', onTap: () { widget.onStatusChanged('reviewed'); Navigator.pop(context); }),
              _StatusButton(label: AppStrings.t('emp_cand_interview'), color: GuroJobsTheme.accent, selected: status == 'interview', onTap: () { widget.onStatusChanged('interview'); Navigator.pop(context); }),
              _StatusButton(label: AppStrings.t('emp_cand_hired'), color: GuroJobsTheme.success, selected: status == 'hired', onTap: () { widget.onStatusChanged('hired'); Navigator.pop(context); }),
              _StatusButton(label: AppStrings.t('emp_cand_rejected'), color: GuroJobsTheme.error, selected: status == 'rejected', onTap: () { widget.onStatusChanged('rejected'); Navigator.pop(context); }),
            ]),
            const SizedBox(height: 20),

            // Bottom buttons
            Row(children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isRevealed ? () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
                  } : () => _revealContact(credits),
                  icon: Icon(isRevealed ? Icons.chat_bubble_outline : Icons.lock_outline, size: 18),
                  label: Text(isRevealed ? AppStrings.t('emp_write_msg') : AppStrings.t('reveal_contact')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRevealed ? GuroJobsTheme.primary : Colors.grey[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showCandidateCvDialog(context, candidate);
                  },
                  icon: const Icon(Icons.description_outlined, size: 18),
                  label: Text(AppStrings.t('emp_view_cv')),
                  style: OutlinedButton.styleFrom(foregroundColor: GuroJobsTheme.primary, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), side: const BorderSide(color: GuroJobsTheme.primary)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

/// Revealed contact — shows actual data
class _RevealedContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _RevealedContactRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Icon(icon, size: 18, color: GuroJobsTheme.primary),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 11, color: context.textHintC)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: GuroJobsTheme.primary)),
        ])),
        const Icon(Icons.check_circle, size: 18, color: GuroJobsTheme.success),
      ]),
    );
  }
}

/// Hidden contact — blurred placeholder
class _HiddenContactRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HiddenContactRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 18, color: Colors.grey[400]),
      const SizedBox(width: 10),
      Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
      const Spacer(),
      Container(
        width: 90, height: 16,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      const SizedBox(width: 8),
      Icon(Icons.lock_outline, size: 16, color: Colors.grey[400]),
    ]);
  }
}

/// Locked feature — shows plan badge required
class _LockedFeatureRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String badge;

  const _LockedFeatureRow({required this.icon, required this.label, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Icon(icon, size: 18, color: Colors.grey[400]),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF015EA7)]),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.lock, size: 10, color: Colors.white),
            const SizedBox(width: 4),
            Text(badge, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
          ]),
        ),
      ]),
    );
  }
}

void _showCandidateCvDialog(BuildContext context, Map<String, dynamic> candidate) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.description, size: 30, color: GuroJobsTheme.primary),
            ),
            const SizedBox(height: 16),
            Text(candidate['name'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(candidate['position'] as String, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 20),
            if (candidate['skills'] != null) ...[
              const Align(alignment: Alignment.centerLeft, child: Text('Skills', style: TextStyle(fontWeight: FontWeight.w600))),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6, runSpacing: 6,
                children: (candidate['skills'] as List<String>).map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                  child: Text(s, style: const TextStyle(fontSize: 12, color: GuroJobsTheme.primary)),
                )).toList(),
              ),
              const SizedBox(height: 16),
            ],
            if (candidate['experience'] != null) ...[
              Row(children: [
                const Icon(Icons.work_outline, size: 16, color: GuroJobsTheme.primary),
                const SizedBox(width: 6),
                Text(candidate['experience'] as String, style: const TextStyle(fontSize: 14)),
              ]),
              const SizedBox(height: 8),
            ],
            if (candidate['salary'] != null) ...[
              Row(children: [
                const Icon(Icons.payments_outlined, size: 16, color: GuroJobsTheme.primary),
                const SizedBox(width: 6),
                Text(candidate['salary'] as String, style: const TextStyle(fontSize: 14)),
              ]),
              const SizedBox(height: 8),
            ],
            if (candidate['location'] != null)
              Row(children: [
                const Icon(Icons.location_on_outlined, size: 16, color: GuroJobsTheme.primary),
                const SizedBox(width: 6),
                Text(candidate['location'] as String, style: const TextStyle(fontSize: 14)),
              ]),
            // Contacts are only visible after reveal
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Icon(Icons.info_outline, size: 16, color: Colors.orange[700]),
                const SizedBox(width: 8),
                Expanded(child: Text(AppStrings.t('contacts_hidden'),
                  style: TextStyle(fontSize: 12, color: Colors.orange[700]))),
              ]),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _JobDetailSheet extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback goToCandidates;

  const _JobDetailSheet({required this.job, required this.goToCandidates});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.all(20),
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text(job['title'] as String, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: context.textHintC),
                const SizedBox(width: 4),
                Text(job['location'] as String, style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
                const SizedBox(width: 16),
                Icon(Icons.schedule, size: 16, color: context.textHintC),
                const SizedBox(width: 4),
                Text(job['type'] as String, style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
              ],
            ),
            const SizedBox(height: 6),
            Text(job['salary'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary)),
            const SizedBox(height: 20),

            // Stats
            Row(
              children: [
                _JobStatBox(icon: Icons.people_outline, value: '${job['apps']}', label: AppStrings.t('applications')),
                const SizedBox(width: 10),
                _JobStatBox(icon: Icons.visibility_outlined, value: '${job['views']}', label: AppStrings.t('profile_views')),
                const SizedBox(width: 10),
                _JobStatBox(icon: Icons.calendar_today_outlined, value: job['posted'] as String, label: AppStrings.t('emp_posted')),
              ],
            ),
            const SizedBox(height: 24),

            // Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () { Navigator.pop(context); goToCandidates(); },
                    icon: const Icon(Icons.people_outline, size: 18),
                    label: Text(AppStrings.t('emp_view_apps')),
                    style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => _CreateJobSheet(initialData: job),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(AppStrings.t('edit')),
                    style: OutlinedButton.styleFrom(foregroundColor: GuroJobsTheme.primary, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), side: const BorderSide(color: GuroJobsTheme.primary)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateJobSheet extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const _CreateJobSheet({this.initialData});
  @override
  State<_CreateJobSheet> createState() => _CreateJobSheetState();
}

class _CreateJobSheetState extends State<_CreateJobSheet> {
  final _titleCtrl = TextEditingController();
  final _salaryCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _type = 'Full-time';
  String _location = 'Remote';
  String _vertical = 'gambling';
  bool get _isEditing => widget.initialData != null;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _titleCtrl.text = widget.initialData!['title'] as String? ?? '';
      _salaryCtrl.text = widget.initialData!['salary'] as String? ?? '';
      _type = widget.initialData!['type'] as String? ?? 'Full-time';
      _location = widget.initialData!['location'] as String? ?? 'Remote';
    }
  }

  final _requirementsCtrl = TextEditingController();
  final _tagsCtrl = TextEditingController();
  String _level = 'Middle';

  static const _types = ['Full-time', 'Part-time', 'Contract', 'Freelance'];
  static const _locations = ['Remote', 'Office', 'Hybrid'];
  static const _levels = ['C-Level', 'Head', 'Senior', 'Middle', 'Junior'];
  static const _verticals = ['gambling', 'betting', 'crypto', 'nutra', 'dating', 'ecommerce', 'fintech', 'other'];

  @override
  void dispose() { _titleCtrl.dispose(); _salaryCtrl.dispose(); _descCtrl.dispose(); _requirementsCtrl.dispose(); _tagsCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.all(20),
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text(_isEditing ? AppStrings.t('edit') : AppStrings.t('emp_post_new_job'), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 20),

            _buildLabel(context, AppStrings.t('emp_job_title')),
            _buildInput(context, _titleCtrl, AppStrings.t('emp_job_title_hint')),
            const SizedBox(height: 16),

            _buildLabel(context, AppStrings.t('emp_vertical')),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _verticals.map((v) => GestureDetector(
                onTap: () => setState(() => _vertical = v),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _vertical == v ? GuroJobsTheme.primary : context.surfaceBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _vertical == v ? GuroJobsTheme.primary : context.dividerC),
                  ),
                  child: Text(AppStrings.t(v), style: TextStyle(fontSize: 13, color: _vertical == v ? Colors.white : context.textPrimaryC)),
                ),
              )).toList(),
            ),
            const SizedBox(height: 16),

            _buildLabel(context, AppStrings.t('salary_expectation')),
            _buildInput(context, _salaryCtrl, '€3,000 - €5,000'),
            const SizedBox(height: 16),

            _buildLabel(context, AppStrings.t('emp_work_type')),
            Wrap(
              spacing: 8,
              children: _types.map((t) => ChoiceChip(
                label: Text(t),
                selected: _type == t,
                onSelected: (s) { if (s) setState(() => _type = t); },
                selectedColor: GuroJobsTheme.primary.withOpacity(0.15),
                labelStyle: TextStyle(color: _type == t ? GuroJobsTheme.primary : context.textPrimaryC, fontWeight: _type == t ? FontWeight.w600 : FontWeight.normal),
              )).toList(),
            ),
            const SizedBox(height: 16),

            _buildLabel(context, AppStrings.t('location')),
            Wrap(
              spacing: 8,
              children: _locations.map((l) => ChoiceChip(
                label: Text(l),
                selected: _location == l,
                onSelected: (s) { if (s) setState(() => _location = l); },
                selectedColor: GuroJobsTheme.primary.withOpacity(0.15),
                labelStyle: TextStyle(color: _location == l ? GuroJobsTheme.primary : context.textPrimaryC, fontWeight: _location == l ? FontWeight.w600 : FontWeight.normal),
              )).toList(),
            ),
            const SizedBox(height: 16),

            _buildLabel(context, AppStrings.t('experience')),
            Wrap(
              spacing: 8,
              children: _levels.map((l) => ChoiceChip(
                label: Text(l),
                selected: _level == l,
                onSelected: (s) { if (s) setState(() => _level = l); },
                selectedColor: GuroJobsTheme.primary.withValues(alpha: 0.15),
                labelStyle: TextStyle(color: _level == l ? GuroJobsTheme.primary : context.textPrimaryC, fontWeight: _level == l ? FontWeight.w600 : FontWeight.normal),
              )).toList(),
            ),
            const SizedBox(height: 16),

            _buildLabel(context, AppStrings.t('description')),
            _buildInput(context, _descCtrl, AppStrings.t('emp_job_desc_hint'), maxLines: 5),
            const SizedBox(height: 16),

            _buildLabel(context, AppStrings.t('requirements')),
            _buildInput(context, _requirementsCtrl, AppStrings.t('requirements_hint'), maxLines: 4),
            const SizedBox(height: 16),

            _buildLabel(context, AppStrings.t('tags')),
            _buildInput(context, _tagsCtrl, AppStrings.t('tags_hint')),
            const SizedBox(height: 24),

            // Preview & Publish button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_titleCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(AppStrings.t('emp_title_required')),
                      backgroundColor: GuroJobsTheme.error,
                      behavior: SnackBarBehavior.floating,
                    ));
                    return;
                  }
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => _JobPreviewScreen(
                    title: _titleCtrl.text,
                    salary: _salaryCtrl.text,
                    description: _descCtrl.text,
                    requirements: _requirementsCtrl.text,
                    tags: _tagsCtrl.text,
                    type: _type,
                    location: _location,
                    level: _level,
                    vertical: _vertical,
                    isEditing: _isEditing,
                  )));
                },
                icon: const Icon(Icons.visibility, size: 18),
                label: Text(AppStrings.t('preview_and_publish'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
    );
  }

  Widget _buildInput(BuildContext context, TextEditingController ctrl, String hint, {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: TextStyle(fontSize: 14, color: context.textPrimaryC),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: context.textHintC),
        filled: true,
        fillColor: context.inputFill,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.dividerC)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.dividerC)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: GuroJobsTheme.primary)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SMALL HELPERS
// ═══════════════════════════════════════════════════════════════

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: context.textHintC),
          const SizedBox(width: 10),
          Text('$label:', style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
          const SizedBox(width: 6),
          Expanded(child: Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: context.textPrimaryC))),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  const _StatusButton({required this.label, required this.color, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? Colors.white : color)),
      ),
    );
  }
}

class _JobStatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _JobStatBox({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: context.surfaceBg, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Icon(icon, size: 20, color: GuroJobsTheme.primary),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            Text(label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: context.textSecondaryC)),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
        Text(label, style: TextStyle(fontSize: 11, color: context.textSecondaryC)),
      ],
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
    final c = color ?? context.textPrimaryC;
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        leading: Icon(icon, color: c, size: 22),
        title: Text(label, style: TextStyle(fontSize: 15, color: c)),
        trailing: trailing ?? Icon(Icons.chevron_right, color: context.textHintC, size: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: onTap,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// JOB PREVIEW → PUBLISH FLOW
// ═══════════════════════════════════════════════════════════════

class _JobPreviewScreen extends StatelessWidget {
  final String title, salary, description, requirements, tags, type, location, level, vertical;
  final bool isEditing;

  const _JobPreviewScreen({
    required this.title, required this.salary, required this.description,
    required this.requirements, required this.tags, required this.type,
    required this.location, required this.level, required this.vertical,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t('job_preview'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF015EA7), Color(0xFF0288D1)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                child: Text(AppStrings.t(vertical), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 8),
              Wrap(spacing: 10, runSpacing: 6, children: [
                _chip(Icons.work_outline, type),
                _chip(Icons.location_on_outlined, location),
                _chip(Icons.timeline, level),
                if (salary.isNotEmpty) _chip(Icons.payments_outlined, salary),
              ]),
            ]),
          ),
          const SizedBox(height: 24),

          // Description
          if (description.isNotEmpty) ...[
            Text(AppStrings.t('description'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 8),
            Text(description, style: TextStyle(fontSize: 14, color: context.textSecondaryC, height: 1.6)),
            const SizedBox(height: 20),
          ],

          // Requirements
          if (requirements.isNotEmpty) ...[
            Text(AppStrings.t('requirements'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 8),
            ...requirements.split('\n').where((l) => l.trim().isNotEmpty).map((line) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.check_circle_outline, size: 16, color: GuroJobsTheme.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(line.trim(), style: TextStyle(fontSize: 14, color: context.textSecondaryC))),
              ]),
            )),
            const SizedBox(height: 20),
          ],

          // Tags
          if (tags.isNotEmpty) ...[
            Text(AppStrings.t('tags'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: tags.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).map((t) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: GuroJobsTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                child: Text(t, style: const TextStyle(fontSize: 12, color: GuroJobsTheme.primary)),
              )).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Info note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFF3E5F5), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Icon(Icons.info_outline, size: 18, color: Colors.purple[700]),
              const SizedBox(width: 10),
              Expanded(child: Text(AppStrings.t('job_preview_note'), style: TextStyle(fontSize: 12, color: Colors.purple[800]))),
            ]),
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.edit, size: 18),
                label: Text(AppStrings.t('edit')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: GuroJobsTheme.primary,
                  side: const BorderSide(color: GuroJobsTheme.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => _JobPublishingScreen(
                  title: title, vertical: vertical, isEditing: isEditing,
                ))),
                icon: const Icon(Icons.publish, size: 18),
                label: Text(AppStrings.t('emp_publish_job')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: GuroJobsTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: Colors.white),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.white)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// JOB PUBLISHING — animated processing
// ═══════════════════════════════════════════════════════════════

class _JobPublishingScreen extends StatefulWidget {
  final String title, vertical;
  final bool isEditing;

  const _JobPublishingScreen({required this.title, required this.vertical, required this.isEditing});

  @override
  State<_JobPublishingScreen> createState() => _JobPublishingState();
}

class _JobPublishingState extends State<_JobPublishingScreen> {
  int _step = 0;
  final _steps = <String>[];

  @override
  void initState() {
    super.initState();
    _steps.addAll([
      AppStrings.t('step_validating_job'),
      AppStrings.t('step_checking_plan'),
      AppStrings.t('step_publishing'),
      AppStrings.t('step_indexing'),
    ]);
    _runSteps();
  }

  Future<void> _runSteps() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(Duration(milliseconds: i == _steps.length - 1 ? 600 : 1000));
      if (!mounted) return;
      setState(() => _step = i + 1);
    }
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => _JobPublishedScreen(
      title: widget.title, vertical: widget.vertical, isEditing: widget.isEditing,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: 80, height: 80,
                child: CircularProgressIndicator(
                  value: _step >= _steps.length ? 1.0 : null,
                  strokeWidth: 4, color: GuroJobsTheme.primary,
                ),
              ),
              const SizedBox(height: 30),
              Text(widget.isEditing ? AppStrings.t('updating_job') : AppStrings.t('publishing_job'),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
              const SizedBox(height: 8),
              Text('"${widget.title}"', style: TextStyle(fontSize: 15, color: context.textSecondaryC), textAlign: TextAlign.center),
              const SizedBox(height: 30),
              ...List.generate(_steps.length, (i) {
                final done = _step > i;
                final current = _step == i;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(children: [
                    done
                      ? const Icon(Icons.check_circle, size: 22, color: GuroJobsTheme.success)
                      : current
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: GuroJobsTheme.primary))
                        : Icon(Icons.radio_button_unchecked, size: 22, color: context.dividerC),
                    const SizedBox(width: 12),
                    Text(_steps[i], style: TextStyle(
                      fontSize: 14,
                      color: done ? GuroJobsTheme.success : (current ? context.textPrimaryC : context.textHintC),
                      fontWeight: current ? FontWeight.w600 : FontWeight.w400,
                    )),
                  ]),
                );
              }),
            ]),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// JOB PUBLISHED — success screen
// ═══════════════════════════════════════════════════════════════

class _JobPublishedScreen extends StatelessWidget {
  final String title, vertical;
  final bool isEditing;

  const _JobPublishedScreen({required this.title, required this.vertical, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              const SizedBox(height: 40),

              // Success icon
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: GuroJobsTheme.success.withValues(alpha: 0.12),
                ),
                child: const Icon(Icons.check_circle, size: 60, color: GuroJobsTheme.success),
              ),
              const SizedBox(height: 20),
              Text(isEditing ? AppStrings.t('job_updated') : AppStrings.t('job_published'),
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: context.textPrimaryC)),
              const SizedBox(height: 8),
              Text('"$title"', style: TextStyle(fontSize: 16, color: context.textSecondaryC), textAlign: TextAlign.center),
              const SizedBox(height: 30),

              // Stats card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(children: [
                  _infoRow(context, AppStrings.t('status'), AppStrings.t('active'), GuroJobsTheme.success),
                  _infoRow(context, AppStrings.t('emp_vertical'), AppStrings.t(vertical), GuroJobsTheme.primary),
                  _infoRow(context, AppStrings.t('visibility'), AppStrings.t('public'), GuroJobsTheme.info),
                  _infoRow(context, AppStrings.t('posted_at'), _now(), context.textSecondaryC),
                  const SizedBox(height: 12),
                  Divider(color: context.dividerC),
                  const SizedBox(height: 12),
                  Row(children: [
                    Icon(Icons.info_outline, size: 14, color: context.textHintC),
                    const SizedBox(width: 6),
                    Expanded(child: Text(AppStrings.t('job_visible_note'), style: TextStyle(fontSize: 12, color: context.textHintC))),
                  ]),
                ]),
              ),
              const SizedBox(height: 20),

              // What happens next
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: GuroJobsTheme.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: GuroJobsTheme.primary.withValues(alpha: 0.15)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(AppStrings.t('what_happens_next'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                  const SizedBox(height: 14),
                  _nextStep(context, '1', AppStrings.t('next_candidates_see')),
                  _nextStep(context, '2', AppStrings.t('next_applications')),
                  _nextStep(context, '3', AppStrings.t('next_review')),
                ]),
              ),
              const SizedBox(height: 30),

              // Done button
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  icon: const Icon(Icons.dashboard, size: 20),
                  label: Text(AppStrings.t('back_to_dashboard'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GuroJobsTheme.primary, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: valueColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
          child: Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor)),
        ),
      ]),
    );
  }

  Widget _nextStep(BuildContext context, String num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(color: GuroJobsTheme.primary, borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(num, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white))),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: TextStyle(fontSize: 14, color: context.textSecondaryC, height: 1.4))),
      ]),
    );
  }

  String _now() {
    final n = DateTime.now();
    return '${n.day.toString().padLeft(2, '0')}.${n.month.toString().padLeft(2, '0')}.${n.year} ${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}';
  }
}

// ═══════════════════════════════════════════════════════════════
// DEMO DATA
// ═══════════════════════════════════════════════════════════════

class _CompanyProfileScreen extends StatefulWidget {
  const _CompanyProfileScreen();
  @override
  State<_CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<_CompanyProfileScreen> {
  final _nameCtrl = TextEditingController(text: 'Demo Gaming Ltd');
  final _descCtrl = TextEditingController(text: 'Leading iGaming company specializing in online casino and sports betting solutions. Founded in 2018, operating in 15+ markets worldwide.');
  final _websiteCtrl = TextEditingController(text: 'https://demogaming.com');
  final _locationCtrl = TextEditingController(text: 'Malta');
  final _sizeCtrl = TextEditingController(text: '50-200');
  final _emailCtrl = TextEditingController(text: 'hr@demogaming.com');
  final _phoneCtrl = TextEditingController(text: '+356 2123 4567');
  final _telegramCtrl = TextEditingController(text: '@demogaming');
  String _vertical = 'gambling';

  @override
  void dispose() { _nameCtrl.dispose(); _descCtrl.dispose(); _websiteCtrl.dispose(); _locationCtrl.dispose(); _sizeCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose(); _telegramCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t('emp_company_profile'), style: TextStyle(color: context.textPrimaryC, fontWeight: FontWeight.w700)),
        backgroundColor: context.cardBg,
        elevation: 0,
        iconTheme: IconThemeData(color: context.textPrimaryC),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Logo
          Center(child: Column(children: [
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(22)),
              child: const Icon(Icons.business, size: 44, color: GuroJobsTheme.primary),
            ),
            const SizedBox(height: 10),
            TextButton.icon(onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined, size: 16), label: const Text('Change Logo'), style: TextButton.styleFrom(foregroundColor: GuroJobsTheme.primary)),
          ])),
          const SizedBox(height: 24),

          _buildField('Company Name', _nameCtrl, Icons.business),
          _buildField('Description', _descCtrl, Icons.description_outlined, maxLines: 4),
          _buildField('Website', _websiteCtrl, Icons.language),
          _buildField('Location', _locationCtrl, Icons.location_on_outlined),
          _buildField('Company Size', _sizeCtrl, Icons.people_outline),
          _buildField('Telegram', _telegramCtrl, Icons.send),
          _buildField('Contact Email', _emailCtrl, Icons.email_outlined),
          _buildField('Phone', _phoneCtrl, Icons.phone_outlined),

          const SizedBox(height: 16),
          Text('Industry', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: ['gambling', 'betting', 'crypto', 'nutra', 'dating', 'ecommerce', 'fintech', 'other'].map((v) {
            final selected = _vertical == v;
            return GestureDetector(
              onTap: () => setState(() => _vertical = v),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? GuroJobsTheme.primary : context.surfaceBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: selected ? GuroJobsTheme.primary : context.dividerC),
                ),
                child: Text(AppStrings.t(v), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: selected ? Colors.white : context.textSecondaryC)),
              ),
            );
          }).toList()),

          const SizedBox(height: 24),

          // Verified badge
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: GuroJobsTheme.success.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Icon(Icons.verified, color: GuroJobsTheme.success, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Verified Company', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                Text('Your company is verified and visible to candidates', style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
              ])),
            ]),
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Company profile saved!'), backgroundColor: GuroJobsTheme.success,
                  behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ));
              },
              icon: const Icon(Icons.save, size: 20),
              label: const Text('Save Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          style: TextStyle(fontSize: 15, color: context.textPrimaryC),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: context.textHintC),
            filled: true, fillColor: context.inputFill,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: GuroJobsTheme.primary, width: 2)),
          ),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════

final List<Map<String, dynamic>> _demoEmployerJobs = [
  {'title': 'Senior Affiliate Manager', 'location': 'Remote', 'type': 'Full-time', 'salary': '€4,000–€6,000', 'status': 'active', 'apps': 8, 'views': 67, 'posted': '5d ago'},
  {'title': 'Casino Content Writer', 'location': 'Malta', 'type': 'Full-time', 'salary': '€2,500–€3,500', 'status': 'active', 'apps': 12, 'views': 89, 'posted': '3d ago'},
  {'title': 'Betting Product Manager', 'location': 'Remote', 'type': 'Full-time', 'salary': '€5,000–€7,000', 'status': 'active', 'apps': 3, 'views': 24, 'posted': '1d ago'},
  {'title': 'Crypto Payment Analyst', 'location': 'Limassol', 'type': 'Contract', 'salary': '€3,500–€5,000', 'status': 'paused', 'apps': 0, 'views': 7, 'posted': '10d ago'},
  {'title': 'Junior QA Engineer', 'location': 'Kyiv', 'type': 'Full-time', 'salary': '€1,500–€2,500', 'status': 'closed', 'apps': 15, 'views': 120, 'posted': '30d ago'},
  {'title': 'Retention Manager', 'location': 'Remote', 'type': 'Full-time', 'salary': '€3,000–€4,500', 'status': 'draft', 'apps': 0, 'views': 0, 'posted': '-'},
];

final List<Map<String, dynamic>> _recentApps = [
  {'name': 'Olga Petrov', 'job': 'Casino Content Writer', 'status': 'new'},
  {'name': 'Max Schneider', 'job': 'Senior Affiliate Manager', 'status': 'interview'},
  {'name': 'Anna Kowalska', 'job': 'Betting Product Manager', 'status': 'new'},
  {'name': 'Ivan Moroz', 'job': 'Casino Content Writer', 'status': 'reviewed'},
];

final List<Map<String, dynamic>> _demoCandidates = [
  {'name': 'Max Schneider', 'position': 'Affiliate Manager', 'job': 'Senior Affiliate Manager', 'status': 'interview', 'experience': '5 years', 'salary': '€5,000', 'location': 'Berlin', 'email': 'max@example.com', 'phone': '+49 170 123 4567', 'telegram': '@max_sch', 'linkedin': 'linkedin.com/in/maxschneider', 'date': 'Mar 10', 'skills': ['Affiliate Marketing', 'SEO', 'Google Ads', 'Analytics']},
  {'name': 'Olga Petrov', 'position': 'Content Writer', 'job': 'Casino Content Writer', 'status': 'new', 'experience': '3 years', 'salary': '€3,000', 'location': 'Kyiv', 'email': 'olga@example.com', 'phone': '+380 67 123 4567', 'telegram': '@olga_pet', 'linkedin': 'linkedin.com/in/olgapetrov', 'date': 'Mar 13', 'skills': ['Copywriting', 'SEO', 'Casino', 'English C1']},
  {'name': 'Anna Kowalska', 'position': 'Product Manager', 'job': 'Betting Product Manager', 'status': 'new', 'experience': '4 years', 'salary': '€6,000', 'location': 'Warsaw', 'email': 'anna@example.com', 'phone': '+48 500 123 456', 'telegram': '@anna_kow', 'linkedin': 'linkedin.com/in/annakowalska', 'date': 'Mar 13', 'skills': ['Agile', 'Betting', 'Jira', 'SQL']},
  {'name': 'Ivan Moroz', 'position': 'Content Writer', 'job': 'Casino Content Writer', 'status': 'reviewed', 'experience': '2 years', 'salary': '€2,500', 'location': 'Remote', 'email': 'ivan@example.com', 'phone': '+380 50 987 6543', 'telegram': '@ivan_mor', 'linkedin': 'linkedin.com/in/ivanmoroz', 'date': 'Mar 12', 'skills': ['Copywriting', 'WordPress', 'Gambling']},
  {'name': 'Dmitry Volkov', 'position': 'QA Engineer', 'job': 'Senior Affiliate Manager', 'status': 'rejected', 'experience': '1 year', 'salary': '€2,000', 'location': 'Moscow', 'email': 'dmitry@example.com', 'phone': '+7 916 123 4567', 'telegram': '@dmitry_v', 'linkedin': 'linkedin.com/in/dmitryvolkov', 'date': 'Mar 8', 'skills': ['Manual QA', 'Selenium']},
  {'name': 'Sarah Miller', 'position': 'Affiliate Manager', 'job': 'Senior Affiliate Manager', 'status': 'hired', 'experience': '6 years', 'salary': '€5,500', 'location': 'London', 'email': 'sarah@example.com', 'phone': '+44 20 7946 0958', 'telegram': '@sarah_m', 'linkedin': 'linkedin.com/in/sarahmiller', 'date': 'Mar 5', 'skills': ['Affiliate Networks', 'CPA', 'Gambling', 'Crypto']},
];

/// Private notes per job (jobTitle -> note text)
final Map<String, String> _jobNotes = {};

/// Private notes per candidate (candidateName -> note text)
final Map<String, String> _candidateNotes = {};
