// import 'dart:convert'; // For base64 encoding
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class WebViewPage extends StatefulWidget {
//   final String url;

//   const WebViewPage({super.key, required this.url});

//   @override
//   State<WebViewPage> createState() => _WebViewPageState();
// }

// class _WebViewPageState extends State<WebViewPage> {
//   InAppWebViewController? webViewController;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Мои заявки'),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//       ),
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(
//           url: WebUri(widget.url),
//           method: 'POST', // Specify POST method
//           body: Uint8List.fromList(utf8.encode(jsonEncode({
//             "orderNumber": "898321wwww1228",
//             "amount": 500.00,
//             "currency": "KGS",
//             "payment_success_url": "https://example.com/success/898321246",
//             "payment_failure_url": "https://example.com/failure/898321246",
//             "callbackUrl": "https://example.com/callback/898321246"
//           }))),
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Basic ${base64Encode(utf8.encode('your_username:your_password'))}', // Basic auth header
//           },
//         ),
//         initialSettings: InAppWebViewSettings(
//           mediaPlaybackRequiresUserGesture: false,
//           clearCache: true,
//           allowsBackForwardNavigationGestures: false,
//           allowsInlineMediaPlayback: true,
//         ),
//         onWebViewCreated: (controller) {
//           webViewController = controller;
//         },
//       ),
//     );
//   }
// }

 // const SizedBox(height: 10),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).colorScheme.surface,
                //     borderRadius: const BorderRadius.all(Radius.circular(12)),
                //   ),
                //   child: SettingsTile(
                //     leading: SvgPicture.asset(
                //       'assets/icons/del.svg',
                //       height: 40,
                //     ),
                //     text: 'Предоставит согласия',
                //     onPressed: () {
                //       AppAlert.showConfirmDialog(
                //         context: context,
                //         title: 'Открыть',
                //         content: const Text(
                //             'Вы уверены что хотите предоставить согласия?'),
                //         cancelText: context.l10n.no,
                //         confirmText: context.l10n.yes,
                //         cancelPressed: () => Navigator.pop(context),
                //         confirmPressed: () {
                //           // Navigate to WebViewPage
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => const WebViewPage(
                //                 url:
                //                     'https://test.finipay.kg/api/v1.1.0/payForm/bank',
                //               ), // Navigate to INNInputPage
                //             ),
                //           ).then((value) {
                //             if (context.mounted) {
                //               Navigator.pop(context);
                //             }
                //           });
                //         },
                //       );
                //     },
                //     color: Theme.of(context).colorScheme.error,
                //   ),
                // ),