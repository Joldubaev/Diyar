import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/core/utils/helper/user_helper.dart';
import 'package:diyar/features/cart/data/models/cart_item_model.dart';
import 'package:diyar/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItemContentWidget extends StatefulWidget {
  final VoidCallback? onTap;
  final bool? isCounter;
  final bool? isShadowVisible;
  final int quantity;
  final FoodModel food;

  const ProductItemContentWidget({
    super.key,
    this.onTap,
    this.isShadowVisible = true,
    required this.food,
    required this.quantity,
    this.isCounter = true,
  });

  @override
  State<ProductItemContentWidget> createState() =>
      _ProductItemContentWidgetState();
}

class _ProductItemContentWidgetState extends State<ProductItemContentWidget> {
  final _controller = TextEditingController();
  bool isChangedCounter = false;

  @override
  void initState() {
    _controller.text = widget.quantity.toString();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProductItemContentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _controller.text = widget.quantity.toString();
      isChangedCounter = true;
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() {
            isChangedCounter = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: widget.isShadowVisible!
            ? [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 0),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.onSurface.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      fadeInCurve: Curves.easeIn,
                      fadeOutCurve: Curves.easeOut,
                      imageUrl: widget.food.urlPhoto ?? '',
                      errorWidget: (context, url, error) => Image.asset(
                          'assets/images/app_logo.png',
                          color: theme.colorScheme.onSurface.withOpacity(0.1)),
                      width: double.infinity,
                      height: 110,
                      // memCacheWidth:
                      //     (MediaQuery.of(context).size.width * 0.5).toInt(),
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      fit: BoxFit.contain,
                    ),
                    if (isChangedCounter)
                      Positioned(
                        right: 0,
                        top: 0,
                        left: 0,
                        bottom: 0,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              alwaysIncludeSemantics: true,
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: DecoratedBox(
                            key: ValueKey<int>(widget.quantity),
                            decoration: BoxDecoration(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                              child: Text(
                                '${widget.quantity}',
                                key: ValueKey<int>(widget.quantity),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: theme.colorScheme.surface,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 60,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '${widget.food.name}',
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text.rich(
              TextSpan(
                text: '${widget.food.weight}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                children: [
                  TextSpan(
                    text: ' - ${widget.food.price} сом',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.green,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),
          if (widget.isCounter == true)
            Container(
              width: double.infinity,
              height: 35,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: widget.isShadowVisible!
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                children: [
                  IconButton(
                    splashRadius: 20,
                    iconSize: 20,
                    onPressed: () {
                      if (widget.quantity > 1) {
                        if (UserHelper.isAuth()) {
                          context
                              .read<CartCubit>()
                              .decrementCart(widget.food.id!);
                        } else {
                          context.pushRoute(const SignInRoute()).then((value) {
                            if (context.mounted) {
                              context.read<SignInCubit>().logout();
                            }
                          });
                        }
                      } else {
                        if (UserHelper.isAuth()) {
                          context
                              .read<CartCubit>()
                              .removeFromCart(widget.food.id!);
                        } else {
                          context.pushRoute(const SignInRoute()).then((value) {
                            if (context.mounted) {
                              context.read<SignInCubit>().logout();
                            }
                          });
                        }
                      }
                    },
                    icon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.remove),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: _controller,
                        textAlign: TextAlign.center,
                        showCursor: false,
                        cursorColor: AppColors.transparent,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isCollapsed: true,
                        ),
                        keyboardType: TextInputType.number,
                        selectionHeightStyle: BoxHeightStyle.max,
                        onChanged: (val) {
                          int valInt = int.parse(val.isEmpty ? '0' : val);
                          _controller.text = valInt.toString();
                          if (valInt > 0) {
                            if (UserHelper.isAuth()) {
                              context.read<CartCubit>().setCartItemCount(
                                    CartItemModel(
                                      food: widget.food,
                                      quantity: int.parse(val),
                                    ),
                                  );
                            } else {
                              context
                                  .pushRoute(const SignInRoute())
                                  .then((value) {
                                if (context.mounted) {
                                  context.read<SignInCubit>().logout();
                                }
                              });
                            }
                          } else {
                            if (UserHelper.isAuth()) {
                              context
                                  .read<CartCubit>()
                                  .removeFromCart(widget.food.id!);
                            } else {
                              context
                                  .pushRoute(const SignInRoute())
                                  .then((value) {
                                if (context.mounted) {
                                  context.read<SignInCubit>().logout();
                                }
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    splashRadius: 20,
                    iconSize: 20,
                    onPressed: () {
                      if (widget.quantity == 0) {
                        if (UserHelper.isAuth()) {
                          context.read<CartCubit>().addToCart(
                                CartItemModel(food: widget.food, quantity: 1),
                              );
                        } else {
                          context.pushRoute(const SignInRoute()).then((value) {
                            if (context.mounted) {
                              context.read<SignInCubit>().logout();
                            }
                          });
                        }
                      } else {
                        if (UserHelper.isAuth()) {
                          context
                              .read<CartCubit>()
                              .incrementCart(widget.food.id!);
                        } else {
                          context.pushRoute(const SignInRoute()).then((value) {
                            if (context.mounted) {
                              context.read<SignInCubit>().logout();
                            }
                          });
                        }
                      }
                    },
                    icon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
