// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'services/payfast_service.dart';
import 'utils/html_form_generator.dart';
import 'payment_webview.dart';
import 'package:flutter/foundation.dart';

class FruitShopScreen extends StatefulWidget {
  const FruitShopScreen({super.key});

  @override
  State<FruitShopScreen> createState() => _FruitShopScreenState();
}

class _FruitShopScreenState extends State<FruitShopScreen> {
  final double _totalAmount = 499.0; // Amount in PKR
  bool _isLoading = false;

  void _handlePaymentFailure() {
    Fluttertoast.showToast(
      msg: "Payment Failed! Please try again.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> _startPayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final orderId = "FRUIT-${DateTime.now().millisecondsSinceEpoch}";

      if (kDebugMode) {
        print("🚀 Starting PayFast payment...");
        print("💰 Amount: $_totalAmount");
        print("🔢 Order ID: $orderId");
      }

      final token = await PayFastService.initiatePayment(
        amount: _totalAmount,
        orderId: orderId,
        customerName: "Customer",
        customerEmail: "customer@example.com",
        customerPhone: "03001234567",
        description: "Fresh Fruits Purchase",
      );

      if (token != null && token.isNotEmpty) {
        if (kDebugMode) {
          print("✅ Access token received: ${token.substring(0, 10)}...");
        }

        final html = generatePaymentForm(token);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PaymentWebView(htmlForm: html)),
        );
      } else {
        if (kDebugMode) {
          print("❌ Access token is null or empty");
        }
        _handlePaymentFailure();
      }
    } catch (e) {
      if (kDebugMode) {
        print("💥 Payment initiation error: $e");
      }
      _handlePaymentFailure();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Fruit Shop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Available Fruits:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildFruitItem('Apple', 'Rs. 99/kg'),
            _buildFruitItem('Banana', 'Rs. 60/dozen'),
            _buildFruitItem('Orange', 'Rs. 120/kg'),
            _buildFruitItem('Mango', 'Rs. 220/kg'),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Total Amount: Rs. ${_totalAmount.toString()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _startPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text(
                              'Proceed to Checkout',
                              style: TextStyle(fontSize: 18),
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFruitItem(String name, String price) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(Icons.shopping_basket, color: Colors.green[700]),
        title: Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: Text(
          price,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
