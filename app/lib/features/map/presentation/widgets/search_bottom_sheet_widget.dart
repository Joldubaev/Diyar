import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Показывает bottom sheet для поиска адресов на карте
Future<void> showMapSearchBottom(
  BuildContext context, {
  required Function(String, double?, double?) onSearch,
}) async {
  const kyrgyzstanBounds = BoundingBox(
    northEast: Point(latitude: 43.0019, longitude: 80.2754),
    southWest: Point(latitude: 39.1921, longitude: 69.2638),
  );

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      final theme = Theme.of(context);
      return _MapSearchBottomSheet(
        theme: theme,
        kyrgyzstanBounds: kyrgyzstanBounds,
        onSearch: onSearch,
      );
    },
  );
}

class _MapSearchBottomSheet extends StatefulWidget {
  final ThemeData theme;
  final BoundingBox kyrgyzstanBounds;
  final Function(String, double?, double?) onSearch;

  const _MapSearchBottomSheet({
    required this.theme,
    required this.kyrgyzstanBounds,
    required this.onSearch,
  });

  @override
  State<_MapSearchBottomSheet> createState() => _MapSearchBottomSheetState();
}

class _MapSearchBottomSheetState extends State<_MapSearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<SuggestItem> _searchResults = [];
  bool _isLoading = false;
  SuggestSession? _activeSession;

  @override
  void dispose() {
    _searchController.dispose();
    _activeSession?.close();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      log('[SEARCH] Начало поиска: "$query"');

      // Улучшаем поисковый запрос: добавляем "Бишкек" если его нет
      final searchQuery = _enhanceSearchQuery(query.trim());
      log('[SEARCH] Итоговый запрос: "$searchQuery"');

      // Закрываем предыдущую сессию
      await _activeSession?.close();

      log('[SEARCH] Вызов YandexSuggest.getSuggestions');
      final suggestResponse = await YandexSuggest.getSuggestions(
        text: searchQuery,
        boundingBox: widget.kyrgyzstanBounds,
        suggestOptions: const SuggestOptions(
          suggestType: SuggestType.unspecified,
          suggestWords: true,
        ),
      );

      log('[SEARCH] Получен ответ от YandexSuggest, ожидание результата...');
      _activeSession = suggestResponse.$1;
      final result = await suggestResponse.$2;

      if (!mounted) {
        log('[SEARCH] Context не mounted, прерывание');
        return;
      }

      final allResults = result.items ?? [];
      log('[SEARCH] Найдено результатов: ${allResults.length}');
      for (int i = 0; i < allResults.length && i < 10; i++) {
        final item = allResults[i];
        log('[SEARCH] Результат ${i + 1}: title="${item.title}", subtitle="${item.subtitle ?? "нет"}"');
      }

      setState(() {
        _searchResults = allResults;
        _isLoading = false;
      });

      log('[SEARCH] Состояние обновлено, отображено ${allResults.length} результатов');
    } catch (e, stackTrace) {
      log('[SEARCH] Ошибка поиска: $e');
      log('[SEARCH] Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
      }
    }
  }

  String _enhanceSearchQuery(String query) {
    final lowerQuery = query.toLowerCase();
    if (!lowerQuery.contains('бишкек') &&
        !lowerQuery.contains('bishkek') &&
        !lowerQuery.contains('кыргызстан') &&
        !lowerQuery.contains('kyrgyzstan')) {
      return '$query Бишкек';
    }
    return query;
  }

  void _onSearchTextChanged(String text) {
    EasyDebounce.debounce(
      'map_search',
      const Duration(milliseconds: 500),
      () => _performSearch(text),
    );
  }

  void _onItemSelected(SuggestItem item) {
    log('[SELECT] Выбран адрес: title="${item.title}", subtitle="${item.subtitle ?? "нет"}"');
    widget.onSearch(item.title, null, null);
    log('[SELECT] Вызов onSearch с адресом: "${item.title}"');
    context.maybePop();
  }

  void _onClear() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: widget.theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Ручка для перетаскивания
            const DraggableBottomSheetHandle(),

            // Поисковая строка
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SearchBarWidget(
                controller: _searchController,
                isLoading: _isLoading,
                hintText: context.l10n.pleaseEnterAddress,
                onChanged: _onSearchTextChanged,
                onClear: _onClear,
              ),
            ),

            // Индикатор загрузки
            if (_isLoading && _searchResults.isEmpty)
              const LinearProgressIndicator(
                minHeight: 2,
                backgroundColor: Colors.transparent,
              ),

            // Результаты поиска
            Expanded(
              child: _searchResults.isEmpty && !_isLoading
                  ? const EmptySearchStateWidget(
                      title: 'Начните вводить адрес',
                      subtitle: 'Например: улица, дом, организация',
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _searchResults.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = _searchResults[index];
                        return SearchResultItemWidget(
                          title: item.title,
                          subtitle: item.subtitle,
                          onTap: () => _onItemSelected(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
