import 'package:diyar/core/core.dart';
import 'package:diyar/features/menu/presentation/cubit/garnish_cubit.dart';
import 'package:diyar/features/menu/presentation/widgets/garnish/garnish_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Инлайн-блок выбора гарнира на странице блюда: показывает все доступные
/// гарниры вертикальным списком. Первый пункт — «Без гарнира».
///
/// Реагирует на [GarnishCubit.requestHighlight]: скроллит к себе и коротко
/// подсвечивает рамку, если пользователь попытался добавить блюдо без выбора.
class ProductDetailGarnishSection extends StatefulWidget {
  const ProductDetailGarnishSection({super.key});

  @override
  State<ProductDetailGarnishSection> createState() => _ProductDetailGarnishSectionState();
}

class _ProductDetailGarnishSectionState extends State<ProductDetailGarnishSection> {
  bool _highlighted = false;

  Future<void> _onHighlightRequested() async {
    if (!mounted) return;
    await Scrollable.ensureVisible(
      context,
      alignment: 0.1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    if (!mounted) return;
    setState(() => _highlighted = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _highlighted = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GarnishCubit, GarnishState>(
      listenWhen: (prev, curr) => prev.highlightNonce != curr.highlightNonce,
      listener: (context, _) => _onHighlightRequested(),
      builder: (context, state) {
        if (state.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        if (state.hasError || state.items.isEmpty) {
          return const SizedBox.shrink();
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _highlighted
                  ? context.colorScheme.primary
                  : context.colorScheme.outlineVariant.withValues(alpha: 0.0),
              width: 1.6,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.chooseGarnish,
                style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GarnishTile(
                        title: context.l10n.withoutGarnish,
                        selected: state.selectedIndex == 0,
                        onTap: () => context.read<GarnishCubit>().select(0),
                      ),
                      ...List.generate(state.items.length, (i) {
                        final garnish = state.items[i];
                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: GarnishTile(
                            title: garnish.name ?? '',
                            imageUrl: garnish.imageUrlForList,
                            trailing: garnish.price != null ? '${garnish.price} сом' : null,
                            selected: state.selectedIndex == i + 1,
                            onTap: () => context.read<GarnishCubit>().select(i + 1),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
