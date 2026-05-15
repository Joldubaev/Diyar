import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/custom_dialog/register_dialog.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Точка входа для действий корзины с карточки товара: проверка сессии + события [CartBloc].
abstract final class ProductCartDispatch {
  static void increment(BuildContext context, FoodEntity food, int displayedQuantity) {
    if (!_ensureSignedIn(context)) return;
    context.read<CartBloc>().add(
          ProductCardIncrementRequested(
            food: food,
            displayedQuantity: displayedQuantity,
          ),
        );
  }

  static void decrement(BuildContext context, FoodEntity food, int displayedQuantity) {
    if (!_ensureSignedIn(context)) return;
    context.read<CartBloc>().add(
          ProductCardDecrementRequested(
            food: food,
            displayedQuantity: displayedQuantity,
          ),
        );
  }

  static void setCount(BuildContext context, FoodEntity food, int newQuantity) {
    if (!_ensureSignedIn(context)) return;
    context.read<CartBloc>().add(
          ProductCardCountCommitted(
            food: food,
            newQuantity: newQuantity,
          ),
        );
  }

  static bool _ensureSignedIn(BuildContext context) {
    if (UserHelper.isAuth()) return true;
    showDialog<void>(
      context: context,
      builder: (_) => RegistrationAlertDialog(
        onRegister: () {
          Navigator.of(context).pop();
          context.router.push(const SignInRoute());
        },
        onLogin: () => Navigator.of(context).pop(),
      ),
    );
    return false;
  }
}
