import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/bonus/bonus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

@RoutePage()
class BonusTransactionsPage extends StatefulWidget {
  const BonusTransactionsPage({super.key});

  @override
  State<BonusTransactionsPage> createState() => _BonusTransactionsPageState();
}

class _BonusTransactionsPageState extends State<BonusTransactionsPage> {
  BonusTransactionResponseEntity? response;
  int currentPage = 1;
  final int pageSize = 50;

  @override
  void initState() {
    super.initState();
    context.read<BonusCubit>().getBonusTransactions(page: currentPage, pageSize: pageSize);
  }

  void _loadPage(int page) {
    setState(() {
      currentPage = page;
    });
    context.read<BonusCubit>().getBonusTransactions(page: page, pageSize: pageSize);
  }

  String _getTransactionTypeText(String type) {
    switch (type) {
      case 'Earned':
        return 'Начислено';
      case 'Spent':
        return 'Списано';
      case 'Adjusted':
        return 'Корректировка';
      default:
        return type;
    }
  }

  Color _getTransactionTypeColor(String type) {
    switch (type) {
      case 'Earned':
        return AppColors.green;
      case 'Spent':
        return AppColors.red;
      case 'Adjusted':
        return AppColors.orange;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.router.maybePop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
        ),
        title: Text('Бонусные транзакции', style: theme.textTheme.bodyLarge!.copyWith(color: AppColors.white)),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: BlocConsumer<BonusCubit, BonusState>(
        listener: (context, state) {
          if (state is BonusTransactionsLoaded) {
            setState(() {
              response = state.response;
            });
          } else if (state is BonusTransactionsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BonusTransactionsLoading && response == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = response?.transactions ?? [];
          final totalPages = response?.totalPages ?? 0;

          return Column(
            children: [
              Expanded(
                child: transactions.isEmpty
                    ? Center(
                        child: Text(
                          'Нет транзакций',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
                          final formattedDate = dateFormat.format(transaction.createdAt);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              transaction.userName,
                                              style: theme.textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              transaction.phone,
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _getTransactionTypeColor(transaction.type).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: _getTransactionTypeColor(transaction.type).withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Text(
                                          _getTransactionTypeText(transaction.type),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: _getTransactionTypeColor(transaction.type),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Сумма',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${transaction.amount > 0 ? '+' : ''}${transaction.amount.toStringAsFixed(2)} сом',
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              color: transaction.amount > 0 ? AppColors.green : AppColors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Баланс после',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${transaction.balanceAfter.toStringAsFixed(2)} сом',
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (transaction.description != null && transaction.description!.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      transaction.description!,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Text(
                                    formattedDate,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (totalPages > 1)
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: currentPage > 1 ? () => _loadPage(currentPage - 1) : null,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Text(
                        '$currentPage / $totalPages',
                        style: theme.textTheme.bodyMedium,
                      ),
                      IconButton(
                        onPressed: currentPage < totalPages ? () => _loadPage(currentPage + 1) : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
