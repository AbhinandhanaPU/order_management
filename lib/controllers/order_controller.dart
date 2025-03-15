import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:order_management/controllers/cart_controller.dart';
import 'package:order_management/models/order_draft_model.dart';
import 'package:order_management/models/order_item_model.dart';
import 'package:order_management/models/order_model.dart';
import 'package:order_management/services/firebase_messaging_service.dart';
import 'package:order_management/services/network_service.dart';

class OrderController extends GetxController {
  // Hive Box for saving drafts
  final Box<OrderDraft> draftBox = Hive.box<OrderDraft>('orderDrafts');
  // Stores Placed Orders
  final Box<Order> orderBox = Hive.box<Order>('placeOrder');

  final CartController cartController = Get.find<CartController>();

  // Separate Observables for Draft and Placed Orders
  var draftOrders = <OrderDraft>[].obs;
  var placedOrders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
    startAutoCheckForInternet(); // Start auto-check for internet
  }

  // Periodically check and update order status (only if online)
  void startAutoCheckForInternet() {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      bool isOnline = await checkInternetConnection();
      if (isOnline) {
        await checkAndHandleDraftOrders();
        await autoUpdateOrderStatus();
      } else {
        log("User is offline. Order status remains unchanged.");
      }
    });
  }

  // Function to update order status only if online
  Future<void> autoUpdateOrderStatus() async {
    List<String> orderKeys = orderBox.keys.cast<String>().toList();

    if (orderKeys.isEmpty) {
      log("No orders to update.");
      return;
    }

    for (String key in orderKeys) {
      Order? order = orderBox.get(key);

      // Debugging: Log order status before updating
      log("Checking Order #$key - Current Status: ${order?.orderStatus}");

      if (order == null || order.orderStatus.trim() == "Delivered") {
        log("Skipping Order #$key - Already Delivered");
        continue; // Skips "Delivered" orders correctly
      }

      String? nextStatus = getNextStatus(order.orderStatus);

      if (nextStatus != null) {
        // Create a NEW instance before updating
        Order updatedOrder = Order(
          items: List.from(order.items), // Clone list
          total: order.total,
          orderStatus: nextStatus, // Update order status
        );

        await orderBox.put(key, updatedOrder); // Store updated instance

        log("Order #$key updated to: $nextStatus");

        // Send FCM Notification when status is updated
        if (nextStatus == "Approved" || nextStatus == "Shipped") {
          MyFirebaseMessagingService.variableNotifier.value = nextStatus;
        }

        loadOrders();
      }
    }
  }

  // Function to get the next order status
  String? getNextStatus(String currentStatus) {
    Map<String, String> statusFlow = {
      "Pending": "Approved",
      "Approved": "Shipped",
      "Shipped": "Delivered",
    };

    return statusFlow[currentStatus];
  }

  // Load both Draft and Placed Orders from Hive
  void loadOrders() {
    draftOrders.assignAll(draftBox.values.toList());
    placedOrders.assignAll(orderBox.values.toList());
  }

  // Function to Place Order (Separate Draft & Placed Orders)
  Future<void> placeOrder() async {
    bool isOnline = await checkInternetConnection();
    log('isOnline $isOnline');

    if (cartController.cartItems.isEmpty) {
      Get.snackbar("Cart Empty", "Please add items before placing an order.");
      return;
    }

    // Create a new order
    Order newOrder = Order(
      items: cartController.cartItems.entries.map((entry) {
        return OrderItem(
          product: entry.key,
          quantity: entry.value,
        );
      }).toList(),
      total: cartController.totalPrice,
      orderStatus: isOnline ? "Pending" : "Draft",
    );
    String orderKey = DateTime.now().toString();

    if (isOnline) {
      // Save order in Placed Orders Box
      await orderBox.put(orderKey, newOrder);

      Get.snackbar(
        "Order Placed",
        "Your order has been successfully placed!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } else {
      // Save order in Draft Orders Box
      OrderDraft draft = OrderDraft(order: newOrder, createdAt: DateTime.now());
      await draftBox.put(orderKey, draft);

      Get.snackbar(
        "Offline Mode",
        "No internet. Order saved as 'Draft' locally.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }

    cartController.clearCart(); // Clear cart after order is placed
    loadOrders(); // Refresh order list
  }

  // Function to Ask the User About Placing Draft Orders
  Future<void> checkAndHandleDraftOrders() async {
    if (draftBox.isNotEmpty) {
      Get.dialog(
        AlertDialog(
          title: Text("Draft Orders Found"),
          content: Text(
              "You have pending draft orders. Do you want to place them now?"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // User declined, close dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                await placeDraftOrders(); // Move drafts to placed orders
              },
              child: Text("Yes, Place Orders"),
            ),
          ],
        ),
      );
    }
  }

  // Function to Move Draft Orders to Placed Orders
  Future<void> placeDraftOrders() async {
    List<String> draftKeys = draftBox.keys.cast<String>().toList();

    for (String key in draftKeys) {
      OrderDraft? draft = draftBox.get(key); // Get the correct draft using key

      if (draft != null) {
        // Create a NEW instance of the Order
        Order placedOrder = Order(
          items: List.from(draft.order.items), // Clone order items
          total: draft.order.total,
          orderStatus: "Pending",
        );

        await orderBox.put(key, placedOrder); // Store a NEW instance
        await draftBox.delete(key); // Remove from Drafts
      }
    }

    loadOrders(); // Refresh order lists

    Get.snackbar(
      "Draft Orders Placed",
      "Your draft orders have been successfully placed!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
