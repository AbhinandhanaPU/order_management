import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_management/bindings/app_bindings.dart';
import 'package:order_management/view/product_listing/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Order Management',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(), // Inject all controllers globally
      home: ProductListScreen(),
    );
  }
}
