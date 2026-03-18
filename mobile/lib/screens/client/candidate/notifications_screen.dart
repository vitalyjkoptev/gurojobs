import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotifItem> _notifications = [
    _NotifItem(icon: Icons.work, color: GuroJobsTheme.primary, title: 'New jobs matching your profile', body: '5 new iGaming jobs in Malta posted today', time: '2h ago', read: false),
    _NotifItem(icon: Icons.check_circle, color: GuroJobsTheme.success, title: 'Application received', body: 'Evolution Gaming confirmed your application', time: '1d ago', read: false),
    _NotifItem(icon: Icons.person, color: GuroJobsTheme.accent, title: 'Profile viewed', body: 'An employer viewed your profile', time: '2d ago', read: true),
    _NotifItem(icon: Icons.star, color: GuroJobsTheme.warning, title: 'Complete your profile', body: 'Add your CV to increase visibility by 80%', time: '3d ago', read: true),
    _NotifItem(icon: Icons.campaign, color: GuroJobsTheme.info, title: 'Welcome to GURO JOBS!', body: 'Start exploring iGaming careers today', time: '5d ago', read: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t('notifications')),
        actions: [
          TextButton(
            onPressed: () => setState(() { for (var n in _notifications) { n.read = true; } }),
            child: const Text('Mark all read', style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.notifications_outlined, size: 48, color: GuroJobsTheme.primary),
                  ),
                  const SizedBox(height: 24),
                  Text('No Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                  const SizedBox(height: 8),
                  Text('You\'re all caught up!', style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final n = _notifications[index];
                return Dismissible(
                  key: Key('notif_$index'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(color: GuroJobsTheme.error, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => setState(() => _notifications.removeAt(index)),
                  child: GestureDetector(
                    onTap: () => setState(() => n.read = true),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: n.read ? context.cardBg : GuroJobsTheme.primary.withOpacity(context.isDark ? 0.1 : 0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: n.read ? context.dividerC : GuroJobsTheme.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42, height: 42,
                            decoration: BoxDecoration(color: n.color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                            child: Icon(n.icon, size: 22, color: n.color),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Expanded(child: Text(n.title, style: TextStyle(fontSize: 14, fontWeight: n.read ? FontWeight.w500 : FontWeight.w700, color: context.textPrimaryC))),
                                  if (!n.read) Container(width: 8, height: 8, decoration: const BoxDecoration(color: GuroJobsTheme.primary, shape: BoxShape.circle)),
                                ]),
                                const SizedBox(height: 4),
                                Text(n.body, style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
                                const SizedBox(height: 6),
                                Text(n.time, style: TextStyle(fontSize: 11, color: context.textHintC)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _NotifItem {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;
  bool read;
  _NotifItem({required this.icon, required this.color, required this.title, required this.body, required this.time, required this.read});
}
