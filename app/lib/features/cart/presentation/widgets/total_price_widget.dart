import '../../../../l10n/l10n.dart';
import '../../../../core/components/components.dart';
import '../presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalPriceWidget extends StatefulWidget {
  const TotalPriceWidget({
    super.key,
    required this.price,
    required this.sale,
    required this.totalPrice,
    required this.containerPrice,
  });

  final int price;
  final int sale;
  final int totalPrice;
  final int containerPrice;

  @override
  State<TotalPriceWidget> createState() => _TotalPriceWidgetState();
}

class _TotalPriceWidgetState extends State<TotalPriceWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
              blurRadius: 5,
              offset: const Offset(0, 0))
        ],
      ),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          context.read<CartCubit>().changeTotalPrice(
              widget.totalPrice + (context.read<CartCubit>().dishCount * 15));

          return Column(
            children: [
              CustomTile(
                  title: context.l10n.costOfMeal,
                  trailing: '${widget.price} ${context.l10n.som}'),
              CustomTile(
                  title: context.l10n.dishes,
                  trailing: '${widget.containerPrice} ${context.l10n.som}'),
              CustomTile(
                  title: context.l10n.sale, trailing: '${widget.sale} %'),
              Divider(
                  color:
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),),
              CustomTile(
                title: context.l10n.total,
                trailing: '${widget.totalPrice} ${context.l10n.som}',
              ),
              const SizedBox(height: 10),
              Text(context.l10n.totalToPay,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).colorScheme.error)),
              const SizedBox(height: 10),
              const DishesWidget(),
            ],
          );
        },
      ),
    );
  }
}
