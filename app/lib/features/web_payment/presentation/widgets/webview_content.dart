import 'dart:developer' as developer;

import 'package:diyar/features/web_payment/domain/enum/payment_status_type.dart';
import 'package:diyar/features/web_payment/presentation/constants/web_payment_strings.dart';
import 'package:diyar/features/web_payment/presentation/cubit/open_banking_cubit.dart';
import 'package:diyar/features/web_payment/presentation/utils/intent_parser.dart';
import 'package:diyar/features/web_payment/presentation/utils/payment_bank_domains.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPaymentWebViewContent extends StatefulWidget {
  const WebPaymentWebViewContent({super.key, required this.url});

  final String url;

  @override
  State<WebPaymentWebViewContent> createState() => _WebPaymentWebViewContentState();
}

class _WebPaymentWebViewContentState extends State<WebPaymentWebViewContent> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    developer.log('[WebPayment] WebView initState: url=${widget.url}');
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // Прозрачный фон, снижение нагрузки на GPU
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel(
        'FlutterLinkOpener',
        onMessageReceived: (JavaScriptMessage message) {
          _handleExternalUrl(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            final url = request.url;
            developer.log('[WebPayment] Navigation: $url');

            if (url.startsWith(WebPaymentStrings.callbackSuccessPrefix)) {
              context.read<OpenBankingCubit>().onPaymentCallbackReceived(PaymentStatusType.success);
              return NavigationDecision.prevent;
            }
            if (url.startsWith(WebPaymentStrings.callbackErrorPrefix)) {
              context.read<OpenBankingCubit>().onPaymentCallbackReceived(PaymentStatusType.error);
              return NavigationDecision.prevent;
            }

            final uri = Uri.tryParse(url);
            if (uri != null) {
              final isIntent = url.startsWith('intent://');
              final isCustomScheme = uri.scheme != 'http' && uri.scheme != 'https';

              if (isIntent) {
                developer.log('[WebPayment] Intent URL detected, parsing...');
                final launched = await IntentParser.handleIntentUrl(url);
                developer.log('[WebPayment] Intent launch result: $launched');
                return launched ? NavigationDecision.prevent : NavigationDecision.navigate;
              }

              if (isCustomScheme) {
                try {
                  final canLaunch = await canLaunchUrl(uri);
                  developer.log('[WebPayment] Custom scheme $uri, canLaunch: $canLaunch');
                  if (canLaunch) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                    return NavigationDecision.prevent;
                  }
                } catch (e) {
                  developer.log('[WebPayment] Custom scheme error: $e');
                }
              }

              if (PaymentBankDomains.isKnown(uri.host)) {
                try {
                  developer.log('[WebPayment] Known bank domain ${uri.host}, opening externally');
                  final launched = await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                  developer.log('[WebPayment] Bank domain launch: $launched');
                  if (launched) return NavigationDecision.prevent;
                } catch (e) {
                  developer.log('[WebPayment] Bank domain error: $e');
                }
              }
            }

            return NavigationDecision.navigate;
          },
          onPageFinished: (url) async {
            if (mounted) setState(() => _isLoading = false);
            await _injectLinkInterceptor();
          },
          onWebResourceError: (error) {
            developer.log('[WebPayment] WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _injectLinkInterceptor() async {
    const script = r'''
      (function() {
        if (window._linkInterceptorInjected) return;
        window._linkInterceptorInjected = true;
        document.addEventListener('click', function(e) {
          var a = e.target && (e.target.closest ? e.target.closest('a') : e.target);
          if (!a || !a.href) return;
          var href = a.href;
          if (href.indexOf('intent://') === 0 || 
              (href.indexOf('http://') !== 0 && href.indexOf('https://') !== 0 && href.indexOf('://') > 0)) {
            e.preventDefault();
            e.stopPropagation();
            if (window.FlutterLinkOpener) {
              window.FlutterLinkOpener.postMessage(href);
            }
          }
        }, true);
      })();
    ''';
    try {
      await _controller.runJavaScript(script);
    } catch (e) {
      developer.log('[WebPayment] Inject interceptor error: $e');
    }
  }

  void _handleExternalUrl(String url) {
    developer.log('[WebPayment] LinkOpener received: $url');
    if (url.startsWith('intent://')) {
      IntentParser.handleIntentUrl(url).then((launched) {
        developer.log('[WebPayment] Intent from channel: $launched');
      });
    } else {
      final uri = Uri.tryParse(url);
      if (uri != null && uri.scheme != 'http' && uri.scheme != 'https' && uri.scheme.isNotEmpty) {
        launchUrl(uri, mode: LaunchMode.externalApplication).catchError((e) {
          developer.log('[WebPayment] LinkOpener launch error: $e');
          return false;
        });
      }
    }
  }

  @override
  void dispose() {
    developer.log('[WebPayment] WebView dispose → load about:blank');
    _controller.loadRequest(Uri.parse('about:blank')).ignore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
