import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';

/// Виджет-инициализатор для загрузки данных корзины
///
/// Выполняет загрузку акций и таймера один раз при монтировании
class CartInitializer extends StatefulWidget {
  final Widget child;

  const CartInitializer({
    super.key,
    required this.child,
  });

  @override
  State<CartInitializer> createState() => _CartInitializerState();
}

class _CartInitializerState extends State<CartInitializer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.maybeRead<HomeContentCubit>()?.getSales();
      context.maybeRead<SettingsCubit>()?.getTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
