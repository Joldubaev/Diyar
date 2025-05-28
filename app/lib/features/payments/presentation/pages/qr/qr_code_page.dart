import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/payments/payments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class QrCodePage extends StatefulWidget {
  final int initialAmount;
  final String orderNumber;

  const QrCodePage({
    super.key,
    required this.initialAmount,
    required this.orderNumber,
  });

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  late final TextEditingController _amountController;
  final QrService _qrService = QrService();
  Uint8List? _lastQrBytes;
  int _lastRequestedAmount = 0;
  QrCodeEntity? _lastQrEntity;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.initialAmount.toStringAsFixed(0));
    _lastRequestedAmount = widget.initialAmount;
    _amountController.addListener(_onAmountChanged);

    // Проверяем существующий QR-код
    final currentState = context.read<PaymentBloc>().state;
    if (currentState is PaymentQrCodeSuccess) {
      _updateQrCode(currentState.qrCode);
    } else {
      _sendQrRequest(widget.initialAmount);
    }
  }

  void _updateQrCode(QrCodeEntity qrCode) {
    _lastQrEntity = qrCode;
    final qrBytes = _qrService.decodeQr(qrCode.qrData ?? '');
    if (qrBytes != null) {
      _lastQrBytes = qrBytes;
    }
  }

  void _onAmountChanged() {
    final value = int.tryParse(_amountController.text);
    if (value != null && value > 0 && value != _lastRequestedAmount) {
      _sendQrRequest(value);
    }
  }

  void _sendQrRequest(int amount) {
    _lastRequestedAmount = amount;
    context.read<PaymentBloc>().add(GenerateQrCodeEvent(amount));
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final qrSize = size.width * 0.8;
    final buttonHeight = size.height * 0.065;
    final padding = size.width * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Оплата'),
        centerTitle: true,
        leading: BackButton(onPressed: () => context.router.maybePop()),
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, state) {
            if (state is PaymentQrCodeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PaymentQrCodeError) {
              return Center(
                child: Text(
                  'Невозможно сгенерировать QR-код',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
              );
            }

            if (state is PaymentQrCodeSuccess) {
              _updateQrCode(state.qrCode);
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.02),
                  Text(
                    'Подтвердите оплату',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.06,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    'Оплата производится по технологии ElQR',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: size.width * 0.04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.03),
                  if (_lastQrBytes != null)
                    Container(
                      height: qrSize,
                      width: qrSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(qrSize * 0.09),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(qrSize * 0.08),
                      child: Image.memory(
                        _lastQrBytes!,
                        width: qrSize,
                        height: qrSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  SizedBox(height: size.height * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: theme.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: theme.primaryColor.withValues(alpha: 0.2)),
                          ),
                        ),
                        icon: const Icon(Icons.share),
                        label: Text('Поделиться', style: TextStyle(fontSize: size.width * 0.04)),
                        onPressed: _lastQrBytes == null ? null : () => _qrService.sharePng(_lastQrBytes!),
                      ),
                      SizedBox(width: size.width * 0.04),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: theme.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: theme.primaryColor.withValues(alpha: 0.2)),
                          ),
                        ),
                        icon: const Icon(Icons.download),
                        label: Text('Скачать', style: TextStyle(fontSize: size.width * 0.04)),
                        onPressed: _lastQrBytes == null
                            ? null
                            : () async {
                                final path = await _qrService.savePdfToDownloads(_lastQrBytes!);
                                if (path != null && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Сохранено: $path')),
                                  );
                                }
                              },
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Сумма к оплате',
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: size.width * 0.042),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: CustomInputWidget(
                      isReadOnly: true,
                      hintText: 'Введите сумму',
                      controller: _amountController,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: SubmitButtonWidget(
                      bgColor: theme.primaryColor,
                      onTap: () {
                        if (_lastQrEntity == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('QR-код еще не сгенерирован!')),
                          );
                          return;
                        }
                        context.router.push(
                          QrCheckStatusRoute(
                            transactionId: _lastQrEntity!.transactionId ?? '',
                            orderNumber: widget.orderNumber,
                            amount: double.tryParse(_amountController.text) ?? 0,
                          ),
                        );
                      },
                      title: 'Подтвердить',
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
