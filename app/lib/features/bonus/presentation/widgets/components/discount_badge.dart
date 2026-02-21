import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DiscountBadge extends StatelessWidget {
  final int discount;

  const DiscountBadge({
    super.key,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE4D4).withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/icons/tag.svg'),
          const SizedBox(width: 6),
          Text(
            'Кэшбэк $discount%',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
