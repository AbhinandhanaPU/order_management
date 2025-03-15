import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:order_management/controllers/cart_controller.dart';
import 'package:order_management/models/order_draft_model.dart';
import 'package:order_management/models/order_item_model.dart';
import 'package:order_management/models/order_model.dart';
import 'package:order_management/services/network_service.dart';

class OrderController extends GetxController {
  // Hive Box for saving drafts
  final _orderDraftBox = Hive.box<OrderDraft>('orderDrafts');

  final CartController cartController = Get.find<CartController>();

  // orderHistory into an observable list
  var orderHistory = <OrderDraft>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
    startAutoUpdateStatus(); // Start auto-updating order status
  }

  // Periodically check and update order status (only if online)
  void startAutoUpdateStatus() {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      bool isOnline = await checkInternetConnection();
      if (isOnline) {
        await autoUpdateOrderStatus();
      } else {
        log("User is offline. Order status remains unchanged.");
      }
    });
  }

  // Function to update order status only if online
  Future<void> autoUpdateOrderStatus() async {
    List<OrderDraft> ordersToUpdate = _orderDraftBox.values
        .where((order) => order.order.orderStatus != "Delivered")
        .toList();

    if (ordersToUpdate.isEmpty) {
      log("No orders to update.");
      return;
    }

    for (OrderDraft orderDraft in ordersToUpdate) {
      String currentStatus = orderDraft.order.orderStatus;
      String? nextStatus = getNextStatus(currentStatus);

      if (nextStatus != null) {
        orderDraft.order.orderStatus = nextStatus;
        await _orderDraftBox.put(orderDraft.key, orderDraft);

        log("Order updated to: $nextStatus");

        Get.snackbar(
          "Order Update",
          "Your order is now: $nextStatus",
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );

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

  // Load orders from Hive
  void loadOrders() {
    orderHistory.assignAll(_orderDraftBox.values.toList());
  }

  // Place Order or Save as Draft
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
  }
}
