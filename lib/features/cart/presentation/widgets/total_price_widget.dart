import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:diyar/features/cart/presentation/presentation.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalPriceWidget extends StatefulWidget {
  const TotalPriceWidget({
    super.key,
    required this.price,
    required this.sale,
    required this.totalPrice,
  });

  final int price;
  final int sale;
  final int totalPrice;

  @override
  State<TotalPriceWidget> createState() => _TotalPriceWidgetState();
}

class _TotalPriceWidgetState extends State<TotalPriceWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 0))],
      ),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          context.read<CartCubit>().changeTotalPrice(widget.totalPrice + (context.read<CartCubit>().dishCount * 15));

          return Column(
            children: [
              CustomTile(title: context.l10n.costOfMeal, trailing: '${widget.price} ${context.l10n.som}'),
              CustomTile(title: context.l10n.dishes, trailing: '15 ${context.l10n.som}'),
              CustomTile(title: context.l10n.sale, trailing: '${widget.sale} ${context.l10n.som}'),
              const Divider(color: Colors.grey),
              CustomTile(
                title: context.l10n.total,
                trailing: '${widget.totalPrice + (context.read<CartCubit>().dishCount * 15)}${context.l10n.som}',
              ),
              Text(context.l10n.totalToPay, style: theme.textTheme.bodySmall!.copyWith(color: AppColors.red)),
              const SizedBox(height: 10),
              const DishesWidget(),
            ],
          );
        },
      ),
    );
  }
}
