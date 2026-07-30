import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// in-app webview screen for portpos payment gateway
/// returns true via Get.back(result: true) when successUrl is hit,
/// returns false via Get.back(result: false) on failure/cancel/incomplete
class PaymentWebviewScreen extends StatefulWidget {
  // payment gateway url to load
  final String url;

  // url substring that signals a successful payment
  final String successUrl;

  // appbar title shown to the user
  final String screenTitle;

  const PaymentWebviewScreen({
    super.key,
    required this.url,
    required this.successUrl,
    required this.screenTitle,
  });

  @override
  State<PaymentWebviewScreen> createState() => _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends State<PaymentWebviewScreen> {
  // webview controller managing navigation and js
  late final WebViewController _controller;

  // tracks whether a result has already been dispatched to avoid double-pop
  bool _resultDispatched = false;

  @override
  void initState() {
    super.initState();

    // configure webview: js enabled + navigation delegate for url monitoring
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            debugPrint('PaymentWebviewScreen: page finished → $url');

            // guard: only dispatch result once
            if (_resultDispatched) return;

            if (url.contains(widget.successUrl)) {
              // payment succeeded — return true to caller
              _resultDispatched = true;
              Get.back(result: true);
            } else if (url.contains('fail') ||
                url.contains('incomplete') ||
                url.contains('cancel') ||
                url.contains('unfinished')) {
              // payment failed or cancelled — return false to caller
              _resultDispatched = true;
              Get.back(result: false);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(widget.screenTitle),
        // user should not manually close this to avoid ambiguous payment state
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
