import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';

class NumberStepper extends StatelessWidget {
  const NumberStepper({
    super.key,
    required this.value,
    required this.label,
    required this.onIncrement,
    required this.onDecrement,
    required this.onSubmitted,
  });

  final String value;
  final String label;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<int> onSubmitted;

  Future<void> _edit(BuildContext context) async {
    final result = await showDialog<int>(
      context: context,
      builder: (_) => _EditDialog(label: label, initial: value),
    );
    if (result != null) onSubmitted(result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.keyboard_arrow_up),
          color: AppColors.textSecondary,
          iconSize: 28,
        ),
        GestureDetector(
          onTap: () => _edit(context),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 88,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
        ),
        IconButton(
          onPressed: onDecrement,
          icon: const Icon(Icons.keyboard_arrow_down),
          color: AppColors.textSecondary,
          iconSize: 28,
        ),
        const Text(
          'TAP TO EDIT',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _EditDialog extends StatefulWidget {
  const _EditDialog({required this.label, required this.initial});

  final String label;
  final String initial;

  @override
  State<_EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final parsed = int.tryParse(_controller.text);
    Navigator.of(context).pop(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('Edit ${widget.label}'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: _submit, child: const Text('OK')),
      ],
    );
  }
}
