import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

showMapSearchBottom(
  BuildContext context, {
  required Function(String) onSearch,
}) {
  List<SuggestItem> suggests = [];

  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) {
      final theme = Theme.of(context);
      return StatefulBuilder(builder: (context, setState) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.6,
          expand: false,
          maxChildSize: 0.8,
          builder: (context, scrollController) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomInputWidget(
                          filledColor: theme.colorScheme.surface,
                          hintText: context.l10n.pleaseEnterAddress,
                          leading: const Icon(Icons.search),
                          onChanged: (p0) {
                            EasyDebounce.debounce(
                              'search',
                              const Duration(milliseconds: 500),
                              () async {
                                await YandexSuggest.getSuggestions(
                                  text: p0,
                                  boundingBox: const BoundingBox(
                                    northEast: Point(latitude: 42.8764, longitude: 74.6072),
                                    southWest: Point(latitude: 42.7919, longitude: 74.4317),
                                  ),
                                  suggestOptions: const SuggestOptions(
                                    suggestType: SuggestType.transit,
                                  ),
                                ).then((value) {
                                  final result = value.$2;
                                  final suggestSession = value.$1;

                                  result.then((value) {
                                    log('Search result: ${value.items?.length}');
                                    if (value.items == null) return;
                                    log(suggestSession.id.toString());
                                    setState(() {
                                      suggests = value.items!;
                                    });
                                  });
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        child: ColoredBox(
                          color: theme.colorScheme.primary,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            color: theme.colorScheme.onPrimary,
                            onPressed: () => context.maybePop(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                suggests.isEmpty
                    ? const Expanded(
                        child: Center(child: Text('Начните вводить адрес')),
                      )
                    : Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              onSearch(suggests[index].displayText);
                              context.maybePop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(suggests[index].displayText),
                            ),
                          ),
                          // physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => Divider(
                            color: theme.colorScheme.onSurface,
                          ),
                          itemCount: suggests.length,
                        ),
                      ),
              ],
            ),
          ),
        );
      });
    },
  );
}
