import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_management/models/product_model.dart';

class CartController extends GetxController {
  var cartItems = <ProductModel, int>{}.obs; // Map to store product & quantity

  // Adds a product to the cart or increases quantity if it already exists
  void addToCart(ProductModel product) {
    if (cartItems.containsKey(product)) {
      cartItems[product] = cartItems[product]! + 1;
    } else {
      cartItems[product] = 1;
    }
    update();
    Get.snackbar(
      "Added to Cart",
      "${product.name} added!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void updateQuantity(ProductModel product, int change) {
    if (cartItems.containsKey(product)) {
      int currentQuantity = cartItems[product]!;
      int newQuantity = currentQuantity + change;

      // Check if new quantity is within stock limit
      if (newQuantity > product.stock) {
        Get.snackbar(
          "Stock Limit Reached",
          "Only ${product.stock} items available.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (newQuantity > 0) {
        cartItems[product] = newQuantity;
      } else {
        cartItems.remove(product);
      }
    } else if (change > 0 && change <= product.stock) {
      // Add product if not in cart, ensuring it doesn't exceed stock
      cartItems[product] = change;
    } else {
      Get.snackbar(
        "Stock Error",
        "Not enough stock available.",
      );
      return;
    }

    update();
  }

  // Removes a product completely from the cart
  void removeFromCart(ProductModel product) {
    cartItems.remove(product);
    update();
    Get.snackbar(
      "Removed from Cart",
      "${product.name} removed!",
    );
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
