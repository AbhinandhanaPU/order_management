import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:order_management/bindings/app_bindings.dart';
import 'package:order_management/models/order_draft_model.dart';
import 'package:order_management/models/order_item_model.dart';
import 'package:order_management/models/order_model.dart';
import 'package:order_management/models/product_model.dart';
import 'package:order_management/services/firebase_messaging_service.dart';
import 'package:order_management/view/bottom_nav_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(); // initializing firebase

  await MyFirebaseMessagingService.initialize();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Hive.initFlutter(); // initializing hive

  // Register all adapters
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(OrderItemAdapter());
  Hive.registerAdapter(OrderAdapter());
  Hive.registerAdapter(OrderDraftAdapter());

  // Open Multiple Hive Boxes
  await Hive.openBox<Order>('placeOrder'); // Stores placed orders
  await Hive.openBox<OrderDraft>('orderDrafts'); // Stores draft orders

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
