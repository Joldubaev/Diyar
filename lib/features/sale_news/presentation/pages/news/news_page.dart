import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/sale_news/data/model/news_model.dart';
import 'package:diyar/features/sale_news/presentation/pages/widgets/custom_widget.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../cubit/home_features_cubit.dart';

@RoutePage()
class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<NewsModel> news = [];

  @override
  void initState() {
    super.initState();
    context.read<HomeFeaturesCubit>().getNews();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () {
            context.router.maybePop();
          },
        ),
        title: Text(
          context.l10n.news,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: AppColors.white),
        ),
      ),
      body: BlocConsumer<HomeFeaturesCubit, HomeFeaturesState>(
        listener: (context, state) {
          if (state is GetNewsError) {
            SnackBarMessage().showErrorSnackBar(
              message: state.message,
              context: context,
            );
          }
        },
        builder: (context, state) {
          if (state is GetNewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetNewsLoaded) {
            news = state.news;
          }
          return news.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/cuate.svg',
                          width: 200, height: 200),
                      const SizedBox(height: 20),
                      Text(
                        context.l10n.noNews,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                            ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                    return CardWidget(
                      title: news[index].name!,
                      description: news[index].description!,
                      image: news[index].photoLink!,
                    );
                  },
                );
        },
      ),
    );
  }
}
