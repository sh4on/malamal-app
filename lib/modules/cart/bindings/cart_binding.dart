import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

/// cart page bindings registration
class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController());
  }
}
