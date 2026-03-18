import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import '../../../providers/lang_provider.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  final Map<String, bool> _connected = {};

  @override
  Widget build(BuildContext context) {
    context.watch<LangProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t('connections'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(AppStrings.t('messengers'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(height: 6),
          Text(AppStrings.t('messengers_desc'), style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
          const SizedBox(height: 16),
          _connectorTile(id: 'telegram', name: AppStrings.t('telegram_name'), icon: Icons.send, color: const Color(0xFF0088CC), description: AppStrings.t('telegram_desc'), qrUrl: 'https://t.me/GuroJobsbot'),
          _connectorTile(id: 'whatsapp', name: AppStrings.t('whatsapp_name'), icon: Icons.chat_bubble, color: const Color(0xFF25D366), description: AppStrings.t('whatsapp_desc'), qrUrl: 'https://wa.me/48579266493'),
          _connectorTile(id: 'viber', name: AppStrings.t('viber_name'), icon: Icons.phone_in_talk, color: const Color(0xFF7360F2), description: AppStrings.t('viber_desc')),
          _connectorTile(id: 'email', name: AppStrings.t('email_name'), icon: Icons.email, color: const Color(0xFF6C757D), description: AppStrings.t('email_desc')),
          _connectorTile(id: 'signal', name: AppStrings.t('signal_name'), icon: Icons.security, color: const Color(0xFF3A76F0), description: AppStrings.t('signal_desc')),

          const SizedBox(height: 30),

          Text(AppStrings.t('social_networks'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(height: 6),
          Text(AppStrings.t('social_desc'), style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
          const SizedBox(height: 16),
          _connectorTile(id: 'linkedin', name: AppStrings.t('linkedin_name'), icon: Icons.business_center, color: const Color(0xFF0A66C2), description: AppStrings.t('linkedin_desc')),
          _connectorTile(id: 'github', name: AppStrings.t('github_name'), icon: Icons.code, color: context.isDark ? Colors.white : const Color(0xFF24292E), description: AppStrings.t('github_desc')),
          _connectorTile(id: 'twitter', name: AppStrings.t('twitter_name'), icon: Icons.alternate_email, color: context.isDark ? Colors.white : const Color(0xFF1DA1F2), description: AppStrings.t('twitter_desc')),
          _connectorTile(id: 'facebook', name: AppStrings.t('facebook_name'), icon: Icons.facebook, color: const Color(0xFF1877F2), description: AppStrings.t('facebook_desc')),
          _connectorTile(id: 'instagram', name: AppStrings.t('instagram_name'), icon: Icons.camera_alt, color: const Color(0xFFE4405F), description: AppStrings.t('instagram_desc')),
          _connectorTile(id: 'discord', name: AppStrings.t('discord_name'), icon: Icons.headphones, color: const Color(0xFF5865F2), description: AppStrings.t('discord_desc')),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _connectorTile({required String id, required String name, required IconData icon, required Color color, required String description, String? qrUrl}) {
    final isConnected = _connected[id] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isConnected ? GuroJobsTheme.success.withOpacity(0.4) : context.dividerC),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                    if (isConnected) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: GuroJobsTheme.success.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: Text(AppStrings.t('connected'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: GuroJobsTheme.success)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isConnected)
            IconButton(
              icon: Icon(Icons.link_off, color: context.textHintC, size: 22),
              onPressed: () {
                setState(() => _connected[id] = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name ${AppStrings.t('disconnected')}'), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 1)),
                );
              },
            )
          else
            GestureDetector(
              onTap: () => _showConnectSheet(id, name, icon, color, qrUrl),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.3))),
                child: Icon(Icons.add, color: color, size: 22),
              ),
            ),
        ],
      ),
    );
  }

  void _showConnectSheet(String id, String name, IconData icon, Color color, String? qrUrl) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 16),
              Text('${AppStrings.t('connect_title')} $name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
              const SizedBox(height: 8),
              Text('${AppStrings.t('connect_scan_desc')} $name', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
              const SizedBox(height: 24),
              Container(
                width: 180, height: 180,
                decoration: BoxDecoration(color: context.surfaceBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.dividerC)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_2, size: 100, color: context.textHintC),
                    const SizedBox(height: 8),
                    Text(AppStrings.t('scan_to_connect'), style: TextStyle(fontSize: 12, color: context.textHintC)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    if (qrUrl != null) {
                      final uri = Uri.parse(qrUrl);
                      if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                    await Future.delayed(const Duration(milliseconds: 500));
                    if (mounted) {
                      setState(() => _connected[id] = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$name ${AppStrings.t('connected_success')}'), backgroundColor: GuroJobsTheme.success, behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2)),
                      );
                    }
                  },
                  icon: Icon(icon, size: 20),
                  label: Text('${AppStrings.t('connect')} $name', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppStrings.t('cancel'), style: TextStyle(color: context.textSecondaryC))),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
