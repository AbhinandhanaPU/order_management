import 'dart:developer';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:order_management/models/product_model.dart';

class ProductController extends GetxController {
  // observable List to store all products
  var productList = <ProductModel>[].obs;

  // observable List to store filtered products (based on search, filter, and sorting)
  var filteredProducts = <ProductModel>[].obs;

  // Boolean to track loading state
  var isLoading = true.obs;

  @override
  void onInit() {
    loadProducts(); // Loading products when the controller is initialized
    super.onInit();
  }

  // Loads product data from JSON file inside assets/json/s
  Future<void> loadProducts() async {
    try {
      isLoading(true); // Start loading
      log("Loading products...");

      // Read the JSON file from assets
      final String response =
          await rootBundle.loadString('assets/json/products.json');

      // Convert JSON string to List<ProductModel>
      final List<ProductModel> loadedProducts =
          ProductModel.fromJsonList(response);

      // Assigning the fetched products to the observable lists
      productList.assignAll(loadedProducts);
      filteredProducts.assignAll(loadedProducts);

      log("Successfully loaded ${loadedProducts.length} products");
    } catch (e) {
      log("Error loading products: $e");
    } finally {
      isLoading(false); // Stop loading
    }
  }

  // Applies search, filter, and sorting on the product list
  void applyFilters({
    String searchQuery = '',
    String filter = 'All',
    String sort = 'None',
  }) {
    log("Applying filters: Search: $searchQuery, Filter: $filter, Sort: $sort");

    // Filter based on search query and selected filter
    List<ProductModel> tempList = productList.where((product) {
      bool matchesSearch =
          product.name.toLowerCase().contains(searchQuery.toLowerCase());

      bool matchesFilter = filter == 'All' ||
          (filter == 'Less than 1,000' && product.price < 1000) ||
          (filter == '1,000 - 3,000' &&
              product.price >= 1000 &&
              product.price <= 3000) ||
          (filter == 'More than 3,000' && product.price > 3000);

      return matchesSearch && matchesFilter;
    }).toList();

    // Apply sorting
    if (sort == 'Price: Low to High') {
      tempList.sort((a, b) => a.price.compareTo(b.price));
    } else if (sort == 'Price: High to Low') {
      tempList.sort((a, b) => b.price.compareTo(a.price));
    }

    // Update the filtered products list
    filteredProducts.assignAll(tempList);
    log("Filtered product count: ${filteredProducts.length}");
  }
}
