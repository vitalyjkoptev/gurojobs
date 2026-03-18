import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import 'job_detail_screen.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({super.key});

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  final List<Map<String, String>> _savedJobs = [
    {'title': 'Senior Casino Game Developer', 'company': 'Evolution Gaming', 'location': 'Malta', 'type': 'Full-time', 'salary': '€65-85K'},
    {'title': 'iGaming Compliance Officer', 'company': 'LeoVegas', 'location': 'Gibraltar', 'type': 'Full-time', 'salary': '€50-65K'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t('saved_jobs'))),
      body: _savedJobs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.bookmark_outline, size: 48, color: GuroJobsTheme.primary),
                  ),
                  const SizedBox(height: 24),
                  Text('No Saved Jobs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                  const SizedBox(height: 8),
                  Text('Jobs you save will appear here', style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _savedJobs.length,
              itemBuilder: (context, index) {
                final job = _savedJobs[index];
                return Dismissible(
                  key: Key('${job['title']}_$index'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: GuroJobsTheme.error, borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    setState(() => _savedJobs.removeAt(index));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job removed from saved'), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 1)));
                  },
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => JobDetailScreen(job: job))),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.cardBg, borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: context.shadowC, blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(color: GuroJobsTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                            child: Center(child: Text(job['company']![0], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary))),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(job['title']!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
                                const SizedBox(height: 4),
                                Text('${job['company']} • ${job['location']}', style: TextStyle(fontSize: 13, color: context.textSecondaryC)),
                                const SizedBox(height: 4),
                                Text(job['salary']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: GuroJobsTheme.primary)),
                              ],
                            ),
                          ),
                          const Icon(Icons.bookmark, color: GuroJobsTheme.primary, size: 22),
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
