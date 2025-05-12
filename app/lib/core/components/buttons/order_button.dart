
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OrderButton extends StatelessWidget {
  const OrderButton({super.key, required this.text, required this.icon, required this.onPressed});

  final String text;
  final String icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          padding: EdgeInsets.zero,
          elevation: 3),
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(icon, height: 50),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[500]),
          ],
        ),
      ),
    );
  }
}
