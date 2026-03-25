import 'package:diyar/features/web_payment/domain/enum/payment_status_type.dart';
import 'package:flutter/material.dart';

import 'status_banner.dart';
import 'webview_content.dart';

class WebPaymentContent extends StatelessWidget {
  const WebPaymentContent({
    super.key,
    required this.payLinkUrl,
    required this.signalRStatus,
  });

  final String payLinkUrl;
  final PaymentStatusType signalRStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WebPaymentStatusBanner(status: signalRStatus),
        Expanded(
          child: WebPaymentWebViewContent(url: payLinkUrl),
        ),
      ],
    );
  }
}
