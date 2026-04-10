import 'package:diyar/common/components/text/row_text_widget.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePopularFoodSection extends StatelessWidget {
  const HomePopularFoodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeContentCubit, HomeContentState>(
      buildWhen: (prev, curr) => curr is HomeContentLoading || curr is HomeContentLoaded,
      builder: (context, state) {
        final isLoading = state is HomeContentLoading;
        final products = state is HomeContentLoaded ? state.popularProducts : <FoodEntity>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            RowTextWidget(text: context.l10n.popularFood, theme: context.theme),
            if (isLoading)
              const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
            if (!isLoading && products.isNotEmpty) PopularFoodSectionWidget(menu: products),
          ],
        );
      },
    );
  }
}
