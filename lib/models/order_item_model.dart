import 'package:hive/hive.dart';

import 'product_model.dart';

part 'order_item_model.g.dart';

@HiveType(typeId: 1)
class OrderItem extends HiveObject {
  @HiveField(0)
  final ProductModel product;

  @HiveField(1)
  final int quantity;

  OrderItem({
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}
