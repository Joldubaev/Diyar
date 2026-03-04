import 'package:diyar/features/web_payment/presentation/constants/web_payment_strings.dart';
import 'package:diyar/features/web_payment/presentation/cubit/open_banking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebPaymentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WebPaymentAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OpenBankingCubit, OpenBankingState, bool>(
      selector: (state) => state is OpenBankingReady,
      builder: (context, showIPayedButton) {
        return AppBar(
          title: const Text(WebPaymentStrings.appBarTitle),
        );
      },
    );
  }
}
