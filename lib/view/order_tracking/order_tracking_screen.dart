import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_management/controllers/cart_controller.dart';
import 'package:order_management/controllers/order_controller.dart';
import 'package:order_management/models/order_model.dart';
import 'package:order_management/view/order_placement/order_placement_screen.dart';
import 'package:order_management/view/widgets/order_status_badge.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderController orderController = Get.find<OrderController>();
  final CartController cartController = Get.find<CartController>();

  final RxSet<int> expandedOrders = <int>{}.obs;

  OrderTrackingScreen({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Orders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: Obx(
                () {
                  if (orderController.orderHistory.isEmpty) {
                    return Center(child: Text("No orders found"));
                  }

                  return ListView.separated(
                    itemCount: orderController.orderHistory.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      Order order = orderController.orderHistory[index].order;

                      return Obx(
                        () {
                          bool isExpanded = expandedOrders.contains(index);

                          return GestureDetector(
                            onTap: () {
                              if (isExpanded) {
                                expandedOrders.remove(index); // Collapse card
                              } else {
                                expandedOrders.add(index); // Expand card
                              }
                            },
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Order Header+
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Order #${index + 1}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        OrderStatusBadge(
                                            orderStatus: order.orderStatus),
                                      ],
                                    ),

                                    // Expand Items List When Tapped
                                    if (isExpanded) ...[
                                      Divider(),
                                      Column(
                                        children: order.items.map((orderItem) {
                                          return ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              child: Image.asset(
                                                orderItem.product.image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            title: Text(
                                              orderItem.product.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Qty: ${orderItem.quantity}',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            trailing: Text(
                                              '₹${(orderItem.product.price * orderItem.quantity).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],

                                    Divider(),
                                    // Order Summary
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          spacing: 10,
                                          children: [
                                            Text(
                                              "Total Items:",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              order.items.length.toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          spacing: 10,
                                          children: [
                                            Text(
                                              "Total:",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "₹${order.total.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
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
