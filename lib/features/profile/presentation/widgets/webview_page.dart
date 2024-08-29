import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class INNInputPage extends StatefulWidget {
  const INNInputPage({super.key});

  @override
  INNInputPageState createState() => INNInputPageState();
}

class INNInputPageState extends State<INNInputPage> {
  final _innController = TextEditingController();

  void _openWebView() {
    final inn = _innController.text.trim();
    if (inn.isNotEmpty) {
      final url = 'https://widget.mydatacoin.io?inn=$inn';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewPage(url: url),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пожалуйста, введите ИНН'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _innController,
              decoration: const InputDecoration(
                labelText: 'ИНН',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openWebView,
              child: const Text('Отправить'),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заявки'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(widget.url), // Ensure WebUri is used correctly
        ),
        initialSettings: InAppWebViewSettings(
          mediaPlaybackRequiresUserGesture: false,
          transparentBackground: true,
          clearCache: true,
          allowsBackForwardNavigationGestures: false,
          allowsInlineMediaPlayback: true,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
      ),
    );
  }
}
