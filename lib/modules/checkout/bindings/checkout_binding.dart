import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';

/// checkout page bindings setup
class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(() => CheckoutController());
  }
}
