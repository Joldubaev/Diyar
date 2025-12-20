import 'package:flutter/material.dart';

/// Диалог для ввода имени шаблона при сохранении адреса
class SaveTemplateDialog extends StatefulWidget {
  final String defaultName;
  final ThemeData theme;

  const SaveTemplateDialog({
    super.key,
    required this.defaultName,
    required this.theme,
  });

  static Future<String?> show({
    required BuildContext context,
    required String defaultName,
    required ThemeData theme,
  }) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => SaveTemplateDialog(
        defaultName: defaultName,
        theme: theme,
      ),
    );
  }

  @override
  State<SaveTemplateDialog> createState() => _SaveTemplateDialogState();
}

class _SaveTemplateDialogState extends State<SaveTemplateDialog> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.defaultName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showValidationError('Пожалуйста, введите название шаблона');
      return;
    }

    Navigator.of(context).pop(name);
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Сохранить адрес',
        style: widget.theme.textTheme.titleLarge?.copyWith(
          color: widget.theme.colorScheme.onSurface,
        ),
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Название шаблона',
            hintText: 'Например: Дом, Офис',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: widget.theme.colorScheme.surface,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Пожалуйста, введите название';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Отмена',
            style: TextStyle(
              color: widget.theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Сохранить',
            style: TextStyle(
              color: widget.theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
