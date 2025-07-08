import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'services/payfast_service.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final double amount;
  final String email;
  final String mobile;
  final String? customerName;
  final String? description;

  const PaymentWebViewScreen({
    super.key,
    required this.amount,
    required this.email,
    required this.mobile,
    this.customerName,
    this.description,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  final PaymentService _paymentService = PaymentService();
  WebViewController? _controller;

  String? _paymentUrl;
  Map<String, dynamic>? _formData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startPayment();
  }

  Future<void> _startPayment() async {
    try {
      final data = await _paymentService.generatePaymentForm(
        amount: widget.amount,
        email: widget.email,
        mobile: widget.mobile,
        customerName: widget.customerName,
        description: widget.description,
      );

      setState(() {
        _paymentUrl = data['paymentUrl'];
        _formData = data['formData'];
      });

      _postFormToWebView();
    } catch (e) {
      print("Payment error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error starting payment: $e")));
      Navigator.pop(context, false);
    }
  }

  void _postFormToWebView() async {
    if (_paymentUrl == null || _formData == null) return;

    final htmlForm = '''
    <html>
    <body onload="document.forms[0].submit()">
      <form method="post" action="$_paymentUrl">
        ${_formData!.entries.map((e) => '<input type="hidden" name="${e.key}" value="${e.value}">').join()}
      </form>
      <div style="text-align: center; padding: 20px;">
        <h3>Redirecting to PayFast...</h3>
        <p>Please wait while we redirect you to the payment gateway.</p>
      </div>
    </body>
    </html>
    ''';

    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (_) => setState(() => _isLoading = true),
              onPageFinished: (_) => setState(() => _isLoading = false),
              onNavigationRequest: (request) {
                final url = request.url;
                if (url.contains("/payment/success")) {
                  Navigator.pop(context, true); // success
                  return NavigationDecision.prevent;
                } else if (url.contains("/payment/failure")) {
                  Navigator.pop(context, false); // failure
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadHtmlString(htmlForm);

    setState(() {
      _controller = controller;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Processing Payment"),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Setting up payment..."),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("PayFast Checkout"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller!.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller!),
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
