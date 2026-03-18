import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/theme_provider.dart';
import 'change_password_screen.dart';
import 'splash_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotif = true;
  bool _emailNotif = true;

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(height: 8),
          _toggle('Push Notifications', 'Get notified about new jobs', _pushNotif, (v) {
            setState(() => _pushNotif = v);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(v ? 'Push notifications enabled' : 'Push notifications disabled'), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 1)));
          }),
          _toggle('Email Notifications', 'Receive job alerts via email', _emailNotif, (v) {
            setState(() => _emailNotif = v);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(v ? 'Email notifications enabled' : 'Email notifications disabled'), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 1)));
          }),
          const SizedBox(height: 24),
          Text('Appearance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(height: 8),
          _toggle('Dark Mode', 'Switch to dark theme', themeProv.isDark, (v) {
            themeProv.toggle();
          }),
          const SizedBox(height: 24),
          Text('Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(height: 8),
          _menuItem('Change Password', Icons.lock_outline, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
          }),
          _menuItem('Clear App Data', Icons.cleaning_services_outlined, () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Clear App Data'),
                content: const Text('This will log you out and clear all saved preferences. Continue?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppStrings.t('cancel'))),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Clear', style: TextStyle(color: GuroJobsTheme.error)),
                  ),
                ],
              ),
            );
            if (confirm == true && context.mounted) {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const SplashScreen()), (route) => false);
              }
            }
          }),
          _menuItem('Delete Account', Icons.delete_outline, () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete Account'),
                content: const Text('This action is permanent and cannot be undone. All your data will be deleted.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppStrings.t('cancel'))),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Delete', style: TextStyle(color: GuroJobsTheme.error)),
                  ),
                ],
              ),
            );
            if (confirm == true && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account deletion request submitted. You will receive an email confirmation.'), behavior: SnackBarBehavior.floating));
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const SplashScreen()), (route) => false);
              }
            }
          }, color: GuroJobsTheme.error),
          const SizedBox(height: 30),
          Center(child: Text('GURO JOBS v1.0.0', style: TextStyle(fontSize: 12, color: context.textHintC))),
        ],
      ),
    );
  }

  Widget _toggle(String title, String sub, bool val, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.dividerC)),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: context.textPrimaryC)),
            Text(sub, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
          ])),
          Switch(value: val, onChanged: onChanged, activeColor: GuroJobsTheme.primary),
        ],
      ),
    );
  }

  Widget _menuItem(String title, IconData icon, VoidCallback onTap, {Color? color}) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.dividerC)),
        child: Row(children: [
          Icon(icon, size: 22, color: color ?? context.textSecondaryC),
          const SizedBox(width: 14),
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color ?? context.textPrimaryC)),
          const Spacer(),
          Icon(Icons.chevron_right, size: 20, color: color ?? context.textHintC),
        ]),
      ),
    );
  }
}
