import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart';
import 'package:diyar/features/web_payment/presentation/constants/web_payment_strings.dart';
import 'package:diyar/features/web_payment/presentation/cubit/open_banking_cubit.dart';
import 'package:diyar/features/web_payment/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class OpenBankingPaymentPage extends StatelessWidget {
  final String orderNumber;
  final int amount;

  const OpenBankingPaymentPage({
    super.key,
    required this.orderNumber,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OpenBankingCubit>()..initialize(orderNumber: orderNumber, amount: amount),
      child: _WebPaymentView(orderNumber: orderNumber, amount: amount),
    );
  }
}

class _WebPaymentView extends StatefulWidget {
  final String orderNumber;
  final int amount;

  const _WebPaymentView({required this.orderNumber, required this.amount});

  @override
  State<_WebPaymentView> createState() => _WebPaymentViewState();
}

class _WebPaymentViewState extends State<_WebPaymentView> {
  // Флаг разрешения pop после подтверждения выхода.
  // Без него context.router.maybePop() снова перехватывается PopScope → бесконечный диалог.
  bool _allowPop = false;

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(WebPaymentStrings.confirmExitTitle),
        content: const Text(WebPaymentStrings.confirmExitMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(WebPaymentStrings.confirmExitCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // закрываем диалог
              setState(() => _allowPop = true); // разрешаем pop
              context.router.maybePop(); // теперь PopScope пропустит
            },
            child: const Text(WebPaymentStrings.confirmExitConfirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OpenBankingCubit, OpenBankingState>(
      listener: (context, state) {
        if (state is OpenBankingPaymentConfirmed) {
          context.router.pushAndPopUntil(
            const MainHomeRoute(),
            predicate: (_) => false,
          );
        }
      },
      child: PopScope(
        canPop: _allowPop,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _showExitDialog();
        },
        child: Scaffold(
          appBar: WebPaymentAppBar(onBackPressed: _showExitDialog),
          body: BlocBuilder<OpenBankingCubit, OpenBankingState>(
            builder: (context, state) {
              return switch (state) {
                OpenBankingInitializing() => const WebPaymentLoadingView(),
                OpenBankingError(:final message) => WebPaymentErrorView(message: message),
                OpenBankingSuccess(:final amount) => WebPaymentSuccessView(amount: amount),
                OpenBankingReady(:final payLinkUrl, :final signalRStatus) => WebPaymentContent(
                    payLinkUrl: payLinkUrl,
                    signalRStatus: signalRStatus,
                  ),
                OpenBankingPaymentConfirmed() => const WebPaymentLoadingView(),
              };
            },
          ),
        ),
      ),
    );
  }
}
