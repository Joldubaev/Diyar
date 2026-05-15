import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

typedef _AddressResult = ({String title, String? subtitle, double? lat, double? lon});

/// Весь сервисный регион — для searchByText, чтобы находить адреса
/// в любом месте зоны доставки (Бишкек, Кант, Новопокровка и т.д.).
const _fullZoneBounds = BoundingBox(
  northEast: Point(latitude: 42.957, longitude: 75.1),
  southWest: Point(latitude: 42.71, longitude: 74.285),
);

/// Показывает bottom sheet для поиска адресов на карте.
/// [mapCenter] — текущий центр камеры, используется для suggest-подсказок.
Future<void> showMapSearchBottom(
  BuildContext context, {
  required Point mapCenter,
  required Function(String, double?, double?) onSearch,
}) async {
  final suggestBounds = BoundingBox(
    northEast: Point(latitude: mapCenter.latitude + 0.15, longitude: mapCenter.longitude + 0.15),
    southWest: Point(latitude: mapCenter.latitude - 0.15, longitude: mapCenter.longitude - 0.15),
  );

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _MapSearchBottomSheet(
      theme: Theme.of(context),
      bounds: suggestBounds,
      onSearch: onSearch,
    ),
  );
}

class _MapSearchBottomSheet extends StatefulWidget {
  final ThemeData theme;
  final BoundingBox bounds;
  final Function(String, double?, double?) onSearch;

  const _MapSearchBottomSheet({
    required this.theme,
    required this.bounds,
    required this.onSearch,
  });

  @override
  State<_MapSearchBottomSheet> createState() => _MapSearchBottomSheetState();
}

class _MapSearchBottomSheetState extends State<_MapSearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<_AddressResult> _searchResults = [];
  bool _isLoading = false;
  SuggestSession? _activeSession;

  @override
  void dispose() {
    _searchController.dispose();
    _activeSession?.close();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    final text = query.trim();
    if (text.isEmpty) {
      setState(() { _searchResults = []; _isLoading = false; });
      return;
    }

    setState(() => _isLoading = true);
    log('[SEARCH] Начало поиска: "$text"');

    try {
      await _activeSession?.close();

      // Оба запроса стартуют одновременно (параллельно).
      final suggestFuture = YandexSuggest.getSuggestions(
        text: text,
        boundingBox: widget.bounds,
        suggestOptions: const SuggestOptions(
          suggestType: SuggestType.unspecified,
          suggestWords: true,
        ),
      );
      final textSearchFuture = YandexSearch.searchByText(
        searchText: text,
        searchOptions: const SearchOptions(),
        geometry: Geometry.fromBoundingBox(_fullZoneBounds),
      );

      final suggestPair = await suggestFuture;
      final textPair = await textSearchFuture;

      _activeSession = suggestPair.$1;
      final suggestResponse = await suggestPair.$2;
      final textResponse = await textPair.$2;

      if (!mounted) return;

      // --- Suggest results ---
      final suggestItems = suggestResponse.items ?? [];
      log('[SEARCH] Suggest: ${suggestItems.length} результатов');

      final results = <_AddressResult>[];
      final seenCoords = <(double, double)>{};

      for (final item in suggestItems) {
        final lat = item.center?.latitude;
        final lon = item.center?.longitude;
        if (lat != null && lon != null) {
          final inZone = await MapHelper.isPointInServiceZone(lat, lon);
          if (!inZone) continue;
          seenCoords.add((_round(lat), _round(lon)));
        }
        results.add((title: item.title, subtitle: item.subtitle, lat: lat, lon: lon));
      }

      // --- Text search results (строгий bbox — находит адреса в сёлах) ---
      final textItems = textResponse.items ?? [];
      log('[SEARCH] TextSearch: ${textItems.length} результатов');

      for (final item in textItems) {
        final point = item.geometry.firstOrNull?.point;
        final lat = point?.latitude;
        final lon = point?.longitude;

        if (lat != null && lon != null) {
          final inZone = await MapHelper.isPointInServiceZone(lat, lon);
          if (!inZone) continue;
          final key = (_round(lat), _round(lon));
          if (seenCoords.contains(key)) continue; // дубль из suggest
          seenCoords.add(key);
        }

        results.add((
          title: item.name,
          subtitle: null,
          lat: lat,
          lon: lon,
        ));
      }

      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
      log('[SEARCH] Итого показано: ${results.length}');
    } catch (e, st) {
      log('[SEARCH] Ошибка: $e\n$st');
      if (mounted) setState(() { _searchResults = []; _isLoading = false; });
    }
  }

  /// Округляет до ~100 м для дедупликации.
  double _round(double v) => (v * 1000).round() / 1000;

  void _onSearchTextChanged(String text) {
    EasyDebounce.debounce(
      'map_search',
      const Duration(milliseconds: 500),
      () => _performSearch(text),
    );
  }

  void _onItemSelected(_AddressResult item) {
    log('[SELECT] Выбран: "${item.title}", lat=${item.lat}, lon=${item.lon}');
    widget.onSearch(item.title, item.lat, item.lon);
    context.maybePop();
  }

  void _onClear() {
    _searchController.clear();
    setState(() { _searchResults = []; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        padding: EdgeInsets.only(bottom: bottomInset),
        decoration: BoxDecoration(
          color: widget.theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            const DraggableBottomSheetHandle(),
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
            if (_isLoading && _searchResults.isEmpty)
              const LinearProgressIndicator(
                minHeight: 2,
                backgroundColor: Colors.transparent,
              ),
            Expanded(
              child: _searchResults.isEmpty && !_isLoading
                  ? const EmptySearchStateWidget(
                      title: 'Начните вводить адрес',
                      subtitle: 'Например: улица, дом, организация\n\nАдрес не найден? Закройте поиск и перетащите карту на нужное место.',
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _searchResults.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, index) {
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
