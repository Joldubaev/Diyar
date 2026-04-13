import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeStoriesSection extends StatelessWidget {
  const HomeStoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeContentCubit, HomeContentState>(
      buildWhen: (prev, curr) =>
          curr is HomeContentLoading || curr is HomeContentLoaded || curr is GetNewsLoaded || curr is GetNewsLoading,
      builder: (context, state) {
        if (state is HomeContentLoading || state is GetNewsLoading) {
          return const SizedBox(height: 115);
        }

        final news = state is HomeContentLoaded
            ? state.news
            : state is GetNewsLoaded
                ? state.news
                : <NewsEntity>[];
        if (news.isEmpty) return const SizedBox.shrink();

        final items = news
            .where((e) => (e.listImageUrl?.isNotEmpty ?? false))
            .toList()
            .asMap()
            .entries
            .map((e) {
              final n = e.value;
              final listImg = n.listImageUrl!;
              final mainImg =
                  (n.photoLink != null && n.photoLink!.isNotEmpty) ? n.photoLink! : listImg;
              return DiyarStoryItem(
                id: n.id ?? e.key.toString(),
                cardImageLink: listImg,
                cardLabel: n.name ?? '',
                storyPagesImages: [mainImg],
                storyPageDuration: const [Duration(seconds: 5)],
              );
            })
            .toList();

        return items.isEmpty ? const SizedBox.shrink() : MqStoryItemsWidget(items: items);
      },
    );
  }
}
