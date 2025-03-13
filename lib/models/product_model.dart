import 'dart:convert';

class ProductModel {
  final String id;
  final String name;
  final int stock;
  final double price;
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
      price: (json['price'] as num).toDouble(),
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
