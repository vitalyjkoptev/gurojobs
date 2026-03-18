import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _saving = false;
  bool _showCurrent = false;
  bool _showNew = false;

  @override
  void dispose() { _currentCtrl.dispose(); _newCtrl.dispose(); _confirmCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Password changed successfully!'), backgroundColor: GuroJobsTheme.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lock_outline, size: 48, color: GuroJobsTheme.primary),
              const SizedBox(height: 16),
              Text('Update your password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
              const SizedBox(height: 6),
              Text('Enter your current password and choose a new one', style: TextStyle(fontSize: 14, color: context.textSecondaryC)),
              const SizedBox(height: 30),
              _passwordField('Current Password', _currentCtrl, _showCurrent, (v) => setState(() => _showCurrent = v),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter current password' : null),
              const SizedBox(height: 16),
              _passwordField('New Password', _newCtrl, _showNew, (v) => setState(() => _showNew = v),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter new password';
                  if (v.length < 8) return AppStrings.t('password_min');
                  return null;
                }),
              const SizedBox(height: 16),
              _passwordField('Confirm New Password', _confirmCtrl, false, null,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Confirm your password';
                  if (v != _newCtrl.text) return AppStrings.t('passwords_mismatch');
                  return null;
                }),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(backgroundColor: GuroJobsTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: _saving
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : const Text('Update Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordField(String label, TextEditingController ctrl, bool showPw, ValueChanged<bool>? onToggle, {String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl, obscureText: !showPw, validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline, size: 20, color: context.textHintC),
            suffixIcon: onToggle != null ? IconButton(icon: Icon(showPw ? Icons.visibility_off : Icons.visibility, size: 20, color: context.textHintC), onPressed: () => onToggle(!showPw)) : null,
            filled: true, fillColor: context.inputFill,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
          ),
        ),
      ],
    );
  }
}
