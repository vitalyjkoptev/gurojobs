import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../services/api_service.dart';

/// Виджет для жалоб на вакансию или пользователя.
/// Использование: ReportDialog.show(context, type: 'job', id: 123);
class ReportDialog {
  static const _reasons = [
    {'value': 'spam', 'label': 'Spam', 'icon': Icons.report},
    {'value': 'fake', 'label': 'Fake listing', 'icon': Icons.warning},
    {'value': 'inappropriate', 'label': 'Inappropriate content', 'icon': Icons.block},
    {'value': 'harassment', 'label': 'Harassment', 'icon': Icons.person_off},
    {'value': 'scam', 'label': 'Scam / Fraud', 'icon': Icons.gpp_bad},
    {'value': 'other', 'label': 'Other', 'icon': Icons.more_horiz},
  ];

  static Future<void> show(BuildContext context, {required String type, required int id}) async {
    String? selectedReason;
    final descCtrl = TextEditingController();
    bool submitting = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.flag, color: Colors.red, size: 22),
                  const SizedBox(width: 8),
                  Text('Report ${type == 'job' ? 'Job' : 'User'}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Select reason:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: _reasons.map((r) {
                  final sel = selectedReason == r['value'];
                  return ChoiceChip(
                    avatar: Icon(r['icon'] as IconData, size: 16, color: sel ? Colors.white : Colors.grey),
                    label: Text(r['label'] as String),
                    selected: sel,
                    selectedColor: Colors.red,
                    labelStyle: TextStyle(color: sel ? Colors.white : null, fontSize: 13),
                    onSelected: (_) => setState(() => selectedReason = r['value'] as String),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Describe the issue (optional)...',
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton(
                  onPressed: selectedReason == null || submitting ? null : () async {
                    setState(() => submitting = true);
                    try {
                      final res = await ApiService.submitReport(
                        type: type, id: id,
                        reason: selectedReason!,
                        description: descCtrl.text.isNotEmpty ? descCtrl.text : null,
                      );
                      if (ctx.mounted) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(res['message'] ?? 'Report submitted'),
                          backgroundColor: Colors.green,
                        ));
                      }
                    } catch (e) {
                      setState(() => submitting = false);
                      if (ctx.mounted) {
                        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                          content: Text('Error: $e'), backgroundColor: Colors.red,
                        ));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: submitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Submit Report', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
