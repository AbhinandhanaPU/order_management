import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_management/controllers/cart_controller.dart';
import 'package:order_management/view/order_placement/order_placement_screen.dart';
import 'package:order_management/view/widgets/order_status_badge.dart';

class OrderTrackingScreen extends StatelessWidget {
  OrderTrackingScreen({super.key});
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OrderY',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Get.to(() => OrderPlacementScreen()); // Navigate to cart
                },
                icon: Icon(
                  Icons.shopping_cart_checkout,
                  size: 30,
                  color: Colors.deepPurple,
                ),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: Obx(() {
                  if (cartController.itemCount > 0) {
                    return CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartController.itemCount.toString(),
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
              ),
            ],
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Orders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: 3,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return ListTile(
                    shape: Border.all(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      // vertical: 12,
                    ),
                    leading: Container(
                      height: 150,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Image.asset(
                        'assets/images/backpack.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      'product.name',
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
                          'Qty: 2',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    trailing: OrderStatusBadge(orderStatus: 'Delivered'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
