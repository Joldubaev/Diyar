import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyTemplateWidget extends StatelessWidget {
  const EmptyTemplateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/cart.svg', width: 200, height: 200),
          const SizedBox(height: 16),
          Text(
            'Нет шаблонов',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Создайте свой первый шаблон',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }
}
