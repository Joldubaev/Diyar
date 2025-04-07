import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class OnlainPaymentPage extends StatefulWidget {
  final String paymentUrl;
  const OnlainPaymentPage({super.key, required this.paymentUrl});

  @override
  State<OnlainPaymentPage> createState() => _OnlainPaymentPageState();
}

class _OnlainPaymentPageState extends State<OnlainPaymentPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Оплата"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.replaceRoute(MainRoute());
          },
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
