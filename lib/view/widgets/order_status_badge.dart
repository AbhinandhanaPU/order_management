import 'package:flutter/material.dart';

class OrderStatusBadge extends StatelessWidget {
  final String orderStatus;

  const OrderStatusBadge({
    super.key,
    required this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String badgeText;
    Color textColor;
    Color circleColor;

    // Handle Status Logic
    switch (orderStatus) {
      case 'Approved':
        badgeColor = Colors.blue.shade100;
        badgeText = 'Approved';
        textColor = Colors.blue;
        circleColor = Colors.blue;
        break;
      case 'Shipped':
        badgeColor = Colors.orange.shade100;
        badgeText = 'Shipped';
        textColor = Colors.orange;
        circleColor = Colors.orange;
        break;
      case 'Delivered':
        badgeColor = Colors.green.shade100;
        badgeText = 'Delivered';
        textColor = Colors.green;
        circleColor = Colors.green;
        break;
      default:
        badgeColor = Colors.grey.shade100;
        badgeText = 'Pending';
        textColor = Colors.black;
        circleColor = Colors.grey;
    }

    // Return the Badge Widget
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            badgeText,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
