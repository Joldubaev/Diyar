import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<NewsEntity> news = [];

  @override
  void initState() {
    super.initState();
    context.read<HomeContentCubit>().getNews();
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
            context.pushRoute(MainRoute());
          },
        ),
        title: Text(
          context.l10n.news,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.white),
        ),
      ),
      body: BlocConsumer<HomeContentCubit, HomeContentState>(
        listener: (context, state) {
          if (state is HomeContentError) {
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
                      SvgPicture.asset('assets/icons/cuate.svg', width: 200, height: 200),
                      const SizedBox(height: 20),
                      Text(
                        context.l10n.noNews,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                    final currentNews = news[index];
                    return CardWidget(
                      title: currentNews.name ?? 'Новость',
                      description: currentNews.description ?? '',
                      image: currentNews.photoLink,
                    );
                  },
                );
        },
      ),
    );
  }
}
