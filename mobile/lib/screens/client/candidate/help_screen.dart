import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t('help_support'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('How can we help?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(height: 20),
          _item(context, 'Email Support', Icons.email_outlined, 'info@gurojobs.com', () => _open('mailto:info@gurojobs.com')),
          _item(context, 'Telegram', Icons.send, '@GuroJobsbot', () => _open('https://t.me/GuroJobsbot')),
          _item(context, 'Community', Icons.group_outlined, 't.me/GuroJobs', () => _open('https://t.me/GuroJobs')),
          _item(context, 'Website', Icons.language, 'gurojobs.com', () => _open('https://gurojobs.com')),
          const SizedBox(height: 30),
          Text('FAQ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
          const SizedBox(height: 12),
          _faq(context, 'How to apply for a job?', 'Go to Jobs tab, find a job you like and tap Apply.'),
          _faq(context, 'How to upload CV?', 'Go to Profile -> My CV and upload your resume in PDF or DOC format.'),
          _faq(context, 'How to change language?', 'Go to Profile -> Language and select your preferred language.'),
          _faq(context, 'How to contact an employer?', 'After applying, the employer will contact you through the platform chat. All communication happens on the platform.'),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String title, IconData icon, String sub, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.dividerC)),
        child: Row(children: [
          Icon(icon, size: 22, color: GuroJobsTheme.primary),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
            Text(sub, style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
          ])),
          Icon(Icons.open_in_new, size: 18, color: context.textHintC),
        ]),
      ),
    );
  }

  Widget _faq(BuildContext context, String q, String a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.dividerC)),
      child: ExpansionTile(
        title: Text(q, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [Text(a, style: TextStyle(fontSize: 13, color: context.textSecondaryC))],
      ),
    );
  }

  static Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
