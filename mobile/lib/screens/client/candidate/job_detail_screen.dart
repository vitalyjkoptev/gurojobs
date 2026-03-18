import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import 'report_dialog.dart';

class JobDetailScreen extends StatefulWidget {
  final Map<String, String> job;
  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool _saved = false;
  bool _applied = false;
  bool _applying = false;

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200, pinned: true,
            backgroundColor: GuroJobsTheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [GuroJobsTheme.primary, GuroJobsTheme.primaryDark]),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56, height: 56,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                              child: Center(child: Text(job['company']![0], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary))),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(job['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                                  const SizedBox(height: 4),
                                  Text(job['company']!, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.85))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_saved ? Icons.bookmark : Icons.bookmark_border, color: Colors.white),
                onPressed: () {
                  setState(() => _saved = !_saved);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_saved ? 'Job saved!' : 'Job removed from saved'), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 1)));
                },
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share link copied!'), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 1))),
              ),
              IconButton(
                icon: const Icon(Icons.flag_outlined, color: Colors.white),
                tooltip: 'Report',
                onPressed: () => ReportDialog.show(context, type: 'job', id: 1),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: [
                      _tag(context, Icons.location_on_outlined, job['location']!),
                      _tag(context, Icons.schedule, job['type']!),
                      _tag(context, Icons.euro, job['salary']!),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Job Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                  const SizedBox(height: 12),
                  Text(
                    'We are looking for an experienced ${job['title']} to join our team at ${job['company']}. '
                    'This is an exciting opportunity to work in the fast-growing iGaming industry.\n\n'
                    'You will be responsible for developing and maintaining high-quality products, '
                    'collaborating with cross-functional teams, and driving innovation.',
                    style: TextStyle(fontSize: 14, color: context.textSecondaryC, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  Text('Requirements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                  const SizedBox(height: 12),
                  _bullet(context, '3+ years of relevant experience'),
                  _bullet(context, 'Strong communication skills'),
                  _bullet(context, 'Experience in the iGaming industry is a plus'),
                  _bullet(context, 'English proficiency (B2+)'),
                  _bullet(context, 'Team player with a proactive mindset'),
                  const SizedBox(height: 24),
                  Text('Benefits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                  const SizedBox(height: 12),
                  _benefit(context, Icons.health_and_safety, 'Health Insurance'),
                  _benefit(context, Icons.home_work, 'Remote Work Options'),
                  _benefit(context, Icons.school, 'Professional Development'),
                  _benefit(context, Icons.flight, 'Annual Team Trips'),
                  _benefit(context, Icons.fitness_center, 'Gym Membership'),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.dividerC)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('About Company', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                        const SizedBox(height: 10),
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
                                  Text(job['company']!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                                  Text('iGaming Company', style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
                                ],
                              ),
                            ),
                            TextButton(onPressed: () {}, child: const Text('View')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: context.cardBg,
          boxShadow: [BoxShadow(color: context.shadowMedium, blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: SizedBox(
          width: double.infinity, height: 52,
          child: ElevatedButton(
            onPressed: _applied ? null : _applyForJob,
            style: ElevatedButton.styleFrom(
              backgroundColor: _applied ? GuroJobsTheme.success : GuroJobsTheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: _applying
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_applied ? Icons.check_circle : Icons.send, size: 20),
                      const SizedBox(width: 8),
                      Text(_applied ? 'Applied!' : 'Apply Now', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _applyForJob() async {
    setState(() => _applying = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() { _applying = false; _applied = true; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Application submitted successfully!'), backgroundColor: GuroJobsTheme.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      );
    }
  }

  Widget _tag(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: context.cardBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: context.dividerC)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: GuroJobsTheme.primary),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: context.textPrimaryC)),
        ],
      ),
    );
  }

  Widget _bullet(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 6), child: Icon(Icons.circle, size: 6, color: GuroJobsTheme.primary)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14, color: context.textSecondaryC, height: 1.4))),
        ],
      ),
    );
  }

  Widget _benefit(BuildContext context, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: GuroJobsTheme.success.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: GuroJobsTheme.success),
          ),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: context.textPrimaryC)),
        ],
      ),
    );
  }
}
