import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:diyar/shared/utils/fmt/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<CurierOrderModel> orders = [];

  @override
  void initState() {
    context.read<CurierCubit>().getCurierHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.orderHistory, style: theme.textTheme.titleSmall),
        actions: [
          IconButton(
            onPressed: () {
              AppAlert.showConfirmDialog(
                context: context,
                title: context.l10n.orderHistory,
                content: const Text('Вы уверены что хотите удалить все заказы?'),
                cancelText: context.l10n.no,
                confirmText: context.l10n.yes,
                cancelPressed: () => Navigator.pop(context),
                confirmPressed: () {},
              );
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: BlocConsumer<CurierCubit, CurierState>(
        listener: (context, state) {
          if (state is GetCurierHistoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ошибка при загрузке данных'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetCurierHistoryError) {
            return const Center(child: Text('Ошибка при загрузке данных'));
          } else if (state is GetCurierHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetCurierHistoryLoaded) {
            orders = state.curiers;
            if (state.curiers.isEmpty) {
              return const Center(child: Text('No orders'));
            }
          }
          return ListView.separated(
            padding: const EdgeInsets.all(10),
            separatorBuilder: (context, index) => const SizedBox(height: 5),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                color: AppColors.primary[50],
                child: ListTile(
                  title: Text(
                    '${context.l10n.orderNumber} ${order.orderNumber ?? ""}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${context.l10n.name}: ${order.userName ?? ""}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        'Адреc: ${order.address ?? ""}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        '${context.l10n.som}: ${order.price ?? ""}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
