import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_management/models/product_model.dart';

class CartController extends GetxController {
  var cartItems = <ProductModel, int>{}.obs; // Stores product & quantity

  // Adds a product to the cart
  void addToCart(ProductModel product) {
    cartItems[product] = 1;

    update();
    Get.snackbar(
      "Added to Cart",
      "${product.name} added!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Updates product quantity
  void updateQuantity(ProductModel product, int change) {
    if (!cartItems.containsKey(product)) return;

    int newQuantity = cartItems[product]! + change;
    if (newQuantity > product.stock) {
      Get.snackbar(
        "Stock Limit Reached",
        "Only ${product.stock} items available.",
      );
      return;
    }
    if (newQuantity > 0) {
      cartItems[product] = newQuantity;
    } else {
      cartItems.remove(product);
    }
    update();
  }

  // Removes a product completely from the cart
  void removeFromCart(ProductModel product) {
    cartItems.remove(product);
    update();
    Get.snackbar("Removed from Cart", "${product.name} removed!");
  }

  // Clears the entire cart
  void clearCart() {
    cartItems.clear();
    update();
  }

  // Gets the total price
  double get totalPrice {
    return cartItems.entries
        .fold(0, (sum, entry) => sum + (entry.key.price * entry.value));
  }

  // Gets quantity of a specific product
  int getProductQuantity(ProductModel product) {
    return cartItems[product] ?? 0;
  }

  // Gets the total number of items in the cart
  int get itemCount => cartItems.length;
}
