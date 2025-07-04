import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String htmlForm;
  const PaymentWebView({super.key, required this.htmlForm});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (_) => setState(() => _isLoading = true),
              onPageFinished: (url) {
                setState(() => _isLoading = false);
                _handleUrlNavigation(url);
              },
              onNavigationRequest: (request) {
                _handleUrlNavigation(request.url);
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(
            Uri.dataFromString(
              widget.htmlForm,
              mimeType: 'text/html',
              encoding: Encoding.getByName('utf-8'),
            ),
          );
  }

  void _handleUrlNavigation(String url) {
    if (url.contains('success.payfast.local') ||
        url.contains('payment-success')) {
      Navigator.pushReplacementNamed(context, '/success');
    } else if (url.contains('failure.payfast.local') ||
        url.contains('payment-failure') ||
        url.contains('error')) {
      Navigator.pushReplacementNamed(context, '/failure');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PayFast Checkout"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Loading PayFast...', style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
