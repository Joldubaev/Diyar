import 'package:flutter/material.dart';

class RegistrationAlertDialog extends StatelessWidget {
  final VoidCallback onRegister; // Функция для кнопки "Да"
  final VoidCallback onCancel; // Функция для кнопки "Нет"

  const RegistrationAlertDialog({
    super.key,
    required this.onRegister,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: Row(
        children: [
          Icon(Icons.person_add, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Text(
            "Регистрация",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Вы не авторизованы.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            "Для продолжения вам необходимо зарегистрироваться или войти в систему. Хотите зарегистрироваться сейчас?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          onPressed: onCancel, // Вызываем функцию отмены
          child: const Text("Нет"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          onPressed: onRegister, // Вызываем функцию регистрации
          child: const Text("Да"),
        ),
      ],
    );
  }
}
