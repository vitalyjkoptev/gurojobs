import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/localization.dart';
import '../../core/pricing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/jarvis_provider.dart';
import '../../providers/lang_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/jarvis_fab.dart';
import '../client/candidate/notifications_screen.dart';
import '../client/candidate/settings_screen.dart';
import '../client/candidate/help_screen.dart';
import '../client/candidate/chat_screen.dart';
import '../client/candidate/splash_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;
  bool _jarvisInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_jarvisInitialized) {
      _jarvisInitialized = true;
      context.read<JarvisProvider>().initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LangProvider>();

    final jarvis = context.watch<JarvisProvider>();
    final jarvisActive = jarvis.isOpen || jarvis.isListening || jarvis.isProcessing;

    return Stack(
      children: [
        Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _AdminHomeTab(
                goToUsers: () => setState(() => _currentIndex = 1),
                goToJobs: () => setState(() => _currentIndex = 2),
              ),
              const _AdminUsersTab(),
              const _AdminJobsTab(),
              const ChatScreen(),
              const _AdminProfileTab(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: context.cardBg,
              boxShadow: [BoxShadow(color: context.shadowMedium, blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex > 4 ? 4 : _currentIndex,
              onTap: (i) {
                if (i == 5) {
                  jarvis.togglePanel();
                } else {
                  setState(() => _currentIndex = i);
                }
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: context.cardBg,
              selectedItemColor: GuroJobsTheme.primary,
              unselectedItemColor: context.textHintC,
              selectedFontSize: 11,
              unselectedFontSize: 11,
              elevation: 0,
              items: [
                BottomNavigationBarItem(icon: const Icon(Icons.dashboard_outlined), activeIcon: const Icon(Icons.dashboard), label: AppStrings.t('home')),
                BottomNavigationBarItem(icon: const Icon(Icons.people_outline), activeIcon: const Icon(Icons.people), label: AppStrings.t('adm_users')),
                BottomNavigationBarItem(icon: const Icon(Icons.work_outline), activeIcon: const Icon(Icons.work), label: AppStrings.t('jobs')),
                BottomNavigationBarItem(icon: const Icon(Icons.chat_bubble_outline), activeIcon: const Icon(Icons.chat_bubble), label: AppStrings.t('chat')),
                BottomNavigationBarItem(icon: const Icon(Icons.admin_panel_settings_outlined), activeIcon: const Icon(Icons.admin_panel_settings), label: AppStrings.t('adm_panel')),
                BottomNavigationBarItem(
                  icon: _JarvisGlowIcon(active: jarvisActive),
                  label: AppStrings.t('jarvis'),
                ),
              ],
            ),
          ),
        ),
        // Jarvis chat panel overlay (no FAB button)
        if (jarvis.isOpen) const _JarvisPanelOverlay(),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// JARVIS GLOW ICON (mic with pulsing glow when active)
// ═══════════════════════════════════════════════════════════════
class _JarvisGlowIcon extends StatefulWidget {
  final bool active;
  const _JarvisGlowIcon({required this.active});

  @override
  State<_JarvisGlowIcon> createState() => _JarvisGlowIconState();
}

class _JarvisGlowIconState extends State<_JarvisGlowIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.active) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_JarvisGlowIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.active && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) {
      return const Icon(Icons.mic_none);
    }
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: GuroJobsTheme.primary.withValues(alpha: 0.3 + _animation.value * 0.5),
                blurRadius: 8 + _animation.value * 12,
                spreadRadius: _animation.value * 4,
              ),
            ],
          ),
          child: Icon(Icons.mic, color: GuroJobsTheme.primary, size: 24),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// JARVIS PANEL OVERLAY (chat panel without FAB)
// ═══════════════════════════════════════════════════════════════
class _JarvisPanelOverlay extends StatelessWidget {
  const _JarvisPanelOverlay();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: JarvisFab(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ADMIN HOME TAB
// ═══════════════════════════════════════════════════════════════
class _AdminHomeTab extends StatelessWidget {
  final VoidCallback goToUsers;
  final VoidCallback goToJobs;
  const _AdminHomeTab({required this.goToUsers, required this.goToJobs});

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
                    gradient: const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF015EA7)]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      (auth.userName ?? 'A')[0].toUpperCase(),
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
                        '${AppStrings.t('hello')}, ${auth.userName ?? AppStrings.t('admin')}!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC),
                      ),
                      Text(AppStrings.t('adm_welcome'), style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
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

            // Platform stats
            Text(AppStrings.t('adm_platform_stats'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 14),
            Row(
              children: [
                _AdminStatCard(icon: Icons.people, label: AppStrings.t('adm_total_users'), value: '1,247', color: GuroJobsTheme.primary),
                const SizedBox(width: 10),
                _AdminStatCard(icon: Icons.work, label: AppStrings.t('adm_total_jobs'), value: '384', color: GuroJobsTheme.accent),
                const SizedBox(width: 10),
                _AdminStatCard(icon: Icons.business, label: AppStrings.t('adm_companies'), value: '89', color: GuroJobsTheme.success),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _AdminStatCard(icon: Icons.person_add, label: AppStrings.t('adm_new_today'), value: '23', color: GuroJobsTheme.info),
                const SizedBox(width: 10),
                _AdminStatCard(icon: Icons.attach_money, label: AppStrings.t('adm_revenue'), value: '\$4.2K', color: GuroJobsTheme.warning),
                const SizedBox(width: 10),
                _AdminStatCard(icon: Icons.flag, label: AppStrings.t('adm_reports'), value: '5', color: GuroJobsTheme.error),
              ],
            ),
            const SizedBox(height: 28),

            // Quick actions
            Text(AppStrings.t('adm_quick_actions'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _QuickAction(
                    icon: Icons.people, label: AppStrings.t('adm_manage_users'),
                    color: GuroJobsTheme.primary, onTap: goToUsers,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.work, label: AppStrings.t('adm_moderate_jobs'),
                    color: GuroJobsTheme.accent, onTap: goToJobs,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _QuickAction(
                    icon: Icons.analytics, label: AppStrings.t('adm_analytics'),
                    color: GuroJobsTheme.success, onTap: () => _AdminProfileTab._showAnalytics(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.report_problem, label: AppStrings.t('adm_reports'),
                    color: GuroJobsTheme.error, onTap: () => _AdminProfileTab._showVerification(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _QuickAction(
                    icon: Icons.payment, label: AppStrings.t('adm_payments'),
                    color: GuroJobsTheme.warning, onTap: () => _AdminProfileTab._showPayments(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.verified_user, label: AppStrings.t('adm_verification'),
                    color: const Color(0xFF9C27B0), onTap: () => _AdminProfileTab._showVerification(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Pending approvals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.t('adm_pending_approvals'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                TextButton(onPressed: goToUsers, child: Text(AppStrings.t('see_all'))),
              ],
            ),
            const SizedBox(height: 8),
            ..._pendingApprovals.map((a) => _ApprovalCard(data: a)),

            const SizedBox(height: 28),

            // Recent activity
            Text(AppStrings.t('adm_recent_activity'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 14),
            ..._recentActivity.map((a) => _ActivityRow(data: a)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ADMIN USERS TAB
// ═══════════════════════════════════════════════════════════════
class _AdminUsersTab extends StatefulWidget {
  const _AdminUsersTab();

  @override
  State<_AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<_AdminUsersTab> {
  String _roleFilter = 'all';
  String _statusFilter = 'all';
  String _searchQuery = '';

  List<Map<String, String>> get _filteredUsers {
    var users = _demoUsers;
    if (_roleFilter != 'all') {
      users = users.where((u) => u['role'] == _roleFilter).toList();
    }
    if (_statusFilter != 'all') {
      users = users.where((u) => u['status'] == _statusFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      users = users.where((u) => u['name']!.toLowerCase().contains(q) || u['email']!.toLowerCase().contains(q)).toList();
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredUsers;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.t('adm_users'), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                const SizedBox(height: 14),
                // Search
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: context.cardBg, borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.dividerC),
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: AppStrings.t('adm_search_users'),
                      hintStyle: TextStyle(color: context.textHintC, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Role filters
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FilterChip(label: AppStrings.t('all'), isSelected: _roleFilter == 'all', onTap: () => setState(() => _roleFilter = 'all')),
                      _FilterChip(label: AppStrings.t('adm_candidates'), isSelected: _roleFilter == 'candidate', onTap: () => setState(() => _roleFilter = 'candidate')),
                      _FilterChip(label: AppStrings.t('adm_employers'), isSelected: _roleFilter == 'employer', onTap: () => setState(() => _roleFilter = 'employer')),
                      _FilterChip(label: AppStrings.t('adm_admins'), isSelected: _roleFilter == 'admin', onTap: () => setState(() => _roleFilter = 'admin')),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Status filters
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FilterChip(label: AppStrings.t('all'), isSelected: _statusFilter == 'all', onTap: () => setState(() => _statusFilter = 'all')),
                      _FilterChip(label: AppStrings.t('adm_active'), isSelected: _statusFilter == 'active', onTap: () => setState(() => _statusFilter = 'active')),
                      _FilterChip(label: AppStrings.t('adm_pending'), isSelected: _statusFilter == 'pending', onTap: () => setState(() => _statusFilter = 'pending')),
                      _FilterChip(label: AppStrings.t('adm_banned'), isSelected: _statusFilter == 'banned', onTap: () => setState(() => _statusFilter = 'banned')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Users count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${filtered.length} ${AppStrings.t('adm_users').toLowerCase()}', style: TextStyle(fontSize: 13, color: context.textHintC)),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.person_off, size: 48, color: context.textHintC),
                      const SizedBox(height: 12),
                      Text(AppStrings.t('adm_no_users'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textSecondaryC)),
                    ]),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => _UserCard(
                      user: filtered[index],
                      onTap: () => _showUserDetail(context, filtered[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showUserDetail(BuildContext context, Map<String, String> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: context.cardBg,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.85,
          expand: false,
          builder: (_, scrollCtrl) {
            return ListView(
              controller: scrollCtrl,
              padding: const EdgeInsets.all(20),
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                // Avatar
                Center(
                  child: Container(
                    width: 70, height: 70,
                    decoration: BoxDecoration(
                      color: _roleColor(user['role']!),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text(user['name']![0], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white))),
                  ),
                ),
                const SizedBox(height: 14),
                Center(child: Text(user['name']!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC))),
                const SizedBox(height: 4),
                Center(child: Text(user['email']!, style: TextStyle(fontSize: 14, color: context.textSecondaryC))),
                const SizedBox(height: 8),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _RoleBadge(role: user['role']!),
                      const SizedBox(width: 8),
                      _StatusBadge(status: user['status']!),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Info rows
                _InfoRow(label: AppStrings.t('adm_registered'), value: user['registered']!),
                _InfoRow(label: AppStrings.t('adm_last_login'), value: user['lastLogin']!),
                _InfoRow(label: AppStrings.t('adm_jobs_applied'), value: user['jobsApplied'] ?? '-'),
                const SizedBox(height: 20),
                // Action buttons
                Row(
                  children: [
                    if (user['status'] == 'pending') ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            showDialog(context: context, builder: (d) => AlertDialog(
                              title: Text('${AppStrings.t("adm_approve")} ${user["name"]}?'),
                              content: Text(AppStrings.t('adm_approve_confirm')),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(d), child: Text(AppStrings.t('cancel'))),
                                ElevatedButton(onPressed: () {
                                  Navigator.pop(d);
                                  setState(() => user['status'] = 'active');
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user["name"]} ${AppStrings.t("adm_approved")}'), backgroundColor: GuroJobsTheme.success, behavior: SnackBarBehavior.floating));
                                }, style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.success), child: Text(AppStrings.t('adm_approve'))),
                              ],
                            ));
                          },
                          icon: const Icon(Icons.check, size: 18),
                          label: Text(AppStrings.t('adm_approve')),
                          style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.success, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            final reasonCtrl = TextEditingController();
                            showDialog(context: context, builder: (d) => AlertDialog(
                              title: Text('${AppStrings.t("adm_reject")} ${user["name"]}?'),
                              content: Column(mainAxisSize: MainAxisSize.min, children: [
                                Text(AppStrings.t('adm_reject_reason')),
                                const SizedBox(height: 12),
                                TextField(controller: reasonCtrl, maxLines: 3, decoration: InputDecoration(hintText: AppStrings.t('adm_reason_hint'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                              ]),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(d), child: Text(AppStrings.t('cancel'))),
                                ElevatedButton(onPressed: () {
                                  Navigator.pop(d);
                                  setState(() => user['status'] = 'rejected');
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user["name"]} ${AppStrings.t("adm_rejected_status")}'), backgroundColor: GuroJobsTheme.error, behavior: SnackBarBehavior.floating));
                                }, style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.error), child: Text(AppStrings.t('adm_reject'))),
                              ],
                            ));
                          },
                          icon: const Icon(Icons.close, size: 18),
                          label: Text(AppStrings.t('adm_reject')),
                          style: OutlinedButton.styleFrom(foregroundColor: GuroJobsTheme.error, side: const BorderSide(color: GuroJobsTheme.error), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ] else if (user['status'] == 'active') ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
                          },
                          icon: const Icon(Icons.chat, size: 18),
                          label: Text(AppStrings.t('adm_message')),
                          style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            final reasonCtrl = TextEditingController();
                            showDialog(context: context, builder: (d) => AlertDialog(
                              title: Text('${AppStrings.t("adm_ban")} ${user["name"]}?'),
                              content: Column(mainAxisSize: MainAxisSize.min, children: [
                                Text(AppStrings.t('adm_ban_confirm')),
                                const SizedBox(height: 12),
                                TextField(controller: reasonCtrl, maxLines: 2, decoration: InputDecoration(hintText: AppStrings.t('adm_reason_hint'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                              ]),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(d), child: Text(AppStrings.t('cancel'))),
                                ElevatedButton(onPressed: () {
                                  Navigator.pop(d);
                                  setState(() => user['status'] = 'banned');
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user["name"]} ${AppStrings.t("blocked")}'), backgroundColor: GuroJobsTheme.error, behavior: SnackBarBehavior.floating));
                                }, style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.error), child: Text(AppStrings.t('adm_ban'))),
                              ],
                            ));
                          },
                          icon: const Icon(Icons.block, size: 18),
                          label: Text(AppStrings.t('adm_ban')),
                          style: OutlinedButton.styleFrom(foregroundColor: GuroJobsTheme.error, side: const BorderSide(color: GuroJobsTheme.error), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ] else if (user['status'] == 'banned') ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            showDialog(context: context, builder: (d) => AlertDialog(
                              title: Text('${AppStrings.t("adm_unban")} ${user["name"]}?'),
                              content: Text(AppStrings.t('adm_unban_confirm')),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(d), child: Text(AppStrings.t('cancel'))),
                                ElevatedButton(onPressed: () {
                                  Navigator.pop(d);
                                  setState(() => user['status'] = 'active');
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user["name"]} ${AppStrings.t("adm_unbanned")}'), backgroundColor: GuroJobsTheme.success, behavior: SnackBarBehavior.floating));
                                }, style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.success), child: Text(AppStrings.t('adm_unban'))),
                              ],
                            ));
                          },
                          icon: const Icon(Icons.restore, size: 18),
                          label: Text(AppStrings.t('adm_unban')),
                          style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.success, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ADMIN JOBS TAB — MODERATION
// ═══════════════════════════════════════════════════════════════
class _AdminJobsTab extends StatefulWidget {
  const _AdminJobsTab();

  @override
  State<_AdminJobsTab> createState() => _AdminJobsTabState();
}

class _AdminJobsTabState extends State<_AdminJobsTab> {
  String _filter = 'all';

  List<Map<String, String>> get _filteredJobs {
    if (_filter == 'all') return _demoAdminJobs;
    return _demoAdminJobs.where((j) => j['modStatus'] == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredJobs;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.t('adm_job_moderation'), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                const SizedBox(height: 14),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FilterChip(label: AppStrings.t('all'), isSelected: _filter == 'all', onTap: () => setState(() => _filter = 'all')),
                      _FilterChip(label: AppStrings.t('adm_pending'), isSelected: _filter == 'pending', onTap: () => setState(() => _filter = 'pending')),
                      _FilterChip(label: AppStrings.t('adm_approved'), isSelected: _filter == 'approved', onTap: () => setState(() => _filter = 'approved')),
                      _FilterChip(label: AppStrings.t('adm_rejected_status'), isSelected: _filter == 'rejected', onTap: () => setState(() => _filter = 'rejected')),
                      _FilterChip(label: AppStrings.t('adm_featured'), isSelected: _filter == 'featured', onTap: () => setState(() => _filter = 'featured')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${filtered.length} ${AppStrings.t('jobs').toLowerCase()}', style: TextStyle(fontSize: 13, color: context.textHintC)),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.work_off, size: 48, color: context.textHintC),
                      const SizedBox(height: 12),
                      Text(AppStrings.t('no_jobs_found'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textSecondaryC)),
                    ]),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => _AdminJobCard(
                      job: filtered[index],
                      onApprove: () {
                        showDialog(context: context, builder: (d) => AlertDialog(
                          title: Text('${AppStrings.t("adm_approve")}: ${filtered[index]["title"]}?'),
                          content: Text(AppStrings.t('adm_approve_job_confirm')),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(d), child: Text(AppStrings.t('cancel'))),
                            ElevatedButton(onPressed: () {
                              Navigator.pop(d);
                              setState(() => filtered[index]['modStatus'] = 'approved');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${filtered[index]["title"]} ${AppStrings.t("adm_approved")}'), backgroundColor: GuroJobsTheme.success, behavior: SnackBarBehavior.floating));
                            }, style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.success), child: Text(AppStrings.t('adm_approve'))),
                          ],
                        ));
                      },
                      onReject: () {
                        final reasonCtrl = TextEditingController();
                        showDialog(context: context, builder: (d) => AlertDialog(
                          title: Text('${AppStrings.t("adm_reject")}: ${filtered[index]["title"]}?'),
                          content: Column(mainAxisSize: MainAxisSize.min, children: [
                            Text(AppStrings.t('adm_reject_job_reason')),
                            const SizedBox(height: 12),
                            TextField(controller: reasonCtrl, maxLines: 3, decoration: InputDecoration(hintText: AppStrings.t('adm_reason_hint'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                          ]),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(d), child: Text(AppStrings.t('cancel'))),
                            ElevatedButton(onPressed: () {
                              Navigator.pop(d);
                              setState(() => filtered[index]['modStatus'] = 'rejected');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${filtered[index]["title"]} ${AppStrings.t("adm_rejected_status")}'), backgroundColor: GuroJobsTheme.error, behavior: SnackBarBehavior.floating));
                            }, style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.error), child: Text(AppStrings.t('adm_reject'))),
                          ],
                        ));
                      },
                      onFeature: () {
                        showDialog(context: context, builder: (d) => AlertDialog(
                          title: Text('${AppStrings.t("adm_featured")}: ${filtered[index]["title"]}?'),
                          content: Text(AppStrings.t('adm_feature_confirm')),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(d), child: Text(AppStrings.t('cancel'))),
                            ElevatedButton(onPressed: () {
                              Navigator.pop(d);
                              setState(() => filtered[index]['modStatus'] = 'featured');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${filtered[index]["title"]} → Featured'), backgroundColor: GuroJobsTheme.accent, behavior: SnackBarBehavior.floating));
                            }, style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.accent), child: const Text('Feature')),
                          ],
                        ));
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ADMIN PROFILE TAB
// ═══════════════════════════════════════════════════════════════
class _AdminProfileTab extends StatelessWidget {
  const _AdminProfileTab();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lang = context.watch<LangProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF015EA7)]),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: const Color(0xFF6C5CE7).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Center(
                child: Text((auth.userName ?? 'A')[0].toUpperCase(), style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            Text(auth.userName ?? AppStrings.t('admin'), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 4),
            Text(auth.userEmail ?? '', style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF015EA7)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(AppStrings.t('admin'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
            const SizedBox(height: 24),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ProfileStat(value: '1,247', label: AppStrings.t('adm_users')),
                Container(width: 1, height: 30, color: context.dividerC),
                _ProfileStat(value: '384', label: AppStrings.t('jobs')),
                Container(width: 1, height: 30, color: context.dividerC),
                _ProfileStat(value: '89', label: AppStrings.t('adm_companies')),
              ],
            ),
            const SizedBox(height: 24),

            // Language selector
            _AdminMenuItem(
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

            // Dark mode
            Builder(builder: (context) {
              final themeProv = context.watch<ThemeProvider>();
              return _AdminMenuItem(
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

            // Admin tools section
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
              child: Text(AppStrings.t('adm_tools'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textHintC, letterSpacing: 0.5)),
            ),
            _AdminMenuItem(icon: Icons.card_membership, label: AppStrings.t('adm_subscriptions'), onTap: () => _showSubscriptions(context)),
            _AdminMenuItem(icon: Icons.payment, label: AppStrings.t('adm_payments'), onTap: () => _showPayments(context)),
            _AdminMenuItem(icon: Icons.analytics_outlined, label: AppStrings.t('adm_analytics'), onTap: () => _showAnalytics(context)),
            _AdminMenuItem(icon: Icons.security, label: AppStrings.t('adm_security'), onTap: () => _showSecurity(context)),
            _AdminMenuItem(icon: Icons.storage_outlined, label: AppStrings.t('adm_database'), onTap: () => _showSystemInfo(context)),
            _AdminMenuItem(icon: Icons.verified_user_outlined, label: AppStrings.t('adm_verification'), onTap: () => _showVerification(context)),

            const Divider(height: 24),

            // General section
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Text(AppStrings.t('adm_general'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textHintC, letterSpacing: 0.5)),
            ),
            _AdminMenuItem(icon: Icons.notifications_outlined, label: AppStrings.t('notifications'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()))),
            _AdminMenuItem(icon: Icons.settings_outlined, label: AppStrings.t('settings'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
            _AdminMenuItem(icon: Icons.help_outline, label: AppStrings.t('help_support'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen()))),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 50,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
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
                  if (confirmed == true && context.mounted) {
                    await context.read<AuthProvider>().logout();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const SplashScreen()),
                        (_) => false,
                      );
                    }
                  }
                },
                icon: const Icon(Icons.logout, color: GuroJobsTheme.error),
                label: Text(AppStrings.t('logout'), style: const TextStyle(color: GuroJobsTheme.error)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: GuroJobsTheme.error),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static void _showAnalytics(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: context.cardBg,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7, minChildSize: 0.4, maxChildSize: 0.9, expand: false,
          builder: (_, scrollCtrl) {
            return ListView(
              controller: scrollCtrl,
              padding: const EdgeInsets.all(20),
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Text(AppStrings.t('adm_analytics'), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                const SizedBox(height: 20),
                // Period stats
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: GuroJobsTheme.primary.withOpacity(0.1))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('This Month', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                      const SizedBox(height: 12),
                      _AnalyticsRow(label: 'New registrations', value: '156', change: '+23%', isPositive: true),
                      _AnalyticsRow(label: 'Jobs posted', value: '47', change: '+12%', isPositive: true),
                      _AnalyticsRow(label: 'Applications sent', value: '892', change: '+34%', isPositive: true),
                      _AnalyticsRow(label: 'Successful hires', value: '18', change: '+8%', isPositive: true),
                      _AnalyticsRow(label: 'Revenue', value: '\$12,450', change: '+15%', isPositive: true),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 8, offset: const Offset(0, 2))]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Top Categories', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                      const SizedBox(height: 12),
                      _AnalyticsBar(label: 'iGaming', value: 0.35, count: '134'),
                      _AnalyticsBar(label: 'Crypto', value: 0.25, count: '96'),
                      _AnalyticsBar(label: 'Betting', value: 0.20, count: '77'),
                      _AnalyticsBar(label: 'FinTech', value: 0.12, count: '46'),
                      _AnalyticsBar(label: 'Other', value: 0.08, count: '31'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 8, offset: const Offset(0, 2))]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Top Locations', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                      const SizedBox(height: 12),
                      _AnalyticsBar(label: 'Remote', value: 0.40, count: '154'),
                      _AnalyticsBar(label: 'Malta', value: 0.18, count: '69'),
                      _AnalyticsBar(label: 'Cyprus', value: 0.15, count: '58'),
                      _AnalyticsBar(label: 'London', value: 0.12, count: '46'),
                      _AnalyticsBar(label: 'Warsaw', value: 0.08, count: '31'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        );
      },
    );
  }

  static void _showPricingSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: context.cardBg,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              const Icon(Icons.confirmation_number, color: GuroJobsTheme.primary, size: 24),
              const SizedBox(width: 10),
              Expanded(child: Text('Daily Contact Limits', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC))),
            ]),
            const SizedBox(height: 6),
            Text('Contact reveal limits per plan (per day)', style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
            const SizedBox(height: 24),

            ...ContactPricing.dailyLimits.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: context.surfaceBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.dividerC),
                ),
                child: Row(children: [
                  Icon(Icons.workspace_premium, size: 20, color: GuroJobsTheme.primary),
                  const SizedBox(width: 12),
                  Expanded(child: Text(ContactPricing.planNames[entry.key] ?? entry.key, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: GuroJobsTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text('${entry.value} / day', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary)),
                  ),
                ]),
              ),
            )),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                icon: const Icon(Icons.check, size: 20),
                label: const Text('Close', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
          ]),
        );
      },
    );
  }

  static void _showSubscriptions(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const _AdminSubscriptionsScreen()));
  }

  static void _showPayments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: context.cardBg,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8, minChildSize: 0.4, maxChildSize: 0.95, expand: false,
          builder: (_, scrollCtrl) {
            return ListView(
              controller: scrollCtrl,
              padding: const EdgeInsets.all(20),
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Text('Payments & Finance', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                const SizedBox(height: 20),
                // Revenue overview
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF015EA7), Color(0xFF6C5CE7)]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Revenue', style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.8))),
                      const SizedBox(height: 4),
                      const Text('\$48,720', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                            child: const Text('+18.5% vs last month', style: TextStyle(fontSize: 12, color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Stats row
                Row(
                  children: [
                    Expanded(child: _PaymentStatBox(label: 'This Month', value: '\$12,450', icon: Icons.calendar_today, color: GuroJobsTheme.primary)),
                    const SizedBox(width: 10),
                    Expanded(child: _PaymentStatBox(label: 'Pending', value: '\$3,200', icon: Icons.hourglass_empty, color: GuroJobsTheme.warning)),
                    const SizedBox(width: 10),
                    Expanded(child: _PaymentStatBox(label: 'Overdue', value: '\$850', icon: Icons.warning_amber, color: GuroJobsTheme.error)),
                  ],
                ),
                const SizedBox(height: 20),
                // Subscription plans
                Text('Subscription Plans', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                const SizedBox(height: 12),
                _PlanRow(name: 'Basic', price: '\$10/mo', subscribers: '87', color: GuroJobsTheme.info),
                _PlanRow(name: 'Premium', price: '\$35/mo', subscribers: '34', color: GuroJobsTheme.primary),
                _PlanRow(name: 'VIP', price: '\$65/mo', subscribers: '12', color: GuroJobsTheme.accent),
                _PlanRow(name: 'Free / Trial', price: 'Free', subscribers: '156', color: GuroJobsTheme.success),
                const SizedBox(height: 20),
                // Recent transactions
                Text('Recent Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                const SizedBox(height: 12),
                _TransactionRow(company: 'BetStars Gaming', amount: '\$65.00', date: 'Mar 17', status: 'Paid', plan: 'VIP', color: GuroJobsTheme.success),
                _TransactionRow(company: 'CryptoPlay Ltd', amount: '\$35.00', date: 'Mar 16', status: 'Paid', plan: 'Premium', color: GuroJobsTheme.success),
                _TransactionRow(company: 'LuckySlots', amount: '\$10.00', date: 'Mar 15', status: 'Pending', plan: 'Basic', color: GuroJobsTheme.warning),
                _TransactionRow(company: 'NutraHealth', amount: '\$35.00', date: 'Mar 14', status: 'Paid', plan: 'Premium', color: GuroJobsTheme.success),
                _TransactionRow(company: 'BlockBet', amount: '\$10.00', date: 'Mar 13', status: 'Overdue', plan: 'Basic', color: GuroJobsTheme.error),
                _TransactionRow(company: 'DatingPro', amount: '\$65.00', date: 'Mar 12', status: 'Paid', plan: 'VIP', color: GuroJobsTheme.success),
                const SizedBox(height: 20),
                // Contact Unlock Pricing
                Text('Contact Unlock Pricing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                const SizedBox(height: 6),
                Text('Prices for employers to unlock candidate contacts', style: TextStyle(fontSize: 12, color: context.textHintC)),
                const SizedBox(height: 12),
                _ContactPricingWidget(),
                const SizedBox(height: 20),

                // Payment methods
                Text('Payment Methods', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                const SizedBox(height: 12),
                _PaymentMethodRow(method: 'Stripe', icon: Icons.credit_card, active: true),
                _PaymentMethodRow(method: 'PayPal', icon: Icons.paypal_outlined, active: true),
                _PaymentMethodRow(method: 'Revolut', icon: Icons.account_balance, active: true),
                _PaymentMethodRow(method: 'Crypto (USDT/USDC)', icon: Icons.currency_bitcoin, active: true),
                _PaymentMethodRow(method: 'Trustly', icon: Icons.account_balance, active: true),
                _PaymentMethodRow(method: 'Skrill', icon: Icons.wallet, active: false),
                _PaymentMethodRow(method: 'Neteller', icon: Icons.account_balance_wallet, active: false),
                _PaymentMethodRow(method: 'Paysafecard', icon: Icons.confirmation_number, active: false),
                const SizedBox(height: 20),
              ],
            );
          },
        );
      },
    );
  }

  static void _showSecurity(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: context.cardBg,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65, minChildSize: 0.4, maxChildSize: 0.9, expand: false,
          builder: (_, scrollCtrl) {
            return ListView(
              controller: scrollCtrl,
              padding: const EdgeInsets.all(20),
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Text(AppStrings.t('adm_security'), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                const SizedBox(height: 20),
                _SecurityItem(icon: Icons.shield, title: '2FA Authentication', subtitle: 'Enabled — Google Authenticator', color: GuroJobsTheme.success, onTap: () => _show2FA(ctx)),
                _SecurityItem(icon: Icons.lock_outline, title: 'Password', subtitle: 'Last changed 14 days ago', color: GuroJobsTheme.primary, onTap: () => _showChangePassword(ctx)),
                _SecurityItem(icon: Icons.devices, title: 'Active Sessions', subtitle: '2 devices logged in', color: GuroJobsTheme.info, onTap: () => _showActiveSessions(ctx)),
                _SecurityItem(icon: Icons.vpn_key, title: 'API Keys', subtitle: '3 active keys', color: GuroJobsTheme.warning, onTap: () => _showApiKeys(ctx)),
                _SecurityItem(icon: Icons.history, title: 'Login History', subtitle: 'Last login: just now (Chrome, macOS)', color: GuroJobsTheme.accent, onTap: () => _showLoginHistory(ctx)),
                _SecurityItem(icon: Icons.block, title: 'IP Whitelist', subtitle: '2 IPs whitelisted', color: GuroJobsTheme.error, onTap: () => _showIpWhitelist(ctx)),
                const SizedBox(height: 20),
                // Anti-Fraud section
                Text('Anti-Fraud & Abuse Protection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                const SizedBox(height: 12),
                _SecurityItem(icon: Icons.fingerprint, title: 'Device Fingerprinting', subtitle: 'Detect multi-accounts by device ID', color: const Color(0xFF9C27B0), onTap: () => _showAntifraud(ctx, 'fingerprint')),
                _SecurityItem(icon: Icons.location_searching, title: 'IP Tracking', subtitle: '14 flagged IPs with multi-accounts', color: GuroJobsTheme.error, onTap: () => _showAntifraud(ctx, 'ip')),
                _SecurityItem(icon: Icons.timer_off, title: 'Trial Abuse Detection', subtitle: '3 suspected abusers', color: GuroJobsTheme.warning, onTap: () => _showAntifraud(ctx, 'trial')),
                _SecurityItem(icon: Icons.email_outlined, title: 'Email Fraud Check', subtitle: 'Disposable email blocking: ON', color: GuroJobsTheme.info, onTap: () => _showAntifraud(ctx, 'email')),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: GuroJobsTheme.success.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: GuroJobsTheme.success.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified, color: GuroJobsTheme.success, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Text('Security score: Excellent', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC))),
                      const Text('95/100', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: GuroJobsTheme.success)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        );
      },
    );
  }

  // ── 2FA ──
  static void _show2FA(BuildContext context) {
    bool enabled = true;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: ctx.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('2FA Authentication', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ctx.textPrimaryC)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(color: (enabled ? GuroJobsTheme.success : GuroJobsTheme.error).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Icon(enabled ? Icons.shield : Icons.shield_outlined, color: enabled ? GuroJobsTheme.success : GuroJobsTheme.error, size: 40),
              ),
              const SizedBox(height: 16),
              Text(enabled ? 'Two-factor authentication is active' : 'Two-factor authentication is disabled', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: ctx.textSecondaryC)),
              const SizedBox(height: 12),
              Text('Method: Google Authenticator', style: TextStyle(fontSize: 13, color: ctx.textHintC)),
              const SizedBox(height: 20),
              SwitchListTile(
                value: enabled,
                onChanged: (v) => setS(() => enabled = v),
                title: Text('Enable 2FA', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ctx.textPrimaryC)),
                activeColor: GuroJobsTheme.success,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
              _secDialogBtn(ctx, 'Recovery Codes', Icons.key, () {
                Navigator.pop(ctx);
                _showInfoDialog(ctx, 'Recovery Codes', 'A1B2-C3D4\nE5F6-G7H8\nI9J0-K1L2\nM3N4-O5P6\nQ7R8-S9T0\nU1V2-W3X4', Icons.key, GuroJobsTheme.warning);
              }),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
        ),
      ),
    );
  }

  // ── Change Password ──
  static void _showChangePassword(BuildContext context) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool obscureCurrent = true, obscureNew = true, obscureConfirm = true;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: ctx.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Change Password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ctx.textPrimaryC)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _passField(ctx, currentCtrl, 'Current Password', obscureCurrent, () => setS(() => obscureCurrent = !obscureCurrent)),
              const SizedBox(height: 12),
              _passField(ctx, newCtrl, 'New Password', obscureNew, () => setS(() => obscureNew = !obscureNew)),
              const SizedBox(height: 12),
              _passField(ctx, confirmCtrl, 'Confirm Password', obscureConfirm, () => setS(() => obscureConfirm = !obscureConfirm)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: GuroJobsTheme.info.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: GuroJobsTheme.info, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Min 8 chars, uppercase, number, symbol', style: TextStyle(fontSize: 11, color: ctx.textSecondaryC))),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated successfully'), backgroundColor: GuroJobsTheme.success));
              },
              style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _passField(BuildContext ctx, TextEditingController ctrl, String label, bool obscure, VoidCallback toggle) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: TextStyle(color: ctx.textPrimaryC),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 13, color: ctx.textHintC),
        filled: true,
        fillColor: ctx.inputFill,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, size: 20, color: ctx.textHintC), onPressed: toggle),
      ),
    );
  }

  // ── Active Sessions ──
  static void _showActiveSessions(BuildContext context) {
    final sessions = [
      {'device': 'Chrome — macOS', 'ip': '192.168.1.101', 'time': 'Active now', 'current': true},
      {'device': 'Safari — iPhone 15', 'ip': '10.0.0.42', 'time': '2 hours ago', 'current': false},
      {'device': 'Firefox — Windows 11', 'ip': '185.42.105.23', 'time': 'Yesterday', 'current': false},
    ];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Active Sessions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ctx.textPrimaryC)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: sessions.map((s) {
              final isCurrent = s['current'] == true;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCurrent ? GuroJobsTheme.success.withOpacity(0.05) : ctx.surfaceBg,
                  borderRadius: BorderRadius.circular(12),
                  border: isCurrent ? Border.all(color: GuroJobsTheme.success.withOpacity(0.3)) : null,
                ),
                child: Row(
                  children: [
                    Icon(s['device'].toString().contains('iPhone') ? Icons.phone_iphone : Icons.laptop, color: isCurrent ? GuroJobsTheme.success : ctx.textSecondaryC, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(s['device'] as String, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ctx.textPrimaryC))),
                              if (isCurrent) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: GuroJobsTheme.success.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: const Text('Current', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: GuroJobsTheme.success))),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text('${s['ip']}  •  ${s['time']}', style: TextStyle(fontSize: 11, color: ctx.textHintC)),
                        ],
                      ),
                    ),
                    if (!isCurrent) IconButton(icon: const Icon(Icons.logout, color: GuroJobsTheme.error, size: 18), onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Session on ${s['device']} revoked'), backgroundColor: GuroJobsTheme.warning));
                    }),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All other sessions revoked'), backgroundColor: GuroJobsTheme.warning));
            },
            child: const Text('Revoke All Others', style: TextStyle(color: GuroJobsTheme.error)),
          ),
        ],
      ),
    );
  }

  // ── API Keys ──
  static void _showApiKeys(BuildContext context) {
    final keys = [
      {'name': 'Production API', 'key': 'gj_prod_***a8f2', 'created': 'Feb 10, 2026', 'status': 'active'},
      {'name': 'Staging API', 'key': 'gj_stg_***3c7e', 'created': 'Feb 20, 2026', 'status': 'active'},
      {'name': 'Webhook Key', 'key': 'gj_whk_***9d1b', 'created': 'Mar 1, 2026', 'status': 'active'},
    ];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('API Keys', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ctx.textPrimaryC)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...keys.map((k) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: ctx.surfaceBg, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: GuroJobsTheme.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.vpn_key, color: GuroJobsTheme.warning, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(k['name']!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ctx.textPrimaryC)),
                          Text('${k['key']}  •  ${k['created']}', style: TextStyle(fontSize: 11, color: ctx.textHintC)),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.delete_outline, color: GuroJobsTheme.error, size: 18), onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${k['name']} revoked'), backgroundColor: GuroJobsTheme.error));
                    }),
                  ],
                ),
              )),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity, height: 42,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('New API key generated'), backgroundColor: GuroJobsTheme.success));
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Generate New Key'),
                  style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
      ),
    );
  }

  // ── Login History ──
  static void _showLoginHistory(BuildContext context) {
    final history = [
      {'time': 'Mar 14, 14:32', 'device': 'Chrome — macOS', 'ip': '192.168.1.101', 'status': 'success'},
      {'time': 'Mar 14, 09:15', 'device': 'Safari — iPhone', 'ip': '10.0.0.42', 'status': 'success'},
      {'time': 'Mar 13, 22:48', 'device': 'Firefox — Windows', 'ip': '185.42.105.23', 'status': 'success'},
      {'time': 'Mar 13, 18:05', 'device': 'Unknown — Linux', 'ip': '95.217.45.12', 'status': 'failed'},
      {'time': 'Mar 12, 11:22', 'device': 'Chrome — macOS', 'ip': '192.168.1.101', 'status': 'success'},
      {'time': 'Mar 11, 16:40', 'device': 'Chrome — Android', 'ip': '78.31.22.8', 'status': 'failed'},
    ];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Login History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ctx.textPrimaryC)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: history.map((h) {
              final ok = h['status'] == 'success';
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ok ? ctx.surfaceBg : GuroJobsTheme.error.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: ok ? null : Border.all(color: GuroJobsTheme.error.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(ok ? Icons.check_circle : Icons.cancel, color: ok ? GuroJobsTheme.success : GuroJobsTheme.error, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(h['device']!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ctx.textPrimaryC)),
                          Text('${h['ip']}  •  ${h['time']}', style: TextStyle(fontSize: 11, color: ctx.textHintC)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: (ok ? GuroJobsTheme.success : GuroJobsTheme.error).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(ok ? 'OK' : 'FAIL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: ok ? GuroJobsTheme.success : GuroJobsTheme.error)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
      ),
    );
  }

  // ── IP Whitelist ──
  static void _showIpWhitelist(BuildContext context) {
    final ips = [
      {'ip': '192.168.1.101', 'label': 'Office Network', 'added': 'Feb 10, 2026'},
      {'ip': '10.0.0.0/24', 'label': 'VPN Range', 'added': 'Feb 15, 2026'},
    ];
    final ipCtrl = TextEditingController();
    final labelCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('IP Whitelist', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ctx.textPrimaryC)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...ips.map((ip) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: ctx.surfaceBg, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: GuroJobsTheme.error.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.language, color: GuroJobsTheme.error, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ip['ip']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: ctx.textPrimaryC, fontFamily: 'monospace')),
                          Text('${ip['label']}  •  ${ip['added']}', style: TextStyle(fontSize: 11, color: ctx.textHintC)),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.remove_circle_outline, color: GuroJobsTheme.error, size: 18), onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${ip['ip']} removed'), backgroundColor: GuroJobsTheme.error));
                    }),
                  ],
                ),
              )),
              const Divider(),
              const SizedBox(height: 8),
              TextField(
                controller: ipCtrl,
                style: TextStyle(color: ctx.textPrimaryC),
                decoration: InputDecoration(labelText: 'IP Address', labelStyle: TextStyle(fontSize: 13, color: ctx.textHintC), filled: true, fillColor: ctx.inputFill, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: labelCtrl,
                style: TextStyle(color: ctx.textPrimaryC),
                decoration: InputDecoration(labelText: 'Label (optional)', labelStyle: TextStyle(fontSize: 13, color: ctx.textHintC), filled: true, fillColor: ctx.inputFill, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity, height: 42,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('IP address added to whitelist'), backgroundColor: GuroJobsTheme.success));
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add IP'),
                  style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
      ),
    );
  }

  // ── Anti-Fraud ──
  static void _showAntifraud(BuildContext context, String type) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => _AntifraudScreen(type: type)));
  }

  // ── Helper: info dialog ──
  static void _showInfoDialog(BuildContext context, String title, String body, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [Icon(icon, color: color, size: 22), const SizedBox(width: 8), Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ctx.textPrimaryC))]),
        content: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: ctx.surfaceBg, borderRadius: BorderRadius.circular(10)),
          child: SelectableText(body, style: TextStyle(fontSize: 14, fontFamily: 'monospace', height: 1.6, color: ctx.textPrimaryC)),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
      ),
    );
  }

  // ── Helper: security dialog button ──
  static Widget _secDialogBtn(BuildContext ctx, String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: ctx.surfaceBg, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Icon(icon, size: 18, color: ctx.textSecondaryC),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: ctx.textPrimaryC))),
            Icon(Icons.chevron_right, size: 18, color: ctx.textHintC),
          ],
        ),
      ),
    );
  }

  static void _showSystemInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: context.cardBg,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6, minChildSize: 0.4, maxChildSize: 0.85, expand: false,
          builder: (_, scrollCtrl) {
            return ListView(
              controller: scrollCtrl,
              padding: const EdgeInsets.all(20),
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Text(AppStrings.t('adm_database'), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                const SizedBox(height: 20),
                _SysInfoRow(label: 'Server', value: 'Hetzner VPS'),
                _SysInfoRow(label: 'API Version', value: 'v1.0'),
                _SysInfoRow(label: 'Database', value: 'MySQL 8.0'),
                _SysInfoRow(label: 'Storage used', value: '2.4 GB / 20 GB'),
                _SysInfoRow(label: 'Uptime', value: '14 days'),
                _SysInfoRow(label: 'PHP', value: '8.2'),
                _SysInfoRow(label: 'Laravel', value: '11.x'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: GuroJobsTheme.success.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: GuroJobsTheme.success.withOpacity(0.2))),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: GuroJobsTheme.success, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Text('All systems operational', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC))),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity, height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared successfully'), backgroundColor: GuroJobsTheme.success));
                    },
                    icon: const Icon(Icons.cached, size: 18),
                    label: const Text('Clear Cache'),
                    style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        );
      },
    );
  }

  static void _showVerification(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const _AdminVerificationScreen()));
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

class _AdminStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _AdminStatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: context.textPrimaryC)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: context.textSecondaryC)),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimaryC))),
            Icon(Icons.chevron_right, color: context.textHintC, size: 18),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? GuroJobsTheme.primary : context.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? GuroJobsTheme.primary : context.dividerC),
        ),
        child: Center(child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : context.textSecondaryC))),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final Map<String, String> user;
  final VoidCallback onTap;
  const _UserCard({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: _roleColor(user['role']!), shape: BoxShape.circle),
              child: Center(child: Text(user['name']![0], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['name']!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                  const SizedBox(height: 2),
                  Text(user['email']!, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _RoleBadge(role: user['role']!),
                const SizedBox(height: 4),
                _StatusBadge(status: user['status']!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: _roleColor(role).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(AppStrings.t(role), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _roleColor(role))),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'active' ? GuroJobsTheme.success
        : status == 'pending' ? GuroJobsTheme.warning
        : GuroJobsTheme.error;
    final label = status == 'active' ? AppStrings.t('adm_active')
        : status == 'pending' ? AppStrings.t('adm_pending')
        : AppStrings.t('adm_banned');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _AdminJobCard extends StatelessWidget {
  final Map<String, String> job;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onFeature;
  const _AdminJobCard({required this.job, required this.onApprove, required this.onReject, required this.onFeature});

  @override
  Widget build(BuildContext context) {
    final modStatus = job['modStatus']!;
    final statusColor = modStatus == 'approved' ? GuroJobsTheme.success
        : modStatus == 'pending' ? GuroJobsTheme.warning
        : modStatus == 'featured' ? GuroJobsTheme.info
        : GuroJobsTheme.error;
    final statusLabel = modStatus == 'approved' ? AppStrings.t('adm_approved')
        : modStatus == 'pending' ? AppStrings.t('adm_pending')
        : modStatus == 'featured' ? AppStrings.t('adm_featured')
        : AppStrings.t('adm_rejected_status');

    return Container(
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
                width: 42, height: 42,
                decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text(job['company']![0], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job['title']!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                    Text(job['company']!, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Text(statusLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 14, color: context.textHintC),
              const SizedBox(width: 4),
              Text(job['location']!, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
              const SizedBox(width: 16),
              Icon(Icons.attach_money, size: 14, color: context.textHintC),
              Text(job['salary']!, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
            ],
          ),
          if (modStatus == 'pending') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 34,
                    child: ElevatedButton(
                      onPressed: onApprove,
                      style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.success, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: EdgeInsets.zero),
                      child: Text(AppStrings.t('adm_approve'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 34,
                    child: OutlinedButton(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(foregroundColor: GuroJobsTheme.error, side: const BorderSide(color: GuroJobsTheme.error), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: EdgeInsets.zero),
                      child: Text(AppStrings.t('adm_reject'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 34,
                  child: OutlinedButton(
                    onPressed: onFeature,
                    style: OutlinedButton.styleFrom(foregroundColor: GuroJobsTheme.info, side: const BorderSide(color: GuroJobsTheme.info), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12)),
                    child: const Icon(Icons.star_outline, size: 18),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  final Map<String, String> data;
  const _ApprovalCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GuroJobsTheme.warning.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: GuroJobsTheme.warning.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(_approvalIcon(data['type']!), color: GuroJobsTheme.warning, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['title']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                Text(data['desc']!, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: GuroJobsTheme.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(AppStrings.t('adm_pending'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: GuroJobsTheme.warning)),
          ),
        ],
      ),
    );
  }

  static IconData _approvalIcon(String type) {
    switch (type) {
      case 'user': return Icons.person_add;
      case 'job': return Icons.work;
      case 'company': return Icons.business;
      default: return Icons.pending;
    }
  }
}

class _ActivityRow extends StatelessWidget {
  final Map<String, String> data;
  const _ActivityRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.08), shape: BoxShape.circle),
            child: Icon(_activityIcon(data['type']!), color: GuroJobsTheme.primary, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['text']!, style: TextStyle(fontSize: 13, color: context.textPrimaryC)),
                Text(data['time']!, style: TextStyle(fontSize: 11, color: context.textHintC)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static IconData _activityIcon(String type) {
    switch (type) {
      case 'register': return Icons.person_add;
      case 'job': return Icons.work;
      case 'payment': return Icons.payment;
      case 'report': return Icons.flag;
      default: return Icons.info;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
        ],
      ),
    );
  }
}

class _AdminMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;
  const _AdminMenuItem({required this.icon, required this.label, this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: context.textSecondaryC, size: 22),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: TextStyle(fontSize: 15, color: context.textPrimaryC))),
            trailing ?? Icon(Icons.chevron_right, color: context.textHintC, size: 20),
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
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
      ],
    );
  }
}

class _AnalyticsRow extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  final bool isPositive;
  const _AnalyticsRow({required this.label, required this.value, required this.change, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: context.textSecondaryC))),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: (isPositive ? GuroJobsTheme.success : GuroJobsTheme.error).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(change, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isPositive ? GuroJobsTheme.success : GuroJobsTheme.error)),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsBar extends StatelessWidget {
  final String label;
  final double value;
  final String count;
  const _AnalyticsBar({required this.label, required this.value, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: context.textPrimaryC))),
              Text(count, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textSecondaryC)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: value, minHeight: 6, backgroundColor: context.dividerC, valueColor: const AlwaysStoppedAnimation(GuroJobsTheme.primary)),
          ),
        ],
      ),
    );
  }
}

class _SecurityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;
  const _SecurityItem({required this.icon, required this.title, required this.subtitle, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 6, offset: const Offset(0, 2))]),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.textHintC, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SysInfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _SysInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
        ],
      ),
    );
  }
}

class _VerificationStat extends StatelessWidget {
  final String label;
  final String count;
  final Color color;
  const _VerificationStat({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.15))),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(count, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: context.textPrimaryC))),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PAYMENT WIDGETS
// ═══════════════════════════════════════════════════════════════
class _PaymentStatBox extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _PaymentStatBox({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          Text(label, style: TextStyle(fontSize: 11, color: context.textSecondaryC)),
        ],
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  final String name, price, subscribers;
  final Color color;
  const _PlanRow({required this.name, required this.price, required this.subscribers, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 6, offset: const Offset(0, 2))]),
      child: Row(
        children: [
          Container(width: 4, height: 36, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
              Text(price, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
            ],
          )),
          Text('$subscribers users', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final String company, amount, date, status;
  final String? plan;
  final Color color;
  const _TransactionRow({required this.company, required this.amount, required this.date, required this.status, this.plan, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 6, offset: const Offset(0, 2))]),
      child: Row(
        children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(company, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
              Row(children: [
                Text(date, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
                if (plan != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(color: GuroJobsTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                    child: Text(plan!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: GuroJobsTheme.primary)),
                  ),
                ],
              ]),
            ],
          )),
          Text(amount, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodRow extends StatelessWidget {
  final String method;
  final IconData icon;
  final bool active;
  const _PaymentMethodRow({required this.method, required this.icon, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 6, offset: const Offset(0, 2))]),
      child: Row(
        children: [
          Icon(icon, color: active ? GuroJobsTheme.primary : context.textHintC, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(method, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: (active ? GuroJobsTheme.success : context.textHintC).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(active ? 'Active' : 'Inactive', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: active ? GuroJobsTheme.success : context.textHintC)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════════
Color _roleColor(String role) {
  switch (role) {
    case 'admin': return const Color(0xFF6C5CE7);
    case 'employer': return GuroJobsTheme.primary;
    default: return GuroJobsTheme.accent;
  }
}

// ═══════════════════════════════════════════════════════════════
// DEMO DATA
// ═══════════════════════════════════════════════════════════════

final List<Map<String, String>> _demoUsers = [
  {'name': 'Anna Kowalski', 'email': 'anna@email.com', 'role': 'candidate', 'status': 'active', 'registered': 'Mar 10, 2026', 'lastLogin': '2 hours ago', 'jobsApplied': '12'},
  {'name': 'BetStars Gaming', 'email': 'hr@betstars.com', 'role': 'employer', 'status': 'active', 'registered': 'Feb 28, 2026', 'lastLogin': '1 day ago', 'jobsApplied': '-'},
  {'name': 'Mark Chen', 'email': 'mark.c@gmail.com', 'role': 'candidate', 'status': 'pending', 'registered': 'Mar 14, 2026', 'lastLogin': 'Never', 'jobsApplied': '0'},
  {'name': 'CryptoPlay Ltd', 'email': 'jobs@cryptoplay.io', 'role': 'employer', 'status': 'pending', 'registered': 'Mar 13, 2026', 'lastLogin': 'Never', 'jobsApplied': '-'},
  {'name': 'Elena Volkov', 'email': 'elena.v@mail.ru', 'role': 'candidate', 'status': 'active', 'registered': 'Mar 1, 2026', 'lastLogin': '5 hours ago', 'jobsApplied': '8'},
  {'name': 'SpamBot User', 'email': 'spam@fake.com', 'role': 'candidate', 'status': 'banned', 'registered': 'Mar 8, 2026', 'lastLogin': 'Mar 9', 'jobsApplied': '0'},
  {'name': 'Alex Admin', 'email': 'admin@gurojobs.com', 'role': 'admin', 'status': 'active', 'registered': 'Jan 1, 2026', 'lastLogin': 'Just now', 'jobsApplied': '-'},
  {'name': 'NutraHealth Inc', 'email': 'hr@nutrahealth.com', 'role': 'employer', 'status': 'active', 'registered': 'Feb 15, 2026', 'lastLogin': '3 days ago', 'jobsApplied': '-'},
  {'name': 'Ivan Petrov', 'email': 'ivan.p@outlook.com', 'role': 'candidate', 'status': 'active', 'registered': 'Mar 5, 2026', 'lastLogin': '1 hour ago', 'jobsApplied': '15'},
  {'name': 'FakeCompany', 'email': 'scam@temp.com', 'role': 'employer', 'status': 'banned', 'registered': 'Mar 7, 2026', 'lastLogin': 'Mar 7', 'jobsApplied': '-'},
];

final List<Map<String, String>> _demoAdminJobs = [
  {'title': 'Senior Affiliate Manager', 'company': 'BetStars Gaming', 'location': 'Remote', 'salary': '\$5K-\$7K', 'modStatus': 'pending'},
  {'title': 'Flutter Developer', 'company': 'CryptoPlay', 'location': 'Malta', 'salary': '\$6K-\$9K', 'modStatus': 'pending'},
  {'title': 'Casino Product Manager', 'company': 'LuckySlots', 'location': 'Cyprus', 'salary': '\$7K-\$10K', 'modStatus': 'approved'},
  {'title': 'Crypto Analyst', 'company': 'BlockBet', 'location': 'Remote', 'salary': '\$4K-\$6K', 'modStatus': 'approved'},
  {'title': 'Fake Job Posting', 'company': 'ScamCo', 'location': 'Unknown', 'salary': '\$100K', 'modStatus': 'rejected'},
  {'title': 'Head of Betting', 'company': 'BetKing', 'location': 'London', 'salary': '\$10K-\$15K', 'modStatus': 'featured'},
  {'title': 'iGaming UX Designer', 'company': 'NutraHealth', 'location': 'Remote', 'salary': '\$4K-\$6K', 'modStatus': 'pending'},
];

final List<Map<String, String>> _pendingApprovals = [
  {'type': 'user', 'title': 'New employer registration', 'desc': 'CryptoPlay Ltd — crypto gaming'},
  {'type': 'job', 'title': 'Job posting review', 'desc': 'Flutter Developer — CryptoPlay'},
  {'type': 'user', 'title': 'New candidate signup', 'desc': 'Mark Chen — Developer'},
];

final List<Map<String, String>> _recentActivity = [
  {'type': 'register', 'text': 'Mark Chen registered as candidate', 'time': '15 min ago'},
  {'type': 'job', 'text': 'BetStars posted "Senior Affiliate Manager"', 'time': '1 hour ago'},
  {'type': 'payment', 'text': 'NutraHealth subscribed to Pro plan', 'time': '3 hours ago'},
  {'type': 'report', 'text': 'Job "Fake Job Posting" reported by 3 users', 'time': '5 hours ago'},
  {'type': 'register', 'text': 'CryptoPlay Ltd registered as employer', 'time': 'Yesterday'},
];

class _PricingField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  const _PricingField({required this.label, required this.icon, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 44, height: 44,
        decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: GuroJobsTheme.primary, size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(child: Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: context.textPrimaryC))),
      SizedBox(
        width: 80,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary),
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[500]),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.dividerC)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.dividerC)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: GuroJobsTheme.primary, width: 2)),
          ),
        ),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════
// ADMIN SUBSCRIPTIONS SCREEN
// ═══════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════
// ANTI-FRAUD SCREEN
// ═══════════════════════════════════════════════════════════════

class _AntifraudScreen extends StatefulWidget {
  final String type; // fingerprint, ip, trial, email
  const _AntifraudScreen({required this.type});
  @override
  State<_AntifraudScreen> createState() => _AntifraudState();
}

class _AntifraudState extends State<_AntifraudScreen> {
  bool _deviceFingerprintEnabled = true;
  bool _ipTrackingEnabled = true;
  bool _trialAbuseEnabled = true;
  bool _disposableEmailBlock = true;
  bool _sameCardBlock = true;
  bool _phoneVerification = false;

  final _suspectedTrialAbusers = <Map<String, dynamic>>[
    {'email': 'john.doe@gmail.com', 'ips': '3 IPs match user john_d@temp.com', 'device': 'Same device ID', 'trials': 4, 'status': 'flagged'},
    {'email': 'fake@guerrillamail.com', 'ips': '91.214.xx.xx (proxy)', 'device': 'New device each time', 'trials': 7, 'status': 'flagged'},
    {'email': 'test123@yopmail.com', 'ips': '185.xx.xx.xx (VPN)', 'device': 'Emulator detected', 'trials': 3, 'status': 'blocked'},
  ];

  final _flaggedIPs = <Map<String, String>>[
    {'ip': '91.214.15.42', 'accounts': '5', 'country': 'UA', 'status': 'flagged'},
    {'ip': '185.62.190.11', 'accounts': '3', 'country': 'RU', 'status': 'flagged'},
    {'ip': '45.33.120.78', 'accounts': '4', 'country': 'DE', 'status': 'blocked'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anti-Fraud Protection')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Protection toggles
          Text('Protection Rules', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(height: 14),

          _toggle('Device Fingerprinting', 'Block same device from creating multiple accounts', _deviceFingerprintEnabled, (v) => setState(() => _deviceFingerprintEnabled = v), Icons.fingerprint, const Color(0xFF9C27B0)),
          _toggle('IP Tracking', 'Flag accounts sharing same IP address', _ipTrackingEnabled, (v) => setState(() => _ipTrackingEnabled = v), Icons.location_searching, GuroJobsTheme.error),
          _toggle('Trial Abuse Detection', 'Detect users cycling free trials with new emails', _trialAbuseEnabled, (v) => setState(() => _trialAbuseEnabled = v), Icons.timer_off, GuroJobsTheme.warning),
          _toggle('Block Disposable Emails', 'Reject guerrillamail, yopmail, temp-mail, etc.', _disposableEmailBlock, (v) => setState(() => _disposableEmailBlock = v), Icons.email_outlined, GuroJobsTheme.info),
          _toggle('Same Card Detection', 'Flag if same payment card used on multiple accounts', _sameCardBlock, (v) => setState(() => _sameCardBlock = v), Icons.credit_card, GuroJobsTheme.primary),
          _toggle('Phone Verification', 'Require phone SMS verify for free trial signup', _phoneVerification, (v) => setState(() => _phoneVerification = v), Icons.phone_android, GuroJobsTheme.accent),

          const SizedBox(height: 24),

          // Flagged IPs
          Text('Flagged IPs (${_flaggedIPs.length})', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(height: 12),
          ..._flaggedIPs.map((ip) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.dividerC)),
            child: Row(children: [
              Icon(Icons.warning_amber, size: 20, color: ip['status'] == 'blocked' ? GuroJobsTheme.error : GuroJobsTheme.warning),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(ip['ip']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC, fontFamily: 'monospace')),
                Text('${ip["accounts"]} accounts · ${ip["country"]}', style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
              ])),
              TextButton(onPressed: () {
                setState(() => ip['status'] = ip['status'] == 'blocked' ? 'flagged' : 'blocked');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${ip["ip"]} ${ip["status"]}'), behavior: SnackBarBehavior.floating));
              }, child: Text(ip['status'] == 'blocked' ? 'Unblock' : 'Block', style: TextStyle(color: ip['status'] == 'blocked' ? GuroJobsTheme.success : GuroJobsTheme.error, fontWeight: FontWeight.w600))),
            ]),
          )),

          const SizedBox(height: 24),

          // Trial abusers
          Text('Suspected Trial Abusers (${_suspectedTrialAbusers.length})', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(height: 12),
          ..._suspectedTrialAbusers.map((u) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: u['status'] == 'blocked' ? GuroJobsTheme.error.withValues(alpha: 0.3) : GuroJobsTheme.warning.withValues(alpha: 0.3)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Icons.person_off, size: 18, color: u['status'] == 'blocked' ? GuroJobsTheme.error : GuroJobsTheme.warning),
                const SizedBox(width: 8),
                Expanded(child: Text(u['email'] as String, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: (u['status'] == 'blocked' ? GuroJobsTheme.error : GuroJobsTheme.warning).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text('${u["trials"]} trials', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: u['status'] == 'blocked' ? GuroJobsTheme.error : GuroJobsTheme.warning)),
                ),
              ]),
              const SizedBox(height: 6),
              Text('IP: ${u["ips"]}', style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
              Text('Device: ${u["device"]}', style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
              const SizedBox(height: 8),
              Row(children: [
                if (u['status'] != 'blocked')
                  Expanded(child: ElevatedButton(onPressed: () {
                    setState(() => u['status'] = 'blocked');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${u["email"]} blocked'), backgroundColor: GuroJobsTheme.error, behavior: SnackBarBehavior.floating));
                  }, style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.error, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Block')))
                else
                  Expanded(child: OutlinedButton(onPressed: () {
                    setState(() => u['status'] = 'flagged');
                  }, style: OutlinedButton.styleFrom(foregroundColor: GuroJobsTheme.success, side: const BorderSide(color: GuroJobsTheme.success), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Unblock'))),
                const SizedBox(width: 8),
                Expanded(child: OutlinedButton(onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dismissed ${u["email"]}'), behavior: SnackBarBehavior.floating));
                }, style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Dismiss'))),
              ]),
            ]),
          )),
        ],
      ),
    );
  }

  Widget _toggle(String title, String sub, bool val, ValueChanged<bool> onChanged, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.dividerC)),
      child: Row(children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
          Text(sub, style: TextStyle(fontSize: 11, color: context.textSecondaryC)),
        ])),
        Switch(value: val, onChanged: onChanged, activeColor: color),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ADMIN VERIFICATION & REPORTS SCREEN
// ═══════════════════════════════════════════════════════════════

class _AdminVerificationScreen extends StatefulWidget {
  const _AdminVerificationScreen();
  @override
  State<_AdminVerificationScreen> createState() => _AdminVerificationState();
}

class _AdminVerificationState extends State<_AdminVerificationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  final _verifications = <Map<String, dynamic>>[
    {'name': 'CryptoPlay Ltd', 'type': 'employer', 'status': 'pending', 'date': 'Mar 18', 'docs': 'Company registration, Tax ID'},
    {'name': 'BlockBet', 'type': 'employer', 'status': 'pending', 'date': 'Mar 17', 'docs': 'Company registration'},
    {'name': 'GambleFi', 'type': 'employer', 'status': 'pending', 'date': 'Mar 16', 'docs': 'Company registration, License'},
    {'name': 'SlotMaster', 'type': 'employer', 'status': 'approved', 'date': 'Mar 14', 'docs': 'All verified'},
  ];

  final _reports = <Map<String, dynamic>>[
    {'reporter': 'Anna K.', 'target': 'FakeCompany', 'reason': 'Fake job listing', 'status': 'pending', 'date': 'Mar 19'},
    {'reporter': 'Ivan P.', 'target': 'ScamCo', 'reason': 'Spam messages', 'status': 'pending', 'date': 'Mar 18'},
    {'reporter': 'Elena V.', 'target': 'BlockBet', 'reason': 'Misleading salary', 'status': 'resolved', 'date': 'Mar 15'},
  ];

  @override
  void initState() { super.initState(); _tabCtrl = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t('adm_verification')),
        bottom: TabBar(controller: _tabCtrl, labelColor: GuroJobsTheme.primary, unselectedLabelColor: context.textHintC, indicatorColor: GuroJobsTheme.primary, tabs: [
          Tab(text: AppStrings.t('adm_verification')),
          Tab(text: AppStrings.t('adm_reports')),
        ]),
      ),
      body: TabBarView(controller: _tabCtrl, children: [
        _verificationTab(),
        _reportsTab(),
      ]),
    );
  }

  Widget _verificationTab() {
    return ListView(padding: const EdgeInsets.all(20), children: [
      // Stats
      Row(children: [
        _stat(context, '${_verifications.where((v) => v["status"] == "pending").length}', AppStrings.t('pending'), GuroJobsTheme.warning),
        const SizedBox(width: 10),
        _stat(context, '${_verifications.where((v) => v["status"] == "approved").length}', AppStrings.t('adm_approved'), GuroJobsTheme.success),
      ]),
      const SizedBox(height: 20),
      ..._verifications.map((v) => _verificationCard(v)),
    ]);
  }

  Widget _reportsTab() {
    return ListView(padding: const EdgeInsets.all(20), children: [
      Row(children: [
        _stat(context, '${_reports.where((r) => r["status"] == "pending").length}', AppStrings.t('pending'), GuroJobsTheme.error),
        const SizedBox(width: 10),
        _stat(context, '${_reports.where((r) => r["status"] == "resolved").length}', AppStrings.t('resolved'), GuroJobsTheme.success),
      ]),
      const SizedBox(height: 20),
      ..._reports.map((r) => _reportCard(r)),
    ]);
  }

  Widget _stat(BuildContext context, String value, String label, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
      ]),
    ));
  }

  Widget _verificationCard(Map<String, dynamic> v) {
    final isPending = v['status'] == 'pending';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.dividerC)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.business, size: 20, color: isPending ? GuroJobsTheme.warning : GuroJobsTheme.success),
          const SizedBox(width: 10),
          Expanded(child: Text(v['name'] as String, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: (isPending ? GuroJobsTheme.warning : GuroJobsTheme.success).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(v['status'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isPending ? GuroJobsTheme.warning : GuroJobsTheme.success)),
          ),
        ]),
        const SizedBox(height: 8),
        Text('${AppStrings.t("documents")}: ${v["docs"]}', style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
        Text(v['date'] as String, style: TextStyle(fontSize: 11, color: context.textHintC)),
        if (isPending) ...[
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: ElevatedButton(onPressed: () {
              showDialog(context: context, builder: (d) => AlertDialog(
                title: Text('${AppStrings.t("adm_approve")} ${v["name"]}?'),
                content: Text(AppStrings.t('adm_verify_approve')),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(d), child: Text(AppStrings.t('cancel'))),
                  ElevatedButton(onPressed: () { Navigator.pop(d); setState(() => v['status'] = 'approved'); }, style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.success), child: Text(AppStrings.t('adm_approve'))),
                ],
              ));
            }, style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.success, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text(AppStrings.t('adm_approve')))),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton(onPressed: () {
              final rc = TextEditingController();
              showDialog(context: context, builder: (d) => AlertDialog(
                title: Text('${AppStrings.t("adm_reject")} ${v["name"]}?'),
                content: TextField(controller: rc, maxLines: 2, decoration: InputDecoration(hintText: AppStrings.t('adm_reason_hint'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(d), child: Text(AppStrings.t('cancel'))),
                  ElevatedButton(onPressed: () { Navigator.pop(d); setState(() => v['status'] = 'rejected'); }, style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.error), child: Text(AppStrings.t('adm_reject'))),
                ],
              ));
            }, style: OutlinedButton.styleFrom(foregroundColor: GuroJobsTheme.error, side: const BorderSide(color: GuroJobsTheme.error), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text(AppStrings.t('adm_reject')))),
          ]),
        ],
      ]),
    );
  }

  Widget _reportCard(Map<String, dynamic> r) {
    final isPending = r['status'] == 'pending';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: isPending ? GuroJobsTheme.error.withValues(alpha: 0.3) : context.dividerC)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.flag, size: 18, color: isPending ? GuroJobsTheme.error : GuroJobsTheme.success),
          const SizedBox(width: 8),
          Expanded(child: Text('${r["target"]}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC))),
          Text(r['date'] as String, style: TextStyle(fontSize: 11, color: context.textHintC)),
        ]),
        const SizedBox(height: 6),
        Text('${AppStrings.t("reason")}: ${r["reason"]}', style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
        Text('${AppStrings.t("reported_by")}: ${r["reporter"]}', style: TextStyle(fontSize: 12, color: context.textHintC)),
        if (isPending) ...[
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: ElevatedButton(onPressed: () {
              showDialog(context: context, builder: (d) => AlertDialog(
                title: Text(AppStrings.t('adm_take_action')),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  ListTile(leading: const Icon(Icons.warning, color: GuroJobsTheme.warning), title: Text(AppStrings.t('adm_warn_user')), onTap: () { Navigator.pop(d); setState(() => r['status'] = 'resolved'); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.t('adm_warning_sent')), backgroundColor: GuroJobsTheme.warning, behavior: SnackBarBehavior.floating)); }),
                  ListTile(leading: const Icon(Icons.block, color: GuroJobsTheme.error), title: Text(AppStrings.t('adm_ban')), onTap: () { Navigator.pop(d); setState(() => r['status'] = 'resolved'); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${r["target"]} ${AppStrings.t("blocked")}'), backgroundColor: GuroJobsTheme.error, behavior: SnackBarBehavior.floating)); }),
                  ListTile(leading: const Icon(Icons.delete, color: GuroJobsTheme.error), title: Text(AppStrings.t('adm_remove_content')), onTap: () { Navigator.pop(d); setState(() => r['status'] = 'resolved'); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.t('adm_content_removed')), backgroundColor: GuroJobsTheme.success, behavior: SnackBarBehavior.floating)); }),
                ]),
              ));
            }, style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.error, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text(AppStrings.t('adm_take_action')))),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton(onPressed: () {
              setState(() => r['status'] = 'resolved');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.t('adm_report_dismissed')), backgroundColor: GuroJobsTheme.info, behavior: SnackBarBehavior.floating));
            }, style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text(AppStrings.t('adm_dismiss')))),
          ]),
        ],
      ]),
    );
  }
}

class _AdminSubscriptionsScreen extends StatefulWidget {
  const _AdminSubscriptionsScreen();
  @override
  State<_AdminSubscriptionsScreen> createState() => _AdminSubscriptionsState();
}

class _AdminSubscriptionsState extends State<_AdminSubscriptionsScreen> {
  String _filter = 'all';

  static final _subscribers = <Map<String, dynamic>>[
    {'name': 'BetStars Gaming', 'email': 'hr@betstars.com', 'plan': 'vip', 'status': 'active', 'expires': '2026-04-17', 'contacts_used': 42, 'revenue': 65.0},
    {'name': 'CryptoPlay Ltd', 'email': 'jobs@cryptoplay.io', 'plan': 'premium', 'status': 'active', 'expires': '2026-04-10', 'contacts_used': 28, 'revenue': 35.0},
    {'name': 'LuckySlots', 'email': 'recruit@luckyslots.com', 'plan': 'basic', 'status': 'active', 'expires': '2026-04-05', 'contacts_used': 7, 'revenue': 10.0},
    {'name': 'NutraHealth', 'email': 'hr@nutrahealth.eu', 'plan': 'premium', 'status': 'active', 'expires': '2026-04-12', 'contacts_used': 35, 'revenue': 35.0},
    {'name': 'BlockBet', 'email': 'team@blockbet.io', 'plan': 'basic', 'status': 'expired', 'expires': '2026-03-15', 'contacts_used': 0, 'revenue': 10.0},
    {'name': 'DatingPro', 'email': 'jobs@datingpro.com', 'plan': 'vip', 'status': 'active', 'expires': '2026-04-20', 'contacts_used': 89, 'revenue': 65.0},
    {'name': 'SlotMaster', 'email': 'hr@slotmaster.com', 'plan': 'basic', 'status': 'trial', 'expires': '2026-04-01', 'contacts_used': 3, 'revenue': 0.0},
    {'name': 'GambleFi', 'email': 'careers@gamblefi.io', 'plan': 'premium', 'status': 'cancelled', 'expires': '2026-03-20', 'contacts_used': 0, 'revenue': 35.0},
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'all') return _subscribers;
    return _subscribers.where((s) => s['status'] == _filter || s['plan'] == _filter).toList();
  }

  Color _planColor(String plan) {
    switch (plan) {
      case 'vip': return GuroJobsTheme.accent;
      case 'premium': return GuroJobsTheme.primary;
      case 'basic': return GuroJobsTheme.info;
      default: return GuroJobsTheme.success;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active': return GuroJobsTheme.success;
      case 'trial': return GuroJobsTheme.info;
      case 'expired': return GuroJobsTheme.error;
      case 'cancelled': return GuroJobsTheme.warning;
      default: return GuroJobsTheme.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final activeCount = _subscribers.where((s) => s['status'] == 'active').length;
    final trialCount = _subscribers.where((s) => s['status'] == 'trial').length;
    final totalMRR = _subscribers.where((s) => s['status'] == 'active').fold<double>(0, (sum, s) => sum + (s['revenue'] as double));

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t('adm_subscriptions'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // MRR overview
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF015EA7), Color(0xFF6C5CE7)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('MRR', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8))),
                Text('\$${totalMRR.toStringAsFixed(0)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)),
              ])),
              Column(children: [
                _miniStat('$activeCount', AppStrings.t('active'), Colors.white),
                const SizedBox(height: 8),
                _miniStat('$trialCount', 'Trial', Colors.white),
              ]),
            ]),
          ),
          const SizedBox(height: 16),

          // Plan breakdown
          Row(children: [
            ...[
              {'key': 'basic', 'label': 'Basic', 'count': _subscribers.where((s) => s['plan'] == 'basic').length},
              {'key': 'premium', 'label': 'Premium', 'count': _subscribers.where((s) => s['plan'] == 'premium').length},
              {'key': 'vip', 'label': 'VIP', 'count': _subscribers.where((s) => s['plan'] == 'vip').length},
            ].map((p) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: _planColor(p['key'] as String).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Column(children: [
                  Text('${p['count']}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _planColor(p['key'] as String))),
                  Text(p['label'] as String, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
                ]),
              ),
            )),
          ]),
          const SizedBox(height: 20),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              _filterChip('all', AppStrings.t('all')),
              _filterChip('active', AppStrings.t('active')),
              _filterChip('trial', 'Trial'),
              _filterChip('expired', AppStrings.t('expired')),
              _filterChip('cancelled', AppStrings.t('cancelled')),
            ]),
          ),
          const SizedBox(height: 16),

          // Subscribers list
          Text('${filtered.length} ${AppStrings.t('adm_subscribers')}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(height: 12),
          ...filtered.map((sub) => _subscriberCard(context, sub)),
        ],
      ),
    );
  }

  Widget _miniStat(String value, String label, Color c) {
    return Row(children: [
      Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: c)),
      const SizedBox(width: 6),
      Text(label, style: TextStyle(fontSize: 12, color: c.withValues(alpha: 0.8))),
    ]);
  }

  Widget _filterChip(String key, String label) {
    final selected = _filter == key;
    return GestureDetector(
      onTap: () => setState(() => _filter = key),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? GuroJobsTheme.primary : context.surfaceBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? GuroJobsTheme.primary : context.dividerC),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.w400, color: selected ? Colors.white : context.textPrimaryC)),
      ),
    );
  }

  Widget _subscriberCard(BuildContext context, Map<String, dynamic> sub) {
    final plan = sub['plan'] as String;
    final status = sub['status'] as String;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.dividerC),
      ),
      child: Column(children: [
        Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: _planColor(plan).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text((sub['name'] as String)[0], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _planColor(plan)))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(sub['name'] as String, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
            Text(sub['email'] as String, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: _planColor(plan).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
              child: Text(ContactPricing.planNames[plan] ?? plan, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _planColor(plan))),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: _statusColor(status).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _statusColor(status))),
            ),
          ]),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _subInfo(context, Icons.calendar_today, 'Expires: ${sub['expires']}'),
          const SizedBox(width: 16),
          _subInfo(context, Icons.contacts, '${sub['contacts_used']} contacts'),
        ]),
        const SizedBox(height: 10),
        // Action buttons
        Row(children: [
          Expanded(child: OutlinedButton.icon(
            onPressed: () => _showChangePlan(context, sub),
            icon: const Icon(Icons.swap_horiz, size: 16),
            label: Text(AppStrings.t('change_plan')),
            style: OutlinedButton.styleFrom(
              foregroundColor: GuroJobsTheme.primary,
              side: const BorderSide(color: GuroJobsTheme.primary),
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          )),
          const SizedBox(width: 8),
          Expanded(child: OutlinedButton.icon(
            onPressed: () => _showExtend(context, sub),
            icon: const Icon(Icons.add_circle_outline, size: 16),
            label: Text(AppStrings.t('extend')),
            style: OutlinedButton.styleFrom(
              foregroundColor: GuroJobsTheme.success,
              side: const BorderSide(color: GuroJobsTheme.success),
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          )),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _showBlock(context, sub),
            icon: const Icon(Icons.block, size: 20),
            color: GuroJobsTheme.error,
            tooltip: AppStrings.t('block'),
          ),
        ]),
      ]),
    );
  }

  Widget _subInfo(BuildContext context, IconData icon, String text) {
    return Row(children: [
      Icon(icon, size: 14, color: context.textHintC),
      const SizedBox(width: 4),
      Text(text, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
    ]);
  }

  void _showChangePlan(BuildContext context, Map<String, dynamic> sub) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: context.cardBg,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('${AppStrings.t('change_plan')}: ${sub['name']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          ...['basic', 'premium', 'vip'].map((p) {
            final current = sub['plan'] == p;
            return ListTile(
              leading: Icon(Icons.workspace_premium, color: _planColor(p)),
              title: Text('${ContactPricing.planNames[p]} — \$${ContactPricing.prices[p]?.toStringAsFixed(0)}/mo', style: TextStyle(fontWeight: current ? FontWeight.w700 : FontWeight.w400)),
              subtitle: Text('${ContactPricing.limitFor(p)} contacts/day, Team ${ContactPricing.teamLimit[p]}', style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
              trailing: current ? const Icon(Icons.check_circle, color: GuroJobsTheme.success) : null,
              onTap: current ? null : () {
                setState(() => sub['plan'] = p);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${sub['name']} → ${ContactPricing.planNames[p]}'),
                  backgroundColor: GuroJobsTheme.success, behavior: SnackBarBehavior.floating,
                ));
              },
            );
          }),
        ]),
      ),
    );
  }

  void _showExtend(BuildContext context, Map<String, dynamic> sub) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${AppStrings.t('extend')}: ${sub['name']}'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(AppStrings.t('extend_confirm')),
          const SizedBox(height: 16),
          ...['7 ${AppStrings.t("days")}', '14 ${AppStrings.t("days")}', '30 ${AppStrings.t("days")}'].map((d) => ListTile(
            title: Text('+$d'),
            leading: const Icon(Icons.add_circle_outline, color: GuroJobsTheme.success),
            onTap: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${sub['name']} ${AppStrings.t("extended_by")} $d'),
                backgroundColor: GuroJobsTheme.success, behavior: SnackBarBehavior.floating,
              ));
            },
          )),
        ]),
      ),
    );
  }

  void _showBlock(BuildContext context, Map<String, dynamic> sub) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${AppStrings.t('block')}: ${sub['name']}?'),
        content: Text(AppStrings.t('block_confirm')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppStrings.t('cancel'))),
          TextButton(
            onPressed: () {
              setState(() => sub['status'] = 'cancelled');
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${sub['name']} ${AppStrings.t("blocked")}'),
                backgroundColor: GuroJobsTheme.error, behavior: SnackBarBehavior.floating,
              ));
            },
            child: Text(AppStrings.t('block'), style: const TextStyle(color: GuroJobsTheme.error)),
          ),
        ],
      ),
    );
  }
}

class _ContactPricingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: context.surfaceBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.dividerC)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Daily Contact Reveal Limits', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
        const SizedBox(height: 6),
        Text('Contacts per day by employer plan', style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
        const SizedBox(height: 16),
        ...ContactPricing.dailyLimits.entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(children: [
            const Icon(Icons.workspace_premium, size: 18, color: GuroJobsTheme.primary),
            const SizedBox(width: 10),
            Expanded(child: Text(ContactPricing.planNames[entry.key] ?? entry.key, style: TextStyle(fontSize: 14, color: context.textPrimaryC))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(color: GuroJobsTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Text('${entry.value}/day', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary)),
            ),
          ]),
        )),
      ]),
    );
  }
}
