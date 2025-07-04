import 'package:flutter/material.dart';
import 'package:payfast_payment_gateway/failure_screen.dart';
import 'package:payfast_payment_gateway/success_screen.dart';
import 'package:payfast_payment_gateway/fruit_shop_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayFast Integration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const FruitShopScreen(),
        '/success': (context) => const SuccessScreen(),
        '/failure': (context) => const FailureScreen(),
      },
    );
  }
}
