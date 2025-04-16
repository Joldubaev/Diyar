import 'package:cached_network_image/cached_network_image.dart';
import '../custom_dialog/custom_dialog.dart';
import '../../../features/menu/data/models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../router/routes.gr.dart';
import '../../utils/helper/user_helper.dart';
import '../../../features/cart/data/models/cart_item_model.dart';
import '../../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../theme/theme.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
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
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.food.urlPhoto ?? '',
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/app_logo.png'),
                      width: double.infinity,
                      height: 110,
                      // cacheManager: customCacheManager,
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
                          child: DecoratedBox(
                            key: ValueKey<int>(widget.quantity),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                              child: Text(
                                '${widget.quantity}',
                                key: ValueKey<int>(widget.quantity),
                                style: theme.textTheme.titleMedium?.copyWith(
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
              style: theme.textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text.rich(
              TextSpan(
                text: '${widget.food.weight}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                children: [
                  TextSpan(
                    text: ' - ${widget.food.price} сом',
                    style: theme.textTheme.bodyMedium?.copyWith(
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
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          _showRegisterDialog(context);
                        }
                      } else {
                        if (UserHelper.isAuth()) {
                          context
                              .read<CartCubit>()
                              .removeFromCart(widget.food.id!);
                        } else {
                          _showRegisterDialog(context);
                        }
                      }
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Expanded(
                    child: TextFormField(
                      cursorColor: AppColors.transparent,
                      textAlign: TextAlign.center,
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isCollapsed: true,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        int valInt = int.parse(val.isEmpty ? '0' : val);
                        if (valInt > 0) {
                          if (UserHelper.isAuth()) {
                            context.read<CartCubit>().setCartItemCount(
                                  CartItemModel(
                                    food: widget.food,
                                    quantity: valInt,
                                  ),
                                );
                          } else {
                            _showRegisterDialog(context);
                          }
                        } else {
                          if (UserHelper.isAuth()) {
                            context
                                .read<CartCubit>()
                                .removeFromCart(widget.food.id!);
                          } else {
                            _showRegisterDialog(context);
                          }
                        }
                      },
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
                          _showRegisterDialog(context);
                        }
                      } else {
                        if (UserHelper.isAuth()) {
                          context
                              .read<CartCubit>()
                              .incrementCart(widget.food.id!);
                        } else {
                          _showRegisterDialog(context);
                        }
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return RegistrationAlertDialog(
          onRegister: () {
            Navigator.of(context).pop();
            context.router.push(const SignInRoute());
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  final customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 1),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: 'customCache'),
      fileService: HttpFileService(),
    ),
  );
}
