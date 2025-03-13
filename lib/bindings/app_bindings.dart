import 'package:get/get.dart';
import 'package:order_management/controllers/product_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductController()); // Injects ProductController
  }
}
