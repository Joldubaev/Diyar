import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/about_us/presentation/widgets/about_us_detail_body.dart';
import 'package:diyar/features/about_us/presentation/widgets/about_us_type.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RestorantPage extends StatelessWidget {
  const RestorantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(context.l10n.restaurant, style: theme.textTheme.titleMedium!.copyWith(color: AppColors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: const AboutUsDetailBody(type: AboutUsType.restoran),
    );
  }
}
