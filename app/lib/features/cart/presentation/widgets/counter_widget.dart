
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterWidget extends StatelessWidget {
  final int counter;
  final String id;

  const CounterWidget({super.key, required this.counter, required this.id});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: Border.all(
              color: AppColors.grey.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (counter > 1) {
                    context.read<CartBloc>().add(DecrementItemQuantity(id));
                  } else if (counter == 1) {
                    context.read<CartBloc>().add(RemoveItemFromCart(id));
                  }
                },
              ),
              Text(counter.toString(), style: Theme.of(context).textTheme.bodyLarge),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => context.read<CartBloc>().add(IncrementItemQuantity(id)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
