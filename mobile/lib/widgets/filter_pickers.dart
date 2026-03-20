import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/countries.dart';

/// Single-select dropdown for language or country
class SingleSelectPicker extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final String hint;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  const SingleSelectPicker({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.hint,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: context.textHintC, fontSize: 14)),
          isExpanded: true,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: context.textHintC),
            filled: true,
            fillColor: context.inputFill,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.dividerC)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Multi-select chips picker (opens a bottom sheet with checkboxes)
class MultiSelectChipsPicker extends StatelessWidget {
  final String label;
  final List<String> selected;
  final List<String> items;
  final String hint;
  final IconData icon;
  final int maxSelect;
  final ValueChanged<List<String>> onChanged;

  const MultiSelectChipsPicker({
    super.key,
    required this.label,
    required this.selected,
    required this.items,
    required this.hint,
    required this.icon,
    this.maxSelect = 5,
    required this.onChanged,
  });

  void _showPicker(BuildContext context) {
    final tempSelected = List<String>.from(selected);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setModalState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 0.85,
            minChildSize: 0.3,
            expand: false,
            builder: (_, scrollCtrl) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                        TextButton(
                          onPressed: () {
                            onChanged(tempSelected);
                            Navigator.pop(ctx);
                          },
                          child: Text('Done (${tempSelected.length})', style: TextStyle(color: GuroJobsTheme.primary, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollCtrl,
                      itemCount: items.length,
                      itemBuilder: (_, i) {
                        final item = items[i];
                        final isSelected = tempSelected.contains(item);
                        return CheckboxListTile(
                          title: Text(item, style: const TextStyle(fontSize: 14)),
                          value: isSelected,
                          activeColor: GuroJobsTheme.primary,
                          onChanged: (checked) {
                            setModalState(() {
                              if (checked == true) {
                                if (tempSelected.length < maxSelect) {
                                  tempSelected.add(item);
                                }
                              } else {
                                tempSelected.remove(item);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _showPicker(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: context.inputFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.dividerC),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: context.textHintC),
                const SizedBox(width: 12),
                Expanded(
                  child: selected.isEmpty
                      ? Text(hint, style: TextStyle(color: context.textHintC, fontSize: 14))
                      : Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: selected.map((s) => Chip(
                            label: Text(s, style: const TextStyle(fontSize: 12)),
                            deleteIcon: const Icon(Icons.close, size: 14),
                            onDeleted: () {
                              final updated = List<String>.from(selected)..remove(s);
                              onChanged(updated);
                            },
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          )).toList(),
                        ),
                ),
                Icon(Icons.arrow_drop_down, color: context.textHintC),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Yes/No toggle
class YesNoToggle extends StatelessWidget {
  final String label;
  final bool? value;
  final ValueChanged<bool?> onChanged;

  const YesNoToggle({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimaryC)),
        const SizedBox(height: 8),
        Row(children: [
          _chip(context, 'Yes', true),
          const SizedBox(width: 8),
          _chip(context, 'No', false),
        ]),
      ],
    );
  }

  Widget _chip(BuildContext context, String text, bool chipValue) {
    final selected = value == chipValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(chipValue),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? GuroJobsTheme.primary : context.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? GuroJobsTheme.primary : context.dividerC, width: selected ? 2 : 1),
          ),
          child: Center(child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: selected ? Colors.white : context.textSecondaryC))),
        ),
      ),
    );
  }
}
