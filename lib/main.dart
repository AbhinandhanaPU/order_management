import 'package:flutter/material.dart';
import 'package:order_management/view/product_listing/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Management',
      debugShowCheckedModeBanner: false,
      home: ProductListScreen(),
    );
  }
}
