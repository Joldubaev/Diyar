import 'dart:developer' as developer;

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
    developer.log('[OpenBanking] Page build: orderNumber=$orderNumber, amount=$amount');
    return BlocProvider(
      create: (_) => sl<OpenBankingCubit>()..initialize(orderNumber: orderNumber, amount: amount),
      child: _WebPaymentView(orderNumber: orderNumber, amount: amount),
    );
  }
}

class _WebPaymentView extends StatelessWidget {
  final String orderNumber;
  final int amount;

  const _WebPaymentView({
    required this.orderNumber,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<OpenBankingCubit, OpenBankingState>(
      listener: (context, state) {
        if (state is OpenBankingPaymentConfirmed) {
          developer.log('[OpenBanking] PaymentConfirmed → navigate to MainHome');
          context.router.pushAndPopUntil(
            const MainHomeRoute(),
            predicate: (_) => false,
          );
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
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
                    Navigator.pop(context);
                    context.router.maybePop();
                  },
                  child: const Text(WebPaymentStrings.confirmExitConfirm),
                ),
              ],
            ),
          );
        },
        child: Scaffold(
          appBar: const WebPaymentAppBar(),
          body: BlocBuilder<OpenBankingCubit, OpenBankingState>(
            builder: (context, state) {
              developer.log('[OpenBanking] State: ${state.runtimeType}');
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
