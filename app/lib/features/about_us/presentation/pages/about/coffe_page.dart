import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/about_us/presentation/widgets/about_us_detail_body.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CofePage extends StatelessWidget {
  const CofePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          context.l10n.ecpessCoffee,
          style: theme.textTheme.titleMedium!.copyWith(color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: const AboutUsDetailBody(apiType: 'ЭКСПРЕСС КАФЕ'),
    );
  }
}
