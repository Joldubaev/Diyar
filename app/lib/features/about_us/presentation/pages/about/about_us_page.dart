import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => context.router.maybePop(),
        ),
        title: Text(
          context.l10n.aboutUs,
          style: theme.textTheme.titleSmall!.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: const SafeArea(child: _AboutUsBody()),
    );
  }
}

class _AboutUsBody extends StatelessWidget {
  const _AboutUsBody();

  @override
  Widget build(BuildContext context) {
    final types = AboutUsType.values;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: types.length,
      itemBuilder: (context, index) {
        final type = types[index];
        return HallCardWidget(
          hallName: type.getUIName(context),
          imagePath: type.getAsset,
          title: type.getTitle(context),
          onPressed: () {
            switch (type) {
              case AboutUsType.cafe:
                context.router.push(const CofeRoute());
              case AboutUsType.hall:
                context.router.push(const HallRoute());
              case AboutUsType.restoran:
                context.router.push(const RestorantRoute());
              case AboutUsType.vip:
                context.router.push(const VipRoute());
              case AboutUsType.terasa:
                context.router.push(const TerasaRoute());
            }
          },
        );
      },
    );
  }
}
