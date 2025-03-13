import 'package:flutter/material.dart';

class ProductListItem extends StatelessWidget {
  final String productImage;
  final String productName;
  final int productPrice;
  final VoidCallback addToCart;

  const ProductListItem({
    super.key,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.addToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(productImage),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            productName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹$productPrice',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FilledButton.icon(
                onPressed: addToCart,
                label: Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 15),
                ),
                icon: Icon(Icons.add_shopping_cart_sharp),
              )
            ],
          ),
        ],
      ),
    );
  }
}
