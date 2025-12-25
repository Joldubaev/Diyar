import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

Future<void> showDistrictSearchBottom(
  BuildContext context, {
  required Function(DistrictDataModel) onDistrictSelected,
  required Future<List<DistrictDataModel>> Function(String) onSearch,
}) async {
  List<DistrictDataModel> districts = [];

  await showModalBottomSheet<void>(
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

      return StatefulBuilder(
        builder: (context, setState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.6,
            expand: false,
            maxChildSize: 0.8,
            builder: (context, scrollController) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: const InputDecoration(
                        hintText: 'Введите название района',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search),
                        fillColor: AppColors.grey1,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        constraints: BoxConstraints(maxHeight: 40)),
                    onChanged: (query) {
                      EasyDebounce.debounce(
                        'district-search-debounce',
                        const Duration(milliseconds: 500),
                        () async {
                          final results = await onSearch(query.trim());
                          setState(() {
                            districts = results;
                          });
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  child: districts.isEmpty
                      ? const Center(
                          child: Text('Начните вводить название района'),
                        )
                      : ListView.separated(
                          controller: scrollController,
                          itemBuilder: (context, index) {
                            final district = districts[index];
                            return ListTile(
                              title: Text(
                                '${district.name} (${district.price} сом)',
                                style: theme.textTheme.bodyLarge,
                              ),
                              onTap: () {
                                onDistrictSelected(district);
                                Navigator.pop(context);
                              },
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            color: theme.colorScheme.onSurface,
                          ),
                          itemCount: districts.length,
                        ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
