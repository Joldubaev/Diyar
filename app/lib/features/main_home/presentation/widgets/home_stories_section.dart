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
            .where((e) => e.photoLink?.isNotEmpty ?? false)
            .toList()
            .asMap()
            .entries
            .map((e) => DiyarStoryItem(
                  id: e.value.id ?? e.key.toString(),
                  cardImageLink: e.value.photoLink!,
                  cardLabel: e.value.name ?? '',
                  storyPagesImages: [e.value.photoLink!],
                  storyPageDuration: const [Duration(seconds: 5)],
                ))
            .toList();

        return items.isEmpty ? const SizedBox.shrink() : MqStoryItemsWidget(items: items);
      },
    );
  }
}
