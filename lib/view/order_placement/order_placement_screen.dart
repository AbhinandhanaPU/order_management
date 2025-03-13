import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_management/controllers/cart_controller.dart';
import 'package:order_management/models/product_model.dart';

class OrderPlacementScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  OrderPlacementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.deepPurple,
        title: Text(
          'OrderY',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      '₹${cartController.totalPrice}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Total Price',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              FilledButton(
                onPressed: () {
                  if (cartController.cartItems.isNotEmpty) {
                    Get.snackbar(
                      "Order Placed",
                      "Your order has been placed successfully!",
                    );
                    cartController.clearCart(); // Clear cart
                  } else {
                    Get.snackbar(
                      "Cart Empty",
                      "Add items before placing an order.",
                    );
                  }
                },
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Place Order',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
      body: Column(
        children: [
          // Cart Item List
          Expanded(
            child: Obx(() {
              if (cartController.cartItems.isEmpty) {
                return Center(child: Text("Your cart is empty"));
              }
              return ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final productEntry =
                      cartController.cartItems.entries.elementAt(index);
                  final ProductModel product = productEntry.key;

                  return Column(
                    children: [
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        isThreeLine: true,
                        leading: Container(
                          height: 150,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Image.asset(
                            product.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          product.name,
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${product.price}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text('Quantity:'),
                                IconButton(
                                  onPressed: () => cartController
                                      .updateQuantity(product, -1),
                                  icon: const Icon(
                                    Icons.remove,
                                    size: 20,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    '${cartController.getProductQuantity(product)}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      cartController.updateQuantity(product, 1),
                                  icon: const Icon(
                                    Icons.add,
                                    size: 20,
                                  ),
                                ),
                                Spacer(),
                                // Remove Item Button
                                TextButton.icon(
                                  onPressed: () =>
                                      cartController.removeFromCart(product),
                                  label: Text('Remove Item'),
                                  icon: Icon(Icons.close),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey.shade300,
                        width: double.infinity,
                        height: 5,
                      ),
                    ],
                  );
                },
              );
            }),
          ),
          // Price Summary Section
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Items',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${cartController.cartItems.length}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Product Price',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '₹${cartController.totalPrice}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Order Total',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '₹${cartController.totalPrice}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
