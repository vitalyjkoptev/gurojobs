import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/lang_provider.dart';
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
    context.watch<LangProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(AppStrings.t('notifications'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(height: 8),
          _toggle(AppStrings.t('push_notifications'), AppStrings.t('push_notifications_desc'), _pushNotif, (v) {
            setState(() => _pushNotif = v);
          }),
          _toggle(AppStrings.t('email_notifications'), AppStrings.t('email_notifications_desc'), _emailNotif, (v) {
            setState(() => _emailNotif = v);
          }),
          const SizedBox(height: 24),
          Text(AppStrings.t('appearance'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(height: 8),
          _toggle(AppStrings.t('dark_mode'), AppStrings.t('dark_mode_desc'), themeProv.isDark, (v) {
            themeProv.toggle();
          }),
          const SizedBox(height: 24),
          Text(AppStrings.t('account'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(height: 8),
          _menuItem(AppStrings.t('change_password'), Icons.lock_outline, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
          }),
          _menuItem(AppStrings.t('clear_app_data'), Icons.cleaning_services_outlined, () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(AppStrings.t('clear_app_data')),
                content: Text(AppStrings.t('clear_app_data_confirm')),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppStrings.t('cancel'))),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(AppStrings.t('clear'), style: const TextStyle(color: GuroJobsTheme.error)),
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
          _menuItem(AppStrings.t('delete_account'), Icons.delete_outline, () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(AppStrings.t('delete_account')),
                content: Text(AppStrings.t('delete_account_confirm')),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppStrings.t('cancel'))),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(AppStrings.t('delete'), style: const TextStyle(color: GuroJobsTheme.error)),
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
