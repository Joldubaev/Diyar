import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/profile/profile.dart';
import 'package:diyar/features/templates/presentation/presentation.dart';
import 'package:diyar/features/templates/presentation/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class TemplatesPage extends StatelessWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои шаблоны'),
      ),
      body: _TemplatesPageContent(),
    );
  }
}

class _TemplatesPageContent extends StatefulWidget {
  const _TemplatesPageContent();

  @override
  State<_TemplatesPageContent> createState() => _TemplatesPageContentState();
}

class _TemplatesPageContentState extends State<_TemplatesPageContent> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_initialized) {
        final cubit = context.read<TemplatesListCubit>();
        if (cubit.state is TemplatesListInitial) {
          _initialized = true;
          cubit.onInit();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TemplatesListCubit, TemplatesListState>(
          listener: (context, state) {
            if (state is TemplatesListFailure) {
              SnackBarMessage().showErrorSnackBar(
                message: state.message,
                context: context,
              );
            } else if (state is TemplateDeleteSuccess) {
              SnackBarMessage().showSuccessSnackBar(
                message: 'Шаблон успешно удален',
                context: context,
              );
            } else if (state is TemplateDeleteFailure) {
              SnackBarMessage().showErrorSnackBar(
                message: state.message,
                context: context,
              );
            } else if (state is TemplatesNavigationToDeliveryReady) {
              // Получаем данные пользователя из ProfileCubit
              final profileCubit = context.read<ProfileCubit>();
              final user = profileCubit.user;

              context.router.push(
                DeliveryFormRoute(
                  cart: state.navigationData.cart,
                  totalPrice: state.navigationData.totalPrice,
                  dishCount: state.navigationData.dishCount,
                  deliveryPrice: state.navigationData.deliveryPrice,
                  address: state.navigationData.address,
                  initialUserName: user?.userName,
                  initialUserPhone: user?.phone,
                ),
              );
              // Сбрасываем состояние навигации после выполнения
              context.read<TemplatesListCubit>().resetNavigation();
            } else if (state is TemplatesNavigationToOrderMapReady) {
              context.router.push(
                OrderMapRoute(
                  cart: state.navigationData.cart,
                  totalPrice: state.navigationData.totalPrice,
                  dishCount: state.navigationData.dishCount,
                ),
              );
              // Сбрасываем состояние навигации после выполнения
              context.read<TemplatesListCubit>().resetNavigation();
            }
          },
        ),
      ],
      child: BlocBuilder<TemplatesListCubit, TemplatesListState>(
        builder: (context, state) {
          if (state is TemplatesListLoading) {
            return const LoadingWidget();
          }

          if (state is TemplatesListLoaded) {
            if (state.templates.isEmpty) {
              return EmptyTemplateWidget();
            }

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final template = state.templates[index];
                        return TemplateListItem(
                          template: template,
                          isSelected: state.selectedTemplateId == template.id,
                          onSelectedChanged: (selected) {
                            context.read<TemplatesListCubit>().selectTemplate(
                                  selected ? template.id : null,
                                );
                          },
                        );
                      },
                      childCount: state.templates.length,
                    ),
                  ),
                ),
                // Кнопки внизу - оптимизированы через BlocSelector
                _buildBottomButtonsSection(context, state),
                // Добавляем отступ снизу для SafeArea
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
            );
          }

          if (state is TemplatesListFailure) {
            return EmptyTemplateWidget();
          }

          return const LoadingWidget();
        },
      ),
    );
  }
}

/// Оптимизированная секция кнопок через BlocSelector
/// Перерисовывается только при изменении состояния корзины
Widget _buildBottomButtonsSection(
  BuildContext context,
  TemplatesListLoaded state,
) {
  return BlocSelector<CartBloc, CartState, CartLoaded?>(
    selector: (cartState) {
      if (cartState is CartLoaded && cartState.items.isNotEmpty) {
        return cartState;
      }
      return null;
    },
    builder: (context, cartLoaded) {
      if (cartLoaded == null) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }

      return SliverToBoxAdapter(
        child: _buildBottomButtons(context, state, cartLoaded),
      );
    },
  );
}

Widget _buildBottomButtons(
  BuildContext context,
  TemplatesListLoaded state,
  CartLoaded cartState,
) {
  final selectedTemplate = state.selectedTemplateId != null
      ? state.templates.firstWhereOrNull(
          (t) => t.id == state.selectedTemplateId,
        )
      : null;

  return TemplateBottomButtons(
    selectedTemplateId: state.selectedTemplateId,
    cartState: cartState,
    selectedTemplate: selectedTemplate,
    onApplyTemplate: () {
      context.read<TemplatesListCubit>().applySelectedTemplate(cartState);
    },
    onSkip: () {
      context.read<TemplatesListCubit>().skipToMap(cartState);
    },
  );
}
