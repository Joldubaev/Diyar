import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_storyboard/flutter_instagram_storyboard.dart';

@immutable
final class DiyarStoryItem {
  const DiyarStoryItem({
    required this.id,
    required this.cardImageLink,
    required this.cardLabel,
    required this.storyPagesImages,
    required this.storyPageDuration,
  });

  final String id;
  final String cardImageLink;
  final String cardLabel;
  final List<String> storyPagesImages;
  final List<Duration> storyPageDuration;
}

@immutable
class MqStoryItemsWidget extends StatefulWidget {
  const MqStoryItemsWidget({
    required this.items,
    this.listHeight = 115,
    this.buttonWidth = 100,
    this.buttonSpacing = 10,
    super.key,
  });

  final List<DiyarStoryItem> items;
  final double listHeight;
  final double buttonWidth;
  final double buttonSpacing;

  @override
  State<MqStoryItemsWidget> createState() => _MqStoryItemsWidgetState();
}

class _MqStoryItemsWidgetState extends State<MqStoryItemsWidget> {
  late final List<DiyarStoryItem> _items;
  late final StoryTimelineController _storyController;

  @override
  void initState() {
    _items = widget.items;
    _storyController = StoryTimelineController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return StoryListView(
      listHeight: widget.listHeight,
      buttonWidth: widget.buttonWidth,
      buttonSpacing: widget.buttonSpacing,
      paddingLeft: 4,
      pageTransform: const StoryPage3DTransform(),
      buttonDatas: _items
          .map(
            (e) => StoryButtonData(
              storyId: e.id,
              storyController: _storyController,
              timelineBackgroundColor: colorScheme.primary,
              buttonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(e.cardImageLink),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                // child: _CardLabelText(e.cardLabel),
              ),
              borderDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.primary),
              ),
              storyPages: e.storyPagesImages
                  .map(
                    (i) => StoryPageScaffold(
                      body: _StoryPageImageBody(
                        pageImageUrl: i,
                        previewImageUrl: e.cardImageLink,
                      ),
                    ),
                  )
                  .toList(),
              segmentDuration: e.storyPageDuration,
            ),
          )
          .toList(),
    );
  }
}

/// Пока грузится полноэкранный кадр — размытая обложка сторис и затемнение вместо пустого чёрного.
class _StoryPageImageBody extends StatelessWidget {
  const _StoryPageImageBody({
    required this.pageImageUrl,
    required this.previewImageUrl,
  });

  final String pageImageUrl;
  final String previewImageUrl;

  static const double _blurSigma = 14;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: ClipRect(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
              child: Transform.scale(
                scale: 1.08,
                child: CachedNetworkImage(
                  imageUrl: previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorWidget: (_, __, ___) =>
                      ColoredBox(color: theme.colorScheme.surface),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: ColoredBox(
            color: theme.colorScheme.scrim.withValues(alpha: 0.42),
          ),
        ),
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: pageImageUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => const SizedBox.shrink(),
            errorWidget: (_, __, ___) => Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                size: 48,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
