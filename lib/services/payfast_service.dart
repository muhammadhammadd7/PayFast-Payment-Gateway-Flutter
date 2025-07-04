import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PayFastService {
  /// Base URL of your backend API (deployed on Railway or elsewhere)
  static const String _baseUrl =
      "https://payfast-backend-production.up.railway.app";

  /// Gets an access token for initiating a PayFast payment session.
  static Future<String?> getAccessToken({
    required String basketId,
    required String amount,
  }) async {
    final url = Uri.parse("$_baseUrl/get-access-token");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"basketId": basketId, "txnAmt": amount},
      );

      if (response.statusCode == 200 &&
          response.body.contains("ACCESS_TOKEN")) {
        final token = response.body.split('"ACCESS_TOKEN":"')[1].split('"')[0];

        if (kDebugMode) {
          print("✅ Access Token Received: $token");
        }

        return token;
      } else {
        if (kDebugMode) {
          print("❌ Failed to get access token (HTTP ${response.statusCode})");
          print("Response Body: ${response.body}");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Exception while fetching token: $e");
      }
      return null;
    }
  }

  /// Wrapper method to initiate payment using customer/order details
  static Future<String?> initiatePayment({
    required double amount,
    required String orderId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    String description = "Order Payment",
  }) async {
    if (kDebugMode) {
      print("📦 Initiating payment for order: $orderId");
      print("💰 Amount: $amount");
      print(
        "👤 Customer: $customerName | 📧 $customerEmail | 📞 $customerPhone",
      );
    }

    return await getAccessToken(
      basketId: orderId,
      amount: amount.toInt().toString(), // PayFast accepts integer strings
    );
  }
}
