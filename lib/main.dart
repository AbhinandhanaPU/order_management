import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:order_management/bindings/app_bindings.dart';
import 'package:order_management/models/order_draft_model.dart';
import 'package:order_management/models/order_item_model.dart';
import 'package:order_management/models/order_model.dart';
import 'package:order_management/view/bottom_nav_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initializing hive
  await Hive.initFlutter();

  // Register all adapters
  Hive.registerAdapter(OrderItemAdapter());
  Hive.registerAdapter(OrderAdapter());
  Hive.registerAdapter(OrderDraftAdapter());

  // Open a Hive box for storing orders
  await Hive.openBox<OrderDraft>('orderDrafts');

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
      home: BottomNavScreen(),
    );
  }
}
