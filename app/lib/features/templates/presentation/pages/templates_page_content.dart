import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/profile/profile.dart';
import 'package:diyar/features/templates/presentation/presentation.dart';
import 'package:diyar/features/templates/presentation/widgets/empty_template_widget.dart';
import 'package:diyar/features/templates/presentation/widgets/templates_bottom_buttons_section.dart';
import 'package:diyar/features/templates/presentation/widgets/templates_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Виджет с контентом страницы шаблонов
class TemplatesPageContent extends StatefulWidget {
  const TemplatesPageContent({super.key});

  @override
  State<TemplatesPageContent> createState() => _TemplatesPageContentState();
}

class _TemplatesPageContentState extends State<TemplatesPageContent> {
  late final TemplatesListCubit cubit;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    cubit = context.read<TemplatesListCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_initialized) {
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
              return const EmptyTemplateWidget();
            }

            return CustomScrollView(
              slivers: [
                TemplatesListView(
                  state: state,
                  cubit: cubit,
                ),
                // Кнопки внизу - оптимизированы через BlocSelector
                TemplatesBottomButtonsSection(state: state),
                // Добавляем отступ снизу для SafeArea
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
            );
          }

          if (state is TemplatesListFailure) {
            return const EmptyTemplateWidget();
          }

          return const LoadingWidget();
        },
      ),
    );
  }
}
