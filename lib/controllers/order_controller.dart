import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:order_management/controllers/cart_controller.dart';
import 'package:order_management/models/order_draft_model.dart';
import 'package:order_management/models/order_item_model.dart';
import 'package:order_management/models/order_model.dart';

class OrderController extends GetxController {
  // Hive Box for saving drafts
  final _orderDraftBox = Hive.box<OrderDraft>('orderDrafts');

  final CartController cartController = Get.find<CartController>();

  // orderHistory into an observable list
  var orderHistory = <OrderDraft>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders(); // Load existing orders when the app starts
  }

  // Load orders from Hive
  void loadOrders() {
    orderHistory.assignAll(_orderDraftBox.values.toList());
  }

  // Place Order or Save as Draft
  Future<void> placeOrder() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool isOnline = connectivityResult != ConnectivityResult.none;
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

    // Storing Orders in Hive
    OrderDraft draft = OrderDraft(order: newOrder, createdAt: DateTime.now());
    _orderDraftBox.put(orderKey, draft);

    loadOrders(); // Refresh order list after saving

    if (isOnline) {
      Get.snackbar(
        "Order Placed",
        "Your order has been successfully placed!",
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Offline Mode",
        "No internet. Order saved as 'Draft' locally.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }

    cartController.clearCart(); // Clear cart after order is placed

    updateOrderStatus(
        orderKey); //Start updating order status after order is placed
  }

  Future<void> updateOrderStatus(String orderKey) async {
    final OrderDraft? orderDraft = _orderDraftBox.get(orderKey);

    if (orderDraft == null) {
      log("Order not found!");
      return;
    }

    List<String> statusSequence = [
      "Pending",
      "Approved",
      "Shipped",
      "Delivered"
    ];

    for (String status in statusSequence) {
      await Future.delayed(Duration(seconds: 5));

      orderDraft.order.orderStatus = status;
      await _orderDraftBox.put(orderKey, orderDraft); // Update Hive storage

      loadOrders(); // Refresh order list

      log("Order #$orderKey updated to: $status");

      Get.snackbar(
        "Order Update",
        "Your order is now: $status",
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    }
  }
}
