import 'package:flutter/material.dart';

/// Класс-хелпер для группировки контроллеров контакта
class ContactFormControllers {
  final TextEditingController userName;
  final TextEditingController phone;

  ContactFormControllers({
    TextEditingController? userName,
    TextEditingController? phone,
  })  : userName = userName ?? TextEditingController(),
        phone = phone ?? TextEditingController();

  void dispose() {
    userName.dispose();
    phone.dispose();
  }
}
