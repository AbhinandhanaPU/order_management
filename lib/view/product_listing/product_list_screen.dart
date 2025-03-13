import 'package:flutter/material.dart';
import 'package:order_management/view/order_placement/order_placement_screen.dart';
import 'package:order_management/view/widgets/product_listitem.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

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
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderPlacementScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart_checkout,
              size: 30,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(width: 20)
        ],
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: TextEditingController(),
              decoration: InputDecoration(
                labelText: 'Search Product',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                // Filter Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: 'All',
                    isExpanded: true,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    items: [
                      'All',
                      'Less than 1,000',
                      '1,000 - 3,000',
                      'More than 3,000',
                    ].map((filter) {
                      return DropdownMenuItem(
                        value: filter,
                        child: Text(filter),
                      );
                    }).toList(),
                    onChanged: (value) {},
                  ),
                ),

                SizedBox(width: 10),

                // Sorting Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: 'None',
                    isExpanded: true,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    items: [
                      'None',
                      'Price: Low to High',
                      'Price: High to Low',
                    ].map((sortOption) {
                      return DropdownMenuItem(
                        value: sortOption,
                        child: Text(sortOption),
                      );
                    }).toList(),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ),

          // Product List
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ProductListItem(
                  productImage: 'assets/images/backpack.jpg',
                  productName: 'productName',
                  productPrice: 2000,
                  addToCart: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
