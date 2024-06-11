import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';

class HallCardWidget extends StatelessWidget {
  const HallCardWidget({
    required this.imagePath,
    required this.title,
    this.hallName = '',
    this.onPressed,
    super.key,
  });

  final String imagePath;
  final String title;
  final String hallName;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Stack(
        children: [
          Image.asset(imagePath, fit: BoxFit.cover),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hallName,
                    style: theme.textTheme.displayLarge!
                        .copyWith(color: Colors.white, fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          title,
                          maxLines: 3,
                          style: theme.textTheme.displayMedium!
                              .copyWith(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onPressed,
                          child: const FittedBox(
                            child: Text('Смотреть'),
                          ),
                        ),
                      ),
                    ],
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
