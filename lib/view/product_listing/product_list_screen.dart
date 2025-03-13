import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_management/controllers/product_controller.dart';
import 'package:order_management/view/order_placement/order_placement_screen.dart';
import 'package:order_management/view/widgets/product_listitem.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  final ProductController productController = Get.find<ProductController>();
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _selectedSort = 'None';

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
              Get.to(OrderPlacementScreen());
            },
            icon: Icon(
              Icons.shopping_cart_checkout,
              size: 30,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Product',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => productController.applyFilters(
                searchQuery: value,
                filter: _selectedFilter,
                sort: _selectedSort,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                // Filter Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedFilter,
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
                    onChanged: (value) {
                      setState(() => _selectedFilter = value!);
                      productController.applyFilters(
                        searchQuery: _searchController.text,
                        filter: _selectedFilter,
                        sort: _selectedSort,
                      );
                    },
                  ),
                ),

                SizedBox(width: 10),

                // Sorting Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSort,
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
                    onChanged: (value) {
                      setState(() => _selectedSort = value!);
                      productController.applyFilters(
                        searchQuery: _searchController.text,
                        filter: _selectedFilter,
                        sort: _selectedSort,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Product List
          Expanded(
            child: Obx(() {
              if (productController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (productController.filteredProducts.isEmpty) {
                return Center(child: Text("No products available"));
              }
              return ListView.builder(
                itemCount: productController.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = productController.filteredProducts[index];
                  return ProductListItem(
                    product: product,
                    addToCart: () {},
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
