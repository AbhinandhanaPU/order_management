import 'package:hive/hive.dart';

import 'order_model.dart';

part 'order_draft_model.g.dart';

@HiveType(typeId: 3)
class OrderDraft extends HiveObject {
  @HiveField(0)
  final Order order;

  @HiveField(1)
  final DateTime createdAt;

  OrderDraft({required this.order, required this.createdAt});

  Map<String, dynamic> toJson() => {
        'order': order.toJson(),
        'created_at': createdAt.toIso8601String(),
      };

  factory OrderDraft.fromJson(Map<String, dynamic> json) {
    return OrderDraft(
      order: Order.fromJson(json['order']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
