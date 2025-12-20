import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class PaymentsPage extends StatefulWidget {
  final String? orderNumber;
  final String? amount;
  const PaymentsPage({
    super.key,
    this.orderNumber,
    this.amount,
  });

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getUser();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оплата'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            UserProfileModel? currentUser;
            if (state is ProfileGetLoaded) {
              currentUser = state.userModel;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Выберите способ оплаты',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                PaymentMethodTileWidget(
                  icon: SvgPicture.asset('assets/icons/mbank.svg', height: 28),
                  title: 'Mbank',
                  onTap: () => context.router.push(MbankInitiateRoute(
                    amount: widget.amount ?? '0',
                    orderNumber: widget.orderNumber ?? '0',
                    provider: 'Mbank',
                    phone: currentUser?.phone ?? '996',
                  )),
                ),
                PaymentMethodTileWidget(
                  icon: SvgPicture.asset('assets/icons/mega.svg', height: 28),
                  title: 'MegaPay',
                  onTap: () => context.router.push(MegaCheckUserRoute(
                    amount: widget.amount ?? '0',
                    orderNumber: widget.orderNumber ?? '0',
                    provider: 'MegaPay',
                    phone: currentUser?.phone ?? '996',
                  )),
                ),
                PaymentMethodTileWidget(
                  icon: SvgPicture.asset(
                    'assets/icons/qr_code.svg',
                    height: 28,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                  title: 'Оплата через QR',
                  onTap: () => context.router.push(QrCodeRoute(
                    initialAmount: int.parse(widget.amount ?? '0'),
                    orderNumber: widget.orderNumber ?? '0',
                  )),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
