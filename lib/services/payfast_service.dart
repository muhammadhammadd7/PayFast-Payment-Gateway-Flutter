import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class PaymentService {
  final String baseUrl = "https://payfast-backend-production.up.railway.app";

  Future<Map<String, dynamic>> generatePaymentForm({
    required double amount,
    required String email,
    required String mobile,
    String? customerName,
    String? description,
  }) async {
    final basketId = const Uuid().v4();

    final response = await http.post(
      Uri.parse("$baseUrl/generate-payment-form"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "basketId": basketId,
        "txnAmt": amount.toStringAsFixed(2),
        "customerEmail": email,
        "customerMobile": mobile,
        "customerName": customerName ?? "Test User",
        "txnDesc": description ?? "Test Payment",
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to generate payment form: ${response.body}");
    }
  }
}
