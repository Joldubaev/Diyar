import 'package:diyar/features/web_payment/presentation/constants/web_payment_strings.dart';
import 'package:flutter/material.dart';

class WebPaymentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;

  const WebPaymentAppBar({super.key, required this.onBackPressed});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(WebPaymentStrings.appBarTitle),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: onBackPressed,
      ),
    );
  }
}
