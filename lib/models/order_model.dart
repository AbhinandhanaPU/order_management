import 'package:hive/hive.dart';

import 'order_item_model.dart';

part 'order_model.g.dart';

@HiveType(typeId: 2)
class Order extends HiveObject {
  @HiveField(0)
  final List<OrderItem> items;

  @HiveField(1)
  final double total;

  Order({required this.items, required this.total});

  Map<String, dynamic> toJson() => {
        'items': items.map((item) => item.toJson()).toList(),
        'total': total,
      };

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      total: json['total'],
    );
  }
}
