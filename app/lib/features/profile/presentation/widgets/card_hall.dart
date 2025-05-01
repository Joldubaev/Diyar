
import 'package:diyar/core/theme/theme.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';

class HallCardWidget extends StatelessWidget {
  const HallCardWidget({
    required this.imagePath,
    required this.title,
    this.onPressed,
    super.key,
  });

  final String imagePath;
  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: Stack(
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.black1.withValues(alpha: 0.4),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(title,
                        maxLines: 3,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Colors.white, fontSize: 18)),
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: onPressed,
                        child: FittedBox(child: Text(context.l10n.look))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
