import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

class MenuSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const MenuSearchBar({
    super.key,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: context.l10n.search,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search),
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          constraints: const BoxConstraints(maxHeight: 40),
        ),
        onChanged: onSearch,
      ),
    );
  }
}
