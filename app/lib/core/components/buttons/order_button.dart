import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OrderButton extends StatelessWidget {
  const OrderButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  final String text;
  final String icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          height: 90,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              // Круглая иконка
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    height: 32,
                    width: 32,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Текст
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Стрелка
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
