import 'dart:convert';

import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int stock;

  @HiveField(3)
  final int price;

  @HiveField(4)
  final String image;

  ProductModel({
    required this.id,
    required this.name,
    required this.stock,
    required this.price,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      stock: json['stock'],
      price: (json['price'] as num).toInt(),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'stock': stock,
      'price': price,
      'image': image,
    };
  }

  static List<ProductModel> fromJsonList(String jsonString) {
    final List<dynamic> data = json.decode(jsonString);
    return data.map((item) => ProductModel.fromJson(item)).toList();
  }
}
