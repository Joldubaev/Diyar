import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyar/features/payments/presentation/bloc/payment_bloc.dart';
import 'package:diyar/features/payments/domain/entities/payments_entity.dart';

@RoutePage()
class MbankInitiatePage extends StatefulWidget {
  final String? orderNumber;
  final String? amount;
  final String? provider;
  const MbankInitiatePage({
    super.key,
    this.orderNumber,
    this.amount,
    this.provider,
  });

  @override
  State<MbankInitiatePage> createState() => _MbankInitiatePageState();
}

class _MbankInitiatePageState extends State<MbankInitiatePage> {
  final _phoneController = TextEditingController(text: '996703182859');
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = '1';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оплата'),
        centerTitle: true,
        leading: const BackButton(),
        elevation: 0,
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentMbankError) {
            showToast(state.message, isError: true);
          }
          if (state is PaymentMbankSuccess) {
            context.router.push(
              MbankConfirmRoute(
                phone: _phoneController.text,
                amount: double.tryParse(_amountController.text.trim()) ?? 0,
                orderNumber: widget.orderNumber,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is PaymentMbankLoading;
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Оплата через ${widget.provider}',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 32),
                CustomInputWidget(
                  title: 'Номер телефона',
                  hintText: '',
                  controller: _phoneController,
                  inputType: TextInputType.phone,
                  phoneFormatType: PhoneFormatType.withoutPlus,
                  onChanged: (value) {
                    if (value.length > 13) {
                      _phoneController.text = value.substring(0, 13);
                      _phoneController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _phoneController.text.length),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                CustomInputWidget(
                  // isReadOnly: true,
                  title: 'Сумма',
                  hintText: '',
                  controller: _amountController,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: SubmitButtonWidget(
                    bgColor: Theme.of(context).primaryColor,
                    onTap: isLoading
                        ? null
                        : () {
                            final phone = _phoneController.text.trim();
                            final amount = double.tryParse(_amountController.text.trim());
                            if (phone.isEmpty || amount == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Заполните все поля корректно!')),
                              );
                              return;
                            }
                            final entity = PaymentsEntity(
                              user: _phoneController.text,
                              amount: amount,
                              orderNumber: widget.orderNumber,
                            );
                            context.read<PaymentBloc>().add(InitiateMbankEvent(entity));
                          },
                    title: isLoading ? 'Проверка...' : 'Проверить',
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
